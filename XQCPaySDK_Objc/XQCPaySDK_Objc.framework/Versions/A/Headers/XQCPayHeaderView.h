//
//  XQCPayHeaderView.h
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQCPayHeaderView : UIView

- (void)setDataWithTitle:(NSString *)title Price:(CGFloat)price;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *priceLab;
@end

NS_ASSUME_NONNULL_END
