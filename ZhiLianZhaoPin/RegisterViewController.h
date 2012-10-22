//
//  RegisterViewController.h
//  ZhiLianZhaoPin
//
//  Created by Tiamo on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *_telephoneTF;
    UITextField *_emailTF;
    UITextField *_passwordTF;
    UITextField *_verifypasswordTF;
    UIView *_registerview;
    NSString *_password;
    NSString *_email;
    NSString *_telephone;
    NSMutableDictionary *_registerInfoDictionary;
    NSString *_errString;
}
@property(retain,nonatomic)UITextField *telephoneTF,*emailTF,*passwordTF,*verifypasswordTF;
@property(retain,nonatomic)UIView *registerview;
@property(retain,nonatomic)NSString *password,*email,*telephone,*errString;
@property(retain,nonatomic)NSMutableDictionary *registerInfoDictionary;
- (BOOL)validateEmail:(NSString *)email;
-(BOOL)parseReceivedString:(NSString *)string;
@end
