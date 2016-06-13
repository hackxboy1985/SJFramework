//
//  UIImage+ZRExt.h
//
//  Created by ZR on 14-8-18.
//  Copyright (c) 2014年 ZR. All rights reserved.
//

#import <UIKit/UIKit.h>

//实现毛玻璃效果，工程需要包括Accelerate.framework
@interface UIImage (BoxBlur)

/**
*  @param blur           代表传入的模糊度，模糊度介于0-1之间，参数的值越大代表越迷糊
*  @return UIImage       实现毛玻璃效果后得图片
*/
- (UIImage*)getFrostedGlassImage:(CGFloat)blur;

@end



//根据color获得纯色image
@interface UIImage (UIColor)

/**
 *  @param color          颜色值
 *  @return UIImage       纯色图片size{1,1}
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end



//对当前控件进行截图
@interface UIView (Snapshot)

- (UIImage *)snapshot;

@end



//压缩图片
@interface UIImage (ScaledToSize)

- (UIImage *)scaledToSize:(CGSize)newSize;

@end


