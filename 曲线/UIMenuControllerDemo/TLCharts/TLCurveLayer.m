//
//  TLCurveLayer.m
//
//
//  Created by 故乡的云 on 2018/10/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  

#import "TLCurveLayer.h"
#import "TLCurveLineLayer.h"
#import "TLAxisLayer.h"
#import "TLTextLayer.h"
#import "TLTipsLayer.h"
#import "TLCurveChartObject.h"

@interface TLCurveLayer ()
{
    CGFloat _curOffsetX;        // 当前偏移
    NSInteger _curIndex;        // 当前索引
}
/// 包装层,用于边沿剪切
@property(nonatomic, weak) CALayer *wrapLayer;
/// 文字层
@property(nonatomic, weak) TLTextLayer *textLayer;
/// 提示信息层（选中标注信息层）
@property(nonatomic, weak) TLTipsLayer *tipsLayer;

//***** wrapLayer sub layer *****//
/// 曲线集合
@property(nonatomic, strong) NSMutableArray <TLCurveLineLayer *>*curveLayers;
/// 坐标轴层
@property(nonatomic, weak) TLAxisLayer *axisLayer;

@end

@implementation TLCurveLayer

- (instancetype)initWithCurveChartObject:(TLCurveChartObject * _Nonnull )chartObj {
    if (self = [super init]) {
        self.chartObj = chartObj;
    }
    return self;
}

+ (instancetype)layerWithCurveChartObject:(TLCurveChartObject * _Nonnull )chartObj {
    return [[self alloc] initWithCurveChartObject:chartObj];
}

- (void)setChartObj:(TLCurveChartObject *)chartObj {
    _chartObj = chartObj;
    
    self.curveLayers = [NSMutableArray array];
    [self addSublayers];
    [self layoutSublayers];
    
    _textLayer.chartObj = chartObj;
    _tipsLayer.chartObj = chartObj;
}

#pragma mark - 添加sub layers
- (void)addSublayers {
    CALayer *wrapLayer = [CALayer layer];
    _wrapLayer = wrapLayer;
    [self addSublayer:wrapLayer];
    wrapLayer.anchorPoint = CGPointZero;
    wrapLayer.masksToBounds = YES;
    
    TLAxisLayer *axisLayer = [TLAxisLayer layer];
    _axisLayer = axisLayer;
    [_wrapLayer addSublayer:axisLayer];
    axisLayer.chartObj = self.chartObj;
  
    TLTextLayer *textLayer = [TLTextLayer layer];
    _textLayer.chartObj = self.chartObj;
    _textLayer = textLayer;
    [self addSublayer:textLayer];

    TLTipsLayer *tipsLayer = [TLTipsLayer layer];
    _tipsLayer = tipsLayer;
    [self addSublayer:tipsLayer];
    
    for (TLCurveObject *cObj in self.chartObj.curves) {
        [self addCurveLineLayerWithCurveObject:cObj];
    }
}

- (void)addCurveLineLayerWithCurveObject:(TLCurveObject *)cObj {
    TLCurveLineLayer *curveLineLayer = [[TLCurveLineLayer alloc] initWithCurveObject:cObj];
    [_wrapLayer addSublayer:curveLineLayer];
    [self.curveLayers addObject:curveLineLayer];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    if (!_chartObj) return;
    CGFloat H = self.bounds.size.height;
    CGFloat W = self.bounds.size.width;
    
    [self updateGridSize];
    
    UIEdgeInsets inset = _chartObj.axisInset;
    _wrapLayer.frame = CGRectMake(inset.left, 0.f, W - inset.left - inset.right, H);
    CGFloat H2 = _wrapLayer.bounds.size.height - inset.top - inset.bottom;
    CGRect frame = CGRectMake(0.f, inset.top, _wrapLayer.bounds.size.width, H2);
    for (CALayer *layer in self.curveLayers) {
        layer.frame = frame;
    }
    _axisLayer.frame = frame;
    _textLayer.yOfXAxis = H - inset.bottom;
    _textLayer.frame = self.bounds;
    _tipsLayer.frame = CGRectMake(inset.left, 0.f, W - inset.left - inset.right, H - inset.bottom);
    
    if (self.chartObj.gridW  > 0) {
        [self setNeedsDisplay];
    }
}

#pragma mark - 刷新显示
- (void)updateGridSize {
    [self.chartObj updateGridLayoutWithSize:self.bounds.size];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];

    [self setOffsetX:0];
}

// 选中
- (void)showTipsWithPoint:(CGPoint)point {
    point = [self convertPoint:point toLayer:_axisLayer];
    if (point.x < -kOutMarginOfShowSelectPoint ||
        point.x > _axisLayer.frame.size.width + kOutMarginOfShowSelectPoint)
    {
        return;
    }
   
    NSInteger index = [self.chartObj indexOfPoint:point];
    self.chartObj.selectedIndex = index;
    
    [self.tipsLayer refreshTips];
}


// 移动
- (void)setOffsetX:(CGFloat)offsetX {
    
    [self.chartObj setOffsetX:offsetX];       
    [self.curveLayers enumerateObjectsUsingBlock:^(TLCurveLineLayer * layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if (layer.curveObject.curPoints.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [layer draw];
            });
        }
    }];
}

#pragma mark - setter
- (BOOL)canMove {
    return self.chartObj.curves.firstObject.points.count > self.chartObj.gridCountOfX;
}
@end
