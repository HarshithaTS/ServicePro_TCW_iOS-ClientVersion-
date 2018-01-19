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
#import "ServiceConfirmation.h"
#import "AppDelegate_iPhone.h"
#import "Constants.h"
#import "TaskLocationMapView.h"
#import "MainMenu.h"
#import "ColleagueList.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
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

@synthesize sBar;
@synthesize searching;
@synthesize dubArrayList;

@synthesize searchHaldleFlagWhenBack;


#pragma mark -
#pragma mark View lifecycle


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
	
    
    
   
    
    
	[self.myTableView reloadData];
    
    
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
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
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //end
    
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.localImageFilePath = @"";
    
	
	/*//Alloc right side bar button.. to ordering the task list orders..
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_Menu",@"") style:UIBarButtonItemStylePlain target:self action:@selector(orderingTask:)];
     [[self navigationItem] setRightBarButtonItem:barButton];
     [barButton release], barButton = nil;	*/
    
    //Added back bar button
	UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_Main_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barBackButton;
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
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM 'TBL_ERRORLIST' WHERE 1"];
    
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"error table" :1];
    
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
        
    gss_qp_pastboard *obj_gss_qp_pastboard = [[gss_qp_pastboard alloc] init];
    NSMutableArray *pastboarderrorItemArray = [[NSMutableArray alloc] init];
    pastboarderrorItemArray = [obj_gss_qp_pastboard getErrorItemsFromPastBoard:@"Backprocess"];
    
    NSLog(@"ARR %@", pastboarderrorItemArray);
    
    //IF ERROR RECORD FOUND INSERT INTO ERROR TABLE
    for (int index=0; index < [pastboarderrorItemArray  count]; index++) {
        
        NSDictionary *pastBoardDataDic =
        [pastboarderrorItemArray  objectAtIndex:index ];
        
        NSLog(@"arr %@", pastBoardDataDic);
        NSString *appnameStr = [NSString stringWithFormat:@"%@",
                                [[NSString alloc] initWithData:[pastBoardDataDic valueForKey:@"appname"] encoding:NSUTF8StringEncoding]];
        
        if ([appnameStr isEqualToString:@"SERVICEPRO"]) {
            NSString *sqlQry =
            [NSString stringWithFormat:@"INSERT INTO TBL_ERRORLIST (apprefid,appname,apiname,errtype,errdesc,errdate,status) VALUES ('%@','%@','%@','%@','%@','%@',1)",
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
            
            if([objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQry :@"ServiceReportsDB.sqlite"])
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
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

//Action sheet for ordering the service orders (Task list)
-(IBAction)orderingTask:(id)sender
{
    
	UIActionSheet *orderTaskActionSheet = [[UIActionSheet alloc]
                                           initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_title",@"")
                                           delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Cancel_title",@"")
                                           destructiveButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_DueDate",@"")
                                           otherButtonTitles:NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Priority",@""),
										   NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Status",@""),
										   NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Subject",@""),
                                           NSLocalizedString(@"Servic_Orders_ActionSheet_Order_Task_List_Rep", @"")
										   ,nil];
	
	orderTaskActionSheet.tag = 1; //I have set tag, because two action sheet is present in this class..
	[orderTaskActionSheet showInView:self.view];
	[orderTaskActionSheet release], orderTaskActionSheet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(IS_IPAD) {
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,900,T_HEADER_TABLE_HEIGHT)];
    
    UIColor *BorderColor = [UIColor darkTextColor];
    
    
    UILabel *service_H_STS = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_STS_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_STS_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_STS.layer.borderColor = [BorderColor CGColor];
    service_H_STS.layer.cornerRadius = T_HEADER_CORNER_RADIUS;
    service_H_STS.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    service_H_STS.tag = T_HEADER_STS_TAG;
    service_H_STS.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    service_H_STS.text = @"";
    
    [headerView addSubview:service_H_STS];
    //[service_H_STS release],service_H_STS=nil;
    
    
    
    UILabel *service_H_StartDate = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_STD_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_STD_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_StartDate.tag = T_HEADER_STD_TAG;
    service_H_StartDate.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    service_H_StartDate.textColor = [UIColor whiteColor];
    
    service_H_StartDate.layer.borderColor = [BorderColor CGColor];
    service_H_StartDate.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    service_H_StartDate.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
    
    [service_H_StartDate setTextAlignment:NSTextAlignmentLeft];
    
    service_H_StartDate.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"Service_Order_Table_Header_Title_Start_Date",@"")];
    
    [headerView addSubview:service_H_StartDate];
    //[service_H_StartDate release],service_H_StartDate=Nil;
    
    
    
    UIButton *service_H_CustL = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_CUSTL_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_CUSTL_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_CustL.tag = T_HEADER_CUSTL_TAG;
    [service_H_CustL setTitle:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"Service_Order_Table_Header_Title_CustL",@"")] forState:UIControlStateNormal];
    service_H_CustL.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    
    // service_H_CustL.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [service_H_CustL setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    service_H_CustL.layer.borderColor = [BorderColor CGColor];
    service_H_CustL.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    
    
    
    service_H_CustL.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
    
    [service_H_CustL addTarget:self action:@selector(Click_Cust_Location_HTB:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:service_H_CustL];
    //[service_H_CustL release],service_H_CustL=Nil;
    
    
    UILabel *service_H_EstA = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_ESTARR_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_ESTARR_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_EstA.tag = T_HEADER_ESTARR_TAG;
    service_H_EstA.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    service_H_EstA.textColor = [UIColor whiteColor];
    
    
    service_H_EstA.layer.borderColor = [BorderColor CGColor];
    service_H_EstA.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    service_H_EstA.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
    
    service_H_EstA.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"Service_Order_Table_Header_Title_EstA",@"")];
    
    [headerView addSubview:service_H_EstA];
    // [headerView release],headerView=Nil;
    
    
    
    UIButton *service_H_SerDoc = [[UIButton alloc] initWithFrame:CGRectMake(T_HEADER_SERDOC_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_SERDOC_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_SerDoc.tag = T_HEADER_SERDOC_TAG;
    [service_H_SerDoc setTitle:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"Service_Order_Table_Header_Title_ServiceD",@"")] forState:UIControlStateNormal];
    
    service_H_SerDoc.layer.borderColor = [BorderColor CGColor];
    service_H_SerDoc.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    
    [service_H_SerDoc setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    service_H_SerDoc.titleLabel.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
    
    
    service_H_SerDoc.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    
    [service_H_SerDoc addTarget:self action:@selector(Click_Service_Doc_HTB:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:service_H_SerDoc];
    //[service_H_SerDoc release],service_H_SerDoc=Nil;
    
    
    
    UILabel *service_H_CName = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_CNAME_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_CNAME_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
    service_H_CName.tag = T_HEADER_CNAME_TAG;
    service_H_CName.backgroundColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    service_H_CName.textColor = [UIColor whiteColor];
    
    
    service_H_CName.layer.borderColor = [BorderColor CGColor];
    service_H_CName.layer.borderWidth = T_HEADER_BORDER_WIDTH;
    
    
    service_H_CName.font = [UIFont boldSystemFontOfSize:T_HEADER_FONT_SIZE];
    
    
    service_H_CName.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"Service_Order_Table_Header_Title_CName",@"")];
    [headerView addSubview:service_H_CName];
    
    //[service_H_CName release],service_H_CName=Nil;
    
    
    UILabel *service_H_PDesc = [[UILabel alloc] initWithFrame:CGRectMake(T_HEADER_PDESC_OFFSET,T_HEADER_TABLE_YAXIS,T_HEADER_PDESC_WIDTH,T_HEADER_TABLE_HEIGHT)];
    
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

