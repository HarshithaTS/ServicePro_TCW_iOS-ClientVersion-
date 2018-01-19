//
//  CompletedTasks.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompletedTasks.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
//#import "Z_GSSMWFM_HNDL_EVNTRQST00.h"
#import "TouchXML.h"
#import "ServiceManagementData.h"
#import "ViewCompletedTaskDetails.h"
#import "CompletedTaskDetails.h"
#import "CheckedNetwork.h"
#import "Constants.h"


@implementation CompletedTasks


@synthesize sBar,myTableView,mainArrayList,dubArrayList,searching;
@synthesize postingDateFlag;
@synthesize soldToPartyFlag;
@synthesize objectidFlag;
@synthesize loadingImgView;
@synthesize actView;

int selectedRow;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	kvcPreviewScrollViewHeight = 30.0f;

	
	self.title = NSLocalizedString(@"Task Overview", @"");
    
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    [tlabel release],tlabel =nil;
    //end

	[self callSAPDownloadMethod];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager]; 
	[objServiceManagementData.taskListArray removeAllObjects];
	[objServiceManagementData fetchAndUpdateCompletedTaskList:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCRPRTDATA10 WHERE 1"]:-1];
	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"POSTING_DATE" 
																   ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    objServiceManagementData.sortedArrayList = [objServiceManagementData.taskListArray sortedArrayUsingDescriptors:sortDescriptors];
    [sortDescriptor release];
	
	//NSString *s = [NSString stringWithFormat:@"%@",[[self.sortedArrayList objectAtIndex:0] objectForKey:@"OBJECT_ID"]];
	//NSLog(@"dfdfdf%@",s);
	
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
	
	// create sort bar button on header bar.	
	UIBarButtonItem *searchButton= [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(orderingTask:)];
	self.navigationItem.rightBarButtonItem = searchButton;
	[searchButton release];
	
	
	//Create table view
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 43.0, 430.0, 345.0) style:UITableViewStylePlain];
	myTableView.delegate=self;
	myTableView.dataSource=self;
	myTableView.scrollEnabled=TRUE;
	myTableView.alwaysBounceHorizontal = TRUE;
	
	[self.view addSubview:myTableView];
	
	//create search bar
	
	self.sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00, 320.00, 42.00)];
	self.sBar.delegate = self;
	self.sBar.placeholder =@"Search your task...";
	[self.view addSubview:sBar];
    
	self.searching = NO;
	//elf.searchHaldleFlagWhenBack = NO;
	self.dubArrayList = [[NSMutableArray alloc] init];
	
	[super viewDidLoad];
}

//calling while trying to back Service Orders (Task) list page
-(void) goBack
{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}




//The function will check network connection and call data download method
-(void) callSAPDownloadMethod
{
	
	/*MainMenu *objMainMenu = [[MainMenu alloc] initWithNibName:@"MainMenu" bundle:nil];
	 [mainController pushViewController:objMainMenu animated:YES];
	 [objMainMenu release];
	 */
	
	
	self.view.userInteractionEnabled = FALSE;
	
	actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	actView.frame = CGRectMake(145.0, 225.0, 35.0, 35.0);
	[actView startAnimating];
	
	loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
	loadingImgView.image = [UIImage imageNamed:@"login-activity.png"];
	[loadingImgView addSubview:actView];
	[self.view addSubview:loadingImgView];
	
	if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
	{
		if([self downloadDataFromSAP]) // Calling the function where downloading all the Task list from SAP	
		{	
			//If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
			[actView stopAnimating];
			[actView removeFromSuperview];
			[actView release];
			[loadingImgView removeFromSuperview];
			[loadingImgView release];
			
			self.view.userInteractionEnabled = TRUE;
			
			//MainMenu *objMainMenu = [[MainMenu alloc] initWithNibName:@"MainMenu" bundle:nil];
			//[mainController pushViewController:objMainMenu animated:YES];
			//[objMainMenu release];
		}
		else {
			printf("NO data found");
		}
	}
	else {			
		[actView stopAnimating];
		[actView removeFromSuperview];
		[actView release];
		[loadingImgView removeFromSuperview];	
		[loadingImgView release];
		self.view.userInteractionEnabled = TRUE;
		
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_title",@"")
							  message:NSLocalizedString(@"AppDelegate_netChecking_alert_msg",@"")
							  delegate:self
							  cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"") 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}		
	
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[myTableView reloadData];
}

