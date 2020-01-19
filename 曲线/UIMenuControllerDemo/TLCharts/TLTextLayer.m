//
//  TLTextLayer.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/16.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#import "TLTextLayer.h"
#import "TLChartsConfigure.h"
#import "TLCurveChartObject.h"

@implementation TLTextLayer {
    CALayer *_XTextsLayer;
    CALayer *_YTextsLayer;
    CATextLayer *_remark1Layer;
    CATextLayer *_remark2Layer;
    CATextLayer *_titleLayer;
    CATextLayer *_subTitleLayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointZero;
        _yOfXAxis = 0;
        _XTextsLayer = [CALayer layer];
        _XTextsLayer.anchorPoint = CGPointZero;
        [self addSublayer:_XTextsLayer];
                
        _YTextsLayer = [CALayer layer];
        _YTextsLayer.anchorPoint = CGPointZero;
        [self addSublayer:_YTextsLayer];
        
        _XTextsLayer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    if (!_chartObj) return;
    
    CGSize size = self.bounds.size;
    CGFloat margin = self.chartObj.axisInset.left - self.chartObj.gridW * 0.5;
    CGFloat marginR = self.chartObj.axisInset.right - self.chartObj.gridW * 0.5;
    if (marginR < 0) marginR = 0;
    _XTextsLayer.frame = CGRectMake(margin,
                                    _yOfXAxis,
                                    size.width - margin - marginR,
                                    size.height - _yOfXAxis);
    _YTextsLayer.frame = CGRectMake(0.f, 0.f, self.chartObj.axisInset.left, size.height);
    
    [self draw];
}

- (void)refreshTitle {
    if (_titleLayer) {
        _titleLayer.string = self.chartObj.title;
        [_titleLayer setNeedsDisplay];
        return;
    }
    
    CGFloat left = 16.f;
    CGFloat top = 5.f;
    CGFloat W = 200.f;
    CGFloat H = 20.f;
    _titleLayer = [self drawText:self.chartObj.title
                          inRect:CGRectMake(left, top , W, H)
                   alignmentMode:kCAAlignmentLeft
                           color:kTitleColor
                            font:kTitleFont
                        fontSize: 16.f
                         inLayer:self];
}

- (void)refreshSubTitle {
    if (_subTitleLayer) {
        _subTitleLayer.string = self.chartObj.subTitle;
        [_subTitleLayer setNeedsDisplay];
        return;
    }
    
    CGFloat left = 16.f;
    CGFloat top = 30.f;
    CGFloat W = 120.f;
    CGFloat H = 20.f;
    _subTitleLayer = [self drawText:self.chartObj.subTitle
                             inRect:CGRectMake(left, top , W, H)
                      alignmentMode:kCAAlignmentLeft
                              color:kSubTitleColor
                               font:kSubTitleFont
                           fontSize: 14.f
                            inLayer:self];
}

- (void)refreshYInfos {
    NSArray *temp = [self->_YTextsLayer.sublayers mutableCopy];
    for (CALayer *layer in temp) {
        [layer removeFromSuperlayer];
    }
    
    CGFloat H = _yOfXAxis;
    for (NSInteger i = 0; i < self.chartObj.yInfos.count; i++) {
        [self drawText:self.chartObj.yInfos[i]
                     inRect:CGRectMake(0, H - i * self.chartObj.gridH - 5.f , 36.f, 20.f)
              alignmentMode:kCAAlignmentRight
                      color:kAxisTextCGColor1
                       font:kAxisFont
                   fontSize: 10.f
                    inLayer:_YTextsLayer];
    }
}

