//
//  ViewController.m
//  GQGestureDemo
//
//  Created by Lois_pan on 2018/5/9.
//  Copyright © 2018年 Lois_pan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate, PerVCScrollViewDidScrollDelegate>

@property (nonatomic,strong) UIScrollView  *scrollView;
@property (nonatomic,strong) UIView  *scrollContentView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *selectTitleView;
@property (nonatomic,strong) UIPageViewController * pageViewVC;

@property (nonatomic,strong) NSMutableArray * childVCArray;
@property (nonatomic,assign) NSInteger currentChildVCIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-40, 0,80, 30)];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"首页";
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = title;

    self.navigationController.navigationBar.translucent = NO;
    UIViewController *initVC = self.childVCArray[0];
    self.currentChildVCIndex = 0;
    [self.pageViewVC setViewControllers:@[initVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)createView {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.bottom.mas_equalTo(self.view);
    }];

    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(kScreenHeight-64+200);
    }];

    [self.scrollContentView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollContentView);
        make.right.left.mas_equalTo(self.scrollContentView);
        make.height.mas_equalTo(200);
    }];

    [self.scrollContentView addSubview:self.selectTitleView];
    [self.selectTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollContentView);
        make.height.mas_equalTo(49);
    }];

    [self addChildViewController:self.pageViewVC];
    [self.scrollContentView addSubview:self.pageViewVC.view];
    [self.pageViewVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectTitleView.mas_bottom);
        make.right.left.mas_equalTo(self.scrollContentView);
        make.bottom.mas_equalTo(self.view);
    }];
    
//    //滚动视图  设置约束
//    [self.scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.top.equalTo(self.view.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
}

- (BOOL)getCanScroll {
    if (self.currentChildVCIndex==0) {
        FirstViewController *vc = self.childVCArray[self.currentChildVCIndex];
        return  vc.canScroll;
    } else if (self.currentChildVCIndex==1) {
        SecondViewController *vc = self.childVCArray[self.currentChildVCIndex];
        return vc.canScroll;
    }
    return NO;
}

- (void)setCanScroll:(BOOL)canScroll {
    if (self.currentChildVCIndex==0) {
        FirstViewController *vc = self.childVCArray[self.currentChildVCIndex];
        vc.canScroll = canScroll;
    } else if (self.currentChildVCIndex==1) {
        SecondViewController *vc = self.childVCArray[self.currentChildVCIndex];
        vc.canScroll = canScroll;
    }
}

//MARK: - pageViewControllerDelegate
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self.childVCArray indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }
    self.currentChildVCIndex = index-1;
    
    return self.childVCArray[index-1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self.childVCArray indexOfObject:viewController];
    if (index >= self.childVCArray.count -1) {
        
        return nil;
    }
    self.currentChildVCIndex = index+1;
    return self.childVCArray[index+1];
}

//MARK: - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL canScroll = [self getCanScroll];
    //如果自己不能滚动,那么就固定在固定位置
    if (!canScroll) {
        [scrollView setContentOffset:CGPointMake(0, 200)];
    }
}

//MARK: - PerVCScrollViewDidScrollDelegate
- (void)perVCScrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL canScroll = [self getCanScroll];
    //下拉的时候:scrollView.contentOffset.y<=0说明子视图的滚动已经到头了;父视图即将开始滚动
    
    NSLog(@"%lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<=0) {
        [self setCanScroll:YES];
        [scrollView setContentOffset:CGPointZero];
    }else{
        //      CGRect rec = [self.titleView convertRect:self.titleView.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect rec = [self.selectTitleView convertRect:self.selectTitleView.bounds toView:self.view];
        //父视图没有到头的时候;子视图将设置CGPointZero;和父视图一起滚动;
        if (canScroll && rec.origin.y > 0) {
            [scrollView setContentOffset:CGPointZero];
            [self setCanScroll:YES];
        }else{
            //父视图到头:那么设置父视图不再滚动
            [self setCanScroll:NO];
        }
    }
}

//MARK: - lazy
- (UIPageViewController *)pageViewVC {
    if (!_pageViewVC) {
        _pageViewVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewVC.dataSource = self;
        _pageViewVC.delegate = self;
    }
    return _pageViewVC;
}

- (NSMutableArray *)childVCArray {
    if (!_childVCArray) {
        _childVCArray = [NSMutableArray array];
        FirstViewController *firstVC = [FirstViewController new];
        firstVC.delegate = self;

        SecondViewController *secondVC = [SecondViewController new];
        secondVC.delegate = self;

        [_childVCArray addObject:firstVC];
        [_childVCArray addObject:secondVC];
    }
    return _childVCArray;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor yellowColor];
    }
    return _headView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
    }
    return _scrollContentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.tag = 666;
    }
    return _scrollView;
}

- (UIView *)selectTitleView {
    if (!_selectTitleView) {
        _selectTitleView = [[UIView alloc] init];
        _selectTitleView.backgroundColor = [UIColor blackColor];
    }
    return _selectTitleView;
}

@end






















