//
//  ServiceOrders.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*-----Listing the service orders (Task list)....*/

#import "ServiceOrders.h"
#import "ServiceManagementData.h"
#import "ServiceOrderEdit.h"
//#import "ServiceConfirmation.h"
#import "AppDelegate_iPhone.h"
#import "Constants.h"
#import "TaskLocationMapView.h"
#import "MainMenu.h"
#import "ColleagueList.h"

#import "CheckedNetwork.h"

//#import "Z_GSSMWFM_HNDL_EVNTRQST00Svc.h"
#import "TouchXML.h"

#import "CustomAlertView.h"
#import "gss_qp_pastboard.h"
#import "iOSMacros.h"

#import "ServiceTaskEdit.h"
#import "CurrentDateTime.h"



CustomAlertView *customAlt;

@implementation ServiceOrders

@synthesize toolbar;
@synthesize myTableView;
@synthesize rowIndex;
@synthesize object_id;
@synthesize priorityOrderByFlag;
@synthesize dueDateOrderByFlag;
@synthesize statusOrderByFlag;
@synthesize subjectOrderByFlag;

//Start Vivek Kumar - G
//Setting And Getting Declaring for Table Header

@synthesize  headerView;
@synthesize  BorderColor;

// CHANGES Made by Biren on 28-02-13
@synthesize service_Priority;
@synthesize service_Status;
//end
@synthesize service_H_STS;
@synthesize service_H_StartDate;
@synthesize service_H_CustL;
@synthesize service_H_EstA;
@synthesize service_H_SerDoc;
@synthesize service_H_CName;
@synthesize service_H_PDesc;

@synthesize sBar;
@synthesize searching;
@synthesize dubArrayList;

@synthesize searchHaldleFlagWhenBack;

@synthesize activity_inc;


#pragma mark -
#pragma mark View lifecycle


//This function will call when back from the pushed viewcontroller..
-(void)viewWillAppear:(BOOL)animated
{
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	//delegate.activeApp = @"ServiceOrders";

    
    if(delegate.modifySearchWhenBackFalg && !delegate.DidBecomeActive)
	{
		delegate.modifySearchWhenBackFalg = FALSE;
		
		if([self.dubArrayList count]>0 && [self.sBar.text length]>0)
		{
			self.searching = YES;
			[self searchTableView];
		}
   
	}
    else
    {
        delegate.DidBecomeActive = FALSE;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadServiceTaskData" object:nil];
    }
    
    //Show update view diagnosis popup
    if (delegate.ShowServiceUpdateDiagnosis) {
        //Show Diagnosis popup
        if (delegate.diagnoseSwitchStatus)
        {
            [self showDiagnosisPopup];
            
        }
        
        delegate.ShowServiceUpdateDiagnosis = FALSE;
    }

    
}
-(NSString *) GetCurrentTimeStamp {
    //Find Device Date and Time
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd HHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];


    NSLog(@"Date String %@", dateString);
    
return dateString;
//End
}

-(void) GETSERVICETASKDATA:(NSNotification *) notification{
    
    
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    [objServiceManagementData.diagonseArray removeAllObjects];

    customAlt = [[CustomAlertView alloc] init];
    
    //APTURE DEVICE START TIME
    [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"+ START-PROCESSING DEVICE %@",[self GetCurrentTimeStamp]]];
    
    
    dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Concurrent_Queue_High,^{
        
        
        AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        //********************************************************************************************************************
        //********************************************************************************************************************
        //* CALL SERVICE DOX API                                                                                                       *
        //********************************************************************************************************************
        //********************************************************************************************************************
        dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
            //Show processing Alert to User
            self.view.userInteractionEnabled = FALSE;
            self.navigationItem.leftBarButtonItem.enabled = FALSE;
            float _screenWidth = self.view.frame.size.width;
            float _screenHieght = self.view.frame.size.height;
            
            if (IS_IPAD) {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Fetching_Service_Task",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
            else {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
            
        });
        //ADD EVENT TITLE
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"EVENT: SERVICE-DOX-FOR-EMPLY-BP-GET"]];
        
        //CAPTURE API START TIME
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"+ API-BEGIN-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
        
        NSString *responseValue;
        //Add Input Strings into nsmutablearray
        NSMutableArray *getInputArray = [[NSMutableArray alloc] init];
        //getInputArray = [[NSMutableArray alloc] init];
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        responseValue = [CheckedNetwork getResponseFromSAP:getInputArray :@"SERVICE-DOX-FOR-EMPLY-BP-GET":objServiceManagementData.serviceReportsDB:1:@"GETDATA"];
        
        NSLog(@"Response Value %@ ", responseValue);
        //CAPTURE API START TIME
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"- API-END-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
        
        //********************************************************************************************************************
        //********************************************************************************************************************
        //* SERVICE DOX SUCCESS THEN CALL ANOTHER API                                                                         *
        //********************************************************************************************************************
        //********************************************************************************************************************
        
        if ([responseValue isEqualToString:@"555-Success"]){
            
            NSLog(@" %hhd", objAppDelegate_iPHone.CallContext);
           
            if (objAppDelegate_iPHone.CallContext) {
            
                // this code moved to after render code
                //ADD EVENT TITLE
                [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-FOR-EVENT SERVICE-DOX-CONTEXT-DATA-GET"]];

                [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-BEGIN-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
               // ********************************************************************************************************************
               // ********************************************************************************************************************
               //  CALL CONTEXT API
               // ********************************************************************************************************************
               // ********************************************************************************************************************
                dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
                    //Show processing Alert to User
                    [customAlt removeAlertForView];
                    
                    self.view.userInteractionEnabled = FALSE;
                    self.navigationItem.leftBarButtonItem.enabled = FALSE;
                    float _screenWidth = self.view.frame.size.width;
                    float _screenHieght = self.view.frame.size.height;
                    
                    if (IS_IPAD) {
                        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Fetching_Context",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
                    }
                    else {
                        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
                    }
                });
                
                
               [CheckedNetwork getResponseFromSAP:nil :@"SERVICE-DOX-CONTEXT-DATA-GET":objServiceManagementData.gssSystemDB:99:@"GETDATA"];
                
                
                [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-END-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
            
                
                //Updating Setting
                AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
                objAppDelegate_iPHone.CallContext = FALSE;
                NSString *sqlQryStr = [NSString stringWithFormat:@"UPDATE TBL_SETTING SET loadContext = %d", 0];
                [objServiceManagementData excuteSqliteQryString:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];
                

                
                
            }
            
        }
        
        //RENDER CAPTURE BEGIN TIME
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"+ RENDER-BEGIN-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
        //********************************************************************************************************************
        //********************************************************************************************************************
        //* RENDER VIEW                                                                                                        *
        //********************************************************************************************************************
        //********************************************************************************************************************
        
        dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
            //Show processing Alert to User
            [customAlt removeAlertForView];
            
            self.view.userInteractionEnabled = FALSE;
            self.navigationItem.leftBarButtonItem.enabled = FALSE;
            float _screenWidth = self.view.frame.size.width;
            float _screenHieght = self.view.frame.size.height;
            
            if (IS_IPAD) {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
            else {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
        });
        
        
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
        objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVICE ORDER" :1];
        NSLog(@"Task list array %@", objServiceManagementData.taskListArray);
        //Retrieving colleague data
        [objServiceManagementData.colleagueListArray removeAllObjects];
        
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM 'ZGSXCAST_EMPLY01' WHERE 1"];
       objServiceManagementData.colleagueListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"COLLEAGUE LIST" :1];
        
        
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"- RENDER-END-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
        
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"- STOP-PROCESSING DEVICE %@",[self GetCurrentTimeStamp]]];
        //********************************************************************************************************************
        //********************************************************************************************************************
        //* STOP PROGRESS BAR INDICATOR                                                                                                         *
        //********************************************************************************************************************
        //********************************************************************************************************************
        dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
            //Stop Active Indicator
            [customAlt removeAlertForView];
            [customAlt release],customAlt=nil;
            self.view.userInteractionEnabled = TRUE;
            self.navigationItem.leftBarButtonItem.enabled =  TRUE;
            
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
            
             NSLog(@"time stamp: %@", objServiceManagementData.diagonseArray);
            
            //********************************************************************************************************************
            //********************************************************************************************************************
            //* REFRESH TASK OVERVIEW TABLE                                                                                                        *
            //********************************************************************************************************************
            //********************************************************************************************************************
            
            
            [self.myTableView reloadData];
            
            //Show Diagnosis popup
            if (objAppDelegate_iPHone.diagnoseSwitchStatus)
            {
                //CustomDiagnosisPopup *objCustomDiagnosisPopup = [[CustomDiagnosisPopup alloc] init];
                //[objCustomDiagnosisPopup showDiagnosisPopup:self.view];
                [self showDiagnosisPopup];
                
            }
            
            
            //********************************************************************************************************************
            //********************************************************************************************************************
            
            
        });
        
    });
    
    
    
   
}




