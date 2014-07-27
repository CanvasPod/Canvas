//
//  URBMediaFocusViewController.m
//  URBMediaFocusViewControllerDemo
//
//  Created by Nicholas Shipes on 11/3/13.
//  Copyright (c) 2013 Urban10 Interactive. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "URBMediaFocusViewController.h"

static const CGFloat __overlayAlpha = 0.6f;						// opacity of the black overlay displayed below the focused image
static const CGFloat __animationDuration = 0.18f;				// the base duration for present/dismiss animations (except physics-related ones)
static const CGFloat __maximumDismissDelay = 0.5f;				// maximum time of delay (in seconds) between when image view is push out and dismissal animations begin
static const CGFloat __resistance = 0.0f;						// linear resistance applied to the image’s dynamic item behavior
static const CGFloat __density = 1.0f;							// relative mass density applied to the image's dynamic item behavior
static const CGFloat __velocityFactor = 1.0f;					// affects how quickly the view is pushed out of the view
static const CGFloat __angularVelocityFactor = 1.0f;			// adjusts the amount of spin applied to the view during a push force, increases towards the view bounds
static const CGFloat __minimumVelocityRequiredForPush = 50.0f;	// defines how much velocity is required for the push behavior to be applied

/* parallax options */
static const CGFloat __backgroundScale = 0.9f;					// defines how much the background view should be scaled
static const CGFloat __blurRadius = 2.0f;						// defines how much the background view is blurred
static const CGFloat __blurSaturationDeltaMask = 0.8f;
static const CGFloat __blurTintColorAlpha = 0.2f;				// defines how much to tint the background view

@interface UIView (URBMediaFocusViewController)
- (UIImage *)urb_snapshotImageWithScale:(CGFloat)scale;
@end

/**
 Pulled from Apple's UIImage+ImageEffects category, but renamed to avoid potential selector name conflicts.
 */
@interface UIImage (URBImageEffects)
- (UIImage *)urb_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end

@interface URBMediaFocusViewController () <UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, weak) UIViewController *targetViewController;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@property (nonatomic, readonly) UIWindow *keyWindow;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *photoTapRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *photoLongPressRecognizer;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *urlData;

@property (nonatomic, strong) UIView *blurredSnapshotView;
@property (nonatomic, strong) UIView *snapshotView;

@end

@implementation URBMediaFocusViewController {
	CGRect _originalFrame;
	CGFloat _minScale;
	CGFloat _maxScale;
	CGFloat _lastPinchScale;
	CGFloat _lastZoomScale;
	UIInterfaceOrientation _currentOrientation;
	BOOL _hasLaidOut;
	BOOL _unhideStatusBarOnDismiss;
}

- (id)init {
	self = [super init];
	if (self) {
		_hasLaidOut = NO;
		_unhideStatusBarOnDismiss = YES;
		
		self.shouldBlurBackground = YES;
		self.parallaxEnabled = YES;
		self.shouldDismissOnTap = YES;
		self.shouldDismissOnImageTap = NO;
		self.shouldShowPhotoActions = NO;
		self.shouldRotateToDeviceOrientation = YES;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setup];
}

