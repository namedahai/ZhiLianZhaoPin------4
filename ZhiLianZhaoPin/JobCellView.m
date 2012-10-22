//
//  MyResumeView.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-9-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JobCellView.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
#import "CreatJobSearchViewController.h"
#import "PromptView.h"
@implementation JobCellView
@synthesize viewCountButton = _viewCountButton;
@synthesize titeLabel = _titleLabel,label3;
@synthesize useResume = _useResume;
@synthesize refreshButton = _refreshButton;
@synthesize receiveData = _receiveData,subscribeData = _subscribeData;
@synthesize jobDelegate = _jobDelegate;
@synthesize alertId;
@synthesize subscribeConnection = _subscribeConnection;
- (void)dealloc {
    [_viewCountButton release];
    _viewCountButton = nil;
    [_titleLabel release];
    _titleLabel = nil;
    [_useResume release];
    _useResume = nil;
    [_refreshButton release];
    _refreshButton = nil;
    [super dealloc];
}

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
        [self.viewCountButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.viewCountButton setBackgroundColor:[UIColor clearColor]];
        [self.viewCountButton setTitle:@"0" forState:UIControlStateNormal];
        [self.viewCountButton addTarget:self action:@selector(viewCountButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.viewCountButton];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, 110, 32)];
        label1.backgroundColor = clearColor;
        label1.textAlignment = UITextAlignmentCenter;
        label1.text = @"最新职位";
        label1.backgroundColor = clearColor;
        [self addSubview:label1];
        [label1 release];
       
        //第二列
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refreshButton.frame = CGRectMake(131, 0, 32, 32);
        self.refreshButton.backgroundColor = clearColor;
        [self.refreshButton setImage:[UIImage imageNamed:@"job_record_disable.png"] forState:UIControlStateNormal];
        [self.refreshButton setImage:[UIImage imageNamed:@"job_record.png"] forState:UIControlStateHighlighted];
        [self.refreshButton addTarget:self action:@selector(postRefreshNotification:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.refreshButton];
    
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(111, 33, 74, 32)];
        label2.backgroundColor = clearColor;
        label2.textAlignment = UITextAlignmentCenter;
        label2.text = @"修改";
        label2.backgroundColor = clearColor;
        [self addSubview:label2];
        [label2 release];
        
        //第三列订阅
        self.useResume = [SubscribeButton buttonWithType:UIButtonTypeCustom];
        self.useResume.frame = CGRectMake(230, 5, 32, 25);
        [self.useResume addTarget:self action:@selector(changeUseResume) forControlEvents:UIControlEventTouchUpInside];
        self.useResume.delegate = self;
        self.useResume.contents = [NSArray arrayWithObjects:@"不订阅",@"订阅一天",@"订阅三天",@"订阅七天", nil];
        [self.useResume setBackgroundImage:[UIImage imageNamed:@"unreader_flag.png"] forState:UIControlStateNormal];
        [self addSubview:self.useResume];
        
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(186, 33, 120, 32)];
        label3.textAlignment = UITextAlignmentCenter;
        label3.text = @"订阅三天";
        label3.backgroundColor = clearColor;
        [self addSubview:label3];

    }
    return self;
}

