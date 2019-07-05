//
//  XQCPayViewController.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayViewController.h"
#import "XQCNavBarView.h"
#import "PaySDKHeader.h"
#import "XQCPayHeaderView.h"
#import "XQCPayItemView.h"
#import "XQCPayFootView.h"
#import "XQCWhiteStripTableViewCell.h"
#import <YSEPaySDK/YSEPay.h>
#import "WXApi.h"
#import "XQCPaymentPasswordInputView.h"
#import "ReactiveObjC.h"



@interface XQCPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTable;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *whiteStripSource;
@property (nonatomic,strong)XQCPayHeaderView *tableHeaderView;
@property (nonatomic,assign) CGFloat  price;
@property (nonatomic,assign) feeType  myFeeType;
@property (nonatomic,copy)NSString *orderTitle;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,strong)XQCPayFootView *tableFootView;

@end

@implementation XQCPayViewController

- (instancetype)initWithOrderTitle:(NSString *)title OrderId:(NSString *)orderId
{
    self = [super init];
    if (self) {
        self.orderId = orderId;
        self.orderTitle = title;
    }
    return self;
}

- (NSMutableArray *)whiteStripSource {
    if (_whiteStripSource == nil) {
        _whiteStripSource = [[NSMutableArray alloc]init];
    }
    return _whiteStripSource;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    XQCNavBarView *nav = [[XQCNavBarView alloc] initWithFrame:CGRectMake(0, 0, XQCPHONE_WIDTH, XQCNAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:nav];
    @weakify(self);
    nav.click = ^(UIButton * _Nonnull btn) {
        [[RACScheduler mainThreadScheduler] schedule:^{
            @strongify(self);
            [self navBack];
        }];
    };
    [self setUI];
    XQCPayManager *manager = [XQCPayManager defaultManager];
    [XQCPayManager getChannels:@"" agentNo:[manager getAgentNo] respon:^(NSArray * _Nonnull list) {
        NSLog(@"list ==>%@",list);
        self.dataSource = [list mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable reloadData];
        });
    }];
    
    //    [XQCPayManager whitestripAgentNo:[manager getAgentNo] companyOpenId:[manager getCompanyOpenId] userOpenId:[manager getUserOpenId] respon:^(NSArray * _Nonnull list) {
    //        self.whiteStripSource = [list mutableCopy];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.myTable reloadData];
    //        });
    //    }];
}

- (void)navBack {
    NSString *payType = @"";
    for (ChannelModel *model in self.dataSource) {
        if (model.isClick) {
            payType = model.channelType;
        }
    }
    NSDictionary *dict = @{@"amount": @(self.price * 100),
                           @"outTradeNo" : self.orderId,
                           @"payState" : @(10),
                           @"payType" : payType,
                           @"isBack" : @(YES),
                           };
    ResponseModel *model = [[ResponseModel alloc] initWithDict:dict];
    if ([XQCPayManager defaultManager].result) {
        [XQCPayManager defaultManager].result(model);
    }
    UINavigationController *navigation = self.navigationController;
    if (navigation) {
        [navigation popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)close {
    if (self.back) {
        self.back();
    }else {
        UINavigationController *navigation = self.navigationController;
        if (navigation) {
            [navigation popViewControllerAnimated:YES];
        } else {
            [self dissmissAllModalControllerAnimated:YES];
        }
    }
}

- (void)dissmissAllModalControllerAnimated:(BOOL)flag{
    UIViewController *presentingViewController = self.presentingViewController ;
    UIViewController *lastVC = self ;
    while (presentingViewController) {
        id temp = presentingViewController;
        presentingViewController = [presentingViewController presentingViewController];
        lastVC = temp ;
    }
    [lastVC dismissViewControllerAnimated:flag completion:^{}];
}


- (void)setUI {
    self.tableHeaderView = [[XQCPayHeaderView alloc] initWithFrame:CGRectMake(0, XQCNAVIGATION_BAR_HEIGHT, XQCPHONE_WIDTH, 128)];
    [self.tableHeaderView setDataWithTitle:self.orderTitle Price:self.price];
    [self.view addSubview:self.tableHeaderView];
    self.tableFootView = [[XQCPayFootView alloc] initWithFrame:CGRectMake(0, XQCPHONE_HEIGHT-76-XQCTAB_SAFE_HEIGHT, XQCPHONE_WIDTH, 76)];
    [self.view addSubview:self.tableFootView];
    WeakSelf(self)
    self.tableFootView.gotoPay = ^(UIButton * _Nonnull sender) {
        [weakself send];
    };
    self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, XQCNAVIGATION_BAR_HEIGHT+self.tableHeaderView.frame.size.height, XQCPHONE_WIDTH, XQCPHONE_HEIGHT-XQCNAVIGATION_BAR_HEIGHT-self.tableHeaderView.frame.size.height-self.tableFootView.frame.size.height-XQCTAB_SAFE_HEIGHT) style:(UITableViewStylePlain)];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    self.myTable.backgroundColor = UIColor.whiteColor;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable registerClass:[XQCWhiteStripTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XQCWhiteStripTableViewCell class])];
    if (@available(iOS 11.0, *)) {
        self.myTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.myTable.estimatedRowHeight = 0;
        self.myTable.estimatedSectionHeaderHeight = 0;
        self.myTable.estimatedSectionFooterHeight = 0;
    }
}


