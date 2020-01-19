//
//  TLChartView.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TLChartTypeCurve = 0,   // 曲线、折线
//    TLChartTypeMatrix,  // 矩阵（未实现）
} TLChartType;

@class TLCurveLayer, TLCurveChartObject;
NS_ASSUME_NONNULL_BEGIN

@interface TLChartView : UIView
/// chartType == TLChartTypeCurve 时有值
@property(nonatomic, weak, readonly) TLCurveLayer *curvelLayer;
/// 图标类型（曲线、矩阵） 预留字段
@property(nonatomic, assign) TLChartType chartType;
/// 图表曲线对象
@property(nonatomic, strong) TLCurveChartObject *chartObj;

/// （默认高240），chartType为预留字段，默认传0 或者TLChartTypeCurve即可
+ (instancetype)chartWithType:(TLChartType)chartType;
@end

NS_ASSUME_NONNULL_END