- (void)setup {
	self.view.frame = self.keyWindow.bounds;
	
	self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.keyWindow.frame), CGRectGetHeight(self.keyWindow.frame))];
	self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:__overlayAlpha];
	self.backgroundView.alpha = 0.0f;
	self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:self.backgroundView];
	
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView.delegate = self;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollEnabled = NO;
	[self.view addSubview:self.scrollView];
	
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50.0, 50.0)];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.alpha = 0.0f;
	self.imageView.userInteractionEnabled = YES;
	// Enable edge antialiasing on 7.0 or later.
	// This symbol appears pre-7.0 but is not considered public API until 7.0
	if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)) {
		self.imageView.layer.allowsEdgeAntialiasing = YES;
	}
	[self.scrollView addSubview:self.imageView];
	
	/* setup gesture recognizers */
	// double tap gesture to return scaled image back to center for easier dismissal
	self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
	self.doubleTapRecognizer.delegate = self;
	self.doubleTapRecognizer.numberOfTapsRequired = 2;
	self.doubleTapRecognizer.numberOfTouchesRequired = 1;
	[self.imageView addGestureRecognizer:self.doubleTapRecognizer];
	
	// tap recognizer on area outside image view for dismissing
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissFromTap:)];
	self.tapRecognizer.delegate = self;
	self.tapRecognizer.numberOfTapsRequired = 1;
	self.tapRecognizer.numberOfTouchesRequired = 1;
	[self.tapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
	[self.view addGestureRecognizer:self.tapRecognizer];
	
	// long press gesture recognizer to bring up photo actions (when `shouldShowPhotoActions` is set to YES)
	if (self.shouldShowPhotoActions) {
		self.photoLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
		self.photoLongPressRecognizer.delegate = self;
		[self.imageView addGestureRecognizer:self.photoLongPressRecognizer];
	}
	
	// only add pan gesture and physics stuff if we can (e.g., iOS 7+)
	if (NSClassFromString(@"UIDynamicAnimator")) {
		// pan gesture to handle the physics
		self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		self.panRecognizer.delegate = self;
		[self.imageView addGestureRecognizer:self.panRecognizer];
		
		/* UIDynamics stuff */
		self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
		self.animator.delegate = self;
		
		// snap behavior to keep image view in the center as needed
		self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
		self.snapBehavior.damping = 1.0f;
		
		self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.imageView] mode:UIPushBehaviorModeInstantaneous];
		self.pushBehavior.angle = 0.0f;
		self.pushBehavior.magnitude = 0.0f;
		
		self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageView]];
		self.itemBehavior.elasticity = 0.0f;
		self.itemBehavior.friction = 0.2f;
		self.itemBehavior.allowsRotation = YES;
		self.itemBehavior.density = __density;
		self.itemBehavior.resistance = __resistance;
	}
	else {
		// add tap gesture to image to also dismiss since we don't have UIDynamics to flick out of view
		self.photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissFromTap:)];
		self.photoTapRecognizer.delegate = self;
		self.photoTapRecognizer.numberOfTapsRequired = 1;
		self.photoTapRecognizer.numberOfTouchesRequired = 1;
		[self.photoTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
		[self.imageView addGestureRecognizer:self.photoTapRecognizer];
	}
}

- (void)cancelURLConnectionIfAny {
    if (self.loadingView) {
        [self.loadingView stopAnimating];
        if (self.loadingView.superview) [self.loadingView removeFromSuperview];
    }
    if (self.urlConnection) [self.urlConnection cancel];
};

#pragma mark - Presenting and Dismissing

- (void)showImage:(UIImage *)image fromView:(UIView *)fromView {
	[self showImage:image fromView:fromView inViewController:nil];
}

- (void)showImage:(UIImage *)image fromView:(UIView *)fromView inViewController:(UIViewController *)parentViewController {
	self.fromView = fromView;
	//self.targetViewController = parentViewController;
	UIView *superview = (parentViewController) ? parentViewController.view : fromView.superview;
	CGRect fromRect = [superview convertRect:fromView.frame toView:nil];
	
	[self showImage:image fromRect:fromRect];
}

