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

@property (nonatomic , strong)NSArray *hourAry;                  //时

@property (nonatomic , strong)NSArray *minuteAry;                //分

@property (nonatomic , strong)NSArray *secondAry;                //秒

@property (nonatomic , assign)BOOL isRun;                        //是否是闰年

@property (nonatomic , assign)int year;                          //年

@property (nonatomic , assign)int month;                         //月

@property (nonatomic , assign)int day;                           //日
//为了防止在切换月份时导致日期自动变化时日期取值错误的问题
@property (nonatomic , assign)int day1;

@property (nonatomic , assign)int hour;                          //时

@property (nonatomic , assign)int minute;                        //分

@property (nonatomic , assign)int second;                        //秒

@property (nonatomic , assign)int type;                          //初始时间显示

@property (nonatomic , assign)int iType;                         //0 : 1 -

@property (nonatomic, assign)NSInteger numComponces;

@property (nonatomic, assign)NSInteger pickViewType;
@end
@implementation DatePickView

-(instancetype)initWithFrame:(CGRect)frame timeType:(NSInteger)timerType {
    _pickViewType = timerType;
    return [self initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = 1;
        self.backgroundColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:66/100.0];
        [self setOtherDate];
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
        self.hourAry = @[@"00",@"01" , @"02" , @"03" , @"04" , @"05" , @"06" , @"07" , @"08" , @"09" , @"10" , @"11" , @"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        self.minuteAry = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        self.secondAry = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
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
    NSInteger numberComponents = 0;
    if (_pickViewType == 0) {
        numberComponents = 6;
    }else if (_pickViewType == 1) {
        numberComponents = 5;
    }else if (_pickViewType == 2) {
        numberComponents = 4;
    }else if (_pickViewType == 3 || _pickViewType == 5){
        numberComponents = 3;
    }else if (_pickViewType == 4 || _pickViewType == 6 || _pickViewType == 7) {
        numberComponents = 2;
    }
    _numComponces = numberComponents;
    return numberComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_pickViewType == 0){
       if (component == 0) {
           return self.yearAry.count;
       }else if (component == 1){
           return self.monthaAry.count;
       }else if (component == 2) {
           return self.dayAry.count;
       }else if (component == 3) {
           return self.hourAry.count;
       }else if (component == 4) {
           return self.minuteAry.count;
       }else {
           return self.secondAry.count;
       }
    }else if (_pickViewType == 1) {
        if (component == 0) {
            return self.yearAry.count;
        }else if (component == 1){
            return self.monthaAry.count;
        }else if (component == 2) {
            return self.dayAry.count;
        }else if (component == 3) {
            return self.hourAry.count;
        }else {
            return self.minuteAry.count;
        }
    }else if (_pickViewType == 2) {
        if (component == 0) {
            return self.yearAry.count;
        }else if (component == 1){
            return self.monthaAry.count;
        }else if (component == 2) {
            return self.dayAry.count;
        }else {
            return self.hourAry.count;
        }
    }else if (_pickViewType == 3) {
        if (component == 0) {
            return self.yearAry.count;
        }else if (component == 1){
            return self.monthaAry.count;
        }else
            return self.dayAry.count;
    }else if (_pickViewType == 4) {
        if (component == 0) {
            return self.yearAry.count;
        }else {
            return self.monthaAry.count;
        }
    }else if (_pickViewType == 5) {
        if (component == 0) {
            return self.hourAry.count;
        }else if (component == 1){
            return self.minuteAry.count;
        }else {
            return self.secondAry.count;
        }
    }else if (_pickViewType == 6) {
        if (component == 0) {
            return self.hourAry.count;
        }else {
            return self.minuteAry.count;
        }
    }else if (_pickViewType == 7) {
        if (component == 0) {
            return self.minuteAry.count;
        }else {
            return self.secondAry.count;
        }
    }
    else
        return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickViewType == 0) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else if (component == 1){
            return [self.monthaAry objectAtIndex:row];
        }else if (component == 2){
            self.day1 = [[self.dayAry objectAtIndex:row] intValue];
            return [self.dayAry objectAtIndex:row];
        }else if (component == 3){
            return [self.hourAry objectAtIndex:row];
        }else if (component == 4){
            return [self.minuteAry objectAtIndex:row];
        }else {
            return [self.secondAry objectAtIndex:row];
        }
    }else if (_pickViewType == 1) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else if (component == 1){
            return [self.monthaAry objectAtIndex:row];
        }else if (component == 2){
            self.day1 = [[self.dayAry objectAtIndex:row] intValue];
            return [self.dayAry objectAtIndex:row];
        }else if (component == 3){
            return [self.hourAry objectAtIndex:row];
        }else {
            return [self.minuteAry objectAtIndex:row];
        }
    }else if (_pickViewType == 2) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else if (component == 1){
            return [self.monthaAry objectAtIndex:row];
        }else if (component == 2){
            self.day1 = [[self.dayAry objectAtIndex:row] intValue];
            return [self.dayAry objectAtIndex:row];
        }else {
            return [self.hourAry objectAtIndex:row];
        }
    }else if (_pickViewType == 3) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else if (component == 1){
            return [self.monthaAry objectAtIndex:row];
        }else{
            self.day1 = [[self.dayAry objectAtIndex:row] intValue];
            return [self.dayAry objectAtIndex:row];
        }
    }else if (_pickViewType == 4) {
        if (component == 0) {
            return [self.yearAry objectAtIndex:row];
        }else {
            return [self.monthaAry objectAtIndex:row];
        }
    }else if (_pickViewType == 5) {
        if (component == 0) {
            return [self.hourAry objectAtIndex:row];
        }else if (component == 1){
            return [self.minuteAry objectAtIndex:row];
        }else{
            return [self.secondAry objectAtIndex:row];
        }
    }else if (_pickViewType == 6) {
        if (component == 0) {
            return [self.hourAry objectAtIndex:row];
        }else {
            return [self.minuteAry objectAtIndex:row];
        }
    }else if (_pickViewType == 7) {
        if (component == 0) {
            return [self.minuteAry objectAtIndex:row];
        }else {
            return [self.secondAry objectAtIndex:row];
        }
    }else {
        return @"";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickViewType == 0) {
        if (component == 0) {
            NSString *selectYear = [self.yearAry objectAtIndex:row];
            self.year = [selectYear intValue];
            self.isRun = [self isRunWithYear:self.year];
            [self updataDayAryWithMouth];
            [self.testPickView reloadAllComponents];
        }
        
        if (component == 1) {
            NSString *selectMonth = [self.monthaAry objectAtIndex:row];
            self.month = [selectMonth intValue];
            [self updataDayAryWithMouth];
            [self.testPickView reloadAllComponents];
            
        }
        
        if (component == 2) {
            NSString *selectDay = [self.dayAry objectAtIndex:row];
            self.day = [selectDay intValue];
        }
        
        if (component == 3) {
            NSString *selectHour = [self.hourAry objectAtIndex:row];
            self.hour = [selectHour intValue];
        }
        
        if (component == 4) {
            NSString *selectMinute = [self.minuteAry objectAtIndex:row];
            self.minute = [selectMinute intValue];
        }
        
        if (component == 5) {
            NSString *selectSecond = [self.secondAry objectAtIndex:row];
            self.second = [selectSecond intValue];
        }
    }else if (_pickViewType == 3) {
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
    }else if (_pickViewType == 4) {
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
            [self.testPickView reloadAllComponents];
            
        }
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([UIScreen mainScreen].bounds.size.width-10)/_numComponces;
}

