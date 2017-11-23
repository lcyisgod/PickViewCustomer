//
//  DatePickView.h
//  PickViewTest
//
//  Created by 梁成友 on 16/4/26.
//  Copyright © 2016年 梁成友. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnDate <NSObject>

@optional
-(void)returnDateCompleteWithDate:(NSString *)date;

@end
@interface DatePickView : UIView

@property (nonatomic, weak)id<returnDate>delegate;
//设置返回日期格式
-(void)useRetuDateType:(int)type;

//设置从今年开始向前显示多少年(0:不包含本年 1:包含本年)
-(void)setYearBeforNow:(int)num andType:(int)type;

//设置从今年开始向后显示多少年(0:不包含本年 1:包含本年)
-(void)setYearAfterNow:(int)num andType:(int)type;

//设置以今年为起点前后显示多少年
-(void)setYearBtwNow:(int)num;

//设置年份的最小最大
-(void)setYeraFrom:(int)BYear and:(int)EYear;

//设置默认显示的时间
-(void)setApperDate:(NSString *)dateStr;


@end