-(void)Click_Cust_Location_HTB:(id)sender
{
    
    NSLog(@"I clicked Cust Location Button");
    
}


-(void)Click_Service_Doc_HTB:(id)sender
{
    
    NSLog(@"I clicked Service Document Button");
    
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
		
        // NSLog(@"count %d",[objServiceManagementData fetchTotalRecordsCount:objServiceManagementData.serviceReportsDB:[objServiceManagementData.dataTypeArray objectAtIndex:0]]);//
		
        
        //return [objServiceManagementData fetchTotalRecordsCount:objServiceManagementData.serviceReportsDB:[objServiceManagementData.dataTypeArray objectAtIndex:0]];
        NSLog(@"task cnt %d",[objServiceManagementData.taskListArray count]);
        
        return [objServiceManagementData.taskListArray count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    errStatus = FALSE;
    
    UIFont *Font_Size;
   
    static NSString *CellIdentifier = @"Cell";
    
    NSLog(@"task arra %@",objServiceManagementData.taskListArray);
        
    
	
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
        
        //UITableViewCellAccessoryDisclosureIndicator;// ;//  ;
        
        
        
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
        
      /*  UILabel *lbl1 = (UILabel *)[cell viewWithTag:T_TEXT1_TAG];
        lbl1.text = [NSString stringWithFormat:@"%@ ", mTransactionDate];
        lbl1.textColor = [UIColor blueColor];
        
        lbl1.font = Font_Size;*/
        
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT1_TAG andFontS:Font_Size andNOLines:0 andLdata:mTransactionDate];
        
        
        [self Create_Label_Service_Order:cell andTag:T_TEXT2_TAG andFontS:Font_Size andNOLines:5 andLdata:tmpStr];
        
        
       /* UILabel *lbl2 = (UILabel *)[cell viewWithTag:T_TEXT2_TAG];
        lbl2.text = [NSString stringWithFormat:@"%@ ", tmpStr];
        lbl2.font = Font_Size;
        lbl2.textColor = [UIColor blueColor];
        lbl2.numberOfLines = 5;
        lbl2.adjustsFontSizeToFitWidth = YES;
        //lbl2.minimumFontSize = 8.0f;*/
        
        
        UIButton *statusButton = (UIButton *) [cell viewWithTag:T_IMAGE1_TAG];
        [statusButton setImage:[UIImage imageNamed:periorityImageName] forState:UIControlStateNormal];
        //[statusButton setTitle:indexPath.row forState:UIControlStateNormal];
        //[statusButtonutton addTarget:self action:@selector(FaulteditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *taskButton = (UIButton *) [cell viewWithTag:T_IMAGE2_TAG];
        [taskButton setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateNormal];
        //[taskButton setTitle:indexPath.row forState:UIControlStateNormal];
        //[taskButton addTarget:self action:@selector(FaultDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        
       [self Create_Label_Service_Order:cell andTag:T_TEXT5IP_TAG andFontS:Font_Size andNOLines:0 andLdata:[NSString stringWithFormat:@"%@",ContactName]];
        
    
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
    lbl1.textColor = [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0];
    
    if(Lines !=0)
    lbl1.numberOfLines = Lines;
    
    lbl1.adjustsFontSizeToFitWidth = YES;

}