#pragma mark -
-(void)setYearBeforNow:(int)num andType:(int)type
{
    if (_pickViewType == 5 ||
        _pickViewType == 6 ||
        _pickViewType == 7) {
        return;
    }
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
    [self setOtherDate];
    if(type == 0){
        self.year = [[self.yearAry objectAtIndex:0] intValue];
    }
    [self setFrisDate];
    [self.testPickView reloadAllComponents];
}

-(void)setYearAfterNow:(int)num andType:(int)type
{
    if (_pickViewType == 5 ||
        _pickViewType == 6 ||
        _pickViewType == 7) {
        return;
    }
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
    [self setOtherDate];
    if (type == 0) {
        self.year = [[self.yearAry objectAtIndex:0] intValue];
    }
    [self setFrisDate];
    [self.testPickView reloadAllComponents];
}


-(void)setYearBtwNow:(int)num
{
    if (_pickViewType == 5 ||
        _pickViewType == 6 ||
        _pickViewType == 7) {
        return;
    }
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
    [self setOtherDate];
    [self setFrisDate];
    [self.testPickView reloadAllComponents];
}

-(void)setYeraFrom:(int)BYear and:(int)EYear
{
    if (_pickViewType == 5 ||
        _pickViewType == 6 ||
        _pickViewType == 7) {
        return;
    }
    [self.yearAry removeAllObjects];
    for (int i = BYear; i <= EYear; i++) {
        [self.yearAry addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self setOtherDate];
    [self setFrisDate];
    [self.testPickView reloadAllComponents];
}

-(void)setOtherDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *time_now = [formatter stringFromDate:date];
    self.year = [[time_now substringToIndex:4] intValue];
    self.month = [[time_now substringWithRange:NSMakeRange(5, 2)] intValue];
    self.day = [[time_now substringWithRange:NSMakeRange(8, 2)] intValue];
    self.day1 = [[time_now substringWithRange:NSMakeRange(8, 2)] intValue];
    self.hour = [[time_now substringWithRange:NSMakeRange(11, 2)] intValue];
    self.minute = [[time_now substringWithRange:NSMakeRange(14, 2)] intValue];
    self.second = [[time_now substringWithRange:NSMakeRange(17, 2)] intValue];
}

