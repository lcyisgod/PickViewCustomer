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
/*
 0:年-月-日-时-分-秒
 1:年-月-日-时-分
 2:年-月-日-时
 3:年-月-日
 4:年-月
 5:时-分-秒
 6:时-分
 7:分-秒
 8:月-日-时-分
 */
-(instancetype)initWithFrame:(CGRect)frame timeType:(NSInteger)timerType;
/*
 0 xx:xx
 1 xx-xx
 */
//设置返回日期格式
-(void)useRetuDateType:(int)type;

/*
指定月份的选择内容
*/
-(void)upDataMonthArray:(NSArray *)monthArray;
/*
指定天的选择内容
*/
-(void)upDataDayArray:(NSArray *)dayArray;
/*
指定时的选择内容
*/
-(void)upDataHourArray:(NSArray *)hourArray;
/*
 指定分钟的选择内容
 */
-(void)upDataMinuteArray:(NSArray *)minuteArray;
/*
 指定秒的选择内容
 */
-(void)upDataSecondArray:(NSArray *)secondArray;

//设置默认显示的时间
/*默认显示时间格式必须为以下类型的其中一种
 yyyy-MM-dd HH-mm-ss
 yyyy:MM:dd HH:mm:ss
 yyyy MM dd HH mm-ss
 */
/*
 eg:
 需要展示的时间为时-分-秒格式
 xxxx-xx-xx 01-01-00
 */
-(void)setApperDate:(NSString *)dateStr;

/*
 以下设置只在有年份选择的类别下才生效
 */
//设置从今年开始向前显示多少年(0:不包含本年 1:包含本年)
-(void)setYearBeforNow:(int)num andType:(int)type;

//设置从今年开始向后显示多少年(0:不包含本年 1:包含本年)
-(void)setYearAfterNow:(int)num andType:(int)type;

//设置以今年为起点前后显示多少年
-(void)setYearBtwNow:(int)num;

//设置年份的最小最大
-(void)setYeraFrom:(int)BYear and:(int)EYear;


@end
