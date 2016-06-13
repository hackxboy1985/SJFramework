

#import <UIKit/UIKit.h>

@interface UIView (Layout)

@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat buttom;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGSize size;


@end


@interface UIFont (AdapterUI)

/**
 * @brief 适配字体，传入字体大小以iphone6为标准，适配iphone5及iphone6p
 */
+ (UIFont *)systemFontOfSizeInIphone6:(CGFloat)fontSize;

@end