- (void)showImage:(UIImage *)image fromRect:(CGRect)fromRect {
	NSAssert(image, @"Image is required");

	[self view]; // make sure view has loaded first
	_currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
	//fromRect = CGRectApplyAffineTransform(fromRect, [self transformForOrientation:_currentOrientation]);
	self.fromRect = fromRect;
	
	self.imageView.transform = CGAffineTransformIdentity;
	self.imageView.image = image;
	self.imageView.alpha = 0.2;
	
	// create snapshot of background if parallax is enabled
	if (self.parallaxEnabled || self.shouldBlurBackground) {
		[self createViewsForBackground];
		
		// hide status bar, but store whether or not we need to unhide it later when dismissing this view
		// NOTE: in iOS 7+, this only works if you set `UIViewControllerBasedStatusBarAppearance` to YES in your Info.plist
		_unhideStatusBarOnDismiss = ![UIApplication sharedApplication].statusBarHidden;
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
		
		if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
			[self setNeedsStatusBarAppearanceUpdate];
		}
	}
	
	// update scrollView.contentSize to the size of the image
	self.scrollView.contentSize = image.size;
	CGFloat scaleWidth = CGRectGetWidth(self.scrollView.frame) / self.scrollView.contentSize.width;
	CGFloat scaleHeight = CGRectGetHeight(self.scrollView.frame) / self.scrollView.contentSize.height;
	CGFloat scale = MIN(scaleWidth, scaleHeight);
	
	// image view's destination frame is the size of the image capped to the width/height of the target view
	CGPoint midpoint = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	CGSize scaledImageSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
	CGRect targetRect = CGRectMake(midpoint.x - scaledImageSize.width / 2.0, midpoint.y - scaledImageSize.height / 2.0, scaledImageSize.width, scaledImageSize.height);
	
	// set initial frame of image view to match that of the presenting image
	self.imageView.frame = [self.view convertRect:fromRect fromView:nil];
	_originalFrame = targetRect;
	
	// rotate imageView based on current device orientation
	[self reposition];
    
	if (scale < 1.0f) {
		self.scrollView.minimumZoomScale = 1.0f;
		self.scrollView.maximumZoomScale = 1.0f / scale;
	}
	else {
		self.scrollView.minimumZoomScale = 1.0f / scale;
		self.scrollView.maximumZoomScale = 1.0f;
	}
	
	_minScale = self.scrollView.minimumZoomScale;
	_maxScale = self.scrollView.maximumZoomScale;
	_lastPinchScale = 1.0f;
	_hasLaidOut = YES;
	
	// register for device orientation changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	// register with the device that we want to know when the device orientation changes
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	if (self.targetViewController) {
		[self willMoveToParentViewController:self.targetViewController];
		if ([UIView instancesRespondToSelector:@selector(setTintAdjustmentMode:)]) {
			self.targetViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			[self.targetViewController.view tintColorDidChange];
		}
		[self.targetViewController addChildViewController:self];
		[self.targetViewController.view addSubview:self.view];
		
		if (self.snapshotView) {
			[self.targetViewController.view insertSubview:self.snapshotView belowSubview:self.view];
			[self.targetViewController.view insertSubview:self.blurredSnapshotView aboveSubview:self.snapshotView];
		}
	}
	else {
		// add this view to the main window if no targetViewController was set
		if ([UIView instancesRespondToSelector:@selector(setTintAdjustmentMode:)]) {
			self.keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			[self.keyWindow tintColorDidChange];
		}
		[self.keyWindow addSubview:self.view];
		
		if (self.snapshotView) {
			[self.keyWindow insertSubview:self.snapshotView belowSubview:self.view];
			[self.keyWindow insertSubview:self.blurredSnapshotView aboveSubview:self.snapshotView];
		}
	}
	
	[UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.backgroundView.alpha = 1.0f;
		self.imageView.alpha = 1.0f;
		self.imageView.frame = targetRect;
		
		if (self.snapshotView) {
			self.blurredSnapshotView.alpha = 1.0f;
			if (self.parallaxEnabled) {
				self.blurredSnapshotView.transform = CGAffineTransformScale(CGAffineTransformIdentity, __backgroundScale, __backgroundScale);
				self.snapshotView.transform = CGAffineTransformScale(CGAffineTransformIdentity, __backgroundScale, __backgroundScale);
			}
		}
		
	} completion:^(BOOL finished) {
		//[self.imageView addGestureRecognizer:self.pinchRecognizer];
		if (self.targetViewController) {
			[self didMoveToParentViewController:self.targetViewController];
		}
		
		if ([self.delegate respondsToSelector:@selector(mediaFocusViewControllerDidAppear:)]) {
			[self.delegate mediaFocusViewControllerDidAppear:self];
		}
	}];
}

- (void)showImageFromURL:(NSURL *)url fromView:(UIView *)fromView {
	[self showImageFromURL:url fromView:fromView inViewController:nil];
}

- (void)showImageFromURL:(NSURL *)url fromView:(UIView *)fromView inViewController:(UIViewController *)parentViewController {
	self.fromView = fromView;
	self.targetViewController = parentViewController;
	
	UIView *superview = (parentViewController) ? parentViewController.view : fromView.superview;
	CGRect fromRect = [superview convertRect:fromView.frame toView:nil];
	
	[self showImageFromURL:url fromRect:fromRect];
}