-(void)setApperDate:(NSString *)dateStr
{
    if (dateStr.length < 19) {
        NSLog(@"无效的初始时间");
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        return;
    }
    self.year = [[dateStr substringToIndex:4] intValue];
    self.month = [[dateStr substringWithRange:NSMakeRange(5, 2)] intValue];
    self.day = [[dateStr substringWithRange:NSMakeRange(8, 2)] intValue];
    self.day1 = [[dateStr substringWithRange:NSMakeRange(8, 2)] intValue];
    self.hour = [[dateStr substringWithRange:NSMakeRange(11, 2)] intValue];
    self.minute = [[dateStr substringWithRange:NSMakeRange(14, 2)] intValue];
    self.second = [[dateStr substringWithRange:NSMakeRange(17, 2)] intValue];
    
    if (_pickViewType == 0 ||
        _pickViewType == 1 ||
        _pickViewType == 2 ||
        _pickViewType ==3 ||
        _pickViewType == 4) {
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
    }
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
    int hour = self.hour - [[self.hourAry objectAtIndex:0] intValue];
    int minute = self.minute - [[self.minuteAry objectAtIndex:0] intValue];
    int second = self.second - [[self.secondAry objectAtIndex:0] intValue];
    if (year >= self.yearAry.count ||
        month >= self.monthaAry.count ||
        day >= self.dayAry.count ||
        hour >= self.hourAry.count ||
        minute >= self.minuteAry.count ||
        second >= self.secondAry.count) {
        NSLog(@"无效的初始时间");
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        return;
    }
    if (_pickViewType == 0) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:year inComponent:0 animated:YES];
        [self.testPickView selectRow:month inComponent:1 animated:YES];
        [self.testPickView selectRow:day inComponent:2 animated:YES];
        [self.testPickView selectRow:hour inComponent:3 animated:YES];
        [self.testPickView selectRow:minute inComponent:4 animated:YES];
        [self.testPickView selectRow:second inComponent:5 animated:YES];
        self.isRun = [self isRunWithYear:self.year];
    }else if (_pickViewType == 1) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:year inComponent:0 animated:YES];
        [self.testPickView selectRow:month inComponent:1 animated:YES];
        [self.testPickView selectRow:day inComponent:2 animated:YES];
        [self.testPickView selectRow:hour inComponent:3 animated:YES];
        [self.testPickView selectRow:minute inComponent:4 animated:YES];
        self.isRun = [self isRunWithYear:self.year];
    }else if (_pickViewType == 2) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:year inComponent:0 animated:YES];
        [self.testPickView selectRow:month inComponent:1 animated:YES];
        [self.testPickView selectRow:day inComponent:2 animated:YES];
        [self.testPickView selectRow:hour inComponent:3 animated:YES];
        self.isRun = [self isRunWithYear:self.year];
    }
    else if (_pickViewType == 3) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:year inComponent:0 animated:YES];
        [self.testPickView selectRow:month inComponent:1 animated:YES];
        [self.testPickView selectRow:day inComponent:2 animated:YES];
        self.isRun = [self isRunWithYear:self.year];
    }else if (_pickViewType == 4) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:year inComponent:0 animated:YES];
        [self.testPickView selectRow:month inComponent:1 animated:YES];
        self.isRun = [self isRunWithYear:self.year];
    }else if (_pickViewType == 5) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:hour inComponent:0 animated:YES];
        [self.testPickView selectRow:minute inComponent:1 animated:YES];
        [self.testPickView selectRow:second inComponent:2 animated:YES];
    }else if (_pickViewType == 6) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:hour inComponent:0 animated:YES];
        [self.testPickView selectRow:minute inComponent:1 animated:YES];
    }else if (_pickViewType == 7) {
        [self.testPickView reloadAllComponents];
        [self.testPickView selectRow:minute inComponent:0 animated:YES];
        [self.testPickView selectRow:second inComponent:1 animated:YES];
    }
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
        
        NSString *hour = [NSString stringWithFormat:@"%d",self.hour];
        if (self.hour < 10) {
            hour = [NSString stringWithFormat:@"0%d",self.hour];
        }
        
        NSString *minute = [NSString stringWithFormat:@"%d",self.minute];
        if (self.minute < 10) {
            minute = [NSString stringWithFormat:@"0%d",self.minute];
        }
        
        NSString *second = [NSString stringWithFormat:@"%d",self.second];
        if (self.second < 10) {
            second = [NSString stringWithFormat:@"0%d",self.second];
        }
        sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",mouth]];
        sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",day]];
        sText = [sText stringByAppendingString:[NSString stringWithFormat:@" %@",hour]];
        sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",minute]];
        sText = [sText stringByAppendingString:[NSString stringWithFormat:@":%@",second]];
        if (self.iType == 1) {
            sText = [sText stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        }
        if (_pickViewType == 1) {
            sText = [sText substringToIndex:16];
        }else if (_pickViewType == 2) {
            sText = [sText substringToIndex:13];
        }else if (_pickViewType == 3) {
            sText = [sText substringToIndex:10];
        }else if (_pickViewType == 4) {
            sText = [sText substringToIndex:7];
        }else if (_pickViewType == 5) {
            NSRange range = NSMakeRange(11, 8);
            sText = [sText substringWithRange:range];
        }else if (_pickViewType == 6) {
            NSRange range = NSMakeRange(11, 5);
            sText = [sText substringWithRange:range];
        }else if (_pickViewType == 7) {
            NSRange range = NSMakeRange(14, 5);
            sText = [sText substringWithRange:range];
        }
        [self removeFromSuperview];
        [self.delegate returnDateCompleteWithDate:sText];
    }
}
@end
