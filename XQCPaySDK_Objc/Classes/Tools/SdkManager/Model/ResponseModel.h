//
//  ResponseModel.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResponseModel : NSObject

@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *outTradeNo;
@property (nonatomic,copy)NSString *merchantId;
@property (nonatomic,copy)NSString *payState;
@property (nonatomic,copy)NSString *payTime;
@property (nonatomic,copy)NSString *tradeNo;
@property (nonatomic,copy)NSString *outTransactionId;

- (id)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
