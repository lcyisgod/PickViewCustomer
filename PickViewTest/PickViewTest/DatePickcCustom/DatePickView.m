//
//  DatePickView.m
//  PickViewTest
//
//  Created by 梁成友 on 16/4/26.
//  Copyright © 2016年 梁成友. All rights reserved.
//

#import "DatePickView.h"
#import "DatePickOper.h"

@interface DatePickView ()<UIPickerViewDelegate,UIPickerViewDataSource,btnProto>

@property (nonatomic , strong)UIPickerView *testPickView;

@property (nonatomic , strong)DatePickOper *operView;

@property (nonatomic , strong)NSMutableArray *yearAry;           //年份

@property (nonatomic , strong)NSArray *monthaAry;                //月份

@property (nonatomic , strong)NSArray *dayAry;                   //日期

@property (nonatomic , assign)BOOL isRun;                        //是否是闰年

@property (nonatomic , assign)int year;                          //年

@property (nonatomic , assign)int month;                         //月

@property (nonatomic , assign)int day;                           //日

@property (nonatomic , assign)int day1;

@property (nonatomic , assign)int type;                          //初始时间显示

@property (nonatomic , assign)int iType;                         //0  HHHH:mm:dd   1 HHHH-mm-dd  2 HHHH-mm-dd 00-00-00    3    HHHH:mm:dd 00:00:00
@end
@implementation DatePickView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = 1;
        self.backgroundColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:66/100.0];
        self.year = [[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:4] intValue];
        self.month = [[[NSString stringWithFormat:@"%@",[NSDate date]] substringWithRange:NSMakeRange(5, 2)] intValue];
        self.day = [[[NSString stringWithFormat:@"%@",[NSDate date]] substringFromIndex:8] intValue];
        self.yearAry = [NSMutableArray array];
        for (int i = 0; i <= 200; i++) {
            if (i < 100) {
                [self.yearAry addObject:[NSString stringWithFormat:@"%d",self.year - 50 + i]];
            }else{
                [self.yearAry addObject:[NSString stringWithFormat:@"%d",self.year + i - 50]];
            }
        }
         self.monthaAry = [[NSArray alloc] initWithObjects:@"01" , @"02" , @"03" , @"04" , @"05" , @"06" , @"07" , @"08" , @"09" , @"10" , @"11" , @"12", nil];
        self.dayAry = [[NSArray alloc] init];
        self.dayAry = [self returnDayArrayWithNumCount:31];
        [self addSubview:self.operView];
        [self addSubview:self.testPickView];
        [self setFrisDate];
        UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePick:)];
        [self addGestureRecognizer:tapRecog];
    }
    return self;
}

-(void)layoutSubviews
{
    CGFloat x , y , wCell , hCell;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    //
    wCell = w;
    hCell = 80;
    x = 0;
    y = h - hCell-216;
    self.operView.frame = CGRectMake(x, y, wCell, hCell);
    
    //
    x = 0;
    y = y + hCell;
    hCell = 216;
    self.testPickView.frame = CGRectMake(x, y, wCell, hCell);
}

-(DatePickOper *)operView
{
    if (!_operView) {
        self.operView = [[DatePickOper alloc] initWithFrame:CGRectZero];
        self.operView.delegate = self;
    }
    return _operView;
}

-(UIPickerView *)testPickView
{
    if (!_testPickView) {
        self.testPickView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.testPickView.backgroundColor = [UIColor whiteColor];
        self.testPickView.showsSelectionIndicator = YES;
        self.testPickView.delegate = self;
        self.testPickView.dataSource = self;
    }
    return _testPickView;
}

