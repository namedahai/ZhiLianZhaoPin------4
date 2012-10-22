//
//  Resume.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface Resume : NSObject
{
    NSString *resume_id;
    NSString *resume_number;
    NSString *resume_name;
    NSString *version_number;
    BOOL isdefaultflag;
    NSString *show_count;
}
@property (strong, nonatomic)NSString *resume_id,*resume_number,*resume_name,*show_count,*version_number;
@property (assign, nonatomic)BOOL isdefaultflag;
-(NSString *)description;
@end