- (void)showImageFromURL:(NSURL *)url fromRect:(CGRect)fromRect {
	self.fromRect = fromRect;
	
	// cancel any outstanding requests if we have one
	[self cancelURLConnectionIfAny];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	if (self.requestHTTPHeaders.count > 0) {
		for (NSString *key in self.requestHTTPHeaders) {
			NSString *value = [self.requestHTTPHeaders valueForKey:key];
			[request setValue:value forHTTPHeaderField:key];
		}
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.urlConnection = connection;
	
	// stores data as it's loaded from the request
	self.urlData = [[NSMutableData alloc] init];
	
	// show loading indicator on fromView
	if (!self.loadingView) {
		self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
	}
	if (self.fromView) {
		[self.fromView addSubview:self.loadingView];
		self.loadingView.center = CGPointMake(CGRectGetWidth(self.fromView.frame) / 2.0, CGRectGetHeight(self.fromView.frame) / 2.0);
	}
	
	[self.loadingView startAnimating];
	[self.urlConnection start];
}

- (void)dismiss:(BOOL)animated {
	if (animated) {
		[self dismissToTargetView];
	}
	else {
		self.backgroundView.alpha = 0.0f;
		self.imageView.alpha = 0.0f;
		[self cleanup];
	}
}

- (void)dismissAfterPush {
	[self hideSnapshotView];
	[UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.backgroundView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self cleanup];
	}];
}

- (void)dismissToTargetView {
	[self hideSnapshotView];
	
	if (self.scrollView.zoomScale != 1.0f) {
		[self.scrollView setZoomScale:1.0f animated:NO];
	}
	
	CGRect targetFrame = [self.view convertRect:self.fromView.frame fromView:nil];
	if (!CGRectIsEmpty(self.fromRect)) {
		targetFrame = self.fromRect;
	}
	
	[UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.frame = targetFrame;
		if (!CGRectIsEmpty(self.fromRect)) {
			self.imageView.frame = self.fromRect;
		}
		else {
			self.imageView.frame = [self.view convertRect:self.fromView.frame fromView:nil];
		}
		//self.imageView.alpha = 0.0f;
		self.backgroundView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self cleanup];
	}];
	// offset image fade out slightly than background/frame animation
	[UIView animateWithDuration:__animationDuration - 0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.alpha = 0.0f;
	} completion:nil];
}

#pragma mark - Private Methods

- (UIWindow *)keyWindow {
	return [UIApplication sharedApplication].keyWindow;
}

- (void)createViewsForBackground {
	// container view for window
	CGRect containerFrame = CGRectMake(0, 0, CGRectGetWidth(self.keyWindow.frame), CGRectGetHeight(self.keyWindow.frame));
	
	// inset container view so we can blur the edges, but we also need to scale up so when __backgroundScale is applied, everything lines up
	// only perform inset if `parallaxEnabled` is YES
	if (self.parallaxEnabled) {
		containerFrame.size.width *= 1.0f / __backgroundScale;
		containerFrame.size.height *= 1.0f / __backgroundScale;
	}
	
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectIntegral(containerFrame)];
	containerView.backgroundColor = [UIColor blackColor];
	
	// add snapshot of window to the container
	UIImage *windowSnapshot = [self.keyWindow urb_snapshotImageWithScale:[UIScreen mainScreen].scale];
	UIImageView *windowSnapshotView = [[UIImageView alloc] initWithImage:windowSnapshot];
	windowSnapshotView.center = containerView.center;
	[containerView addSubview:windowSnapshotView];
	containerView.center = self.keyWindow.center;
	
	UIImageView *snapshotView;
	// only add blurred view if radius is above 0
	if (self.shouldBlurBackground && __blurRadius) {
		UIImage *snapshot = [containerView urb_snapshotImageWithScale:[UIScreen mainScreen].scale];
		snapshot = [snapshot urb_applyBlurWithRadius:__blurRadius
										   tintColor:[UIColor colorWithWhite:0.0f alpha:__blurTintColorAlpha]
							   saturationDeltaFactor:__blurSaturationDeltaMask
										   maskImage:nil];
		snapshotView = [[UIImageView alloc] initWithImage:snapshot];
		snapshotView.center = containerView.center;
		snapshotView.alpha = 0.0f;
		snapshotView.userInteractionEnabled = NO;
	}
	
	self.snapshotView = containerView;
	self.blurredSnapshotView = snapshotView;
}

