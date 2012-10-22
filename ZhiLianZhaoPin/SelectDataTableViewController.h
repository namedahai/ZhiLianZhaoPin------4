//
//  SelectDataTableViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDataProtocol.h"
#import "SelectDataTableViewProtocol.h"
#import "PromptView.h"
@interface SelectDataTableViewController : UITableViewController<SelectDataTableViewProtocol>
{
    NSMutableArray *dataArray;
    NSMutableArray *boolDataArray;
    BOOL unSelect;
    NSMutableArray *secondSelectArray;//接受第二页传过来的数据;
    NSMutableDictionary *secondSelectDic;
   
}
@property(nonatomic,assign)int row;
@property(nonatomic,assign)id<SelectDataProtocol>delegate;
@property(nonatomic,retain)NSMutableArray *boolDataArray;
@property(nonatomic,retain)NSMutableDictionary *secondUnSelectDic;
-(void)analysisArea;//解析xml数据地区1;
-(void)analysisJob;//解析职位；
-(void)analysisBusiness;
-(void)analysisMoreOption;//解析更多选项;
@end
