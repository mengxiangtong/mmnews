//
//  WSNavigationView.h
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSContainerController.h"

/*
    传出类定义block
 */

//定义block
typedef void (^ItemClickBlock)(NSInteger selectedIndex);


@interface WSNavigationView : UIScrollView

@property (assign, nonatomic) NSInteger selectedItemIndex;

@property (strong, nonatomic) NSArray<NSString *> *items;


//block 做函数参数

+ (instancetype)navigationViewWithItems:( NSArray <NSString *> * )items itemClick:(ItemClickBlock)itemClick;

@end
