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
        self.payState = [[dict valueForKey:@"payState"] integerValue];
        self.payTime = [dict valueForKey:@"payTime"];
        self.tradeNo = [dict valueForKey:@"tradeNo"];
        self.outTransactionId = [dict valueForKey:@"outTransactionId"];
        
        switch (self.payState) {
            case 0:
                self.message = @"待支付";
                break;
            case 1:
                self.message = @"支付成功";
                break;
            case 2:
                self.message = @"支付失败";
                break;
            case 3:
                self.message = @"已冲正";
                break;
            case 4:
                self.message = @"已撤销";
                break;
            case 5:
                self.message = @"转入退款";
                break;
            case 9:
                self.message = @"交易关闭";
                break;
            case 10:
                self.message = @"用户取消";
                break;
            default:
                self.message = @"未知";
                break;
        }
    }
    return self;
}
@end
