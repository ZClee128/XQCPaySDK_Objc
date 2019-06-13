//
//  YSEPayObjects.h
//  YSEPaySDK
//
//  Created by JoakimLiu on 2017/4/20.
//  Copyright © 2017年 银盛通信有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求事件类型

 - YSEPayEvenTypeBaseReq: 基础请求
 - YSEPayEvenTypePayReq: 支付请求
 
 - YSEPayEvenTypeBaseReqResp: 基础返回
 - YSEPayEvenTypePayResp: 支付返回
 */
typedef NS_ENUM(NSInteger, YSEPayEventType) {
    YSEPayEvenTypeBaseReq = 100,
    YSEPayEvenTypePayReq,
    
    YSEPayEvenTypeBaseReqResp = 200,
    YSEPayEvenTypePayResp,
};

/**
 支付渠道

 - YSEPayChannelUnsupport: 暂不支持
 - YSEPayChannelWxApp: 微信APP支付
 - YSEPayChannelAliApp: 支付宝支付
 - YSEPayChannelQQApp: QQ钱包支付
 */

typedef NS_ENUM(NSInteger, YSEPayChannel) {
    YSEPayChannelUnsupport = 0,
    YSEPayChannelWxApp = 1902000,
    YSEPayChannelAliApp = 1903000,
    YSEPayChannelQQApp = 1904000,
};

/**
 响应码

 - YSEPayResultCodeSuccess: 成功
 - YSEPayResultCodeCommon: 参数错误
 - YSEPayResultCodeUserCancel: 用户点击取消并返回
 - YSEPayResultCodeSentFail: 发送失败
 - YSEPayResultCodeUnsupport: 暂不支持
 - YSEPayResultCodeClose: 订单已关闭
 */
typedef NS_ENUM(NSInteger, YSEPayResultCode) {
    YSEPayResultCodeSuccess    = 0,
    YSEPayResultCodeCommon     = -1,
    YSEPayResultCodeUserCancel = -2,
    YSEPayResultCodeSentFail   = -3,
    YSEPayResultCodeUnsupport  = -4,
    YSEPayResultCodeClose      = -5,
};

static NSString * const kYSDateFormat = @"yyyy-MM-dd HH:mm";

#pragma mark - 请求实体基类
/**
 请求实体基类
 */
@interface YSEPayBaseReq : NSObject<NSCopying>
// 事件类型，默认是 YSEPayTypeBaseReqResp
@property (nonatomic, assign) YSEPayEventType type;
// 银盛商户id
@property (nonatomic, copy) NSString *partnerId;
// 银盛服务器订单id
@property (nonatomic, copy) NSString *tradeNo;
// 商户服务器订单id
@property (nonatomic, copy) NSString *outTradeNo;
// 商户私钥密码
@property (nonatomic, copy) NSString *privatePassword;
@end

#pragma mark - 返回实体基类
/**
 返回实体基类
 */
@interface YSEPayBaseResp : NSObject<NSCopying>
// 事件类型，默认是 YSEPayEvenTypeBaseReqResp
@property (nonatomic, assign) YSEPayEventType type;
// 响应码，默认是 YSEPayResultCodeCommon
@property (nonatomic, assign) YSEPayResultCode resultCode;
// 响应提示字符串，默认是 @""
@property (nonatomic, copy) NSString *resultMsg;
// 请求
@property (nonatomic, strong) YSEPayBaseReq *request;

- (instancetype)initWithReq:(YSEPayBaseReq *)request;
@end

