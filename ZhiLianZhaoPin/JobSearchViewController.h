//
//  JobSearchViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobCellViewProtocol.h"
#import "CreatJobSearchViewController.h"
@interface JobSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JobCellViewProtocol,CreateJobReloadDataDelegate>
@property(nonatomic,retain)UITableView *jobTableView;
@property(nonatomic,retain)NSMutableData *receiveData;
@property(nonatomic,retain) NSMutableArray *dataInformation;
@property(nonatomic,retain)NSURLConnection *deleteConnection;
@property(nonatomic,retain)NSMutableData *deleteData;
-(void)creatJobSearch;
-(void)ObtainPositionInformation:(NSString *)ut;
-(void)deleteInformation:(NSString *)uticket:(NSString *)alert_id;
@end
