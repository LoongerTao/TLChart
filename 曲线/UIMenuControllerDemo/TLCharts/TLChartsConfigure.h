//
//  TLChartsConfigure.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2018/10/18.
//  Copyright © 2018 故乡的云. All rights reserved.
//

#ifndef TLChartsConfigure_h
#define TLChartsConfigure_h

#import <UIKit/UIKit.h>

#endif /* TLChartsConfigure_h */

#pragma mark - Debug
#define TLParameterAssert(condition) NSAssert((condition), @"无效的参数: %@", @#condition);


#pragma mark - 枚举
/// 曲线样式
typedef enum : NSUInteger {
    TLLineTypeBezierCurve = 0,      // 贝塞尔（计算公式1）
    TLLineTypeBezierCurve2,         // 贝塞尔2（与TLCurveLineTypeBezierOne计算公式不同）
    TLLineTypeFakeBezierCurve,      // 带修饰的贝塞尔
    TLLineTypeFakeSine,             // 伪正玄
    TLLineTypeFakeSine2,            // 伪正玄（带修饰）
    TLLineTypeLine,                 // 折线(默认)
} TLLineType;

#pragma mark - 宏
/// Y方向网格的数量(决定网格的高度)
//#define kGridCountOfY 3
/// X方向网格的数量（决定网格宽度）
//#define kGridCountOfX 6

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kAxisInset UIEdgeInsetsMake(60.f, 50.f, 40.f, 0.f)

/// 超出坐标轴边界误差范围（边界外的仍然可选中范围）
#define kOutMarginOfShowSelectPoint 10.f

/// 贝塞尔曲线控制点顺滑基数
#define kBezierCurveSmoothValue 0.20f   // 0~1
/// 贝塞尔曲线控制点顺滑基数2(对应 TLLineTypeBezierCurve2)
#define kBezierCurveSmoothValue2 0.20f   // 0~1



/// 网格线宽度
#define kGridWidth 0.3f
/// 网格线颜色
#define kGridCGColor ([UIColor colorWithWhite:220.0f / 255 alpha:1.0f].CGColor)
/// 网格填充颜色
#define kGridFillCGColor ([UIColor clearColor].CGColor)

/// 坐标轴颜色
#define kAxisCGColor UIColorFromRGB(0xC4C6CF).CGColor
/// 坐标轴文字颜色1
#define kAxisTextCGColor1 ([UIColor colorWithWhite:0.7f alpha:1.f].CGColor)
/// 坐标轴文字颜色2
#define kAxisTextCGColor2 ([UIColor colorWithWhite:0.6f alpha:1.f].CGColor)
/// 标题字体颜色
#define kTitleColor ([UIColor colorWithRed:98/255.0 green:110/255.0 blue:127/255.0 alpha:1].CGColor)
/// 副标题字体颜色
#define kSubTitleColor ([UIColor colorWithRed:98/255.0 green:110/255.0 blue:127/255.0 alpha:1].CGColor)


/// 选中点提示字体
#define kTipsFont [UIFont fontWithName:@"Gill Sans" size:12.f]
/// 坐标轴字体
#define kAxisFont [UIFont fontWithName:@"DIN Condensed" size:10.f]
/// 标题字体
#define kTitleFont [UIFont fontWithName:@"DIN Condensed" size:14.f]
/// 副标题字体
#define kSubTitleFont [UIFont fontWithName:@"DIN Condensed" size:12.f]


/* 系统字体名称表
Copperplate,
Heiti SC,
Apple SD Gothic Neo,
Thonburi,
Gill Sans,
Marker Felt,
Hiragino Maru Gothic ProN,
Courier New,
Kohinoor Telugu,
Heiti TC,
Avenir Next Condensed,
Tamil Sangam MN,
Helvetica Neue,
Gurmukhi MN,
Georgia,
Times New Roman,
Sinhala Sangam MN,
Arial Rounded MT Bold,
Kailasa,
Kohinoor Devanagari,
Kohinoor Bangla,
Chalkboard SE,
Apple Color Emoji,
PingFang TC,
Gujarati Sangam MN,
Geeza Pro,
Damascus,
Noteworthy,
Avenir,
Mishafi,
Academy Engraved LET,
Futura,
Party LET,
Kannada Sangam MN,
Arial Hebrew,
Farah,
Arial,
Chalkduster,
Kefa,
Hoefler Text,
Optima,
Palatino,
Malayalam Sangam MN,
Al Nile,
Lao Sangam MN,
Bradley Hand,
Hiragino Mincho ProN,
PingFang HK,
Helvetica,
Courier,
Cochin,
Trebuchet MS,
Devanagari Sangam MN,
Oriya Sangam MN,
Rockwell,
Snell Roundhand,
Zapf Dingbats,
Bodoni 72,
Verdana,
American Typewriter,
Avenir Next,
Baskerville,
Khmer Sangam MN,
Didot,
Savoye LET,
Bodoni Ornaments,
Symbol,
Charter,
Menlo,
Noto Nastaliq Urdu,
Bodoni 72 Smallcaps,
DIN Alternate,
Papyrus,
Hiragino Sans,
PingFang SC,
Myanmar Sangam MN,
Noto Sans Chakma,
Zapfino,
Telugu Sangam MN,
Bodoni 72 Oldstyle,
Euphemia UCAS,
Bangla Sangam MN,
DIN Condensed
*/


