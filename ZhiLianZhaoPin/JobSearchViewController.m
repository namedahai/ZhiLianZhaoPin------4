//
//  JobSearchViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JobSearchViewController.h"
#import "JobSearchViewCell.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
#import "PromptView.h"
@implementation JobSearchViewController
@synthesize jobTableView = _jobTableView;
@synthesize receiveData = _receiveData;
@synthesize dataInformation = _dataInformation;
@synthesize deleteConnection = _deleteConnection;
@synthesize deleteData = _deleteData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [_jobTableView release];
    _jobTableView = nil;
    [_dataInformation release];
    _dataInformation = nil;
    [_deleteConnection release];
    _deleteConnection = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//推进到创建职位搜索器
-(void)creatJobSearch
{
    CreatJobSearchViewController *creatJobSearchViewController = [[CreatJobSearchViewController alloc]init];
    creatJobSearchViewController.delegate = self;
    [self.navigationController pushViewController:creatJobSearchViewController animated:YES];
    [creatJobSearchViewController release];
}
-(void)ReloadJobData//刷新数据代理实现
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    //NSLog(@"filePath = %@",filePath);
    NSString *uticket = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self ObtainPositionInformation:uticket];
}
-(void)ObtainPositionInformation:(NSString *)ut//从网络获取职位信息，创建职位搜索器
{
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher.aspx?uticket=%@",ut];
    EncryptURL *encryptUrl = [[EncryptURL alloc]init];
    NSString *urlStr = [encryptUrl getMD5String:urls];
    [encryptUrl release];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
    [connection release];
}
-(void)deleteInformation:(NSString *)uticket:(NSString *)alert_id//删除职位搜索器
{
    NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher_del.aspx?alert_id=%@&uticket=%@",alert_id,uticket];
    EncryptURL *encryptUrl = [[EncryptURL alloc]init];
    NSString *urlStr = [encryptUrl getMD5String:urls];
    [encryptUrl release];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.deleteConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
}
//服务器开始返回数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (connection == self.deleteConnection) {
        self.deleteData = [NSMutableData data];
    }
    else
    {
        self.receiveData = [NSMutableData data];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == self.deleteConnection) 
    {
        [self.deleteData appendData:data];
    }
    else
    {
        [self.receiveData appendData:data];//拼接多次
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"错误" message:[error localizedDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [self.view addSubview:alart];
    [alart show];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    if (connection == self.deleteConnection)
    {
        NSString *receiveStr = [[NSString alloc]initWithData:self.deleteData encoding:NSUTF8StringEncoding];
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:receiveStr options:0 error:nil];
        [receiveStr release];
        GDataXMLElement *root = [document rootElement];
        GDataXMLElement *result = [[root children] objectAtIndex:0];
        GDataXMLElement *message = [[root children] objectAtIndex:1];
        PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15,100, 260, 80) Result:[result stringValue] PromtLabelText:[message stringValue]];
        [self.view.window addSubview:promptView];
        [promptView release];
    }
    else
    {
        NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",receiveStr);
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:receiveStr options:0 error:nil];
        [receiveStr release];
        GDataXMLElement *root = [document rootElement];
        NSArray *children = [root children];
        GDataXMLElement *result = [children objectAtIndex:0];
        NSString *promtLabelText = @"";
        if([[result stringValue] isEqualToString:@"1"] == YES)
        {
            promtLabelText = @"刷新搜索器成功";
        }
        else
        {
            promtLabelText = @"刷新搜索器失败";
        }
        PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15, 100, 260, 80) Result:nil PromtLabelText:promtLabelText];
        [self.view.window addSubview:promptView];
        [promptView release];
        GDataXMLElement *jobalertlist = [children objectAtIndex:1];
        [self.dataInformation removeAllObjects];
        for (GDataXMLElement *alert in [jobalertlist children]) {
            NSMutableArray *alertArray = [[NSMutableArray alloc]init];
            for (GDataXMLElement *alartInformation in [alert children]) 
            {
                [alertArray addObject:[alartInformation stringValue]];
            }
            [self.dataInformation addObject:alertArray];
            [alertArray release];
        }
        [self.jobTableView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //数组数据
    self.dataInformation = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
    self.navigationItem.title = @"搜索与订阅";
   self.editButtonItem.title = @"编辑";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editor:)];
    self.navigationItem.rightBarButtonItem = right;
    right.tag = 100;
    [right release];
    UIButton *creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    creatBtn.frame = CGRectMake(0, 0, 320, 44);
    [creatBtn setTitle:@"创建职位搜索器" forState:UIControlStateNormal];
    [creatBtn addTarget:self action:@selector(creatJobSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatBtn];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 4)];
    imageView.image = [UIImage imageNamed:@"searchHistoryUpLine.png"];
    [self.view addSubview:imageView];
    [imageView release];
    //调用服务器;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    //NSLog(@"filePath = %@",filePath);
    NSString *uticket = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [self ObtainPositionInformation:uticket];
    
    
    //现在开始创建tableView
    self.jobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, 317) style:UITableViewStyleGrouped];
    self.jobTableView.delegate = self;
    self.jobTableView.dataSource = self;
    self.jobTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.jobTableView];
    
}
-(void)editor:(UIBarButtonItem *)right//编辑
{    
    if(right.tag == 100)
    {
        [self.jobTableView setEditing:YES animated:YES];
        right.title = @"编辑";
        right.tag = 101;
    }
    else
    {
        [self.jobTableView setEditing:NO animated:YES];
        right.title = @"完成";
        right.tag = 100;
    }
}
//tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath//设置行高
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section//设置标题
{ 
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 30)]autorelease];
    view.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 20)];
    NSMutableArray *alertArray =[self.dataInformation objectAtIndex:section];
    headerLabel.text = [alertArray objectAtIndex:1];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:headerLabel];
    [headerLabel release];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section//标题的高度;
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//rows的数目
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//分区数
{
    return [self.dataInformation count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *creatCell = @"creatCell";
    JobSearchViewCell *cell = [self.jobTableView dequeueReusableCellWithIdentifier:creatCell];
    if (cell == nil) {
        cell = [[[JobSearchViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:creatCell]autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableArray *alertArray =[self.dataInformation objectAtIndex:indexPath.section];
    [cell.jobCellView.viewCountButton setTitle:[alertArray objectAtIndex:3] forState:UIControlStateNormal];
    cell.jobCellView.refreshButton.tag = [[alertArray objectAtIndex:0] intValue];
    cell.jobCellView.viewCountButton.tag = [[alertArray objectAtIndex:0] intValue];
    cell.jobCellView.alertId = [[alertArray objectAtIndex:0] intValue];

    
    if([[alertArray objectAtIndex:2] isEqualToString:@""] == NO)
    {
        switch ([[alertArray objectAtIndex:2] intValue]) {
            case 1:
                cell.jobCellView.label3.text = @"订阅一天";
                break;
            case 3:
                cell.jobCellView.label3.text = @"订阅三天";
                break;
            case 7:
                cell.jobCellView.label3.text = @"订阅七天";
                break;
            case -1:
               cell.jobCellView.label3.text = @"不订阅";
                break;
            default:
                break;
        }
    }
    cell.jobCellView.jobDelegate = self;
    return cell;

}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;//是删除，下面的是添加
}
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
         NSString *uticket = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];  
         [self deleteInformation:uticket:[[self.dataInformation objectAtIndex:indexPath.section] objectAtIndex:0]];//调用删除的方法
         [self.dataInformation removeObjectAtIndex:indexPath.section];
         [self.jobTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];//界面删除一行

 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
//代理的实现
-(void)changeInformation:(NSMutableArray *)informationArray
{
    CreatJobSearchViewController *creatJobSearchVC = [[CreatJobSearchViewController alloc]init];
    creatJobSearchVC.informationArray = informationArray;
    int i = 0;
    for (id a in creatJobSearchVC.informationArray) {
        
        NSLog(@"修改信息%d == %@",i,a);
        i++;
    }
    [creatJobSearchVC.creatTableView reloadData];
    [self.navigationController pushViewController:creatJobSearchVC animated:YES];
    [creatJobSearchVC release];  
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath//推进去的方法
//{
//    
//}
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