-(void) GETCONTEXTDATA{
    NSString *responseValue;
    
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
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


-(void) ShowActiveIndicator:(NSNotification *) notification{

    dispatch_group_async(objServiceManagementData.Task_Group,objServiceManagementData.Main_Queue,^{
    if ([notification.userInfo isEqual:YES] ) {
        [self.activity_inc startAnimating];
    }
    else
        [self.activity_inc stopAnimating];
    });
}





- (void)viewDidLoad {
    [super viewDidLoad];
	

    // Add an observer that will respond to notif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GETSERVICETASKDATA:)
                                                 name:@"LoadServiceTaskData" object:nil];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
	//set the Ordering flags default value..
	self.priorityOrderByFlag = TRUE;
	self.dueDateOrderByFlag = TRUE;
	self.statusOrderByFlag = TRUE;
	self.subjectOrderByFlag = TRUE;
	
	//Creating search bar instance..
	//self.sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00, 320.00, 42.00)];
	//self.sBar.delegate = self;
	self.sBar.placeholder = @"Task Search...";
	//[self.view addSubview:sBar];
	self.searching = NO;
	self.searchHaldleFlagWhenBack = NO;
	self.dubArrayList = [[NSMutableArray alloc] init];
	
	self.title =  NSLocalizedString(@"Servic_Orders_title",@"");
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // __IPHONE_7_0
    //  tlabel.textColor = [UIColor blackColor];
    //#else
    tlabel.textColor = [UIColor whiteColor];
    //#endif
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    [tlabel release],tlabel =nil;
    //end
    
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.localImageFilePath = @"";

	
	/*//Alloc right side bar button.. to ordering the task list orders..
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_Menu",@"") style:UIBarButtonItemStylePlain target:self action:@selector(orderingTask:)];
     [[self navigationItem] setRightBarButtonItem:barButton];
     [barButton release], barButton = nil;	*/
    
    //Added back bar button
	barBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_Main_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barBackButton;
    if ([SYSTEM_VERSION floatValue]>= 7.0) {
        [barBackButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
        barBackButton.tintColor = [UIColor whiteColor];
    }
	[barBackButton release], barBackButton = nil;
    
    float _screenWidth = self.view.frame.size.width;

    //toolbar code
    toolbar.barStyle = UIBarStyleBlackOpaque; // UIBarStyleDefault;
    // create a bordered style button with custom title
    UIBarButtonItem *menuItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu28-b.png"] style:UIBarButtonItemStylePlain target:self action:@selector(orderingTask:)] autorelease];
    menuItem.title = @"Menu";
    
    UIBarButtonItem *fixSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    
    NSLog(@"The Width of Ipad is %f",_screenWidth);
    
    
    if(IS_IPHONE)
      fixSpaceItem.width = (_screenWidth/2)-20;
    else
      fixSpaceItem.width = 350.0f;
        
    NSArray *items = [NSArray arrayWithObjects:
                      
                      fixSpaceItem,
                      
                      menuItem,
                      
                      nil];
    
    toolbar.items = items;
    
    // size up the toolbar and set its frame
    // please not that it will work only for views without Navigation toolbars.
    /*[toolbar sizeToFit];
     CGFloat toolbarHeight = [toolbar frame].size.height;
     CGRect mainViewBounds = self.view.bounds;
     [toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
     CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight),
     CGRectGetWidth(mainViewBounds),
     toolbarHeight)];*/
    [self.view addSubview:toolbar];
    //End toobar Code
    
    //CHECK ERROR PASTBOARD AND ERROR TABLE FOR ANY ERROR MESSAGE
    
    errStatus = [self verifyErrorPastboard];
    
    objServiceManagementData = [ServiceManagementData sharedManager];
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM 'tbl_errorlist' WHERE 1"];
    
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"error table" :1];
    
    //Setting TableView Background
    self.myTableView.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    
    //Scrolling
    [self.Table_ScrollView setScrollEnabled:YES];
    [self.Table_ScrollView setShowsHorizontalScrollIndicator:YES];
    [self.Table_ScrollView setContentSize:(CGSizeMake(950,800))];
    
    //CHECK ERROR END
}
//Read pastboard for any error message availble for servicepro
//*******************************************************************************
//GET ERROR PASTBOARD DETAILS
//*******************************************************************************

