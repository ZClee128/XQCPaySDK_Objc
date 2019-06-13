//
//  UIImage+xqcBundle.h
//  testProject
//
//  Created by huangwenwu on 2019/5/16.
//  Copyright © 2019 huangwenwu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (xqcBundle)

+ (instancetype)xqc_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass;

/** 根据颜色返回图片 */
+ (UIImage *)xqc_imageWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
