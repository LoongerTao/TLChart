//
//  TLTextLayer.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class TLCurveChartObject;
@interface TLTextLayer : CALayer

/// X轴的坐标Y值
@property(nonatomic, assign) CGFloat yOfXAxis;
@property(nonatomic, strong) TLCurveChartObject *chartObj;

@end

NS_ASSUME_NONNULL_END