-(BOOL) verifyErrorPastboard {
    
    errStatus = NO;
    objServiceManagementData = [ServiceManagementData sharedManager];

    gss_qp_pastboard *obj_gss_qp_pastboard = [[gss_qp_pastboard alloc] init];
    NSMutableArray *pastboarderrorItemArray;
    pastboarderrorItemArray = [obj_gss_qp_pastboard getErrorItemsFromPastBoard:@"Backprocess"];
    
    NSLog(@"Pastboard Error: %@", pastboarderrorItemArray);
    
    //IF ERROR RECORD FOUND INSERT INTO ERROR TABLE
    for (int index=0; index < [pastboarderrorItemArray  count]; index++) {
        
        NSDictionary *pastBoardDataDic =
        [pastboarderrorItemArray  objectAtIndex:index ];
        
        NSString *appnameStr = [NSString stringWithFormat:@"%@",
                                [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"appname"] encoding:NSUTF8StringEncoding]];
        
        if ([appnameStr isEqualToString:@"SERVICEPRO"]) {
            NSString *sqlQry =
            [NSString stringWithFormat:@"INSERT INTO tbl_errorlist (apprefid,appname,apiname,errtype,errdesc,errdate,status) VALUES ('%@','%@','%@','%@','%@','%@',1)",
             [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"apprefid"] encoding:NSUTF8StringEncoding]],
             appnameStr,
             [NSString stringWithFormat:@"%@",
              [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"apiname"] encoding:NSUTF8StringEncoding]],
             
             [NSString stringWithFormat:@"%@",
              [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"errtype"] encoding:NSUTF8StringEncoding]],
             
             [NSString stringWithFormat:@"%@",
              [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"errdesc"] encoding:NSUTF8StringEncoding]],
             
             [NSString stringWithFormat:@"%@",
              [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"errdate"] encoding:NSUTF8StringEncoding]]];
            
            
            NSLog(@"error sql %@",sqlQry);
            
            if([objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQry :@"gssSystemDB.sqlite"])
            {
                errStatus = YES;
                [pastboarderrorItemArray removeObjectAtIndex:index];
                
            }
        }
    }
    
    //BOOL setPastBoardStatus =
    [obj_gss_qp_pastboard setEItemsIntoPastBoard:pastboarderrorItemArray :@"Backprocess"];
    
    /* //Remove or clear past board
     [UIPasteboard removePasteboardWithName:@"gss_qp_error_pb"];
     //Create pastboard with pastboardname
     UIPasteboard *pastBoardObj = [UIPasteboard pasteboardWithName:@"gss_qp_error_pb" create:YES];
     [pastBoardObj setPersistent:YES];
     //Overwrite array into pastboard
     [pastBoardObj setItems:pastboarderrorItemArray];
     //[self.pastBoardItemArray release];
     [pastBoardObj release];*/
    return errStatus;
}
//
//calling while trying to back Service Orders (Task) list page
-(void) goBack
{
    //Store Active View Name
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.activeApp = @"Main";
    delegate.DidBecomeActive = FALSE;

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

//Action sheet for ordering the service orders (Task list)
-(IBAction)orderingTask:(id)sender
{
    UIActionSheet *orderTaskActionSheet;
    if (IS_IPAD) {
        
        orderTaskActionSheet = [[UIActionSheet alloc]
                                initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_title",@"")
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Cancel_title",@"")
                                destructiveButtonTitle:nil
                                otherButtonTitles:
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Rep", @"")
                                ,nil];
    }
    else {
        orderTaskActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_title",@"")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Cancel_title",@"")
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_DueDate",@""),
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Priority",@""),
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Status",@""),
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Subject",@""),
                                NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Rep", @"")
                                ,nil];
        
    }
	
	orderTaskActionSheet.tag = 1; //I have set tag, because two action sheet is present in this class..
	[orderTaskActionSheet showInView:self.view];
	[orderTaskActionSheet release], orderTaskActionSheet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


//Start - Vivek Kumar G
//Underline Line Below Button

-(UILabel*)Underline_ButtonTitle:(UIButton*)button
{
    NSString *string = [button titleForState:UIControlStateNormal];
    CGSize stringSize = [string sizeWithFont:button.titleLabel.font];
    CGRect buttonFrame = button.frame;
    /* CGRect labelFrame = CGRectMake(buttonFrame.origin.x + buttonFrame.size.width - stringSize.width,
     buttonFrame.origin.y + stringSize.height + 1 ,
     stringSize.width, 2);*/
    
    CGRect labelFrame = CGRectMake(buttonFrame.origin.x + 4 ,
                                   buttonFrame.origin.y + stringSize.height +1,
                                   stringSize.width-5,1);
    
    UILabel *lineLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    lineLabel.backgroundColor = [UIColor whiteColor];
    //[forgetButton addSubview:lineLabel];
    [self.view addSubview:lineLabel];
    
    
    return lineLabel;
    
 }


