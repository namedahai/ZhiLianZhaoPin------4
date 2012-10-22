//
//  JobSearchViewCell.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JobSearchViewCell.h"

@implementation JobSearchViewCell
@synthesize jobCellView = _jobCellView;
- (void)dealloc {
    [_jobCellView release];
    _jobCellView = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.jobCellView = [[JobCellView alloc]initWithFrame:CGRectMake(0, 0, 310,68)];
        [self.contentView addSubview:self.jobCellView];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