- (void)adjustFrame {
	CGRect imageFrame = self.imageView.frame;
	
	// snap x sides
	if (CGRectGetWidth(imageFrame) > CGRectGetWidth(self.view.frame)) {
		if (CGRectGetMinX(imageFrame) > 0) {
			imageFrame.origin.x = 0;
		}
		else if (CGRectGetMaxX(imageFrame) < CGRectGetWidth(self.view.frame)) {
			imageFrame.origin.x = CGRectGetWidth(self.view.frame) - CGRectGetWidth(imageFrame);
		}
	}
	else if (self.imageView.center.x != CGRectGetMidX(self.view.frame)) {
		imageFrame.origin.x = CGRectGetMidX(self.view.frame) - CGRectGetWidth(imageFrame) / 2.0f;
	}
	
	// snap y sides
	if (CGRectGetHeight(imageFrame) > CGRectGetHeight(self.view.frame)) {
		if (CGRectGetMinY(imageFrame) > 0) {
			imageFrame.origin.y = 0;
		}
		else if (CGRectGetMaxY(imageFrame) < CGRectGetHeight(self.view.frame)) {
			imageFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(imageFrame);
		}
	}
	else if (self.imageView.center.y != CGRectGetMidY(self.view.frame)) {
		imageFrame.origin.y = CGRectGetMidY(self.view.frame) - CGRectGetHeight(imageFrame) / 2.0f;
	}
	
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.frame = imageFrame;
	} completion:^(BOOL finished) {
		
	}];
}

/**
 *	When adding UIDynamics to a view, it resets `zoomScale` on UIScrollView back to 1.0, which is an issue when applying dynamics
 *	to the imageView when scaled down. So we just scale the imageView.frame while dynamics are applied.
 */
- (void)scaleImageForDynamics {
	_lastZoomScale = self.scrollView.zoomScale;
	
	CGRect imageFrame = self.imageView.frame;
	imageFrame.size.width *= _lastZoomScale;
	imageFrame.size.height *= _lastZoomScale;
	self.imageView.frame = imageFrame;
}

- (void)centerScrollViewContents {
	CGSize contentSize = self.scrollView.contentSize;
	CGFloat offsetX = (CGRectGetWidth(self.scrollView.frame) > contentSize.width) ? (CGRectGetWidth(self.scrollView.frame) - contentSize.width) / 2.0f : 0.0f;
	CGFloat offsetY = (CGRectGetHeight(self.scrollView.frame) > contentSize.height) ? (CGRectGetHeight(self.scrollView.frame) - contentSize.height) / 2.0f : 0.0f;
	self.imageView.center = CGPointMake(self.scrollView.contentSize.width / 2.0f + offsetX, self.scrollView.contentSize.height / 2.0f + offsetY);
}

- (void)returnToCenter {
	if (self.animator) {
		[self.animator removeAllBehaviors];
	}
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.transform = CGAffineTransformIdentity;
		self.imageView.frame = _originalFrame;
	} completion:nil];
}

- (void)hideSnapshotView {
	// only unhide status bar if it wasn't hidden before this view appeared
	if (_unhideStatusBarOnDismiss) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	}
	
	[UIView animateWithDuration:__animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.blurredSnapshotView.alpha = 0.0f;
		self.blurredSnapshotView.transform = CGAffineTransformIdentity;
		self.snapshotView.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished) {
		[self.snapshotView removeFromSuperview];
		[self.blurredSnapshotView removeFromSuperview];
		self.snapshotView = nil;
		self.blurredSnapshotView = nil;
	}];
}

- (void)cleanup {
	_hasLaidOut = NO;
	[self.view removeFromSuperview];
	
	if (self.targetViewController) {
		if ([UIView instancesRespondToSelector:@selector(setTintAdjustmentMode:)]) {
			self.targetViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
			[self.targetViewController.view tintColorDidChange];
		}
		[self willMoveToParentViewController:nil];
		[self removeFromParentViewController];
	}
	else {
		if ([UIWindow instancesRespondToSelector:@selector(setTintAdjustmentMode:)]) {
			self.keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
			[self.keyWindow tintColorDidChange];
		}
	}
	
	if (self.animator) {
		[self.animator removeAllBehaviors];
	}
	
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if ([self.delegate respondsToSelector:@selector(mediaFocusViewControllerDidDisappear:)]) {
		[self.delegate mediaFocusViewControllerDidDisappear:self];
	}
	
	if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
		[self setNeedsStatusBarAppearanceUpdate];
	}
}

- (void)saveImageToLibrary:(UIImage *)image {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription
																message:error.localizedRecoverySuggestion
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"OK", nil)
													  otherButtonTitles:nil];
			[alertView show];
		}
	}];
}

- (void)copyImage:(UIImage *)image {
	[UIPasteboard generalPasteboard].image = image;
}

