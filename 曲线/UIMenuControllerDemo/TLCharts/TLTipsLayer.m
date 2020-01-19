//
//  TLTipsLayer.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  选中坐标标注信息层

#import "TLTipsLayer.h"
#import "TLChartsConfigure.h"
#import "TLCurveChartObject.h"

@interface TLTipsLayer ()
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, strong) NSMutableArray <CAShapeLayer *> *pointLayers;
@property(nonatomic, strong) CAShapeLayer *textLayer;
@property(nonatomic, strong) CAShapeLayer *dashLayer;
@end

@implementation TLTipsLayer

- (instancetype)init {
    if (self = [super init]) {
        // 虚线
        self.anchorPoint = CGPointZero;
        self.lineDashPattern = @[@2, @2];
        self.lineWidth = 1.f;
        self.strokeColor = UIColorFromRGB(0x979797).CGColor;
    }
    return self;
}

- (void)setChartObj:(TLCurveChartObject *)chartObj {
    _chartObj = chartObj;
    
    __weak TLTipsLayer *wself = self;
    [chartObj addDidUpdateOffsetXBlock:^{
        if (wself.chartObj.selectedIndex) {
            [wself refreshTips];
        }
    }];
}

// 单曲信息线渲染
- (void)refreshTips {
    if (!self.chartObj) return;
    
    if (self.chartObj.selectedIndex < 0) {
        [self clear];
        return;
    }
    
    TLCurvePoint *point = self.chartObj.curves.firstObject.points[self.chartObj.selectedIndex];
    if (point.point.x < 0 || point.point.x > self.bounds.size.width || point.isPlaceholder) { // 清空
        [self clear];
        
    }else {
        if (_top <= 0) {
            _top = self.bounds.size.height - self.chartObj.gridCountOfY * self.chartObj.gridH;
        }
        [self drawDashLine];
        [self drawPoints];
        [self drawTexts];
    }
}

- (void)clear {
    if (_textLayer.sublayers.count) {
        NSArray *subLyars = [self.textLayer.sublayers copy];
        for (CALayer *layer in subLyars) {
            [layer removeFromSuperlayer];
        }
        _textLayer.path = nil;
        [_textLayer setNeedsDisplay];
    }
    
    if (_pointLayers.count) {
        for (CALayer *layer in _pointLayers) {
            [layer removeFromSuperlayer];
        }
        [_pointLayers removeAllObjects];
    }
    
    self.path = nil;
    [self setNeedsDisplay];
}

- (void)drawDashLine {
    NSUInteger selectedIndex = self.chartObj.selectedIndex;
    CGFloat x = self.chartObj.curves.firstObject.points[selectedIndex].point.x;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x, _top)];
    [path addLineToPoint:CGPointMake(x, self.bounds.size.height)];
    self.path = path.CGPath;
    [self setNeedsDisplay];
}

- (void)drawPoints {
    if (_pointLayers == nil) {
        _pointLayers = [NSMutableArray arrayWithCapacity:self.chartObj.curves.count];
    }
    
    if (_pointLayers.count) {
        for (CALayer *layer in _pointLayers) {
            [layer removeFromSuperlayer];
        }
        [_pointLayers removeAllObjects];
    }
    
    NSUInteger selectedIndex = self.chartObj.selectedIndex;
    for (TLCurveObject *cObj in self.chartObj.curves) {
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
        pointLayer.bounds = self.bounds;
        pointLayer.anchorPoint = CGPointMake(0, 0);
        pointLayer.strokeColor = UIColorFromRGB(0xFFFFFF).CGColor;
        pointLayer.fillColor = cObj.selectedPointColor.CGColor;
        pointLayer.lineWidth = 1.5;
        [self addSublayer:pointLayer];
        [_pointLayers addObject:pointLayer];
        CGPoint point = cObj.points[selectedIndex].point;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point.x, _top + point.y)
                                                            radius:4
                                                        startAngle:0
                                                          endAngle:M_PI_2 * 4
                                                         clockwise:YES];
         pointLayer.path = path.CGPath;
         [pointLayer setNeedsDisplay];
    }
}

