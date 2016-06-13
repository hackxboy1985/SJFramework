//
//  UIImage+Extend.h
//  Fetion
//
//  Created by Zou Tianshi on 12-5-1.
//  Copyright (c) 2012年 xinrui.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

- (CGFloat)calculateBrightness;
- (UIImage *) scaledImageWithWidth:(CGFloat)width andHeight:(CGFloat)height;
//CGContextRef CreateRGBABitmapContext (CGImageRef inImage);
//-(UIImage*)getSubImage:(CGRect)rect;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
//- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                 // bounds:(CGSize)bounds
                   // interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)subImageInRect:(CGRect)rect;
- (CGRect) rectFitInSize:(CGSize)size;
- (CGRect) rectFillWithSize:(CGSize)size;

- (UIImage *) squaredThumbImageWithEdge:(CGFloat)length;

+ (UIImage *) imageFromScreen;

+ (UIImage *)fixOrientation:(UIImage *)aImage orientation:(UIDeviceOrientation)orientation;
- (UIImage *)clipImagewithRect:(CGRect)rect;
- (UIImage *)resizeImage:(UIImage *)image;
+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;

- (UIImage *)scaleThumbImage;
- (UIImage *)createScaleThumbImage;

/**
 *  处理单图文、多图文大图、小图等
 *  如：
 *  （1）当原图小于360*200，以360/200为基准，等比例拉伸。如原图为300*100，将图片高拉伸为600*200，截取中间部分。
 *  （2）当原图等于360*200，显示正常图片。
 *  （3）当原图大于360*200，以360/200为基准，等比例缩放，如原图为720*500，将图片宽压缩为360*250，截取中间部分。
 */
+ (UIImage *)dealWithImage:(UIImage *)kImg andSize:(CGSize)kSize;

/**
 *  获取等比例图
 *
 *  @param newSize 新宽高
 *  @param img     旧图
 *
 *  @return 新图
 */
+ (UIImage *)getNewImgWithSize:(CGSize)newSize andImg:(UIImage *)img;

/**
 *  根据颜色值返回UIImage
 *
 *  @param color 颜色值
 *
 *  @return 创建好的纯色image
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color;

/**
 *  裁剪图
 *
 *  @param rect 裁剪frame
 *
 *  @return 返回裁剪图
 */
+ (UIImage *)getClipImg:(UIImage *)img withSize:(CGSize)kSize;

@end

//added by lubiao - 2014/2/10
@interface UIImage (PureColor)

/**
 *	@brief	判断UIImage是否为纯色图片,模糊判断,不是绝对精确
 *
 *	@return	YES/NO  纯色图片返回YES,非纯色返回NO;
                    如果在处理图片过程中创建color space失败或者创建CGContext失败,返回 NO;
 */
- (BOOL)isPureColor;

//图片转化为灰度图片
-(UIImage*)getGrayImage:(UIImage*)sourceImage;

/**
 *	@brief	获取图片的后缀
 *
 *	@param 	imageData 	图片数据
 *
 *	@return	图片后缀
 */
+(NSString*)getImageExtension:(NSData*) imageData;

@end

//通过UIColor创建纯色图片
@interface UIImage (CreateByColor)
+ (UIImage *)imageWithColor:(UIColor *)color;

@end