#pragma mark - Gesture Methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
	UIView *view = gestureRecognizer.view;
	CGPoint location = [gestureRecognizer locationInView:self.view];
	CGPoint boxLocation = [gestureRecognizer locationInView:self.imageView];
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[self.animator removeBehavior:self.snapBehavior];
		[self.animator removeBehavior:self.pushBehavior];
		
		UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.imageView.bounds), boxLocation.y - CGRectGetMidY(self.imageView.bounds));
		self.panAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView offsetFromCenter:centerOffset attachedToAnchor:location];
		//self.panAttachmentBehavior.frequency = 0.0f;
		[self.animator addBehavior:self.panAttachmentBehavior];
		[self.animator addBehavior:self.itemBehavior];
		[self scaleImageForDynamics];
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		self.panAttachmentBehavior.anchorPoint = location;
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[self.animator removeBehavior:self.panAttachmentBehavior];
		
		// need to scale velocity values to tame down physics on the iPad
		CGFloat deviceVelocityScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.2f : 1.0f;
		CGFloat deviceAngularScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.7f : 1.0f;
		// factor to increase delay before `dismissAfterPush` is called on iPad to account for more area to cover to disappear
		CGFloat deviceDismissDelay = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.8f : 1.0f;
		CGPoint velocity = [gestureRecognizer velocityInView:self.view];
		CGFloat velocityAdjust = 10.0f * deviceVelocityScale;
		
		if (fabs(velocity.x / velocityAdjust) > __minimumVelocityRequiredForPush || fabs(velocity.y / velocityAdjust) > __minimumVelocityRequiredForPush) {
			UIOffset offsetFromCenter = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.imageView.bounds), boxLocation.y - CGRectGetMidY(self.imageView.bounds));
			CGFloat radius = sqrtf(powf(offsetFromCenter.horizontal, 2.0f) + powf(offsetFromCenter.vertical, 2.0f));
			CGFloat pushVelocity = sqrtf(powf(velocity.x, 2.0f) + powf(velocity.y, 2.0f));
			
			// calculate angles needed for angular velocity formula
			CGFloat velocityAngle = atan2f(velocity.y, velocity.x);
			CGFloat locationAngle = atan2f(offsetFromCenter.vertical, offsetFromCenter.horizontal);
			if (locationAngle > 0) {
				locationAngle -= M_PI * 2;
			}
			
			// angle (θ) is the angle between the push vector (V) and vector component parallel to radius, so it should always be positive
			CGFloat angle = fabsf(fabsf(velocityAngle) - fabsf(locationAngle));
			// angular velocity formula: w = (abs(V) * sin(θ)) / abs(r)
			CGFloat angularVelocity = fabsf((fabsf(pushVelocity) * sinf(angle)) / fabsf(radius));
			
			// rotation direction is dependent upon which corner was pushed relative to the center of the view
			// when velocity.y is positive, pushes to the right of center rotate clockwise, left is counterclockwise
			CGFloat direction = (location.x < view.center.x) ? -1.0f : 1.0f;
			// when y component of velocity is negative, reverse direction
			if (velocity.y < 0) { direction *= -1; }
			
			// amount of angular velocity should be relative to how close to the edge of the view the force originated
			// angular velocity is reduced the closer to the center the force is applied
			// for angular velocity: positive = clockwise, negative = counterclockwise
			CGFloat xRatioFromCenter = fabsf(offsetFromCenter.horizontal) / (CGRectGetWidth(self.imageView.frame) / 2.0f);
			CGFloat yRatioFromCetner = fabsf(offsetFromCenter.vertical) / (CGRectGetHeight(self.imageView.frame) / 2.0f);

			// apply device scale to angular velocity
			angularVelocity *= deviceAngularScale;
			// adjust angular velocity based on distance from center, force applied farther towards the edges gets more spin
			angularVelocity *= ((xRatioFromCenter + yRatioFromCetner) / 2.0f);
			
			[self.itemBehavior addAngularVelocity:angularVelocity * __angularVelocityFactor * direction forItem:self.imageView];
			[self.animator addBehavior:self.pushBehavior];
			self.pushBehavior.pushDirection = CGVectorMake((velocity.x / velocityAdjust) * __velocityFactor, (velocity.y / velocityAdjust) * __velocityFactor);
			self.pushBehavior.active = YES;
			
			// delay for dismissing is based on push velocity also
			CGFloat delay = __maximumDismissDelay - (pushVelocity / 10000.0f);
			[self performSelector:@selector(dismissAfterPush) withObject:nil afterDelay:(delay * deviceDismissDelay) * __velocityFactor];
		}
		else {
			[self returnToCenter];
		}
	}
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
	if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
	}
	else {
		CGPoint tapPoint = [self.imageView convertPoint:[gestureRecognizer locationInView:gestureRecognizer.view] fromView:self.scrollView];
		CGFloat newZoomScale = self.scrollView.maximumZoomScale;
				
		CGFloat w = CGRectGetWidth(self.imageView.frame) / newZoomScale;
		CGFloat h = CGRectGetHeight(self.imageView.frame) / newZoomScale;
		CGRect zoomRect = CGRectMake(tapPoint.x - (w / 2.0f), tapPoint.y - (h / 2.0f), w, h);
		
		[self.scrollView zoomToRect:zoomRect animated:YES];
	}
}

