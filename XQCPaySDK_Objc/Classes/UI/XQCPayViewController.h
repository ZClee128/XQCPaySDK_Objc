//
//  XQCPayViewController.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQCPayViewController : UIViewController

- (void)sendPrice:(CGFloat )price;

- (instancetype)initWithOrderTitle:(NSString *)title OrderId:(NSString *)orderId;

@end

NS_ASSUME_NONNULL_END
