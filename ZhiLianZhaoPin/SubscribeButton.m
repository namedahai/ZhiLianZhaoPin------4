//
//  SubscribeButton.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubscribeButton.h"

@implementation SubscribeButton
@synthesize inputView = _inputView,inputAccessoryView = _inputAccessoryView,contents,delegate;
- (void)dealloc {
    [_inputAccessoryView release];
    [_inputView release];
    [contents release];
    [super dealloc];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (UIToolbar *)inputAccessoryView {
    
	//如果没有输入的辅助视图，则创建一个
    if (!_inputAccessoryView) {
        _inputAccessoryView =[[UIToolbar alloc] init];
        
        _inputAccessoryView.barStyle =UIBarStyleBlackTranslucent;
        _inputAccessoryView.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        [_inputAccessoryView sizeToFit];
        UIBarButtonItem  *spaceBtnItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem  *doneBtnItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(done)];
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
    [self.delegate setInterval];
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
    NSLog(@"[contents objectAtIndex:row] = %@",str);
    [self.delegate setContent:str];
    
}
-(UIPickerView *)inputView
{ 
    if (!_inputView) {
        _inputView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 200, 320, 100)];
        _inputView.delegate = self;
        _inputView.dataSource = self;
        _inputView.showsSelectionIndicator = YES;
    }
    return _inputView;
    
}

@end
