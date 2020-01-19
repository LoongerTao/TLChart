//
//  ViewController.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/12.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "ViewController.h"
#import "iMMenuLabel.h"
#import "TLCharts.h"
#import "OSDeviceLogController.h"

@interface ViewController ()
{
    TLCurveLayer *layer;
}
@property (weak, nonatomic) IBOutlet iMMenuLabel *label;
@property (strong, nonatomic) IBOutlet UIView *textField;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    TLChartView *view = [TLChartView chartWithType:TLChartTypeCurve];
    view.frame = CGRectMake(0.f, 100.f, self.view.bounds.size.width, 375.f);
    view.layer.borderColor = [UIColor purpleColor].CGColor;
    view.layer.borderWidth = 1;
    
    [self.view addSubview:view];
    layer = view.curvelLayer;
    layer.A = _slider.value;
    layer.B = 0.5f;
    
    
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
    chartObj.title = @"Demo";
    chartObj.subTitle = @"sub title";
    chartObj.gridCountOfX = 7;
    chartObj.gridCountOfY = 6;
    chartObj.maxY = 240;
    chartObj.indentX = 20.f;
    
    view.chartObj = chartObj;
}

// A
- (IBAction)sliderValueDidChange:(id)sender {
    
    layer.A = ((UISlider *)sender).value;
   
//    NSLog(@"A --> %.2f",layer.A);
    
    [self presentViewController:[OSDeviceLogController new] animated:YES completion:nil];
    return;

}

// B
- (IBAction)action:(UISlider *)sender {
    layer.B = sender.value;
//    NSLog(@"B --> %.2f",sender.value);
 
}


@end
