//
//  WDGestureTableView.m
//  GQGestureDemo
//
//  Created by Lois_pan on 2018/5/9.
//  Copyright © 2018年 Lois_pan. All rights reserved.
//

#import "WDGestureTableView.h"

@implementation WDGestureTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
