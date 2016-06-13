//
//  UIImage+Extend.m
//  Fetion
//
//  Created by Zou Tianshi on 12-5-1.
//  Copyright (c) 2012年 xinrui.com. All rights reserved.
//

#import "UIImage+Extend.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
//#define kNewScaleThumbMethod

#define MaxLength 320
#define MinLength 70
@implementation UIImage (Extend)

- (UIImage *) scaledImageWithWidth:(CGFloat)width andHeight:(CGFloat)height
{
	//NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];//去掉这里面的内存池,不去掉有问题
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];  // scales image to rect
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	//[pool drain];
	return scaledImage;
}

-(CGContextRef) CreateRGBABitmapContext:(CGImageRef) inImage
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
//	void * bitmapData; 
//	int bitmapByteCount; 
	unsigned long bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage); 
	size_t pixelsHigh = CGImageGetHeight(inImage); 
	bitmapBytesPerRow	= (pixelsWide * 4); 
//	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); 
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) 
	{
		return NULL;
	}
	// allocate the bitmap & create context 
	//	bitmapData = malloc( bitmapByteCount ); 
	//	if (bitmapData == NULL) 
	//	{
	//		CGColorSpaceRelease( colorSpace ); 
	//		return NULL;
	//	}
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    
	context = CGBitmapContextCreate (NULL,
                                     pixelsWide, 
                                     pixelsHigh, 
                                     8, 
                                     bitmapBytesPerRow, 
                                     colorSpace, 
                                     bitmapInfo);
	if (context == NULL) 
	{
//		free (bitmapData); 
		CGColorSpaceRelease( colorSpace );
        return NULL;
	} 
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

- (CGFloat)calculateBrightness
{
    
    CGImageRef img = [self CGImage]; 
	CGSize size = [self size];
	CGContextRef bitmapContext = [self CreateRGBABitmapContext:img];
	if (bitmapContext == NULL) 
		return 0.0;
	CGRect rect = {{0,0},{size.width, size.height}}; 
	CGContextDrawImage(bitmapContext, rect, img); 
	unsigned char *imageData = CGBitmapContextGetData (bitmapContext); 
    
    CGFloat width = size.width;
	CGFloat height = size.height;
    
    CGFloat lineBrightness = 0;
	CGFloat totalBrightness = 0;
    
    int pixelOffset = 0;
    int lineOffset = 0;
    
	for(CGFloat y = 0; y < height; y++)
	{
		pixelOffset = lineOffset;
		lineBrightness = 0;
		for (CGFloat x = 0; x < width; x++) 
		{
			//unsigned char alpha = (unsigned char)imageData[pixelOffset+3];
			unsigned char red = (unsigned char)imageData[pixelOffset];
			unsigned char green = (unsigned char)imageData[pixelOffset+1];
			unsigned char blue = (unsigned char)imageData[pixelOffset+2];
			
			CGFloat ava = ((red+green+blue)/765.0);
            
            pixelOffset += 4;
			lineBrightness += ava;
            
		}
		lineOffset += width * 4;
		CGFloat lineAva = lineBrightness / width;
        totalBrightness += lineAva;
	}
	CGContextRelease(bitmapContext);
    return totalBrightness / height;
}

-(UIImage*)subImageInRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();  
    return smallImage;  
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}



// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,//CGImageGetBitsPerComponent(imageRef),
                                                newRect.size.width * 4,
                                                colorSpace,//CGImageGetColorSpace(imageRef),
                                                bitmapInfo);//CGImageGetBitmapInfo(imageRef));
    CGColorSpaceRelease(colorSpace);
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = nil;
    
	if(newImageRef)
	{
		newImage =[UIImage imageWithCGImage:newImageRef];
	}
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

