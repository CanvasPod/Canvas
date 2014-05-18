//
//  DAKeyboardControl.h
//  DAKeyboardControlExample
//
//  Created by Daniel Amitay on 7/14/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DAKeyboardDidMoveBlock)(CGRect keyboardFrameInView);

/** DAKeyboardControl allows you to easily add keyboard awareness and scrolling
 dismissal (a receding keyboard ala iMessages app) to any UIView, UIScrollView
 or UITableView with only 1 line of code. DAKeyboardControl automatically
 extends UIView and provides a block callback with the keyboard's current origin.
 */

@interface UIView (DAKeyboardControl)

/** The keyboardTriggerOffset property allows you to choose at what point the
 user's finger "engages" the keyboard.
 */
@property (nonatomic) CGFloat keyboardTriggerOffset;
@property (nonatomic, readonly) BOOL keyboardWillRecede;

/** Adding pan-to-dismiss (functionality introduced in iMessages)
 @param didMoveBlock called everytime the keyboard is moved so you can update
  the frames of your views
 @see addKeyboardNonpanningWithActionHandler:
 @see removeKeyboardControl
 */
- (void)addKeyboardPanningWithActionHandler:(DAKeyboardDidMoveBlock)didMoveBlock;

/** Adding keyboard awareness (appearance and disappearance only)
 @param didMoveBlock called everytime the keyboard is moved so you can update
  the frames of your views
 @see addKeyboardPanningWithActionHandler:
 @see removeKeyboardControl
 */
- (void)addKeyboardNonpanningWithActionHandler:(DAKeyboardDidMoveBlock)didMoveBlock;

/** Remove the keyboard action handler
 @note You MUST call this method to remove the keyboard handler before the view
  goes out of memory.
 */
- (void)removeKeyboardControl;

/** Returns the keyboard frame in the view */
- (CGRect)keyboardFrameInView;

/** Convenience method to dismiss the keyboard */
- (void)hideKeyboard;

@end

