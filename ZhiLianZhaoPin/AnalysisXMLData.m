//
//  AnalysisXMLData.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnalysisXMLData.h"
@implementation AnalysisXMLData
@synthesize dataArray = _dataArray;
-(id)initWithArray:(NSMutableArray*)aDataArray
{
    self=[super init];
    if (self) {
        self.dataArray = aDataArray;
    }
    return self;
}
-(GDataXMLElement *)analysis//解析开始
{
    NSString *str = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZhiLianData" ofType:@"xml"]encoding:NSUTF8StringEncoding error:nil ];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:str options:0 error:nil];
    GDataXMLElement *root = [document rootElement];//获得根节点;
    NSArray *children = [root children];//获得节点
    GDataXMLElement *basedata = [children objectAtIndex:0];
    return basedata;
}
-(NSMutableArray *)analysisArea:(NSString *)areaData//解析xml数据地区1;
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *city = [[basedata children]objectAtIndex:0];
    GDataXMLElement *firstLevel = [[city children]objectAtIndex:0];
    [self.dataArray removeAllObjects];
    for (GDataXMLElement *cityName in [firstLevel children]) {
        [self.dataArray addObject:[cityName stringValue]];
    }
    NSArray *areaArray = [areaData componentsSeparatedByString:@";"];
    NSMutableArray *boolArray = [NSMutableArray array];
    for (NSString *str1 in self.dataArray) {
        BOOL unSelect = YES;
        for (NSString *str2 in areaArray) 
        {
            if ([str1 isEqualToString:str2] == YES) {
                unSelect = NO;
            }
        }
        [boolArray addObject:[NSNumber numberWithBool:unSelect]];
    }
    return boolArray;
    
}
-(NSMutableArray *)analysisJob:(NSString *)jobData//解析职位
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *jobtype = [[basedata elementsForName:@"jobtype"] objectAtIndex:0];
    [self.dataArray removeAllObjects];
    NSArray *jobArray = [jobData componentsSeparatedByString:@";"];
    GDataXMLElement *smallJobType = [[basedata elementsForName:@"small_Job_type"] objectAtIndex:0];
    NSString *firstCode;
    NSMutableArray *smallArray = [NSMutableArray array];
    for (GDataXMLElement *smallJob in [smallJobType children]) {
        for (NSString *str1 in jobArray) {
            if ([[smallJob stringValue] isEqualToString:str1] == YES) {
                if([smallArray indexOfObject:[[smallJob attributeForName:@"categoryid"] stringValue]]==NSNotFound)
                    [smallArray addObject:[[smallJob attributeForName:@"categoryid"] stringValue]];
            }
        }
    }
    NSMutableArray *boolFirstJobData = [NSMutableArray array];
    
    for (GDataXMLElement *jobPost in [jobtype children]) {
        [self.dataArray addObject:[jobPost stringValue]];
        BOOL unSelect = YES;
        for (NSString *str2 in smallArray) 
        {
            if ([[[jobPost attributeForName:@"code"] stringValue] isEqualToString:str2]) 
            {
                unSelect = NO;
            }
        }
        [boolFirstJobData addObject:[NSNumber numberWithBool:unSelect]];
    }
    NSMutableDictionary *boolDic = [NSMutableDictionary dictionary];
    NSMutableArray *secondUnSelectArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[boolFirstJobData count]; i++) 
    {
        if ([[boolFirstJobData objectAtIndex:i] boolValue] == NO) 
        {
            NSMutableArray *boolSecondArray = [NSMutableArray array];//写入第二页的等量情况
            GDataXMLElement *item = [[jobtype children] objectAtIndex:i];
            firstCode = [[item attributeForName:@"code"] stringValue];
            
            for (GDataXMLElement *jobName in [smallJobType children]) 
            {
                if ([[[jobName attributeForName:@"categoryid"] stringValue]isEqualToString:firstCode] == YES) 
                {
                    BOOL secondUnSelect = YES;
                    for (NSString *str3 in jobArray) 
                    { 
                        
                        if ([str3 isEqualToString:[jobName stringValue]] == YES) 
                        {
                            secondUnSelect = NO;
                        }
                    }  
                    [boolSecondArray addObject:[NSNumber numberWithBool:secondUnSelect]];
                }
            }
            [boolDic setObject:boolSecondArray forKey:[NSNumber numberWithInt:i]];
        }
    }
    [secondUnSelectArray addObject:boolFirstJobData];
    [secondUnSelectArray addObject:boolDic];
    return [secondUnSelectArray autorelease];
}
-(NSMutableArray *)analysisBusiness:(NSString *)businessData//解析行业
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *industry = [[basedata elementsForName:@"industry"]objectAtIndex:0];
    [self.dataArray removeAllObjects];
    for (GDataXMLElement *business in [industry children]) {
        [self.dataArray addObject:[business stringValue]];
    }
    NSArray *businessArray = [businessData componentsSeparatedByString:@";"];
    NSMutableArray *boolArray = [NSMutableArray array];
    for (NSString *str1 in self.dataArray) {
        BOOL unSelect = YES;
        for (NSString *str2 in businessArray) 
        {
            if ([str1 isEqualToString:str2] == YES) {
                unSelect = NO;
            }
        }
        [boolArray addObject:[NSNumber numberWithBool:unSelect]];
    }

    return boolArray;
}
-(NSMutableArray *)analysisMoreOption:(int)i:(NSString *)moreData//解析更多选项;
{
    GDataXMLElement *basedata = [self analysis];
    [self.dataArray removeAllObjects];
    switch (i) {
        case 4:
        {
            GDataXMLElement *publishDate = [[basedata elementsForName:@"publishDate"]objectAtIndex:0];
            for (GDataXMLElement *business in [publishDate children]) {
                [self.dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 5:
        {
            GDataXMLElement *workEXP = [[basedata elementsForName:@"workEXP"]objectAtIndex:0];
            for (GDataXMLElement *business in [workEXP children]) {
                [self.dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 6:
        {
            GDataXMLElement *education = [[basedata elementsForName:@"education"]objectAtIndex:0];
            for (GDataXMLElement *business in [education children]) {
                [self.dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 7:
        {
            GDataXMLElement *comptype = [[basedata elementsForName:@"comptype"]objectAtIndex:0];
            for (GDataXMLElement *business in [comptype children]) {
                [self.dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 8:
        {
            GDataXMLElement *compsize = [[basedata elementsForName:@"compsize"]objectAtIndex:0];
            for (GDataXMLElement *business in [compsize children]) {
                [self.dataArray addObject:[business stringValue]];
            }
        }
            break;
        default:
            break;
    }
    NSArray *moreArray = [moreData componentsSeparatedByString:@";"];
    NSMutableArray *boolArray = [NSMutableArray array];
    for (NSString *str1 in self.dataArray) {
        BOOL unSelect = YES;
        for (NSString *str2 in moreArray) 
        {
            if ([str1 isEqualToString:str2] == YES) {
                unSelect = NO;
            }
        }
        [boolArray addObject:[NSNumber numberWithBool:unSelect]];
    }
    return boolArray;
}
- (void)dealloc {
    [_dataArray release];
    [super dealloc];
}
@end
