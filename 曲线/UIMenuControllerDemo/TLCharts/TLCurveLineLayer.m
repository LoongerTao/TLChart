//
//  TLCurveLineLayer.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  曲线绘制层

#import "TLCurveLineLayer.h"
#import "TLCurveChartObject.h"

@interface TLCurveLineLayer ()
/// 填充layer（因为strokeStart，和strokeEnd不好计算，所以单独使用一层layer）
@property(nonatomic, weak) CAShapeLayer *fillMaskLayer;
/// 背景层填充
@property(nonatomic, strong) CAGradientLayer *fillLayer;
/// 圆点
@property(nonatomic, weak) CAShapeLayer *pointsLayer;
@end

@implementation TLCurveLineLayer

- (instancetype)initWithCurveObject:(TLCurveObject *)curveObject;
{
    self = [super init];
    if (self) {
        self.curveObject = curveObject;
        self.anchorPoint = CGPointMake(0, 0);
        self.strokeColor = curveObject.lineColor.CGColor;
        self.fillColor = [UIColor clearColor].CGColor;
        self.A = kBezierCurveSmoothValue;
        self.B = kBezierCurveSmoothValue2;
    }
    return self;
}

/// 绘制曲线
- (void)draw {
    // 曲线
    UIBezierPath *path = [self bezierPath];
    self.path = path.CGPath;
    [self setNeedsDisplay];
    
    // 曲线填充
    if (self.curveObject.needFill) {
        [self drawFillCurve];
    }
    
    // 画圆点
    if(self.curveObject.showPoint) {
        [self drawPoints];
    }
}

/// 填充
- (void)drawFillCurve {
    if (_fillLayer == nil) {
        CAGradientLayer *fillLayer = [CAGradientLayer layer];
        _fillLayer = fillLayer;
        [self addSublayer:_fillLayer];
        fillLayer.frame = self.bounds;
        fillLayer.colors = self.fillColors;
        fillLayer.locations=@[@0.0,@1.0];
        fillLayer.startPoint = CGPointMake(0,0);
        fillLayer.endPoint = CGPointMake(0,1);
        
        CAShapeLayer *fillMaskLayer = [[CAShapeLayer alloc] init];
        _fillMaskLayer = fillMaskLayer;
        fillLayer.mask = fillMaskLayer;
    }

    _fillMaskLayer.path = [self fillPath];
}

- (NSArray *)fillColors {
    UIColor *beginFillColor = self.curveObject.fillColor;
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [beginFillColor getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *endFillColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
    return @[(__bridge id)beginFillColor.CGColor, (__bridge id)endFillColor.CGColor];
}

- (void)drawPoints {
    if (_pointsLayer == nil) {
        CAShapeLayer *pointsLayer = [[CAShapeLayer alloc] init];
        _pointsLayer = pointsLayer;
        [self addSublayer:pointsLayer];
        
        _pointsLayer.bounds = self.bounds;
        _pointsLayer.anchorPoint = CGPointMake(0, 0);
        _pointsLayer.fillColor = self.curveObject.pointColor.CGColor;
        _pointsLayer.strokeColor = UIColorFromRGB(0xFFFFFF).CGColor;
        _pointsLayer.lineWidth = 1.5;
    }

    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [points enumerateObjectsUsingBlock:^(TLCurvePoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isPlaceholder) {
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:obj.point
                                                            radius:4
                                                        startAngle:0
                                                          endAngle:M_PI_2 * 4
                                                         clockwise:YES]];
           
        }
    }];
    _pointsLayer.path = path.CGPath;
    [_pointsLayer setNeedsDisplay];
}


