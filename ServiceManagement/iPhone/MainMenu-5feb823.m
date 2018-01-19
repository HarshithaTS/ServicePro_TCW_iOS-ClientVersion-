//
//  MainMenu.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"


/*--this header file for SOAP call--*/
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"


#import "TouchXML.h"
#import "ServiceManagementData.h"

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>

#import <sqlite3.h>
#import "CheckedNetwork.h"
#import "getResponseFromSAPGeneric.h"

#import "ServiceOrders.h"
#import "AppDelegate_iPhone.h"
#import "CompletedTasks.h"
#import "VanStock.h"
#import "InstBaseReport.h"
#import "MyUtilization.h"
#import "BillableSO.h"
#import "GssInfoView.h"
#import "CustomAlertView.h"
#import "SignatureCapture.h"

#import "UIDevice+IdentifierAddition.h"

CustomAlertView *customAlt;



@implementation MainMenu


@synthesize window;
@synthesize mainController;

@synthesize service_url;

@synthesize loadingImgView, actView;
@synthesize modifySearchWhenBackFalg;

@synthesize activeFaultSegmentIndexFlag;
@synthesize activitySparesEditedFlag;

@synthesize attachmentImage;
@synthesize localImageFilePath;
@synthesize encryptedImageString;

@synthesize log;
@synthesize textView;
@synthesize textField;

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
	
    self.navigationItem.hidesBackButton = YES;
	self.navigationController.navigationBarHidden = NO;
	self.title = NSLocalizedString(@"Main_Menu_title",@"");
	
	//Searching Task related variable, when back edit task to task list page
	modifySearchWhenBackFalg = FALSE;
	
    
    
    self.navigationController.navigationBar.tintColor = [UIColor   
                                                         colorWithRed:50.0/255   
                                                         green:50.0/255   
                                                         blue:205.0/255   
                                                         alpha:1]; 

   // UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoGssInfoView:)];
    
    
    //Info View Button 
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:[UIImage imageNamed:@"info_btn.png"] forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,25,25);    
    
    [aButton addTarget:self action:@selector(gotoGssInfoView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = aBarButtonItem;
    
    
    [aButton release],aButton=Nil;
    [aBarButtonItem release],aBarButtonItem=Nil;
    
    //Show Image 
    UIImageView *right_App_Icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"36x36app-icon.png"]];
    right_App_Icon.frame = CGRectMake(2,5,36,29);
    
    
    //Text Label
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,250,40)];
    tmpTitleLabel.font = [UIFont boldSystemFontOfSize:25];
    tmpTitleLabel.text = NSLocalizedString(@"Main_Menu_title",@"");
    
    tmpTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    tmpTitleLabel.textColor = [UIColor whiteColor];
    tmpTitleLabel.backgroundColor = [UIColor clearColor];
    
    //Adding to UIView above Items 
    
    CGRect applicationFrame = CGRectMake(0, 0, 300, 40);
    UIView * newView = [[[UIView alloc] initWithFrame:applicationFrame] autorelease];
    [newView addSubview:right_App_Icon];
    [newView addSubview:tmpTitleLabel];
    self.navigationItem.titleView = newView;
    
    [right_App_Icon release],right_App_Icon=Nil;
    [tmpTitleLabel release],tmpTitleLabel=Nil;
    
   
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)gotoGssInfoView:(id)sender 
{
    GssInfoView *objGssInfoView = [[GssInfoView alloc] initWithNibName:@"GssInfoView" bundle:nil];
    [self.navigationController pushViewController:objGssInfoView animated:YES];
    
    [objGssInfoView release];
    
    
}

//Below six functions wiil call seperatly when pressed corresponding buttons

