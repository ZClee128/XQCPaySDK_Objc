//
//  XQCHeader.h
//  XQCPaymentPasswordInputView
//
//  Created by huangwenwu on 2019/5/29.
//

#ifndef XQCHeader_h
#define XQCHeader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImage+xqcBundle.h"
#import "NSString+XQCMd5.h"
#import "NSString+XQCPwdRsaTool.h"
#import "RSAEncryptor.h"
#import "UIButton+Extension.h"
#import "UITextField+MyExtension.h"

//屏幕宽
#define kPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高
#define kPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})\

#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// View 圆角和加边框
//#define kViewBorderRadius(View, Radius, Width, Color)\

//#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"SDK.bundle/%@",imageName]inBundle: [NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]

#define kGetImage(imageName) [UIImage xqc_imgWithName:[NSString stringWithFormat:@"%@",imageName] bundle:@"XQCPaymentPasswordInputView" targetClass:[self class]]

/*
 常用字号
 */
#define XQC_REGULAR_FONT_9                          [UIFont systemFontOfSize:9.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_10                         [UIFont systemFontOfSize:10.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_11                         [UIFont systemFontOfSize:11.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_12                         [UIFont systemFontOfSize:12.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_13                         [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_14                         [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_15                         [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_16                         [UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_17                         [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_18                         [UIFont systemFontOfSize:18.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_19                         [UIFont systemFontOfSize:19.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_20                         [UIFont systemFontOfSize:20.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_21                         [UIFont systemFontOfSize:21.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_22                         [UIFont systemFontOfSize:22.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_23                         [UIFont systemFontOfSize:23.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_24                         [UIFont systemFontOfSize:24.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_25                         [UIFont systemFontOfSize:25.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_26                         [UIFont systemFontOfSize:26.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_27                         [UIFont systemFontOfSize:27.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_28                         [UIFont systemFontOfSize:28.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_29                         [UIFont systemFontOfSize:29.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_30                         [UIFont systemFontOfSize:30.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_33                         [UIFont systemFontOfSize:33.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_35                         [UIFont systemFontOfSize:35.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_40                         [UIFont systemFontOfSize:40.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_45                         [UIFont systemFontOfSize:45.0f weight:UIFontWeightRegular]
#define XQC_REGULAR_FONT_50                         [UIFont systemFontOfSize:50.0f weight:UIFontWeightRegular]

/** 主字体颜色 */
#define kGlobalMainTextColor        RGB16(0x2F2D42)
/** 一级文字颜色 */
#define kGlobalPrimaryTextColor     RGB16(0x333333)
/** 二级文字颜色 */
#define kGlobalSecondaryTextColor   RGB16(0xBFBDD7)
/** 次级文字颜色 */
#define kGlobalSubprimeTextColor    RGB16(0xACACAC)
/** 提示色 */
#define kGlobalWarnColor           RGB16(0x999999)

/** 通用灰色 */
#define kGlobalGrayColor    RGB16(0xcccccc)

/** 主颜色 */
#define kGlobalMainColor    RGB16(0x395BA8)
/** 辅助色 线条色 文字颜色 图标色 */
#define kGlobalAssistedColor  RGB16(0xF5F5F5)

//系统色
#define WhiteColor  [UIColor whiteColor]
#define OrangeColor [UIColor orangeColor]
#define BlackColor  [UIColor blackColor]
#define ClearColor  [UIColor clearColor]

#endif /* XQCHeader_h */
