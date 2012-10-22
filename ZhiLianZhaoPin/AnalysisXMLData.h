//
//  AnalysisXMLData.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface AnalysisXMLData : NSObject
@property(nonatomic,retain)NSMutableArray *dataArray;
-(GDataXMLElement *)analysis;//解析开始
-(NSMutableArray *)analysisArea:(NSString *)areaData;//解析xml数据地区1;
-(NSMutableArray *)analysisJob:(NSString *)jobData;//解析职位
-(NSMutableArray *)analysisBusiness:(NSString *)businessData;//解析行业
-(NSMutableArray *)analysisMoreOption:(int)i:(NSString *)moreData;//解析更多选项;

-(id)initWithArray:(NSMutableArray*)aDataArray;

@end
