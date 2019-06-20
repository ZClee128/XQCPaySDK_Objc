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
 初始化
 @param showForgetPwd   是否显示“忘记密码”
 @param payButtonClick  点击立即支付回调
 */
- (instancetype)initWithForgetPwd:(BOOL)showForgetPwd payButtonclick:(RACSignal * (^)(NSString *pwd))payButtonClick;

- (instancetype)initWithStyle:(XQCPaymentPasswordStyle)style payButtonclick:(RACSignal * (^)(NSString *pwd))payButtonClick;

- (void)show;

@end

NS_ASSUME_NONNULL_END
