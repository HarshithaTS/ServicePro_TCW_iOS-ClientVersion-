//
//  MainMenu.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"


/*--this header file for SOAP call--*/
//#import "Z_GSSMWFM_HNDL_EVNTRQST00Svc.h"


#import "TouchXML.h"
#import "ServiceManagementData.h"

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>

#import <sqlite3.h>
#import "CheckedNetwork.h"
#import "getResponseFromSAPGeneric.h"
#import <AdSupport/ASIdentifierManager.h>
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
#import "OpenUDID.h"
#import "UIDevice+IdentifierAddition.h"
#import "iOSMacros.h"
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
@synthesize textField, scroll;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
-(void) viewWillAppear:(BOOL)animated {
   
  /*  //Get Context Data
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    customAlt = [[CustomAlertView alloc] init];
    
    dispatch_group_async(objServiceManagementData.Task_Group,objServiceManagementData.Concurrent_Queue_High,^{
    // *************************
    //Fetch Context Data
    // *************************
    //Show processing Alert to User
    self.view.userInteractionEnabled = FALSE;
    //customAlt = [[CustomAlertView alloc] init];
    //[self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
    
    
    float _screenWidth = self.view.frame.size.width;
    float _screenHieght = self.view.frame.size.height;
    
    
    if (IS_IPAD) {
        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Comunicating_sap",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    }
    else {
        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Comunicating_sap",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    }
    
    
    
    [self GETCONTEXTDATA];
    
    dispatch_group_async(objServiceManagementData.Task_Group,objServiceManagementData.Main_Queue,^{
    //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
    [customAlt removeAlertForView];
    //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
    
    self.view.userInteractionEnabled = TRUE;
    // *************************
     });
    
    });
    
    */
    
  
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
 
   

    // Add an observer that will respond to notif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GETSERVICETASKDATA:)
                                                 name:@"notGetData" object:nil];
    

    
    
    //Get Customized unique device identification number
    NSLog(@"Unique Device Identifier:\n%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
    NSLog(@"Unique GLOBAL Device Identifier:\n%@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]);
    NSLog(@"Vendor id:%@", [[[UIDevice currentDevice]identifierForVendor] UUIDString]);
    NSLog(@"advt id:%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] );
    NSLog(@"\n version %@",SYSTEM_VERSION);
    NSLog(@"open Udid:%@", [OpenUDID value]);
//    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // __IPHONE_7_0
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    #endif
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.hidesBackButton = YES;
	self.navigationController.navigationBarHidden = NO;
	self.title = NSLocalizedString(@"Main_Menu_title",@"");
	
	//Searching Task related variable, when back edit task to task list page
	modifySearchWhenBackFalg = FALSE;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    bar.translucent = NO;
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        [bar setBarTintColor:[UIColor
                           colorWithRed:50.0/255
                           green:50.0/255
                           blue:205.0/255
                           alpha:1]];
    else
        [bar setTintColor:[UIColor
                           colorWithRed:50.0/255
                           green:50.0/255
                           blue:205.0/255
                           alpha:1]];

    // UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoGssInfoView:)];
    
    
    //Info View Button
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPHONE) {
    [aButton setImage:[UIImage imageNamed:@"info_btn.png"] forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,25,25);
    }
    else {
        [aButton setImage:[UIImage imageNamed:@"info_btn_big.png"] forState:UIControlStateNormal];
        aButton.frame = CGRectMake(0.0, 0.0,35,35);
    }
    [aButton addTarget:self action:@selector(gotoGssInfoView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = aBarButtonItem;
    
    
    //[aButton release],aButton=Nil;
    [aBarButtonItem release],aBarButtonItem=Nil;
    
   
    //Show Image
    
    UIImageView *right_App_Icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Small.png"]];
    right_App_Icon.frame = CGRectMake(10,5,29,29);
    
    
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,130,40)];
    tmpTitleLabel.text = NSLocalizedString(@"Main_Menu_title",@"");
    tmpTitleLabel.textAlignment = NSTextAlignmentCenter;
    tmpTitleLabel.font = [UIFont boldSystemFontOfSize:20];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // __IPHONE_7_0
//    tmpTitleLabel.textColor = [UIColor blueColor];
//#else
    tmpTitleLabel.textColor = [UIColor whiteColor];
//#endif
    tmpTitleLabel.backgroundColor = [UIColor clearColor];
    
    
    //Adding to UIView above Items
    CGRect applicationFrame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    
    UIView * newView = [[[UIView alloc] initWithFrame:applicationFrame] autorelease];
    [newView addSubview:right_App_Icon];
    [newView addSubview:tmpTitleLabel];
    self.navigationItem.titleView = newView;
    
    [right_App_Icon release],right_App_Icon=Nil;
    [tmpTitleLabel release],tmpTitleLabel=Nil;
    
    
 
    
    
    
    [super viewDidLoad];
    
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
    return YES;
    
    return NO;
   
}



-(IBAction)gotoGssInfoView:(id)sender 
{
    GssInfoView *objGssInfoView;
    if (IS_IPHONE) {
         objGssInfoView = [[[GssInfoView alloc] initWithNibName:@"GssInfoView" bundle:[NSBundle mainBundle]] autorelease];
        }
    else {
        objGssInfoView = [[[GssInfoView alloc] initWithNibName:@"GssInfoView-iPad" bundle:[NSBundle mainBundle]] autorelease];
        }
    [self.navigationController pushViewController:objGssInfoView animated:YES];
    
    //[objGssInfoView release];
}

//Below six functions wiil call seperatly when pressed corresponding buttons

-(IBAction)gotoServiceOrders:(id)sender{
    //Store Active View Name
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.activeApp = @"ServiceOrders";
    
    
    //[self GETSERVICETASKDATA];
    
    ServiceOrders *objServiceOrders;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        objServiceOrders = [[[ServiceOrders alloc] initWithNibName:@"ServiceOrders_ipad" bundle:[NSBundle mainBundle]] autorelease];
    }
    else{
        objServiceOrders = [[[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:[NSBundle mainBundle]] autorelease];
        
    }
    

  
     [self.navigationController pushViewController:objServiceOrders animated:YES];
    

}


-(IBAction)gotoCompletedTasks:(id)sender{
	/*CompletedTasks *objCompletedTasks = [[CompletedTasks alloc]  initWithNibName:@"CompletedTasks" bundle:nil];
	[self.navigationController pushViewController:objCompletedTasks animated:YES];
	[objCompletedTasks release];*/
}

-(IBAction)gotoVanStock:(id)sender{
	/*VanStock *objVanStock = [[VanStock alloc]  initWithNibName:@"VanStock" bundle:nil];
	[self.navigationController pushViewController:objVanStock animated:YES];
	[objVanStock release];*/
}

-(IBAction)gotoInstBaseReport:(id)sender{
	/*InstBaseReport *objInstBaseReport = [[InstBaseReport alloc]  initWithNibName:@"InstBaseReport" bundle:nil];
	[self.navigationController pushViewController:objInstBaseReport animated:YES];*/
}

-(IBAction)gotoMyUtilization:(id)sender{
	/*MyUtilization *objMyUtilization = [[MyUtilization alloc]  initWithNibName:@"MyUtilization" bundle:nil];
	[self.navigationController pushViewController:objMyUtilization animated:YES];
	[objMyUtilization release];*/
}

-(IBAction)gotoBillableSO:(id)sender{
	/*BillableSO *objBillableSO = [[BillableSO alloc]  initWithNibName:@"BillableSO" bundle:nil];
	[self.navigationController pushViewController:objBillableSO animated:YES];
	[objBillableSO release];*/
}
-(IBAction)gotoRestartApp:(id)sender{
    //AppDelegate_iPhone *delegate = [[AppDelegate_iPhone alloc] initWithNibName:@"AppDelegate_iPhone" bundle:nil];
    //[self.navigationController pushViewController:delegate animated:YES];
   // [delegate release];
}



-(void) GETSERVICETASKDATA{
    
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
        customAlt = [[CustomAlertView alloc] init];
    
    
        //Show processing Alert to User
        self.view.userInteractionEnabled = FALSE;
        
        self.navigationItem.leftBarButtonItem.enabled = FALSE;
        
        NSString *responseValue;
        //Add Input Strings into nsmutablearray
        getInputArray = [[NSMutableArray alloc] init];
        
        
        float _screenWidth = self.view.frame.size.width;
        float _screenHieght = self.view.frame.size.height;
        
        if (IS_IPAD) {
            [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
        }
        else {
            [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
        }
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        responseValue = [CheckedNetwork getResponseFromSAP:getInputArray :@"SERVICE-DOX-FOR-EMPLY-BP-GET":objServiceManagementData.serviceReportsDB:1:@"GETDATA"];
        
        
        if ( ![responseValue isEqualToString:@"555-Success"] && ![responseValue isEqualToString:@""] ){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                                  message:responseValue
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
        else
        {
            responseValue = [CheckedNetwork getResponseFromSAP:nil :@"SERVICE-DOX-CONTEXT-DATA-GET":objServiceManagementData.gssSystemDB:99:@"GETDATA"];
            if ( ![responseValue isEqualToString:@"555-Success"] && ![responseValue isEqualToString:@""] ){
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
        
    
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
        objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVICE ORDER" :1];
        
        
        //Retrieving colleague data
        [objServiceManagementData.colleagueListArray removeAllObjects];
    
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM 'ZGSXCAST_EMPLY01' WHERE 1"];
        objServiceManagementData.colleagueListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"COLLEAGUE LIST" :1];
        
        
        //Stop Active Indicator
        
        [customAlt removeAlertForView];
        [customAlt release],customAlt=nil;

        self.view.userInteractionEnabled = TRUE;
    
   
}




-(void) GETCONTEXTDATA{
    NSString *responseValue;
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    responseValue = [CheckedNetwork getResponseFromSAP:nil :@"SERVICE-DOX-CONTEXT-DATA-GET":objServiceManagementData.gssSystemDB:99:@"GETDATA"];
    if ( ![responseValue isEqualToString:@"555-Success"] && ![responseValue isEqualToString:@""] ){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                              message:responseValue
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
  
    //COMMENTED BY SELVAN ON 29/03/2013 FOR TCW STATUS CHANGE
    
    //Get status description from status master
   /* NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT TXT30 FROM ZGSXCAST_STTS10 WHERE 1"];
    objServiceManagementData.taskStatusTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :1];
        
    */
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
