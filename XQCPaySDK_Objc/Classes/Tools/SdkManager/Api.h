//
//  Api.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>
#import "XQCPayManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface Api : NSObject

+ (void)getChannels:(NSString *)channelType agentNo:(NSString *)agentNo respon:(void(^)(NSArray *list))res;
+ (void)whitestripAgentNo:(NSString *)agentNo companyOpenId:(NSString *)companyOpenId userOpenId:(NSString *)userOpenId respon:(void(^)(NSArray *list))res;
+ (void)payRequsetAmount:(CGFloat)amount payType:(NSString *)type bizCode:(NSString *)bizCode Body:(NSString *)body orderId:(NSString *)orderId iousCode:(NSString *)iousCode FeeType:(int )myFeeType viewController:(UIViewController *)vc error:(void(^)(NSString *error))errorMsg;
+ (void)checkPayPwd:(NSString *)password reuslt:(void(^)(PasswordModel *model))result error:(void(^)(NSString *errorMsg))errorMsg;
+ (void)queryOrder:(NSString *)orderId PayType:(NSString *)paytype reuslt:(void(^)(ResponseModel *model))result error:(void(^)(NSString *errorMsg))errorMsg;
@end

NS_ASSUME_NONNULL_END
