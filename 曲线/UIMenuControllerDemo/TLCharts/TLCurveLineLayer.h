//
//  TLCurveLineLayer.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  曲线绘制层

#import <QuartzCore/QuartzCore.h>
#import "TLChartsConfigure.h"


NS_ASSUME_NONNULL_BEGIN

@class TLCurveObject, TLCurvePoint;

@interface TLCurveLineLayer : CAShapeLayer

// 控制点计算参考点
@property(nonatomic, strong) TLCurvePoint *beginRefPoint;
@property(nonatomic, strong) TLCurvePoint *endRefPoint;


@property(assign, nonatomic) CGFloat A;
@property(assign, nonatomic) CGFloat B;


@property(nonatomic, weak) TLCurveObject *curveObject;

- (void)draw;
- (instancetype)initWithCurveObject:(TLCurveObject *)curveObject;
@end

NS_ASSUME_NONNULL_END
