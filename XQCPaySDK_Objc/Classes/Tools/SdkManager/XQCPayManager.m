//
//  XQCPayManager.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayManager.h"
#import "XQCNetworking.h"
#import "ChannelModel.h"
#import <YSSDK/YSSDK.h>
#import <YSEPaySDK/YSEPay.h>
@interface XQCPayManager()
// 统一下单
@property (nonatomic,copy)NSString *orderUrl;
// 查询订单
@property (nonatomic,copy)NSString *queryUrl;
// 渠道查询
@property (nonatomic,copy)NSString *getChannelUrl;
// 白条查询
@property (nonatomic,copy)NSString *whitestripUrl;
// 验证支付密码
@property (nonatomic,copy)NSString *payPasswordUrl;
// 商家key
@property (nonatomic,copy)NSString *signKey;
// 代理key
@property (nonatomic,copy)NSString *agentKey;
@end

@implementation XQCPayManager

static XQCPayManager *_sharedManager = nil;

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [XQCPayManager new];
    });
    
    return _sharedManager;
}

- (void)setConfig:(NSString *)url {
    self.orderUrl = [NSString stringWithFormat:@"%@/api/v1/trade/unifiedPay",url];
    self.queryUrl = [NSString stringWithFormat:@"%@/api/v1/trade/query",url];
    self.getChannelUrl = [NSString stringWithFormat:@"%@/api/v1/trade/channelQuery",url];
    self.whitestripUrl = [NSString stringWithFormat:@"%@/api/v1/trade/iousQuery",url];
    self.payPasswordUrl = [NSString stringWithFormat:@"%@/api/v1/trade/checkPayPwd",url];
}

- (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void (^)(NSArray * _Nonnull))res{
    NSAssert(self.getChannelUrl != nil, @"支付渠道获取地址不能为空， OC 请使用 [XQCPayManager configWithUrl:@\"\" query:@\"\" channelControl:@\"\"];");
    [XQCNetworking PostWithURL:self.getChannelUrl Params:[@{@"agentNo":agentNo,@"channelType":channelType} mutableCopy] keyValue:self.signKey success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (NSString *)GetOrderUrl {
    return self.orderUrl;
}

- (NSString *)GetQuerUrl {
    return self.queryUrl;
}

- (NSString *)GetChannelUrl {
    return self.getChannelUrl;
}

- (NSString *)GetWhitesTripUrl {
    return self.whitestripUrl;
}

- (NSString *)GetPasswordUrl {
    return self.payPasswordUrl;
}

- (void)setSignKey:(NSString *)signKey {
    self.signKey = signKey;
}

- (void)setAgentKey:(NSString *)agentKey {
    self.agentKey = agentKey;
}

- (NSString *)getSignKey{
    return self.signKey;
}

- (NSString *)getAgentKey {
    return self.agentKey;
}

- (void)setWechatKey:(NSString *)wechatKey {
    [[YSEPay sharedInstance] configureWeChatPay:wechatKey];
    
}

@end
