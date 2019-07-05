//
//  XQCPayItemView.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/12.
//

#import "XQCPayItemView.h"
#import "PaySDKHeader.h"
@interface XQCPayItemView()

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIButton *selectBtn;

@end

@implementation XQCPayItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, (self.frame.size.height-43)/2, 43, 43)];
        [self addSubview:self.logoImageView];
        self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(85, (self.frame.size.height-14)/2, XQCPHONE_WIDTH - 119, 14)];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = Hex(0x010101);
        [self addSubview:self.titleLab];
        
        self.selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.selectBtn.frame = CGRectMake(XQCPHONE_WIDTH-34, (self.frame.size.height-18)/2, 18, 18);
        [self addSubview:self.selectBtn];
        self.selectBtn.userInteractionEnabled = NO;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, self.frame.size.height-1, XQCPHONE_WIDTH-15, 1)];
        line.backgroundColor = Hex(0xECEBF1);
        [self addSubview:line];
        
    }
    return self;
}

- (void)setDataWithModel:(ChannelModel *)model {
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.channelLogoUrl] placeholderImage:[UIImage my_bundleImageNamed:@"xqc"]];
    self.titleLab.text = model.channelName;
    self.selectBtn.selected = model.isClick;
    [self.selectBtn setImage:[UIImage my_bundleImageNamed:@"unchecked"] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage my_bundleImageNamed:@"checked"] forState:(UIControlStateSelected)];
}

@end
