//
//  CreatJobSearchViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDataProtocol.h"
#import "CellLabel.h"
#import "PickTableViewCell.h"
#import "PromptView.h"
@protocol CreateJobReloadDataDelegate;
@interface CreatJobSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectDataProtocol,CellLabel,UITextFieldDelegate>
{
    NSMutableArray *searchConditionArray;//搜索条件;
    BOOL isOpen;
    NSMutableArray *advancedArray;
    NSMutableArray *timeArray;
    NSMutableArray *salaryArray;
    PickTableViewCell *strPickCell;
    NSMutableArray *timeAndSalaryArray;
    UIButton *saveBtn;
    NSMutableData *receiveData;
    NSString *tfStr;
    NSString *key_word;
    NSNumber *showKey;
    NSNumber *showSearch;
    
    NSMutableDictionary *boolUnselectDictionary;
    NSMutableDictionary *boolSecondUnselectDictionary;
}
@property(assign ,nonatomic) id <CreateJobReloadDataDelegate> delegate;
@property(nonatomic,retain)UITableView *creatTableView;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)NSMutableData *receiveData;
@property(nonatomic,retain)NSMutableArray *informationArray;
@end
@protocol CreateJobReloadDataDelegate

-(void)ReloadJobData;
@optional
-(void)autoMovekeyBoard:(CGFloat)f;//键盘回收

@end