-(IBAction)gotoServiceOrders:(id)sender{
    
    NSString *responseValue;
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
    //[objServiceManagementData.taskListArray removeAllObjects];	
	
	//Gathering all the data in to task list array..after remove all the objects from tasklist array
	//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]]:-1];

    
      //Service Order List Input
     //Add Input Strings into nsmutablearray
    getInputArray = [[NSMutableArray alloc] init];
    
    
    //Show processing Alert to User
    self.view.userInteractionEnabled = FALSE;
    //customAlt = [[CustomAlertView alloc] init];
    //[self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
    
    
    float _screenWidth = self.view.frame.size.width;
    float _screenHieght = self.view.frame.size.height;
   
    
    NSLog(@"%f,%f",_screenWidth,_screenHieght);
    
    
    customAlt = [[CustomAlertView alloc] init];
    [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    
    //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
    responseValue = [CheckedNetwork getResponseFromSAP:getInputArray :@"SERVICE-DOX-FOR-EMPLY-BP-GET":objServiceManagementData.serviceReportsDB:1:@"GETDATA"];
    
    
    
    if ( ![responseValue isEqualToString:@"555-Success"] ){
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                          message:responseValue
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"") 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];

    }
    else {
        
        //colleague List Input
         //Add Input Strings into nsmutablearray
        getInputArray = [[NSMutableArray alloc] init];
 
        //If create db flag = 0 then no need to create new db or don't overwrite existing db
        responseValue = [CheckedNetwork getResponseFromSAP:getInputArray :@"SERVICE-COLLEAGUE-LIST":objServiceManagementData.serviceReportsDB:0:@"GETDATA"];
        
        if ( ![responseValue isEqualToString:@"555-Success"] ){
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                                  message:responseValue
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"") 
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];

        }
        
    }
    
    //Retrieving all service list data.
    [objServiceManagementData.taskListArray removeAllObjects];	
    //[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]]:-1];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
    objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVICE ORDER" :1]; 
    
    
    //Retrieving colleague data
    [objServiceManagementData.colleagueListArray removeAllObjects];	
    //[objServiceManagementData fetchColleagueList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:10]]:-1];
    
    sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:10]];
    objServiceManagementData.colleagueListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"COLLEAGUE LIST" :1]; 
    

    
    //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
    
    
    self.view.userInteractionEnabled = TRUE;
   
    
    /*ServiceOrders *objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
    [self.navigationController pushViewController:objServiceOrders animated:YES];
    [objServiceOrders release];*/
    ServiceOrders *objServiceOrders;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders_ipad" bundle:nil];
    }
    else{
        objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
        
    }
    [self.navigationController pushViewController:objServiceOrders animated:YES];
    [objServiceOrders release],objServiceOrders = nil;

}


-(IBAction)gotoCompletedTasks:(id)sender{
	CompletedTasks *objCompletedTasks = [[CompletedTasks alloc]  initWithNibName:@"CompletedTasks" bundle:nil];
	[self.navigationController pushViewController:objCompletedTasks animated:YES];
	[objCompletedTasks release];
}

-(IBAction)gotoVanStock:(id)sender{
	VanStock *objVanStock = [[VanStock alloc]  initWithNibName:@"VanStock" bundle:nil];
	[self.navigationController pushViewController:objVanStock animated:YES];
	[objVanStock release];
}

-(IBAction)gotoInstBaseReport:(id)sender{
	InstBaseReport *objInstBaseReport = [[InstBaseReport alloc]  initWithNibName:@"InstBaseReport" bundle:nil];
	[self.navigationController pushViewController:objInstBaseReport animated:YES];
}

-(IBAction)gotoMyUtilization:(id)sender{
	MyUtilization *objMyUtilization = [[MyUtilization alloc]  initWithNibName:@"MyUtilization" bundle:nil];
	[self.navigationController pushViewController:objMyUtilization animated:YES];
	[objMyUtilization release];
}

-(IBAction)gotoBillableSO:(id)sender{
	BillableSO *objBillableSO = [[BillableSO alloc]  initWithNibName:@"BillableSO" bundle:nil];
	[self.navigationController pushViewController:objBillableSO animated:YES];
	[objBillableSO release];
}
-(IBAction)gotoRestartApp:(id)sender{
    //AppDelegate_iPhone *delegate = [[AppDelegate_iPhone alloc] initWithNibName:@"AppDelegate_iPhone" bundle:nil];
    //[self.navigationController pushViewController:delegate animated:YES];
   // [delegate release];
}










































//*********************

//**********************
//**********************


    
    
