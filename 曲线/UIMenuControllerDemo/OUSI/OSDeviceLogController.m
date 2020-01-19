//
//  OSDeviceLogController.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2020/1/19.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "OSDeviceLogController.h"
#import "TLCharts.h"
#import "OSDeviceLogHeadView.h"

// MARK: - OSDeviceLogItem
@interface OSDeviceLogInfoItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *value;

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value;
@end

@implementation OSDeviceLogInfoItem
+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value {
    OSDeviceLogInfoItem *item = [[self alloc] init];
    item.title = title;
    item.value = value;
    return item;
}
@end



// MARK: - OSDeviceLogController
@interface OSDeviceLogController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, strong) UIView *textInfoView;
@property(nonatomic, strong) TLChartView *chartView;
@property(nonatomic, weak) UIView *bottomView;
@property(nonatomic, weak) UIButton *nextBtn;
@property(nonatomic, weak) UIButton *previousBtn;

@property(nonatomic, strong) NSArray <OSDeviceLogInfoItem *>*infoItems;
@end

@implementation OSDeviceLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.infoItems = @[
        [OSDeviceLogInfoItem itemWithTitle:@"绑定菜品" value:@"香干肉丝"],
        [OSDeviceLogInfoItem itemWithTitle:@"告警次数" value:@"1次"],
        [OSDeviceLogInfoItem itemWithTitle:@"波动时长" value:@"10:04:12  61152g"],
        [OSDeviceLogInfoItem itemWithTitle:@"取盘时间" value:@"10:04:12  61152g"],
        [OSDeviceLogInfoItem itemWithTitle:@"生成支付" value:@"10:04:12  61152g"]
    ];
    
    NSMutableArray *points = [NSMutableArray array];
    NSArray *num = @[@"20", @"100", @"0", @"-10", @"88", @"240", @"210", @"123", @"90", @"12",@"20", @"100", @"0", @"-10", @"88", @"240", @"210", @"123", @"90", @"12"];
    for (NSInteger i = 0; i < num.count; i++) {
        TLCurvePoint *point = [TLCurvePoint pointWithIndex:i xValue:[NSString stringWithFormat:@"xName%zi", i]
                                                    yValue:[NSString stringWithFormat:@"%@", num[i]]
                                                   isFirst:i == 0
                                                    isLast:i==99];
        [points addObject:point];
        
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:[TLPointTipItem itemWhitTitle:@"时间" value:@"10:04:12"]];
        [temp addObject:[TLPointTipItem itemWhitTitle:@"重量" value:@"61152g"]];
        [temp addObject:[TLPointTipItem itemWhitTitle:@"状态" value:@"不稳定"]];
        [temp addObject:[TLPointTipItem itemWhitTitle:@"操作" value:@"放置托盘"]];
        [temp addObject:[TLPointTipItem itemWhitTitle:@"告警" value:@"余额不足"]];
        point.tipItems = temp;
    }
    TLCurveObject *curveObj = [TLCurveObject objectWithID:0 points:points];
    curveObj.needFill = YES;
    curveObj.lineType = 0;
    
    TLCurveChartObject *chartObj = [TLCurveChartObject objectWithCurves:@[curveObj]];
    chartObj.isLeftToRight = NO;
//    chartObj.title = @"Demo";
//    chartObj.subTitle = @"sub title";
    chartObj.gridCountOfX = 7;
    chartObj.gridCountOfY = 6;
    chartObj.maxY = 240;
    chartObj.indentX = 20.f;
    
    self.chartView.chartObj = chartObj;
}

