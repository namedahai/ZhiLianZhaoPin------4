//
//  RegisterViewController.m
//  ZhiLianZhaoPin
//
//  Created by Tiamo on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "GDataXMLNode.h"
#import "MyZhiLianViewController.h"
#import "EncryptURL.h"

@implementation RegisterViewController
@synthesize telephoneTF=_telephoneTF,emailTF=_emailTF,passwordTF=_passwordTF,verifypasswordTF=_verifypasswordTF,registerview=_registerview,password=_password,email=_email,telephone=_telephone,registerInfoDictionary=_registerInfoDictionary,errString=_errString;
//
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//+ BOOL NSStringIsValidEmail(NSString *checkString)    
//{    
//    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+//.[A-Za-z]{2,4}";    
//    NSString *laxString = @".+@.+/.[A-Za-z]{2}[A-Za-z]*";    
//    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;    
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];    
//    return [emailTest evaluateWithObject:checkString];    
//}   
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        // Custom initialization
    }
    return self;
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
   
    UIView *aview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
//    [aview addTarget:self action:@selector(doTap) forControlEvents:UIControlEventTouchUpInside];
//    aview.backgroundColor=[UIColor whiteColor];
    self.view=aview;
    [self.view addGestureRecognizer:tap];
    
    [aview release];
    _registerview=[[[UIView alloc]initWithFrame:CGRectMake(5, 10, 307, 210)]autorelease];
    _registerview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"registerBg.png"]];
    [aview addSubview:_registerview];

    
}
//空白键盘回收
- (void)doTap
{
    NSLog(@"a");
    for (UIView *view in _registerview.subviews) {
        if ([view isFirstResponder]) {
            NSLog(@"b");
            [view resignFirstResponder];
            
            _password=_passwordTF.text; 
            _email=_emailTF.text;
            if([self validateEmail:_email]==NO)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"邮箱格式错误" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil    ];
                [alertView show];
                [alertView release];
            };
            
            _telephone=((UITextField*)view).text;
            [UIView beginAnimations:@"down" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.view.frame=CGRectMake(0, 0, 320, 416);
            [UIView commitAnimations];
            
        }
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    [super viewDidLoad];
    //注册
    self.navigationItem.title=@"新用户注册";
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(registernew)];
    right.tintColor=[UIColor redColor];
    
    self.navigationItem.rightBarButtonItem=right;
    [right release];
    //注册引导
    self.emailTF=[[[UITextField alloc]initWithFrame:CGRectMake(90, 15, 220, 25)]autorelease];
    self.emailTF.backgroundColor=[UIColor clearColor];
    self.emailTF.textAlignment=UITextAlignmentLeft;
    self.emailTF.delegate=self;
    self.emailTF.placeholder=@"请输入邮箱";
    self.emailTF.adjustsFontSizeToFitWidth=YES;
    self.emailTF.keyboardType=UIKeyboardTypeEmailAddress;
    [_registerview addSubview:self.emailTF];
    
    self.telephoneTF=[[[UITextField alloc]initWithFrame:CGRectMake(90, 70, 220, 25)]autorelease];
    self.telephoneTF.backgroundColor=[UIColor clearColor];
    self.telephoneTF.textAlignment=UITextAlignmentLeft;
    self.telephoneTF.delegate=self;
    self.telephoneTF.placeholder=@"请输入电话号码";
    self.telephoneTF.adjustsFontSizeToFitWidth=YES;
    self.telephoneTF.keyboardType=UIKeyboardTypeNumberPad;
    [_registerview addSubview:self.telephoneTF];
    
    self.passwordTF=[[[UITextField alloc]initWithFrame:CGRectMake(90, 123, 220, 25)]autorelease];
    self.passwordTF.backgroundColor=[UIColor clearColor];
    self.passwordTF.textAlignment=UITextAlignmentLeft;
    self.passwordTF.delegate=self;
    self.passwordTF.placeholder=@"请输入密码";
    self.passwordTF.adjustsFontSizeToFitWidth=YES;
    self.passwordTF.secureTextEntry=YES;
    [_registerview addSubview:self.passwordTF];
    
    self.verifypasswordTF=[[[UITextField alloc]initWithFrame:CGRectMake(90, 177, 220, 25)]autorelease];
    self.verifypasswordTF.backgroundColor=[UIColor clearColor];
    self.verifypasswordTF.textAlignment=UITextAlignmentLeft;
    self.verifypasswordTF.delegate=self;
    self.verifypasswordTF.placeholder=@"请确认密码";
    self.verifypasswordTF.adjustsFontSizeToFitWidth=YES;
    self.verifypasswordTF.secureTextEntry=YES;
    [_registerview addSubview:self.verifypasswordTF];
    
    
}
//注册按钮功能
- (void)registernew
{
    if (![_passwordTF.text isEqualToString:_verifypasswordTF.text]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"两次输入的不一致" message:@"重新确认" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        
    }else{
        NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/register.aspx?email=%@&password=%@&mobile=%@&",self.email,self.password,self.telephone];
        //        NSLog(@"%@",urls);
        EncryptURL *encryPtion=[[EncryptURL alloc]init];
        NSString *urlStr=[encryPtion getMD5String:urls];
       // NSLog(@"%@",urlStr);
       
        NSString *encodeUrlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      //  NSLog(@"encodeurlstr=%@",encodeUrlStr);
        NSURL *url=[NSURL URLWithString:encodeUrlStr];
        
//    NSString *urlstr=[NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/register.aspx?email=%@&password=%@&mobile=%@&t=1349666653.678475&e=E51A68E3777E8AD64837247800F77ABF&t=1349749567.163675&e=3A99B9D0CD2D4673D740CBF885BFEB7A&f=p&d=BC44E63B-5749-5DCD-9EA2-352957B5B859",self.email,self.password,self.telephone];
//    NSString *encodeUrlStr=[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:encodeUrlStr];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSURLResponse *response=nil;
    NSError *err=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *receiveString=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"receiveString=%@",receiveString);
        if ([self parseReceivedString:receiveString]) 
        {
            MyZhiLianViewController *myZhiLian=[[MyZhiLianViewController alloc]init];
            myZhiLian.userInfoDic = self.registerInfoDictionary;
            [self.navigationController pushViewController:myZhiLian animated:YES];
            
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"邮箱已存在,请直接登录" message:[NSString stringWithFormat:@"%@",self.errString] delegate:nil cancelButtonTitle:@"登录" otherButtonTitles:@"忘记密码",nil ];
            [alertView show];
        }
        
    }
   
}
//键盘升起
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.passwordTF) {
        [UIView beginAnimations:@"up" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.view.frame=CGRectMake(0, -50, 320, 480);
        [UIView commitAnimations];
        
        
    }return YES;
    
}
//解析数据
-(BOOL)parseReceivedString:(NSString *)string
{
    NSError *err=nil;
    GDataXMLDocument *document=[[GDataXMLDocument alloc]initWithXMLString:string options:0 error:&err];
    self.registerInfoDictionary=[NSMutableDictionary dictionaryWithCapacity:10];
    GDataXMLElement *root=[document rootElement];
    GDataXMLNode *result=[root childAtIndex:0];
    int resultValue=[[result stringValue]intValue];
    if (resultValue == 0) {
        GDataXMLNode *message=[root childAtIndex:1];
        self.errString=[message stringValue];
       // NSLog(@"error 0");
        return NO;
        
    }
    GDataXMLNode *uticket=[root childAtIndex:1];
    NSString *uticketString = [uticket stringValue];
    [self.registerInfoDictionary setValue:uticketString forKey:@"uticket"];
   // GDataXMLElement *resumelist=[[root children]objectAtIndex:2];
    
    return YES;
    
}
//普通键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:_emailTF.text]) {
        [_emailTF resignFirstResponder];
        [_telephoneTF becomeFirstResponder];
        if([self validateEmail:_email]==NO)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"邮箱格式错误" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil    ];
            [alertView show];
            [alertView release];
        };

    }else if([textField.text isEqualToString:_telephoneTF.text]){
        if (_telephoneTF.text.length != 11) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号长度有误" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
        [_telephoneTF resignFirstResponder];
        [_passwordTF becomeFirstResponder];
        
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