- (void)refreshXInfos {
    NSArray *temp = [self->_XTextsLayer.sublayers mutableCopy];
    for (CALayer *layer in temp) {
        [layer removeFromSuperlayer];
    }
   
    NSArray <TLCurvePoint *>* points = self.chartObj.curves.firstObject.curPoints;
    for (NSInteger i = 0; i < points.count; i++) {
        TLCurvePoint *pObj = points[i];
        CGFloat X = pObj.point.x;
        CGFloat top = 8.f;
        if (pObj.xValue.length) {
            [self drawText:pObj.xValue
                    inRect:CGRectMake(X , top , self.chartObj.gridW, 20.f)
             alignmentMode:kCAAlignmentCenter
                     color:kAxisTextCGColor1
                      font:kAxisFont
                  fontSize: 10.f
                   inLayer:_XTextsLayer];
            top = 20.f;
        }
        if (pObj.xSubValue.length) {
            [self drawText:pObj.xSubValue
                    inRect:CGRectMake(X, top , self.chartObj.gridW, 20.f)
             alignmentMode:kCAAlignmentCenter
                     color:kAxisTextCGColor2
                      font:kAxisFont
                  fontSize: 10.f
                   inLayer:_XTextsLayer];
        }
    }
}

- (void)drawRemarkOfLine {
    /*
    if(_remark1Layer) {
        _remark1Layer.string = self.chartObj.remark;
        _remark2Layer.string = _remark2;
        [_remark1Layer setNeedsDisplay];
        [_remark1Layer setNeedsDisplay];
        return;
    }
    
    CGFloat textW = 70.f;
    CGFloat textH = 16.f;
    CGFloat textLeft = self.bounds.size.width - textW;
    CGFloat textTop = 20.f;
    
    CGFloat lineH = 2.f;
    CGFloat lineW = 5.f;
    CGFloat lineTop = textTop + 6.f;
    CGFloat lineLeft = textLeft - lineW - 5.f;
    
    CALayer *line1 = [CALayer layer];
    line1.backgroundColor = kCurvelLine1CGColor;
    line1.frame = CGRectMake(lineLeft, lineTop, lineW, lineH);
    [self addSublayer:line1];
    
    CALayer *line2 = [CALayer layer];
    line2.backgroundColor = kCurvelLine2CGColor;
    line2.frame = CGRectMake(lineLeft, textTop + textH + 6.f, lineW, lineH);
    [self addSublayer:line2];
    
    _remark1Layer = [self drawText:_remark1
                            inRect:CGRectMake(textLeft, textTop , textW, textH)
                     alignmentMode:kCAAlignmentLeft
                             color:kCurvelLine1CGColor
                              font:kTipsFont
                         fontSize: 10.f
                           inLayer:self];
    
    _remark2Layer = [self drawText:_remark2
                            inRect:CGRectMake(textLeft, textTop + textH , textW, textH)
                     alignmentMode:kCAAlignmentLeft
                             color:kCurvelLine2CGColor
                              font:kTipsFont
                         fontSize: 10.f
                           inLayer:self];*/
}

- (CATextLayer *)drawText:(NSString *)text
                   inRect:(CGRect)rect
            alignmentMode:(CATextLayerAlignmentMode)alignmentMode
                    color:(CGColorRef)color
                     font:(UIFont *)font
                 fontSize:(CGFloat)fontSize
                  inLayer:(CALayer *)layer {
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.fontSize = fontSize;
    textLayer.foregroundColor = color;
    textLayer.string = text;
    textLayer.frame = rect;
    textLayer.font = (__bridge CFTypeRef _Nullable)(font);
    textLayer.alignmentMode = alignmentMode;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:textLayer];
    [textLayer setNeedsDisplay];
    
    return textLayer;
}

- (void)draw {
    if (_chartObj && _yOfXAxis > 0) {        
        [self drawRemarkOfLine];
        [self refreshTitle];
        [self refreshSubTitle];
        [self refreshYInfos];
        [self refreshXInfos];
    }
}

- (void)setChartObj:(TLCurveChartObject *)chartObj {
    _chartObj = chartObj;
    
    [self layoutSublayers];
    
    __weak TLTextLayer *wself = self;
    [chartObj addDidUpdateOffsetXBlock:^{
        [wself refreshXInfos];
    }];
    
    [self draw];
}


@end
