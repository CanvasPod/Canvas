/*
* This file is part of the Canvas package.
* (c) Canvas <usecanvas@gmail.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import "UINavigationBar+TCCustomFont.h"

@implementation UINavigationBar (TCCustomFont)
- (NSString *)fontName {
    UIFont *font = (self.titleTextAttributes)[NSFontAttributeName];
    return font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    UIFont *font = (self.titleTextAttributes)[NSFontAttributeName];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.titleTextAttributes];
    [attributes setValue:[UIFont fontWithName:fontName size:font.pointSize] forKey:NSFontAttributeName];
    self.titleTextAttributes = [NSDictionary dictionaryWithDictionary:attributes];
}
@end
