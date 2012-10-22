//
//  PickTableViewCell.h
//  可输入的tableView
//
//  Created by Ibokan on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellLabel.h"//pickView的代理
@interface PickTableViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,retain)UILabel *label1,*label2;
@property(nonatomic,retain)UIImageView *cellImageView;
@property(nonatomic,readwrite,retain)UIToolbar *inputAccessoryView;
@property(nonatomic,retain,readwrite)UIPickerView *inputView;
@property(nonatomic,assign)id<CellLabel>delegate;
@property(nonatomic,retain)NSArray *contents;
@end