//End - Vivek Kumar G




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(IS_IPAD) {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,900,T_HEADER_TABLE_HEIGHT)];
        
        BorderColor = [UIColor darkTextColor];
        
        
        service_H_STS = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_STS_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_STS_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_STS.layer.borderColor = [BorderColor CGColor];
        service_H_STS.layer.cornerRadius = T_HEADER_CORNER_RADIUS;
        service_H_STS.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        service_H_STS.tag = T_HEADER_STS_TAG;
        service_H_STS.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        service_H_STS.text = @"";
        
        [headerView addSubview:service_H_STS];
        //[service_H_STS release],service_H_STS=nil;
        
        service_Priority = [[UIButton alloc]initWithFrame:CGRectMake(1, T_HEADER_TABLE_YAXIS, T_HEADER_CUSTL_WIDTH/2, T_HEADER_TABLE_HEIGHT)];
        
        service_Priority.tag = 1;
        service_Priority.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_Priority setTitle:[NSString stringWithFormat:@" Pri"] forState:UIControlStateNormal];
        
        [service_Priority setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        service_Priority.layer.borderColor = [BorderColor CGColor];
        service_Priority.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        
        service_Priority.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [service_Priority addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:service_Priority];
        
        UILabel *Line_B1 = [self Underline_ButtonTitle:service_Priority];
        [headerView addSubview:Line_B1];
        //[Line_B1 release], Line_B1 = nil;
        
        service_Status = [[UIButton alloc]initWithFrame:CGRectMake(30, T_HEADER_TABLE_YAXIS, T_HEADER_CUSTL_WIDTH/2, T_HEADER_TABLE_HEIGHT)];
        service_Status.tag = 2;
        service_Status.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_Status setTitle:[NSString stringWithFormat:@" Stat"] forState:UIControlStateNormal];
        
        [service_Status setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        service_Status.layer.borderColor = [BorderColor CGColor];
        service_Status.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        
        service_Status.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [service_Status addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:service_Status];
        
        UILabel *Line_B2 = [self Underline_ButtonTitle:service_Status];
        [headerView addSubview:Line_B2];
        //[Line_B2 release], Line_B2 = nil;
        
        service_H_StartDate = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_STD_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_STD_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_StartDate.tag = 3;
        service_H_StartDate.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        
        [service_H_StartDate setTitle:@" Start Date " forState:UIControlStateNormal];
        //    service_H_StartDate.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"Service_Order_Table_Header_Title_Start_Date",@"")];
        [service_H_StartDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        
        service_H_StartDate.layer.borderColor = [BorderColor CGColor];
        service_H_StartDate.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        service_H_StartDate.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [service_H_StartDate addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:service_H_StartDate];
        // [headerView release],headerView=Nil;
        
        UILabel *Line_B3 = [self Underline_ButtonTitle:service_H_StartDate];
        [headerView addSubview:Line_B3];
        //[Line_B3 release], Line_B3 = nil;
        
        
        service_H_CustL = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_CUSTL_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_CUSTL_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_CustL.tag = 4;
        [service_H_CustL setTitle:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"Service_Order_Table_Header_Title_CustL",@"")] forState:UIControlStateNormal];
        service_H_CustL.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        
        // service_H_CustL.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [service_H_CustL setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        service_H_CustL.layer.borderColor = [BorderColor CGColor];
        service_H_CustL.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        
        service_H_CustL.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [service_H_CustL addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:service_H_CustL];
        
        UILabel *Line_B4 = [self Underline_ButtonTitle:service_H_CustL];
        [headerView addSubview:Line_B4];
        //[Line_B4 release], Line_B4 = nil;
        
        //[service_H_CustL release],service_H_CustL=Nil;
        
        
        service_H_EstA = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_ESTARR_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_ESTARR_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_EstA.tag = 5;
        [service_H_EstA setTitle:@" Est. Arrival " forState:UIControlStateNormal];
        service_H_EstA.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        [service_H_EstA setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        
        service_H_EstA.layer.borderColor = [BorderColor CGColor];
        service_H_EstA.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        service_H_EstA.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        [service_H_EstA addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:service_H_EstA];
        // [headerView release],headerView=Nil;
        
        UILabel *Line_B5 = [self Underline_ButtonTitle:service_H_EstA];
        [headerView addSubview:Line_B5];
        //[Line_B5 release], Line_B5 = nil;
        
        
        service_H_SerDoc = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_SERDOC_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_SERDOC_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_SerDoc.tag = 6;
        [service_H_SerDoc setTitle:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"Service_Order_Table_Header_Title_ServiceD",@"")] forState:UIControlStateNormal];
        
        service_H_SerDoc.layer.borderColor = [BorderColor CGColor];
        service_H_SerDoc.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        
        [service_H_SerDoc setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        service_H_SerDoc.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        
        
        service_H_SerDoc.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        
        [service_H_SerDoc addTarget:self action:@selector(Header_Button_Click_Event_Service_Task:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:service_H_SerDoc];
        
        
        UILabel *Line_B6 = [self Underline_ButtonTitle:service_H_SerDoc];
        [headerView addSubview:Line_B6];
        //[Line_B6 release],Line_B6=Nil;
        //[service_H_SerDoc release],service_H_SerDoc=Nil;
        
        
        //CUSTOMERNAME COMMENTED BY SELVAN
        /*service_H_CName = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_CNAME_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_CNAME_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_CName.tag = T_HEADER_CNAME_TAG;
        service_H_CName.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        service_H_CName.textColor = [UIColor whiteColor];
        
        
        service_H_CName.layer.borderColor = [BorderColor CGColor];
        service_H_CName.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        
        service_H_CName.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        
        
        service_H_CName.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"Service_Order_Table_Header_Title_CName",@"")];
        [headerView addSubview:service_H_CName];*/
        
        //[service_H_CName release],service_H_CName=Nil;
        
        
        service_H_PDesc = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_PDESC_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_PDESC_WIDTH,T_HEADER_TABLE_HEIGHT)];
        
        service_H_PDesc.tag = T_HEADER_PDESC_TAG;
        service_H_PDesc.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
        service_H_PDesc.textColor = [UIColor whiteColor];
        
        service_H_PDesc.layer.borderColor = [BorderColor CGColor];
        service_H_PDesc.layer.borderWidth = T_HEADER_BORDER_WIDTH;
        
        service_H_PDesc.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
        
        // service_H_PDesc.layer.cornerRadius = 3.5f;
        
        service_H_PDesc.text =[NSString stringWithFormat:@"  %@",NSLocalizedString(@"Service_Order_Table_Header-Title_PDesc",@"")];
        [headerView addSubview:service_H_PDesc];
        
        //[service_H_PDesc release],service_H_PDesc=Nil; */
        
        
        return headerView;
        
    }
    
    
    return NULL;
    
}