- (CGRect) rectFitInSize:(CGSize)size
{
	if (size.width == 0 || size.height == 0)
    {
        return CGRectMake(0.0, 0.0, 0.0, 0.0);
    }
    if (self.size.width <= size.width && self.size.height <= size.height)
    {
        return CGRectMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
    }
	CGFloat distRadio = size.width / size.height;
	CGFloat radio = self.size.width / self.size.height;
	CGFloat newWidth = 0.0, newHeight = 0.0, newX = 0.0, newY = 0.0;
	if (distRadio >= radio)
	{
		newHeight = size.height;
		newY = 0.0;
		newWidth = newHeight *  radio;//self.size.width / self.size.height;
		newX = (size.width - newWidth) / 2.0f;
	}
    else
    {
		newWidth = size.width;
		newX = 0.0;
		newHeight = newWidth * self.size.height / self.size.width;
		newY = (size.height - newHeight) / 2.0f;
	}
	return CGRectMake(newX, newY, newWidth, newHeight);
}

- (CGRect) rectFillWithSize:(CGSize)size
{
	if(size.width == 0 || size.height == 0)
		return CGRectMake(0.0, 0.0, 0.0, 0.0);
	CGFloat distRadio = size.width / size.height;
	CGFloat radio = self.size.width / self.size.height;
	CGFloat newWidth = 0.0, newHeight = 0.0, newX = 0.0, newY = 0.0;
	if(distRadio > radio)
	{
		newWidth = size.width;
		newX = 0.0;
		newHeight = newWidth * self.size.height / self.size.width;
		newY = (size.height - newHeight) / 2.0f;
	} else {
		newHeight = size.height;
		newY = 0.0;
		newWidth = newHeight *  radio;//self.size.width / self.size.height;
		newX = (size.width - newWidth) / 2.0f;
	}
	return CGRectMake(newX, newY, newWidth, newHeight);
}

- (UIImage *) squaredThumbImageWithEdge:(CGFloat)length
{
	if(length <= 0)
		return nil;
    
	CGFloat clippingX, clippingY, clippingSize;
	if(self.size.width >= self.size.height)
	{
		clippingY = 0.0;
		clippingSize = self.size.height;
		clippingX = (self.size.width - clippingSize) / 2.0f;
	}
	else 
	{
		clippingX = 0.0;
		clippingSize = self.size.width;
		clippingY = (self.size.height - clippingSize) / 2.0f;
	}
	CGRect clippingBounds = CGRectMake(clippingX, clippingY, clippingSize, clippingSize);
	
	CGImageRef clippedImageRef = CGImageCreateWithImageInRect(self.CGImage, clippingBounds);  
    CGRect thumbImageBounds = CGRectMake(0, 0, length, length);  
    
    CGColorSpaceRef rgbaColorSpace = CGColorSpaceCreateDeviceRGB();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGContextRef thumbContent = CGBitmapContextCreate(NULL,
                                                length,
                                               	length,
                                                8,
                                                length * 4,
                                                rgbaColorSpace,
                                                bitmapInfo);
	CGColorSpaceRelease(rgbaColorSpace);
	UIImage * thumbImage = nil;
	if (thumbContent != nil) 
	{
		CGContextDrawImage(thumbContent, thumbImageBounds, clippedImageRef);
		
		CGImageRef thumbImageRef = CGBitmapContextCreateImage(thumbContent);     
		thumbImage = [[UIImage alloc] initWithCGImage:thumbImageRef];
		CGContextRelease(thumbContent);
		CGImageRelease(thumbImageRef);
		CGImageRelease(clippedImageRef);
#if __has_feature(objc_arc)
		return thumbImage;
#else
        return [thumbImage autorelease];
#endif
	}
	else {
		CGImageRelease(clippedImageRef);
		return nil;
	}
}

