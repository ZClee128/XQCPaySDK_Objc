//
//  ResponseModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResponseModel : NSObject

// 金额
@property (nonatomic,copy)NSString *amount;
// 商户订单号
@property (nonatomic,copy)NSString *outTradeNo;
// 商户号
@property (nonatomic,copy)NSString *merchantId;
// 订单实际支付状态
@property (nonatomic,assign)NSInteger payState;
// 订单支付时间
@property (nonatomic,copy)NSString *payTime;
// 平台订单号
@property (nonatomic,copy)NSString *tradeNo;
// 第三方支付订单号
@property (nonatomic,copy)NSString *outTransactionId;
// 支付回调结果信息
@property (nonatomic,copy)NSString *message;
// 支付渠道类型
@property (nonatomic,copy)NSString *payType;
// 返回按钮标识
//@property (nonatomic,assign) BOOL  isBack;
- (id)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
