//
//  XQCPaymentPasswordInputView.m
//  XQC
//
//  Created by huangwenwu on 2019/5/8.
//  Copyright © 2019 xqc. All rights reserved.
//

#import "XQCPaymentPasswordInputView.h"
#import "XQCHeader.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

#define bolderColor RGB16(0xEFF1F0)
#define keyHeight  260

typedef void (^XQCCompletedBlock)(NSString *btnText,NSInteger btnTag);
typedef RACSignal *(^Completion)(NSString *password);
typedef void(^Forgotten)(void);
typedef void(^ForgottenWithStyle)(XQCPaymentPasswordStyle);

@interface XQCKeyBoardNumber : UIView

@property (nonatomic, strong) NSArray *numArray;
@property (nonatomic, copy) XQCCompletedBlock completeBlock;
- (instancetype)initWithFrame:(CGRect)frame;
+ (instancetype)ShowWithFrame:(CGRect)frame;
- (void)dismiss;
+(instancetype)show;

@end

@implementation XQCKeyBoardNumber

//懒加载
- (NSArray *)numArray {
    
    if (!_numArray) {
        
        self.numArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    }
    
    return _numArray;
}

+ (instancetype)show {
    
    return [self new];
}

+ (instancetype)ShowWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = RGB16(0xf5f5f5);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.frame = CGRectMake(0, kPHONE_HEIGHT - keyHeight , kPHONE_WIDTH, keyHeight);
        
        [self setupNumKeyBoard];
    }
    return self;
}

- (void)setupNumKeyBoard {
    
    NSMutableArray *numArray = [NSMutableArray arrayWithArray:self.numArray];
    int row = 4;
    int coloumn = 3;
    CGFloat marger = 5.0f;
    CGFloat left = 10.0f;
    CGFloat top = 10.0f;
    CGFloat keyWidth = (self.frame.size.width - left *2 - marger *2) / coloumn;
    CGFloat keyNewHeight = (self.frame.size.height - top - marger *3) / row;
    
    @weakify(self);
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i % coloumn *keyWidth + i % coloumn * marger + left , i / coloumn *keyNewHeight + i / coloumn *marger + top, keyWidth, keyNewHeight)];
        button.tag = i;
       
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        //设置背景图
        [button setBackgroundImage:[UIImage xqc_imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1.0]] forState:UIControlStateHighlighted];
        [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)]subscribeNext:^(UIButton *sender) {
            
            @strongify(self);
            
            if (self.completeBlock) {
                self.completeBlock(sender.titleLabel.text,sender.tag);
            }
        }];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        if (i == 9 || i == 11) {
            button.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1];
            [button setBackgroundImage:[UIImage xqc_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            if (i == 9) {
                [button setTitle:@"完成" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"删除" forState:UIControlStateNormal];
            }
        } else {
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[UIImage xqc_imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
            int loc = arc4random_uniform((int)numArray.count);
            [button setTitle:[numArray objectAtIndex:loc]forState:UIControlStateNormal];
            [numArray removeObjectAtIndex:loc];
        }
        
    }
}

- (void)dismiss {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self removeFromSuperview];
}

@end

@interface XQCPaymentPasswordInputView()

@property (nonatomic, copy) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *inputFrameView;
@property (nonatomic,strong) NSMutableArray <UILabel *>*labels;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *forgetPwdButton;
@property (nonatomic, copy)  Completion completion;
@property (nonatomic, copy) Forgotten forgoten;
@property (nonatomic, copy) ForgottenWithStyle forgottenstyle;
@property (nonatomic,assign)  XQCPaymentPasswordStyle style;

@property (nonatomic, strong) XQCKeyBoardNumber *NumKeyBoard;
@property (nonatomic,assign) BOOL isForgotten;
@property (nonatomic, copy) NSString *subTitle;

@end

@implementation XQCPaymentPasswordInputView