//Start - Vivek Kumar G
//Header Button Action for Table View

-(void)Header_Button_Click_Event_Service_Task:(id)sender
{
    
    UIButton *myButton = (UIButton *)sender;
    [self Menu_ActionSheet_Sorting:myButton.tag];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return T_HEADER_TABLE_HEIGHT;
    
}


//Calculating cell height..
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

//calculating text label height..
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE)
        return 85.0f;
    else
        return 60.0f;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    int row_index = indexPath.row + 1;
    
    if((row_index % 2) == 0)
        cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if(self.searching)
    {
        return [self.dubArrayList count];
        
    }
	else {
        return [objServiceManagementData.taskListArray count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    errStatus = FALSE;
    
    UIFont *Font_Size;
   
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
        if (IS_IPHONE) {
            cell = [self taskTableViewCellWithIdentifier:CellIdentifier];

        }else {
            cell = [self taskTableViewCellWithIdentifier_ipad:CellIdentifier];
        }
            
        
        if(IS_IPHONE)
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
    }
	
	
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	
	
    periorityImageName = @"";
    statusImageName = @"";
	tmpStr = @"";
	mTransactionDate = @"";
	
    
    	
	
	if(self.searching) //while searching...
	{
            
        [self createStatusButtonImage:[self.dubArrayList objectAtIndex:indexPath.row]];
        
		      
	}
	else ///When searching is False..
	{

        [self createStatusButtonImage:[objServiceManagementData.taskListArray objectAtIndex:indexPath.row]];
        
    }
    
	
    if(Service_Task_Status)
    {
        Font_Size = [UIFont boldSystemFontOfSize:12.0f];
        
    }
    else
    {
        
        Font_Size = [UIFont systemFontOfSize:12.0f];
        
    }
    
    
    
    if (IS_IPHONE) {
        
       
        [self Create_Label_Service_Order:cell andTag:T_TEXT1_TAG andFontS:Font_Size andNOLines:0 andLdata:mTransactionDate];
        
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT2_TAG andFontS:Font_Size andNOLines:5 andLdata:tmpStr];
        
      
        UIButton *statusButton = (UIButton *) [cell viewWithTag:T_IMAGE1_TAG];
        [statusButton setImage:[UIImage imageNamed:periorityImageName] forState:UIControlStateNormal];
        
        
        UIButton *taskButton = (UIButton *) [cell viewWithTag:T_IMAGE2_TAG];
        [taskButton setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateNormal];
        
        if (errStatus) {
            
            UIButton *errtaskButton = (UIButton *) [cell viewWithTag:T_IMAGE3_TAG];
            [errtaskButton setImage:[UIImage imageNamed:@"notify.png"] forState:UIControlStateNormal];
        }
        
    }
    else{
        
    
        [self Create_Label_Service_Order:cell andTag:T_TEXT1IP_TAG andFontS:Font_Size andNOLines:0 andLdata:mTransactionDate];
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT2IP_TAG andFontS:Font_Size andNOLines:3 andLdata:tmpStr];
        
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT3IP_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",Est_Arrival]];
        
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT4IP_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",ServiceDoc]];
        
    
       [self Create_Label_Service_Order:cell andTag:T_TEXT6IP_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",ProductDesc]];
        
        
        UIButton *statusButton = (UIButton *) [cell viewWithTag:T_IMAGE1IP_TAG];
        [statusButton setImage:[UIImage imageNamed:periorityImageName] forState:UIControlStateNormal];
        
        
        UIButton *taskButton = (UIButton *) [cell viewWithTag:T_IMAGE2IP_TAG];
        [taskButton setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateNormal];

        if (errStatus) {
            
            UIButton *errtaskButton = (UIButton *) [cell viewWithTag:T_IMAGE3IP_TAG];
            [errtaskButton setImage:[UIImage imageNamed:@"notify.png"] forState:UIControlStateNormal];
        }
        
    }
	
   // UIButton *nextButton = (UIButton *) [cell viewWithTag:T_IMAGE3_TAG];
	//[nextButton setImage:[UIImage imageNamed:@"gratter.jpg"] forState:UIControlStateNormal];
    
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


