//
//  SubscribeButton.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeLabelContentDelegate;
//订阅按钮
@interface SubscribeButton : UIButton<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIToolbar *_inputAccessoryView;
    UIPickerView *_inputView;
}
@property(strong,nonatomic,readwrite) UIToolbar *inputAccessoryView;
@property(strong,nonatomic,readwrite) UIPickerView *inputView;
@property(nonatomic,retain) NSArray *contents;
@property(assign, nonatomic) id <changeLabelContentDelegate> delegate;
@end
@protocol changeLabelContentDelegate
-(void)setContent:(NSString *)str;
-(void)setInterval;//设置订阅周期
@end
