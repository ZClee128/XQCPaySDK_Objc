//
//  XQCPayManager.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>
#import "ChannelModel.h"
#import "WhitestripModel.h"
#import "PasswordModel.h"
#import "ResponseModel.h"
#import <YSEPaySDK/YSEPay.h>
NS_ASSUME_NONNULL_BEGIN

static NSString *WECHATPAY_YS = @"WECHATPAY_YS";
static NSString *ALIPAY_YS = @"ALIPAY_YS";
static NSString *ALIPAY = @"ALIPAY";
static NSString *WECHATPAY = @"WECHATPAY";
static NSString *IOUSPAY = @"IOUSPAY";


@interface XQCPayManager : NSObject

// 单例
+ (instancetype)defaultManager;

@property (nonatomic,copy)void(^reuslt)(ResponseModel *model);
/**
 配置接口地址

 @param url 接口域名
 */
- (void)setConfig:(NSString *)url;

- (NSString *)GetOrderUrl;

- (NSString *)GetQuerUrl;

- (NSString *)GetChannelUrl;

- (NSString *)GetWhitesTripUrl;

- (NSString *)GetPasswordUrl;

- (void)setWechatKey:(NSString *)wechatKey;

/**
 设置参数

 @param Key 商户key
 @param agentKey 代理key
 @param merchantId 平台商户号
 @param partnerId 银盛商户名
 @param password 银盛证书密码
 @param notify 回调地址 
 @param agentNo 代理商编号
 @param companyOpenId 企业唯一标识
 @param userOpenId 用户唯一标识
 */
- (void)setMacSignKey:(NSString *)Key AgentKey:(NSString *)agentKey MerchantId:(NSString *)merchantId PartnerId:(NSString *)partnerId Password:(NSString *)password Notify:(NSString *)notify AgentNo:(NSString *)agentNo CompanyOpenId:(NSString *)companyOpenId UserOpenId:(NSString *)userOpenId;

- (NSString *)getSignKey;

- (NSString *)getAgentKey;

- (NSString *)getAgentNo;

- (NSString *)getCompanyOpenId;

- (NSString *)getUserOpenId;

- (NSString *)getMerchantId;

- (NSString *)getNotify;

- (NSString *)getPartnerId;

- (NSString *)getPassword;
- (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void(^)(NSArray *list))res;
- (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(void(^)(NSArray *list))res;
+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode viewController:(UIViewController *)vc reuslt:(void(^)(ResponseModel *model))result;
+ (void)checkPayPwd:(NSString *)password reuslt:(void(^)(PasswordModel *model))result;
+ (void)queryOrder:(NSString *)orderId reuslt:(void(^)(ResponseModel *model))result;

/**
 处理通过URL唤起APP的URL
 
 @param url url description
 @return return value description
 */
+ (BOOL)handler:(NSURL *)url;
+ (void)applicationWillEnterForeground:(UIApplication *)application;
@end

NS_ASSUME_NONNULL_END
