//
//  FieldTableViewCell.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldTableViewCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,retain)UILabel *firstLabel;
@property(nonatomic,retain)UITextField *secondTF;
@end
