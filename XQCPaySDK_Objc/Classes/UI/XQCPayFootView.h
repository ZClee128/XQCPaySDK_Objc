//
//  XQCPayFootView.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQCPayFootView : UIView

@property (nonatomic,copy)void(^gotoPay)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
