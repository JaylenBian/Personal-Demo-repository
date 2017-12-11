//
//  ViewController.m
//  LrcShare
//
//  Created by Minecode on 2017/11/30.
//  Copyright © 2017年 Minecode. All rights reserved.
//

#import "ViewController.h"

#import "LrcDecoder.h"
#import "MCLrcCell.h"
#import "MCShareVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

// UI控件
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *createButton;

// 属性
@property (nonatomic, strong) LrcDecoder *decoder;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL cellSelecting;

// 存储cell的选择状态
@property (nonatomic, copy) NSMutableDictionary *cellDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fileName = @"song";
    [self setupTableView];
    [self setupButton];
    [self loadLrc];
}

- (void)loadLrc {
    NSString *filePath = [self.decoder loadLrcWithFileName: self.fileName];
    [self.decoder decodeLrcWithString:filePath];
    [self.tableView reloadData];
}

#pragma mark - 代理方法实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.decoder.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MCLrcCell" owner:nil options:nil] firstObject];
    }
    
    [cell reset];
    cell.lrc = self.decoder.lrcArray[indexPath.row];
    cell.lrcSelecting = self.cellSelecting;
    // 判断cell是否正在选择
    NSNumber *val = [self.cellDict objectForKey:[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
    if (val && val.boolValue) {
        cell.lrcSelected = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 如果没有在选择状态，则退出
    if (!self.cellSelecting) return;
    
    MCLrcCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.lrcSelected = !cell.isLrcSelected;
    [self.cellDict setObject:[NSNumber numberWithBool:cell.lrcSelected] forKey:[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
}

#pragma mark - 私有API
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor blackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cellSelecting = NO;
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongPressAction:)];
    longPressGes.minimumPressDuration = 1.0;
    [tableView addGestureRecognizer:longPressGes];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupButton {
    [self.createButton setEnabled:NO];
    [self.createButton setTintColor:[UIColor clearColor]];
    [self.createButton setTarget:self];
    [self.createButton setAction:@selector(createShareImage)];
}

- (void)createShareImage {
    if (!self.cellSelecting) return;
    
    // 生成歌词数组
    NSMutableArray *lrcArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.decoder.lrcArray.count; ++i) {
        // 生成Key，通过Key访问字典
        NSString *key = [NSString stringWithFormat:@"0-%ld", i];
        NSNumber *val = [self.cellDict objectForKey:key];
        if (val && val.boolValue) {
            [lrcArr addObject:self.decoder.lrcArray[i]];
        }
    }
    
    // 如果没有选择歌词，则提示
    if (lrcArr.count <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请至少选择一句歌词！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // 显示歌词分享界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MCShareVC *vc = [sb instantiateViewControllerWithIdentifier:@"LrcShareVC"];
    vc.lrcArr = [lrcArr copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewLongPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    // 切换选择模式
    self.cellSelecting = !self.cellSelecting;
    if (self.cellSelecting) {
        // 清空映射字典
        [self.cellDict removeAllObjects];
        // 显示按钮
        [self.createButton setEnabled:YES];
        [self.createButton setTintColor:[UIColor redColor]];
    }
    else {
        // 隐藏按钮
        [self.createButton setEnabled:NO];
        [self.createButton setTintColor:[UIColor clearColor]];
    }
    // 更新tableView
    [self.tableView reloadData];
}

#pragma mark - getter/setter实现
- (LrcDecoder *)decoder {
    if (!_decoder) {
        _decoder = [[LrcDecoder alloc] init];
    }
    return _decoder;
}

- (NSMutableDictionary *)cellDict {
    if (!_cellDict) {
        _cellDict = [[NSMutableDictionary alloc] init];
    }
    return _cellDict;
}

@end
