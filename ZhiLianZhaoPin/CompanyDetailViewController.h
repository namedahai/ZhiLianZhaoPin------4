//
//  CompanyDetailViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

@interface CompanyDetailViewController : UIViewController
{
    Company *_company;
    UILabel *_companyLabel;
}
@property (retain ,nonatomic) Company *company;
@property (retain ,nonatomic) UITextView *textView;
@property (strong ,nonatomic) NSString *errorString;
@property (retain ,nonatomic) UILabel *companyLabel;
-(BOOL)parseReceivedString:(NSString *)string;
@end
