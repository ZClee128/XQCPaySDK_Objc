//
//  XQCPayHeaderView.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import "XQCPayHeaderView.h"
#import "Header.h"
@implementation XQCPayHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 19, XQCPHONE_WIDTH-30, 13)];
        [self addSubview:self.titleLab];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = Hex(0x010101);
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, XQCPHONE_WIDTH-30, 14)];
        [self addSubview:self.priceLab];
        self.priceLab.font = [UIFont systemFontOfSize:14];
        self.priceLab.textColor = Hex(0x010101);
        
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 80, XQCPHONE_WIDTH, 48)];
        bottom.backgroundColor = Hex(0xF7F7F7);
        [self addSubview:bottom];
        UILabel *payTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, (bottom.frame.size.height-13)/2, XQCPHONE_WIDTH-15, 13)];
        [bottom addSubview:payTitle];
        payTitle.font = [UIFont systemFontOfSize:14];
        payTitle.textColor = Hex(0x999999);
        payTitle.text = @"选择支付方式";
        
    }
    return self;
}


- (void)setDataWithTitle:(NSString *)title Price:(CGFloat)price {
    self.titleLab.text = [NSString stringWithFormat:@"订单详情：%@",title];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单金额：¥%.2f",price]];
    [str addAttribute:NSForegroundColorAttributeName value:Hex(0x010101) range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:Hex(0xFDB300) range:NSMakeRange(5,str.length-5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(5, str.length-5)];
    self.priceLab.attributedText = str;
}

@end
