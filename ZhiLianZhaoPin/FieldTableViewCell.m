//
//  FieldTableViewCell.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FieldTableViewCell.h"

@implementation FieldTableViewCell
@synthesize firstLabel,secondTF;
- (void)dealloc {
    [firstLabel release];
    firstLabel = nil;
    [secondTF release];
    secondTF = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 120, 44)];
        self.firstLabel.text = @"";
        self.firstLabel.textAlignment = UITextAlignmentLeft;
        self.firstLabel.backgroundColor = [UIColor clearColor];
        self.firstLabel.font = [self.firstLabel.font fontWithSize:15];
        [self.contentView addSubview:self.firstLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 5, 170, 34)];
        imageView.image = [UIImage imageNamed:@"input_bg.png"];
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        
        self.secondTF = [[UITextField alloc]initWithFrame:CGRectMake(125,5, 170, 34)];
        self.secondTF.backgroundColor = [UIColor clearColor];
        self.secondTF.textAlignment = UITextAlignmentRight;
        self.secondTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
       // self.secondTF.delegate = self;
        [self.contentView addSubview:self.secondTF];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
