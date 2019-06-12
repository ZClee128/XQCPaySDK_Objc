//
//  XQCPayManager.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>
#import "ChannelModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface XQCPayManager : NSObject

// 单例
+ (instancetype)defaultManager;

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

- (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void(^)(NSArray *list))res;
- (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(void(^)(NSArray *list))res;
@end

NS_ASSUME_NONNULL_END
