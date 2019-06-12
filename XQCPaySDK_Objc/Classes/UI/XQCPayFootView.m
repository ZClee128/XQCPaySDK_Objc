//
//  XQCPayFootView.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import "XQCPayFootView.h"
#import "Header.h"


@implementation XQCPayFootView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        payBtn.frame = CGRectMake(16, 16, XQCPHONE_WIDTH-32, 44);
        [self addSubview:payBtn];
        payBtn.backgroundColor = Hex(0xFDB300);
        payBtn.layer.cornerRadius = 5;
        payBtn.layer.masksToBounds = YES;
        [payBtn setTitle:@"立即支付" forState:(UIControlStateNormal)];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [payBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [payBtn addTarget:self action:@selector(gotoPay:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)gotoPay:(UIButton *)sender {
    if (self.gotoPay) {
        self.gotoPay(sender);
    }
}

@end
