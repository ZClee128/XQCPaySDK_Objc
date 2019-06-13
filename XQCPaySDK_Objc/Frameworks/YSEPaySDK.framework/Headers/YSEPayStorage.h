//
//  YSEPayStorage.h
//  YSEPaySDK
//
//  Created by JoakimLiu on 2017/4/20.
//  Copyright © 2017年 银盛通信有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSEPay.h"

/**
 中间缓存类
 */
@interface YSEPayStorage : NSObject
@property (nonatomic, strong) YSEPayBaseResp *resp;
@property (nonatomic, assign) BOOL printLogMsg;
@property (nonatomic, assign) YSEPayChannel channel;
@property (nonatomic, assign) BOOL hasOpenWebPay;

@property (nonatomic, strong) NSString *out_trade_no;
@property (nonatomic, strong) NSString *tradeNo;
@property (nonatomic, strong) NSString *partner_id;
@property (nonatomic, strong) NSString *privatePassword;

/**
 单例

 @return <#return value description#>
 */
+ (instancetype)sharedInstance;

/**
 <#Description#>

 @return <#return value description#>
 */
- (BOOL)doResponseCallBack;
@end
