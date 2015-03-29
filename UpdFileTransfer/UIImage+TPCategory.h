//
//  UIImage+ImageHelper.h
//  CommonLibrary
//
//  Created by rang on 13-1-14.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPCategory)
/*
 * image cut to size
 */
- (UIImage *)imageAtRect:(CGRect)rect;
/*
 * image proportionally scall to minsize
 */
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
/*
 * image proportionally scall to size
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
/*
 * image scall to size
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
/*
 * image rotate to radians
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/*
 * image rotate to degree
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/*
 * merger two image to single image
 */
+(UIImage*)mergerImage:(UIImage*)img mergerImage:(UIImage*)merger position:(CGPoint)pos;
/*
 * create color to image
 */
+(UIImage*)createImageWithColor:(UIColor*)color;
/*
 * convert base64string to image
 */
-(NSString *) imageBase64String;
+(UIImage *) dataFromBase64String:(NSString *)string;
/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Creates an image with a path compontent relative to
 * the main bundle's resource path
 */
+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent;

/*
 * Scales the image to the given size, NOT aspect
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 * Aspect scale with border color, and corner radius, and shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor;
/*
 * Aspect scale with a shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor;

/*
 * Aspect scale with corner radius
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius;

/*
 * Aspect scales the image to a max size
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size;

/*
 * Aspect scales the image to a rect size
 */
- (UIImage*)aspectScaleToSize:(CGSize)size;

/*
 * Masks the context with the image, then fills with the color
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor;

/*
 * Masks the context with the image, then fills with the gradient (two colors in an array)
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors;
/*
 * save image local
 */
- (BOOL)saveImage:(NSString*)path;
- (BOOL)saveImage:(NSString*)path withName:(NSString*)fileName;
@end