-(void) createStatusButtonImage:(NSMutableDictionary *) _marray
{
    
    Service_Task_Status = NO;
 
    //**************************************************************************
    //PRIORITY icon
    //**************************************************************************
    //Below four block for handling the task PRIORITY images... the image name is indicating the PRIORITY value..
    
    NSString *sqlPrQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_PRRTY10 WHERE PRIORITY = '%@'",[_marray objectForKey:@"PRIORITY"]];
    NSMutableArray *tempPrtMast = [objServiceManagementData fetchDataFrmSqlite:sqlPrQryStr :objServiceManagementData.gssSystemDB:@"PRIORITY" :1];
    
    if ([tempPrtMast count]>0) {
        periorityImageName = [NSString stringWithFormat:@"%@.png",[[tempPrtMast objectAtIndex:0] objectForKey:@"ZZPRIORITY_ICON"]];
    }
    
    //NSLog(@"periority %@",periorityImageName);
    //***************************************************************************
    //NSLog(@"sts mast arr %@",[[tempPrtMast objectAtIndex:0] objectForKey:@"ZZPRIORITY_ICON"]);

    
    
    //**************************************************************************
    //Status icon
    //**************************************************************************
    //Below four block for handling the task status images... the image name is indicating the status value..
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE STATUS = '%@'",[_marray objectForKey:@"STATUS"]];
    NSMutableArray *tempStsMast = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :1];
    
    if ([tempStsMast count]>0) {
          statusImageName = [NSString stringWithFormat:@"%@.png",[[tempStsMast objectAtIndex:0] objectForKey:@"ZZSTATUS_ICON"]];
    //***************************************************************************
     //NSLog(@"sts mast arr %@",[[tempStsMast objectAtIndex:0] objectForKey:@"ZZSTATUS_ICON"]);
    }
    
    
    Service_Task_Status = YES;
    
    //NSLog(@"Temp Service Array : %@",_marray);
    
    mTransactionDate = [NSString stringWithFormat: @"%@", [_marray objectForKey:@"DISPLAY_DUE_DATE"]];
    
    //CHANGES MADE BY Biren on 28-02-13
    NSString *date = [_marray objectForKey:@"ZZETADATE"];
    NSRange range = [date rangeOfString:@", "];
    
    date = [date substringToIndex:range.location];
    
    //Display ETA time format like HH:MM
    if ([[_marray objectForKey:@"ZZETATIME"] isEqualToString:@""]) {
        Est_Arrival = [NSString stringWithFormat: @"%@, %@", date,[_marray objectForKey:@"ZZETATIME"] ];
    }
    else
        Est_Arrival = [NSString stringWithFormat: @"%@, %@", date,[[_marray objectForKey:@"ZZETATIME"] substringToIndex:5]];
    //end
    
    ServiceDoc = [NSString stringWithFormat:@"%@/%@" , [_marray objectForKey:@"OBJECT_ID"],[_marray objectForKey:@"ZZFIRSTSERVICEITEM"]];
    ContactName = [NSString stringWithFormat: @"%@", [_marray objectForKey:@"CP1_NAME1_TEXT"]];
    
    if([_marray objectForKey:@"DESCRIPTION"] != NULL)
    ProductDesc = [NSString stringWithFormat: @"%@", [_marray objectForKey:@"DESCRIPTION"]];
    else
    ProductDesc = @"";
    
    
    if(IS_IPHONE) {
    
        tmpStr = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@, %@, %@\nDoc# %@",
              
              [_marray  objectForKey:@"NAME_ORG1"],
              [_marray  objectForKey:@"NAME_ORG2"],
              [_marray  objectForKey:@"STRAS"],
              [_marray  objectForKey:@"ORT01"],
              [_marray objectForKey:@"REGIO"],
              [_marray  objectForKey:@"PSTLZ"],
              [_marray  objectForKey:@"LAND1"],
              [_marray  objectForKey:@"OBJECT_ID"]
              ];
    }
    else
    {
        tmpStr = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@, %@",
                  
                  [_marray  objectForKey:@"NAME_ORG1"],
                  [_marray  objectForKey:@"NAME_ORG2"],
                  [_marray  objectForKey:@"STRAS"],
                  [_marray  objectForKey:@"ORT01"],
                  [_marray objectForKey:@"REGIO"],
                  [_marray  objectForKey:@"PSTLZ"]
                  ];
        
    }
        
    NSString *sqlQryStr2 = [NSString stringWithFormat:@"SELECT * FROM 'tbl_errorlist' WHERE apprefid = '%@'",[_marray objectForKey:@"OBJECT_ID"]];
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr2 :objServiceManagementData.gssSystemDB:@"error table" :1];
    
    if ([objServiceManagementData.errorlistArray count] > 0) {
        errStatus = YES;
    }
    else
        errStatus = NO;
    

}

