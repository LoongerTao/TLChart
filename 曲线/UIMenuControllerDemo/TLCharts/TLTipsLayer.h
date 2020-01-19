//
//  TLTipsLayer.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//  选中坐标标注信息层

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class TLCurveChartObject;
@interface TLTipsLayer : CAShapeLayer

@property(nonatomic, weak) TLCurveChartObject *chartObj;

- (void)refreshTips;
@end

NS_ASSUME_NONNULL_END
