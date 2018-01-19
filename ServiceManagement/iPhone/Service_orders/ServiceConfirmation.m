//
//  ServiceConfirmation.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*...This page for service confirmation and activity listing........
 ...Please consult with Ibrahim...for deatils of this page..and after that proceed..*/

#import "ServiceConfirmation.h"
#import "QuartzCore/QuartzCore.h"
#import "ServiceManagementData.h"
#import "ServiceConfCreation.h"
#import "ServiceOrders.h"
#import "ServiceOrderEdit.h"
#import "ServiceOrders.h"

#import "AppDelegate_iPhone.h"

#import "TaskLocationMapView.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

@implementation ServiceConfirmation

@synthesize myTableView;
@synthesize displayServiceOrder;
@synthesize addNewConfirmationButton;
@synthesize isAnyCheckboxSelectedArray;

@synthesize checkBoxValueDictionary;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
	
	self.title = @"Service Confirmation Overview";
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //end
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	
	//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
	
	
	//Creating textview to display the task deatils...
	displayServiceOrder = [Design textViewFormation:5.0 :5.0 :310.0 :120.0 :3 :self];
	displayServiceOrder.backgroundColor = [UIColor clearColor];
	displayServiceOrder.textColor = [UIColor blackColor];
	displayServiceOrder.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
	displayServiceOrder.layer.masksToBounds = YES;
	displayServiceOrder.layer.cornerRadius = 2.0;
	displayServiceOrder.layer.borderWidth = 0.9;
	displayServiceOrder.layer.borderColor =  [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];	
    
  	
	displayServiceOrder.text = [NSString stringWithFormat:@" Customer: %@, %@\n Start Date: %@\n Service Order: %@ %@",
						[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:0] objectForKey:@"NAME_ORG1"],
						[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:0] objectForKey:@"NAME_ORG2"],
						[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:0] objectForKey:@"ZZKEYDATE"],
						[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
						[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:0] objectForKey:@"ZZITEM_DESCRIPTION"]
						];
	
	[self.view addSubview:displayServiceOrder];
	self.myTableView.backgroundColor = [UIColor clearColor];
	self.myTableView.layer.masksToBounds = YES;
	self.myTableView.layer.cornerRadius = 5.0;
	self.myTableView.layer.borderWidth = 1.9;
	self.myTableView.layer.borderColor =  [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	//This dictionary for...gathering the value of check box...you can changed the way..to collect the value of check box.. 
	self.checkBoxValueDictionary = [[NSMutableDictionary alloc] init];
	
	[self.checkBoxValueDictionary removeAllObjects];
	[super viewDidLoad];
}

