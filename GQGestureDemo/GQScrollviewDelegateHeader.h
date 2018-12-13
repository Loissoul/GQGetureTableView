//
//  GQScrollviewDelegateHeade.h
//  GQGestureDemo
//
//  Created by Lois_pan on 2018/5/9.
//  Copyright © 2018年 Lois_pan. All rights reserved.
//

#ifndef GQScrollviewDelegateHeader_h
#define GQScrollviewDelegateHeader_h
@protocol PerVCScrollViewDidScrollDelegate<NSObject>
@optional
- (void)perVCScrollViewDidScroll:(UIScrollView *)scrollView;
@end


#endif /* GQScrollviewDelegateHeade_h */
