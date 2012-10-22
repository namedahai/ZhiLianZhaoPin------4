//
//  Company.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

@implementation Company
@synthesize company_name,company_size,company_number,company_type,date_show,resume_name;
-(void)dealloc
{
    [company_name release];
    [company_number release];
    [company_size release];
    [company_type release];
    [resume_name release];
    [date_show release];
    [super dealloc];
}
@end
