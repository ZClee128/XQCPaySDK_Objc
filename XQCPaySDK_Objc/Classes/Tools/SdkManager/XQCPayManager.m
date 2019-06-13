//
//  XQCPayManager.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayManager.h"
#import "XQCNetworking.h"
#import "Api.h"
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
///   - merchantId: 平台商户号
///   - partnerId: 银盛商户名
///   - password: 银盛证书密码
///   - notify: 回调地址
///   - agentNo: 代理商编号
@property (nonatomic,copy)NSString *merchantId;
@property (nonatomic,copy)NSString *partnerId;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *notify;
@property (nonatomic,copy)NSString *agentNo;
@property (nonatomic,copy)NSString *companyOpenId;
@property (nonatomic,copy)NSString *userOpenId;


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
    [Api getChannels:channelType agentNo:agentNo respon:^(NSArray * _Nonnull list) {
        res(list);
    }];
}


- (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(nonnull void (^)(NSArray * _Nonnull))res {
    if (self.agentKey.length == 0 && self.agentKey == nil) {
        NSLog(@"agentKey不能为空");
        return;
    }
    if (agentNo.length == 0) {
        NSLog(@"agentNo不能为空");
        return;
    }
    
    if (companyOpenId.length == 0) {
        NSLog(@"companyOpenId不能为空");
        return;
    }
    if (userOpenId.length == 0) {
        NSLog(@"userOpenId不能为空");
        return;
    }
    [Api whitestripAgentNo:agentNo companyOpenId:companyOpenId userOpenId:userOpenId respon:^(NSArray * _Nonnull list) {
        res(list);
    }];
}

+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode viewController:(UIViewController *)vc reuslt:(nonnull void (^)(ResponseModel * _Nonnull))result{
    [Api payRequsetAmount:amount payType:type bizCode:bizCode Body:body orderId:orderId iousCode:iousCode viewController:vc error:^(NSString * _Nonnull error) {
        if ([type isEqualToString:IOUSPAY]) {
            [self queryOrder:orderId reuslt:result];
        }
    }];
}

+ (void)checkPayPwd:(NSString *)password reuslt:(nonnull void (^)(PasswordModel * _Nonnull))result{
    [Api checkPayPwd:password reuslt:result];
}

+ (void)queryOrder:(NSString *)orderId reuslt:(nonnull void (^)(ResponseModel * _Nonnull))result {
    [Api queryOrder:orderId reuslt:result];
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

- (void)setMacSignKey:(NSString *)Key AgentKey:(NSString *)agentKey MerchantId:(NSString *)merchantId PartnerId:(NSString *)partnerId Password:(NSString *)password Notify:(NSString *)notify AgentNo:(NSString *)agentNo CompanyOpenId:(NSString *)companyOpenId UserOpenId:(NSString *)userOpenId {
    self.signKey = Key;
    self.agentKey = agentKey;
    self.merchantId = merchantId;
    self.partnerId = partnerId;
    self.password = password;
    self.notify = notify;
    self.agentNo = agentNo;
    self.companyOpenId = companyOpenId;
    self.userOpenId = userOpenId;
}

- (NSString *)getSignKey{
    return _signKey;
}

- (NSString *)getAgentKey {
    return _agentKey;
}

- (NSString *)getAgentNo {
    return _agentNo;
}

- (NSString *)getCompanyOpenId {
    return _companyOpenId;
}

- (NSString *)getUserOpenId {
    return _userOpenId;
}

- (NSString *)getMerchantId {
    return _merchantId;
}

- (NSString *)getNotify {
    return _notify;
}

- (NSString *)getPartnerId {
    return _partnerId;
}

- (NSString *)getPassword {
    return _password;
}

- (void)setWechatKey:(NSString *)wechatKey {
    [[YSEPay sharedInstance] configureWeChatPay:wechatKey];
    
}

@end