- (UIImage *) squaredThumbImageWithWidth:(CGFloat)width Height:(CGFloat)height FromTop:(BOOL)bTop Image:(UIImage*)aImage
{
    CGFloat clippingX = 0.0, clippingY = 0.0, clippingSizeX = 0.0 ,clippingSizeY = 0.0;
    
    if (bTop) {
        clippingX = 0.0;
        clippingY = 0.0;
        
        clippingSizeX = width;
        clippingSizeY = height;
    }

    CGRect clippingBounds = CGRectMake(clippingX, clippingY, clippingSizeX, clippingSizeY);
	
	CGImageRef clippedImageRef = CGImageCreateWithImageInRect(aImage.CGImage, clippingBounds);
    CGRect thumbImageBounds = CGRectMake(0, 0, clippingSizeX, clippingSizeY);
    
    CGColorSpaceRef rgbaColorSpace = CGColorSpaceCreateDeviceRGB();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGContextRef thumbContent = CGBitmapContextCreate(NULL,
                                                      clippingSizeX,
                                                      clippingSizeY,
                                                      8,
                                                      clippingSizeX * 4,
                                                      rgbaColorSpace,
                                                      bitmapInfo);
	CGColorSpaceRelease(rgbaColorSpace);
	UIImage * thumbImage = nil;
	if (thumbContent != nil)
	{
		CGContextDrawImage(thumbContent, thumbImageBounds, clippedImageRef);
		
		CGImageRef thumbImageRef = CGBitmapContextCreateImage(thumbContent);
#if __has_feature(objc_arc)
#else
        [thumbImageRef autorelease];
#endif

		thumbImage = [[UIImage alloc] initWithCGImage:thumbImageRef];
		CGContextRelease(thumbContent);
		CGImageRelease(thumbImageRef);
		CGImageRelease(clippedImageRef);
        UIImage *image = [thumbImage scaleThumbImage];
		return image;
	}
	else {
		CGImageRelease(clippedImageRef);
		return nil;
	}

}

- (UIImage *) squaredThumbImageWithLength:(CGFloat)length
{
	if(length <= 0)
		return nil;
    
	CGFloat clippingX, clippingY, clippingSizeX,clippingSizeY;
	if(self.size.width >= self.size.height)
	{
		clippingY = 0.0;
		clippingSizeY = self.size.height;
        clippingSizeX = clippingSizeY*3;
		clippingX = (self.size.width - clippingSizeY*3) / 2.0f;
	}
	else
	{
		clippingX = 0.0;
		clippingSizeX = self.size.width;
        clippingSizeY = clippingSizeX*3;
		clippingY = 0.0;
        
	}

	CGRect clippingBounds = CGRectMake(clippingX, clippingY, clippingSizeX, clippingSizeY);
	
	CGImageRef clippedImageRef = CGImageCreateWithImageInRect(self.CGImage, clippingBounds);
    CGRect thumbImageBounds = CGRectMake(0, 0, clippingSizeX, clippingSizeY);
    
    CGColorSpaceRef rgbaColorSpace = CGColorSpaceCreateDeviceRGB();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGContextRef thumbContent = CGBitmapContextCreate(NULL,
                                                      clippingSizeX,
                                                      clippingSizeY,
                                                      8,
                                                      clippingSizeX * 4,
                                                      rgbaColorSpace,
                                                      bitmapInfo);
	CGColorSpaceRelease(rgbaColorSpace);
	UIImage * thumbImage = nil;
	if (thumbContent != nil)
	{
		CGContextDrawImage(thumbContent, thumbImageBounds, clippedImageRef);
		
		CGImageRef thumbImageRef = CGBitmapContextCreateImage(thumbContent);
		thumbImage = [[UIImage alloc] initWithCGImage:thumbImageRef];
#if __has_feature(objc_arc)
#else
        [thumbImage autorelease];
#endif
		CGContextRelease(thumbContent);
		CGImageRelease(thumbImageRef);
		CGImageRelease(clippedImageRef);
        UIImage *image = [thumbImage scaleThumbImage];
		return image;
	}
	else {
		CGImageRelease(clippedImageRef);
		return nil;
	}
}

- (UIImage *)scaleThumbImage
{
    float newWidth = self.size.width;
    float newHeight = self.size.height;
    float maxLength = MaxLength;
    float minLength = 80;
    int   maxScale = 0;
#ifdef kNewScaleThumbMethod
    maxScale = 3;
#else
    maxScale = INT32_MAX;
#endif
    
    
    BOOL bScale = NO;
    UIImage *image = nil;
    
	if(self.size.width >= self.size.height)
	{
        if (self.size.width/self.size.height > maxScale)
        {
            bScale = YES;
        }
        else
        {
            if (self.size.width>maxLength)
            {
                newWidth = maxLength;
                float fScale =newWidth/self.size.width;
                newHeight = self.size.height*fScale;
            }
            
        }
		
	}
	else
	{
        if (self.size.height/self.size.width > maxScale)
        {
            bScale = YES;
            
        }
        else
        {
            if (self.size.height>maxLength)
            {
                newHeight = maxLength;
                float fScale =newHeight/self.size.height;
                newWidth = self.size.width*fScale;
                
            }
            
        }
        
    }
    if (bScale) {
        image = [self squaredThumbImageWithLength:minLength];
        
    }
    else
    {
        image = [self scaledImageWithWidth:newWidth andHeight:newHeight];
    }
    return image;
    
}

