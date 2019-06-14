//
//  XQCWhiteStripTableViewCell.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/13.
//

#import "XQCWhiteStripTableViewCell.h"
#import "PaySDKHeader.h"
@interface XQCWhiteStripTableViewCell()

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *subTitleLab;
@property (nonatomic,strong)UILabel *allPriceLab;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIImageView *bgImageView;

@end

@implementation XQCWhiteStripTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = Hex(0xFAFAFA);
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WidthOfScale(13), 0, WidthOfScale(350), WidthOfScale(134))];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.image = [UIImage my_bundleImageNamed:@"baitiao"];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(WidthOfScale(29), WidthOfScale(22), WidthOfScale((self.bgImageView.frame.size.width-WidthOfScale(29))), WidthOfScale(14))];
        [self.bgImageView addSubview:self.titleLab];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = Hex(0x010101);
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthOfScale(29), WidthOfScale(54), WidthOfScale(201), WidthOfScale(29))];
        [self.bgImageView addSubview:self.priceLab];
        
        self.subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthOfScale(30), WidthOfScale(97), WidthOfScale(100), WidthOfScale(12))];
        self.subTitleLab.text = @"可用余额";
        self.subTitleLab.font = [UIFont systemFontOfSize:12];
        self.subTitleLab.textColor = Hex(0x000000);
        [self.bgImageView addSubview:self.subTitleLab];
        
        self.allPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthOfScale(350-230), WidthOfScale(97), WidthOfScale(201), WidthOfScale(12))];
        self.allPriceLab.font = [UIFont systemFontOfSize:12];
        self.allPriceLab.textColor = Hex(0x999999);
        self.allPriceLab.textAlignment = NSTextAlignmentRight;
        [self.bgImageView addSubview:self.allPriceLab];
        
        self.selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.selectBtn.frame = CGRectMake(WidthOfScale(302), WidthOfScale(59), 18, 18);
        [self.bgImageView addSubview:self.selectBtn];
        self.selectBtn.userInteractionEnabled = NO;
    }
    return self;
}


- (void)setDataWithModel:(WhitestripModel *)model{
    self.titleLab.text = model.name;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",model.canUseAmt]];
    [str addAttribute:NSForegroundColorAttributeName value:Hex(0xEDB84C) range:NSMakeRange(0,str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:36] range:NSMakeRange(1, str.length-1)];
    self.priceLab.attributedText = str;
    self.allPriceLab.text = [NSString stringWithFormat:@"总额度:%@元",model.totalAmt];
    self.selectBtn.selected = model.isCheck;
    [self.selectBtn setImage:[UIImage my_bundleImageNamed:@"unchecked"] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage my_bundleImageNamed:@"checked"] forState:(UIControlStateSelected)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