//Downloading task lists from SAP
-(BOOL)downloadDataFromSAP1{	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

    
    
    //Get Device Type
    //UIDevice *myDevice = [UIDevice new];
    //NSString *deviceType = [myDevice model];
    NSLog(@"Unique Device Identifier:\n%@",
          [[UIDevice currentDevice] uniqueDeviceIdentifier]);
    
    NSLog(@"Unique GLOBAL Device Identifier:\n%@",
          [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]);
  
    //If phone device get IEMI ID
    
    //Other than phone device get deviceUDID
    //NSString *deviceUDID = [myDevice uniqueIdentifier];
    //NSLog(@"deviceUDID=%@",deviceUDID);

   /// NetworkController *ntc = [NetworkController sharedInstance];
   // NSString *imeistring = [ntc IMEI];

	//Calling Soap servive
	//SOAP Input Part
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:service_url];	
	binding.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
    par1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par3.Cdata = @"EVENT[.]SERVICE-DOX-FOR-EMPLY-BP-GET[.]VERSION[.]0";	
	
	
	//Passing parameters in soap service
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:par3];	
    //SOAP Input part end
    
    NSLog(@"objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01  %@",objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01);
    
    
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01;		

	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request];
	
	
	//Get the response here, and create CXMLDocument object for parse the response
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp.getResponseData options:0 error:nil];	
    
     
    
    //Sarted to parsing the response...
	NSArray *nodes = NULL;

    //Start - Selvan - 06/08/2012 Included sap response error check
    
    //First check the response contain any error message
	nodes = [doc nodesForXPath:@"//DpostMssg" error:nil];
    if ([nodes count] != 0) 
    {
   	for(CXMLDocument *node in nodes)
	{		
		//NSMutableArray *individualItemArray = [[NSMutableArray alloc] init];		
		
		for(CXMLNode *childNode in [node children])
		{
			//NSLog(@"childNode=%@",[childNode name]);	
           // NSLog(@"childNode value=%@",[childNode stringValue]);
			//NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
			
			if([[childNode name] isEqualToString:@"item"])
			{
				
				for(CXMLNode *childNode2 in [childNode children])
				{
					//NSLog(@"childNode2 name=%@",[childNode2 name]);
					//NSLog(@"childNode2 value=%@",[childNode2 stringValue]);
                    if ([[childNode2 name] isEqualToString:@"Type"]) {
                        if ([childNode2 stringValue] != nil) {
                            if ([[childNode2 stringValue] isEqualToString: @"E"]) {
                                objAppDelegate_iPHone.mErrorFlagSAP = TRUE;
                                
                                UIAlertView *alert = [[UIAlertView alloc] 
                                                      initWithTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_title",@"")
                                                      message:NSLocalizedString(@"AppDelegate_sapChecking_alert_msg",@"")
                                                      delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_cancel_title",@"") 
                                                      otherButtonTitles:nil];
                                [alert show];
                                [alert release];

                            }
                        }
                    }
                }
            }
        
        }
    }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_title",@"")
                              message:NSLocalizedString(@"AppDelegate_sapChecking_alert_msg",@"")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"AppDelegate_sapChecking_alert_cancel_title",@"") 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
 
        
    }

    //If errorflag is not true then create/re-create database to fetch data from sap server/ 
    //Even if server not responding, the app will show exist data from local database.
    if (!objAppDelegate_iPHone.mErrorFlagSAP) {
        //Create ServiceReport Database
        [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];	
        
        //Create ServiceOrderConfirmationDatabase
        [objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceOrderConfirmationListingDB];
    }

    //End - Selvan
    
    
    
    //Second check the response has any data
    nodes = [doc nodesForXPath:@"//DpostOtpt" error:nil];
	for(CXMLDocument *node in nodes)
	{		
		//NSMutableArray *individualItemArray = [[NSMutableArray alloc] init];		
		
		for(CXMLNode *childNode in [node children])
		{
			NSLog(@"childNode=%@",[childNode name]);	
            NSLog(@"childNode value=%@",[childNode stringValue]);
			//NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
			
			if([[childNode name] isEqualToString:@"item"])
			{
				
				for(CXMLNode *childNode2 in [childNode children])
				{
					NSLog(@"childNode2 name=%@",[childNode2 name]);
					NSLog(@"childNode2 value=%@",[childNode2 stringValue]);
					if([childNode2 stringValue]!=nil)
					{
						NSArray *getArrayAfterSplit = [[[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"[.]"];						
						
						NSLog(@" getArrayAfterSplit %@",[getArrayAfterSplit objectAtIndex:0]);
						NSLog(@" object 8 %@", [objServiceManagementData.dataTypeArray objectAtIndex:0]);
						
						if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:0]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCDCMNT01FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCDCMNT01FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCDCMNT01FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:0],tempFiledStr,tempValueStr];
                            
                           // NSLog(@"task list insert query %@", sqlQuery);
                            
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];	
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:1]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCACTVTYLIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCACTVTYLIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCACTVTYLIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:1],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];	
							
							
						} 
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:2]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_CAUSECODELIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_CAUSECODELIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_CAUSECODELIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:2],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];	
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:3]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_CAUSECODEGROUPLIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_CAUSECODEGROUPLIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_CAUSECODEGROUPLIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}							
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:3],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];								
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:4]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_PRBLMCODELIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_PRBLMCODELIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_PRBLMCODELIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:4],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];							
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:5]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_PRBLMCODEGROUPLIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:5],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
							
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:6]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SYMPTMCODELIST10FiledArray count];i++)
							{								
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SYMPTMCODELIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SYMPTMCODELIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:6],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
                            
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:7]])
						{							
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";							
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SYMPTMCODEGROUPLIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:7],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
							
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:8]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_EMPLYMTRLLIST10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_EMPLYMTRLLIST10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];	
								
								if(i<([objServiceManagementData.ZGSCSMST_EMPLYMTRLLIST10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
								
							}
                            
							//Inserting data into Sqlite DB
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:8],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];		
                            
                            NSLog(@"mtrl sql query %@", sqlQuery);
                            
						}
                        //Service Confirmation relates data start
                        else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:0]])
						{
							
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCACTVTY10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCACTVTY10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCACTVTY10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							//Insert data in to Sqlite..
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:0],tempFiledStr,tempValueStr];
							NSLog(@"%@",sqlQuery);
							
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceOrderConfirmationListingDB];	
							
							
						}
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:1]])
						{
                            
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCSPARE10FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCSPARE10FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCSPARE10FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Insert data in to Sqlite..
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:1],tempFiledStr,tempValueStr];
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceOrderConfirmationListingDB];	
							
							
						} 
						else if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:2]])
						{
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_SRVCCNFRMTN12FiledArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_SRVCCNFRMTN12FiledArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_SRVCCNFRMTN12FiledArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Insert data in to Sqlite..
                            NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:2],tempFiledStr,tempValueStr];

							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceOrderConfirmationListingDB];	
							
						}	
                        
                        //******Service Confirmation Related data list end
					}
					
					
					//if([[childNode2 name] isEqualToString:@"Cdata"])
                    //[individualItemArray addObject:tempDictionary];
					
				}
			}
		}
	}
    //Inserting OTHER material record in Material table
    NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  ZGSXSMST_EMPLYMTRLLIST10 (BP_UNAME,MATNR,MAKTX_INSYLANGU,VRKME,MEINS) VALUES ('SCHADHA','OTHER','','','')"];
    [objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
    

    
    //********************Download All Colleague List**********************
    [self getColleagueListDownloadFromSAP];
	//*********************************************************************
    
	return TRUE;	
}

