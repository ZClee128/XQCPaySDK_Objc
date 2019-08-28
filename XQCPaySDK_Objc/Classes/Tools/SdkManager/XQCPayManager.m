//
//  XQCPayManager.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayManager.h"
#import "XQCNetworking.h"
#import "Api.h"
#import "PaySDKHeader.h"
#import "XQCPaymentPasswordInputView.h"
#import "ReactiveObjC.h"
#import "PayAlertView.h"


static NSString *outTradeNo = @"";
static NSString *PayType = @"";
static BOOL isEnterForeground = NO;

@interface XQCPayManager()<YSEPayDelegate>
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

@property (nonatomic,copy)NSString *baseUrl;
@property (nonatomic,copy)NSString *wechatuserName;
@property (nonatomic,copy)NSString *aliSchemes;
@property (nonatomic,assign)WXMiniProgramType miniProgramType;
@property (nonatomic,copy)NSString *channelType;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[YSEPay sharedInstance] setYSEPayDelegate:self];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    }
    return self;
}

- (void)setConfig:(NSString *)url {
    self.baseUrl = url;
    self.orderUrl = [NSString stringWithFormat:@"%@/api/v1/trade/unifiedPay",url];
    self.queryUrl = [NSString stringWithFormat:@"%@/api/v1/trade/query",url];
//    self.getChannelUrl = [NSString stringWithFormat:@"%@/api/v1/trade/channelQuery",url];
    self.whitestripUrl = [NSString stringWithFormat:@"%@/api/v1/trade/iousQuery",url];
    self.payPasswordUrl = [NSString stringWithFormat:@"%@/api/v1/trade/checkPayPwd",url];
    self.getChannelUrl = [NSString stringWithFormat:@"%@/api/v1/combopay/app/v1/getchannels",url];
}

- (void)setWeChatUserName:(NSString *)userName miniProgramType:(WXMiniProgramType)type{
    _wechatuserName = userName;
    _miniProgramType = type;
}

- (void)setAliPaySchemes:(NSString *)schemes {
    _aliSchemes = schemes;
}

+ (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void (^)(NSArray * _Nonnull))res{
    [Api getChannels:channelType agentNo:agentNo respon:^(NSArray * _Nonnull list) {
        res(list);
    }];
}

- (void)setProhibitChannelType:(NSString *)channelType {
    _channelType = channelType;
}

+ (NSString *)getChannelType {
    if (_sharedManager.channelType == nil) {
        return @"";
    }
    return _sharedManager.channelType;
}

