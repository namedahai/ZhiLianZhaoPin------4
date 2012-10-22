//
//  SecondSelectDataTableViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondSelectDataTableViewController.h"
#import "GDataXMLNode.h"
#import "PromptView.h"
@implementation SecondSelectDataTableViewController
@synthesize selectName = _selectName;
@synthesize row = _row;
@synthesize delegate = _delegate;
@synthesize firstRow = _firstRow;
@synthesize boolDataArray;
@synthesize allSelect;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [secondDataArray release];
    secondDataArray = nil;
    [boolDataArray release];
    boolDataArray = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)analysis//解析xml数据地区1;
{
   
    NSString *str = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZhiLianData" ofType:@"xml"]encoding:NSUTF8StringEncoding error:nil ];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:str options:0 error:nil];
    [str release];
    GDataXMLElement *root = [document rootElement];//获得根节点;
    NSArray *children = [root children];//获得节点
    GDataXMLElement *basedata = [children objectAtIndex:0];
    GDataXMLElement *city = [[basedata children]objectAtIndex:0];
    GDataXMLElement *secondLevel = [[city children]objectAtIndex:1];
    GDataXMLElement *firstLevel = [[city children]objectAtIndex:0];
    NSString *firstCode;
    for (GDataXMLElement *item in [firstLevel children]) {
       if([[item stringValue] isEqualToString:self.selectName] == YES)
       {
           firstCode = [[item attributeForName:@"code"] stringValue];
       }
    }
    for (GDataXMLElement *cityName in [secondLevel children]) {
     if([[[cityName attributeForName:@"parent"] stringValue] isEqualToString:firstCode] == YES)
     {
         [secondDataArray addObject:[cityName stringValue]];
     }
    }
}
-(void)a//解析职位
{
    NSString *str = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZhiLianData" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:str options:0 error:nil];
    [str release];
    GDataXMLElement *root = [document rootElement];
    NSArray *children = [root children];
    GDataXMLElement *basedata = [children objectAtIndex:0];
    GDataXMLElement *jobType = [[basedata elementsForName:@"jobtype"] objectAtIndex:0];
    GDataXMLElement *smallJobType = [[basedata elementsForName:@"small_Job_type"] objectAtIndex:0];
    NSString *firstCode;
    for (GDataXMLElement *item in [jobType children]) {
        if ([[item stringValue] isEqualToString:self.selectName] == YES) {
            firstCode = [[item attributeForName:@"code"] stringValue];
        }
    }
    for (GDataXMLElement *jobName in [smallJobType children]) {
        if ([[[jobName attributeForName:@"categoryid"] stringValue]isEqualToString:firstCode] == YES) {
            [secondDataArray addObject:[jobName stringValue]];
        }
    }
}
-(void)back
{
    int i = 0;//表示数组中的位置;
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (NSNumber *number in boolDataArray) {
        if([number boolValue] == NO)
        {   
            
            [data addObject:[secondDataArray objectAtIndex:i]];
        }
        i++;
    }
    [self.delegate dataTableViewProtocol:data:self.row:boolDataArray:self.firstRow];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    secondDataArray = [[NSMutableArray alloc]init];
    if(boolDataArray == nil)
    {
    boolDataArray = [[NSMutableArray alloc]init];//用来标记datarrray，里面是bool值;
    }
    unSelect = YES;
    //重新设置left
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
    if(self.row == 2)
    {
        self.navigationItem.title = @"选择城市";
    [self analysis];
    }
    if (self.row == 0) {
        self.navigationItem.title = @"选择职位";
        [self a];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    for (int i=0; i<[secondDataArray count]; i++) {//给每个行设置bool来标记;
        [boolDataArray addObject:[NSNumber numberWithBool:unSelect]];
    }

    return [secondDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [secondDataArray objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];//找出选择的cell；
    if([[boolDataArray objectAtIndex:indexPath.row] boolValue]==NO)
    {
        self.allSelect--;
        cell.imageView.image = [UIImage imageNamed:@"unselect_icon.png"];
        BOOL a = YES;
        [boolDataArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:a]];
    }
    else
    {
        self.allSelect++;
        if (self.allSelect>=6) 
        {
            PromptView *promptView = [[PromptView alloc]initWithFrame:CGRectMake(15,100, 260, 80)];
            promptView.promptLabel.text = @"最多选择五个";
            [self.view.window addSubview:promptView];
            [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                promptView.alpha = 0;
            } completion:^(BOOL finished) {
                [promptView removeFromSuperview];
            }];
            [promptView release];
            return;
        } 
        cell.imageView.image = [UIImage imageNamed:@"select_icon.png"];
        BOOL a = NO;
        [boolDataArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:a]];
        
    }
    
}

@end