- (instancetype)initWithForgetPwd:(BOOL)showForgetPwd forgotten:(void (^)(void))forgotten completion:(RACSignal *(^)(NSString *pwd))completion
{
    self = [super init];
    
    if (self) {
        
        _labels = [NSMutableArray new];
        self.subTitle = @"";
        self.isForgotten = showForgetPwd;
        self.forgoten = forgotten;
        self.completion = completion;
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(XQCPaymentPasswordStyle)style forgetPwd:(BOOL)showForgetPwd forgotten:(void (^)(XQCPaymentPasswordStyle style))forgotten completion:(RACSignal * (^)(NSString *pwd))completion
{
    self = [super init];
    
    if (self) {
        
        _labels = [NSMutableArray new];
        self.subTitle = @"";
        self.isForgotten = showForgetPwd;
        self.forgottenstyle = forgotten;
        self.style = style;
        self.completion = completion;
        
    }
    
    return self;
}

- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupViews];
        UIWindow *window = (UIWindow *)[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [window endEditing:YES];
        [self performPresentationAnimation];
        self.NumKeyBoard = [XQCKeyBoardNumber show];
        self.textField.inputView = self.NumKeyBoard;
        [self numKeyBoardAction];
    });
}

// 出场动画
- (void)performPresentationAnimation{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.05],
                              [NSNumber numberWithFloat:0.98],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [self.contentView.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
}

- (void)setupViews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    if (self.contentView) {
        
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.inputFrameView];
    [self.contentView addSubview:self.forgetPwdButton];
    [self.contentView addSubview:self.textField];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-30);
        make.height.mas_equalTo(175);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_contentView).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.inputFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    
    @weakify(self);
    
    [[[tapGesture rac_gestureSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self);
        
        if (!self.NumKeyBoard) {
            
            self.NumKeyBoard = [XQCKeyBoardNumber show];
            self.textField.inputView = self.NumKeyBoard;
            
            [self numKeyBoardAction];
        }
        
    }];
    [self.inputFrameView addGestureRecognizer:tapGesture];
    
    CGFloat labelWidth = (kPHONE_WIDTH-60-20)/6;
    for (int i = 0; i < 6; i++) {
        // 标签
        UILabel *label = [UILabel new];
        [label setFont:[UIFont systemFontOfSize:20]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_inputFrameView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.inputFrameView);
            make.left.equalTo(self.inputFrameView).offset(i*labelWidth);
            make.width.mas_equalTo(labelWidth);
        }];
        
        // 分隔线
        if (i < 5) {
            UIView *line = [UIView new];
            [line setBackgroundColor:bolderColor];
            [_inputFrameView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self.inputFrameView);
                make.left.equalTo(label.mas_right);
                make.width.mas_equalTo(1);
            }];
        }
        
        [_labels addObject:label];
    }
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inputFrameView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    self.forgetPwdButton.hidden = !self.isForgotten;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
    
    [self.textField setHidden:YES];
}

- (UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc]init];
        [_contentView setBackgroundColor:WhiteColor];
//        kViewBorderRadius(_contentView, 6.0f, 0.0, WhiteColor);
        
    }
    
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kGlobalMainTextColor;
        _titleLabel.font = XQC_REGULAR_FONT_18;
        _titleLabel.text = @"请输入6位支付密码";
        
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kGlobalMainTextColor;
        _subTitleLabel.font = XQC_REGULAR_FONT_16;
        _subTitleLabel.text = self.subTitle;
    }
    
    return _subTitleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
    }
    
    return _textField;
}

- (void)clickDeleteBtn
{
    if (self.textField.text.length > 0) {
        
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
        
        [self inputContentsChanged:self.textField.text];
    }
}

