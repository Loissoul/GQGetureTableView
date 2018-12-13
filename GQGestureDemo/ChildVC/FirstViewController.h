//
//  FirstViewController.h
//  GQGestureDemo
//
//  Created by Lois_pan on 2018/5/9.
//  Copyright © 2018年 Lois_pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQScrollviewDelegateHeader.h"

@interface FirstViewController : UIViewController

@property (nonatomic, weak) id <PerVCScrollViewDidScrollDelegate>delegate;

@property (nonatomic, assign) BOOL canScroll;

@end
