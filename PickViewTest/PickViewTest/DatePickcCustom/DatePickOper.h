//
//  DatePickOper.h
//  PickViewTest
//
//  Created by 梁成友 on 16/6/2.
//  Copyright © 2016年 梁成友. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnProto <NSObject>

-(void)cacleBtn;

-(void)clickBtn;

@end

@interface DatePickOper : UIView
@property (nonatomic, weak)id<btnProto>delegate;
@end
