//
//  PartnerViewController.m
//  ServicePro
//
//  Created by GSS Mysore on 12/19/13.
//
//

#import "PartnerViewController.h"
#import "Constants.h"
#import "ServiceManagementData.h"
#import "iOSMacros.h"



@interface PartnerViewController ()

@end




@implementation PartnerViewController


@synthesize teleNumFirst,teleNumSecond,partnerData;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    
    self.title =  @"Additional Partners";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0) {
        [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
        barButton.tintColor = [UIColor whiteColor];
    }
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    
    
    //****************************************************************************************************************
    //GET PARTNER
    //*****************************************************************************************************************
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_DCMNTPRTNR10EC WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",objServiceManagementData.partnerTaskID,objServiceManagementData.partnerTaskItem];
    self.partnerData = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"PARTNER" :1];
    //******************************************************************************************************************
    NSLog(@"PARTNER %@", self.partnerData);
    NSLog(@"object id %@", objServiceManagementData.partnerTaskID);
    [partnerTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.partnerData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(IS_IPAD) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,900,P_HEADER_TABLE_HEIGHT)];
        
        UIColor *BorderColor = [UIColor darkTextColor];

    
        UIButton *service_Priority = [[UIButton alloc]initWithFrame:CGRectMake(P_HEADER_STS_OFFSET, P_HEADER_TABLE_YAXIS, P_HEADER_STS_WIDTH, P_HEADER_TABLE_HEIGHT)];
        service_Priority.tag = 1;
        service_Priority.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_Priority setTitle:[NSString stringWithFormat:@" Partner Type"] forState:UIControlStateNormal];
        [service_Priority setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        service_Priority.layer.borderColor = [BorderColor CGColor];
        service_Priority.layer.borderWidth = P_HEADER_BORDER_WIDTH;
        service_Priority.titleLabel.font = [UIFont boldSystemFontOfSize:P_HEADER_FONT_SIZE];
        [headerView addSubview:service_Priority];
        
        
        UIButton *service_Partner= [[UIButton alloc]initWithFrame:CGRectMake(P_HEADER_STD_OFFSET, P_HEADER_TABLE_YAXIS, P_HEADER_STD_WIDTH, P_HEADER_TABLE_HEIGHT)];
        service_Partner.tag = 2;
        service_Partner.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_Partner setTitle:[NSString stringWithFormat:@" Partner Name"] forState:UIControlStateNormal];
        [service_Partner setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        service_Partner.layer.borderColor = [BorderColor CGColor];
        service_Partner.layer.borderWidth = P_HEADER_BORDER_WIDTH;
        service_Partner.titleLabel.font = [UIFont boldSystemFontOfSize:P_HEADER_FONT_SIZE];
        [headerView addSubview:service_Partner];
        
        
        
        UIButton *service_Status = [[UIButton alloc]initWithFrame:CGRectMake(P_HEADER_CUSTL_OFFSET, P_HEADER_TABLE_YAXIS, P_HEADER_CUSTL_WIDTH, P_HEADER_TABLE_HEIGHT)];
        service_Status.tag = 3;
        service_Status.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_Status setTitle:[NSString stringWithFormat:@" Contact"] forState:UIControlStateNormal];
        [service_Status setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        service_Status.layer.borderColor = [BorderColor CGColor];
        service_Status.layer.borderWidth = P_HEADER_BORDER_WIDTH;
        service_Status.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [headerView addSubview:service_Status];
        
        
        
        return headerView;
        
    }
    
    
    return NULL;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return T_HEADER_TABLE_HEIGHT;    
}


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    int row_index = indexPath.row + 1;
    
    if((row_index % 2) == 0)
        cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    UIFont *Font_Size;
    
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	cell = [partnerTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
            cell = [self taskTableViewCellWithIdentifier_ipad:CellIdentifier];
    }
	
	
	cell.textLabel.numberOfLines = 1;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	
    Font_Size = [UIFont systemFontOfSize:12.0f];
    
    
    NSString *scdName = @"";
    
    if (![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"NAME2"] isEqualToString:@""] && !([[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"NAME2"] == nil) && ![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"NAME2"] isEqualToString:@"(null)"])
    {
        scdName = [[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"NAME2"];
    }
    
    
    NSString *pName = [NSString stringWithFormat:@"%@ %@ (%@)", [[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"NAME1"],scdName,[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"PARTNER_NO"]];
    
    // Configure the cell... setting the text of our cell's label
    [self Create_Label_Service_Order:cell andTag:T_TEXT1PAT_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",[self GetPartnerTypeDiscription:[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"PARVW"]]]];
    
    
    [self Create_Label_Service_Order:cell andTag:T_TEXT2PAT_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",pName]];
    
    
    //Load telephone number1
    if (![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF1"] isEqualToString:@""] && !([[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF1"] == nil) && ![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF1"] isEqualToString:@"(null)"]) {
        [self Create_Label_Service_Order:cell andTag:T_TEXT3PAT_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF1"]]];
        
        [self Create_Image_partner:cell andTag:T_IMAGE1PAT_TAG andImageName:@"call_icon.jpg" andButTag:indexPath.row];
    }
    
    
    //Load telephone number2
    if (![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF2"] isEqualToString:@""] && !([[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF2"] == nil) && ![[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF2"] isEqualToString:@"(null)"]) {
      
        [self Create_Label_Service_Order:cell andTag:T_TEXT4PAT_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",[[self.partnerData objectAtIndex:indexPath.row] objectForKey:@"TELF2"]]];

        [self Create_Image_partner:cell andTag:T_IMAGE2PAT_TAG andImageName:@"call_icon.jpg" andButTag:indexPath.row+2000];
        
    }
    
    return cell;
}

-(void)Create_Image_partner:(UITableViewCell *)cell andTag:(int)LTag andImageName:(NSString*)imageName andButTag:(NSInteger *)butTag
{
    UIButton *telButton = (UIButton *) [cell viewWithTag:LTag];
    telButton.tag = butTag;
    [telButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [telButton addTarget:self action:@selector(dailTelePhoneNumber:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:telButton];
    
}


//calling while trying to back Service Orders (Task) list page
-(void) dailTelePhoneNumber: (UIButton *) butName
{
    
    NSString *telNum;
    
    
    NSLog(@"ress %d", (butName.tag - 2000));
    
    if ((butName.tag - 2000) >= 0) {
        telNum = [[self.partnerData objectAtIndex:(butName.tag - 2000)] objectForKey:@"TELF2"];
    }
    else
        telNum =[[self.partnerData objectAtIndex:butName.tag] objectForKey:@"TELF1"];
    
    NSLog(@"tel Number %@",telNum);
    
    
    if (IS_IPHONE) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telNum]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }
}



-(NSString *) GetPartnerTypeDiscription: (NSString *) partnerType {
    
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    NSString *sqlPrQryStr = [NSString stringWithFormat:@"SELECT * FROM CRMC_PARTNER_FT WHERE PARTNER_FCT = '%@'",partnerType];
    NSMutableArray *tempPrtMast = [objServiceManagementData fetchDataFrmSqlite:sqlPrQryStr :objServiceManagementData.gssSystemDB:@"PARTNERTYPE" :1];
    
    if ([tempPrtMast count]>0) {
        return [[tempPrtMast objectAtIndex:0] objectForKey:@"DESCRIPTION"];
    }
    else
        return @"";
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - Table view columns setting

//IPhone Table Cell  View - Table View

-(UITableViewCell *)taskTableViewCellWithIdentifier_ipad:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
    
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
    
	//Now we have to create the two labels.
	UILabel *label;
	
    
    //Create a rectangle container for the EST.Arrival .
	cellRectangle = CGRectMake(T_TEXT1PAT_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT1PAT_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT1PAT_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
    //Create a rectangle container for the Service Doc .
	cellRectangle = CGRectMake(T_TEXT2PAT_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT2PAT_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT2PAT_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
    //Create a rectangle container for the Contact Name .
	cellRectangle = CGRectMake(T_TEXT3PAT_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT3PAT_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT3PAT_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
    //Create a rectangle container for the Contact Name .
	cellRectangle = CGRectMake(T_TEXT4PAT_OFFSET, 40, T_TEXT4PAT_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT4PAT_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];

    
    //Create a rectangle container for the date text.
	cellRectangle = CGRectMake(T_IMAGE1PAT_OFFSET,25, T_IMAGE1PAT_WIDTH, 25);
	//Initialize the label with the rectangle.
	UIButton *but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE1PAT_TAG;
    //Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
    
    
    //Create a rectangle container for the date text.
	cellRectangle = CGRectMake(T_IMAGE2PAT_OFFSET,52, T_IMAGE2PAT_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE2PAT_TAG;
    //Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];

	return cell;
}

-(void)Create_Label_Service_Order:(UITableViewCell *)cell andTag:(int)LTag andFontS :(UIFont*)FontS andNOLines:(int)Lines andLdata:(NSString*)Ldata
{
    
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:LTag];
    lbl1.text = [NSString stringWithFormat:@"%@ ", Ldata];
    lbl1.font = FontS;
    lbl1.textColor = [UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0];
    
    if(Lines !=0)
        lbl1.numberOfLines = Lines;
    
    // lbl1.adjustsFontSizeToFitWidth = YES;
    
}





@end
