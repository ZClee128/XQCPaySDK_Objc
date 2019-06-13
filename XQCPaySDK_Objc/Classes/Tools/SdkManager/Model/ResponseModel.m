//
//  ResponseModel.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import "ResponseModel.h"

@implementation ResponseModel

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.amount = [NSString stringWithFormat:@"%.2f",[[dict valueForKey:@"amount"] floatValue] / 100];
        self.outTradeNo = [dict valueForKey:@"outTradeNo"];
        self.merchantId = [dict valueForKey:@"merchantId"];
        self.payState = [dict valueForKey:@"payState"];
        self.payTime = [dict valueForKey:@"payTime"];
        self.tradeNo = [dict valueForKey:@"tradeNo"];
        self.outTransactionId = [dict valueForKey:@"outTransactionId"];
    }
    return self;
}
@end
