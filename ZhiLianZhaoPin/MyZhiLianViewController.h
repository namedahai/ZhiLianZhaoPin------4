//
//  MyZhiLianViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MyResumeView.h"
@interface MyZhiLianViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,changeDefaultResumeDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_userInfoDic;
    NSString *uticket;
    UIScrollView *_resumeScrollView;
    UILabel *_helloLabel;
    UIPageControl *_pageControl;
    BOOL isLogin;
    int defualtResumeViewNumber;
}
@property(assign, nonatomic) BOOL isLogin;
@property(retain, nonatomic) UITableView *tableView;
@property(retain, nonatomic) NSMutableDictionary *userInfoDic;
@property(strong, nonatomic) NSString *uticket;
@property(retain, nonatomic)  UIScrollView *resumeScrollView;
@property(retain, nonatomic) UILabel *helloLabel;
@property(assign, nonatomic) int defualtResumeViewNumber;
@property(retain, nonatomic) UIPageControl *pageControl;
@end
