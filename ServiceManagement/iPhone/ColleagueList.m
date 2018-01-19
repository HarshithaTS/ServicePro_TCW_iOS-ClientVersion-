//
//  ColleagueList.m
//  ServiceManagement
//
//  Created by gss on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColleagueList.h"
#import "AppDelegate_iPhone.h"
#import "ServiceManagementData.h"
/*--this header file for SOAP call--*/
//#import "Z_GSSMWFM_HNDL_EVNTRQST00Svc.h"
#import "CustomAlertView.h"
#import "TouchXML.h"
#import "ServiceManagementData.h"
#import "CheckedNetwork.h"
#import "ColleagueTaskList.h"
#import "ServiceOrders.h"
#import "iOSMacros.h"

CustomAlertView *customAlt;

@implementation ColleagueList


@synthesize buttonCancel;
@synthesize tableViewColleague;

@synthesize loadingImgView;
@synthesize actView;
//@synthesize partnerId;
@synthesize rowIndex;
@synthesize object_id;

//@synthesize sBar;
@synthesize searching;
@synthesize dubArrayList;
@synthesize searchHaldleFlagWhenBack;

@synthesize alert;
@synthesize mIndexPath;

NSString *kTitleKey;
NSString *kExplainKey;
static NSString *kCellIdentifier = @"MyIdentifier";
//static NSString *kViewControllerKey = @"viewController";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//This function will call when back from the pushed viewcontroller..
-(void)viewWillAppear:(BOOL)animated
{
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	
	if(delegate.modifySearchWhenBackFalg)
	{
		delegate.modifySearchWhenBackFalg = FALSE;
		
		if([self.dubArrayList count]>0 && [sBar.text length]>0)
		{
			self.searching = YES;
			[self searchTableView];
		}		
	}
	
	//[self.tableViewColleague reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view from its nib.
    //Added bar button to get the alert while back from this page..
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    if ([delegate.colleagueAction isEqualToString:@"ChangeColleague"])
        self.title = @"Tasks for which Rep?";
    else if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
       self.title = @"Transfer task to...";
    
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.font = [UIFont systemFontOfSize:18];
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    [tlabel release],tlabel =nil;
    //end

    //Creating search bar instance..
    
    
	if(IS_IPHONE)
    sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00, 320.00, 42.00)];
    else
    sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00,768.00, 42.00)];
        
	sBar.delegate = self;
	sBar.placeholder = @"Search Rep..";
	[self.view addSubview:sBar];
	self.searching = NO;
	self.searchHaldleFlagWhenBack = NO;
	self.dubArrayList = [[NSMutableArray alloc] init];
    
    //Added back bar button
	UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];

    if ([SYSTEM_VERSION floatValue] >= 7.0)
        barBackButton.tintColor = [UIColor whiteColor];
	
    self.navigationItem.leftBarButtonItem = barBackButton;

	[barBackButton release], barBackButton = nil;
    
    
    //Service Management - Allocating Memory 
    objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    //Message Box Status
    Msg_Box_Sts = Nil;
    

}

//Send back service confirmation activity screen
-(void)cancelButtonClick
{
    
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//Delegate function of search bar...called when search string changed..

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
    if([searchText length] > 0) {
		self.searching = YES;		
		[self searchTableView];
	}
	else{
		self.searching = NO;
	}
	
	[self.tableViewColleague reloadData];
}



//This is also Delegate function of search bar...called when search button will clicked...
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	if([theSearchBar.text isEqualToString:sBar.text])
		[theSearchBar resignFirstResponder];
	else
		[self searchTableView];
}

