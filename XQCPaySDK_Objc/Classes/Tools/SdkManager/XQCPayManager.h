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
#import "UMSPPPayUnifyPayPlugin.h"
#import "UMSPPPayPluginSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 费用类型
 
 - feeTypeShop: 薪商城
 - feeTypeLife: 本地生活
 - feeTypeGift: 薪礼
 - feeTypeBanquet: 宴请
 - feeTypeWelfare: 薪福利
 - feeTypeCollection: 薪集采
 - feeTypeTel: 话费
 */
typedef NS_ENUM(NSUInteger, feeType) {
    feeTypeShop = 1001,
    feeTypeLife = 1002,
    feeTypeGift = 1003,
    feeTypeBanquet = 1004,
    feeTypeWelfare = 1005,
    feeTypeCollection = 1006,
    feeTypeTel = 1007,
};

static NSString *WECHATPAY_YS = @"WECHATPAY_YS";
static NSString *ALIPAY_YS = @"ALIPAY_YS";
static NSString *ALIPAY = @"ALIPAY";
static NSString *WECHATPAY = @"WECHATPAY";
static NSString *IOUSPAY = @"IOUSPAY";


@interface XQCPayManager : NSObject

// 单例
+ (instancetype)defaultManager;

@property (nonatomic,copy)void(^result)(ResponseModel *model);
// 弹窗忘记密码回调
//@property (nonatomic,copy)void(^ForgetPassword)(void);
/**
 配置接口地址

 @param url 接口域名
 */
- (void)setConfig:(NSString *)url;

/**
 统一下单url

 @return url
 */
- (NSString *)GetOrderUrl;

/**
 订单查询url

 @return url
 */
- (NSString *)GetQuerUrl;

/**
 渠道url

 @return url
 */
- (NSString *)GetChannelUrl;

/**
 白条查询url

 @return url
 */
- (NSString *)GetWhitesTripUrl;

/**
 校验支付密码rurl

 @return url
 */
- (NSString *)GetPasswordUrl;

/**
 设置微信key

 @param wechatKey 微信key
 */
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


/**
 设置companyOpenId

 @param companyOpenId companyOpenId
 */
- (void)setCompanyOpenId:(NSString *)companyOpenId;



/**
 设置userOpenId

 @param userOpenId setUserOpenId
 */
- (void)setUserOpenId:(NSString *)userOpenId;

/**
 获取商户签名

 @return NSString
 */
- (NSString *)getSignKey;

/**
 获取代理商签名

 @return NSString
 */
- (NSString *)getAgentKey;

/**
 获取代理商编号

 @return NSString
 */
- (NSString *)getAgentNo;

/**
 获取企业唯一标识

 @return NSString
 */
- (NSString *)getCompanyOpenId;

/**
 获取用户唯一标识

 @return NSString
 */
- (NSString *)getUserOpenId;

/**
 获取平台商户号

 @return NSString
 */
- (NSString *)getMerchantId;

/**
 获取回调地址

 @return NSString
 */
- (NSString *)getNotify;

/**
 获取银盛商户名

 @return NSString
 */
- (NSString *)getPartnerId;

/**
 获取银盛证书密码

 @return NSString
 */
- (NSString *)getPassword;

/**
 获取渠道

 @param channelType 渠道类型
 @param agentNo 代理商编号
 @param res 结果
 */
+ (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void(^)(NSArray *list))res;

/**
 获取白条

 @param agentNo 代理商编号
 @param companyOpenId 企业唯一标识
 @param userOpenId 用户唯一标识
 @param res 结果
 */
+ (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(void(^)(NSArray *list))res;

/**
 统一下单

 @param amount 金额
 @param type 支付类型
 @param bizCode 交易类型
 @param body 订单描述
 @param orderId 订单id
 @param iousCode 白条编码
 @param vc 控制器
 @param result 结果
 */
+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode FeeType:(feeType)Mytype viewController:(UIViewController *)vc reuslt:(void(^)(ResponseModel *model))result;

/**
 交易支付密码

 @param password 密码
 @param result 结果
 */
+ (void)checkPayPwd:(NSString *)password reuslt:(void(^)(PasswordModel *model))result;

/**
 查询订单

 @param orderId 订单id
 @param result 结果
 */
+ (void)queryOrder:(NSString *)orderId reuslt:(void(^)(ResponseModel *model))result;

/**
 处理通过URL唤起APP的URL
 
 @param url url description
 @return return value description
 */
+ (BOOL)handler:(NSURL *)url;


/**
 后台回到前台

 @param application application
 */
+ (void)applicationWillEnterForeground:(UIApplication *)application;


/**
 密码框唤起

 @param success 校验成功回调
 */
+ (void)showPasswordViewControllerResult:(void(^)(void))success;


+ (void)setUmspEnviroment:(UMSPluginEnvironment)enviroment;
@end

NS_ASSUME_NONNULL_END