#pragma mark - Bezier Path（贝塞尔路径）
/// 曲线路径
- (UIBezierPath *)bezierPath {
    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    if (self.curveObject.lineType != TLLineTypeLine) {
        NSInteger beginIndex = [self.curveObject.points indexOfObject:self.curveObject.curPoints.firstObject];
        NSInteger endIndex = [self.curveObject.points indexOfObject:self.curveObject.curPoints.lastObject];
        if ( beginIndex > 0) {
            _beginRefPoint = self.curveObject.points[beginIndex-1];
            _beginRefPoint.offsetX = self.curveObject.curPoints.firstObject.offsetX;
        }else {
            _beginRefPoint = self.curveObject.curPoints.firstObject;
        }
        if (endIndex >= self.curveObject.points.count -1) {
            _endRefPoint = self.curveObject.curPoints.lastObject;
        }else {
            _endRefPoint = self.curveObject.points[endIndex+1];
            _endRefPoint.offsetX = self.curveObject.curPoints.lastObject.offsetX;
        }        
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL needMoveToPoint = NO;
    switch (self.curveObject.lineType) {
        case TLLineTypeBezierCurve:
        case TLLineTypeFakeBezierCurve:
        case TLLineTypeFakeSine:
        case TLLineTypeFakeSine2:
            for (int i = 0; i < points.count; i++) {
                TLCurvePoint *obj = points[i];
                if (obj.isPlaceholder) {
                    needMoveToPoint = YES;
                    continue;
                }
                
                CGPoint point = [self pointWithPoint:obj];
                if (needMoveToPoint || i == 0) {
                    needMoveToPoint = NO;
                    [path moveToPoint:point];
                }else {
                    CGPoint ctr1 = [self getControlPoint1ByIndex:i-1];
                    CGPoint ctr2 = [self getControlPoint2ByIndex:i-1];
                    [path addCurveToPoint:point controlPoint1:ctr1 controlPoint2:ctr2];
                }
            }
            break;
        case TLLineTypeBezierCurve2:
            for (int i = 0; i < points.count; i++) {
                TLCurvePoint *obj = points[i];
                if (obj.isPlaceholder) {
                    needMoveToPoint = YES;
                    continue;
                }
                
                CGPoint point = [self pointWithPoint:obj];
                if (needMoveToPoint || i == 0) {
                    needMoveToPoint = NO;
                    [path moveToPoint:point];
                }else {
                    path = [self addCurveToPointWithIndex:i toPath:path];
                }
            }
            break;
        default:
            for (int i = 0; i < points.count; i++) {
                TLCurvePoint *obj = points[i];
                if (obj.isPlaceholder) {
                    needMoveToPoint = YES;
                    continue;
                }
                
                CGPoint point = [self pointWithPoint:obj];
                if (needMoveToPoint || i == 0) {
                    needMoveToPoint = NO;
                    [path moveToPoint:point];
                }else {
                    [path addLineToPoint:[self pointWithPoint:points[i]]];
                }
            }
            break;
    }
    return path;
}

/// 封闭的曲线路径（用于填充）
- (CGPathRef)fillPath {
    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    UIBezierPath *path = [self bezierPath];
    CGPoint endPoint = [self pointWithPoint:points.lastObject];
    [path addLineToPoint:CGPointMake(endPoint.x, self.bounds.size.height)];
    
    for (TLCurvePoint *obj in points) {
        if (obj.isPlaceholder == NO) {
            CGPoint startPoint = [self pointWithPoint:obj];
            [path addLineToPoint:CGPointMake(startPoint.x, self.bounds.size.height)];
            break;
        }
    }
    
    return path.CGPath;
}

// 贝塞尔曲线控制点计算方法：https://wenku.baidu.com/view/c790f8d46bec0975f565e211.html
// Points = @[P1, P2, ..., Pi, Pi+1, Pi+2, ...,Pn], Pi = (Xi, Yi)
// ctr1[i] : (Xi + a(Xi+1 - Xi-1), Yi + a(Yi+1 - Yi-1))
// ctr2[i] : (Xi+1 - b(Xi+2 - Xi), Yi+1 - b(Yi+2 - Yi))
// 起始点时：让P[i] = P[i-1], 结束点时：P[i+1] = P[i]

// 获取控制点1(右)
- (CGPoint)getControlPoint1ByIndex:(NSInteger)idx {
    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    if (idx >= points.count) {
        return CGPointZero;
    }
    
    // (Xi + a(Xi+1 - Xi-1), Yi + a(Yi+1 - Yi-1))
    CGPoint p = [self pointWithPoint:points[idx]];
    CGPoint p0; // idx -1
    CGPoint p1 = [self pointWithPoint:points[idx + 1]]; // idx + 1
    if(idx == 0) {
        p0 = (_beginRefPoint.isPlaceholder) ? p : [self pointWithPoint:_beginRefPoint];
    }else {
        p0 = (points[idx-1].isPlaceholder) ? p : [self pointWithPoint:points[idx-1]];
    }
    
    CGFloat a, x, y;
    if (self.curveObject.lineType == TLLineTypeBezierCurve) {
        a = _A;
        x = p.x + a * (p1.x - p0.x);
        y =  p.y + a * (p1.y - p0.y);
    }else if (self.curveObject.lineType == TLLineTypeFakeBezierCurve){
        CGFloat H = ABS(p.y - p1.y);
        a = H < _A * 100.0f ? _A - (_A * 100.0f - H) * 0.01f : _A;
        x = p.x + a * (p1.x - p0.x);
        y =  p.y + a * (p1.y - p0.y);
    }else if (self.curveObject.lineType == TLLineTypeFakeSine){
        a = _A;
        x = p.x + a * (p1.x - p0.x);
        y =  p.y;
    }else if (self.curveObject.lineType == TLLineTypeFakeSine2){
        CGFloat H = ABS(p.y - p1.y);
        a = H < _A * 100.0f ? _A - (_A * 100.0f - H) * 0.01f : _A;
        x = p.x + a * (p1.x - p0.x);
        y =  p.y;
    }else {
        x = 0;
        y = 0;
    }

    return CGPointMake(x, y);
}

// 获取控制点2(左)
- (CGPoint)getControlPoint2ByIndex:(NSInteger)idx {
    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    if (idx >= points.count) {
        return CGPointZero;
    }
    
    // (Xi+1 - b(Xi+2 - Xi), Yi+1 - b(Yi+2 - Yi))
    CGPoint p = [self pointWithPoint:points[idx]];
    CGPoint p1 = points[idx+1].isPlaceholder ? p : [self pointWithPoint:points[idx+1]]; // idx + 1
    CGPoint p2; // idx + 2
    if(idx == points.count - 2){
        p2 = _endRefPoint.isPlaceholder ? p1: [self pointWithPoint:_endRefPoint];
    }else {
        p2 = points[idx+2].isPlaceholder ? p1 : [self pointWithPoint:points[idx+2]];
    }
    
    CGFloat b, x, y;
    if (self.curveObject.lineType == TLLineTypeBezierCurve) {
        b = _A;
        x = p1.x - b * (p2.x - p.x);
        y =  p1.y - b * (p2.y - p.y);
    }else if (self.curveObject.lineType == TLLineTypeFakeBezierCurve){
        CGFloat H = ABS(p.y - p1.y);
        b = H < _A * 100.0f ? _A - (_A * 100.0f - H) * 0.01f : _A;
        x = p1.x - b * (p2.x - p.x);
        y =  p1.y - b * (p2.y - p.y);
    }else if (self.curveObject.lineType == TLLineTypeFakeSine){
        b = _A;
        x = p1.x - b * (p2.x - p.x);
        y =  p1.y;
    }else if (self.curveObject.lineType == TLLineTypeFakeSine2){
        CGFloat H = ABS(p.y - p1.y);
        b = H < _A * 100.0f ? _A - (_A * 100.0f - H) * 0.01f : _A;
        x = p1.x - b * (p2.x - p.x);
        y =  p1.y;
    }else {
        x = 0;
        y = 0;
    }

    return CGPointMake(x, y);
}


// 曲线公式2（备选）-- 不全面
// http://ju.outofmemory.cn/entry/205267
- (UIBezierPath *)addCurveToPointWithIndex:(NSInteger)idx toPath:(UIBezierPath *)path{
    NSArray <TLCurvePoint *>*points = self.curveObject.curPoints;
    if (idx >= points.count - 1) {
        return path;
    }
    
    CGPoint p0; // idx -1
    CGPoint p1 = [self pointWithPoint:points[idx]];
    CGPoint p = [self pointWithPoint:points[idx+1]]; // idx + 1
    CGPoint p3; // idx + 2
    if(idx == 0) {
        p0 = [self pointWithPoint:_beginRefPoint];
    }else {
        p0 = [self pointWithPoint:points[idx-1]];
    }
    
    if(idx == points.count - 2){
        p3 = [self pointWithPoint:_endRefPoint];
    }else {
        p3 = [self pointWithPoint:points[idx+2]];
    }
    
    
    CGFloat x0 = p0.x, y0 = p0.y;
    CGFloat x1 = p1.x, y1 = p1.y;
    CGFloat x2 = p.x, y2 = p.y;
    CGFloat x3 = p3.x, y3 = p3.y;
    
    // 1.假设控制点在(x1,y1)和(x2,y2)之间，第一个点和最后一个点分别是曲线路径上的上一个点和下一个点
    // 2.求中点
    CGFloat xc1 = (x0 + x1) / 2.0;
    CGFloat yc1 = (y0 + y1) / 2.0;
    CGFloat xc2 = (x1 + x2) / 2.0;
    CGFloat yc2 = (y1 + y2) / 2.0;
    CGFloat xc3 = (x2 + x3) / 2.0;
    CGFloat yc3 = (y2 + y3) / 2.0;
    
    // 3.求各中点连线长度
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    
    // 4.求中点连线长度比例（用来确定平移前p2, p3的位置）
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    
    // 5.平移p2
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    
    // 6.平移p3
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;

    // 7.微调控制点与顶点之间的距离，越大曲线越平直
    CGFloat ctrl1_x = (xc2 - xm1) * self.B + x1 ;
    CGFloat ctrl1_y = (yc2 - ym1) * self.B + y1;
    CGFloat ctrl2_x = (xc2 - xm2) * self.B + x2;
    CGFloat ctrl2_y = (yc2 - ym2) * self.B + y2;
    
    CGPoint ctrP1 = CGPointMake(ctrl1_x, ctrl1_y);
    CGPoint ctrP2 = CGPointMake(ctrl2_x, ctrl2_y);
    [path addCurveToPoint:p controlPoint1:ctrP1 controlPoint2:ctrP2];
    
    return path;
}

- (CGPoint)pointWithPoint:(TLCurvePoint *)point {
    return point.point;
}
@end