- (UIImage *)createScaleThumbImage
{
    float orignalWidth = self.size.width;
    float orignalHeight = self.size.height;
    float rate = orignalWidth/orignalHeight;
    //最终截取图片的宽高
    float newWidth =0.0;
    float newHeight = 0.0;
    //缩放宽高
    float scaleHeight = 0.0;
    float scaleWidth = 0.0;
    UIImage *image = nil;
    
    if (rate<=0.5) //边界外竖图
    {
        if (orignalWidth<MinLength) {
            newWidth = MinLength;
            float fScale =newWidth/orignalWidth;
            newHeight = orignalHeight*fScale;
            if (newHeight>320) {
                newHeight=320;
            }
        }
        else
        {
            newWidth = 160.0;
            newHeight = 320.0;
        }
        
        if (orignalWidth != newWidth) {
            scaleWidth = newWidth;
            float fScale =newWidth/orignalWidth;
            scaleHeight = orignalHeight*fScale;
            //缩放
            image = [self scaledImageWithWidth:scaleWidth andHeight:scaleHeight];
        }
        
        //截图
        image = [self squaredThumbImageWithWidth:newWidth Height:newHeight FromTop:YES Image:image];
    }
    else if (0.5<rate && rate<1) //边界内竖图
    {
        if (orignalWidth<MinLength) {
            newWidth = MinLength;
            float fScale = newWidth/orignalWidth;
            newHeight = orignalHeight * fScale;
            scaleWidth = newWidth;
            scaleHeight = newHeight;

        }
        else
        {
            newHeight = 320;
            scaleHeight = newHeight;
            float fScale = newHeight/orignalHeight;
            scaleWidth = orignalWidth * fScale;
        }
        if (orignalHeight != newHeight) {
            //缩放
            image = [self scaledImageWithWidth:scaleWidth andHeight:scaleHeight];
        }
        else
        {
            image = self;
        }
    }
    else if (rate == 1)
    {
        newHeight = 288;
        newWidth = 288;
        if (orignalWidth > newWidth)
        {
            newHeight = 288;
            newWidth = 288;
        }
        else if (orignalHeight<70)
        {
            newHeight = 70;
            newWidth = 70;
        }
        else
        {
            newHeight = orignalHeight;
            newWidth = orignalWidth;
        }
        if (orignalWidth != newWidth)
        {
            //缩放
            image = [self scaledImageWithWidth:newHeight andHeight:newWidth];
        }
        else
        {
            image = self;
        }
    }
    else if (1<rate && rate<5.0/3) //边界内横图
    {
        if (orignalHeight<MinLength)
        {
            newHeight = MinLength;
            scaleHeight = newHeight;
            float fScale =newHeight/orignalHeight;
            scaleWidth = orignalWidth*fScale;
        }
        else
        {
            newWidth = 288;
            scaleWidth = newWidth;
            float fScale =newWidth/orignalWidth;
            scaleHeight = orignalHeight*fScale;
        }
        
        if (orignalWidth != newWidth) {
            //缩放
            image = [self scaledImageWithWidth:scaleWidth andHeight:scaleHeight];
        }
        else
        {
            image = self;
        }
    }
    else if(rate>=5.0/3) //边界外横图
    {
        if (orignalWidth<MinLength)
        {
            newHeight = MinLength;
            float fScale =scaleHeight/orignalHeight;
            newWidth = orignalWidth * fScale;
            if (newWidth>288) {
                newWidth = 288;
            }
        }
        else
        {
            newWidth = 288;
            newHeight = 173;
        }
      
        if (orignalHeight != newHeight) {
            scaleHeight = newHeight;
            float fScale =scaleHeight/orignalHeight;
            scaleWidth = orignalWidth * fScale;
            //缩放
            image = [self scaledImageWithWidth:scaleWidth andHeight:scaleHeight];
            
        }
        
        //截图
        image = [self squaredThumbImageWithWidth:newWidth Height:newHeight FromTop:YES Image:image];
    }
    else
        return self;

    return image;
}

