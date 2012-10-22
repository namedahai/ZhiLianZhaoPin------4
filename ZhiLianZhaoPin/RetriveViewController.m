//
//  RetriveViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RetriveViewController.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
@implementation RetriveViewController
@synthesize email,emailTextField = _emailTextField,errorString = _errorString;
@synthesize needSendMobile = _needSendMobile,needSendMobileButton = _needSendMobileButton;
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
    email = nil;
    _emailTextField = nil;
    _errorString = nil;
    _needSendMobileButton = nil;
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
    
    self.navigationItem.title = @"密码找回";
    UIImageView *retriveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 306, 105)];
    retriveImageView.image = [UIImage imageNamed:@"RetrivePWDBg.png"];
    [self.view addSubview:retriveImageView];
    //[retriveImageView release];
    NSLog(@"add imageView");
    //email输入框
    self.emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(75, 20, 228, 31)];
    self.emailTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg.png"]];
    self.emailTextField.placeholder = @"：";
    self.emailTextField.textAlignment = UITextAlignmentLeft;
    self.emailTextField.delegate = self;
    [self.view addSubview:self.emailTextField];
     //发送电话button
    self.needSendMobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.needSendMobileButton.frame = CGRectMake(50, 70, 31, 31);
    self.needSendMobile = 1;
    [self.needSendMobileButton setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
    //[loginButton1 setBackgroundImage:[UIImage imageNamed:@"loginNormal.png"] forState:UIControlStateNormal];
    //[loginButton1 setBackgroundImage:[UIImage imageNamed:@"loginPress.png"] forState:UIControlStateHighlighted];
    //[loginButton1 setTitle:@"发送" forState:UIControlStateNormal];
    //[loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.needSendMobileButton addTarget:self action:@selector(changeNeedSendMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.needSendMobileButton];
    //self.needSendMobileButton.imageView.image = [UIImage imageNamed:@"select_icon.png"];
    NSLog(@"add button");
    //发送电话label
    UILabel *sendPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 70, 223, 31)];
    sendPhoneLabel.text = @"同时发送短信到注册手机";
    sendPhoneLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sendPhoneLabel];
    [sendPhoneLabel release];
    //完成输入按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(5, 116, 140, 40);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginNormal.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginPress.png"] forState:UIControlStateHighlighted];
    [loginButton setTitle:@"发送" forState:UIControlStateNormal];
    //[loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(sendRetriveEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}
-(void)changeNeedSendMobile
{
    if(self.needSendMobile == 1)
    {
        self.needSendMobile = 0;
        //self.needSendMobileButton.imageView.image = [UIImage imageNamed:@"unselect_icon.png"];
        [self.needSendMobileButton setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
        return ;
    }
    self.needSendMobile = 1;
    //self.needSendMobileButton.imageView.image = [UIImage imageNamed:@"select_icon.png"];
    [self.needSendMobileButton setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
    return ;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.email = textField.text;
    return YES;
}
-(void)sendRetriveEmail
{
    self.email = self.emailTextField.text;
    if ((self.email.length<=1)||((self.email.length>=1)&& (NSNotFound == [self.email rangeOfString:@"@"].location )) )
    {
        NSLog(@"not have @");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"密码格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        NSLog(@"retrive:self.email = %@",self.email);
        NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/forgetpwd.aspx?email=%@&uticket=xxxxxxxxxxxxxxxxxxxxx&needSendMobile=%d",self.email,self.needSendMobile];
        EncryptURL *encryption = [[EncryptURL alloc]init];
        NSString *urlStr = [encryption getMD5String:urls];
        [encryption release];
        NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:encodeUrlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"receivedString = %@",receivedString);
        
        //receivedString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"receivedString = %@",receivedString);
        if([self parseReceivedString:receivedString])
        {
           NSLog(@"retrive success");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发送成功" message:@"请登录邮箱完成密码找回操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            NSLog(@"retrive failed");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发送失败" message:[NSString stringWithFormat:@"%@" ,self.errorString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }

    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)parseReceivedString:(NSString *)string
{
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:string options:0 error:&error];
    
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

    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