- (void)setInfoItems:(NSArray<OSDeviceLogInfoItem *> *)infoItems {
    _infoItems = infoItems;
    
    NSArray *temp = [self.textInfoView.subviews copy];
    for (UIView *view in temp) {
        [view removeFromSuperview];
    }
    
    CGFloat top = 20;
    for (OSDeviceLogInfoItem *item in infoItems) {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(36, top, 72, 17)];
        titleLable.textColor = UIColorFromRGB(0x999999);
        titleLable.font = [UIFont systemFontOfSize:12];
        [_textInfoView addSubview:titleLable];
        titleLable.text = item.title;
        
        UILabel *valueLable = [[UILabel alloc] initWithFrame:CGRectMake(108, top, 200, 17)];
        valueLable.textColor = UIColorFromRGB(0x333333);
        valueLable.font = [UIFont systemFontOfSize:12];
        [_textInfoView addSubview:valueLable];
        valueLable.text = item.value;
        
        if ([item.title isEqualToString:@"告警次数"]) {
            valueLable.textColor = UIColorFromRGB(0xF24141);
            
            CGSize size = [valueLable sizeThatFits:CGSizeMake(200, 17)];
            UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width + 108, top+1, 15, 15)];
            arrowImgView.image = [UIImage systemImageNamed:@"link"];
            [_textInfoView addSubview:arrowImgView];
        }
        
        top += 25;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, 20, 2, _textInfoView.bounds.size.height - 40)];
    line.backgroundColor = UIColorFromRGB(0xF5F5F8);
    [_textInfoView addSubview:line];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        self.tableView.frame = self.view.bounds;
    }
    
    BOOL isIphoneX = YES;
    
    CGFloat W = self.view.bounds.size.width;
    CGFloat H = self.view.bounds.size.height;
    CGFloat h = isIphoneX ? 84 : 50;
    self.bottomView.frame = CGRectMake(0, H - h, W, h);
    
    _previousBtn.frame = CGRectMake(0, 0, W * 0.5, 50);
    _nextBtn.frame = CGRectMake( W * 0.5, 0, W * 0.5, 50);
    [_bottomView viewWithTag:101].center = CGPointMake(W * 0.5, 25);
}

// MARK: - Sub Views
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectZero style:UITableViewStylePlain];
        _tableView = tableView;
        [self.view addSubview:tableView];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 105, 0);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return  _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *btmView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView = btmView;
        [self.view addSubview:_bottomView];
        btmView.backgroundColor = [UIColor whiteColor];
        
        UIButton *previousBtn = [[UIButton alloc] init];
        [previousBtn setTitle:@"上一组" forState:UIControlStateNormal];
        [previousBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [previousBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
        [previousBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateDisabled];
        previousBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [previousBtn addTarget:self action:@selector(previousItem) forControlEvents:UIControlEventTouchUpInside];
        [btmView addSubview:previousBtn];
        _previousBtn = previousBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setTitle:@"下一组" forState:UIControlStateNormal];
        [nextBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [nextBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
        [nextBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateDisabled];
        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [nextBtn addTarget:self action:@selector(nextItem) forControlEvents:UIControlEventTouchUpInside];
        [btmView addSubview:nextBtn];
        _nextBtn = nextBtn;
        
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 12)];
        centerLine.backgroundColor = UIColorFromRGB(0xdddddd);
        centerLine.tag = 101;
        [btmView addSubview:centerLine];
    }
    
    return _bottomView;
}

- (UIView *)textInfoView {
    if (!_textInfoView) {
        _textInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    CGFloat H = self.infoItems.count * (17 + 8) - 8 + 40;
    _textInfoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, H);
    return _textInfoView;
}

- (TLChartView *)chartView {
    if (!_chartView) {
        _chartView = [TLChartView chartWithType:TLChartTypeCurve];
        _chartView.frame = CGRectMake(0.f, 0.f, self.view.bounds.size.width, 375.f);
    }
    
    return _chartView;
}

// MARK: - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"CellID-%zi", indexPath.section];
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            [cell.contentView addSubview:self.textInfoView];
        }else {
            [cell.contentView addSubview:self.chartView];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section ? CGRectGetHeight(self.chartView.bounds) : CGRectGetHeight(self.textInfoView.bounds);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width, 50);
    OSDeviceLogHeadView *header = [[OSDeviceLogHeadView alloc] initWithFrame:frame];
    
    header.imgView.tintColor = [UIColor orangeColor];
    if (section == 0) {
        header.imgView.image = [UIImage systemImageNamed:@"text.cursor"];//[UIImage imageNamed:@""];
        header.titleLabel.text = @"消费";
        header.timeLabel.text = @"10:04:12~10:05:47";
        header.detailLabel.text = @"查看订单";
        header.arrowImgView.hidden = NO;
    }else {
        header.imgView.image = [UIImage systemImageNamed:@"f.cursive.circle.fill"];//[UIImage imageNamed:@""];
        header.arrowImgView.hidden = YES;
        header.titleLabel.text = @"波动趋势";
        header.timeLabel.text = nil;
        header.detailLabel.text = nil;
    }
    [header layoutSubviews];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    view.backgroundColor = tableView.backgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
// MARK: - Actions
- (void)previousItem {
    
}

- (void)nextItem {
    
}

@end
