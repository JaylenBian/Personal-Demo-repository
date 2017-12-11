//
//  MCLrcCell.h
//  LrcShare
//
//  Created by Minecode on 2017/12/1.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCLrcCell : UITableViewCell

@property (nonatomic, assign, getter=isLrcSelecting) BOOL lrcSelecting;
@property (nonatomic, assign, getter=isLrcSelected) BOOL lrcSelected;
@property (nonatomic, copy) NSString *lrc;

- (void)reset;

@end
