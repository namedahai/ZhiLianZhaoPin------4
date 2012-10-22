//
//  RetriveViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface RetriveViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *email;
    UITextField *_emailTextField;
    NSString *_errorString;
    int _needSendMobile;
    UIButton *_needSendMobileButton;
}
@property (retain,nonatomic) NSString *email,*errorString;
@property (retain,nonatomic) UITextField *emailTextField;
@property (assign,nonatomic) int needSendMobile;
@property (retain,nonatomic) UIButton *needSendMobileButton;
-(BOOL)parseReceivedString:(NSString *)string;
@end
