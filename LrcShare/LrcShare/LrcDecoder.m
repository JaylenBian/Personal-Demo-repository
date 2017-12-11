//
//  LrcDecoder.m
//  LrcShare
//
//  Created by Minecode on 2017/11/30.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import "LrcDecoder.h"

@interface LrcDecoder ()



@end


@implementation LrcDecoder

- (instancetype)init {
    if (self = [super init]) {
        _timeArray = [[NSMutableArray alloc] init];
        _lrcArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)loadLrcWithFileName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"lrc"];
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)decodeLrcWithString:(NSString *)lrcStr {
    if (!lrcStr) return;
    
    NSArray *sepArray = [lrcStr componentsSeparatedByString:@"["];
    NSArray *lineArray = [[NSArray alloc] init];
    for (NSInteger i = 0; i < [sepArray count]; ++i) {
        if([sepArray[i] length]>0){
            lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
            if(![lineArray[0] isEqualToString:@"\n"]){
                [self.timeArray addObject:lineArray[0]];
                [self.lrcArray addObject:lineArray.count>1?lineArray[1]:@""];
            }
        }
    }
}

@end