-(void) createStatusButtonImage:(NSMutableDictionary *) _marray
{
    
    Service_Task_Status = NO;
    NSLog(@"periority %@",[_marray objectForKey:@"PRIORITY"]);
    if([[_marray objectForKey:@"PRIORITY"] isEqualToString:@"HIGH"])
    {
        periorityImageName = @"vhigh_icon.png";
    }
    
    else if([[_marray objectForKey:@"PRIORITY"] isEqualToString:@"NORMAL"])
    {
        periorityImageName = @"normal_icon.png";
    }
    else
    {
        periorityImageName = @"low_icon.png";
    }
    //Below four block for handling the task status images... the image name is idicating the status value..
   
    if([[_marray  objectForKey:@"STATUS"] isEqualToString:@"WAIT"])
    {
        statusImageName = @"ready.png";
    }
    else if([[_marray objectForKey:@"STATUS"] isEqualToString:@"ACPT"])
    {
        statusImageName = @"accept.png";
        Service_Task_Status = YES;
        
    }
    else if([[_marray objectForKey:@"STATUS"] isEqualToString:@"DEFR"])
    {
        statusImageName = @"deferred.png";
    }
    else if([[_marray  objectForKey:@"STATUS"] isEqualToString:@"COMP"])
    {
        statusImageName = @"completed.png";
    }
    
    else
    {
        statusImageName = @"declined.png";
    }
    
    
    mTransactionDate = [NSString stringWithFormat: @"%@", [_marray objectForKey:@"DISPLAY_DUE_DATE"]];
    
    
    //Display ETA time format like HH:MM
    if ([[_marray objectForKey:@"ZZETATIME"] isEqualToString:@""]) {
        Est_Arrival = [NSString stringWithFormat: @"%@ %@", [_marray objectForKey:@"ZZETADATE"],[_marray objectForKey:@"ZZETATIME"] ];
    }
    else
        Est_Arrival = [NSString stringWithFormat: @"%@ %@", [_marray objectForKey:@"ZZETADATE"],[[_marray objectForKey:@"ZZETATIME"] substringToIndex:5]];
    
    
    
    ServiceDoc = [NSString stringWithFormat:@"%@" , [_marray objectForKey:@"OBJECT_ID"]];
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
    
    
    
    
    NSString *sqlQryStr2 = [NSString stringWithFormat:@"SELECT * FROM 'TBL_ERRORLIST' WHERE apprefid = '%@'",[_marray objectForKey:@"OBJECT_ID"]];
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr2 :objServiceManagementData.serviceReportsDB:@"error table" :1];
    
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
	cellRectangle = CGRectMake(T_IMAGE2_OFFSET, 40, T_IMAGE2_WIDTH, 25);
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
    
    //Create a rectangle container for the date text.
	//cellRectangle = CGRectMake(T_IMAGE3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_IMAGE3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	//but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	//but.tag = T_IMAGE3_TAG;
	//Add the label as a sub view to the cell.
	//[cell.contentView addSubview:but];
	//[but release];
    
    
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
    
    
    
    //Create a rectangle container for the Contact Name .
	cellRectangle = CGRectMake(T_TEXT5IP_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_TEXT5IP_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = T_TEXT5IP_TAG;
    label.backgroundColor = [UIColor clearColor];
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
    
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
    
    
    
    
    
    
    //Create a rectangle container for the date text.
	//cellRectangle = CGRectMake(T_IMAGE3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, T_IMAGE3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	//but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	//but.tag = T_IMAGE3_TAG;
	//Add the label as a sub view to the cell.
	//[cell.contentView addSubview:but];
	//[but release];
    
    
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
	
    [self gotoServiceDetailPage:indexPath];
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self gotoServiceDetailPage:indexPath];
    
}
-(void) gotoServiceDetailPage: (NSIndexPath *) indexPath {
    // Navigation logic may go here. Create and push another view controller.
	

    //objServiceManagementData.editTaskId = [indexPath row];
    if(self.searching) //while searching...
        objServiceManagementData.editTaskId =  [[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"] integerValue];
	else ///When searching is False..
        objServiceManagementData.editTaskId =  [[[objServiceManagementData.taskListArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"] integerValue];
    

    
 
    ServiceOrderEdit *objServiceOrderEdit = [[ServiceOrderEdit alloc] initWithNibName:@"ServiceOrderEdit" bundle:nil];
    [self.navigationController pushViewController:objServiceOrderEdit animated:YES];
    [objServiceOrderEdit release],objServiceOrderEdit = nil;
    /*
    
    ServiceTaskEdit *objServiceOrderEdit = [[ServiceTaskEdit alloc] initWithNibName:@"ServiceTaskEdit" bundle:nil];
    [self.navigationController pushViewController:objServiceOrderEdit animated:YES];
    [objServiceOrderEdit release],objServiceOrderEdit = nil;

*/
    
}



//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	
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
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DISPLAY_DUE_DATE" ascending:YES];
					self.subjectOrderByFlag = FALSE;
				}
				else {
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DISPLAY_DUE_DATE" ascending:NO];
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

-(void) movetoColleagueList{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.colleagueAction = @"ChangeColleague";
    
    ColleagueList *objColleagueList = [[ColleagueList alloc] initWithNibName:@"ColleagueList" bundle:nil];
    [self.navigationController pushViewController:objColleagueList animated:YES];
    [objColleagueList release], objColleagueList = nil;
    
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
	//[self.myTableView release], self.myTableView = nil;
	///[self.sBar release], self.sBar= nil;
	//[self.dubArrayList release], self.dubArrayList = nil;
    
}

@end

