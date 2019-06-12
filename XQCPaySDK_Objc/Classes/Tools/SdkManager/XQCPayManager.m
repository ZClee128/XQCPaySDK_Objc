//
//  XQCPayManager.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayManager.h"
#import "XQCNetworking.h"
#import <MJExtension/MJExtension.h>
//#import <YSSDK/YSSDK.h>
//#import <YSEPaySDK/YSEPay.h>
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:agentNo forKey:@"agentNo"];
    [params setValue:channelType forKey:@"channelType"];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [XQCNetworking PostWithURL:self.getChannelUrl Params:params keyValue:self.agentKey success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject%@",responseObject);
        for (NSDictionary *dict in responseObject[@"data"]) {
            ChannelModel *model = [[ChannelModel alloc] initWithDict:dict];
            [list addObject:model];
        }
        res(list);
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"error->%@",error);
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
    [XQCNetworking PostWithURL:self.whitestripUrl Params:[@{@"agentNo":agentNo,@"companyOpenId":companyOpenId,@"userOpenId":userOpenId} mutableCopy] keyValue:self.agentKey success:^(id  _Nonnull responseObject) {
        NSLog(@"whitestripUrl%@",responseObject);
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"error->%@",error);
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

- (void)setWechatKey:(NSString *)wechatKey {
//    [[YSEPay sharedInstance] configureWeChatPay:wechatKey];
    
}

@end
