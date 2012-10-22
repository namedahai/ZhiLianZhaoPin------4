//
//  CreatJobSearchViewCell.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatJobSearchViewCell : UITableViewCell
{
    UILabel *jobLabel;
    UILabel *selectLabel;
    UIImageView *cellImageView;
}
@property(nonatomic,retain)UILabel *jobLabel,*selectLabel;
@property(nonatomic,retain)UIImageView *cellImageView;
@end
