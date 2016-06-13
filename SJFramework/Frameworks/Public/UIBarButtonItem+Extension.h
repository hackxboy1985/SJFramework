

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  通过一张图片返回一个UIBarButtonItem
 *
 *  @param imageName 图片的名字
 *
 */

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

//自定义导航栏的"返回按钮"
+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;

//只有文字
+ (instancetype)itemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

@end