-(void)viewCountButtonTapped:(UIButton *)todayBtn//第一个Btn；
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    NSString *ut = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self viewNewJob:todayBtn.tag :ut];
}
-(void)viewNewJob:(int)alert_id:(NSString *)uticket//查看最新职位
{//不订阅",@"订阅一天",@"订阅三天",@"订阅七天
    NSString *str;
    if ([label3.text isEqualToString:@"订阅一天"]==YES) {
        label3.tag = 1;
        str = @"1";
    }
    if ([label3.text isEqualToString:@"订阅三天"]==YES) {
        label3.tag = 3;
        str = @"3";
    }
    if ([label3.text isEqualToString:@"订阅七天"]==YES) {
        label3.tag = 7;
        str = @"7";
    }
    if ([label3.text isEqualToString:@"不订阅"]==YES) {
        label3.tag = 0;
        str = @"";
    }
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/searchjobs.aspx?Alert_id=%d&Pagesize=30&page=1&Publishdate=%@&Uticket=%@",alert_id,str,uticket];
    EncryptURL *encryptUrl = [[EncryptURL alloc]init];
    NSString *urlStr = [encryptUrl getMD5String:urls];
    [encryptUrl release];
   // NSURL *url = [NSURL URLWithString:urlStr];
    //在这里传给吴宇星URL;
    
    
}
-(void)setContent:(NSString *)str
{
    self.label3.text = str;
}
-(void)setInterval
{
    //http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher_set_interval.aspx?alert_id=617599&send_internal=1&uticket=xxxxxxxx
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    NSString *uticket = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *str;//记录订阅频率;
    if ([label3.text isEqualToString:@"订阅一天"]==YES) {
        label3.tag = 1;
        str = @"1";
    }
    if ([label3.text isEqualToString:@"订阅三天"]==YES) {
        label3.tag = 3;
        str = @"3";
    }
    if ([label3.text isEqualToString:@"订阅七天"]==YES) {
        label3.tag = 7;
        str = @"7";
    }
    if ([label3.text isEqualToString:@"不订阅"]==YES) {
        label3.tag = 0;
        str = @"-1";
    }
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher_set_interval.aspx?alert_id=%d&send_interval=%@&uticket=%@",self.alertId,str,uticket];
    EncryptURL *encryption = [[EncryptURL alloc]init];
    NSString *urlStr = [encryption getMD5String:urls];
    [encryption release];
    NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    self.subscribeConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}
-(void)changeUseResume
{
    [self.useResume becomeFirstResponder];
}
//Get服务器的代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if(connection == self.subscribeConnection)
    {
        self.subscribeData = [NSMutableData data];
        return;
    }
    self.receiveData = [NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection == self.subscribeConnection)
    {
        [self.subscribeData appendData:data];
        return;
    }
    [self.receiveData appendData:data];//拼接多次
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@",[error localizedDescription]);
    UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"错误" message:[error localizedDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alart show];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{   
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    if(connection == self.subscribeConnection)
    {
        NSString *receiveStr = [[NSString alloc]initWithData:self.subscribeData encoding:NSUTF8StringEncoding];
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:receiveStr options:0 error:nil];
        [receiveStr release];
        GDataXMLElement *root = [document rootElement];
        GDataXMLElement *result = [[root children] objectAtIndex:0];
      NSString * promptLabelText = @"";
        if ([[result stringValue] isEqualToString:@"1"]) 
        {
            promptLabelText = @"订阅成功";
        }
        else
        {
            promptLabelText = @"订阅失败";
        }
        PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15, 100, 260, 80) Result:nil PromtLabelText:promptLabelText];
        [self.window addSubview:promptView];
        [promptView release];
        return;
    }
        NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:receiveStr options:0 error:nil];
        [receiveStr release];
        GDataXMLElement *root = [document rootElement];
        NSArray *children = [root children];
        GDataXMLElement *alert = [children objectAtIndex:1];
        NSMutableArray *informationArray = [[NSMutableArray alloc]init];
        for (GDataXMLElement *alertData in [alert children]) {
            [informationArray addObject:[alertData stringValue]];
        }
        [self.jobDelegate changeInformation:informationArray];
        [informationArray release];
   
}
//服务器方法
-(void)ObtainPositionInformation:(NSString *)ut:(int)a
{
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/getjobsearcherinfo.aspx?alert_id=%d&uticket=%@",a,ut];
    EncryptURL *encryptUrl = [[EncryptURL alloc]init];
    NSString *urlStr = [encryptUrl getMD5String:urls];
    [encryptUrl release];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
    [connection release];
}


-(void)postRefreshNotification:(UIButton *)btn//推进去修改
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    //NSLog(@"filePath = %@",filePath);
    NSString *ut = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self ObtainPositionInformation: ut:btn.tag];
}


@end
