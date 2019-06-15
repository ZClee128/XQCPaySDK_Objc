//
//  XQCNavBarView.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQCNavBarView : UIView


@property (nonatomic,copy)void(^click)(UIButton *btn);
@end

NS_ASSUME_NONNULL_END
