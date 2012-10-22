//
//  CreatJobSearchViewCell.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreatJobSearchViewCell.h"

@implementation CreatJobSearchViewCell
@synthesize jobLabel,selectLabel,cellImageView;
- (void)dealloc {
    [jobLabel release];
    jobLabel = nil;
    [selectLabel release];
    selectLabel = nil;
    [cellImageView release];
    cellImageView = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 44)];
        jobLabel.text = @"";
        jobLabel.textAlignment = UITextAlignmentLeft;
        jobLabel.font = [jobLabel.font fontWithSize:15];
        jobLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:jobLabel];
        selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 170, 44)];
        selectLabel.text = @"";
        selectLabel.textAlignment = UITextAlignmentRight;
        selectLabel.font = [selectLabel.font fontWithSize:15];
        selectLabel.textColor = [UIColor lightGrayColor];
        selectLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:selectLabel];
        cellImageView = [[UIImageView alloc]init];
       // cellImageView = [[UIImageView alloc]init]WithFrame:CGRectMake(285, 15, 10, 14)];
      //  cellImageView.image = [UIImage imageNamed:@"accessoryArrow.png"];
        cellImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
