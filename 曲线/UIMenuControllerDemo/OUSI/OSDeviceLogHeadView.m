//
//  OSDeviceLogHeadView.m
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2020/1/19.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "OSDeviceLogHeadView.h"
#import "TLChartsConfigure.h"

@implementation OSDeviceLogHeadView {
    CALayer *_bottomLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _bottomLine = [[CALayer alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xF5F5F8).CGColor;
        [self.layer addSublayer:_bottomLine];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        _imgView = imgView;
        [self addSubview:imgView];
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = [UIImage systemImageNamed:@"link"];
        _arrowImgView = arrowView;
        [self addSubview:arrowView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
        UILabel *detialLabel = [[UILabel alloc] init];
        detialLabel.font = [UIFont systemFontOfSize:12];
        detialLabel.textColor = UIColorFromRGB(0xFFA422);
        _detailLabel = detialLabel;
        [self addSubview:detialLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgView.frame = CGRectMake(12, 19, 13, 13);
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(200, 22)];
    self.titleLabel.frame = CGRectMake(35, 14, size.width, 22);
    size = [self.timeLabel sizeThatFits:CGSizeMake(200, 17)];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 19, size.width, 17);
    
    CGFloat W = CGRectGetWidth(self.bounds);
    self.arrowImgView.frame = CGRectMake(W - 12 - 30, 11, 30, 30);
    size = [self.detailLabel sizeThatFits:CGSizeMake(200, 17)];
    self.detailLabel.frame = CGRectMake(W - size.width - 12 - 30 , 16, size.width, 20);
    
    _bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, W, 1);
}
@end
