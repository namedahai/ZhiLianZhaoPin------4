//
//  Company.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface Company : NSObject
{
    NSString *company_number;
    NSString *company_name;
    NSString *company_size;
    NSString *resume_name;
    NSString *company_type;
    NSString *date_show;
}
@property (strong,nonatomic) NSString *company_number,*company_name,*company_size,*resume_name,*date_show,*company_type;
@end