#pragma mark -PickView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.yearAry.count != 0) {
        if (component == 0) {
            return self.yearAry.count;
        }else if (component == 1){
            return self.monthaAry.count;
        }else
            return self.dayAry.count;
    }else
        return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.yearAry.count != 0) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else if (component == 1){
            return [self.monthaAry objectAtIndex:row];
        }else{
            self.day1 = [[self.dayAry objectAtIndex:row] intValue];
            return [self.dayAry objectAtIndex:row];
        }
    }else
        return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.yearAry.count != 0) {
        if (component == 0) {
            NSString *slectYear = [self.yearAry objectAtIndex:row];
            self.year = [slectYear intValue];
            self.isRun = [self isRunWithYear:self.year];
            [self updataDayAryWithMouth];
            [self.testPickView reloadAllComponents];
        }
        
        if (component == 1) {
            NSString *slectMonth = [self.monthaAry objectAtIndex:row];
            self.month = [slectMonth intValue];
            [self updataDayAryWithMouth];
            [self.testPickView reloadAllComponents];
            
        }
        
        if (component == 2) {
            NSString *slectDay = [self.dayAry objectAtIndex:row];
            self.day = [slectDay intValue];
        }
    }
}

#pragma mark -
-(void)setYearBeforNow:(int)num andType:(int)type
{
    [self.yearAry removeAllObjects];
    NSString *str = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:4];
    int min = 0;
    self.type = type;
    if (type == 0) {
        min = 1;
    }
    for (int i = num; i >= min; i--) {
        NSString *year = [NSString stringWithFormat:@"%d",[str intValue] - i];
        [self.yearAry addObject:year];
    }
    if(type == 0){
        self.year = [[self.yearAry objectAtIndex:0] intValue];
        self.month = 1;
        self.day = 1;
    }
    [self.testPickView reloadAllComponents];
    [self setFrisDate];
}

-(void)setYearAfterNow:(int)num andType:(int)type
{
    [self.yearAry removeAllObjects];
    NSString *str = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:4];
    int min = 0;
    self.type = type;
    if (type == 0) {
        min = 1;
    }
    for (int i = min; i <= num; i--) {
        NSString *year = [NSString stringWithFormat:@"%d",[str intValue] + i];
        [self.yearAry addObject:year];
    }
    if (type == 0) {
        self.year = [[self.yearAry objectAtIndex:0] intValue];
        self.month = 1;
        self.day = 1;
    }
    [self.testPickView reloadAllComponents];
    [self setFrisDate];
}


-(void)setYearBtwNow:(int)num
{
    [self.yearAry removeAllObjects];
    NSString *str = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:4];
    for (int i = num; i>0; i--) {
        NSString *year = [NSString stringWithFormat:@"%d",[str intValue] - i];
        [self.yearAry addObject:year];
    }
    for (int i = 0; i <= num ; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",[str intValue] + i];
        [self.yearAry addObject:year];
    }
    [self.testPickView reloadAllComponents];
    [self setFrisDate];
}

