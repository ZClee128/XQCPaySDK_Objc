//
//  XQCNavBarView.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import "XQCNavBarView.h"
#import "Header.h"
@implementation XQCNavBarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        UIButton *back = [UIButton buttonWithType:(UIButtonTypeCustom)];
        back.frame = CGRectMake(16, XQCSTATUS_BAR_HEIGHT+16, 8, 13);
        [self addSubview:back];
        [back setImage:[UIImage my_bundleImageNamed:@"navi_back_black"] forState:(UIControlStateNormal)];
        [back addTarget:self action:@selector(black:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake((XQCPHONE_WIDTH-100)/2, XQCSTATUS_BAR_HEIGHT+14, 100, 17)];
        [self addSubview:titleLab];
        titleLab.textColor = Hex(0x333333);
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.text = @"支付订单";
        titleLab.textAlignment = NSTextAlignmentCenter;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, XQCPHONE_WIDTH, 1)];
        line.backgroundColor = Hex(0xECEBF1);
        [self addSubview:line];
        
    }
    return self;
}

- (void)black:(UIButton *)sender {
    if (self.click) {
        self.click(sender);
    }
}

@end
