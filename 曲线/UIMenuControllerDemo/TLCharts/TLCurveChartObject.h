//
//  TLCurveChartObject.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2020/1/15.
//  Copyright © 2020 故乡的云. All rights reserved.
//  曲线图表对象：1个曲线图表对象由若干个曲线对象组成，1曲线对象由干个点对象组成




#import "TLChartsConfigure.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - TLCurvePoint 选中点要显示的字段
@interface TLPointTipItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *value;

/// 默认：[UIColor colorWithWhite:0.85 alpha:1];
@property(nonatomic, strong) UIColor *titleColor;
/// 默认: [UIColor colorWithWhite:1 alpha:1];
@property(nonatomic, strong) UIColor *valueColor;
/// 默认：[UIFont systemFontOfSize:10];
@property(nonatomic, strong) UIFont *titleFont;
/// 默认：[UIFont systemFontOfSize:10];
@property(nonatomic, strong) UIFont *valueFont;
/// title + value
@property(nonatomic, strong, readonly) NSAttributedString *attributedText;

+ (instancetype)itemWhitTitle:( NSString * _Nonnull )title value:( NSString * _Nonnull )value;
@end



// MARK: - TLCurvePoint 曲线点对象
/// 曲线点对象，点与点之间间隔一致
@interface TLCurvePoint : NSObject 
/// 空白点，用来占位
@property(nonatomic, assign) BOOL isPlaceholder;
/// 点在曲线中的索引，包括空白点、可以为负
@property(nonatomic, assign) NSInteger index;
/// 实时坐标值
@property(nonatomic, assign, readonly) CGPoint point;
/// x方向偏移量
@property(nonatomic, assign)  CGFloat offsetX;
/// value of x,  真实值
@property(nonatomic, copy) NSString *xValue;
/// value of y，真实值
@property(nonatomic, copy) NSString *yValue;
/// X轴副标题
@property(nonatomic, copy) NSString *xSubValue;
/// 第一个有效点
@property(nonatomic, assign) BOOL isFirst;
/// 最后一个有效点
@property(nonatomic, assign) BOOL isLast;
/// 选中点要显示的字段集合
@property(nonatomic, strong) NSArray <TLPointTipItem *>*tipItems;

/// 非空白点
+ (instancetype)pointWithIndex:(NSInteger)index
                        xValue:(NSString *)xValue
                        yValue:(NSString *)yValue
                       isFirst:(BOOL)isFirst
                        isLast:(BOOL)isLast;
/// 空白点
+ (instancetype)placeholderPointWithIndex:(NSInteger)index xValue:(NSString *)xValue;

- (void)updateGridWidth:(CGFloat)width heitht:(CGFloat)height
               countOfY:(NSUInteger)count maxY:(CGFloat)y;
- (CGFloat)xWithOffsetX:(CGFloat)offsetX;
@end




// MARK: - TLCurveObject 曲线对象
/// 曲线对象
@interface TLCurveObject : NSObject
/// 唯一id（相对于所在TLCurveChartObject对象唯一）
@property(nonatomic, assign) NSUInteger ID;
/// 曲线名称
@property(nonatomic, copy) NSString *name;
/// 曲线说明备注
@property(nonatomic, copy) NSString *remark;
/// 曲线样式，默认 TLLineTypeLine
@property(assign, nonatomic) TLLineType lineType;
/// 是否需要填充，默认YES
@property(nonatomic, assign) BOOL needFill;
/// 是否需要填充，默认YES
@property(nonatomic, assign) BOOL showPoint;
/// 填充颜色，[UIColor colorWithRed:0.12 green:0.55 blue:0.91 alpha:0.3];
@property(nonatomic, strong) UIColor *fillColor;
/// 线条颜色，0x1F8CE8
@property(nonatomic, strong) UIColor *lineColor;
/// 坐标点颜色，0xE1F1FF
@property(nonatomic, strong) UIColor *pointColor;
/// 选中坐标点颜色，0x1F8CE8
@property(nonatomic, strong) UIColor *selectedPointColor;
/// 其他信息
@property(nonatomic, strong) id extraInfo;
/// 曲线点集合
@property(nonatomic, strong) NSArray <TLCurvePoint *>*points;
/// 曲线即将或当前渲染的点集合
@property(nonatomic, strong) NSArray <TLCurvePoint *>*curPoints;

/// 推荐的实例创建方法
+ (instancetype)objectWithID:(NSUInteger)ID points:(NSArray <TLCurvePoint *> *)points;
@end



// MARK: - TLCurveChartObject 图表曲线对象
/// 图表曲线对象
@interface TLCurveChartObject : NSObject
/// 主标题
@property(nonatomic, copy) NSString *title;
/// 副标题
@property(nonatomic, copy) NSString *subTitle;
/// x轴标题（单位）
@property(nonatomic, copy) NSString *xName;
/// y轴标题（单位）
@property(nonatomic, copy) NSString *yName;

/// y轴坐标值，将y轴yInfos.count-1等分 决定y轴网格数
@property(nonatomic, strong, readonly) NSArray <NSString *>*yInfos;
/// y轴最大值(⚠️maxY建议为gridCountOfY的整数倍)
@property(nonatomic, assign) CGFloat maxY;
/// x轴网格数,默认7
@property(nonatomic, assign) CGFloat gridCountOfX;
/// y轴网格数,默认7
@property(nonatomic, assign) CGFloat gridCountOfY;
/// 轴网格Width: （x轴的宽度 - indentX）/ gridCountOfX
@property(nonatomic, assign, readonly) CGFloat gridW;
/// 轴网格Hight：y轴的高 / gridCountOfY
@property(nonatomic, assign, readonly) CGFloat gridH;
/// X轴右边的缩进，默认0
@property(nonatomic, assign) CGFloat indentX;

/// 坐标轴与图标边界的距离 ,默认：（60.f, 50.f, 40.f, 0.f）
@property(nonatomic, assign) UIEdgeInsets axisInset;

/// 其他信息
@property(nonatomic, strong) id extraInfo;
/// 曲线集合，如果同时渲染多条曲线需保证所有曲线点的个数一致（没有的点用占位点补充）
@property(nonatomic, strong) NSArray <TLCurveObject *>*curves;
/// 曲线样式
//@property(assign, nonatomic) TLLineType lineType;
/// 隐藏网格，Default： NO
@property(nonatomic, assign) BOOL hideGrids;
/// 隐藏坐标轴, Default is NO
@property(nonatomic, assign) BOOL hideAxis;
/// 滑动方向，默认YES：从左向右， NO：从右向左
@property(nonatomic, assign) BOOL isLeftToRight;

/// 实时数据
/// 当前图标x轴方向偏移量
@property(nonatomic, assign) CGFloat offsetX;
/// 当前渲染点的起始索引
@property(nonatomic, assign) NSUInteger beginIndex;
/// 当前渲染点的结束索引
@property(nonatomic, assign) NSUInteger endIndex;
/// 选中点的索引,默认 -1(不选中)
@property(nonatomic, assign) NSInteger selectedIndex;

/// 推荐的实例创建方法
+ (instancetype)objectWithCurves:(NSArray <TLCurveObject *> *)curves;

/// 返回离x最近的点在数组中的索引
- (NSInteger)indexOfPoint:(CGPoint)point;
/// 更新布局属性
- (void)updateGridLayoutWithSize:(CGSize)size;

/// 添加setOffsetX 监听回调
- (void)addDidUpdateOffsetXBlock:(void(^)(void))setOffsetXBlock;
@end

NS_ASSUME_NONNULL_END