- (void)handleDismissFromTap:(UITapGestureRecognizer *)gestureRecognizer {
	CGPoint location = [gestureRecognizer locationInView:self.view];
	
	// if we are allowing a tap anywhere to dismiss, check if we allow taps within image bounds to dismiss also
	// otherwise a tap outside image bounds will only be able to dismiss
	if (self.shouldDismissOnTap) {
		if (self.shouldDismissOnImageTap || !CGRectContainsPoint(self.imageView.frame, location)) {
			[self dismissToTargetView];
            return;
		}
	}
	
	if (self.shouldDismissOnImageTap && CGRectContainsPoint(self.imageView.frame, location)) {
		// we aren't allowing taps outside of image bounds to dismiss, but tap was detected on image view, we can dismiss
		[self dismissToTargetView];
        return;
	}
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
																 delegate:self
														cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												   destructiveButtonTitle:nil
														otherButtonTitles:NSLocalizedString(@"Save Photo", nil), NSLocalizedString(@"Copy Photo", nil), nil];
		[actionSheet showInView:self.view];
	}
}

#pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	// zoomScale of 1.0 is always our starting point, so anything other than that we disable the pan gesture recognizer
	if (scrollView.zoomScale <= 1.0f && !scrollView.zooming) {
		if (self.panRecognizer) {
			[self.imageView addGestureRecognizer:self.panRecognizer];
		}
		scrollView.scrollEnabled = NO;
	}
	else {
		if (self.panRecognizer) {
			[self.imageView removeGestureRecognizer:self.panRecognizer];
		}
		scrollView.scrollEnabled = YES;
	}
	[self centerScrollViewContents];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self saveImageToLibrary:self.imageView.image];
	}
	else if (buttonIndex == 1) {
		[self copyImage:self.imageView.image];
	}
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	CGFloat transformScale = self.imageView.transform.a;
	BOOL shouldRecognize = transformScale > _minScale;
	
	// make sure tap and double tap gestures aren't recognized simultaneously
	shouldRecognize = shouldRecognize && !([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]);
	
	return shouldRecognize;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.loadingView stopAnimating];
	[self.loadingView removeFromSuperview];
	
	if (self.urlData) {
		NSString *urlPath = connection.currentRequest.URL.absoluteString;
		UIImage *image;
		
		// determine if the loaded url is an animated GIF, and setup accordingly if so
		if ([[urlPath substringFromIndex:[urlPath length] - 3] isEqualToString:@"gif"]) {
			self.imageView.image = [UIImage imageWithData:self.urlData];
			image = [UIImage urb_animatedImageWithAnimatedGIFData:self.urlData];
		}
		else {
			image = [UIImage imageWithData:self.urlData];
		}
		
		// sometimes the server can return bad or corrupt image data which will result in a crash if we don't throw an error here
		if (!image) {
			NSString *errorDescription = [NSString stringWithFormat:@"Bad or corrupt image data for %@", urlPath];
			NSError *error = [NSError errorWithDomain:@"com.urban10.URBMediaFocusViewController" code:100 userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
			if ([self.delegate respondsToSelector:@selector(mediaFocusViewController:didFailLoadingImageWithError:)]) {
				[self.delegate mediaFocusViewController:self didFailLoadingImageWithError:error];
			}
			return;
		}
		
		[self showImage:image fromRect:self.fromRect];
		
		if ([self.delegate respondsToSelector:@selector(mediaFocusViewController:didFinishLoadingImage:)]) {
			[self.delegate mediaFocusViewController:self didFinishLoadingImage:image];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([self.delegate respondsToSelector:@selector(mediaFocusViewController:didFailLoadingImageWithError:)]) {
		[self.delegate mediaFocusViewController:self didFailLoadingImageWithError:error];
	}
}

#pragma mark - Orientation Helpers

- (void)deviceOrientationChanged:(NSNotification *)notification {
	UIInterfaceOrientation deviceOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
	if (_currentOrientation != deviceOrientation) {
		_currentOrientation = deviceOrientation;
		if (self.shouldRotateToDeviceOrientation) {
			[self reposition];
		}
	}
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	// calculate a rotation transform that matches the required orientation
	if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		transform = CGAffineTransformMakeRotation(M_PI);
	}
	else if (orientation == UIInterfaceOrientationLandscapeLeft) {
		transform = CGAffineTransformMakeRotation(-M_PI_2);
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight) {
		transform = CGAffineTransformMakeRotation(M_PI_2);
	}
	
	return transform;
}

- (void)reposition {
	CGAffineTransform baseTransform = [self transformForOrientation:_currentOrientation];
	
	// determine if the rotation we're about to undergo is 90 or 180 degrees
	CGAffineTransform t1 = self.imageView.transform;
	CGAffineTransform t2 = baseTransform;
	CGFloat dot = t1.a * t2.a + t1.c * t2.c;
	CGFloat n1 = sqrtf(t1.a * t1.a + t1.c * t1.c);
	CGFloat n2 = sqrtf(t2.a * t2.a + t2.c * t2.c);
	CGFloat rotationDelta = acosf(dot / (n1 * n2));
	BOOL isDoubleRotation = (rotationDelta > 1.581);
	
	// use the system rotation duration
	CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
	// iPad lies about its rotation duration
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { duration = 0.4; }
	
	// double the animation duration if we're rotation 180 degrees
	if (isDoubleRotation) { duration *= 2; }
	
	// if we haven't laid out the subviews yet, we don't want to animate rotation and position transforms
	if (_hasLaidOut) {
		[UIView animateWithDuration:duration animations:^{
			self.imageView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, baseTransform);
		}];
	}
	else {
		self.imageView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, baseTransform);
	}
}

