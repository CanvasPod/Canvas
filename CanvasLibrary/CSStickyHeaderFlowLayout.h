/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

extern NSString *const CSStickyHeaderParallexHeader;

@interface CSStickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGSize parallexHeaderReferenceSize;
@property (nonatomic) CGSize parallexHeaderMinimumReferenceSize;
@property (nonatomic) BOOL disableStickyHeaders;

@end
