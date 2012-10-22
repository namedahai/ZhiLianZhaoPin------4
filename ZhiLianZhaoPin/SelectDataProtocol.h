//
//  SelectDataProtocol.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectDataProtocol <NSObject>
-(void)dataProtocol:(NSMutableArray *)dataArr:(int)line:(NSMutableArray *)boolUnSelectArray:(NSMutableDictionary *)secondDictionary;
@end
