//
//  CompanyDetailViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
@implementation CompanyDetailViewController
@synthesize company = _company,textView,errorString,companyLabel = _companyLabel;
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
    [_company release];
    _company = nil;
    [textView release];
    textView = nil;
    [errorString release];
    errorString = nil;
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
    UIScrollView *rootView = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)]autorelease];
    rootView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
    self.view = rootView;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    self.companyLabel.backgroundColor = [UIColor clearColor];
    self.companyLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:self.companyLabel];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
    self.textView.userInteractionEnabled = NO;
    [self.view addSubview:self.textView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/company/showcompanydetail.aspx?company_number=%@",self.company.company_number];
    EncryptURL *encryption = [[EncryptURL alloc]init];
    NSString *urlStr = [encryption getMD5String:urls];
    [encryption release];
    NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"companydetail：urlString = %@",encodeUrlStr);
   
    NSURL *url = [NSURL URLWithString:encodeUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"receivedString = %@",receivedString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(![self parseReceivedString:receivedString])
    {
        self.textView.text = self.errorString;
    }
}


-(BOOL) parseReceivedString:(NSString *)string//解析数据，得到公司和工作数据
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
        //    <root>
        //    <result>1</result>
        //    <company>
        //    <company_number>CC229503220</company_number>0
        //    <company_name><![CDATA[丹阳市翔宇电子厂]]></company_name>1
        //    <company_size>20人以下</company_size>2
        //    <company_property><![CDATA[国企]]></company_property>3
        //    <industry><![CDATA[农/林/牧/渔]]></industry>4
        //    <address><![CDATA[江苏省丹阳市访仙镇]]></address>5
        //    <company_desc><![CDATA[]]></company_desc>6
        //    </company>
        //    <joblist />
        //    </root>
        GDataXMLElement *companyElement = [[root elementsForName:@"company"]objectAtIndex:0];
        GDataXMLNode *company_name = [companyElement childAtIndex:1];
        NSString *company_name_string = [company_name stringValue];
        self.companyLabel.text = company_name_string;
        
        GDataXMLNode *company_size = [companyElement childAtIndex:2];
        NSString *company_size_string = [company_size stringValue];
        
        GDataXMLNode *company_property = [companyElement childAtIndex:3];
        NSString *company_property_string = [company_property stringValue];
        
        GDataXMLNode *industry = [companyElement childAtIndex:4];
        NSString *industry_string = [industry stringValue];
        
        GDataXMLNode *address = [companyElement childAtIndex:5];
        NSString *address_string = [address stringValue];
        
        GDataXMLNode *company_desc = [companyElement childAtIndex:6];
        NSString *company_desc_string = [company_desc stringValue];
        
        self.textView.text =[NSString stringWithFormat:@" 类别:%@\n 规模:%@\n 行业:%@\n 地址:%@\n 公司介绍\n  %@",company_property_string,company_size_string,industry_string,address_string,company_desc_string];
                               
        return YES;
    }
    GDataXMLNode *message = [root childAtIndex:1];
    self.errorString = [message stringValue];

    return NO;
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