- (UIView *)inputFrameView
{
    if (!_inputFrameView) {
        
        _inputFrameView = [[UIView alloc]init];
        //        kViewBorderRadius(_inputFrameView, 4, 1, bolderColor);
        _inputFrameView.layer.borderWidth = 1;
        _inputFrameView.layer.borderColor = RGB16(0xEFF1F0).CGColor;
    }
    
    return _inputFrameView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        
        @weakify(self);
        
        _closeButton = [UIButton buttonWithAction:^(UIButton *button) {
            
            @strongify(self);
            
            [self removeFromSuperview];
            //点击完成按钮
            [self.NumKeyBoard dismiss];
        }];
        [_closeButton setImage:kGetImage(@"passWrodCancel") forState:(UIControlStateNormal)];
        
    }
    
    return _closeButton;
}

- (UIButton *)forgetPwdButton
{
    if (!_forgetPwdButton) {
        
        @weakify(self);
        
        _forgetPwdButton = [UIButton buttonWithAction:^(UIButton *button) {
            
            @strongify(self);
            
            if (self.forgoten) {
                
                self.forgoten();
            }
            
            if (self.forgottenstyle) {
                
                self.forgottenstyle(self.style);
            }
            [self removeFromSuperview];
            [self.NumKeyBoard dismiss];
        }];
        [_forgetPwdButton setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
        _forgetPwdButton.titleLabel.font = XQC_REGULAR_FONT_14;
        [_forgetPwdButton setTitleColor:kGlobalMainColor forState:(UIControlStateNormal)];
    }
    
    return _forgetPwdButton;
}

#pragma mark - Private Method

- (void)numKeyBoardAction
{
    //点击键盘
    
    @weakify(self);
    
    self.NumKeyBoard.completeBlock = ^(NSString *text,NSInteger tag) {
        
        @strongify(self);
        
        switch (tag) {
                case 9:
                //点击完成按钮
                [self.NumKeyBoard dismiss];
                self.NumKeyBoard = nil;
                break;
                case 11:
                //点击删除按钮
                [self clickDeleteBtn];
                break;
            default:
                //点击数字键盘
                [self.textField changTextWithNSString:text];
                [self inputContentsChanged:self.textField.text];
                
                if (self.textField.text.length >=6) {
                    
                    self.textField.text = [self.textField.text substringToIndex:6];
                    
                    @weakify(self);
                    
                    [[RACScheduler mainThreadScheduler] afterDelay:0.25 schedule:^{
                        
                        @strongify(self);
                        
                        if (self.completion) {
                            [self.completion([self.textField.text rasedPwdStr]) subscribeCompleted:^{
                                [self removeFromSuperview];
                                [self.NumKeyBoard dismiss];
                                self.NumKeyBoard = nil;
                            }];
                        }
                    }];
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        if (self.completion) {
//
//                           if(self.completion([self.textField.text rasedPwdStr]))
//                            {
//                                [self removeFromSuperview];
//                                [self.NumKeyBoard dismiss];
//                                self.NumKeyBoard = nil;
//                            }
//                        }
//                    });
                }
                
                break;
        }
    };
}

- (void)inputContentsChanged:(NSString *)text {
    
    NSInteger length = text.length;
    int i = 0;
    for (UILabel *label in _labels) {
        if (i<length) {
            label.text = @"●";
        } else {
            label.text = @"";
        }
        i++;
    }
}

- (NSString *)subTitle {
    NSString *subTitle = @"";
    switch (_style) {
            case XQCPaymentPasswordStyleUnionPay:
            subTitle = @"银联电子钱包密码";
            break;
            case XQCPaymentPasswordStyleZSY:
            subTitle = @"中顺易电子钱包密码";
            break;
            case XQCPaymentPasswordStyleXQC:
            subTitle = @"数科电子钱包密码";
            break;
            case XQCPaymentPasswordStyleUMS:
            subTitle = @"好易联电子钱包密码";
            break;
            case XQCPaymentPasswordStyleLimit:
            subTitle = @"薪白条支付密码";
            break;
        default:
            break;
    }
    return subTitle;
}
@end