-(IBAction)orderingTask:(id)sender
{
	UIActionSheet *orderTaskActionSheet = [[UIActionSheet alloc] 
										   initWithTitle:NSLocalizedString(@"Completed_ActionSheet_Order_Task_List_title",@"") 
										   delegate:self 
										   cancelButtonTitle:NSLocalizedString(@"Completed_ActionSheet_Order_Task_List_Cancel_title",@"")  
										   destructiveButtonTitle:NSLocalizedString(@"Completed_ActionSheet_Order_Task_List_Date",@"") 
										   otherButtonTitles:NSLocalizedString(@"Completed_ActionSheet_Order_Task_List_Soid",@""),
										   NSLocalizedString(@"Completed_ActionSheet_Order_Task_List_Customer",@"")
										   ,nil];
	
	orderTaskActionSheet.tag = 1;
	[orderTaskActionSheet showInView:self.view];
	[orderTaskActionSheet release], orderTaskActionSheet = nil;
}

//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//EditTask *objEditTask;
	
	//TaskLocationMapView *objTaskLocationMapView;
	
	
	if([sBar isFirstResponder])
		[sBar resignFirstResponder];
	
	if(actionSheet.tag == 1) //This action sheet for ordering the task...
	{
		//NSString *orderByStr = @"";
		NSSortDescriptor *aSortDescriptor;
		
		switch (buttonIndex) {
			case 0:	
				if(self.postingDateFlag == TRUE)
				{
					//orderByStr = @"DESC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"POSTING_DATE" ascending:NO];
					self.postingDateFlag = FALSE;
				}
				else {		
					//orderByStr = @"ASC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"POSTING_DATE" ascending:YES];
					self.postingDateFlag = TRUE;
				}
				
				if(self.searching)
					[self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				else 
					[objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				
				//[objServiceManagementData.taskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY ZZKEYDATE %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
				
				break;
			case 1:				
				if(self.objectidFlag == TRUE)
				{
					//orderByStr = @"DESC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OBJECT_ID" ascending:NO];
					self.objectidFlag = FALSE;
				}
				else {		
					//orderByStr = @"ASC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OBJECT_ID" ascending:YES];
					self.objectidFlag = TRUE;
				}
				
				if(self.searching)
					[self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				else 
					[objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				
				//[objServiceManagementData.taskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY PRIORITY %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
				
				break;	
			case 2:			
				if(self.soldToPartyFlag == TRUE)
				{
					//orderByStr = @"DESC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SOLD_TO_PARTY_LIST" ascending:NO];
					self.soldToPartyFlag = FALSE;
				}
				else {		
					//orderByStr = @"ASC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SOLD_TO_PARTY_LIST" ascending:YES];
					self.soldToPartyFlag = TRUE;
				}
				
				if(self.searching)
					[self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				else 
					[objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				//[objServiceManagementData.taskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY STATUS %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
				
				break;
				
		}
		
		
		[self.myTableView reloadData];
		
		NSLog(@"taskListArray count=%d",[objServiceManagementData.taskListArray count]);
	}
	
}

-(BOOL)downloadDataFromSAP
{	
	/* commented by selvan for webservice changes
	
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:@"http://75.99.152.10:8050/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/110/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00"];	
	binding.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	//par1.Cdata = @"DEVICE-ID:123456783648138:DEVICE-TYPE:BB";
	
	par1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO";
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	//par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	//par3.Cdata = @"EVENT[.]SERVICE-REPORT-COMPLETED-ORDERS[.]VERSION[.]0";
	par3.Cdata = @"EVENT[.]SERVICE-REPORT-COMPLETED-ORDERS[.]VERSION[.]0";	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par3];	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01;	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
	
	//NSString *str = @"<?xml version=\"1.0\"?><soap-env:Envelope xmlns:soap-env=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap-env:Header/><soap-env:Body><n0:ZGssmwfmHndlEvntrqst00Response xmlns:n0=\"urn:sap-com:document:sap:soap:functions:mc-style\"><DpostMssg/><DpostOtpt><item><Cdata>NOTATION:ZML:VERSION:0:DELIMITER:[.]</Cdata></item></DpostOtpt></n0:ZGssmwfmHndlEvntrqst00Response></soap-env:Body></soap-env:Envelope>";
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp.getResponseData options:0 error:nil];
	//CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[NSMutableData dataWithLength:[str length]] options:0 error:nil];
	
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//Commented by selvan
	//[objServiceManagementData createEditableCopyOfDatabaseIfNeeded];	
	
	//Create table if not exists
	//NSString *qry = [NSString stringWithFormat:@"%@", @"CREATE TABLE IF NOT EXISTS ZGSCSMST_SRVCRPRTDATA10 (OBJECT_ID TEXT PRIMARY KEY,PROCESS_TYPE TEXT,PROCESS_TYPE_TXT TEXT,SOLD_TO_PARTY_LIST TEXT,SOLD_TO_PARTY TEXT,CONTACT_PERSON_LIST TEXT,NET_VALUE TEXT,CURRENCY TEXT,PRIORITY_TXT TEXT,DESCRIPTION TEXT,PO_DATE_SOLD TEXT,CREATED_BY TEXT,CONCATSTATUSER TEXT,POSTING_DATE TEXT,WRK_START_DATE TEXT,WRK_END_DATE TEXT,HRS_LABOR TEXT,HRS_TRAVEL TEXT,HRS_TOTAL TEXT,EQUIP_NO TEXT,REQ_START_DT TEXT)"];
	//[objServiceManagementData createTableNamed:qry];
	
	//Delete Existing Records from table
	//NSString *sqlDeleteQuery = [NSString stringWithFormat:@"DELETE FROM %@",[objServiceManagementData.cDataTypeArray objectAtIndex:0]];
	//NSLog(@"%@",sqlDeleteQuery);
	//[objServiceManagementData deleteDataFromServiceManagmentDB:sqlDeleteQuery];	
	//end
	
	
	NSArray *nodes = NULL;
	nodes = [doc nodesForXPath:@"//DpostOtpt" error:nil];
	
	for(CXMLDocument *node in nodes)
	{		
		//NSMutableArray *individualItemArray = [[NSMutableArray alloc] init];
		
		
		for(CXMLNode *childNode in [node children])
		{
			//NSLog(@"childNode=%@",[childNode name]);
			
			//NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
			
			if([[childNode name] isEqualToString:@"item"])
			{
				
				
				for(CXMLNode *childNode2 in [childNode children])
				{
					//NSLog(@"childNode2 name=%@",[childNode2 name]);
					//NSLog(@"childNode2 value=%@",[childNode2 stringValue]);
					
					if([childNode2 stringValue]!=nil)
					{
						NSArray *getArrayAfterSplit = [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"];						
						
						if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:@"ZGSCSMST_SRVCRPRTDATA10"])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCRPRTDATA10FieldArray count];i++)
							{
							tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCRPRTDATA10FieldArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCRPRTDATA10FieldArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",@"ZGSCSMST_SRVCRPRTDATA10",tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];							
						}
						
					}
					
					
					//if([[childNode2 name] isEqualToString:@"Cdata"])
					//[individualItemArray addObject:tempDictionary];
					
				}
			}
		}
		
		//[objServiceManagementData.taskListArray addObject:individualItemArray];
	}
	*/
	
	return TRUE;	
}

/*// Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source
-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue
{
	int countChar = cellLabelValue.length;
	
	if(countChar>90)
		return 78.0f;
	else if(countChar>70)
		return 68.0f;
	else if(countChar>45)
		return 58.0f;
	else
		return 43.0f;
	
	
}

-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay
{
	int countChar =  cellTextDisplay.length;
	
	if(countChar>90)
		return 65.0f;
	else if(countChar>70)
		return 60.0f;
	else if(countChar>45)
		return 50.0f;
	else
		return 35.0f;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	// Return the number of rows in the section.
	
	if(self.searching)
		return [self.dubArrayList count];
	else {		
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];    
		return [objServiceManagementData fetchTotalRecordsCount:objServiceManagementData.serviceReportsDB:@"ZGSCSMST_SRVCRPRTDATA10"];
		//return 42;
	}	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager]; 
	
	objServiceManagementData.taskId = indexPath.row;
	
	ViewCompletedTaskDetails *objViewCompletedTaskDetails = [[ViewCompletedTaskDetails alloc] initWithNibName:@"ViewCompletedTaskDetails" bundle:nil];
	//CompletedTaskDetails *objViewCompletedTaskDetails = [[CompletedTaskDetails alloc] initWithNibName:@"CompletedTaskDetails" bundle:nil];
	[self.navigationController pushViewController:objViewCompletedTaskDetails animated:YES];
	[objViewCompletedTaskDetails release], objViewCompletedTaskDetails = nil;
	
	
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	static NSString *identifier = @"MyCell";
	
	
	UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) 
		cell = [self reuseTableViewCellWithIdentifier:identifier];
	
	//Now instead of passing data to the text property of the cell.
	//We will get the label by tag and set data to the text property of the label
	
	//NSString *s = [NSString stringWithFormat:@"%@",[[sortedArrayList objectAtIndex:[indexPath row]] objectForKey:@"OBJECT_ID"]];
	//NSLog(@"dfdfdf%@",objServiceManagementData.sortedArrayList);
	
	if (self.searching) {
		UILabel *lbl = (UILabel *)[cell viewWithTag:NUMBER_TAG];
		lbl.text = [NSString stringWithFormat:@"%@ ", [[self.dubArrayList objectAtIndex:[indexPath row]] objectForKey:@"OBJECT_ID"]];
		lbl.font = [UIFont systemFontOfSize:13.0f];
		lbl.textColor = [UIColor blueColor];
		
		UILabel *lblText = (UILabel *)[cell viewWithTag:TEXT_TAG];
		lblText.text =  [[self.dubArrayList objectAtIndex:[indexPath row]] objectForKey:@"SOLD_TO_PARTY_LIST"];
		lblText.font = [UIFont systemFontOfSize:13.0f];
		lblText.numberOfLines = 3;
		lblText.adjustsFontSizeToFitWidth = YES;
		lblText.minimumFontSize = 8.0f;
		
		
		UILabel *lblDateText = (UILabel *)[cell viewWithTag:DATE_TAG];
		lblDateText.text = [[self.dubArrayList objectAtIndex:[indexPath row]] objectForKey:@"POSTING_DATE"];
		lblDateText.font = [UIFont systemFontOfSize:13.0f];
	}
	else {
		
		UILabel *lbl = (UILabel *)[cell viewWithTag:NUMBER_TAG];
		lbl.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.taskListArray objectAtIndex:[indexPath row]] objectForKey:@"OBJECT_ID"]];
		lbl.font = [UIFont systemFontOfSize:13.0f];
		lbl.textColor = [UIColor blueColor];
		
		UILabel *lblText = (UILabel *)[cell viewWithTag:TEXT_TAG];
		lblText.text =  [[objServiceManagementData.taskListArray objectAtIndex:[indexPath row]] objectForKey:@"SOLD_TO_PARTY_LIST"];
		lblText.font = [UIFont systemFontOfSize:13.0f];
		lblText.numberOfLines = 3;
		lblText.adjustsFontSizeToFitWidth = YES;
		lblText.minimumFontSize = 8.0f;
		
		
		UILabel *lblDateText = (UILabel *)[cell viewWithTag:DATE_TAG];
		lblDateText.text = [[objServiceManagementData.taskListArray objectAtIndex:[indexPath row]] objectForKey:@"POSTING_DATE"];
		lblDateText.font = [UIFont systemFontOfSize:13.0f];
	}
	
	
	
	
	CGRect tvbounds = [tableView bounds];
	[self.myTableView setBounds:CGRectMake(tvbounds.origin.x, 
										   tvbounds.origin.y, 
										   tvbounds.size.width, 
										   tvbounds.size.height)];
	
	//NSLog(@"width %f",tvbounds.size.width);	    
	
	// Configure the cell...
	
	//NSLog(@"%@",[[objServiceManagementData.taskListArray objectAtIndex:[indexPath row]] objectForKey:@"OBJECT_ID"]);
	
	
    return cell;
}

//customize the header title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
	//--display movie list as the header ---
	
	
	UILabel *HeaderLabel;
    HeaderLabel = [UILabel alloc];
	HeaderLabel.text = [NSString stringWithFormat:@"%@            %@        %@",@"Date",@"SO ID",@"Customer"];;
	HeaderLabel.textColor = [UIColor redColor];
	HeaderLabel.font = [UIFont systemFontOfSize:10.0f];
	[HeaderLabel autorelease];
	return HeaderLabel.text;
}

-(UITableViewCell *)reuseTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
	
	//Now we have to create the two labels.
	UILabel *label;
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(TEXT_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, TEXT_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	
	//Mark the label with a tag
	label.tag = TEXT_TAG;
	
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(NUMBER_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, NUMBER_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	
	label.numberOfLines = 3;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	
	//Mark the label with a tag
	label.tag = NUMBER_TAG;
	
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(DATE_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, DATE_WIDTH, LABEL_HEIGHT);
	
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	
	//Mark the label with a tag
	label.tag = DATE_TAG;
	
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	return cell;
}
#pragma mark -
#pragma mark searchBar delegate Methods
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	if([searchText length] > 0) {
		self.searching = YES;		
		[self searchTableView];
	}
	else{
		self.searching = NO;
	}
	
	[self.myTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	if([theSearchBar.text isEqualToString:sBar.text])
		[theSearchBar resignFirstResponder];
	else
		[self searchTableView];
}

- (void) searchTableView {
	
	[self.dubArrayList removeAllObjects];
	
    NSString *searchText = sBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	[searchArray addObjectsFromArray:objServiceManagementData.taskListArray];	
	
	
	for (int i=0; i<[searchArray count]; i++) {
		
		//NSLog(@"DISPLAY_DUE_DATE=%@",[[searchArray objectAtIndex:i] objectForKey:@"DISPLAY_DUE_DATE"]);
		
		if([[[searchArray objectAtIndex:i] objectForKey:@"TASK_SEARCH_STRING"] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)		
		{
			
			[self.dubArrayList addObject:[searchArray objectAtIndex:i]];
			
		}
	}	
	
	[searchArray release], searchArray = nil;
	
}

//End Search bar delegate 


/*
 - (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
 {
 }
 - (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
 {
 }
 - (void)viewWillDisappear:(BOOL)animated // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
 {
 }
 - (void)viewDidDisappear:(BOOL)animated
 {
 }
 
 */


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[myTableView release];
	
	[mainArrayList release];
	
}

@end
