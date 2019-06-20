//
//  PayAlertView.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/20.
//

#import "PayAlertView.h"
#import "PaySDKHeader.h"

#define TagValue  1000
#define AlertTime 0.3 //弹出动画时间
#define DropTime 0.5 //落下动画时间


@interface PayAlertView ()

@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIView *AlertView;
@property (nonatomic,strong)UILabel *titleLab;

@end

@implementation PayAlertView

- (instancetype)initWithWithTitle:(NSString *)title leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle leftBolck:(void (^)(void))leftBlock rightBlock:(void (^)(void))rightBlock {
    if (self = [super init]) {
        _leftBlock = leftBlock;
        _rightBlock = rightBlock;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.AlertView = [[UIView alloc] initWithFrame:CGRectMake(WidthOfScale(53),WidthOfScale(256), WidthOfScale(269), WidthOfScale(129))];
        self.AlertView.backgroundColor = UIColor.whiteColor;
        self.AlertView.center = CGPointMake(XQCPHONE_WIDTH/2, XQCPHONE_HEIGHT/2);
        [self addSubview:self.AlertView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthOfScale(15), WidthOfScale(34), self.AlertView.frame.size.width - WidthOfScale(30), 17)];
        self.titleLab.numberOfLines = 0;
        self.titleLab.font = [UIFont systemFontOfSize:17];
        self.titleLab.textColor = UIColor.blackColor;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = title;
        [self.AlertView addSubview:self.titleLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.AlertView.frame.size.height - WidthOfScale(45), self.AlertView.frame.size.width, 1)];
        line.backgroundColor = Hex(0xDDDDDD);
        [self.AlertView addSubview:line];
        
        self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.leftBtn.frame = CGRectMake(0, self.AlertView.frame.size.height - WidthOfScale(45), (self.AlertView.frame.size.width-1)/2, WidthOfScale(45));
        [self.leftBtn setTitle:leftTitle forState:(UIControlStateNormal)];
        [self.leftBtn setTitleColor:Hex(0x333333) forState:(UIControlStateNormal)];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.AlertView addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.rightBtn.frame = CGRectMake(self.leftBtn.frame.size.width+1, self.AlertView.frame.size.height - WidthOfScale(45), (self.AlertView.frame.size.width-1)/2, WidthOfScale(45));
        [self.rightBtn setTitle:rightTitle forState:(UIControlStateNormal)];
        [self.rightBtn setTitleColor:Hex(0xFDB300) forState:(UIControlStateNormal)];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.AlertView addSubview:self.rightBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.leftBtn.frame.size.width, self.AlertView.frame.size.height - WidthOfScale(45), 1, WidthOfScale(45))];
        line2.backgroundColor = Hex(0xDDDDDD);
        [self.AlertView addSubview:line2];
        
    }
    return self;
}

- (void)leftClick:(UIButton *)sender {
    [self hide];
    if (_leftBlock) {
        _leftBlock();
    }
}

- (void)rightClick:(UIButton *)sender {
    [self hide];
    if (_rightBlock) {
        _rightBlock();
    }
}

- (void)show {
    if (self.superview) {
        [self removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.AlertView.transform = CGAffineTransformScale(self.AlertView.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.AlertView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    if (self.superview) {
        [UIView animateWithDuration:AlertTime animations:^{
            self.AlertView.transform = CGAffineTransformScale(self.AlertView.transform,0.1,0.1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
