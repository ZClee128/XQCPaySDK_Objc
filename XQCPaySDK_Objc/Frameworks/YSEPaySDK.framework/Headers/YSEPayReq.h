//
//  YSEPayReq.h
//  YSEPaySDK
//
//  Created by JoakimLiu on 2017/4/20.
//  Copyright © 2017年 银盛通信有限公司. All rights reserved.
//

#import "YSEPayObjects.h"
#import <UIKit/UIKit.h>
/**
 注释后面加 * 星号的为必填参数
 */
@interface YSEPayReq : YSEPayBaseReq
// 支付渠道 *
@property (nonatomic, assign) YSEPayChannel channel;
// 请求支付信息 * 接口返回的 pay_info 信息
@property (nonatomic, copy) NSString *payInfo;
// 控制器 *
@property (nonatomic, weak) UIViewController *viewController;
@end