//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack
{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.localImageFilePath = @""; 
    delegate.signatureCaptured = FALSE;
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}	


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	return [objServiceManagementData.serviceOrderActivityArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL flag = FALSE;
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//Seraching serviceOrderActivityArray objectId in serviceOrderConfirmationArray 
	NSString *searchStr = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"];	
	for(int i=indexPath.row;i<[objServiceManagementData.serviceOrderConfirmationArray count];i++)
	{
		NSString *serviceOrderConfirmationArrayStr = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"SRCDOC_OBJECT_ID"];
		
		if([searchStr isEqualToString:serviceOrderConfirmationArrayStr])
		{
			flag = TRUE;
			break;
		}
	}
	
		
	if(flag == TRUE)
		return 90.0f;
	else 
		return 45.0f;	
		
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";	
	UILabel *commonLabel;
	NSString *imageName = @"";
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
  	
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.userInteractionEnabled = TRUE;
    
	
	BOOL flag = FALSE;
	
	NSInteger indexOfTheObject = 0;
	NSString *strConfirmationNumber = @"";
    NSString *mstrConfimrationNumber;
	int mObject_id = [[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"] intValue];	
    int mNumber_Ext = [[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"NUMBER_EXT"] intValue];
    
    
	for(int i=indexPath.row;i<[objServiceManagementData.serviceOrderConfirmationArray count];i++)
	{
		int mCnfObjectId = [[[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"SRCDOC_OBJECT_ID"] intValue];
        int mCnfNumber_Ext = [[[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"NUMBER_EXT"] intValue];
		
		if(mObject_id == mCnfObjectId && mNumber_Ext == mCnfNumber_Ext )
		{
			flag = TRUE;
			indexOfTheObject = i;
            mstrConfimrationNumber = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"OBJECT_ID"];
            strConfirmationNumber = [NSString stringWithFormat:@"%@ %@",mstrConfimrationNumber,strConfirmationNumber] ;
            
		}
        
	}
	
	//Display the check box...is checkd or uncheked... depending upon the dictionary value...
	if([[self.checkBoxValueDictionary objectForKey:[NSString stringWithFormat:@"checkbox%d",indexPath.row]] boolValue] == YES)
		imageName = @"checked.png";
	else 
		imageName = @"unchecked.png";

	
	//This block will display....if any confirmation is added.....Please consult with Ibrahim...for the Confirmation page...
	if(flag == TRUE)
	{
		commonLabel = [Design LabelFormation:30.0 :45.0 :148.0:35:15.0f :2];
		commonLabel.text =  [NSString stringWithFormat: @"conf# %@", strConfirmationNumber];
		[cell.contentView addSubview:commonLabel];
		[commonLabel release], commonLabel = nil;
		
		
		commonLabel = [Design LabelFormation:79.0 :45.0 :118.0:35:15.0f :2];
		commonLabel.text = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:indexOfTheObject] objectForKey:@"ZZITEM_DESCRIPTION"]; 				
		[cell.contentView addSubview:commonLabel];
		[commonLabel release], commonLabel = nil;
		
		commonLabel = [Design LabelFormation:198 :45.0 :52.0:35:15.0f :2];
		commonLabel.text = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:indexOfTheObject] objectForKey:@"PRODUCT_ID"]; [cell.contentView addSubview:commonLabel];
		[commonLabel release], commonLabel = nil;
		
		
		commonLabel = [Design LabelFormation:252.0 :45.0 :70.0:35:15.0f :2];
		commonLabel.text = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:indexOfTheObject] objectForKey:@"ERDAT"]; 	
		[cell.contentView addSubview:commonLabel];
		[commonLabel release], commonLabel = nil;
		 
		cell.userInteractionEnabled = FALSE;
        cell.backgroundColor = [UIColor clearColor];
		
		imageName = @"checked.png";
		 
		
	}
	
	UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
	checkboxButton.frame = CGRectMake(3, 10, 28, 20);
	[checkboxButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[checkboxButton addTarget:self action:@selector(checkBoxedClicked:) forControlEvents:UIControlEventTouchUpInside];
	checkboxButton.tag = indexPath.row;
	[cell.contentView addSubview:checkboxButton];
	
	
	commonLabel = [Design LabelFormation:30.0 :5.0 :48.0:35:15.0f :2];
	commonLabel.text = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"NUMBER_EXT"]; 		
	[cell.contentView addSubview:commonLabel];
	[commonLabel release], commonLabel = nil;
	
	
	commonLabel = [Design LabelFormation:79.0 :5.0 :158.0:35:15.0f :2];
	commonLabel.text = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"ZZITEM_DESCRIPTION"];
	[cell.contentView addSubview:commonLabel];
	[commonLabel release], commonLabel = nil;
	
	commonLabel = [Design LabelFormation:238 :5.0 :102.0:35:15.0f :2];
	commonLabel.text = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"];
	[cell.contentView addSubview:commonLabel];
	[commonLabel release], commonLabel = nil;
	
	
    return cell;	
}


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	BOOL flag = FALSE;
	
	NSInteger indexOfTheObject = 0;
	int mObject_id = [[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"] intValue];	
    int mNumber_Ext = [[[objServiceManagementData.serviceOrderActivityArray objectAtIndex:indexPath.row] objectForKey:@"NUMBER_EXT"] intValue];
    
    
	for(int i=indexPath.row;i<[objServiceManagementData.serviceOrderConfirmationArray count];i++)
	{
		int mCnfObjectId = [[[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"SRCDOC_OBJECT_ID"] intValue];
        int mCnfNumber_Ext = [[[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:i] objectForKey:@"NUMBER_EXT"] intValue];
		
		if(mObject_id == mCnfObjectId && mNumber_Ext == mCnfNumber_Ext )
		{
			flag = TRUE;
			indexOfTheObject = i;
            
		}
        
	}
	
	/*if(flag == TRUE)
	{
		cell.backgroundColor = [UIColor grayColor];
	}
	else {
		cell.backgroundColor = [UIColor whiteColor];
	}*/
    int row_index = indexPath.row + 1;
    if((row_index % 2) == 0)
        cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
	
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}


//This function will clicked if any check box is clicked..
-(IBAction) checkBoxedClicked:(id)sender
{
	UIButton *btn = (UIButton *)sender;	
	NSLog(@"Button tag=%d", btn.tag);
	
	NSString *tempStr = [NSString stringWithFormat:@"checkbox%d",btn.tag];
	
	if([[self.checkBoxValueDictionary objectForKey:tempStr] boolValue] == YES)
		[self.checkBoxValueDictionary setObject:@"FALSE" forKey:tempStr];
	else 
		[self.checkBoxValueDictionary setObject:@"TRUE" forKey:tempStr];

	
	
	
	[self.myTableView reloadData];
	
}


//When user want to add New Service confirmation, this function will call...
-(IBAction) pressedAddNewConfirmationButton:(id)sender
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	BOOL flag = FALSE;
	//NSString *number_ext;
    

    //Delete all records from temporary tables
    //Creating Sql string delete temporary record already created in acitity table
    NSString *_deleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"];
    [objServiceManagementData excuteSqliteQryString:_deleteSQl :objServiceManagementData.serviceReportsDB :@"DELETE SOACTIVITY TEMP" :1];
     //Creating Sql string delete temporary record already created
    _deleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE 1"];
    [objServiceManagementData excuteSqliteQryString:_deleteSQl :objServiceManagementData.serviceReportsDB :@"DELETE SOASAPRES TEMP" :1];
    //Create sql string to delete records from fault table
   _deleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCCNFRMTNFAULT20 WHERE 1"];
    [objServiceManagementData excuteSqliteQryString:_deleteSQl :objServiceManagementData.serviceReportsDB :@"DELETE SOFAULT TEMP" :1];
   
    
	
	for(int i=0;i<[objServiceManagementData.serviceOrderActivityArray count];i++)
	{
		BOOL innerFlag = FALSE;
		NSString *searchStr = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:i] objectForKey:@"OBJECT_ID"];	
		objServiceManagementData.ACTIVITY_NUMBER_EXT = [[objServiceManagementData.serviceOrderActivityArray objectAtIndex:i] objectForKey:@"NUMBER_EXT"];	
		objServiceManagementData.objectiveID = searchStr;
		
        
        
		for(int k=0;k<[objServiceManagementData.serviceOrderConfirmationArray count];k++)
		{
			NSString *serviceOrderConfirmationArrayStr = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:k] objectForKey:@"SRCDOC_OBJECT_ID"];
			NSString *serviceOrderConfirmationNumberExt = [[objServiceManagementData.serviceOrderConfirmationArray objectAtIndex:k] objectForKey:@"NUMBER_EXT"];
			if([searchStr isEqualToString:serviceOrderConfirmationArrayStr] && [objServiceManagementData.ACTIVITY_NUMBER_EXT isEqualToString: serviceOrderConfirmationNumberExt])
			{
				innerFlag = TRUE;
				break;
			}
		}
		
		if(innerFlag == FALSE)
		{
			NSString *tempStr = [NSString stringWithFormat:@"checkbox%d",i];
			

			if([[self.checkBoxValueDictionary objectForKey:tempStr] boolValue] == YES)
			{
				flag = TRUE;
				break;
			}
			else 
			{
				flag = FALSE;
			}
		}		
	}
	
	if(flag == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Warning!"
							  message:@"Please select an item to proceed!" 
							  delegate:self 
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release], alert = nil;
	}
	else {
		//Retrieving activity data's from Sqlite ...before making the arry is empty...
		//[objServiceManagementData.serviceOrderSelectedActivityArray removeAllObjects];	
		//[objServiceManagementData fetchAndUpdateServiceOrderActivity:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@ AND NUMBER_EXT = %@",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:0],objServiceManagementData.objectiveID,objServiceManagementData.ACTIVITY_NUMBER_EXT]:-2];
        
        [objServiceManagementData.serviceOrderSelectedActivityArray removeAllObjects];	
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@ AND NUMBER_EXT = %@",[objServiceManagementData.dataTypeArray objectAtIndex:13],objServiceManagementData.objectiveID,objServiceManagementData.ACTIVITY_NUMBER_EXT];
        objServiceManagementData.serviceOrderSelectedActivityArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SO SELECTED ACTIVITY" :2]; 

 		
		ServiceConfCreation *objServiceConfCreation = [[ServiceConfCreation alloc] initWithNibName:@"ServiceConfCreation" bundle:nil];
		[self.navigationController pushViewController:objServiceConfCreation animated:YES];
		[objServiceConfCreation release], objServiceConfCreation = nil;
	}

	[objServiceManagementData.faultDataDictionary removeAllObjects];
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.activeFaultSegmentIndexFlag = 0;	
	printf("pressedAddNewConfirmationButton");
}

 

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[myTableView release], myTableView = nil;
	[displayServiceOrder release], displayServiceOrder = nil;
		[isAnyCheckboxSelectedArray release], isAnyCheckboxSelectedArray = nil;
}


@end