+ (UIImage *) imageFromScreen
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(screenWindow.frame.size.width*scale, screenWindow.frame.size.height*scale));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
   // imageWithCGImage:returnImg
    [screenWindow.layer renderInContext:context];
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    screenWindow.layer.contents = nil;
    
    //
    CGRect frame= [[UIScreen mainScreen] applicationFrame];
    frame.size.width *= scale;
    frame.size.height*= scale;
    frame.origin.y =20*scale;
    CGImageRef small = CGImageCreateWithImageInRect([theImage CGImage],frame);
    UIImage * tmp = [UIImage imageWithCGImage:small scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(small);
    return tmp;
    
}

//+(UIImage *)fixOrientation:(UIImage *)aImage {
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}

+ (UIImage *)fixOrientation:(UIImage *)aImage orientation:(UIDeviceOrientation)orientation {
    // No-op if the orientation is already correct
    if (orientation == UIDeviceOrientationPortrait)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIDeviceOrientationLandscapeLeft:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIDeviceOrientationLandscapeRight:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    CGSize size;
    CGRect frame;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            size = CGSizeMake(aImage.size.height, aImage.size.width);
            frame = [aImage rectFitInSize:size];
            CGContextDrawImage(ctx, frame, aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIImage *)clipImagewithRect:(CGRect)rect{
    
    //大图bigImage
    
    //定义myImageRect，截图的区域
    
    CGRect myImageRect = rect;
    
    UIImage* bigImage= self;
    
    CGImageRef imageRef = bigImage.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    
    CGSize size;
    
    size.width = rect.size.width;
    
    size.height = rect.size.height;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);

    return smallImage;
}

