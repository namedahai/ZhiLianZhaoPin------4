//
//  PromptView.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PromptView.h"
#import <QuartzCore/QuartzCore.h>
@implementation PromptView
@synthesize promptImageView = _promptImageView,promptLabel = _promptLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.promptImageView = [[UIImageView alloc]initWithFrame:self.frame];
        self.promptImageView.image = [UIImage imageNamed:@"toast_bg.png"];
        [self addSubview:self.promptImageView];
        self.promptLabel = [[UILabel alloc]initWithFrame:self.frame];
        self.promptLabel.backgroundColor = [UIColor clearColor];
        self.promptLabel.textColor = [UIColor whiteColor];
        self.promptLabel.textAlignment = UITextAlignmentCenter;
        self.promptLabel.text = @"";
        [self addSubview:self.promptLabel];
        // Initialization code
    }
    return self;    
}
-(id)initWithFrame:(CGRect)aFrame Result:(NSString *)aResult PromtLabelText:(NSString *)aPromtLabelText
{
    self = [self initWithFrame:aFrame];
    if (self) 
    {
       self.promptLabel.text = aPromtLabelText;
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];

    }
    return self;
}
- (void)dealloc {
    [self.promptImageView release];
    self.promptImageView = nil;
    [self.promptLabel release];
    self.promptLabel = nil;
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
