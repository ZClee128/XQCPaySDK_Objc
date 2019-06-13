//
//  UIImage+xqcBundle.m
//  testProject
//
//  Created by huangwenwu on 2019/5/16.
//  Copyright © 2019 huangwenwu. All rights reserved.
//

#import "UIImage+xqcBundle.h"

@implementation UIImage (xqcBundle)

+ (instancetype)xqc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass
{
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *curB = [NSBundle bundleForClass:targetClass];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.png", name,scale];
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *path = [curB pathForResource:imgName ofType:nil inDirectory:dir];
    return path?[UIImage imageWithContentsOfFile:path]:nil;
}

/** 根据颜色返回图片 */
+ (UIImage *)xqc_imageWithColor:(UIColor*)color {
    return [self xqc_imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)xqc_imageWithColor:(UIColor*)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
