//
//  ViewController.m
//  WWLJPickView
//
//  Created by 武文杰 on 15/7/16.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import "ViewController.h"
#import "WWLJPickerView.h"

@interface ViewController ()<WWLJPickerViewDelegate>
@property (nonatomic, strong) WWLJPickerView *pickerFromCode;
@property (nonatomic, strong) UIView *pickerV;
@property (nonatomic, strong) UIToolbar *barView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.pickerFromCode = [[WWLJPickerView alloc]initWithFrame:CGRectMake(0, 100, 375, 400)];
    self.pickerFromCode.delegate = self;
    [self.view addSubview:self.pickerFromCode];
    self.pickerFromCode.flag = 1;
    [self.pickerFromCode setupMinYear:2010 maxYear:2016];
    [self.pickerFromCode selectDateWith:@"2012" andMonth:@"May"];

}



- (void)selectYear:(NSString *)year andMonth:(NSString *)month
{
    NSLog(@"%@", year);
    NSLog(@"%@", month);
}


@end
