//
//  TLCurveChartObject.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2020/1/15.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "TLCurveChartObject.h"



// MARK: - TLPointTipItem
@implementation TLPointTipItem
- (instancetype)init {
    if (self = [super init]) {
        _titleColor = [UIColor colorWithWhite:0.85 alpha:1];
        _valueColor = [UIColor colorWithWhite:1 alpha:1];
        _titleFont = [UIFont systemFontOfSize:10];
        _valueFont = [UIFont systemFontOfSize:10];
    }
    return self;
}

+ (instancetype)itemWhitTitle:( NSString * _Nonnull )title value:( NSString * _Nonnull )value {
    TLPointTipItem *item = [[self alloc] init];
    item.title = title;
    item.value = value;
    return item;
}

- (NSAttributedString *)attributedText {
    NSString *title = _title ? _title : @"";
    NSString *value = _value ? _value : @"";
    
    NSString *text = [NSString stringWithFormat:@"%@\t%@", title, value];
    NSDictionary *dict = @{
        NSForegroundColorAttributeName: _titleColor,
        NSFontAttributeName: _titleFont
    };
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                  attributes:dict];
    NSDictionary *dict2 = @{
         NSForegroundColorAttributeName: _valueColor,
         NSFontAttributeName: _valueFont
    };
    [attString setAttributes:dict2 range:[text rangeOfString:value]];
    
    return attString;
}

@end


// MARK: - TLCurvePoint
@implementation TLCurvePoint {
    CGFloat _gridW, _gridH;
    CGFloat _maxY;
    CGFloat _gridCountOfY;
}

+ (instancetype)pointWithIndex:(NSInteger)index
                        xValue:(NSString *)xValue
                        yValue:(NSString *)yValue
                       isFirst:(BOOL)isFirst
                        isLast:(BOOL)isLast
{
    TLCurvePoint *pObj = [[self alloc] init];
    pObj.yValue = yValue;
    pObj.index = index;
    pObj.xValue = xValue;
    pObj.isFirst = isFirst;
    pObj.isLast = isLast;
    return pObj;
}

+ (instancetype)placeholderPointWithIndex:(NSInteger)index xValue:(NSString *)xValue
{
    TLCurvePoint *pObj = [[self alloc] init];
    pObj.isPlaceholder = YES;
    pObj.index = index;
    pObj.xValue = xValue;
    return pObj;
}

- (CGPoint)point {
    CGPoint p = CGPointMake(_index * _gridW + _offsetX, (1.00 - _yValue.floatValue / _maxY) * _gridCountOfY * _gridH);
    return p;
}

- (void)updateGridWidth:(CGFloat)width heitht:(CGFloat)height
               countOfY:(NSUInteger)count maxY:(CGFloat)y
{
    _gridW = width;
    _gridH = height;
    _maxY = y;
    _gridCountOfY = count;
}

- (CGFloat)xWithOffsetX:(CGFloat)offsetX {
    return _index * _gridW + offsetX;
}
@end




// MARK: - TLCurveObject
@implementation TLCurveObject
- (instancetype)init {
    if (self = [super init]) {
        self.showPoint = YES;
        self.needFill = YES;
        self.lineColor = UIColorFromRGB(0x1F8CE8);
        self.fillColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.91 alpha:0.3];
        self.pointColor = UIColorFromRGB(0xE1F1FF);
        self.selectedPointColor = UIColorFromRGB(0x1F8CE8);
        self.lineType = TLLineTypeLine;
    }
    return self;
}

+ (instancetype)objectWithID:(NSUInteger)ID points:(NSArray <TLCurvePoint *> *)points {
    TLCurveObject *obj = [[self alloc] init];
    
    obj.ID = ID;
    obj.points = points;
    return obj;
}

@end





// MARK: - TLCurveChartObject
@implementation TLCurveChartObject {
    NSMutableArray <void(^)(void)>* _blocks;
}

- (instancetype)init {
    if (self == [super init]) {
        _gridCountOfX = 7;
        _gridCountOfX = 6;
//        _lineType = TLLineTypeLine;
        _isLeftToRight = YES;
        _selectedIndex = -1;
        _axisInset = kAxisInset;
    }
    return self;
}

+ (instancetype)objectWithCurves:(NSArray <TLCurveObject *> *)curves {
    NSAssert(curves.count > 0, @"TLCurveChartObject实例curves属性必须包含一条或以上TLCurveObject实例");
    
    TLCurveChartObject *obj = [[self alloc] init];
    obj.curves = curves;
    
    return obj;
}

- (NSArray<NSString *> *)yInfos {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:_gridCountOfY + 1];
    [temp addObject:@"0"];
    if (_maxY && _gridCountOfY) {
        NSInteger gridVal = _maxY / _gridCountOfY;
        NSInteger val = gridVal;
        while (val <= _maxY) {
            [temp addObject:@(val).stringValue];
            val += gridVal;
        }
        return temp;
    }
    return @[@"0"];
}

