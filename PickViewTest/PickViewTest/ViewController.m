//
//  ViewController.m
//  PickViewTest
//
//  Created by 梁成友 on 16/4/26.
//  Copyright © 2016年 梁成友. All rights reserved.
//

#import "ViewController.h"
#import "DatePickView.h"

@interface ViewController ()<returnDate>

@property (nonatomic, strong)UIButton *showPick;

@property (nonatomic, strong)DatePickView *dataPick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showPick = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-40, self.view.center.y-30, 80, 60)];
    self.showPick.backgroundColor = [UIColor redColor];
    [self.showPick setTitle:@"显示" forState:UIControlStateNormal];
    [self.showPick addTarget:self action:@selector(showpickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showPick];
}

-(void)showpickMethod:(UIButton *)sender
{
    [self.view addSubview:self.dataPick];
}

-(DatePickView *)dataPick
{
    if (!_dataPick) {
        self.dataPick = [[DatePickView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) timeType:0];
        self.dataPick.delegate = self;
//        [self.dataPick setYeraFrom:2010 and:2099];
//        [self.dataPick setApperDate:@"2040 02 22 20 22 22"];
    }
    return _dataPick;
}

-(void)returnDateCompleteWithDate:(NSString *)date
{
    NSLog(@"%@",date);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
