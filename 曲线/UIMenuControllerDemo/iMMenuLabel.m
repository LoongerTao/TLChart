//
//  iMMenuLabel.m
//  iManage
//
//  Created by 故乡的云 on 2018/1/23.
//  Copyright © 2018年 故乡的云. All rights reserved.
//  带UIMenuController的Label

#import "iMMenuLabel.h"
@interface iMMenuLabel ()
/** Menu items */
@property (nonatomic,strong) NSMutableArray <UIMenuItem *>*items;
/** Menu items */
@property (nonatomic,strong) UIColor *bgColor;
@end

@implementation iMMenuLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    _allowCopy = YES;
    _allowPing = YES;
    _allowTracert = NO;
    _allowTcping = YES;
    _allowDig = NO;
    _allowReport = YES;
    UILongPressGestureRecognizer *longPress
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(onLongPress:)];
    [self addGestureRecognizer:longPress];
    
   
}

// 不能是 - (BOOL)becomeFirstResponder
- (BOOL)canBecomeFirstResponder{
    return self.allowCopy || self.allowPing ||
           self.allowTracert || self.allowTcping ||
           self.allowDig || _allowReport;
}

/**
 * label能执行哪些操作(比如copy, paste等等)
 * @return  YES:支持这种操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyText:)){
        return self.allowCopy;
    }
    if (action == @selector(ping:)){
        return self.allowPing;
    }
    if (action == @selector(tracert:)){
        return self.allowTracert;
    }
    if (action == @selector(tcping:)){
        return self.allowTcping;
    }
    if (action == @selector(dig:)){
        return self.allowDig;
    }
    if (action == @selector(report:)){
        return self.allowReport;
    }
    return NO; // 禁止系统类型
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            _bgColor = self.backgroundColor;
            self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
            
            // 需要显示的额外条件
            if (self.text == nil || self.text.length < 1) return;
            if (![self canBecomeFirstResponder]) return;
        
            [self becomeFirstResponder];
            
            // 创建UIMenuItem
            NSArray *titles = @[@"Ping",@"Tracert",@"Tcping",@"Dig",@"生成报告",@"复制"];
            NSArray *actions = @[@"ping:",@"tracert:",@"tcping:",@"dig:",@"report:",@"copyText:"];
            self.items = [NSMutableArray array];
            for (NSString *title in titles) {
                NSUInteger index = [titles indexOfObject:title];
                SEL sel = NSSelectorFromString(actions[index]);
                UIMenuItem *newItem = [[UIMenuItem alloc] initWithTitle:title action:sel];
                [self.items addObject:newItem];
            }
            
            // 获取UIMenuController单例
            UIMenuController *controller = [UIMenuController sharedMenuController];
            controller.menuItems = self.items;
            [controller setTargetRect:self.bounds inView:self];
            [controller setMenuVisible:YES animated:YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            self.backgroundColor = _bgColor;
            break;
        default:
            break;
    }
    
}

- (void)ableAllMemus {
    self.allowCopy = YES;
    self.allowPing = YES;
    self.allowTcping = YES;
    self.allowTracert = YES;
    self.allowDig = YES;
    self.allowReport = YES;
}

- (void)disAbleAllMemus {
    self.allowCopy = NO;
    self.allowPing = NO;
    self.allowTcping = NO;
    self.allowTracert = NO;
    self.allowDig = NO;
    self.allowReport = NO;
}


- (void)ping:(UIMenuController *)menu
{
    if (self.itemDidClick) {
        self.itemDidClick(@"ping", menu);
    }
}

- (void)tracert:(UIMenuController *)menu
{
    if (self.itemDidClick) {
        self.itemDidClick(@"tracert -d", menu);
    }
}

- (void)tcping:(UIMenuController *)menu
{
    if (self.itemDidClick) {
        self.itemDidClick(@"tcping", menu);
    }
}


- (void)dig:(UIMenuController *)menu
{
    if (self.itemDidClick) {
        self.itemDidClick(@"dig", menu);
    }
}

- (void)report:(UIMenuController *)menu {
    if (self.itemDidClick) {
        self.itemDidClick(@"report", menu);
    }
}

- (void)copyText:(UIMenuController *)menu
{
    // 将自己的文字复制到粘贴板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text;
    
//    if (self.itemDidClick) {
//        self.itemDidClick(@"copy", menu);
//    }
}
@end
