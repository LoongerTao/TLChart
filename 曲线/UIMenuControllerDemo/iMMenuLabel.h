//
//  iMMenuLabel.h
//  iManage
//
//  Created by 故乡的云 on 2018/1/23.
//  Copyright © 2018年 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^iMMenuItemDidClick)(NSString *title,UIMenuController *menu);

@interface iMMenuLabel : UILabel

/** 允许复制：默认YES */
@property (nonatomic,assign) BOOL allowCopy;
/** Ping：默认NO */
@property (nonatomic,assign) BOOL allowPing;
/** tracert：默认NO */
@property (nonatomic,assign) BOOL allowTracert;
/** tcping：默认NO */
@property (nonatomic,assign) BOOL allowTcping;
/** ipconfig：默认NO */
@property (nonatomic,assign) BOOL allowDig;
/** 生成报告：默认NO */
@property (nonatomic,assign) BOOL allowReport;

/** 自定义的MenuItem被点击 */
@property (nonatomic,copy) iMMenuItemDidClick itemDidClick;

- (void)ableAllMemus;
- (void)disAbleAllMemus;


@end