- (UIImage *)resizeImage:(UIImage *)image {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    size.width *= [UIScreen mainScreen].scale;
    size.height *= [UIScreen mainScreen].scale;
    
    if (image.size.width > size.width || image.size.height > size.height) {
        CGFloat scale;
        CGSize newSize = image.size;
        if (newSize.height && (newSize.height > size.height)) {
            scale = size.height / newSize.height;
            newSize.height = size.height;
            newSize.width *= scale;
        }
        if (newSize.width && (newSize.width > size.width)) {
            scale = size.width / newSize.width;
            newSize.height *= scale;
            newSize.width = size.width;
        }
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/**
 *  裁剪图
 *
 *  @param rect 裁剪frame
 *
 *  @return 返回裁剪图
 */
+ (UIImage *)getClipImg:(UIImage *)img withSize:(CGSize)kSize
{
    float x = (img.size.width - kSize.width)/2.0;
    float y = (img.size.height - kSize.height) /2.0;
    
    CGRect myImageRect = CGRectMake(x, y, kSize.width,kSize.height);
    
    CGImageRef imageRef = img.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    UIGraphicsBeginImageContext(kSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return smallImage;
}

/**
 *  处理单图文、多图文大图、小图等
 *
 *  （1）当原图小于360*200，以360/200为基准，等比例拉伸。如原图为300*100，将图片高拉伸为600*200，截取中间部分。
 *  （2）当原图等于360*200，显示正常图片。
 *  （3）当原图大于360*200，以360/200为基准，等比例缩放，如原图为720*500，将图片宽压缩为360*250，截取中间部分。
 */
+ (UIImage *)dealWithImage:(UIImage *)kImg andSize:(CGSize)kSize
{
    CGSize size = CGSizeZero;
    UIImage *newImg = nil;
    
    float imgWidth = kImg.size.width;
    float imgHeight = kImg.size.height;
    
    float kWidth = kSize.width;
    float kHeiht = kSize.height;
    
    if (imgWidth == kWidth && imgHeight == kHeiht)
    {
        return kImg;
    }
    
    if (imgWidth >= kWidth && imgHeight >= kHeiht)
    {
        float rate  = MIN(imgWidth / kWidth, imgHeight / kHeiht);
        size.width  = imgWidth / rate;
        size.height = imgHeight / rate;
    }
    else if (imgWidth >= kWidth && imgHeight < kHeiht)
    {
        float rate = kHeiht / imgHeight;
        size.height = kHeiht;
        size.width = imgWidth * rate;
    }
    else if (imgWidth < kWidth && imgHeight >= kHeiht)
    {
        float rate = kWidth / imgWidth;
        size.width = kWidth;
        size.height = imgHeight * rate;
    }
    else if (imgWidth < kWidth && imgHeight < kHeiht)
    {
        float rate  = MAX(kWidth / imgWidth, kHeiht / imgHeight);
        size.width  = imgWidth * rate;
        size.height = imgHeight * rate;
    }
    
    UIImage *scaleImg = [self getNewImgWithSize:size andImg:kImg];
    newImg = [self getClipImg:scaleImg withSize:kSize];
    
    return newImg;
}

/**
 *  获取等比例图
 *
 *  @param newSize 新宽高
 *  @param img     旧图
 *
 *  @return 新图
 */
+ (UIImage *)getNewImgWithSize:(CGSize)newSize andImg:(UIImage *)img
{
    UIGraphicsBeginImageContext(newSize);
    
    [img drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



@end

//added by lubiao - 2014/02/10 UIImage(PureColor)
#define BYTES_PER_PIXEL 1           //灰度图每像素占一个字节
#define MAX_COMPRESSED_SIZE 200     //按照比例压缩图片,宽高最大值为200
#define DIFFERENT_THRESHOLD 5       //比较灰度差的阀值

#define IMAGECOLORLOG 0
@implementation UIImage (PureColor)

- (BOOL)isPureColor
{
    BOOL isPure = NO;
    CGContextRef context = [UIImage contextWithGrayAndResizeImage:self];
    isPure = [UIImage isPureColorImageInContext:context];
    CGContextRelease(context);
    return isPure;
}

/**
 *	@brief	计算图片比例,返回按比例压缩后的图片尺寸,宽高最大为200,该函数只是计算尺寸,并没有压缩图片
 *
 *	@param 	srcImage 	待压缩图片源
 *
 *	@return	CGSize
 */
+ (CGSize)scaleSizeWithImage:(UIImage *)srcImage
{
    CGSize size = CGSizeZero;
    if (srcImage.size.width < MAX_COMPRESSED_SIZE && srcImage.size.height < MAX_COMPRESSED_SIZE) {
        return srcImage.size;
    }
    
    //按照图片比例压缩到200xN 或者 Nx200的尺寸
    float scale = srcImage.size.width / srcImage.size.height;
    
    if (scale > 1.0f) {
        size.width = MAX_COMPRESSED_SIZE;
        size.height = size.width / scale;
    }
    else {
        size.height = MAX_COMPRESSED_SIZE;
        size.width = size.height * scale;
    }
    
    return size;
}

/**
 *	@brief	压缩图片并将图片转换为灰度图,返回图片所在的上下文context
 *
 *	@param 	srcImage 	待处理的图片源
 *
 *	@return	携带处理过后的图片数据的上下文
 */
+ (CGContextRef)contextWithGrayAndResizeImage:(UIImage *)srcImage
{
    CGContextRef context = NULL;
    CGSize size = [self scaleSizeWithImage:srcImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    if (NULL == colorSpace) {
#if IMAGECOLORLOG
        NSLog(@"failed to create gray color space\n");
#endif
        return NULL;
    }
    
    context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    if (NULL == context) {
#if IMAGECOLORLOG
        NSLog(@"failed to create bitmap context\n");
#endif
        return NULL;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextDrawImage(context, rect, srcImage.CGImage);
    CGColorSpaceRelease(colorSpace);
    return context;
}

/**
 *	@brief	判断context中图片是否为纯色图
 *
 *	@param 	context 	携带灰度图数据的上下文bitmap context
 *
 *	@return	YES/NO      纯色返回YES,否则返回NO; 异常返回NO;
 */
+ (BOOL)isPureColorImageInContext:(CGContextRef)context
{
    BOOL different = NO;
    if (NULL == context) return NO;
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    long pixelWidth = CGImageGetWidth(cgImage) * BYTES_PER_PIXEL;
    long pixelHeight = CGImageGetHeight(cgImage);
    unsigned char *pixelBuffer = CGBitmapContextGetData(context);
    
    //将图片分成四块,分别从四块中随机取四个不相交的子块,再取图片中间一块,共5块
    //point[]中是5个块起点的的坐标(x,y)
    int midWidth = (int)pixelWidth / 2;
    int midHeight = (int)pixelHeight / 2;
    int subWidth = midWidth / 2;
    int subHeight = midHeight / 2;
    int point[10] = {0};
    point[0] = arc4random()%(subWidth+1);                   //x0;
    point[1] = arc4random()%(subHeight+1);                  //y0;
    point[2] = arc4random()%(subWidth+1) + midWidth;        //x1;
    point[3] = arc4random()%(subHeight+1);                  //y1;
    point[4] = arc4random()%(subWidth+1);                   //x2;
    point[5] = arc4random()%(subHeight+1) + midHeight;      //y2;
    point[6] = arc4random()%(subWidth+1) + midWidth;        //x3;
    point[7] = arc4random()%(subHeight+1) + midHeight;      //y3;
    point[8] = (int)(pixelWidth/2) - (subWidth/2);               //x4;
    point[9] = (int)(pixelHeight/2) - (subHeight)/2;             //y4;
    
    UInt32 sum[5] = {0};
    int aver[5] = {0};
    int offset = 0;
    //遍历5个矩形中的像素点求平局值
    for (int num = 0; num < 5; num++) {
        //遍历一个块中的所有像素
        for (int column = point[offset]; column < point[offset] + subWidth; column++) {
            for (int row = point[offset+1]; row < point[offset+1] + subHeight; row++) {
                sum[num] += pixelBuffer[BYTES_PER_PIXEL*(pixelWidth * row + column)];
            }
        }
        aver[num] = sum[num]/subWidth/subHeight;
        offset += 2;
#if IMAGECOLORLOG
        NSLog(@"sum[%d] ======= %lu", num, sum[num]);
        NSLog(@"aver[%d] ======= %d", num, aver[num]);
#endif
    }
    
    //得到5个矩形灰度的平均值两两进行比较
#if IMAGECOLORLOG
    int count = 1;
#endif
    for (int i = 0; i < 4; i++) {
        for (int j = i+1; j < 5; j++) {
            int diffValue = abs(aver[i] - aver[j]);
#if IMAGECOLORLOG
            NSLog(@"aver[%d] - aver[%d] ========= %d", i, j, diffValue);
            NSLog(@"第 %d 次比较, 结果 : %@", count, ((diffValue > DIFFERENT_THRESHOLD) ? @"不是纯色" : @"纯色"));
#endif
            if (diffValue > DIFFERENT_THRESHOLD) {
                different = YES;
                break;
            }
#if IMAGECOLORLOG
            count++;
#endif
        }
        if (different) break;
    }
#if IMAGECOLORLOG
    NSLog(@"最终比较结果 %d, %@\n\n\n\n\n", different, (different ? @"不是纯色": @"纯色"));
#endif
    CGImageRelease(cgImage);
    return (!different);
}

/**
 *	@brief	提取上下文中的图片
 *
 *	@param 	context 	携带图片数据的bitmap context
 *
 *	@return	UIImage对象
 */
+ (UIImage *)getGrayImageFromContext:(CGContextRef)context
{
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

//图片转化为灰度图片
-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,(CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

/**
 *	@brief	获取图片的后缀
 *
 *	@param 	imageData 	图片数据
 *
 *	@return	图片后缀
 */
+(NSString*)getImageExtension:(NSData*) imageData
{
    NSString* extension= @"jpg";
    if (imageData.length > 4) {
        
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            
            bytes[1] == 0xd8 &&
            
            bytes[2] == 0xff)
            
        {
            extension = @"jpg";
        }
        
        if (bytes[0] == 0x89 &&
            
            bytes[1] == 0x50 &&
            
            bytes[2] == 0x4e &&
            
            bytes[3] == 0x47)
            
        {
            extension = @"png";
        }
      
    }
    
    return extension;
    
}

@end


@implementation UIImage (CreateByColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
