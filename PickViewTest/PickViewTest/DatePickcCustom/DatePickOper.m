//
//  DatePickOper.m
//  PickViewTest
//
//  Created by 梁成友 on 16/6/2.
//  Copyright © 2016年 梁成友. All rights reserved.
//

#import "DatePickOper.h"

@interface DatePickOper ()

@property (nonatomic, strong)UIButton *cacelBtn;

@property (nonatomic, strong)UIButton *clickBtn;

@property (nonatomic, strong)UIView *lineBottom;
@end
@implementation DatePickOper

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cacelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cacelBtn setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.cacelBtn addTarget:self action:@selector(cancleMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cacelBtn];
        
        self.clickBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.clickBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.clickBtn setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.clickBtn addTarget:self action:@selector(clickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clickBtn];
        
        self.lineBottom = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineBottom.backgroundColor = [UIColor colorWithRed:36/255.0 green:131/255.0 blue:203/255.0 alpha:1.0];
        [self addSubview:self.lineBottom];
    }
    return self;
}

-(void)layoutSubviews
{
    CGFloat x , y , wCell , hCell;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    //
    x = 0;
    y = 0;
    hCell = h;
    wCell = 100;
    self.cacelBtn.frame = CGRectMake(x, y, wCell, hCell);
    
    //
    x = w - wCell;
    self.clickBtn.frame = CGRectMake(x, y, wCell, hCell);
    
    //
    wCell = w;
    hCell = 1;
    x = 0;
    y = h - hCell;
    self.lineBottom.frame = CGRectMake(x, y, wCell, hCell);
}

-(void)cancleMethod:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cacleBtn)]) {
        [self.delegate cacleBtn];
    }
}

-(void)clickMethod:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickBtn)]) {
        [self.delegate clickBtn];
    }
}

@end
