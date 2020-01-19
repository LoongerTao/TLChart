//
//  OSDeviceLogHeadView.h
//  UIMenuControllerDemo
//
//  Created by 故乡的云 on 2020/1/19.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSDeviceLogHeadView : UIView
@property(nonatomic, weak) UIImageView *imgView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *timeLabel;
@property(nonatomic, weak) UILabel *detailLabel;
@property(nonatomic, weak) UIImageView *arrowImgView;
@end

NS_ASSUME_NONNULL_END