-(void)setYeraFrom:(int)BYear and:(int)EYear
{
    [self.yearAry removeAllObjects];
    self.year = BYear;
    self.month = 1;
    self.day = 1;
    for (int i = BYear; i <= EYear; i++) {
        [self.yearAry addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.testPickView reloadAllComponents];
    [self setFrisDate];
}

-(void)setApperDate:(NSString *)dateStr
{
    if ([dateStr rangeOfString:@"-"].length != 0 || [dateStr rangeOfString:@" "].length !=0|| [dateStr rangeOfString:@":"].length != 0) {
        if (dateStr.length < 10) {
            NSLog(@"无效的初始时间");
            [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
            return;
        }
        self.year = [[dateStr substringToIndex:4] intValue];
        self.month = [[dateStr substringWithRange:NSMakeRange(5, 2)] intValue];
        self.day = [[dateStr substringFromIndex:8] intValue];
    }else{
        if (dateStr.length != 0) {
            if (dateStr.length < 8) {
                NSLog(@"无效的初始时间");
                [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
            }
            self.year = [[dateStr substringToIndex:4] intValue];
            self.month = [[dateStr substringWithRange:NSMakeRange(4, 2)] intValue];
            self.day = [[dateStr substringFromIndex:6] intValue];
        }
    }
    if (self.yearAry.count > 0) {
        int num = (int)self.yearAry.count;
        if ([[self.yearAry objectAtIndex:0] intValue]> self.year || [[self.yearAry objectAtIndex:(num - 1)] intValue] < self.year) {
            NSLog(@"无效的初始时间");
           [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
            return;
        }
    }else{
        NSLog(@"无效的初始时间");
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        return;
    }
    self.isRun = [self isRunWithYear:self.year];
    [self updataDayAryWithMouth];
    [self setFrisDate];
}


-(NSArray *)returnDayArrayWithNumCount:(int)num
{
    NSMutableArray *testAry = [[NSMutableArray alloc] init];
    for (int i = 0; i < num; i++ ) {
        if (i < 9) {
            [testAry addObject:[NSString stringWithFormat:@"0%d", i+ 1]];
        }else{
            [testAry addObject:[NSString stringWithFormat:@"%d", i+ 1]];
        }
    }
    return testAry;
}

-(void)updataDayAryWithMouth
{
    if (self.month == 1 || self.month == 3 || self.month == 5 || self.month == 7 || self.month == 8 || self.month == 10 || self.month == 12) {
        self.dayAry = [self returnDayArrayWithNumCount:31];
    }else if (self.month == 2){
        if (self.isRun) {
            self.dayAry = [self returnDayArrayWithNumCount:29];
        }else
            self.dayAry = [self returnDayArrayWithNumCount:28];
    }else
        self.dayAry = [self returnDayArrayWithNumCount:30];
}

-(void)setFrisDate
{
    int year = self.year - [[self.yearAry objectAtIndex:0] intValue];
    int month = self.month - [[self.monthaAry objectAtIndex:0] intValue];
    int day = self.day - [[self.dayAry objectAtIndex:0] intValue];
    if (year >= self.yearAry.count || month >= self.monthaAry.count || day >= self.dayAry.count) {
        NSLog(@"无效的初始时间");
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        return;
    }
    [self.testPickView reloadAllComponents];
    [self.testPickView selectRow:year inComponent:0 animated:YES];
    [self.testPickView selectRow:month inComponent:1 animated:YES];
    [self.testPickView selectRow:day inComponent:2 animated:YES];
    self.isRun = [self isRunWithYear:self.year];
}

//判断是否是闰年
-(BOOL)isRunWithYear:(int)year
{
    BOOL bOk = NO;
    if (year%400==0) {
        bOk = YES;
    }else if (year%4==0&&year%100!=0){
        bOk = YES;
    }
    return bOk;
}

-(void)useRetuDateType:(int)type
{
    self.iType = type;
}

-(void)removePick:(UITapGestureRecognizer *)sender
{
    [self removeFromSuperview];
}

#pragma mark-
-(void)cacleBtn
{
    [self removeFromSuperview];
}

-(void)clickBtn
{
    if ([self.delegate respondsToSelector:@selector(returnDateCompleteWithDate:)]) {
        NSString *sText = [NSString stringWithFormat:@"%d",self.year];
        NSString *mouth = [NSString stringWithFormat:@"%d",self.month];
        if (self.month < 10) {
            mouth = [NSString stringWithFormat:@"0%d",self.month];
        }
        NSString *day = [NSString stringWithFormat:@"%d",self.day1];
        if (self.day1<10) {
            day = [NSString stringWithFormat:@"0%d",self.day1];
        }
        
        switch (self.iType) {
            case 0:{
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",mouth]];
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",day]];
                break;
            }
            case 1:{
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@"-%@",mouth]];
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@"-%@",day]];
                break;
            }
            case 2:{
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@"-%@",mouth]];
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@"-%@",day]];
                sText = [sText stringByAppendingString:@" 00-00-00"];

                break;
            }
            case 3:{
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",mouth]];
                sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",day]];
                sText = [sText stringByAppendingString:@" 00:00:00"];
                break;
            }
                
            default:
                break;
        }
        [self removeFromSuperview];
        [self.delegate returnDateCompleteWithDate:sText];
    }
}
@end
