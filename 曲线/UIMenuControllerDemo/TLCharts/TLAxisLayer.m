//
//  TLAxisLayer.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  坐标轴、网格
//  self.frame 就是整个网格区

#import "TLAxisLayer.h"
#import "TLChartsConfigure.h"
#import "TLCurveChartObject.h"

@implementation TLAxisLayer {
    CALayer *_xAxisLayer;
//    CALayer *_YAxisLayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointZero;
        self.strokeColor = kGridCGColor;
        self.fillColor = kGridFillCGColor;
        self.lineWidth = kGridWidth;
        
        _xAxisLayer = [CALayer layer];
        _xAxisLayer.backgroundColor = kAxisCGColor;
        _xAxisLayer.anchorPoint = CGPointZero;
        [self addSublayer:_xAxisLayer];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    CGFloat H = self.bounds.size.height;
    CGFloat W = self.bounds.size.width;
    _xAxisLayer.frame = CGRectMake(0.f, H - 1.f, W, 1.f);
    
    if (self.path) {
        [self draw];
    }
}

/// 绘制曲线
- (void)draw {
    if (_chartObj.hideGrids) {
        self.path = nil;
        [self setNeedsDisplay];
    }else{
        [self drawGrids];
    }
}

/// 绘制网格（动态）
- (void)drawGrids {
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 纵向-静态（边线）
    [path moveToPoint:CGPointMake(0.f, 0.f)]; // 坐标轴原点
    [path addLineToPoint:CGPointMake(0.f, H)];
    [path moveToPoint:CGPointMake(W, 0.f)];
    [path addLineToPoint:CGPointMake(W, H)];

    // 纵向-动态
    NSInteger i = _chartObj.offsetX / _chartObj.gridW;
    CGFloat offset = _chartObj.offsetX - i * _chartObj.gridW;
    for (NSInteger i = -1; i <= _chartObj.gridCountOfX; i++) {
        [path moveToPoint:CGPointMake(i * _chartObj.gridW + offset, H)];
        [path addLineToPoint:CGPointMake(i * _chartObj.gridW + offset, 0.f)];
    }
    
    // 横向-静态
    for (NSInteger i = 1; i <= _chartObj.yInfos.count - 1; i++) {
        [path moveToPoint:CGPointMake(0, H - i * _chartObj.gridH)];
        [path addLineToPoint:CGPointMake(W, H - i * _chartObj.gridH)];
    }
    
    self.path = path.CGPath;
    [self setNeedsDisplay];
}

- (void)setChartObj:(TLCurveChartObject *)chartObj {
    _chartObj = chartObj;
    _xAxisLayer.hidden = chartObj.hideAxis;
    if (self.path) {
        [self draw];
    }
    
    __weak TLAxisLayer *wself = self;
    [chartObj addDidUpdateOffsetXBlock:^{
        [wself drawGrids];
    }];
}
@end
