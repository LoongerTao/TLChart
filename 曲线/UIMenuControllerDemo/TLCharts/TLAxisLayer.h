//
//  TLAxisLayer.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  坐标轴和网格层

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class TLCurveChartObject;
@interface TLAxisLayer : CAShapeLayer

/// 图表曲线对象
@property(nonatomic, weak) TLCurveChartObject *chartObj;

- (void)draw;

/// 绘制网格（动态）
- (void)drawGrids;
@end

NS_ASSUME_NONNULL_END
