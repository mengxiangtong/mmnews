//
//  WSNavigationView.m
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import "WSNavigationView.h"
#define kViewH 35
#define kItemW 70
#define kMargin 10

@interface WSNavigationView ()

@property (strong, nonatomic) NSMutableArray *btns;

@property (weak, nonatomic) UIButton *selectedItem;

@property (copy, nonatomic) ItemClickBlock   itemClickBlock;

@property (strong, nonatomic) WSContainerController *conVC;


@end

@implementation WSNavigationView



#pragma mark - event  按钮切换

- (void)itemClick:(UIButton *)sender {
    
    NSLog(@" 开始  》》  点击按钮 navigationview-------------------------------- 按钮切换 ");
    
    if ([sender isEqual:self.selectedItem])
        return;
    
    self.selectedItem.selected = NO;
    sender.selected = YES;
   
    //  调用
    if (self.itemClickBlock) {
        
        self.itemClickBlock(sender.tag);
        NSLog(@"3-  调用  传出 --==》 %lu ",  sender.tag);
    }

    
    
    //更改字体大小
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.titleLabel.font = [UIFont systemFontOfSize:17];
       // [sender setTitleColor:[UIColor blackColor] forState:0];
        
        self.selectedItem.titleLabel.font = [UIFont systemFontOfSize:13];
    }];
    
    //判断位置  滑块中心 相对 屏幕中心 的 偏移量
    CGFloat offsetX = sender.center.x - self.center.x;
    
    NSLog(@"  滑块中心 相对 屏幕中心 的偏移量 offsetX == %f",  offsetX);
   
    NSLog(@"  按钮宽  == %f",  sender.frame.size.width);
    NSLog(@"   self.center.x == %f",  self.center.x);
    NSLog(@"   sender.center.x == %f",  sender.center.x );

    CGFloat  noVisualW = self.contentSize.width - self.bounds.size.width;
    
    if (offsetX < 0){
        
        self.contentOffset = CGPointMake(0, 0);
        NSLog(@"<0  靠左 ");
        
    }else if (offsetX > noVisualW){
    
        NSLog(@"  noVisualW========== %f", noVisualW);
        // 移动 滚动视图
        self.contentOffset = CGPointMake(noVisualW, 0);
        NSLog(@" >   靠右");
        
    }else{
        
        self.contentOffset = CGPointMake(offsetX, 0);
        NSLog(@"  其他  不变  ");
    }

    self.selectedItem = sender;
    
    NSLog(@"==================================== ");
 
}



#pragma mark - setter
- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    
    NSLog(@" WSNavigationView   setSelectedItemIndex  setter 方法   传值 ");
    
    _selectedItemIndex = selectedItemIndex;
    
    UIButton *item = self.btns[selectedItemIndex];
    
    //按钮切换
    [self itemClick:item];
    
}





- (void)setContentOffset:(CGPoint)contentOffset{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [super setContentOffset:contentOffset];
    }];
}


#pragma mark - init

+ (instancetype)navigationViewWithItems:(NSArray<NSString *> *)items itemClick:(ItemClickBlock)itemClickBlock{
    
    WSNavigationView *nav = [[WSNavigationView alloc] init];
    
    nav.btns = [NSMutableArray arrayWithCapacity:items.count];
    
    //
    NSLog(@"  navigationViewWithItems 初始化 ----------- ");
    
    nav.itemClickBlock = itemClickBlock;
    
    nav.items = items;
    ////禁用滚动到最顶部的属性
    nav.scrollsToTop = NO;

        NSLog(@"-=====--------==---==== ");
    
    return nav;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i=0; i<self.btns.count; i++) {
        
        UIButton *item = self.btns[i];
        CGFloat itemX = kMargin + kItemW * i;
        item.frame = CGRectMake(itemX, 0, kItemW, kViewH);
    }
    
    self.contentSize = CGSizeMake(kItemW * self.btns.count + kMargin * 2, kViewH);
}




#pragma mark - 重写
- (void)setItems:(NSArray<NSString *> *)items{
    
    _items = items;
    
    //创建按钮
    for (NSInteger i=0; i<items.count; i++) {
        
        UIButton *item = [[UIButton alloc] init];
        
        [item setTitle:items[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:13];
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:item];
        [self addSubview:item];
        item.tag = i;
        
    }
}




- (void)setFrame:(CGRect)frame{
    
    frame.size.height = kViewH;
    [super setFrame:frame];
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}




@end