- (void)send {
    BOOL isHasAlipay = [[YSEPay sharedInstance] isAliPayAppInstalled];
    BOOL isHasWechat = [WXApi isWXAppInstalled];
    if (self.price < 0.1) {
        [SVProgressHUD showErrorWithStatus:@"支付金额不能低于0.1元"];
        return;
    }
    for (ChannelModel *model in self.dataSource) {
        if (model.isClick) {
            if ([model.channelType isEqualToString:WECHATPAY] || [model.channelType isEqualToString:WECHATPAY_YS]) {
                if (!isHasWechat) {
                    [SVProgressHUD showErrorWithStatus:@"未安装微信"];
                    return;
                }
            }
            if ([model.channelType isEqualToString:ALIPAY] || [model.channelType isEqualToString:ALIPAY_YS]) {
                if (!isHasAlipay) {
                    [SVProgressHUD showErrorWithStatus:@"未安装支付宝"];
                    return;
                }
            }
            if ([model.channelType isEqualToString:IOUSPAY]) {
                @weakify(self);
                for (WhitestripModel *whiteModel in self.whiteStripSource) {
                    if (whiteModel.isCheck) {
                        [XQCPayManager showPasswordViewControllerResult:^{
                            [XQCPayManager payRequsetAmount:self.price payType:model.channelType bizCode:model.bizCode Body:self.orderTitle orderId:self.orderId iousCode:whiteModel.iousCode FeeType:self.myFeeType viewController:self reuslt:^(ResponseModel * _Nonnull model) {
                                @strongify(self);
                                if ([XQCPayManager defaultManager].result) {
                                    [XQCPayManager defaultManager].result(model);
                                }
                                [self close];
                            }];
                        }];
                        return;
                    }
                }
            }else {
                @weakify(self);
                [XQCPayManager payRequsetAmount:self.price payType:model.channelType bizCode:model.bizCode Body:self.orderTitle orderId:self.orderId iousCode:@"" FeeType:self.myFeeType viewController:self reuslt:^(ResponseModel * _Nonnull model) {
                    @strongify(self);
                    [self close];
                }];
            }
            return;
        }
    }
}

- (void)sendPrice:(CGFloat )price feeType:(feeType)type{
    self.price = price;
    self.myFeeType = type;
}

#pragma mark =======================UITableViewDelegate,UITableViewDataSource================
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ChannelModel *model = self.dataSource[section];
    if ([model.channelType isEqualToString:IOUSPAY]) {
        return model.isClick ? self.whiteStripSource.count : 0;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XQCWhiteStripTableViewCell *whiteCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XQCWhiteStripTableViewCell class])];
    WhitestripModel *model = self.whiteStripSource[indexPath.row];
    [whiteCell setDataWithModel:model];
    return whiteCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ChannelModel *model = self.dataSource[section];
    XQCPayItemView *item = [tableView viewWithTag:section+100];
    if (item == nil) {
        item = [[XQCPayItemView alloc] initWithFrame:CGRectMake(0, 0, XQCPHONE_WIDTH, 68)];
        item.tag = section+100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectView:)];
        item.userInteractionEnabled = YES;
        [item addGestureRecognizer:tap];
    }
    [item setDataWithModel:model];
    return item;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WidthOfScale(146);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WhitestripModel *model = self.whiteStripSource[indexPath.row];
    model.isCheck = YES;
    NSMutableArray *new = [[NSMutableArray alloc] init];
    for (WhitestripModel *listmodel in self.whiteStripSource) {
        if (listmodel != model) {
            listmodel.isCheck = NO;
        }
        [new addObject:listmodel];
    }
    new[indexPath.row] = model;
    self.whiteStripSource = new;
    [self.myTable reloadData];
}

- (void)selectView:(UITapGestureRecognizer *)tap {
    ChannelModel *model = self.dataSource[tap.view.tag-100];
    if ([model.channelType isEqualToString:IOUSPAY]) {
        if (self.whiteStripSource.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"暂无白条"];
            return;
        }
    }
    model.isClick = YES;
    NSMutableArray *new = [[NSMutableArray alloc] init];
    for (ChannelModel *listmodel in self.dataSource) {
        if (listmodel != model) {
            listmodel.isClick = NO;
        }
        [new addObject:listmodel];
    }
    new[tap.view.tag-100] = model;
    self.dataSource = new;
    [self.myTable reloadData];
}

@end
