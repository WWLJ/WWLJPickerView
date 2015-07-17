//
//  WWLJPickerView.m
//  WWLJPickView
//
//  Created by 武文杰 on 15/7/16.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import "WWLJPickerView.h"

// Identifiers of components
#define MONTH ( 1 )
#define YEAR ( 0 )

// Identifies for component views
#define LABEL_TAG 43

@interface WWLJPickerView ()
///today的路径
@property (nonatomic, strong) NSIndexPath *todayIndexPath;
/// 月份的数组
@property (nonatomic, strong) NSArray *months;
///年的数组
@property (nonatomic, strong) NSArray *years;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@property (nonatomic, strong) UIToolbar *barView;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger monthCount;

@property (nonatomic, assign) NSInteger selectrow;


@property (nonatomic, copy) NSString *selectYear;
@property (nonatomic, copy) NSString *selectMonth;


@end

@implementation WWLJPickerView

const NSInteger bigRowCount = 1;
const NSInteger numberOfComponents = 2;

#pragma mark - Properties

-(void)setMonthFont:(UIFont *)monthFont
{
    if (monthFont)
    {
        _monthFont = monthFont;
    }
}

-(void)setMonthSelectedFont:(UIFont *)monthSelectedFont
{
    if (monthSelectedFont)
    {
        _monthSelectedFont = monthSelectedFont;
    }
}

-(void)setYearFont:(UIFont *)yearFont
{
    if (yearFont)
    {
        _yearFont = yearFont;
    }
}

-(void)setYearSelectedFont:(UIFont *)yearSelectedFont
{
    if (yearSelectedFont)
    {
        _yearSelectedFont = yearSelectedFont;
    }
}

#pragma mark - Init

-(instancetype)init
{
    if (self = [super init])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.monthCount = 12;
        self.selectrow = 0;
        self.flag = 0;
        [self loadDefaultsParameters];
        [self addSubview:self.barView];
        [self addSubview:self.pickerView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}

#pragma mark - Open methods

-(NSDate *)date
{
    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self.pickerView selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self.pickerView selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM:yyyy"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
    return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = minYear + 10;
    }
    
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
}

-(void)selectToday
{
    [self.pickerView selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self.pickerView selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

- (void)selectDateWith:(NSString *)year andMonth:(NSString *)month
{
    
    
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            break;
        }
    }
   
    self.selectYear = year;
    self.selectMonth = month;
    
    [self.pickerView selectRow: row
                   inComponent: MONTH
                      animated: NO];
    
    [self.pickerView selectRow: section
                   inComponent: YEAR
                      animated: NO];
}


#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    returnView.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
    returnView.textColor = selected ? [self selectedColorForComponent:component] : [self colorForComponent:component];
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0 && row == self.years.count - 1 && self.flag == 1) {
        self.monthCount = 0;
        [self.pickerView reloadComponent:1];
        self.selectrow = [self.pickerView selectedRowInComponent:1];
    }else{
        self.monthCount = 12;
        [self.pickerView reloadComponent:1];
    }
   
    if (self.flag) {
        if (component == 0 && row == self.years.count - 1) {
            self.selectYear = [self.years objectAtIndex:row];
            self.selectMonth = @"00";
        }
    }else{
        if (component == 0) {
            self.selectYear = [self.years objectAtIndex:row];
        }else{
            self.selectMonth = [self.months objectAtIndex:row];
        }
    }
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return self.monthCount;
    }
    return [self bigRowYearCount];
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return self.years.count  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = self.years.count;
    if (row == yearCount - 1 && self.flag == 1) {
        return @"至今";
    }
    
    return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    return @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
        [years addObject:yearStr];
    }
    
    if (self.flag == 1) {
        NSString *yearStr = [NSString stringWithFormat:@"0000"];
        [years addObject:yearStr];
    }
    
    return years;
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

- (UIColor *)selectedColorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedTextColor;
    }
    return self.yearSelectedTextColor;
}

- (UIColor *)colorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthTextColor;
    }
    return self.yearTextColor;
}

- (UIFont *)selectedFontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedFont;
    }
    return self.yearSelectedFont;
}

- (UIFont *)fontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthFont;
    }
    return self.yearFont;
}

-(void)loadDefaultsParameters
{
    self.minYear = 2008;
    self.maxYear = 2030;
    self.rowHeight = 44;
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.monthFont = [UIFont boldSystemFontOfSize:17];
    
    self.yearSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.yearFont = [UIFont boldSystemFontOfSize:17];
}

#pragma mark - 懒加载
- (UIToolbar *)barView
{
    if (!_barView) {
        _barView = [[UIToolbar alloc]
                    initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, 45)];
        _barView.backgroundColor = [UIColor clearColor];
                
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                      target: self
                                      action: nil];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
        
        _barView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_barView setItems: @[ flexSpace, doneBtn]
                 animated: YES];
    }
    return _barView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height - 45)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        
    }
    return _pickerView;
}
- (void)doneAction
{
    NSLog(@"被点击了");
    if ([self.delegate respondsToSelector:@selector(selectYear:andMonth:)]) {
        [self.delegate selectYear:self.selectYear andMonth:self.selectMonth];
    }
}


@end
