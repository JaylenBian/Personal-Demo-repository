//
//  LrcDecoder.h
//  LrcShare
//
//  Created by Minecode on 2017/11/30.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcDecoder : NSObject

// 歌词数组
@property (nonatomic, copy) NSMutableArray *lrcArray;
// 歌曲时间数组
@property (nonatomic, copy) NSMutableArray *timeArray;

// 加载歌词文件
- (NSString *)loadLrcWithFileName:(NSString *)fileName;
// 读取歌词
- (void)decodeLrcWithString:(NSString *)lrcStr;

@end
