//
//  TLChartView.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLChartView.h"
#import "TLCurveLayer.h"
#import "TLChartsConfigure.h"
#import "TLCurveChartObject.h"

@interface TLChartView ()
{
    TLCurveLayer *_cLayer;
}
//@property(nonatomic, copy) NSString *whId;
/// 总的X偏移
@property(nonatomic, assign) CGFloat offsetX;
/// 上次的x值
@property(nonatomic, assign) CGFloat x;

@end

@implementation TLChartView

/// 默认高度
#define kDefaultH 240.f
#define kDefaultW ([UIScreen mainScreen].bounds.size.width)

+ (instancetype)chartWithType:(TLChartType)chartType {
    TLChartView *cView = [[self alloc] init];
    cView.frame = CGRectMake(0, 100, kDefaultW, kDefaultH);
    cView.chartType = chartType;
    
    return cView;
}

- (void)setChartObj:(TLCurveChartObject *)chartObj {
    _chartObj = chartObj;
    [self setup];
}
/// 初始化设置
- (void)setup {
    if(self.chartType == TLChartTypeCurve) {
        TLCurveLayer *layer = [TLCurveLayer layerWithCurveChartObject:_chartObj];
        self->_cLayer = layer;
        [self.layer addSublayer:layer];
        layer.frame = self.bounds;
        [layer setNeedsDisplay];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
}

- (TLCurveLayer *)curvelLayer {
    return _cLayer;
}

/// 点击查看选中坐标信息
- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    
    if(self.chartType == TLChartTypeCurve) {
        [self.curvelLayer showTipsWithPoint:point];
    }
}

/// 移动图标
- (void)pan:(UITapGestureRecognizer *)pan {
    if (self.chartType != TLChartTypeCurve) return;
    
    
    if (!self.curvelLayer.canMove) { // 点数不够，不移动
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        _x = [pan locationInView:self].x;
        return;
    }
    
    CGFloat curX = [pan locationInView:self].x;
    _offsetX += curX - _x;
    _x = curX;
    
    // 从左向右滑
    if (self.chartObj.isLeftToRight) {
        if (_offsetX >= 0.f) { // 越界修正
            NSUInteger count = self.chartObj.curves.firstObject.points.count - 1; // 最大格数
            CGFloat maxOffsetX = (count - self.chartObj.gridCountOfX) * self.chartObj.gridW;
            if (maxOffsetX < _offsetX) {
                _offsetX = maxOffsetX;
            }
            [self.curvelLayer setOffsetX:_offsetX];
            
        }else{
            _offsetX = 0.f;
        }
    }else {
        if (_offsetX <= 0.f) {
            NSUInteger count = self.chartObj.curves.firstObject.points.count - 1; // 最大格数
            CGFloat maxOffsetX = (count - self.chartObj.gridCountOfX) * self.chartObj.gridW;
            if (maxOffsetX < ABS(_offsetX)) {
                _offsetX = -maxOffsetX;
            }
            [self.curvelLayer setOffsetX:_offsetX];
        }else{
            _offsetX = 0.f;
        }
    }
}
@end
