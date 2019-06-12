//
//  YSEPay.h
//  YSEPaySDK
//
//  Created by JoakimLiu on 2017/4/20.
//  Copyright © 2017年 银盛通信有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YSEPayObjects.h"
#import "YSEPayReq.h"
#import "YSEPayResp.h"

@protocol YSEPayDelegate <NSObject>
@required
/**
 请求事件的响应

 @param resp 响应体
 */
- (void)onYSEPayResp:(YSEPayBaseResp *)resp;
@end


@interface YSEPay : NSObject
/**
 单例

 @return return value description
 */
+ (instancetype)sharedInstance;

/**
 配置微信支付app Id

 @param wxAppId 在微信开发平台申请的app Id
 @return 是否成功，返回YES才能操作微信支付
 */
- (BOOL)configureWeChatPay:(NSString *)wxAppId;

/**
 处理通过URL唤起APP的URL

 @param url url description
 @return return value description
 */
- (BOOL)handleApplicationOpenURL:(NSURL *)url;

/**
 设置代理

 @param delegate delegate description
 */
- (void)setYSEPayDelegate:(id<YSEPayDelegate>)delegate;

/**
 获取代理

 @return return value description
 */
- (id<YSEPayDelegate>)getYSEPayDelegate;

/**
 设置是否打印log

 @param isPrint isPrint description
 */
- (void)setPrintLog:(BOOL)isPrint;

/**
 是否安装支付宝APP

 @return return value description
 */
- (BOOL)isAliPayAppInstalled;

/**
 是否安装微信APP

 @return return value description
 */
- (BOOL)isWeChatAppInstalled;

/**
 当前版本号
 
 @return return value description
 */
- (NSString *)currentVersion;

#pragma mark - Send Request
/**
 发送 YSEPay Request

 @param req 请求体
 @return 请求是否成功
 */
- (BOOL)sendYSEPayRequest:(YSEPayBaseReq *)req;

#pragma mark - UIApplication delegate 需要实现下面的代理方法
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end
