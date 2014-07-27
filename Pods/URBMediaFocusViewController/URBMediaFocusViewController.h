//
//  URBMediaFocusViewController.h
//  URBMediaFocusViewControllerDemo
//
//  Created by Nicholas Shipes on 11/3/13.
//  Copyright (c) 2013 Urban10 Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URBMediaFocusViewController;

@protocol URBMediaFocusViewControllerDelegate <NSObject>
@optional

/**
 *  Tells the delegate that the controller's view is visisble. This is called after all presentation animations have completed.
 *
 *  @param mediaFocusViewController The instance that triggered the event.
 */
- (void)mediaFocusViewControllerDidAppear:(URBMediaFocusViewController *)mediaFocusViewController;

/**
 *  Tells the delegate that the controller's view has been removed and is no longer visible. This is called after all dismissal animations have completed.
 *
 *  @param mediaFocusViewController The instance the triggered the event.
 */
- (void)mediaFocusViewControllerDidDisappear:(URBMediaFocusViewController *)mediaFocusViewController;

/**
 *  Tells the delegate that the remote image needed for presentation has successfully loaded.
 *
 *  @param mediaFocusViewController The instance that triggered the event.
 *  @param image                    The image that was successfully loaded and used for the focus view.
 */
- (void)mediaFocusViewController:(URBMediaFocusViewController *)mediaFocusViewController didFinishLoadingImage:(UIImage *)image;

/**
 *  Tells the delegate that there was an error when requesting the remote image needed for presentation.
 *
 *  @param mediaFocusViewController The instance that triggered the event.
 *  @param error                    The error returned by the internal request.
 */
- (void)mediaFocusViewController:(URBMediaFocusViewController *)mediaFocusViewController didFailLoadingImageWithError:(NSError *)error;

@end

@interface URBMediaFocusViewController : UIViewController <UIDynamicAnimatorDelegate, UIGestureRecognizerDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, assign) BOOL shouldBlurBackground;
@property (nonatomic, assign) BOOL parallaxEnabled;

// determines whether or not view should be dismissed when the container view is tapped anywhere outside image bounds
@property (nonatomic, assign) BOOL shouldDismissOnTap;

// determines whether or not view should be dismissed when the container view is tapped within bounds of image view
@property (nonatomic, assign) BOOL shouldDismissOnImageTap;

// determines if photo action sheet should appear with a long press on the photo (default NO)
@property (nonatomic, assign) BOOL shouldShowPhotoActions;

//determines if view should rotate when the device orientation changes (default YES)
@property (nonatomic, assign) BOOL shouldRotateToDeviceOrientation;

@property (nonatomic, weak) id<URBMediaFocusViewControllerDelegate> delegate;

// HTTP header values included in URL requests
@property (nonatomic, strong) NSDictionary *requestHTTPHeaders;

/**
 *  Convenience method for not using a parentViewController.
 *  @see showImage:fromView:inViewController
 */
- (void)showImage:(UIImage *)image fromView:(UIView *)fromView;

/**
 *  Presents focus view from a specific CGRect, useful for using with images located within UIWebViews.
 *
 *  @param image    The full size image to show, which should be an image already cached on the device or within the app's bundle.
 *  @param fromRect The CGRect from which the image should be presented from.
 */
- (void)showImage:(UIImage *)image fromRect:(CGRect)fromRect;

/**
 *  Convenience method for not using a parentViewController.
 *  @see showImageFromURL:fromView:inViewController
 */
- (void)showImageFromURL:(NSURL *)url fromView:(UIView *)fromView;

/**
 *  Presents media from a specific CGRect after being requested from the specified URL. The `URBMediaFocusViewController` will 
 *	only present its view once the image has been successfully loaded.
 *
 *  @param url      The remote url of the full size image that will be requested and displayed.
 *  @param fromRect The CGRect from which the image should be presented from.
 */
- (void)showImageFromURL:(NSURL *)url fromRect:(CGRect)fromRect;

/**
 *  Shows a full size image over the current view or main window. The image should be cached locally on the device, in the app 
 *	bundle or an image generated from `NSData`.
 *
 *  @param image                The full size image to show, which should be an image already cached on the device or within the app's bundle.
 *  @param fromView             The view from which the presentation animation originates.
 *  @param parentViewController The parent view controller containing the `fromView`. If `parentViewController` is `nil`, then the focus view will be added to the main `UIWindow` instance.
 */
- (void)showImage:(UIImage *)image fromView:(UIView *)fromView inViewController:(UIViewController *)parentViewController;

/**
 *  Shows a full size image over the current view or main window after being requested from the specified URL. The `URBMediaFocusViewController` 
 *	will only present its view once the image has been successfully loaded.
 *
 *  @param url                  The remote url of the full size image that will be requested and displayed.
 *  @param fromView             The view from which the presentation animation originates.
 *  @param parentViewController The parent view controller containing the `fromView`. If `parentViewController` is `nil`, then the focus view will be added to the main `UIWindow` instance.
 */
- (void)showImageFromURL:(NSURL *)url fromView:(UIView *)fromView inViewController:(UIViewController *)parentViewController;

/**
 *  Stop downloading the image (useful when closing a window while the image is downloading)
 */
- (void)cancelURLConnectionIfAny;

@end

@interface UIImage (URBAnimatedGIF)
+ (UIImage *)urb_animatedImageWithAnimatedGIFData:(NSData *)data;
+ (UIImage *)urb_animatedImageWithAnimatedGIFURL:(NSURL *)url;
@end
