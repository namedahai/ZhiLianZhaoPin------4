//
//  CompanyList_ShowResumeViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resume.h"

@interface CompanyList_ShowResumeViewController : UITableViewController<NSURLConnectionDataDelegate>
{
    Resume *_resume;
    NSString *uticket;
    NSMutableArray *_companyList;
    NSString *_errorString;
    BOOL needLoadDataFlag;
    NSMutableData *responseData;
}
@property (retain, nonatomic) Resume *resume;
@property (strong, nonatomic) NSString *uticket,*errorString;
@property (retain, nonatomic) NSMutableArray *companyList;
@property (assign, nonatomic) BOOL needLoadDataFlag;
@property (retain, nonatomic) NSMutableData *responseData;
-(int)parseReceivedString:(NSString *)string;
@end
