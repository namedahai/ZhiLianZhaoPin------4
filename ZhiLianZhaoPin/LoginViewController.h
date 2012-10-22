//
//  LoginViewController.h
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyZhiLianViewController.h"
#import "GDataXMLNode.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_usernameTextField;//用户名输入框
    UITextField *_passwordTextField;//密码输入框
    NSString *_username;//用户名
    NSString *_password;//密码
    NSMutableDictionary *_userInfoDictionary;//用户信息
    NSString *_errorString;//出错信息
    BOOL hasDefaultResumeFlag;//是否设置了默认简历
    //BOOL isLogout;
}
@property (retain,nonatomic) UITextField *usernameTextField,*passwordTextField;//用户名，密码输入框
@property (retain,nonatomic) NSString *username,*password;//用户名，密码
@property (retain,nonatomic) NSMutableDictionary *userInfoDictionary;//用户信息
@property (retain,nonatomic) NSString *errorString;//出错信息
@property (assign,nonatomic) BOOL hasDefaultResumeFalg;//是否设置了默认简历
-(BOOL)parseReceivedString:(NSString *)string;//解析xml文档
-(void)quickLogin;
@end