-(UITableViewCell *)taskTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
    
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
    
	//Now we have to create the two labels.
	UILabel *label;
	
	//Now we have to create the 2 buttons with images
	UIButton *but;
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(T_TEXT1_OFFSET, 12, T_TEXT1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT1_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	cellRectangle = CGRectMake(T_TEXT2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT2_WIDTH, 80);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
    
    
    
	//Mark the label with a tag
	label.tag = T_TEXT2_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
	
	//Create a rectangle container for the image .
	cellRectangle = CGRectMake(T_IMAGE1_OFFSET, 40, T_IMAGE1_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE1_TAG;
    
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the image.
	cellRectangle = CGRectMake(T_IMAGE2_OFFSET, 20, T_IMAGE2_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
    
    
    
    //Create a rectangle container for the image.
	cellRectangle = CGRectMake(T_IMAGE3_OFFSET, 20, T_IMAGE3_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE3_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
    
        
    
	return cell;
}

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
	
	//Now we have to create the 2 buttons with images
	UIButton *but;
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(T_TEXT1IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT1IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT1IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	cellRectangle = CGRectMake(T_TEXT2IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT2IP_WIDTH,50);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT2IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(T_IMAGE1IP_OFFSET,25, T_IMAGE1IP_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE1IP_TAG;
    
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the image text.
	cellRectangle = CGRectMake(T_IMAGE2IP_OFFSET,25, T_IMAGE2IP_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE2IP_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
    
    //Create a rectangle container for the image text.
	cellRectangle = CGRectMake(T_IMAGE3IP_OFFSET,25, T_IMAGE3IP_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE3IP_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
    

    
    //Create a Label for Sample One
    
    //Create a rectangle container for the EST.Arrival .
	cellRectangle = CGRectMake(T_TEXT3IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT3IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT3IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
    //Create a rectangle container for the Service Doc .
	cellRectangle = CGRectMake(T_TEXT4IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT4IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT4IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
    //CUSTOMERNAME COMMENTED BY SELVAN
   /* //Create a rectangle container for the Contact Name .
	cellRectangle = CGRectMake(T_TEXT5IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT5IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT5IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];*/
    
    //Create a rectangle container for the Contact Name .
	cellRectangle = CGRectMake(T_TEXT6IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT6IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT6IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
    
	return cell;
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
	
	[self.myTableView reloadData];
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
	
		[searchArray addObjectsFromArray:objServiceManagementData.taskListArray];
	
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.activeApp = @"ServiceOrderEdit";
    
    [self gotoServiceDetailPage:indexPath];
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self gotoServiceDetailPage:indexPath];
    
}
-(void) gotoServiceDetailPage: (NSIndexPath *) indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    NSLog(@"Task Array:%@",objServiceManagementData.taskListArray);
    
    //objServiceManagementData.editTaskId = [indexPath row];
    if(self.searching){ //while searching...
        objServiceManagementData.editTaskId =  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"];
        objServiceManagementData.itemId =  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"ZZFIRSTSERVICEITEM"];
    }
	else { ///When searching is False..
        objServiceManagementData.editTaskId =  [[objServiceManagementData.taskListArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"];
        objServiceManagementData.itemId = [[objServiceManagementData.taskListArray objectAtIndex:indexPath.row] objectForKey:@"ZZFIRSTSERVICEITEM"];
    }
    
    NSLog(@"Task ID: %@ Item ID: %@",objServiceManagementData.editTaskId, objServiceManagementData.itemId);
    
    
    ServiceOrderEdit *objServiceOrderEdit;
    if (IS_IPHONE) {
        
    objServiceOrderEdit = [[ServiceOrderEdit alloc] initWithNibName:@"ServiceOrderEdit" bundle:nil];
    [self.navigationController pushViewController:objServiceOrderEdit animated:YES];
    [objServiceOrderEdit release],objServiceOrderEdit = nil;
    }
    else{
        objServiceOrderEdit = [[ServiceOrderEdit alloc] initWithNibName:@"ServiceEdit-ipad" bundle:nil];
        [self.navigationController pushViewController:objServiceOrderEdit animated:YES];
        [objServiceOrderEdit release],objServiceOrderEdit = nil;
        
    }
    
}


//ActionSheet - Delegate Function for Sorting

-(void)Menu_ActionSheet_Sorting:(NSInteger)Index
{
    
    NSSortDescriptor *aSortDescriptor;
    
    switch (Index) {
        case 3:
            if(self.dueDateOrderByFlag == TRUE)
            {
                //orderByStr = @"DESC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DATE" ascending:NO ];
                self.dueDateOrderByFlag = FALSE;
            }
            else {
                //orderByStr = @"ASC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DATE" ascending:YES ];
                self.dueDateOrderByFlag = TRUE;
            }
            
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            
            NSLog(@"sort %@",objServiceManagementData.taskListArray);
            
            break;
            
        case 1:
            if(self.priorityOrderByFlag == TRUE)
            {
                //orderByStr = @"DESC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PRIORITY" ascending:NO];
                self.priorityOrderByFlag = FALSE;
            }
            else {
                //orderByStr = @"ASC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PRIORITY" ascending:YES];
                self.priorityOrderByFlag = TRUE;
            }
            NSLog(@"sort %@",objServiceManagementData.taskListArray);
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            
            break;
            
        case 2:
            if(self.statusOrderByFlag == TRUE)
            {
                //orderByStr = @"DESC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STATUS" ascending:NO];
                self.statusOrderByFlag = FALSE;
            }
            else {
                //orderByStr = @"ASC";
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STATUS" ascending:YES];
                self.statusOrderByFlag = TRUE;
            }
            
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            
            break;
            
        case 5:
            
            if(self.subjectOrderByFlag == TRUE)
            {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ETADATE" ascending:YES];
                self.subjectOrderByFlag = FALSE;
            }
            else {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ETADATE" ascending:NO];
                self.subjectOrderByFlag = TRUE;
            }
            
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            break;
            
        case 4:
            
            if(self.subjectOrderByFlag == TRUE)
            {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ORG_CUST_NAME" ascending:YES];
                self.subjectOrderByFlag = FALSE;
            }
            else {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ORG_CUST_NAME" ascending:NO];
                self.subjectOrderByFlag = TRUE;
            }
            
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            break;
            
            
        case 6:
            
            if(self.subjectOrderByFlag == TRUE)
            {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SORT_OBJECT_ID" ascending:YES];
                self.subjectOrderByFlag = FALSE;
            }
            else {
                aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SORT_OBJECT_ID" ascending:NO];
                self.subjectOrderByFlag = TRUE;
            }
            
            if(self.searching)
                [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            else
                [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            [aSortDescriptor release], aSortDescriptor = nil;
            break;
            
    }
    
    [self.myTableView reloadData];
    
}

//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //CHANGES MADE BY Biren on 28-02-13
    if (IS_IPAD) {
        if(actionSheet.tag == 1 && buttonIndex == 0) {
            [self movetoColleagueList];
        }
    }
    else {
        
        
        if([sBar isFirstResponder])
            [sBar resignFirstResponder];
        
        if(actionSheet.tag == 1) //This action sheet for ordering the task...
        {
            //NSString *orderByStr = @"";
            NSSortDescriptor *aSortDescriptor;
            
            switch (buttonIndex) {
                case 0:
                    if(self.dueDateOrderByFlag == TRUE)
                    {
                        //orderByStr = @"DESC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DATE" ascending:NO];
                        self.dueDateOrderByFlag = FALSE;
                    }
                    else {
                        //orderByStr = @"ASC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DATE" ascending:YES];
                        self.dueDateOrderByFlag = TRUE;
                    }
                    
                    if(self.searching)
                        [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    else
                        [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    [aSortDescriptor release], aSortDescriptor = nil;
                    
                    NSLog(@"sort %@",objServiceManagementData.taskListArray);
                    
                    
                    break;
                case 1:
                    if(self.priorityOrderByFlag == TRUE)
                    {
                        //orderByStr = @"DESC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PRIORITY" ascending:NO];
                        self.priorityOrderByFlag = FALSE;
                    }
                    else {
                        //orderByStr = @"ASC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PRIORITY" ascending:YES];
                        self.priorityOrderByFlag = TRUE;
                    }
                    
                    if(self.searching)
                        [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    else
                        [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    [aSortDescriptor release], aSortDescriptor = nil;
                    
                    break;
                case 2:
                    if(self.statusOrderByFlag == TRUE)
                    {
                        //orderByStr = @"DESC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STATUS" ascending:NO];
                        self.statusOrderByFlag = FALSE;
                    }
                    else {
                        //orderByStr = @"ASC";
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STATUS" ascending:YES];
                        self.statusOrderByFlag = TRUE;
                    }
                    
                    if(self.searching)
                        [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    else
                        [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    [aSortDescriptor release], aSortDescriptor = nil;
                    
                    break;
                case 3:
                    
                    if(self.subjectOrderByFlag == TRUE)
                    {
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ORG_CUST_NAME" ascending:YES];
                        self.subjectOrderByFlag = FALSE;
                    }
                    else {
                        aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ORG_CUST_NAME" ascending:NO];
                        self.subjectOrderByFlag = TRUE;
                    }
                    
                    if(self.searching)
                        [self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    else
                        [objServiceManagementData.taskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    [aSortDescriptor release], aSortDescriptor = nil;
                    break;
                    
                case 4:
                    [self movetoColleagueList];
                    break;
            }
            
            
            [self.myTableView reloadData];
        }
        
    }
    //end
}

//CHANGES MADE BY Biren on 28-02-13
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        default:
            break;
    }
}
//end


-(void) movetoColleagueList{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.colleagueAction = @"ChangeColleague";
    
    ColleagueList *objColleagueList = [[ColleagueList alloc] initWithNibName:@"ColleagueList" bundle:nil];
    [self.navigationController pushViewController:objColleagueList animated:YES];
    [objColleagueList release], objColleagueList = nil;
    
}

#pragma mark-
#pragma mark Diagnosis

-(void)DiagPopupDone {
    
    [diagPopupView removeFromSuperview];
}

- (void)sendDiagnoseEmail
{
    //ServiceManagementData * objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    NSRange endRange = [delegate.service_url rangeOfString:@".com"];
    NSRange searchRange = NSMakeRange(8, endRange.location-4);
    NSString *rstString = [delegate.service_url substringWithRange:searchRange];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Gss Mobile Diagnosis & Checks"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"Gss.Mobile@globalsoft-solutions.com", nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody;
        
        emailBody = [NSString stringWithFormat:@"\nBuild Name: %@ \n GDID: %@ \n Alt.GDID: %@ \n iOS Version: %@ \n Server: %@", delegate.buildName,delegate.GDID,delegate.AltGDID,[[UIDevice currentDevice]systemVersion],rstString];

        emailBody = [NSString stringWithFormat:@"%@ \n\nAPI Diagnosis Report:",emailBody];

        
        if ([objServiceManagementData.diagonseArray count]>0) {
            
            for (NSString *diagnoseStrng in objServiceManagementData.diagonseArray) {
                emailBody =  [NSString stringWithFormat:@"%@ \n%@",emailBody, diagnoseStrng];
                
                NSLog(@"Email body string %@", emailBody);
            }
            
            
        }
        
        
        [mailer setMessageBody:emailBody isHTML:NO];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) showDiagnosisPopup {
    
    AppDelegate_iPhone *obj_delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    if (![obj_delegate.activeApp isEqualToString:@"ServiceOrderEdit"])
    {
        
    if ([objServiceManagementData.diagonseArray count] >  0) {
        NSLog(@"SAP Response Time %@", objServiceManagementData.diagonseArray);
        
        diagPopupView = [[UIView alloc] initWithFrame:CGRectMake(135, 175, 500, 200)];
        //[diagPopupView setBackgroundColor:[UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0]];
        [diagPopupView setBackgroundColor:[UIColor whiteColor]];
        diagPopupView.layer.borderColor = [UIColor blackColor].CGColor;
        diagPopupView.layer.borderWidth = 1.0f;
        [self.view addSubview:diagPopupView];
        
        NSString *emailBodyStr = @"";
        
        for (NSString *diagnoseStrng in objServiceManagementData.diagonseArray) {
            
            emailBodyStr =  [NSString stringWithFormat:@"%@  \n%@",emailBodyStr, diagnoseStrng];
            
        }
        
        NSLog(@"Email Body String %@", emailBodyStr);
        UILabel *headerBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, 400, 25)];
        headerBarTitle.text =@"Gss Mobile Diagnosis & Checks";
        
        //100-149-237
        UIView *headerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 30)];
        [headerBar setBackgroundColor:[UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0]];
        [diagPopupView addSubview:headerBar];
        
        [headerBar addSubview:headerBarTitle];
        
        UITextView *diagTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 32, 442, 132)];
        [diagTextView setBackgroundColor:[UIColor whiteColor]];
        diagTextView.text = emailBodyStr;
        [diagPopupView addSubview:diagTextView];
        [diagTextView release], diagTextView = nil;
        
        //Create Done button to cloase popup
        UIButton *butDiagDone = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        butDiagDone.frame = CGRectMake(444.0, 2.0, 50.0, 20.0);
        [butDiagDone setTitle:@"Done" forState:UIControlStateNormal];
        butDiagDone.backgroundColor = [UIColor clearColor];
        [butDiagDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [butDiagDone addTarget:self action:@selector(DiagPopupDone) forControlEvents:UIControlEventTouchDown];
        [headerBar addSubview:butDiagDone];
        [butDiagDone release], butDiagDone = nil;
        
        
        //create email button to send email
        //Create Done button to cloase popup
        UIButton *butDiagEmail = [[UIButton alloc] initWithFrame:CGRectMake(435, 145, 60, 60)];
        //[butDiagEmail setTitle:@"Email" forState:UIControlStateNormal];
        [butDiagEmail setBackgroundImage:[UIImage imageNamed:@"sendemail1.jpeg"] forState:UIControlStateNormal];
        [butDiagEmail addTarget:self action:@selector(sendDiagnoseEmail) forControlEvents:UIControlEventTouchDown];
        [diagPopupView addSubview:butDiagEmail];
        [butDiagEmail release], butDiagEmail = nil;
        
        //Create disable popup button
        UIButton *butDisablePopup = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        butDisablePopup.frame = CGRectMake(270.0, 165.0, 160.0, 25.0);
        [butDisablePopup setTitle:@"Disable Diagnosis" forState:UIControlStateNormal];
        butDisablePopup.backgroundColor = [UIColor redColor];
        [butDisablePopup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
        [butDisablePopup addTarget:self action:@selector(DisablePopup) forControlEvents:UIControlEventTouchDown];
        [diagPopupView addSubview:butDisablePopup];
        [butDisablePopup release], butDisablePopup = nil;
        
        
        [headerBarTitle release], headerBarTitle = nil;
        [headerBar release], headerBar = nil;
        // [self openMail];
    }
    }
    
}

-(void) DisablePopup {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Servicepro" ofType:@"plist"];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
//    [dictionary setValue:[NSNumber numberWithBool:NO] forKey:@"DiagnosePopup"];
//    [dictionary writeToFile:path atomically:YES];
    int popupStatus =0;
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"UPDATE TBL_SETTING SET diagnosepopup = %d", popupStatus];
    [objServiceManagementData excuteSqliteQryString:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];
 

    
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    objAppDelegate_iPHone.diagnoseSwitchStatus = NO;
    
    NSLog(@"Diag Status %hhd", objAppDelegate_iPHone.diagnoseSwitchStatus);
    [self DiagPopupDone];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
}














#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}



- (void)dealloc {
	[super dealloc];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

