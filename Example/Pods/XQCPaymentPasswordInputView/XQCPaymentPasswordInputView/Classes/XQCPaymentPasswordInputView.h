//
//  XQCPaymentPasswordInputView.h
//  XQC
//
//  Created by huangwenwu on 2019/5/8.
//  Copyright © 2019 XQC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XQCPaymentPasswordStyle) {
    XQCPaymentPasswordStyleUnionPay = 0,    // 银联加密
    XQCPaymentPasswordStyleXQC,             // (数科加密,同登录)
    XQCPaymentPasswordStyleZSY,             // 中顺易加密
    XQCPaymentPasswordStylePlainText,       // 纯文字不加密
    XQCPaymentPasswordStyleUMS,             // 银联商务 最新银联密控
    XQCPaymentPasswordStyleLimit,           // 薪白条
};

@class RACSignal;

@interface XQCPaymentPasswordInputView : UIView

/**
 弹出密码框

 @param style 密码框弹出样式
 @param payButtonClick 点即立即支付回调
 @return 密码框
 */
- (instancetype)initWithStyle:(XQCPaymentPasswordStyle)style payButtonclick:(RACSignal * (^)(NSString *pwd))payButtonClick;

/**
 改变立即支付按钮的颜色

 @param color 颜色
 */
- (void)setBtnColor:(UIColor *)color;

- (void)show;

@end

NS_ASSUME_NONNULL_END
