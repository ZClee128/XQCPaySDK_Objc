//
//  XQCPayViewController.m
//  XQCPaySDK_Objc
//
//  Created by lee on 2019/6/10.
//

#import "XQCPayViewController.h"
#import "XQCPayManager.h"
#import "XQCNavBarView.h"
#import "Header.h"
#import "XQCPayHeaderView.h"
#import "XQCPayItemView.h"
#import "XQCPayFootView.h"
@interface XQCPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTable;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)XQCPayHeaderView *tableHeaderView;
@property (nonatomic,assign) CGFloat  price;
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
    nav.click = ^(UIButton * _Nonnull btn) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self setUI];
    XQCPayManager *manager = [XQCPayManager defaultManager];
    [manager getChannels:@"" agentNo:[manager getAgentNo] respon:^(NSArray * _Nonnull list) {
        NSLog(@"list ==>%@",list);
        self.dataSource = [list mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable reloadData];
        });
    }];
    
    [manager whitestripAgentNo:[manager getAgentNo] companyOpenId:[manager getCompanyOpenId] userOpenId:[manager getUserOpenId] respon:^(NSArray * _Nonnull list) {
        
    }];
}

- (void)setUI {
    self.tableHeaderView = [[XQCPayHeaderView alloc] initWithFrame:CGRectMake(0, XQCNAVIGATION_BAR_HEIGHT, XQCPHONE_WIDTH, 128)];
    [self.tableHeaderView setDataWithTitle:self.orderTitle Price:self.price];
    [self.view addSubview:self.tableHeaderView];
    self.tableFootView = [[XQCPayFootView alloc] initWithFrame:CGRectMake(0, XQCPHONE_HEIGHT-76-XQCTAB_SAFE_HEIGHT, XQCPHONE_WIDTH, 76)];
    [self.view addSubview:self.tableFootView];
    self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, XQCNAVIGATION_BAR_HEIGHT+self.tableHeaderView.frame.size.height, XQCPHONE_WIDTH, XQCPHONE_HEIGHT-XQCNAVIGATION_BAR_HEIGHT-self.tableHeaderView.frame.size.height-self.tableFootView.frame.size.height-XQCTAB_SAFE_HEIGHT) style:(UITableViewStylePlain)];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    self.myTable.backgroundColor = UIColor.whiteColor;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.myTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.myTable.estimatedRowHeight = 0;
        self.myTable.estimatedSectionHeaderHeight = 0;
        self.myTable.estimatedSectionFooterHeight = 0;
    }
}

- (void)sendPrice:(CGFloat )price {
    self.price = price;
}

#pragma mark =======================UITableViewDelegate,UITableViewDataSource================
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ChannelModel *model = self.dataSource[section];
    if ([model.channelType isEqualToString:@"IOUSPAY"]) {
        return 0;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68;
}

- (void)selectView:(UITapGestureRecognizer *)tap {
    ChannelModel *model = self.dataSource[tap.view.tag-100];
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