//calling when searching is TRUE..
- (void) searchTableView {
	
	[self.dubArrayList removeAllObjects];
	
    NSString *searchText = sBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
    [searchArray addObjectsFromArray:objServiceManagementData.colleagueListArray];
	
    NSLog(@"The Value is %@",objServiceManagementData.colleagueListArray);
    
	for (int i=0; i<[searchArray count]; i++) {
		
        NSString *UName = [NSString stringWithFormat:@"%@ %@",[[searchArray objectAtIndex:i] objectForKey:@"MC_NAME1"],[[searchArray objectAtIndex:i] objectForKey:@"MC_NAME2"]];
        
        
		if([UName rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)
		{
			[self.dubArrayList addObject:[searchArray objectAtIndex:i]];
		}
        
        UName = Nil;
	}
	
	[searchArray release], searchArray = nil;
	
}

#pragma mark -
#pragma mark UITableViewDelegate


// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

	/*UIViewController *targetViewController = [[objServiceManagementData.colleagueListArray objectAtIndex: indexPath.row] objectForKey:kViewControllerKey];
	[[self navigationController] pushViewController:targetViewController animated:YES];*/
  
    NSLog(@"COLLEAGUE LIST ARRAY %@",objServiceManagementData.colleagueListArray);
    
    
    
    if(self.searching)
    {
        partner_UName = [NSString stringWithFormat:@"SWDTUSER[.]%@",
                         [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"UNAME"]];
        delegate.taskTranTo = [NSString stringWithFormat:@"%@",
                               [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PARTNER"]];
        
        delegate.colleagueName = [NSString stringWithFormat:@"%@ %@",
                                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"MC_NAME1"],
                                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"MC_NAME2"]];
        delegate.colleagueTelNo = [NSString stringWithFormat:@"%@",
                                   [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"TEL_NO"]];
        delegate.colleagueTelNo2 = [NSString stringWithFormat:@"%@",
                                    [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"TEL_NO2"]];
        
        
    }
    else {
    
    
    partner_UName = [NSString stringWithFormat:@"SWDTUSER[.]%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"UNAME"]];
    delegate.taskTranTo = [NSString stringWithFormat:@"%@",
                           [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"PARTNER"]];
    
    delegate.colleagueName = [NSString stringWithFormat:@"%@ %@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME1"],
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME2"]];
    delegate.colleagueTelNo = [NSString stringWithFormat:@"%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"TEL_NO"]];
    delegate.colleagueTelNo2 = [NSString stringWithFormat:@"%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"TEL_NO2"]];
    }
    
 
    NSLog(@"%@",delegate.taskTranFrom);
    
   
    self.mIndexPath = indexPath;
    
    if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
    {
       
         NSString *mColleagueName = [NSString stringWithFormat:@"Are you sure you want to transfer task to:%@",delegate.colleagueName];
        
        //Alert while try to delete...
	   alert = [[UIAlertView alloc] initWithTitle:@"Colleague Transfer Alert" 
									   message:mColleagueName
									  delegate:self 
							 cancelButtonTitle:NSLocalizedString(@"Cancel",@"")											
							 otherButtonTitles:NSLocalizedString(@"Yes",@""),
			 nil];
	   alert.tag = 10; //Set the tag to tack, which alert is clicked..
	   [alert show];
    }
    else
    [self callSAPDownload:indexPath];

        
    
}

//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    [customAlt removeAlertForView];
    
    if(Msg_Box_Sts == Nil) {
    
    if(buttonIndex==1)
    {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert release];
        [self callSAPDownload:self.mIndexPath];

    }
        
    }
    else
    {
        
        if(Msg_Box_Sts)
        {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
        }
            
        
        
        Msg_Box_Sts=Nil;
    }
			
}


-(void) callSAPDownload:(NSIndexPath *) indexPath {
    

    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    self.view.userInteractionEnabled = FALSE;
    
    float _screenWidth = self.view.frame.size.width;
    float _screenHieght = self.view.frame.size.height;

    
    
    customAlt = [[CustomAlertView alloc] init];
    
    
    if (IS_IPAD) {
        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    }
    else {
        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    }

    
    
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {   
     
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        
        if ([delegate.colleagueAction isEqualToString:@"ChangeColleague"])
        [self getColleagueTaskListDownloadFromSAP];
        
        else if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
        [self transferColleagueTaskList];
                
    }
    else {
        
        [customAlt removeAlertForView];
        [customAlt release], customAlt = nil;
        
        [loadingImgView removeFromSuperview];	
        [loadingImgView release];
        self.view.userInteractionEnabled = TRUE;
        
        UIAlertView *alert3 = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_title",@"")
                              message:NSLocalizedString(@"AppDelegate_netChecking_alert_msg",@"")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"") 
                              otherButtonTitles:nil];
        [alert3 show];
        [alert3 release];
        [self.tableViewColleague deselectRowAtIndexPath:indexPath animated:YES]; 
    }	
}