+ (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(nonnull void (^)(NSArray * _Nonnull))res {
    if ([_sharedManager getAgentKey].length == 0 && [_sharedManager getAgentKey] == nil) {
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

+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode FeeType:(int)Mytype viewController:(nonnull UIViewController *)vc reuslt:(nonnull void (^)(ResponseModel * _Nonnull))result {
    PayType = type;
    [SVProgressHUD showWithStatus:@"  支付中   "];
    [Api payRequsetAmount:amount payType:type bizCode:bizCode Body:body orderId:orderId iousCode:iousCode FeeType:Mytype viewController:vc error:^(NSString * _Nonnull error) {
        if ([error isEqualToString:@""]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }else {
            [SVProgressHUD showErrorWithStatus:error];
            return;
        }
        if ([type isEqualToString:IOUSPAY]) {
            [self queryOrder:orderId reuslt:result error:^(NSString * _Nonnull errorMsg) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }else {
            result([[ResponseModel alloc] init]);
        }
        outTradeNo = orderId;
    }];
}

+ (void)checkPayPwd:(NSString *)password reuslt:(nonnull void (^)(PasswordModel * _Nonnull))result error:(nonnull void (^)(NSString * _Nonnull))errorMsg{
    [Api checkPayPwd:password reuslt:result error:errorMsg];
}

+ (void)queryOrder:(NSString *)orderId reuslt:(nonnull void (^)(ResponseModel * _Nonnull))result error:(nonnull void (^)(NSString * _Nonnull))errorMsg{
    [Api queryOrder:orderId PayType:PayType reuslt:result error:errorMsg];
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

- (void)setCompanyOpenId:(NSString *)companyOpenId {
    _companyOpenId = companyOpenId;
}

- (void)setUserOpenId:(NSString *)userOpenId {
    _userOpenId = userOpenId;
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

+ (NSString *)getAliSchemes {
    return _sharedManager.aliSchemes;
}

- (void)setWechatKey:(NSString *)wechatKey {
    [[YSEPay sharedInstance] configureWeChatPay:wechatKey];
     [UMSPPPayUnifyPayPlugin registerApp:wechatKey];
}

+ (void)setUmspEnviroment:(UMSPluginEnvironment)enviroment {
    [UMSPPPayPluginSettings sharedInstance].umspEnviroment = enviroment;
}

+ (BOOL)handler:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return NO;
    }
    if ([PayType isEqualToString:WECHATPAY_YS] || [PayType isEqualToString:WECHATPAY]) {
        return [[YSEPay sharedInstance] handleApplicationOpenURL:url];
    }else {
        return [UMSPPPayUnifyPayPlugin handleOpenURL:url];
    }
    
}


+ (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([PayType isEqualToString:ALIPAY_YS] || [PayType isEqualToString:WECHATPAY_YS]) {
        [[YSEPay sharedInstance] applicationWillEnterForeground:application];
    }
    if (_sharedManager.isPay) {
        [_sharedManager setValue:@(NO) forKey:NSStringFromSelector(@selector(isPay))];
        [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
            [self queryOrder:outTradeNo reuslt:^(ResponseModel * _Nonnull model) {
                if ([XQCPayManager defaultManager].result) {
                    [XQCPayManager defaultManager].result(model);
                }
            }error:^(NSString * _Nonnull errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }];
        }];
    }
}


+ (void)showPasswordViewControllerResult:(void (^)(void))success {
    [[[XQCPaymentPasswordInputView alloc] initWithStyle:(XQCPaymentIousPasswordStyleLimit) payButtonclick:^RACSignal * _Nonnull(NSString * _Nonnull pwd) {
        [[RACScheduler mainThreadScheduler] schedule:^{
           [SVProgressHUD showWithStatus:@""];
        }];
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [XQCPayManager checkPayPwd:pwd reuslt:^(PasswordModel * _Nonnull Passmodel) {
                if ([Passmodel.state intValue] == 1) {
                    [[RACScheduler mainThreadScheduler] schedule:^{
                        [SVProgressHUD dismiss];
                    }];
                    success();
                    [subscriber sendCompleted];
                }else {
                    [[RACScheduler mainThreadScheduler] schedule:^{
                        [SVProgressHUD showErrorWithStatus:Passmodel.info];
                        [subscriber sendCompleted];
//                        [self showAlertViewWithTitle:@"支付密码错误，请重试！" leftBtnTitle:@"重试" rightBtnTitle:@"忘记密码" leftBolck:^{
//                            [self showPasswordViewControllerResult:success];
//                        } rightBlock:^{
//                            if (_sharedManager.ForgetPassword) {
//                                _sharedManager.ForgetPassword();
//                            }
//                        }];
                    }];
                }
            } error:^(NSString * _Nonnull errorMsg) {
                [[RACScheduler mainThreadScheduler] schedule:^{
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }] deliverOn:[RACScheduler mainThreadScheduler]];
    }] show];
}


+ (void)showAlertViewWithTitle:(NSString *)title leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle leftBolck:(void (^)(void))leftBlock rightBlock:(void (^)(void))rightBlock {
    PayAlertView *payAler = [[PayAlertView alloc] initWithWithTitle:title leftBtnTitle:leftTitle rightBtnTitle:rightTitle leftBolck:leftBlock rightBlock:rightBlock];
    [payAler show];
}

+ (BOOL)sendWexinMiniPayWithBizCode:(NSString *)bizCode amount:(CGFloat)amount outTradeNo:(NSString *)outTrade body:(NSString *)body feeType:(int )type{
    XQCPayManager *manager = [XQCPayManager defaultManager];
    outTradeNo = outTrade;
    PayType = WECHATPAY_MINI_HYL;
    NSString *base = [self encode:[NSString stringWithFormat:@"%@/api/v1",manager.baseUrl]];
    NSString *notityUrl = [self encode:[NSString stringWithFormat:@"%@",manager.notify]];
    NSString *url = [NSString stringWithFormat:@"%@&merchantId=%@&bizCode=%@&amount=%@&outTradeNo=%@&body=%@&notifyUrl=%@&feeType=%lu&key=%@",base,manager.merchantId,bizCode,[NSString stringWithFormat:@"%.f",[[NSString stringWithFormat:@"%.2f",amount] floatValue] * 100],outTrade,body,notityUrl,(unsigned long)type,manager.signKey];
//    NSLog(@"url>>>%@",url);
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = manager.wechatuserName; //拉起的小程序的username
    launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/ums/result?requestUrl=%@",url]; //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//    NSLog(@"path>>>%@",launchMiniProgramReq.path);
    launchMiniProgramReq.miniProgramType = manager.miniProgramType; //拉起小程序的类型
    return [WXApi sendReq:launchMiniProgramReq];
}

+ (NSString *)encode:(NSString *)url {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

#pragma mark =======================YSEPayDelegate================

//- (void)onYSEPayResp:(YSEPayBaseResp *)resp {
//    if (!isEnterForeground) {
//        isEnterForeground = NO;
//        [XQCPayManager queryOrder:outTradeNo reuslt:^(ResponseModel * _Nonnull model) {
//            if (self.result) {
//                self.result(model);
//            }
//        }];
//    }
//}
@end
