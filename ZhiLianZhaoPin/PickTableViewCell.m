//
//  PickTableViewCell.m
//  可输入的tableView
//
//  Created by Ibokan on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PickTableViewCell.h"

@implementation PickTableViewCell
@synthesize label1 = _label1,label2 = _label2;
@synthesize inputAccessoryView = _inputAccessoryView;
@synthesize delegate = _delegate;
@synthesize inputView = _inputView;
@synthesize cellImageView = _cellImageView;
@synthesize contents;
- (void)dealloc {
    [_label1 release];
    [_label2 release];
    [contents release];
    [_cellImageView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 44)];
        _label1.text = @"";
        _label1.textAlignment = UITextAlignmentLeft;
        _label1.font = [_label1.font fontWithSize:15];
        _label1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label1];
        
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 170, 44)];
        _label2.backgroundColor = [UIColor clearColor];
        _label2.textAlignment = UITextAlignmentRight;
        _label2.textColor = [UIColor lightGrayColor];
        _label2.text = @"";
        _label2.font = [_label2.font fontWithSize:15];
        [self.contentView addSubview:_label2];
        
        _cellImageView = [[UIImageView alloc]init];
        _cellImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cellImageView];
        
        contents = [[NSArray alloc]init];
        // Initialization code
    }
    return self;
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIToolbar *)inputAccessoryView {
    
	//如果没有输入的辅助视图，则创建一个
    if (!_inputAccessoryView) {
        _inputAccessoryView =[[UIToolbar alloc] init];
        
        _inputAccessoryView.barStyle =UIBarStyleBlackTranslucent;
        _inputAccessoryView.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        [_inputAccessoryView sizeToFit];
        UIBarButtonItem  *spaceBtnItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem  *doneBtnItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        NSArray  *items =[NSArray arrayWithObjects:spaceBtnItem,doneBtnItem, nil];
        _inputAccessoryView.items =items;
        
        [spaceBtnItem release];
        [doneBtnItem release];
    }
    return _inputAccessoryView;
}
-(void)done
{
    [self resignFirstResponder];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [contents objectAtIndex:row];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [contents count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str = [contents objectAtIndex:row];
    [self.delegate content:str];
    
}
-(UIPickerView *)inputView
{ 
    if (!_inputView) {
        _inputView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 200, 320, 100)];
        _inputView.delegate = self;
        _inputView.dataSource = self;
        _inputView.showsSelectionIndicator = YES;
        NSString *str = [contents objectAtIndex:0];
        [self.delegate content:str];
    }
    return _inputView;
    
}
@end
