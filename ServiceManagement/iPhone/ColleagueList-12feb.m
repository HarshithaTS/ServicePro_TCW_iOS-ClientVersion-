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
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "CustomAlertView.h"
#import "TouchXML.h"
#import "ServiceManagementData.h"
#import "CheckedNetwork.h"
#import "ColleagueTaskList.h"
#import "ServiceOrders.h"
CustomAlertView *customAlt;

@implementation ColleagueList


@synthesize buttonCancel;
@synthesize tableViewColleague;

@synthesize loadingImgView;
@synthesize actView;
//@synthesize partnerId;
@synthesize rowIndex;
@synthesize object_id;

@synthesize sBar;
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
		
		if([self.dubArrayList count]>0 && [self.sBar.text length]>0)
		{
			self.searching = YES;
			[self searchTableView];
		}		
	}
	
	[self.tableViewColleague reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Added bar button to get the alert while back from this page..
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    if ([delegate.colleagueAction isEqualToString:@"ChangeColleague"])
        self.title = @"Tasks for which Rep?";
    else if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
       self.title = @"Transfer task to...";
    

    //Creating search bar instance..
	self.sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00, 320.00, 42.00)];
	self.sBar.delegate = self;
	self.sBar.placeholder = @"Search Rep..";
	[self.view addSubview:sBar];
	self.searching = NO;
	self.searchHaldleFlagWhenBack = NO;
	self.dubArrayList = [[NSMutableArray alloc] init];
    
    //Added back bar button
	UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick)];
	self.navigationItem.leftBarButtonItem = barBackButton;
	[barBackButton release], barBackButton = nil;
    
    
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
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	[searchArray addObjectsFromArray:objServiceManagementData.colleagueListArray];	
	
	for (int i=0; i<[searchArray count]; i++) {
		
		//If 'searchText' is found in 'TASK_SEARCH_STRING' then add object in dubArrayList...
		if([[[searchArray objectAtIndex:i] objectForKey:@"SEARCH_STRING"] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)		
		{			
			[self.dubArrayList addObject:[searchArray objectAtIndex:i]];
		}
	}	
	
	[searchArray release], searchArray = nil;
	
}



#pragma mark -
#pragma mark UITableViewDelegate


// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

	/*UIViewController *targetViewController = [[objServiceManagementData.colleagueListArray objectAtIndex: indexPath.row] objectForKey:kViewControllerKey];
	[[self navigationController] pushViewController:targetViewController animated:YES];*/
  
    NSLog(@"COLLEAGUE LIST ARRAY %@",objServiceManagementData.colleagueListArray);
    
    partnerId = [NSString stringWithFormat:@"BBPT_OM_PARTNERS[.]%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"PARTNER"]];
    delegate.taskTranTo = [NSString stringWithFormat:@"%@",
                           [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"PARTNER"]];
    
    delegate.colleagueName = [NSString stringWithFormat:@"%@ %@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME1"],
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"MC_NAME2"]];
    delegate.colleagueTelNo = [NSString stringWithFormat:@"%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"TEL_NO"]];
    delegate.colleagueTelNo2 = [NSString stringWithFormat:@"%@",
                      [[objServiceManagementData.colleagueListArray objectAtIndex:indexPath.row] objectForKey:@"TEL_NO2"]];
    
    
 
    NSLog(@"%@",delegate.taskTranFrom);
    
    NSString *mColleagueName = [NSString stringWithFormat:@"Are you sure you want to transfer task to:%@",delegate.colleagueName];
    self.mIndexPath = indexPath;
    
    if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
    {
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
    customAlt = [[CustomAlertView alloc] init];
    [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
    
    
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {   
        
        if ([delegate.colleagueAction isEqualToString:@"ChangeColleague"])
            //download colleagues tasks
            if ([self getColleagueTaskListDownloadFromSAP])
            {
                //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
                [actView stopAnimating];
                [actView removeFromSuperview];
                [actView release];
                [loadingImgView removeFromSuperview];
                [loadingImgView release];
                
                ColleagueTaskList *objColleagueTaskList = [[ColleagueTaskList alloc] initWithNibName:@"ColleagueTaskList" bundle:nil];
                [self.navigationController pushViewController:objColleagueTaskList animated:YES];
                [objColleagueTaskList release],objColleagueTaskList = nil;
                
            }
            else
            {
                
                UIAlertView *alert1 = [[UIAlertView alloc] 
                                      initWithTitle:NSLocalizedString(@"AppDelegate_taskChecking_alert_title",@"")
                                      message:NSLocalizedString(@"AppDelegate_taskChecking_alert_msg",@"")
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"AppDelegate_taskChecking_alert_cancel_title",@"") 
                                      otherButtonTitles:nil];
                [alert1 show];
                [alert1 release];
                
                
                self.view.userInteractionEnabled = TRUE;
                [self.tableViewColleague deselectRowAtIndexPath:indexPath animated:YES]; 
            }
        
        
        else if ([delegate.colleagueAction isEqualToString:@"TransferColleague"])
            {
                [self transferColleagueTaskList];
                
                /*
                if ([self transferColleagueTaskList]) {
                    //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
                    [actView stopAnimating];
                    [actView removeFromSuperview];
                    [actView release];
                    [loadingImgView removeFromSuperview];
                    [loadingImgView release];
                    
                    
                    
                    ServiceOrders *objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
                    [self.navigationController pushViewController:objServiceOrders animated:YES];
                    [objServiceOrders release];
                    objServiceOrders = nil;
                }
                else
                {
                   UIAlertView *alert2 = [[UIAlertView alloc] 
                                          initWithTitle:NSLocalizedString(@"AppDelegate_dataChecking_alert_title",@"")
                                          message:NSLocalizedString(@"AppDelegate_dataChecking_alert_msg",@"")
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"AppDelegate_dataChecking_alert_cancel_title",@"") 
                                          otherButtonTitles:nil];
                    [alert2 show];
                    [alert2 release];
     
                     //self.view.userInteractionEnabled = TRUE;
                    //[self.tableViewColleague deselectRowAtIndexPath:indexPath animated:YES]; 
                }*/
                
                
            }
    }
    else {			
        [actView stopAnimating];
        [actView removeFromSuperview];
        [actView release];
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
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	return [objServiceManagementData.colleagueListArray count];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"Cell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
	}
	if(self.searching) //while searching... 
	{	
        kTitleKey = [NSString stringWithFormat:@"%@ - %@ %@",
                     [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PARTNER"],
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
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//[objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];
	
    
    NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNTTRNSFR21[.]%@[.]ZFSO[.]%@",delegate.taskTranFrom, delegate.taskTranTo];
    
    NSLog(@"str %@",strPar5);
    
    
    
    
    
    //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
    responseValue = [CheckedNetwork getResponseFromSAP:[NSMutableArray arrayWithObjects:@"DATA-TYPE[.]ZGSXSMST_SRVCDCMNTTRNSFR21[.]OBJECT_ID[.]PROCESS_TYPE[.]SERVICE_EMPLOYEE",strPar5, nil] :@"SERVICE-DOX-TRANSFER":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
    
    
    //responseValue = [gss_ServiceProWebService sendRequestSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
    
    //if ( [responseValue isEqualToString:@"555-Success"] )
    
   
    //Stoping the Animation for Action View "Processing Controller" - Start
    
    [actView stopAnimating];
    [actView removeFromSuperview];
    [actView release];
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
        
        
        //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
        
    }
	    
	
}

//Delegate for UIAlert Box - Start



//Delegate for UIAlert Box - End


//Donwloading serivice order confirmation data from SAP..
-(BOOL) getColleagueTaskListDownloadFromSAP
{
	BOOL localVar = FALSE;
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//[objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];	
    
    
    //Delete any data in colleague task list table
    NSString *sqlQueryString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:11]];
    //[objServiceManagementData executeSqlliteQueryString:sqlQueryString:objServiceManagementData.serviceReportsDB];

    [objServiceManagementData excuteSqliteQryString:sqlQueryString:objServiceManagementData.serviceReportsDB:@"UPDATE TASK":1];
    
    
    NSLog(@"PARTNER ID %@",partnerId);
    
	//Calling Soap servive
	
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:delegate.service_url];
	binding.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:ios:APPLICATION-ID:SERVICEPRO";
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par3.Cdata = @"EVENT[.]SERVICE-DOX-FOR-COLLEAGUE-GET[.]VERSION[.]0";	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par4 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par4.Cdata =  partnerId;	
    
    
	//Passing parameters in soap service
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par3];			
    [objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par4];
    
    
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01;		
	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
	
	
	//Get the response here, and create CXMLDocument object for parse the response
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp.getResponseData options:0 error:nil];	
	
	
    //Sarted to parsing the response...
	NSArray *nodes = NULL;
	nodes = [doc nodesForXPath:@"//DpostOtpt" error:nil];
    
	for(CXMLDocument *node in nodes)
	{
		for(CXMLNode *childNode in [node children])
		{
			if([[childNode name] isEqualToString:@"item"])
			{				
				for(CXMLNode *childNode2 in [childNode children])
				{					
					if([childNode2 stringValue]!=nil)
					{
						NSArray *getArrayAfterSplit = [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"];	
						                        
						if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:0]])
						{
							
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.self.ZGSCSMST_SRVCDCMNT01FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.self.ZGSCSMST_SRVCDCMNT01FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.self.ZGSCSMST_SRVCDCMNT01FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}

                             
                            
							//Insert data in to Sqlite..
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:11],tempFiledStr,tempValueStr];
							
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];	
                            
                            
                            localVar = TRUE;
                            
                            NSLog(@"sql query %@", sqlQuery);
						}
                        
					}					
				}
			}
			else {
				localVar = FALSE;
			}
		}
	}
	/*SELVAN*/
	//Retrieving other rep tasks
	[objServiceManagementData.colleagueTaskListArray removeAllObjects];	
	//[objServiceManagementData  fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCDCMNT01_COLLEAGUE WHERE 1"]:-2];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCDCMNT01_COLLEAGUE WHERE 1"];
    objServiceManagementData.colleagueTaskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"COLLEAGUE TASKLIST" :1];
    
    
    
    [objServiceManagementData.taskListArray removeAllObjects];
    NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
    objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :1];
    
    


	
      
    
    
	return localVar;
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