- (void)drawTexts {
    if (!_textLayer) {
        _textLayer = [[CAShapeLayer alloc] init];
        [self addSublayer:_textLayer];
        _textLayer.bounds = self.bounds;
        _textLayer.anchorPoint = CGPointMake(0, 0);
        _textLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
        _textLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;;
        _textLayer.lineWidth = 1;
        _textLayer.lineJoin = @"round";
    }
    
    if (_textLayer.sublayers.count) {
        NSArray *subLyars = [self.textLayer.sublayers copy];
        for (CALayer *layer in subLyars) {
            [layer removeFromSuperlayer];
        }
    }
    
    NSUInteger selectedIndex = self.chartObj.selectedIndex;
    TLCurveObject *cObj = self.chartObj.curves.firstObject;
    TLCurvePoint *p = cObj.points[selectedIndex];
    NSInteger count = p.tipItems.count;
    if (!count) return;
        
    CGFloat maxY = self.bounds.size.height;
    CGFloat W = 102;
    CGFloat H = 22 * count + 2;
    CGPoint point = p.point;
    BOOL isShowInLeft = self.bounds.size.width - p.point.x < W;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat x = isShowInLeft ? point.x - 9 : point.x + 9;
    CGFloat y = point.y + _top;
    CGFloat h = (H - 10) * 0.5; // 尖角开始以下的高度
    if (y < _top + 8) {
        y = _top + 8;
        h = (H - 10) - 8;
    }else if (y > maxY - 8) {
        h = 8;
        y = maxY - 8;
    }
    if (maxY - y < h) {
        h = maxY - y;
    }else if (y - _top < (H - 10) - h) {
        h = (H - 10) - (y - _top);
    }
    
    CGFloat radius = 2;
    CGFloat px = x;
    CGFloat py = y;
    [path moveToPoint:CGPointMake(px, py)]; // 尖角开始
    px += isShowInLeft ? -6 : 6;
    py += 5;
    [path addLineToPoint:CGPointMake(px, py)];
    py += h - radius;
    [path addLineToPoint:CGPointMake(px , py)];
    
    CGFloat startAngle = isShowInLeft ? 0 : -M_PI;
    CGFloat endAngle = isShowInLeft ? M_PI_2 : M_PI_2;
    [path addArcWithCenter:CGPointMake(isShowInLeft ? px - radius : px + radius, py) radius:radius
                startAngle:startAngle endAngle:endAngle clockwise:isShowInLeft];
    
    px = isShowInLeft ? x - (92 - radius) : x + (92 - radius);
    py += radius;
    [path addLineToPoint:CGPointMake(px , py)];
    startAngle = isShowInLeft ? M_PI_2 : M_PI_2;
    endAngle = isShowInLeft ? -M_PI : 0;
    [path addArcWithCenter:CGPointMake(px, py - radius) radius:radius
                startAngle:startAngle endAngle:endAngle clockwise:isShowInLeft];
    
    px += isShowInLeft ?  -radius : radius;
    py -= (H - radius);
    CGFloat t = py - 0.5;
    [path addLineToPoint:CGPointMake(px , py)];
    
    startAngle = isShowInLeft ? -M_PI : 0;
    endAngle = isShowInLeft ? -M_PI_2 : -M_PI_2;
    [path addArcWithCenter:CGPointMake(isShowInLeft ? px+radius : px-radius, py) radius:radius
                startAngle:startAngle endAngle:endAngle clockwise:isShowInLeft];
    
    px = isShowInLeft ? x - 6 - radius : x + 6 + radius;
    py -= radius;
    [path addLineToPoint:CGPointMake(px , py)];
    
    startAngle = isShowInLeft ? -M_PI_2 : -M_PI_2;
    endAngle = isShowInLeft ? 0 : -M_PI;
    [path addArcWithCenter:CGPointMake(px, py + radius) radius:radius
                startAngle:startAngle endAngle:endAngle clockwise:isShowInLeft];
    
    px = isShowInLeft ? x - 6 : x + 6;
    [path addLineToPoint:CGPointMake(px , y - 5)];
    [path addLineToPoint:CGPointMake(x , y)];
    [path closePath];
    
    CGFloat top = y + h + 5 - H + 1;
    for (NSInteger i = 1; i < count; i++) {
        [path moveToPoint:CGPointMake(isShowInLeft ? x - 6 : x + 6,  top + 22 * i)];
        [path addLineToPoint:CGPointMake(isShowInLeft ? x - 92 : x + 92 , top + 22 * i)];
    }
    
    _textLayer.path = path.CGPath;
    [_textLayer setNeedsDisplay];
    
    CGFloat left = isShowInLeft ? x - 86 : x + 12;
    for (TLPointTipItem *item in p.tipItems) {
        [self darwText:item left:left top:t];
        t += 22;
    }
}

- (void)darwText:(TLPointTipItem *)item left:(CGFloat)left top:(CGFloat)top {

    CGFloat h1 = [item.title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: item.titleFont} context:nil].size.height;
    CGFloat h2 = [item.value boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: item.valueFont} context:nil].size.height;
    CGFloat H = MAX(h1, h2);
    top += (21 - H) * 0.5;
    CATextLayer *titleLayer = [CATextLayer layer];
    [_textLayer addSublayer:titleLayer];
    titleLayer.frame = CGRectMake(left, top, 76, H);
    titleLayer.string = item.attributedText;
    titleLayer.contentsScale = [UIScreen mainScreen].scale;
    titleLayer.truncationMode = kCATruncationEnd;
    [titleLayer setNeedsDisplay];
}


//    titleLayer.shadowOffset = CGSizeMake(0, 3);
//    titleLayer.shadowRadius = 3.0;
//    titleLayer.shadowColor = color;
//    titleLayer.shadowOpacity = 0.4;
@end
