//
//  CompanyList_ShowResumeViewController.m
//  ZhiLianZhaoPin
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CompanyList_ShowResumeViewController.h"
#import "EncryptURL.h"
#import "Company.h"
#import "GDataXMLNode.h"
#import "CompanyDetailViewController.h"
@implementation CompanyList_ShowResumeViewController
@synthesize resume = _resume,uticket,companyList = _companyList,errorString = _errorString,needLoadDataFlag,responseData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [_resume release];
    _resume = nil;
    [uticket release];
    uticket = nil;
    [_companyList release];
    _companyList = nil;
    [_errorString release];
    _errorString = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title = @"浏览"; 
    self.companyList = [[NSMutableArray alloc]init];
    NSLog(@"viewDidLoad");
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
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    if(self.needLoadDataFlag)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *urls = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/getcompanylist_showresume.aspx?resume_id=%@&resume_number=%@&version_number=%@&uticket=%@",self.resume.resume_id,self.resume.resume_number,self.resume.version_number,self.uticket];
        EncryptURL *encryption = [[EncryptURL alloc]init];
        NSString *urlStr = [encryption getMD5String:urls];
        [encryption release];
        NSString *encodeUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"设置默认简历：urlString = %@",encodeUrlStr);
        NSURL *url = [NSURL URLWithString:encodeUrlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"receivedString = %@",receivedString);
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        int parseResult = [self parseReceivedString:receivedString];
//        if(parseResult == 1)
//        {
//            [self.tableView reloadData];
//            NSLog(@"company reloadData ,[self.companyList count] = %d",[self.companyList count]);
//        }
//        else if(parseResult == 5)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取信息失败" message:@"请重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取信息失败" message:[NSString stringWithFormat:@"%@",self.errorString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//        self.needLoadDataFlag = NO;
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"connectionDidFinishLoading receivedString = %@",receivedString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    int parseResult = [self parseReceivedString:receivedString];
    if(parseResult == 1)
    {
        [self.tableView reloadData];
        NSLog(@"company reloadData ,[self.companyList count] = %d",[self.companyList count]);
    }
    else if(parseResult == 5)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取信息失败" message:@"请重新登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取信息失败" message:[NSString stringWithFormat:@"%@",self.errorString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    self.needLoadDataFlag = NO;

}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError:%@",error);
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
        GDataXMLElement *joblist = [[root elementsForName:@"joblist"]objectAtIndex:0];
        NSArray *jobs = [joblist children];
        if([jobs count] <= 0)
        {
            NSLog(@"here [jobs count] <= 0");
            return 1; 
        }
        else
        {
            for(GDataXMLElement *job in jobs)
            {
//                <company_number>CC229503220</company_number>
//                <company_name><![CDATA[丹阳市翔宇电子厂]]></company_name>
//                <company_type>国企</company_type>
//                <company_size>20人以下</company_size>
//                <resume_name>其他 北京</resume_name>
//                <date_show>2012-10-07</date_show>
                Company *company = [[Company alloc]init];
                GDataXMLElement *company_number = [[job elementsForName:@"company_number"] objectAtIndex:0];
                NSString *company_number_string = [company_number stringValue];
                company.company_number = company_number_string;
                
                GDataXMLElement *company_name = [[job elementsForName:@"company_name"] objectAtIndex:0];
                NSString *company_name_string = [company_name stringValue];
                company.company_name = company_name_string;
                
                GDataXMLElement *company_type = [[job elementsForName:@"company_type"] objectAtIndex:0];
                NSString *company_type_string = [company_type stringValue];
                company.company_type = company_type_string;
                
                GDataXMLElement *company_size = [[job elementsForName:@"company_size"] objectAtIndex:0];
                NSString *company_size_string = [company_size stringValue];
                company.company_size = company_size_string;
                
                GDataXMLElement *resume_name = [[job elementsForName:@"resume_name"] objectAtIndex:0];
                NSString *resume_name_string = [resume_name stringValue];
                company.resume_name = resume_name_string;
                
                GDataXMLElement *date_show = [[job elementsForName:@"date_show"] objectAtIndex:0];
                NSString *date_show_string = [date_show stringValue];
                company.date_show = date_show_string;
                
                NSLog(@"company = %@",company);
                [self.companyList addObject:company];
                NSLog(@"[self.companyList count] = %d",[self.companyList count]);

                [company release];
            }
        }
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
    NSLog(@"numberOfSections");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRows");
    NSLog(@"[self.companyList count] = %d",[self.companyList count]);
    return [self.companyList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRow");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Company *company = [self.companyList objectAtIndex:indexPath.row];
    cell.textLabel.text = company.company_name;
    NSLog(@"company name = %@",company.company_name);
    cell.detailTextLabel.text = company.company_size;
    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessoryArrow.png"]];
    //accessoryView.frame = CGRectMake(0, 0, 10, 15);
    cell.accessoryView = accessoryView;
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 128, 23)];
    dateLabel.text = company.date_show;
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.backgroundColor = [UIColor clearColor];
    //dateLabel.textColor = [UIColor orangeColor];
    //numberLabel.textColor = [UIColor greenColor];
    [cell.contentView addSubview:dateLabel];
    [dateLabel release];
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
    // Navigation logic may go here. Create and push another view controller.
    CompanyDetailViewController *companyDetailView = [[CompanyDetailViewController alloc]init];
    Company *company = [self.companyList objectAtIndex:indexPath.row];
    companyDetailView.company = company;
    [self.navigationController pushViewController:companyDetailView animated:YES];
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
