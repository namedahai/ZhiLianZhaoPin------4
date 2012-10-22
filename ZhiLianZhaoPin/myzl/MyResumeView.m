//
//  MyResumeView.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-9-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyResumeView.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
@implementation MyResumeView
@synthesize viewCountButton = _viewCountButton;
@synthesize titeLabel = _titleLabel;
@synthesize useResume = _useResume;
@synthesize refreshButton = _refreshButton;
@synthesize resume,uticket,errorString;
@synthesize delegate,myResumeViewNumber;
//默认简历只能设置一份，确认设置该简历为默认简历吗？
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         UIColor *clearColor  = [UIColor clearColor];
        //背景颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"resume_page_bg.png"]];
        //第一列
        self.viewCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.viewCountButton.frame = CGRectMake(0, 0, 110, 32);
        [self.viewCountButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.viewCountButton setBackgroundColor:[UIColor clearColor]];
        [self.viewCountButton addTarget:self action:@selector(viewCountButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.viewCountButton];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 110, 32)];
        label1.backgroundColor = clearColor;
        label1.textAlignment = UITextAlignmentCenter;
        label1.text = @"浏览";
        //[label1 setFont:font];
        label1.backgroundColor = clearColor;
        [self addSubview:label1];
        [label1 release];
       
        //第二列
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refreshButton.frame = CGRectMake(131, 0, 32, 32);
        self.refreshButton.backgroundColor = clearColor;

        UIImageView *refreshImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reresh_resume_button.png"]highlightedImage:[UIImage imageNamed:@"reresh_resume_button_press.png"]];
        refreshImage.frame = CGRectMake(5, 10, 25, 25);
        [self.refreshButton addSubview:refreshImage];
        [refreshImage release];
        [self.refreshButton addTarget:self action:@selector(postRefreshNotification) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.refreshButton];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(111, 33, 74, 32)];
        label2.backgroundColor = clearColor;
        label2.textAlignment = UITextAlignmentCenter;
        label2.text = @"刷新";
        
        label2.backgroundColor = clearColor;
        [self addSubview:label2];
        [label2 release];
        
        //第三列
        self.useResume = [UIButton buttonWithType:UIButtonTypeCustom];
        self.useResume.frame = CGRectMake(230, 5, 28, 28);
        [self.useResume addTarget:self action:@selector(changeUseResume) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.useResume];
        
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(186, 33, 120, 32)];
        label3.textAlignment = UITextAlignmentCenter;
        label3.text = @"设置默认简历";
        label3.backgroundColor = clearColor;
        [self addSubview:label3];

    }
    return self;
}
-(void)dealloc
{
    _titleLabel = nil;
    _viewCountButton = nil;
    _useResume = nil;
    _refreshButton = nil;
    resume = nil;
    uticket = nil;
    errorString = nil;
    [super dealloc];
}
-(void)viewCountButtonTapped
{
    CompanyList_ShowResumeViewController *companyListView = [[CompanyList_ShowResumeViewController alloc]init];
    companyListView.resume = self.resume;
    companyListView.uticket = self.uticket;
    companyListView.needLoadDataFlag = YES;
    [self.delegate pushCompanyListView:companyListView];
}
-(void)refresh
{
    [self.viewCountButton setTitle:self.resume.show_count forState:UIControlStateNormal];
    if(self.resume.isdefaultflag)
    {
        [self.useResume setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.useResume setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    }
}
-(void)changeUseResume
{
    if(self.resume.isdefaultflag)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"取消该简历为默认简历？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"设置该简历为默认简历？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/setdefaultresume.aspx?resume_id=%@&resume_number=%@&version_number=%@&uticket=%@",self.resume.resume_id,self.resume.resume_number,self.resume.version_number,self.uticket];
        EncryptURL *encryption = [[EncryptURL alloc]init];
        NSString *urlStr = [encryption getMD5String:urls];
        [encryption release];
        NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"设置默认简历：urlString = %@",encodeUrlStr);
        NSURL *url = [NSURL URLWithString:encodeUrlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"receivedString = %@",receivedString);
        
        int parseResult = [self parseReceivedString:receivedString];
        if(parseResult == 1)
        {
            NSLog(@"resume success");
            if(self.resume.isdefaultflag)
            {
                self.resume.isdefaultflag = NO;
                [self.useResume setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
                NSLog(@"change to unselect_icon");
            }
            else
            {
                self.resume.isdefaultflag = YES;
                [self.useResume setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
                NSLog(@"change to select_icon.png");
                [self.delegate changeDefaultResume:self.myResumeViewNumber];
            }

        }
        else if(parseResult == 5)
        {
            NSLog(@"uticket过期，需重新登陆");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"设置失败" message:@"请重新登陆"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"设置失败" message:[NSString stringWithFormat:@"%@" ,self.errorString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];

        }
    }
}
-(int)parseReceivedString:(NSString *)string
{
    
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:string options:0 error:&error];
    
    //<root>
    GDataXMLElement *root = [document rootElement];
    //<result>
    GDataXMLNode *result = [root childAtIndex:0];
    int resultValue = [[result stringValue] intValue];
    if(resultValue == 1)
    {
        return 1; 
    }
    else if(resultValue == 5)
    {
        return 5;
    }
    GDataXMLNode *message = [root childAtIndex:1];
    self.errorString = [message stringValue];
    return 0;

}
-(void)postRefreshNotification
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"refreshResume" object:nil];
    //Get 参数修改，由原来的resume_id,uticket改为resume_number,reume_version,uticket
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphon/myzhaopin/resume_refresh.aspx?resume_number=%@&version_number=%@&uticket=%@",self.resume.resume_number,self.resume.version_number,self.uticket];
   // NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphon/myzhaopin/resume_refresh.aspx?resume_id=%@&version_number=%@&uticket=%@",self.resume.resume_id,self.resume.version_number,self.uticket];
    //NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphon/myzhaopin/resume_refresh.aspx?resume_id=%@&uticket=%@&resume_number=%@&version_number=%@",self.resume.resume_id,self.uticket,self.resume.resume_number,self.resume.version_number];
    EncryptURL *encryption = [[EncryptURL alloc]init];
    NSString *urlStr = [encryption getMD5String:urls];
    [encryption release];
    NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"刷新简历：urlString = %@",encodeUrlStr);
    NSURL *url = [NSURL URLWithString:encodeUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"receivedString = %@",receivedString);
    
    //receivedString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"receivedString = %@",receivedString);
    int parseResult = [self parseReceivedString:receivedString];
    if(parseResult == 1)
    {
        NSLog(@"刷新 success");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"刷新成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(parseResult == 5)
    {
        NSLog(@"uticket过期，需重新登陆");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"刷新失败" message:@"请重新登陆"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"刷新失败" message:[NSString stringWithFormat:@"%@" ,self.errorString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }

}

@end
