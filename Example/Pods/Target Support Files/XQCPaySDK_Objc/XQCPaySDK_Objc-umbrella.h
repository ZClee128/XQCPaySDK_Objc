#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSBundle+loadImage.h"
#import "UIImage+myImage.h"
#import "Header.h"
#import "XQCNetworking.h"
#import "ChannelModel.h"
#import "XQCPayManager.h"
#import "XQCNavBarView.h"
#import "XQCPayHeaderView.h"
#import "XQCPayItemView.h"
#import "XQCPayViewController.h"
#import "WechatAuthSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"

FOUNDATION_EXPORT double XQCPaySDK_ObjcVersionNumber;
FOUNDATION_EXPORT const unsigned char XQCPaySDK_ObjcVersionString[];

