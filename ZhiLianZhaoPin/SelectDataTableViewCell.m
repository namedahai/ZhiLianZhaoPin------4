//
//  SelectDataTableViewCell.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectDataTableViewCell.h"

@implementation SelectDataTableViewCell
@synthesize selectBtn,selectLabel;
- (void)dealloc {
    [selectLabel release];
    selectLabel = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(7.5, 7.5, 29, 29);
        [self.contentView addSubview:self.selectBtn];
        self.selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, 250, 44)];
        self.selectLabel.text = @"";
        [self.contentView addSubview:self.selectLabel];
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
