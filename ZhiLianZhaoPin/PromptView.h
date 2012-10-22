//
//  PromptView.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView
@property(nonatomic,retain)UIImageView *promptImageView;
@property(nonatomic,retain)UILabel *promptLabel;
-(id)initWithFrame:(CGRect)aFrame Result:(NSString *)aResult PromtLabelText:(NSString *)aPromtLabelText;
@end
