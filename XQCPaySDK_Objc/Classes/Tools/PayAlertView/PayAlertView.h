//
//  PayAlertView.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnLeftButtonClick)(void);
typedef void (^OnRightButtonClick)(void);

@interface PayAlertView : UIView

@property (nonatomic,copy) OnLeftButtonClick leftBlock;
@property (nonatomic,copy) OnRightButtonClick rightBlock;

-(instancetype)initWithWithTitle:(NSString *)title leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle leftBolck:(void (^)(void))leftBlock rightBlock:(void (^)(void))rightBlock;
//弹出
-(void)show;

//隐藏
-(void)hide;

@end

NS_ASSUME_NONNULL_END
