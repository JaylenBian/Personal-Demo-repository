//
//  MCShareVC.m
//  LrcShare
//
//  Created by Minecode on 2017/12/1.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import "MCShareVC.h"

#define kImageDefaultHeight 150
#define kItemHeight 20
#define kItemMargin 5.0
#define kLrcRightMargin 20

#define LRC_START_X 40
#define LRC_START_Y 50

@interface MCShareVC () <UIScrollViewDelegate>

// UI控件
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) UIImageView *bkgImage;

@end

@implementation MCShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupButton];
    [self drawLrcBackground];
    [self addLrcToBackground];
}


#pragma mark - 初始化私有方法
- (void)setupView {
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.bkgImage = [[UIImageView alloc] init];
    self.bkgImage.contentMode = UIViewContentModeScaleToFill;
}

- (void)setupButton {
    [self.shareButton addTarget:self action:@selector(shareImageHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveImageHandler) forControlEvents:UIControlEventTouchUpInside];
}

- (void)drawLrcBackground {
    CGFloat imageWidth = self.view.frame.size.width;
    CGFloat imageHeight = self.lrcArr.count * (kItemHeight + kItemMargin);
    
    self.bkgImage.frame = CGRectMake(0, 0, imageWidth, kImageDefaultHeight + imageHeight);
    [self.scrollView addSubview:self.bkgImage];
    
    // 获取图片
    UIImage *sourceImage = [UIImage imageNamed:@"shareBkg.png"];
    self.bkgImage.image = sourceImage;
    // 设置图片拉伸参数
    CGFloat topInset = sourceImage.size.height * 0.4;
    CGFloat leftInset = sourceImage.size.width * 0.7;
    CGFloat bottomInset = sourceImage.size.height - topInset - 1;
    CGFloat rightInset = sourceImage.size.width - leftInset - 1;
    
    UIEdgeInsets bkgEdgeInsets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
    // 拉伸图片
    UIImage *resizedImage = [sourceImage resizableImageWithCapInsets:bkgEdgeInsets resizingMode:UIImageResizingModeStretch];
    // 设置图片和ScrollView
    self.bkgImage.image = resizedImage;
    self.scrollView.contentSize = CGSizeMake(self.bkgImage.frame.size.width, self.bkgImage.frame.size.height);
}

- (void)addLrcToBackground {
    CGFloat xCursor = LRC_START_X;
    CGFloat yCursor = LRC_START_Y;
    
    // 按顺序添加歌词
    for (NSInteger i = 0; i < self.lrcArr.count; ++i) {
        // 获取当前歌词
        NSString *curLrc = [self.lrcArr objectAtIndex:i];
        // 创建歌词对应的Label
        UILabel *lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCursor, yCursor, self.view.frame.size.width - 2*LRC_START_X, kItemHeight)];
        lrcLabel.text = curLrc;
        lrcLabel.textColor = [UIColor darkGrayColor];
        lrcLabel.font = [UIFont systemFontOfSize:15];
        [self.bkgImage addSubview:lrcLabel];
        // 改变位置指针
        yCursor += kItemHeight + kItemMargin;
    }
    
    // 添加底部歌名
    NSString *rightText = @"--[歌手-歌名]";
    yCursor += kLrcRightMargin;
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCursor, yCursor, self.view.frame.size.width - 2*LRC_START_X, kItemHeight)];
    rightLabel.text = rightText;
    rightLabel.textColor = [UIColor darkGrayColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = [UIFont systemFontOfSize:15];
    [self.bkgImage addSubview:rightLabel];
}

#pragma mark - 分享和保存
- (void)saveImageHandler {
    // 生成View的图片
    UIGraphicsBeginImageContextWithOptions(self.bkgImage.bounds.size, YES, 0);
    [self.bkgImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bitmap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(bitmap, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

// 使用系统分享分享图片
- (void)shareImageHandler {
    // 生成View的图片
    UIGraphicsBeginImageContextWithOptions(self.bkgImage.bounds.size, YES, 0);
    [self.bkgImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bitmap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:@[bitmap] applicationActivities:nil];
    [self presentViewController:activityVc animated:YES completion:nil];
}

// 保存后回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo:(id)contextInfo {
    
    if (!error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
