//
//  MCLrcCell.m
//  LrcShare
//
//  Created by Minecode on 2017/12/1.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import "MCLrcCell.h"

#define IMG_CONSTRAIN_SELE 8
#define IMG_CONSTRAIN_NONSELE -28
#define ANIMATE_DURATION 1.0

@interface MCLrcCell ()

@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstrains;

@end


@implementation MCLrcCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self reset];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reset {
    // 重置selecting选项
    _lrcSelecting = NO;
    [self didChangeLrcSelectingWithAnimation:NO];
    // 重置selected选项
    _lrcSelected = NO;
    [self didChangeLrcSelected];
}

#pragma mark - 私有方法
- (void)didChangeLrcSelectingWithAnimation:(BOOL)animate {
    // 设置约束
    if (self.isLrcSelecting) {
        self.imageConstrains.constant = IMG_CONSTRAIN_SELE;
    }
    else {
        self.imageConstrains.constant = IMG_CONSTRAIN_NONSELE;
    }
    
    // 判断是否执行动画
//    if (animate) {
//        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
//            [self layoutIfNeeded];
//        }];
//    }
//    else {
//        [self layoutIfNeeded];
//    }
    [self layoutIfNeeded];
}

- (void)didChangeLrcSelected {
    // 设置选中图片
    NSString *imageName = self.isLrcSelected ? @"img_selected" : @"img_nonselected";
    self.selectedImage.image = [UIImage imageNamed:imageName];
}

#pragma mark - getter/setter
- (void)setLrcSelecting:(BOOL)lrcSelecting {
    _lrcSelecting = lrcSelecting;
    [self didChangeLrcSelectingWithAnimation:YES];
}

- (void)setLrcSelected:(BOOL)lrcSelected {
    _lrcSelected = lrcSelected;
    [self didChangeLrcSelected];
}

- (void)setLrc:(NSString *)lrc {
    _lrc = lrc;
    self.lrcLabel.text = lrc;
}

@end
