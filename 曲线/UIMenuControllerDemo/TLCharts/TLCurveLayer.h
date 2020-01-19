//
//  TLCurveLayer.h
//  
//
//  Created by 故乡的云 on 2018/10/15.
//  Copyright © 2018 故乡的云. All rights reserved.
//  曲线绘制层，支持2条曲线同时绘制

#import <QuartzCore/QuartzCore.h>
#import "TLChartsConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@class TLCurveChartObject;
@interface TLCurveLayer : CALayer


// ======= 测试辅助数据·顺滑基数 ======= //
@property(assign, nonatomic) CGFloat A;
@property(assign, nonatomic) CGFloat B;




/// 图表曲线对象
@property(nonatomic, strong) TLCurveChartObject *chartObj;
/// 移动使能
@property(assign, nonatomic, readonly) BOOL canMove;


/// 选中
- (void)showTipsWithPoint:(CGPoint)point;
/// 移动
- (void)setOffsetX:(CGFloat)offsetX;

/// 指定的实例创建方法
+ (instancetype)layerWithCurveChartObject:(TLCurveChartObject * _Nonnull )chartObj;
/// 指定的初始化方法
- (instancetype)initWithCurveChartObject:(TLCurveChartObject * _Nonnull )chartObj NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