//Donwloading serivice order confirmation data from SAP..
-(BOOL) getColleagueListDownloadFromSAP{
	BOOL localVar = FALSE;
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//[objServiceManagementData createEditableCopyOfDatabaseIfNeeded:objServiceManagementData.serviceReportsDB];	
    
	//Calling Soap servive
	
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:self.service_url];	
	binding.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *epar1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	epar1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO";
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *epar2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	epar2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *epar3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	epar3.Cdata = @"EVENT[.]SERVICE-COLLEAGUE-LIST[.]VERSION[.]0";	
	
	
	//Passing parameters in soap service
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:epar1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:epar2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01.item addObject:epar3];			
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request1.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01;		
	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp1 = [binding ZGssmwfmHndlEvntrqst00UsingParameters:request1];
	
	
	//Get the response here, and create CXMLDocument object for parse the response
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:resp1.getResponseData options:0 error:nil];	
	
	
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
						
						if([[getArrayAfterSplit objectAtIndex:0] isEqualToString:[objServiceManagementData.dataTypeArray objectAtIndex:10]])
						{
							
							NSString *tempFiledStr = @"";
							NSString *tempValueStr = @"";
							
							for(int i=0;i<[objServiceManagementData.ZGSCSMST_EMPLY01FeildArray count];i++)
							{
								tempFiledStr = [tempFiledStr stringByAppendingString:[objServiceManagementData.ZGSCSMST_EMPLY01FeildArray objectAtIndex:i]];								
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];
								tempValueStr = [tempValueStr stringByAppendingString:[[getArrayAfterSplit objectAtIndex:i+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
								tempValueStr = [tempValueStr stringByAppendingString:@"'"];								
								
								if(i<([objServiceManagementData.ZGSCSMST_EMPLY01FeildArray count]- 1))
								{
									tempFiledStr = [tempFiledStr stringByAppendingString:@","];
									tempValueStr = [tempValueStr stringByAppendingString:@","];
								}
							}
							
							//Insert data in to Sqlite..
							NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",[objServiceManagementData.dataTypeArray objectAtIndex:10],tempFiledStr,tempValueStr];
							
							[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];	
                            localVar = TRUE;
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

    
	return localVar;
}



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
}


@end
