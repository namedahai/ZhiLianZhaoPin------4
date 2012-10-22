//
//  MyResumeView.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-9-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resume.h"
#import <QuartzCore/QuartzCore.h>
#import "CompanyList_ShowResumeViewController.h"

//我的简历小视图
@protocol changeDefaultResumeDelegate;
@interface MyResumeView : UIView<UIAlertViewDelegate>
{
    UILabel *_titleLabel;
    UIButton *_viewCountButton;
    UIButton *_useResume;
    UIButton *_refreshButton;
    Resume *resume;
    NSString *uticket;
    NSString *errorString;
    int myResumeViewNumber;
}
@property(retain,nonatomic) Resume *resume;
@property(retain, nonatomic)UILabel *titeLabel;
@property(retain, nonatomic)UIButton *viewCountButton;
@property(retain, nonatomic)UIButton *useResume;
@property(retain, nonatomic)UIButton *refreshButton;
@property(strong, nonatomic)NSString *uticket,*errorString;
@property(assign, nonatomic) id <changeDefaultResumeDelegate> delegate;
@property(assign, nonatomic) int myResumeViewNumber;
-(int)parseReceivedString:(NSString *)string;
-(void)refresh;
@end
@protocol changeDefaultResumeDelegate 
-(void)changeDefaultResume:(int)myResumeViewNumber;
-(void)pushCompanyListView:(CompanyList_ShowResumeViewController *)companyListView;
@end