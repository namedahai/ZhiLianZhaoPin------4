//
//  SecondSelectDataTableViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectDataTableViewProtocol.h"
@interface SecondSelectDataTableViewController : UITableViewController
{
    NSMutableArray *secondDataArray;
    NSMutableArray *boolDataArray;
    BOOL unSelect;
}
@property(nonatomic,retain)NSString *selectName;
@property(nonatomic,assign)int row;
@property(nonatomic,assign)id<SelectDataTableViewProtocol>delegate;
@property(nonatomic,assign)int firstRow;
@property(nonatomic,retain)NSMutableArray *boolDataArray;
@property(nonatomic,assign)int allSelect;
-(void)analysis;
@end
