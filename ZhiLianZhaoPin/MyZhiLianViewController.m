//
//  MyZhiLianViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyZhiLianViewController.h"
#import "Resume.h"
#import "JobSearchViewController.h"
@implementation MyZhiLianViewController
@synthesize isLogin;
@synthesize tableView = _tableView;
@synthesize userInfoDic = _userInfoDic;
@synthesize uticket,helloLabel = _helloLabel;
@synthesize resumeScrollView = _resumeScrollView,pageControl = _pageControl;
@synthesize defualtResumeViewNumber;
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
    _tableView = nil;
    _userInfoDic = nil;
    uticket = nil;
    _resumeScrollView = nil;
    _helloLabel = nil;
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
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)]autorelease];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //导航栏标题
    self.navigationItem.title = @"我的智联";
    //返回登录按钮隐藏
    [self.navigationItem setHidesBackButton:YES];

    //导航栏登录按钮
    UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    //[logoutBarButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    
   
    self.uticket = [self.userInfoDic valueForKey:@"uticket"];
   
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    NSLog(@"filePath = %@",filePath);
    [self.uticket writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *uticketFromFile = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"uticketFromFile = %@",uticketFromFile);
    //我的简历（resume）view
    
    NSMutableArray *resumeArray = [self.userInfoDic valueForKey:@"resumelist"];
    if(resumeArray)
    {
    int resumeCount = [resumeArray count];
    self.resumeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 60, 308, 66)];
    self.resumeScrollView.contentSize = CGSizeMake(308*resumeCount, 66);
        self.resumeScrollView.delegate = self;
    self.resumeScrollView.pagingEnabled = YES;
    self.resumeScrollView.showsHorizontalScrollIndicator = NO;
    //self.resumeScrollView.scrollEnabled = NO;
    [self.view addSubview:self.resumeScrollView];
    for(int i=0;i<resumeCount;i++)
    {
        MyResumeView *myResumeView = [[MyResumeView alloc]initWithFrame:CGRectMake(308*i, 0, 308, 66)];
        Resume *resume = [resumeArray objectAtIndex:i];
        NSLog(@"get from resume array:resume = %@",resume);
        myResumeView.resume = resume;
        myResumeView.uticket = self.uticket;
        myResumeView.myResumeViewNumber = i;
        myResumeView.delegate = self;
        myResumeView.tag = 100+i;
        [myResumeView refresh];
        [self.resumeScrollView addSubview:myResumeView];
        [myResumeView release];
    }
    //页面控制
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 135, 320, 30)];
    self.pageControl.numberOfPages = resumeCount;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(changeResumeViewOffset:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];

    //您好！ 标签
    self.helloLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 300, 50)];
    self.helloLabel.numberOfLines = 2;
    self.helloLabel.backgroundColor = [UIColor clearColor];
    self.helloLabel.textAlignment = UITextAlignmentCenter;
    self.helloLabel.text = ((Resume *)[resumeArray objectAtIndex:0]).resume_name;
    [self.view addSubview:self.helloLabel];
    }
    else
    {
        self.helloLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 300, 50)];
        self.helloLabel.numberOfLines = 2;
        self.helloLabel.backgroundColor = [UIColor clearColor];
        self.helloLabel.textAlignment = UITextAlignmentCenter;
        self.helloLabel.text = @"您还没有设置简历";
        [self.view addSubview:self.helloLabel];

    }
    //tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, 320, 170) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    int offset = self.resumeScrollView.contentOffset.x;
    self.pageControl.currentPage = offset/308;
    NSMutableArray *resumeArray = [self.userInfoDic valueForKey:@"resumelist"];
    self.helloLabel.text = ((Resume *)[resumeArray objectAtIndex:self.pageControl.currentPage]).resume_name;
}
-(void)changeResumeViewOffset:(UIPageControl *)pageControl
{
    int x_offset = pageControl.currentPage * 308;
    [self.resumeScrollView setContentOffset:CGPointMake(x_offset, 0) animated:YES];
    NSMutableArray *resumeArray = [self.userInfoDic valueForKey:@"resumelist"];
    self.helloLabel.text = ((Resume *)[resumeArray objectAtIndex:pageControl.currentPage]).resume_name;
}
-(void)logout
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
       
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"user.txt"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    [fileManage removeItemAtPath:filePath error:nil];
    NSString *uticketPath = [documentPath stringByAppendingFormat:@"uticket.txt"];
    [fileManage removeItemAtPath:uticketPath error:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 
#pragma UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
#pragma mark - 
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"unreader.png"];
        cell.textLabel.text = @"未读人事来信";
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(238, 1,40, 35)];
        numberLabel.text = [self.userInfoDic valueForKey:@"no_read_hr_email_count"];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor orangeColor];
        numberLabel.textAlignment = UITextAlignmentRight;
        //numberLabel.textColor = [UIColor greenColor];
        [cell.contentView addSubview:numberLabel];
        [numberLabel release];
    }
    
    else if(indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"job_record.png"];
        cell.textLabel.text = @"职位申请记录";
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(238, 1, 40, 35)];
        numberLabel.textAlignment = UITextAlignmentRight;
        numberLabel.textColor = [UIColor orangeColor];
        numberLabel.text = [self.userInfoDic valueForKey:@"apply_count"];
       // numberLabel.textColor = [UIColor greenColor];
        numberLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:numberLabel];
        [numberLabel release];
    }
    
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"职位收藏夹";
        cell.imageView.image = [UIImage imageNamed:@"favorite.png"];
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(238, 1, 40, 35)];
        numberLabel.textAlignment = UITextAlignmentRight;
        numberLabel.textColor = [UIColor orangeColor];
        numberLabel.text = [self.userInfoDic valueForKey:@"fav_count"];
       // numberLabel.textColor = [UIColor greenColor];
        numberLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:numberLabel];
        [numberLabel release];
    }
    
    else 
    {
        cell.imageView.image = [UIImage imageNamed:@"searchSubscribeViewController.png"];
        cell.textLabel.text = @"搜索与订阅";
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(238, 1, 40, 35)];
        numberLabel.text = [self.userInfoDic valueForKey:@"job_searcher_count"];
        numberLabel.textAlignment = UITextAlignmentRight;
        NSLog(@"job_searcher_count = %@",[self.userInfoDic valueForKey:@"job_searcher_count"]);
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor orangeColor];
        //numberLabel.textColor = [UIColor greenColor];
        [cell.contentView addSubview:numberLabel];
        [numberLabel release];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessoryArrow.png"]];
    //accessoryView.frame = CGRectMake(0, 0, 10, 15);
    cell.accessoryView = accessoryView;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)//进入职位搜索器
    {
        JobSearchViewController *jobSearch = [[JobSearchViewController alloc]init];
        [self.navigationController pushViewController:jobSearch animated:YES];
        [jobSearch release];
    }

}
#pragma mark - changeDefaultResumeDelegate
-(void)changeDefaultResume:(int)myResumeViewNumber
{
    if(self.defualtResumeViewNumber != -1 && self.defualtResumeViewNumber != myResumeViewNumber)
    {
        MyResumeView *myResumeView = (MyResumeView *)[self.resumeScrollView viewWithTag:(100+self.defualtResumeViewNumber)];
        myResumeView.resume.isdefaultflag = NO;
        [myResumeView.useResume setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    }
    self.defualtResumeViewNumber = myResumeViewNumber;
}
-(void)pushCompanyListView:(CompanyList_ShowResumeViewController *)companyListView
{
    [self.navigationController pushViewController:companyListView animated:YES];
    
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
