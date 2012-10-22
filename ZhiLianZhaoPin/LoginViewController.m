//
//  LoginViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RetriveViewController.h"
#import "EncryptURL.h"
#import "RegisterViewController.h"
#import "Resume.h"
@implementation LoginViewController
@synthesize username = _username,password = _password,usernameTextField = _usernameTextField,passwordTextField = _passwordTextField,hasDefaultResumeFalg;
@synthesize userInfoDictionary = _userInfoDictionary,errorString = _errorString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [_username release];
    _username = nil;
    [_password release];
    _password = nil;
    [_userInfoDictionary release];
    _usernameTextField = nil;
    [_errorString release];
    _errorString = nil;
    [_usernameTextField release];
    _usernameTextField = nil;
    [_passwordTextField release];
    _passwordTextField = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)]autorelease];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //navigation title
    self.navigationItem.title = @"用户登录";
    //login界面，用户名，密码输入框背景图
    UIView *loginBgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 306, 105)];
    loginBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBg.png"]];
    [self.view addSubview:loginBgView];
    [loginBgView release];
   
    //账号输入框
    self.usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(65, 20, 228, 31)];
    self.usernameTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg.png"]];
    self.usernameTextField.textAlignment = UITextAlignmentLeft;
    self.usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;//账号输入键盘类型
    self.usernameTextField.delegate = self;
    [self.view addSubview:self.usernameTextField];
    //密码输入框
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(65, 70, 228, 31)];
    self.passwordTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg.png"]];
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    //
    //登陆按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(5, 116, 140, 40);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginNormal.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginPress.png"] forState:UIControlStateHighlighted];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    //[loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    //新用户注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(170, 116, 140, 40);
    [registerButton setBackgroundImage:[UIImage imageNamed:@"registerNormal.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"registerPress.png"] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    //[registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerNewUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

    //小人
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoren.png"]];
    imageView.frame = CGRectMake(0, 156, 320, 216);
    [self.view addSubview:imageView];
    [imageView release];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"user.txt"];
    NSDictionary *userDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    if(userDic)
    {
        NSString *username = [userDic valueForKey:@"username"];
        NSString *password = [userDic valueForKey:@"password"];
         NSLog(@"username = %@,password = %@",username,password);
        if(username && password)
        {
            self.username = username;
            self.password = password;
            [self quickLogin];
        }
    }
}
-(void)quickLogin
{
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/login.aspx?loginname=%@&password=%@",self.username,self.password];//原始url
    EncryptURL *encryption = [[EncryptURL alloc]init];
    NSString *urlStr = [encryption getMD5String:urls];//url MD5加密
    [encryption release];
    NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF8 Encode处理
    NSLog(@"encodeUrlStr = %@",encodeUrlStr);
    NSURL *url = [NSURL URLWithString:encodeUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"receivedString = %@",receivedString);
    
    //receivedString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"receivedString = %@",receivedString);
    if([self parseReceivedString:receivedString])//如果解析xml方法 返回登陆成功
    {
        MyZhiLianViewController *myZhiLian = [[MyZhiLianViewController alloc]init];//建立MyZhiLianViewController
        myZhiLian.userInfoDic = self.userInfoDictionary;//把用户信息传递给MyZhiLianViewController
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"user.txt"];
        NSDictionary *userDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.username,@"username",self.password,@"password", nil];
        [userDic writeToFile:filePath atomically:YES];//用户名和密码写入文件
        if(!self.hasDefaultResumeFalg)//如果用户没有设置默认简历
        {
            myZhiLian.defualtResumeViewNumber = -1;//设置MyZhiLianViewController的默认简历号为-1
        }
        self.passwordTextField.text = @"";
        [self.navigationController pushViewController:myZhiLian animated:YES];//push MyZhiLianViewController
    }

}
//注册新用户
-(void)registerNewUser
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}
//登陆
-(void)login
{
    NSLog(@"login");
    if(self.usernameTextField)//如果用户名输入框不为空
    {
        self.username = self.usernameTextField.text;//设置登陆用户名
    }
    if(self.passwordTextField)//如果密码输入框不为空
    {
        self.password = self.passwordTextField.text;//设置登陆密码
    }
    if(self.username && self.password)//如果用户名和密码都不为空，开始登陆
    {
        NSLog(@"can login");
        NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/login.aspx?loginname=%@&password=%@",self.username,self.password];//原始url
        EncryptURL *encryption = [[EncryptURL alloc]init];
        NSString *urlStr = [encryption getMD5String:urls];//url MD5加密
        [encryption release];
        NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF8 Encode处理
        NSLog(@"encodeUrlStr = %@",encodeUrlStr);
        NSURL *url = [NSURL URLWithString:encodeUrlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"receivedString = %@",receivedString);
        
        //receivedString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"receivedString = %@",receivedString);
        if([self parseReceivedString:receivedString])//如果解析xml方法 返回登陆成功
        {
            MyZhiLianViewController *myZhiLian = [[MyZhiLianViewController alloc]init];//建立MyZhiLianViewController
            myZhiLian.userInfoDic = self.userInfoDictionary;//把用户信息传递给MyZhiLianViewController
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"user.txt"];
            NSDictionary *userDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.username,@"username",self.password,@"password", nil];
            [userDic writeToFile:filePath atomically:YES];//用户名和密码写入文件
            if(!self.hasDefaultResumeFalg)//如果用户没有设置默认简历
            {
                myZhiLian.defualtResumeViewNumber = -1;//设置MyZhiLianViewController的默认简历号为-1
            }
            [self.navigationController pushViewController:myZhiLian animated:YES];//push MyZhiLianViewController
        }
        else//如果如果解析xml方法 返回登陆失败
        {
            NSLog(@"cannot login");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"%@" ,self.errorString] delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:@"找回密码", nil];//弹出警告窗口 ，选择“重新登陆”或者“找回密码”
            [alertView show];
        }
    }
    else//如果用户名或者密码为空
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户名或密码为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];//弹出警告窗口“用户名或密码为空”

    }
}
#pragma mark -
#pragma UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//当用户选择“重新登陆”
    {
        NSLog(@"找回密码");
        RetriveViewController *retriveViewController = [[RetriveViewController alloc]init];
        [self.navigationController pushViewController:retriveViewController animated:YES];
    }
}
-(BOOL)parseReceivedString:(NSString *)string//解析xml文档，把xml中的所有节点信息放入用户信息字典中，对应的key为节点标识，如@"utiket"
{
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:string options:0 error:&error];
    self.userInfoDictionary = [NSMutableDictionary dictionaryWithCapacity:5];

    //<root>
    GDataXMLElement *root = [document rootElement];
    //<result>
    GDataXMLNode *result = [root childAtIndex:0];
    int resultValue = [[result stringValue] intValue];
    if(resultValue != 1)
    {
        NSLog(@"error %d",resultValue);
        GDataXMLNode *message = [root childAtIndex:1];
        self.errorString = [message stringValue];
        return NO;
    }
    //<uticket>
    GDataXMLNode *uticket = [root childAtIndex:1];
    NSString *uticketString = [uticket stringValue];
    [self.userInfoDictionary setValue:uticketString forKey:@"uticket"];
    //<resumelist>
    GDataXMLElement *resumelist = [[root children] objectAtIndex:2];
    NSArray *resumes = [resumelist children];
    NSLog(@"resumes = %@",resumes);
    if([resumes count] >=1 )
    {
        NSMutableArray *resumesArray = [[NSMutableArray alloc]init];
        for(GDataXMLElement *resume in resumes)
        {
            // NSMutableDictionary *resumeDic = [[NSMutableDictionary alloc]initWithCapacity:6];
            Resume *resum = [[Resume alloc]init];
            GDataXMLElement *resume_id = [[resume elementsForName:@"resume_id"]objectAtIndex:0];
            NSString *resume_id_string = [resume_id stringValue];
            //[resumeDic setValue:resume_id_string forKey:@"resume_id"];
            resum.resume_id = resume_id_string;
        
            GDataXMLElement *resume_number = [[resume elementsForName:@"resume_number"]objectAtIndex:0];
            NSString *resume_number_string = [resume_number stringValue];
            //[resumeDic setValue:resume_number_string forKey:@"resume_number"];
            resum.resume_number = resume_number_string;
        
            GDataXMLElement *version_number = [[resume elementsForName:@"version_number"]objectAtIndex:0];
            NSString *version_number_string = [version_number stringValue];
            //[resumeDic setValue:version_number_string forKey:@"version_number"];
            resum.version_number = version_number_string;

            GDataXMLElement *resume_name = [[resume elementsForName:@"resume_name"]objectAtIndex:0];
            NSString *resume_name_string = [resume_name stringValue];
            //[resumeDic setValue:resume_name_string forKey:@"resume_name"];
            resum.resume_name = resume_name_string;

            GDataXMLElement *show_count = [[resume elementsForName:@"show_count"]objectAtIndex:0];
            NSString *show_count_string = [show_count stringValue];
            //[resumeDic setValue:show_count_string forKey:@"show_count"];
            resum.show_count = show_count_string;
         
            GDataXMLElement *isdefaultflag = [[resume elementsForName:@"isdefaultflag"]objectAtIndex:0];
            NSString *isdefaultflag_string = [isdefaultflag stringValue];
            //[resumeDic setValue:isdefaultflag_string forKey:@"isdefaultflag"];
            if([isdefaultflag_string isEqualToString:@"1"])
            {
                resum.isdefaultflag = YES;
                self.hasDefaultResumeFalg = YES;
                [resumesArray insertObject:resum atIndex:0];
        
            }
            else
            {
                resum.isdefaultflag = NO;
                [resumesArray addObject:resum];
            }

            //NSLog(@"login:resume = %@",resum);
            [resum release];
        }
        [self.userInfoDictionary setValue:resumesArray forKey:@"resumelist"];
    }
    //<no_read_hr_email_count>
    GDataXMLNode *no_read_hr_email_count = [root childAtIndex:3];
    NSString *no_read_count_string = [no_read_hr_email_count stringValue];
    [self.userInfoDictionary setValue:no_read_count_string forKey:@"no_read_hr_email_count"];
    NSLog(@"parse:noreademail = %@",[self.userInfoDictionary valueForKey:@"no_read_hr_email_count"]);
    //<apply_count>
    GDataXMLNode *apply_count = [root childAtIndex:4];
    NSString *apply_count_string = [apply_count stringValue];
    [self.userInfoDictionary setValue:apply_count_string forKey:@"apply_count"];
    //<fav_count>
    GDataXMLNode *fav_count = [root childAtIndex:5];
    NSString *fav_count_string = [fav_count stringValue];
    [self.userInfoDictionary setValue:fav_count_string forKey:@"fav_count"];
    //<job_searcher_count>
    GDataXMLNode *job_searcher_count = [root childAtIndex:6];
    NSString *job_searcher_count_string = [job_searcher_count stringValue];
    [self.userInfoDictionary setValue:job_searcher_count_string forKey:@"job_searcher_count"];
    NSLog(@"here job_searcher_count = %@",[self.userInfoDictionary valueForKey:@"job_searcher_count"]);
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField//键盘回收
{
    [textField resignFirstResponder];
    if(textField == self.usernameTextField)//如果为用户名输入框
    {
        if(self.passwordTextField)
        {
            self.password = self.passwordTextField.text;
        }
        self.username = textField.text;
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    if(textField.text)//如果textField为密码输入框，且输入框不为空
    {
        self.username = self.usernameTextField.text;
    }
    self.password = textField.text;
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    _usernameTextField = nil;
    _passwordTextField = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
