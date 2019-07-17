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

#define bolderColor RGB16(0x999999)

// 相对于参照宽度计算尺寸
#define SizeOfScaleRefW(orgW,orgH,refW) CGSizeMake(kPHONE_WIDTH*(orgW)/(refW), kPHONE_WIDTH*(orgH)/(refW))
// 相对于参照高度计算尺寸
#define SizeOfScaleRefH(orgW,orgH,refH) CGSizeMake(orgW*kPHONE_WIDTH/(refH),kPHONE_WIDTH*(orgH)/(refH))
// 相对于设计标准(宽375)计算数值
#define StandardScale(x) SizeOfScaleRefW(375, x, 375).height

#define keyHeight  StandardScale(260)

typedef void (^XQCCompletedBlock)(NSString *btnText,NSInteger btnTag);
typedef RACSignal *(^PayButtonBlock)(NSString *password);
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
@property (nonatomic,strong) UIButton *payButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic, copy) PayButtonBlock payCompletion;
@property (nonatomic,assign)  XQCPaymentPasswordStyle style;

@property (nonatomic, strong) XQCKeyBoardNumber *NumKeyBoard;
@property (nonatomic,assign) BOOL isForgotten;
@property (nonatomic, copy) NSString *subTitle;

@end

@implementation XQCPaymentPasswordInputView

- (instancetype)initWithStyle:(XQCPaymentPasswordStyle)style payButtonclick:(RACSignal * (^)(NSString *pwd))payButtonClick
{
    self = [super init];
    
    if (self) {
        
        _labels = [NSMutableArray new];
        self.subTitle = @"";
        self.style = style;
        self.payCompletion = payButtonClick;
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
    [self.contentView addSubview:self.inputFrameView];
    [self.contentView addSubview:self.payButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.textField];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-30);
        make.height.mas_equalTo(StandardScale(156));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
  
    [self.inputFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(28);
        make.right.equalTo(self.contentView).offset(-28);
        make.height.mas_equalTo(StandardScale(36));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
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
    
    CGFloat labelWidth = (kPHONE_WIDTH-60-56)/6;
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.inputFrameView.mas_bottom).offset(20);
        make.height.equalTo(@1);
        
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
    
    [self.textField setHidden:YES];
    self.closeButton.hidden = YES;
    
    
    UITapGestureRecognizer *hidetapGesture = [[UITapGestureRecognizer alloc] init];

    [[[hidetapGesture rac_gestureSignal]deliverOn:[RACScheduler mainThreadScheduler]]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self);
        
        [self removeFromSuperview];
        [self.NumKeyBoard dismiss];
        self.NumKeyBoard = nil;
    }];
     
     [self addGestureRecognizer:hidetapGesture];
}

- (UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc]init];
        [_contentView setBackgroundColor:WhiteColor];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
    }
    
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kGlobalPrimaryTextColor;
        if (@available(iOS 8.2, *)) {
            _titleLabel.font = XQC_REGULAR_FONT_17;
        } else {
            _titleLabel.font = [UIFont systemFontOfSize:17];
        }
        _titleLabel.text = @"请输入6位支付密码";
        
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = kGlobalMainTextColor;
        if (@available(iOS 8.2, *)) {
            _subTitleLabel.font = XQC_REGULAR_FONT_16;
        } else {
            _subTitleLabel.font = [UIFont systemFontOfSize:16];
        }
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
        _inputFrameView.layer.borderWidth = 1;
        _inputFrameView.layer.borderColor = RGB16(0x999999).CGColor;
        _inputFrameView.layer.masksToBounds = YES;
        _inputFrameView.layer.cornerRadius = 5;
        _inputFrameView.layer.masksToBounds = YES;
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

- (UIButton *)payButton
{
    if (!_payButton) {
        
        @weakify(self);
        
        _payButton = [UIButton buttonWithAction:^(UIButton *button) {
            
            @strongify(self);
            
            if (self.textField.text.length >= 6) {
                
                [[RACScheduler mainThreadScheduler] afterDelay:0.25 schedule:^{
                    
                    if (self.payCompletion) {
                        
                        [self.payCompletion((self.style == XQCPaymentIousPasswordStyleLimit) ? [self.textField.text rasedPwdStrForSDKWithiousPwd] : [self.textField.text rasedPwdStr])subscribeCompleted:^{
                            
                            [self removeFromSuperview];
                            [self.NumKeyBoard dismiss];
                            self.NumKeyBoard = nil;
                        }];
                    }
                }];
            }
        }];
        [_payButton setTitle:@"立即支付" forState:(UIControlStateNormal)];
        if (@available(iOS 8.2, *)) {
            _payButton.titleLabel.font = XQC_REGULAR_FONT_17;
        } else {
            // Fallback on earlier versions
            _payButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [_payButton setTitleColor:RGB16(0xFDB300) forState:(UIControlStateNormal)];
    }
    
    return _payButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB16(0xDDDDDD);
    }
    
    return _lineView;
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

- (void)setBtnColor:(UIColor *)color
{
    [self.payButton setTitleColor:color forState:(UIControlStateNormal)];
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
            case XQCPaymentIousPasswordStyleLimit:
            subTitle = @"白条支付";
            break;
        default:
            break;
    }
    return subTitle;
}
@end
