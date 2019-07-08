//
//  Api.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import "Api.h"
#import "XQCNetworking.h"
#import "PaySDKHeader.h"
#import "WXApi.h"
@implementation Api

#define manager [XQCPayManager defaultManager]

+ (void)queryOrder:(NSString *)orderId PayType:(nonnull NSString *)paytype reuslt:(void (^)(ResponseModel *))result{
    if ([manager getMerchantId]) {
        NSMutableDictionary *para = [@{
                                       @"outTradeNo": orderId,
                                       @"merchantId":[manager getMerchantId],
                                       @"queryType": @"1"
                                       } mutableCopy];
        [XQCNetworking PostWithURL:[manager GetQuerUrl] Params:para keyValue:[manager getSignKey] success:^(id  _Nonnull responseObject) {
            ResponseModel *model = [[ResponseModel alloc] initWithDict:responseObject];
            model.payType = paytype;
            result(model);
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
}


+ (void)checkPayPwd:(NSString *)password reuslt:(nonnull void (^)(PasswordModel * _Nonnull))result error:(nonnull void (^)(NSString * _Nonnull))errorMsg{
    NSMutableDictionary *para = [@{
                                   @"agentNo": [manager getAgentNo],
                                   @"companyOpenId":[manager getCompanyOpenId],
                                   @"userOpenId": [manager getUserOpenId],
                                   @"password" : password
                                   } mutableCopy];
    [XQCNetworking PostWithURL:[manager GetPasswordUrl] Params:para keyValue:[manager getAgentKey] success:^(id  _Nonnull responseObject) {
        PasswordModel *model = [[PasswordModel alloc] initWithDict:responseObject];
        result(model);
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"error >>>%@",error);
        errorMsg(error);
    }];
}

+ (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void (^)(NSArray * _Nonnull))res {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:agentNo forKey:@"agentNo"];
    [params setValue:channelType forKey:@"channelType"];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [XQCNetworking PostWithURL:[manager GetChannelUrl] Params:params keyValue:[manager getAgentKey] success:^(id  _Nonnull responseObject) {
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


+ (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(void (^)(NSArray * _Nonnull))res {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [XQCNetworking PostWithURL:[manager GetWhitesTripUrl] Params:[@{@"agentNo":agentNo,@"companyOpenId":companyOpenId,@"userOpenId":userOpenId} mutableCopy] keyValue:[manager getAgentKey] success:^(id  _Nonnull responseObject) {
        NSLog(@"whitestripUrl%@",responseObject);
        for (NSDictionary *dict in responseObject[@"data"]) {
            WhitestripModel *model = [[WhitestripModel alloc] initWithDict:dict];
            [list addObject:model];
        }
        res(list);
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"error->%@",error);
    }];
}

+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode FeeType:(feeType)myFeeType viewController:(nonnull UIViewController *)vc error:(nonnull void (^)(NSString * _Nonnull))errorMsg{
    NSMutableDictionary *para = [@{
                                   @"amount": [NSString stringWithFormat:@"%ld",(long)(amount*100)],
                                   @"bizCode": bizCode,
                                   @"body": body,
                                   @"merchantId": [manager getMerchantId],
                                   @"outTradeNo":orderId,
                                   @"notifyUrl":[manager getNotify],
                                   @"feeType" : @(myFeeType),
                                   } mutableCopy];
    
    if ([bizCode integerValue] == 7104) {
        para[@"iousCode"] = iousCode;
        para[@"companyOpenId"] = [manager getCompanyOpenId];
        para[@"userOpenId"] = [manager getUserOpenId];
    }
    [XQCNetworking PostWithURL:[manager GetOrderUrl] Params:para keyValue:[manager getSignKey] success:^(id  _Nonnull responseObject) {
        NSLog(@"order>>%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] intValue] != 0000) {
                errorMsg(responseObject[@"msg"]);
                return;
            }
            if ([type isEqualToString:WECHATPAY_YS] || [type isEqualToString:ALIPAY_YS]) {
                YSEPayReq *payReq = [[YSEPayReq alloc] init];
                payReq.channel = [type isEqualToString:WECHATPAY_YS] ? YSEPayChannelWxApp : YSEPayChannelAliApp;
                payReq.payInfo = responseObject[@"payInfo"];
                payReq.tradeNo = responseObject[@"tradeNo"];
                payReq.outTradeNo = responseObject[@"outTransactionId"];
                payReq.partnerId = [manager getPartnerId];//"XQC_payforapp"//resp["merchantId"]
                payReq.privatePassword = [manager getPassword];//"xQcMy20Pwd19"
                payReq.type = YSEPayEvenTypePayReq;
                payReq.viewController = vc;
                [[YSEPay sharedInstance] sendYSEPayRequest:payReq] ? errorMsg(@"") : errorMsg(@"请求失败");
            }else if ([type isEqualToString:WECHATPAY]) {
                NSError * error = nil;
                NSData *jsondata = [responseObject[@"payInfo"] dataUsingEncoding:(NSUTF8StringEncoding)];
                NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&error];
                if (error) {
                    errorMsg([NSString stringWithFormat:@"%@",error]);
                    return;
                }
                UInt32 time = [[self getNowTimeTimestamp] intValue];
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = getDict[@"partnerid"];
                request.prepayId = getDict[@"prepayid"];
                request.package = getDict[@"package"];
                request.nonceStr = getDict[@"noncestr"];
                request.timeStamp = time;
                request.sign = getDict[@"sign"];
                [WXApi sendReq:request];
                errorMsg(@"");
            }else if ([type isEqualToString:ALIPAY]) {
                [[AlipaySDK defaultService] payOrder:@"" fromScheme:@"" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
                errorMsg(@"");
            }else if ([type isEqualToString:IOUSPAY]) {
                errorMsg(@"");
            }else if ([type isEqualToString:ALIPAY_HYL]){
                [UMSPPPayUnifyPayPlugin payWithPayChannel:CHANNEL_ALIPAY payData:responseObject[@"payInfo"] callbackBlock:^(NSString *resultCode, NSString *resultInfo) {
//                    支付宝这里拿不到回调
//                    if (resultCode.intValue == 0000) {
//                        errorMsg(@"");
//                    }else {
//                        errorMsg(resultCode);
//                    }
                }];
                errorMsg(@"");
            }
        });
    } failure:^(NSString * _Nonnull error) {
        errorMsg(error);
    }];
}


+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}
@end