@end


@implementation UIView (URBMediaFocusViewController)

- (UIImage *)urb_snapshotImageWithScale:(CGFloat)scale {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
	if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	}
	else {
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end


/*
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */
@implementation UIImage (URBImageEffects)

- (UIImage *)urb_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
	// Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
	
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
		
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
		
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
		
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
				0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
		
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
	
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
	
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
	
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
	
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
	
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return outputImage;
}

@end


@import ImageIO;

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

/**
 *  Animated GIF category and utility methods from https://github.com/mayoff/uiimage-from-animated-gif
 */
@implementation UIImage (URBAnimatedGIF)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
		theSum += values[i];
    }
	
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b) {
		return pairGCD(b, a);
	}
	
    while (true) {
		int const r = a % b;
		if (r == 0) {
			return b;
		}
		
		a = b;
		b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
		// Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
		gcd = pairGCD(values[i], gcd);
    }
	
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
	int const gcd = vectorGCD(count, delayCentiseconds);
	size_t const frameCount = totalDurationCentiseconds / gcd;
	UIImage *frames[frameCount];
	for (size_t i = 0, f = 0; i < count; ++i) {
		UIImage *const frame = [UIImage imageWithCGImage:images[i]];
		for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
			frames[f++] = frame;
		}
	}
	
	return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
	for (size_t i = 0; i < count; ++i) {
		CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
	size_t const count = CGImageSourceGetCount(source);
	CGImageRef images[count];
	int delayCentiseconds[count]; // in centiseconds
	createImagesAndDelays(source, count, images, delayCentiseconds);
	int const totalDurationCentiseconds = sum(count, delayCentiseconds);
	NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
	UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
	releaseImages(count, images);
	
	return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef source) {
	if (source) {
		UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
		CFRelease(source);
		return image;
	}
	else {
		return nil;
	}
}

+ (UIImage *)urb_animatedImageWithAnimatedGIFData:(NSData *)data {
	return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)urb_animatedImageWithAnimatedGIFURL:(NSURL *)url {
	return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

@end
