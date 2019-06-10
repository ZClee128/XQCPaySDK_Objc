//
//  XQCPayManager.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <Foundation/Foundation.h>

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
 设置商户key

 @param signKey 商户key
 */
- (void)setSignKey:(NSString *)signKey;

- (NSString *)getSignKey;

/**
 设置代理商key

 @param agentKey 代理商key
 */
- (void)setAgentKey:(NSString *)agentKey;
- (NSString *)getAgentKey;

- (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void(^)(NSArray *list))res;
@end

NS_ASSUME_NONNULL_END