#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    if(self.searching)
        return [dubArrayList count];
    
	return [objServiceManagementData.colleagueListArray count];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"Cell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
	}
	if(self.searching) //while searching... 
	{	
        kTitleKey = [NSString stringWithFormat:@"%@ %@",
                     [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"MC_NAME1"],
                     [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"MC_NAME2"]];
        
        kExplainKey = [NSString stringWithFormat:@"Plant:%@  Storage Loc:%@",
                       [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PLANT"],
                       [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STORAGE_LOC"]];
    }
    else
    {

        kTitleKey = [NSString stringWithFormat:@"%@ %@",
                     [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME1"],
                     [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME2"]];
                     
        kExplainKey = [NSString stringWithFormat:@"Plant:%@  Storage Loc:%@",
                     [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"PLANT"],
                       [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"STORAGE_LOC"]];
    }
    
    
    cell.textLabel.text = kTitleKey;
    cell.detailTextLabel.text = @"";
    
    

	return cell;
}

//Donwloading serivice order confirmation data from SAP..
-(void) transferColleagueTaskList
{
	
    NSString *responseValue;
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    	
    NSString *strMetaData = [NSString stringWithFormat:@"DATA-TYPE[.]ZGSXSMST_SRVCDCMNTTRNSFR20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]SERVICE_EMPLOYEE"];
    
    NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNTTRNSFR20[.]%@[.]%@[.]%@[.]%@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                         delegate.taskTranTo];
    
    
    NSLog(@"str %@",strPar5);
    
    //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
    responseValue = [CheckedNetwork getResponseFromSAP:[NSMutableArray arrayWithObjects:strMetaData,strPar5, nil] :@"SERVICE-DOX-TRANSFER":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
    
    
    //responseValue = [gss_ServiceProWebService sendRequestSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
    
    //if ( [responseValue isEqualToString:@"555-Success"] )
    
   
    //Stoping the Animation for Action View "Processing Controller" - Start
    
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
    self.view.userInteractionEnabled = TRUE;

    [loadingImgView removeFromSuperview];
    [loadingImgView release];
    
    
    //End ==========

    
    
    if (delegate.mErrorFlagSAP) {
        
        
        
        Msg_Box_Sts=FALSE;
         
        
    }
    else
    {
        
        //Delete if any Declined SO in service order table
        NSString *soDltQry = [NSString stringWithFormat:
                              @"DELETE FROM '%@' WHERE OBJECT_ID='%@'",
                              [objServiceManagementData.dataTypeArray objectAtIndex:0],
                              [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        //[objServiceManagementData deleteDataFromServiceManagmentDB:soDltQry];
        
        [objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.serviceReportsDB :@"DELETE Trasfer Service Tasks":0];
        
        
        [objServiceManagementData.taskListArray removeAllObjects];
        NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
        objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :1];
        
        
        Msg_Box_Sts=TRUE;
        
        UIAlertView *errAlert = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                                 message:responseValue
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                 otherButtonTitles:nil];
        [errAlert show];
        errAlert.tag = 4;
        [errAlert release];
        
    }
	    
	
}

//Donwloading serivice order confirmation data from SAP..
-(void) getColleagueTaskListDownloadFromSAP
{
    
    NSString *responseValue;
    
    
    NSLog(@"The Partner UName is;%@",partner_UName);
    
    
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
   //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    //Delete any data in colleague task list table
    NSString *sqlQueryString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:11]];
    [objServiceManagementData excuteSqliteQryString:sqlQueryString :objServiceManagementData.serviceReportsDB :@"Deleting Table Data" :0];
    
    
    //Sending Request to SAP for Getting Colleague List
    responseValue = [CheckedNetwork getResponseFromSAP:[NSMutableArray arrayWithObjects:partner_UName, nil] :@"SERVICE-DOX-FOR-COLLEAGUE-GET":objServiceManagementData.serviceReportsDB:2:@"GETDATA"];
    
    
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
    self.view.userInteractionEnabled = TRUE;

    [loadingImgView removeFromSuperview];
    [loadingImgView release];
    
    
    //Assiging Value to Collegue List 
    [objServiceManagementData.colleagueTaskListArray  removeAllObjects];
    
    NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:11]];
    objServiceManagementData.colleagueTaskListArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :1];
    
    
    
    

    NSString *XIB_File_NAME=@"";
    
    if(IS_IPHONE)
    XIB_File_NAME = @"ColleagueTaskList";
    else
    XIB_File_NAME = @"ColleagueTaskList_IPad";
   
    
    ColleagueTaskList *objColleagueTaskList = [[ColleagueTaskList alloc] initWithNibName:XIB_File_NAME bundle:nil];
    [self.navigationController pushViewController:objColleagueTaskList animated:YES];
    [objColleagueTaskList release],objColleagueTaskList = nil;

    
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
