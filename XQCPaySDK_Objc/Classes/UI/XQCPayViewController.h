//
//  XQCPayViewController.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <UIKit/UIKit.h>
#import "XQCPayManager.h"
NS_ASSUME_NONNULL_BEGIN



@interface XQCPayViewController : UIViewController

/**
 输入金额

 @param price 金额
 */
- (void)sendPrice:(CGFloat)price feeType:(feeType)type;

/**
 初始化

 @param title 订单名字
 @param orderId 订单id
 @return instancetype
 */
- (instancetype)initWithOrderTitle:(NSString *)title OrderId:(NSString *)orderId;

/**
 返回按钮回调
 */
@property (nonatomic,copy)void(^back)(void);

@end

NS_ASSUME_NONNULL_END
