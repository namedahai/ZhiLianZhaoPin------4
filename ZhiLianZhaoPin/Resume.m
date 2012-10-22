//
//  Resume.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Resume.h"

@implementation Resume
@synthesize resume_id,resume_name,resume_number,isdefaultflag,show_count,version_number;
-(NSString *)description
{
    NSString *string = [NSString stringWithFormat:@"id:%@,name:%@,number:%@,isdefault:%d,showcount:%@,version:%@",resume_id,resume_name,resume_number, isdefaultflag,show_count,version_number];
    return string;
}
-(void)dealloc
{
    resume_id = nil;
    resume_name = nil;
    resume_number = nil;
    version_number = nil;
    show_count = nil;
    [super dealloc];
}
@end
