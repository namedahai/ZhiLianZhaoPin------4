//
//  SelectDataTableViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectDataTableViewController.h"
#import "GDataXMLNode.h"
#import "SecondSelectDataTableViewController.h"
#import "SelectDataTableViewCell.h"
@implementation SelectDataTableViewController
@synthesize row = _row;
@synthesize delegate = _delegate;
@synthesize boolDataArray;
@synthesize secondUnSelectDic;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [dataArray release];
    dataArray = nil;
    [boolDataArray release];
    boolDataArray = nil;
    [secondSelectArray release];
    secondSelectArray = nil;
    [secondUnSelectDic release];
    secondUnSelectDic = nil;
    [secondSelectDic release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(GDataXMLElement *)analysis//解析开始
{
    NSString *str = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZhiLianData" ofType:@"xml"]encoding:NSUTF8StringEncoding error:nil ];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:str options:0 error:nil];
    GDataXMLElement *root = [document rootElement];//获得根节点;
    NSArray *children = [root children];//获得节点
    GDataXMLElement *basedata = [children objectAtIndex:0];
    return basedata;
}
-(void)analysisArea//解析xml数据地区1;
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *city = [[basedata children]objectAtIndex:0];
    GDataXMLElement *firstLevel = [[city children]objectAtIndex:0];
    for (GDataXMLElement *cityName in [firstLevel children]) {
        [dataArray addObject:[cityName stringValue]];
    }
}
-(void)analysisJob//解析职位
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *jobtype = [[basedata elementsForName:@"jobtype"] objectAtIndex:0];
    for (GDataXMLElement *jobPost in [jobtype children]) {
        [dataArray addObject:[jobPost stringValue]];
    }
}
-(void)analysisBusiness//解析行业
{
    GDataXMLElement *basedata = [self analysis];
    GDataXMLElement *industry = [[basedata elementsForName:@"industry"]objectAtIndex:0];
    for (GDataXMLElement *business in [industry children]) {
        [dataArray addObject:[business stringValue]];
    }
}
-(void)analysisMoreOption//解析更多选项;
{
    GDataXMLElement *basedata = [self analysis];
    switch (self.row) {
        case 4:
        {
            GDataXMLElement *publishDate = [[basedata elementsForName:@"publishDate"]objectAtIndex:0];
            for (GDataXMLElement *business in [publishDate children]) {
                [dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 5:
        {
            GDataXMLElement *workEXP = [[basedata elementsForName:@"workEXP"]objectAtIndex:0];
            for (GDataXMLElement *business in [workEXP children]) {
                [dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 6:
        {
            GDataXMLElement *education = [[basedata elementsForName:@"education"]objectAtIndex:0];
            for (GDataXMLElement *business in [education children]) {
                [dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 7:
        {
            GDataXMLElement *comptype = [[basedata elementsForName:@"comptype"]objectAtIndex:0];
            for (GDataXMLElement *business in [comptype children]) {
                [dataArray addObject:[business stringValue]];
            }
        }
            break;
        case 8:
        {
            GDataXMLElement *compsize = [[basedata elementsForName:@"compsize"]objectAtIndex:0];
            for (GDataXMLElement *business in [compsize children]) {
                [dataArray addObject:[business stringValue]];
            }
        }
            break;
        default:
            break;
    }
}
//返回
-(void)back
{   
    if (self.row == 0||self.row == 2) {
       NSArray *secondArray =[secondSelectDic allKeys];
        for (id a in secondArray) {
          [secondSelectArray addObjectsFromArray:[secondSelectDic objectForKey:a]];
        }
        [self.delegate dataProtocol:secondSelectArray:self.row:boolDataArray:secondUnSelectDic];//当是2的时候传过去第二页的内容;
    }
    else
    {
    int i = 0;//表示数组中的位置;
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (NSNumber *number in boolDataArray) {
        if([number boolValue] == NO)
        {   
            [data addObject:[dataArray objectAtIndex:i]];
        }
        i++;
    }
        [self.delegate dataProtocol:data:self.row:boolDataArray:secondUnSelectDic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init ];
    if(secondUnSelectDic == nil)
    {
    secondUnSelectDic = [[NSMutableDictionary alloc]init];
    }
    secondSelectDic = [[NSMutableDictionary alloc]init];
    if(self.boolDataArray==nil)
    {
    boolDataArray = [[NSMutableArray alloc]init];//用来标记datarrray，里面是bool值;
    }
    unSelect = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
    secondSelectArray = [[NSMutableArray alloc]init];//用来记忆第二页额信息;
    if(self.row == 2)
    {
        self.navigationItem.title = @"选择地点";
        [self analysisArea];
    }
    if (self.row == 0) {
        self.navigationItem.title = @"选择职位";
        [self analysisJob];
    }
    if (self.row == 1) {
        self.navigationItem.title = @"选择行业";
        [self analysisBusiness];
    }
    if (self.row<9&&self.row>3) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"",@"选择工作经验",@"选择学历",@"选择公司性质",@"选择公司规模",nil];
        self.navigationItem.title = [titleArray objectAtIndex:self.row-4];
        [self analysisMoreOption];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([boolDataArray count] == 0)
    {
    for (int i=0; i<[dataArray count]; i++) {//给每个行设置bool来标记;
        [boolDataArray addObject:[NSNumber numberWithBool:unSelect]];
    }
    }
    return [dataArray count];
}
//为了取消第二页亮灯的内容
-(void)cancleSecondPage:(UIButton *)selectBtn
{
    int index = selectBtn.tag - 300;
    if ([[boolDataArray objectAtIndex:index] boolValue] == NO) 
    {
     [selectBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];  
     [boolDataArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        
        NSMutableArray *secondUnselectArray = [secondUnSelectDic objectForKey:[NSNumber numberWithInt:index]];
        for (int i = 0; i<[secondUnselectArray count]; i++) 
        {
            [secondUnselectArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//重定义第0行和第2行设置不同的CELL
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *cellData = @"CellData";
    if (self.row == 0||self.row == 2)
    {
        SelectDataTableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:cellData];
        if (selectCell == nil) {
            selectCell = [[[SelectDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellData]autorelease];
        }
        selectCell.selectLabel.text = [dataArray objectAtIndex:indexPath.row];
        [selectCell.selectBtn addTarget:self action:@selector(cancleSecondPage:) forControlEvents:UIControlEventTouchUpInside];
        selectCell.selectBtn.tag = indexPath.row + 300;
        if([[boolDataArray objectAtIndex:indexPath.row] boolValue]==YES)
        {
            [selectCell.selectBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
        }
        else
        {
            [selectCell.selectBtn setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
        }
        return selectCell;

    }
    else
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    if([[boolDataArray objectAtIndex:indexPath.row] boolValue]==YES)
    {
        cell.imageView.image = [UIImage imageNamed:@"unselect_icon.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"select_icon.png"];
    }
    // Configure the cell...
    
    return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate
-(void)changeBtnImage:(int)x:(SelectDataTableViewCell *)cell
{
    if ([[boolDataArray objectAtIndex:x] boolValue]==NO) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
        BOOL a = YES;
        [boolDataArray replaceObjectAtIndex:x withObject:[NSNumber numberWithBool:a]];
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
        BOOL a = NO;
        [boolDataArray replaceObjectAtIndex:x withObject:[NSNumber numberWithBool:a]];
    }

}
//0和2里面的代理的实现
-(void)dataTableViewProtocol:(NSMutableArray *)array:(int)line:(NSMutableArray *)secondUnSelecetArray:(int)firstRow
{ 
    [secondUnSelectDic setObject:secondUnSelecetArray forKey:[NSNumber numberWithInt:firstRow]];
    [secondSelectDic setObject:array forKey:[NSNumber numberWithInt:firstRow]];
    //我在这里判断第二个页面是否有数据;
    SelectDataTableViewCell *cell = (SelectDataTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:firstRow inSection:0]];
    
    
    //周四改；
    if ([array count]!=0)
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"select_icon.png"] forState:UIControlStateNormal];
        [boolDataArray replaceObjectAtIndex:firstRow withObject:[NSNumber numberWithBool:NO]];
        
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
        [boolDataArray replaceObjectAtIndex:firstRow withObject:[NSNumber numberWithBool:YES]];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.row == 0||self.row == 2)
    {  
        int allSelect = 0;
        SelectDataTableViewCell *cell = (SelectDataTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self changeBtnImage:indexPath.row :cell];
        SecondSelectDataTableViewController *detailViewController = [[SecondSelectDataTableViewController alloc] init];
        NSArray *allKeys = [self.secondUnSelectDic allKeys];
        for (id a in allKeys) {
            for (id b in [self.secondUnSelectDic objectForKey:a]) 
            {
               if([b boolValue] == NO)
               {
                   allSelect++;
               }
            }
        }
        
        for (id a in allKeys) {
            if([a isEqual:[NSNumber numberWithInt:indexPath.row]] == YES)
            {
                detailViewController.boolDataArray = [self.secondUnSelectDic objectForKey:[NSNumber numberWithInt:indexPath.row]];
            }
        }
        detailViewController.selectName = cell.selectLabel.text;
        detailViewController.row = self.row;
        detailViewController.delegate = self;
        detailViewController.firstRow = indexPath.row;
        detailViewController.allSelect = allSelect;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else
    {
        if (self.row == 1&&[[boolDataArray objectAtIndex:indexPath.row] boolValue]==YES) 
        {
            int i = 0;
            for (NSNumber *a in boolDataArray) {
                if([a boolValue] == NO)
                {
                    i++;
                }
            }

            if (i>=10) 
            {   
                PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15,100, 260, 80)];
                promptView.promptLabel.text = @"最多选择十个";
                [self.view.window addSubview:promptView];
                [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    promptView.alpha = 0;
                } completion:^(BOOL finished) {
                    [promptView removeFromSuperview];
                }];
                [promptView release];
                return;
            } 
        }
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];//找出选择的cell；
        if([[boolDataArray objectAtIndex:indexPath.row] boolValue]==NO)
        {
            cell.imageView.image = [UIImage imageNamed:@"unselect_icon.png"];
            // - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
            BOOL a = YES;
            [boolDataArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:a]];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"select_icon.png"];
            BOOL a = NO;
            [boolDataArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:a]];
            
        }
    }
}
@end
