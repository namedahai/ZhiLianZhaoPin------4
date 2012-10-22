//
//  CreatJobSearchViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreatJobSearchViewController.h"
#import "CreatJobSearchViewCell.h"
#import "FieldTableViewCell.h"
#import "SelectDataTableViewController.h"
#import "EncryptURL.h"
#import "JobSearchViewController.h"
#import "GDataXMLNode.h"
#import "AnalysisXMLData.h"
@implementation CreatJobSearchViewController
@synthesize creatTableView = _creatTableView,scrollView;
@synthesize receiveData = _receiveData;
@synthesize informationArray = _informationArray;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOpen = 0;
        searchConditionArray = [[NSMutableArray alloc]initWithObjects:@"选择职位:",@"请选择职位名称",@"选择行业:",@"请选择行业",@"选择地区:",@"请选择工作地点", nil];
        advancedArray = [[NSMutableArray alloc]initWithObjects:@"发布时间:",@"请选择发布时间",@"工作经验:",@"请选择工作经验",@"学历要求:",@"请选择学历要求",@"公司性质:",@"请选择公司性质",@"公司规模:",@"请选择公司规模",@"月薪范围:",@"请选择月薪范围", nil];
        timeArray = [[NSMutableArray alloc]initWithObjects:@"不限",@"今天",@"最近三天",@"最近一周",@"最近一个月", nil];
        salaryArray = [[NSMutableArray alloc]initWithObjects:@"1000元/月以下",@"1000-2000元/月",@"2001-4000元/月",@"4001-6000元/月",@"6001-8000元/月",@"8001-10000元/月",@"10001-15000元/月",@"15000-25000元/月",@"25000元/月以上",@"面议" ,nil];
        timeAndSalaryArray = [[NSMutableArray alloc]initWithObjects:@"请选择发布时间",@"请选择月薪范围",nil];
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [_creatTableView release];
    _creatTableView = nil;
    [searchConditionArray release];
    searchConditionArray = nil;
    [scrollView release];
    scrollView = nil;
    [boolUnselectDictionary release];
    boolUnselectDictionary = nil;
    [boolSecondUnselectDictionary release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(NSString *)backURL:(NSString *)uticket//取网址参数;
{
    NSString *dataURL = @"?";
    if (self.informationArray) //如果不是空，说明是修改;
    {
        NSString *alart_id = [self.informationArray objectAtIndex:0];
        dataURL = [dataURL stringByAppendingFormat:@"alert_id=%@&",alart_id];
    }
    for (int i = 0; i<3; i++) {
        switch (i) {
            case 0:
            {
                NSString *str0 = [searchConditionArray objectAtIndex:1];
                str0 = [str0 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                dataURL = [dataURL stringByAppendingFormat:@"Job_type=%@",str0];
            }
                break;
            case 1:
            {
                NSString *str1 = [searchConditionArray objectAtIndex:3];
                str1 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                dataURL = [dataURL stringByAppendingFormat:@"&Industry=%@",str1];
            }
                break;
            case 2:
            {
                NSString *str2 = [searchConditionArray objectAtIndex:5];
                str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                dataURL = [dataURL stringByAppendingFormat:@"&city=%@",str2];
            }
                break;
            default:
                break;
        }
    }
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:3 inSection:0];
    FieldTableViewCell *cell = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:path1];
    NSString *textStr = cell.secondTF.text;
    textStr = [textStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataURL = [dataURL stringByAppendingFormat:@"&key_word=%@",textStr];
    
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
    FieldTableViewCell *cell2 = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:path2];
    textStr = cell2.secondTF.text;
    textStr = [textStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataURL = [dataURL stringByAppendingFormat:@"&Searcher_name=%@",textStr];
    
    if ([[timeAndSalaryArray objectAtIndex:0] isEqualToString:@"请选择发布时间"]==NO) {
        NSString *str = [timeAndSalaryArray objectAtIndex:0];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dataURL = [dataURL stringByAppendingFormat:@"&data_refresh=%@",str];
    }
    
    NSMutableArray *OptionParameter = [[NSMutableArray alloc]initWithObjects:@"&workingexp=",@"&edu_level=",@"&companytype=",@"&companysize=",nil];
    NSMutableArray *OptionalArr = [[NSMutableArray alloc]initWithObjects:@"请选择工作经验",@"请选择学历要求",@"请选择公司性质",@"请选择公司规模", nil];
    for (int i = 0; i<4; i++) {
        if([[advancedArray objectAtIndex:i*2+3] isEqualToString:[OptionalArr objectAtIndex:i]] == NO)
        {
            NSString *str = [advancedArray objectAtIndex:i*2+3];
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            dataURL = [dataURL stringByAppendingFormat:@"%@%@",[OptionParameter objectAtIndex:i],str];
        }
    }
    //设置金额；；；
    uticket = [uticket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dataURL = [dataURL stringByAppendingFormat:@"&uticket=%@",uticket];
    [OptionParameter release];
    [OptionalArr release];
    return dataURL;
}
-(void)saveData//上传服务器
{
    NSMutableArray *requiredArr = [[NSMutableArray alloc]initWithObjects:@"请选择职位名称",@"请选择行业",@"请选择工作地点", nil];
    for (int i = 0; i<3; i++) {//检查必选项是否选完;
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        CreatJobSearchViewCell *cell = (CreatJobSearchViewCell *)[self.creatTableView cellForRowAtIndexPath:path];
        if ([requiredArr indexOfObject:cell.selectLabel.text] != NSNotFound) {
            UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"提示" message:cell.selectLabel.text delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alart show];
            [alart release];
            return;
        }
        
    }
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:3 inSection:0];
    FieldTableViewCell *cell1 = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:path1];
    if ([cell1.secondTF.text isEqualToString:@""] == YES) {
        UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入关键字" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alart show];
        [alart release];
        return;
    }
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:0 inSection:1];
    FieldTableViewCell *cell2 = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:path2];
    if([cell2.secondTF.text isEqualToString:@""] == YES)
    {
        UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入搜索器名称" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alart show];
        [alart release];
        return;
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"uticket.txt"];
    NSString *uticket = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *dataStr = [self backURL:uticket]; 
    NSString *urls ;
    if(self.informationArray)//这是判定创建还是修改
    {
        urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher_edit.aspx%@",dataStr];  
    }
    else
    {
        urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/jobsearcher_add.aspx%@",dataStr];
    }
    EncryptURL *encryption = [[EncryptURL alloc]init];
    NSString *urlStr = [encryption getMD5String:urls];
    [encryption release];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
    [requiredArr release];
    [connection release];
    
}
//服务器返回
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    self.receiveData = [NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];//拼接多次
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@",[error localizedDescription]);
    UIAlertView *alart = [[UIAlertView alloc]initWithTitle:@"错误" message:[error localizedDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [self.view addSubview:alart];
    [alart show];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:receiveStr options:0 error:nil];
    GDataXMLElement *root = [document rootElement];
    NSArray *children = [root children];
    GDataXMLElement *result = [children objectAtIndex:0];
    PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15,70, 260, 80)];
    if ([[[[result children] objectAtIndex:0] stringValue] isEqualToString:@"1"] == YES)
    {
        promptView.promptLabel.text = @"保存搜索器成功";
    }
    else
    {
        promptView.promptLabel.text = @"保存搜索器失败";
    }
    [self.view addSubview:promptView];
    [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        promptView.alpha = 0;
    } completion:^(BOOL finished) {
        [promptView removeFromSuperview];
        if ([[[[result children] objectAtIndex:0] stringValue] isEqualToString:@"1"] == YES) {
            [self.delegate ReloadJobData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [promptView release];
    [receiveStr release];
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    tfStr = @"";
    key_word = @"";
    boolUnselectDictionary = [[NSMutableDictionary alloc]init];
    boolSecondUnselectDictionary = [[NSMutableDictionary alloc]init];
    //修改数组的信息
    if (self.informationArray)
    {
        self.navigationItem.title = @"修改职位搜索器";
    }
    else
    {
        self.navigationItem.title = @"创建职位搜索器";
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(320, 367);
    [self.view addSubview:self.scrollView];
    self.creatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, 300) style:UITableViewStyleGrouped];
    self.creatTableView.delegate = self;
    self.creatTableView.dataSource = self;
    self.creatTableView.backgroundColor = [UIColor clearColor];
    self.creatTableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.creatTableView];
    //设置一个Label用于显示搜索条件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    label1.text = @"搜索条件";
    label1.textColor = [UIColor whiteColor];
    label1.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:label1];
    [label1 release];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(89,322, 142, 44);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"loginNormal.png"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"loginPress.png"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.scrollView addSubview:saveBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    if (self.informationArray) 
    {
        NSMutableArray *analyArray = [[NSMutableArray alloc]init];
        AnalysisXMLData *analysisXMLData = [[[AnalysisXMLData alloc]initWithArray:analyArray]autorelease];
        //行业
        tfStr = [self.informationArray objectAtIndex:1];
        key_word = [self.informationArray objectAtIndex:8];
        [searchConditionArray replaceObjectAtIndex:1 withObject:[self.informationArray objectAtIndex:3]];
        NSMutableArray *boolUnSelect = [analysisXMLData analysisJob:[self.informationArray objectAtIndex:3]];
        NSMutableArray *boolFirstUnSelect = [boolUnSelect objectAtIndex:0];
       NSMutableDictionary *boolSecondDic = [boolUnSelect objectAtIndex:1];
        [boolUnselectDictionary setObject:boolFirstUnSelect forKey:[NSNumber numberWithInt:0]];
        [boolSecondUnselectDictionary setObject:boolSecondDic forKey:[NSNumber numberWithInt:0]];
        [searchConditionArray replaceObjectAtIndex:3 withObject:[self.informationArray objectAtIndex:5]];
        NSMutableArray *boolFirstUnselect = [analysisXMLData analysisBusiness:[self.informationArray objectAtIndex:5]];
        [boolUnselectDictionary setObject:boolFirstUnselect forKey:[NSNumber numberWithInt:1]];
        [searchConditionArray replaceObjectAtIndex:5 withObject:[self.informationArray objectAtIndex:7]];
        if ([[self.informationArray objectAtIndex:9] isEqualToString:@""] == NO) {
            int i;
            switch ([[self.informationArray objectAtIndex:9] intValue]) {
                case 1:
                    i = 1;
                    break;
                case 3:
                    i=2;
                    break;
                case 7:
                    i=3;
                    break;
                case 30:
                    i=4;
                    break;
                default:
                    break;
            }
            
            [timeAndSalaryArray replaceObjectAtIndex:0 withObject:[timeArray objectAtIndex:i]];
        }
        if ([[self.informationArray objectAtIndex:13] isEqualToString:@""] == NO) {//工作经验
            [advancedArray replaceObjectAtIndex:3 withObject:[self.informationArray objectAtIndex:13]];
            NSMutableArray *boolexperienceUnselect = [analysisXMLData analysisMoreOption:5:[self.informationArray objectAtIndex:13]];
            [boolUnselectDictionary setObject:boolexperienceUnselect forKey:[NSNumber numberWithInt:5]];
        }   
        if ([[self.informationArray objectAtIndex:11] isEqualToString:@""] == NO)//学历要求
        {
            [advancedArray replaceObjectAtIndex:5 withObject:[self.informationArray objectAtIndex:11]];
            NSMutableArray *boolEduUnselect = [analysisXMLData analysisMoreOption:6:[self.informationArray objectAtIndex:11]];
            [boolUnselectDictionary setObject:boolEduUnselect forKey:[NSNumber numberWithInt:6]];
        }
        if ([[self.informationArray objectAtIndex:15] isEqualToString:@""] == NO) {//公司性质
            [advancedArray replaceObjectAtIndex:7 withObject:[self.informationArray objectAtIndex:15]];
            NSMutableArray *boolCategoryUnselect = [analysisXMLData analysisMoreOption:7:[self.informationArray objectAtIndex:15]];
            [boolUnselectDictionary setObject:boolCategoryUnselect forKey:[NSNumber numberWithInt:7]];
        }
        if ([[self.informationArray objectAtIndex:17] isEqualToString:@""] == NO) {
            [advancedArray replaceObjectAtIndex:9 withObject:[self.informationArray objectAtIndex:17]];
            NSMutableArray *boolSizeUnselect = [analysisXMLData analysisMoreOption:8:[self.informationArray objectAtIndex:17]];
            [boolUnselectDictionary setObject:boolSizeUnselect forKey:[NSNumber numberWithInt:8]];
        }
    }
}
//datasource中的内容
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//rows的数目
{   
    
    if(section ==0)
    {   
        if(isOpen == 0)
        {
            self.scrollView.contentSize = CGSizeMake(320, 367);
            saveBtn.frame = CGRectMake(89, 322, 142, 44);
            tableView.frame = CGRectMake(0, 20, 320, 300);
            return 5;
        }
        else
        {
            self.scrollView.contentSize = CGSizeMake(320, 367+44*6);
            tableView.frame = CGRectMake(0, 20, 320, 300+44*6);
            saveBtn.frame = CGRectMake(89, 322+44*6, 142, 44);
            return 11;
        }
    }
    else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//分区数
{
    
    //    advancedArray = [[NSMutableArray alloc]initWithObjects:@"发布时间:",@"请选择发布时间",@"工作经验:",@"请选择工作经验",@"学历要求:",@"请选择学历要求",@"公司性质:",@"请选择公司性质",@"公司规模:",@"请选择公司规模",@"月薪范围:",@"请选择月薪范围", nil];
    //    timeArray = [[NSMutableArray alloc]initWithObjects:@"不限",@"今天",@"最近三天",@"最近一周",@"最近一个月", nil];
    return 2;
}
//配置CELL；
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    FieldTableViewCell *cell = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell.secondTF != textField) {
        tfStr = textField.text;
    }
    else
    {
        key_word = textField.text;
    }
                                                      
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.tag = 200;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    static NSString *field = @"fieldCell";
    static NSString *creatCell = @"creatCell";
    if ((indexPath.section == 0&&indexPath.row == 3)||indexPath.section == 1) 
    {  
        
        FieldTableViewCell *fieldCell = [tableView dequeueReusableCellWithIdentifier:field];
        if (fieldCell == nil) {
            fieldCell = [[[FieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:field]autorelease];
        }
        if (indexPath.row == 0) {
            fieldCell.firstLabel.text = @"搜索器保存名称";
            fieldCell.secondTF.placeholder = @"输入名称";
            fieldCell.secondTF.text = tfStr;
            fieldCell.secondTF.tag = 100;
            fieldCell.secondTF.delegate = self;
            fieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 3) {
            
            fieldCell.firstLabel.text = @"关键字:";
            fieldCell.secondTF.placeholder = @"输入关键字";
            fieldCell.secondTF.text = key_word;
            fieldCell.secondTF.tag = 100;
            fieldCell.secondTF.delegate = self;
            fieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return fieldCell;
    }
    else if(((isOpen == YES)&&(indexPath.row == 4||indexPath.row == 9)) == 1)
    {
        
        PickTableViewCell *pickCell = [tableView dequeueReusableCellWithIdentifier:@"pick"];
        if(pickCell == nil)
        {
            pickCell = [[[PickTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pick"]autorelease];
        }
        pickCell.delegate = self;
        if(indexPath.row == 4)
        {
            pickCell.contents = timeArray;
            pickCell.label1.text = @"发布时间";
            pickCell.label2.text = [timeAndSalaryArray objectAtIndex:0];
        }
        if (indexPath.row == 9) 
        {
            pickCell.contents = salaryArray;
            pickCell.label1.text = @"月薪范围";
            pickCell.label2.text = [timeAndSalaryArray objectAtIndex:1];
        }
        if ([pickCell.label2.text hasPrefix:@"请"] == NO) {
            pickCell.label2.textColor = [UIColor blackColor];
        }
        pickCell.cellImageView.image = [UIImage imageNamed:@"combox.png"];
        pickCell.cellImageView.frame = CGRectMake(280, 15, 15, 11);
        return pickCell;
    }
    else
    {  
        CreatJobSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:creatCell];
        if (cell == nil) {
            cell = [[[CreatJobSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:creatCell] autorelease];
        }
        // Configure the cell...
        if(indexPath.section == 0)
        {
            if(isOpen == NO)//高级选项是关闭的
            {
                if (indexPath.row == 4) {
                    cell.jobLabel.text = @"更多搜索条件:";
                    cell.selectLabel.text = @"";
                    cell.cellImageView.image = [UIImage imageNamed:@"combox.png"];
                    cell.cellImageView.frame = CGRectMake(280, 15, 15, 11);
                }
            }
            else
            {   
                if(indexPath.row<9&&indexPath.row>4)
                {
                    cell.jobLabel.text = [advancedArray objectAtIndex:(indexPath.row-4)*2];
                    cell.selectLabel.text = [advancedArray objectAtIndex:(indexPath.row-4)*2+1];
                    
                    if ([cell.selectLabel.text hasPrefix:@"请"] == NO) {
                        cell.selectLabel.textColor = [UIColor blackColor];
                    }
                    
                    cell.cellImageView.image = [UIImage imageNamed:@"accessoryArrow.png"];
                    cell.cellImageView.frame = CGRectMake(285, 15, 10, 14);
                }
                if (indexPath.row == 10) {
                    cell.jobLabel.text = @"收起搜索条件:";
                    cell.selectLabel.text = @"";
                    cell.cellImageView.image = [UIImage imageNamed:@"arrowUp.png"];
                    cell.cellImageView.frame = CGRectMake(280, 15, 15, 11);
                }
            }
            if (indexPath.row<4) {
                cell.jobLabel.text = [searchConditionArray objectAtIndex:indexPath.row*2];
                cell.selectLabel.text = [searchConditionArray objectAtIndex:indexPath.row*2+1];
                //改字体颜色；；；
                if ([cell.selectLabel.text hasPrefix:@"请"] == NO) {
                    cell.selectLabel.textColor = [UIColor blackColor];
                }

                
                cell.cellImageView.image = [UIImage imageNamed:@"accessoryArrow.png"];
                cell.cellImageView.frame = CGRectMake(285, 15, 10, 14);
            }
        }
        return cell;
    }
}
//pickCell代理的实现
-(void)content:(NSString *)str
{
    strPickCell.label2.text = str;
    strPickCell.label2.textColor = [UIColor blackColor];
    if (strPickCell.tag == 4) {
        [timeAndSalaryArray replaceObjectAtIndex:0 withObject:str];
    }
    if (strPickCell.tag == 9) {
        [timeAndSalaryArray replaceObjectAtIndex:1 withObject:str];
    }
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath//推进去的方法
{
    SelectDataTableViewController *selectDataTableViewController = [[SelectDataTableViewController alloc]init];
    if (indexPath.section == 0&&indexPath.row<3) {//选择界面
        selectDataTableViewController.row = indexPath.row;
        selectDataTableViewController.delegate = self;
        if([[boolSecondUnselectDictionary allKeys] indexOfObject:[NSNumber numberWithInt:indexPath.row]]!=NSNotFound)
        {
           selectDataTableViewController.secondUnSelectDic = [boolSecondUnselectDictionary objectForKey:[NSNumber numberWithInt:indexPath.row]];
        }
        NSArray *allkeys = [boolUnselectDictionary allKeys];
        for (NSNumber *line in allkeys) {
            if( indexPath.row == [line intValue])
            {   
                selectDataTableViewController.boolDataArray = [boolUnselectDictionary objectForKey:line];
            }
        }
        [self.navigationController pushViewController:selectDataTableViewController animated:YES];
    }
    if(isOpen == 0)
    {
        if(indexPath.row == 4)
        {
            isOpen = 1;
            [tableView reloadData];
        }
    }
    else
    {
        if (indexPath.row>4&&indexPath.row<9) {//推进选择界面
            NSArray *allkeys = [boolUnselectDictionary allKeys];
            for (NSNumber *line in allkeys) {
               if( indexPath.row == [line intValue])
               {
                   selectDataTableViewController.boolDataArray = [boolUnselectDictionary objectForKey:line];
               }
            }
            selectDataTableViewController.row = indexPath.row;
            selectDataTableViewController.delegate = self;
            [self.navigationController pushViewController:selectDataTableViewController animated:YES];
        }
        if (indexPath.row==4||indexPath.row==9) {
            PickTableViewCell *pickCell = (PickTableViewCell *)[self.creatTableView cellForRowAtIndexPath:indexPath];
            strPickCell = pickCell;
            strPickCell.tag = indexPath.row;
            [pickCell becomeFirstResponder];
        }
        if(indexPath.row == 10)
        {
            isOpen = 0;
            [tableView reloadData];
        }
    }
    [selectDataTableViewController release];
}
//代理的实现
-(void)dataProtocol:(NSMutableArray *)dataArr:(int)line:(NSMutableArray *)boolUnSelectArray:(NSMutableDictionary *)secondDictionary
{   
  
    [boolUnselectDictionary setObject:boolUnSelectArray forKey:[NSNumber numberWithInt:line]];
    if (line == 0) {
        [boolSecondUnselectDictionary setObject:secondDictionary forKey:[NSNumber numberWithInt:0]];
    }
    if (line == 2) {
        [boolSecondUnselectDictionary setObject:secondDictionary forKey:[NSNumber numberWithInt:2]];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:line inSection:0];
    CreatJobSearchViewCell *cell = (CreatJobSearchViewCell *)[self.creatTableView cellForRowAtIndexPath:path];
    if([dataArr count]!=0)
    {
        NSString *dataStr = @"";
        for (NSString *dataArrStr in dataArr) {
            dataStr = [NSString stringWithFormat:@"%@;%@",dataStr,dataArrStr];
        }
        NSRange range = {0,1};
        dataStr= [dataStr stringByReplacingCharactersInRange:range withString:@""];
        cell.selectLabel.text = dataStr;
        cell.selectLabel.textColor = [UIColor blackColor];
        if (line>3&&line<9) {
            [advancedArray replaceObjectAtIndex:(line-4)*2+1 withObject:dataStr];
        }
        else
        {
            [searchConditionArray replaceObjectAtIndex:(line*2+1) withObject:dataStr];
        }
    }
    
}   
//键盘回收
-(void)autoMovekeyBoard:(CGFloat)f
{
    if (f!=0) {
        f = f-49;
        NSIndexPath *key_wordIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        FieldTableViewCell *key_wordCell = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:key_wordIndex];
        NSIndexPath *search_nameIndex = [NSIndexPath indexPathForRow:0 inSection:1];
        FieldTableViewCell *search_nameCell = (FieldTableViewCell *)[self.creatTableView cellForRowAtIndexPath:search_nameIndex];
        if(key_wordCell.secondTF.tag == 200)
        {
            self.scrollView.contentOffset = CGPointMake(0, 40);
            key_wordCell.secondTF.tag = 100;
        }
        if (search_nameCell.secondTF.tag == 200) {
            if(isOpen == NO)
            {
                self.scrollView.contentOffset = CGPointMake(0, 150);
                
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    self.scrollView.contentOffset = CGPointMake(0, 413);
                }];
            }
            search_nameCell.secondTF.tag = 100;
        }
        
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.frame = CGRectMake(0, 0, 320, 367-f);
    }];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height ];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self autoMovekeyBoard:0];
}

@end
