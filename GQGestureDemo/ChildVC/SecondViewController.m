//
//  SecondViewController.m
//  GQGestureDemo
//
//  Created by Lois_pan on 2018/5/9.
//  Copyright © 2018年 Lois_pan. All rights reserved.
//

#import "Masonry.h"
#import "SecondViewController.h"
#import "WDGestureTableView.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) WDGestureTableView  *tableView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)initData {
    self.canScroll = YES;
}

- (void)createView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.
        bottom.mas_equalTo(self.view);
    }];
}

//MARK: - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//MARK: - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(perVCScrollViewDidScroll:)]) {
        [self.delegate perVCScrollViewDidScroll:scrollView];
    }
}

//MARK: - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[WDGestureTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end

