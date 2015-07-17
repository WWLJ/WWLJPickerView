//
//  WWLJPickerView.h
//  WWLJPickView
//
//  Created by 武文杰 on 15/7/16.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWLJPickerViewDelegate <NSObject>

- (void)selectYear:(NSString *)year andMonth:(NSString *)month;

@end

@interface WWLJPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

/*
 *  pickerView  可以自定义的属性
 */

///月份选中的字体颜色
@property (nonatomic, strong) UIColor *monthSelectedTextColor;
///月份默认颜色
@property (nonatomic, strong) UIColor *monthTextColor;

///年份选中的字体颜色
@property (nonatomic, strong) UIColor *yearSelectedTextColor;
///年份默认的颜色
@property (nonatomic, strong) UIColor *yearTextColor;

///月份选中的字体
@property (nonatomic, strong) UIFont *monthSelectedFont;
///月份默认的字体
@property (nonatomic, strong) UIFont *monthFont;

///年份选中的字体
@property (nonatomic, strong) UIFont *yearSelectedFont;
///年份默认的字体
@property (nonatomic, strong) UIFont *yearFont;

///行高
@property (nonatomic, assign) NSInteger rowHeight;

///是否包含至今
@property (nonatomic, assign) int *flag;


@property (nonatomic,assign)id<WWLJPickerViewDelegate>delegate;



///设置最小和最大的时间
-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;

///选中今天
-(void)selectToday;

///选中你想选中的 年月    //传相对应的字符串
- (void)selectDateWith:(NSString *)year andMonth:(NSString *)month;


@end
