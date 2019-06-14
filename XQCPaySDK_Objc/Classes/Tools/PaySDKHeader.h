//
//  Header.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#ifndef Header_h
#define Header_h

#import "UIImage+myImage.h"
#import "SDWebImage.h"
#import "SVProgressHUD.h"
//屏幕宽
#define XQCPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高
#define XQCPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height

#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 状态栏高度
#define XQCSTATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define XQCNAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define XQCTAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

#define XQCTAB_SAFE_HEIGHT (iPhoneX ? 34.f : 0.f)

#define Hex(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define WidthOfScale(x)  (x)*(XQCPHONE_WIDTH/375.0)

#define WeakSelf(type) __weak typeof(type) weak##type = type;
#endif /* Header_h */
