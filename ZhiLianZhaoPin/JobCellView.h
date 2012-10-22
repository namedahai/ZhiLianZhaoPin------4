//
//  MyResumeView.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-9-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobCellViewProtocol.h"
#import "SubscribeButton.h"
//我的简历小视图
@interface JobCellView : UIView<UIAlertViewDelegate,changeLabelContentDelegate,NSURLConnectionDataDelegate>
{
    UILabel *_titleLabel;
    UIButton *_viewCountButton;
    SubscribeButton *_useResume;
    UIButton *_refreshButton;
    UILabel *label3;
    int alertId;
    NSURLConnection *_subscribeConnection;
}
@property(retain, nonatomic)UILabel *titeLabel,*label3;//最新职位
@property(retain, nonatomic)UIButton *viewCountButton;//数字
@property(retain, nonatomic)SubscribeButton *useResume;//订阅
@property(retain, nonatomic)UIButton *refreshButton;//修改;
@property(retain, nonatomic)NSMutableData *receiveData,*subscribeData;
@property(assign, nonatomic)id<JobCellViewProtocol>jobDelegate;
@property(assign, nonatomic)int alertId;
@property(retain, nonatomic)NSURLConnection *subscribeConnection;

-(void)viewNewJob:(int)alert_id:(NSString *)uticket;//查看职位;
-(void)ObtainPositionInformation:(NSString *)ut:(int)a;//修改
@end