- (NSInteger)indexOfPoint:(CGPoint)point {
   NSArray <TLCurvePoint *>*temp = self.curves.firstObject.points;
    if (temp.count == 0 || point.y < 0 || point.y > _gridCountOfY * _gridH) {
        return -1;
    }else if (temp.count == 1){
        return 0;
    }
    
    for (NSInteger i = 0; i < temp.count; i++) {
        if (ABS(temp[i].point.x - point.x) <= _gridW * 0.5) {
            return i;
        }
    }
    return temp.count - 1;
}

/// 从左向右滑，offsetX增大；从右向左滑，offsetX减小
- (void)setOffsetX:(CGFloat)offsetX {
    if(_gridW <= 0) return;
    
    
    NSInteger pCount = self.curves.firstObject.points.count;
    if(_isLeftToRight) {
        // 起始修正，向右平移一屏
        offsetX += pCount - 1 <= _gridCountOfX ? (pCount - 1) * _gridW : _gridCountOfX * _gridW;
    }
    NSInteger beginIndex = [self beginIndexWithOffsetX:offsetX];
    NSInteger endIndex = [self endIndexWithOffsetX:offsetX beginIndex:beginIndex];
    
    // 即将显示的坐标点
    NSMutableArray *tempPoints = [NSMutableArray array];
    for (TLCurveObject *cObj in self.curves) {
        for (NSInteger i = beginIndex; i <= endIndex; i++) {
            TLCurvePoint *pointObj = cObj.points[i];
            [pointObj setOffsetX:offsetX]; // 坐标漂移
            [tempPoints addObject:pointObj];
        }
        cObj.curPoints = tempPoints;
    }
    
    _offsetX = offsetX;
    _beginIndex = beginIndex;
    _endIndex = endIndex;
    
    if (_blocks.count && _curves.firstObject.curPoints.count) {
        [_blocks enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                obj();
            });
        }];        
    }
}

- (NSUInteger)beginIndexWithOffsetX:(CGFloat)offsetX {
    NSArray <TLCurvePoint *>*points = self.curves.firstObject.points;
    if (_isLeftToRight) {
        if (points.count < _gridCountOfX) {
            return 0;
        }
        CGFloat maxX = _gridW * _gridCountOfX + _indentX;
        if (offsetX >= _offsetX) { // 向右滑动,向后遍历
            for(NSInteger i = _beginIndex; i < points.count; i++ ) {
                TLCurvePoint *p = points[i];
                CGFloat x = [p xWithOffsetX:offsetX];
                if (x - maxX >= 0 && x - maxX <= _gridW) {
                    return i;
                }
            }
        }else { // 向左滑动,向前遍历
            for(NSInteger i = _beginIndex; i >= 0; i-- ) {
                TLCurvePoint *p = points[i];
                CGFloat x = [p xWithOffsetX:offsetX];
                if (x - maxX >= 0 && x - maxX <= _gridW) {
                    return i;
                }
            }
        }
    }else {
        if (points.count < _gridCountOfX) {
            return 0;
        }
        if (offsetX <= _offsetX) { // 向左滑动,向后遍历
            for(NSInteger i = _beginIndex; i < points.count; i++ ) {
                TLCurvePoint *p = points[i];
                CGFloat x = [p xWithOffsetX:offsetX];
                if (x <= 0 && x >= -_gridW) {
                    return i;
                }
            }
        }else { // 向右滑动,向前遍历
            for(NSInteger i = _beginIndex; i >= 0; i-- ) {
                TLCurvePoint *p = points[i];
                CGFloat x = [p xWithOffsetX:offsetX];
                if (x <= 0 && x >= -_gridW) {
                    return i;
                }
            }
        }
    }
    
    return _beginIndex;
}

- (NSUInteger)endIndexWithOffsetX:(CGFloat)offsetX beginIndex:(NSInteger)beginIndex {
    NSInteger maxIndex = self.curves.firstObject.points.count - 1;
    NSInteger index =  beginIndex + _gridCountOfX + 2;
    
    return index > maxIndex ? maxIndex : index;
}

- (void)updateGridLayoutWithSize:(CGSize)size {
    if (_gridCountOfX && _gridCountOfY) {
        CGFloat gridW = (size.width - _axisInset.left - _axisInset.right - _indentX) / _gridCountOfX;
        CGFloat gridH = (size.height - _axisInset.top - _axisInset.bottom) / _gridCountOfY;
        
        if (gridW > 0 && self.gridW != gridW) {
            _gridW = gridW;
            _gridH = gridH;
            
            for (TLCurveObject *cObj in self.curves) {
                for (TLCurvePoint *p in cObj.points) {
                    [p updateGridWidth:_isLeftToRight ? -_gridW : _gridW
                                heitht:_gridH
                              countOfY:_gridCountOfY
                                  maxY:_maxY];
                }
            }
        }
    }
}

- (void)addDidUpdateOffsetXBlock:(void(^)(void))setOffsetXBlock {
    if(!_blocks) {
        _blocks = [NSMutableArray array];
    }
    
    if (setOffsetXBlock) {
        [_blocks addObject:setOffsetXBlock];
    }
}
@end
