//
//  ServiceOrders.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*-----Listing the service orders (Task list)....*/

#import "ColleagueTaskList.h"
#import "ServiceManagementData.h"
#import "ServiceConfirmation.h"
#import "AppDelegate_iPhone.h"
#import "Constants.h"
#import "TaskLocationMapView.h"
#import "MainMenu.h"
#import "ColleagueTaskView.h"
#import "ServiceOrders.h"
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"
#import "QuartzCore/QuartzCore.h"
#import "CustomAlertView.h"
#import "ColleagueList.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

#import "CheckedNetwork.h"


CustomAlertView *customAlt;

@implementation ColleagueTaskList

@synthesize myTableView;
@synthesize textView;
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
	self.sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.00, 0.00, 320.00, 42.00)];
	self.sBar.delegate = self;
	self.sBar.placeholder = @"Task Search...";
	[self.view addSubview:sBar];
	self.searching = NO;
	self.searchHaldleFlagWhenBack = NO;
	self.dubArrayList = [[NSMutableArray alloc] init];
	
	    
    
    
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

    self.title = [NSString stringWithFormat:@"Tasks - %@", delegate.colleagueName]; 
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //end


    textView = [Design textViewFormation:10.0 :45.0 :300.0 :80.0 :1 :self];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor blackColor];
    
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8.0;
    textView.layer.borderWidth = 0.75;
    textView.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
    
    textView.text = [NSString stringWithFormat:@"Name :%@\nTel No:%@\nTel No:%@",
                        delegate.colleagueName,
                        delegate.colleagueTelNo,
                        delegate.colleagueTelNo2 ]; 

    
    [self.view addSubview:textView];

     

    if (delegate.colleagueTelNo != @"")
    {
        UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
        telButton.frame = CGRectMake(220, 75, 30, 20);
        [telButton setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
        [telButton addTarget:self action:@selector(dailNumber1) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:telButton];
    }
    
    
    if (delegate.colleagueTelNo2 != @"")
    {
        UIButton *telButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        telButton1.frame = CGRectMake(220, 95, 30, 20);
        [telButton1 setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
        [telButton1 addTarget:self action:@selector(dailNumber2) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:telButton1];
    }
    

	
	//Alloc right side bar button.. to ordering the task list orders..
	//UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_Menu",@"") style:UIBarButtonItemStylePlain target:self action:@selector(orderingTask:)];
	//[[self navigationItem] setRightBarButtonItem:barButton];
	//[barButton release], barButton = nil;	
    
    //Added back bar button
	UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barBackButton;
	[barBackButton release], barBackButton = nil;
     
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];    
    NSLog(@"colleague list %@",objServiceManagementData.colleagueTaskListArray);
    
}
//calling while trying to back Service Orders (Task) list page
-(void) dailNumber2
{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSString *telphone = [NSString stringWithFormat:@"tel:%@",delegate.colleagueTelNo];
    

    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telphone]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }
}
//calling while trying to back Service Orders (Task) list page
-(void) dailNumber1
{
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSString *telphone2 = [NSString stringWithFormat:@"tel:%@",delegate.colleagueTelNo2];
 
    
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telphone2]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }
}


//calling while trying to back Service Orders (Task) list page
-(void) goBack
{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
    return 85.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if(self.searching)
		return [self.dubArrayList count];
	else {		
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];    
		return [objServiceManagementData fetchTotalRecordsCount:objServiceManagementData.serviceReportsDB:[objServiceManagementData.dataTypeArray objectAtIndex:11]];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
    static NSString *CellIdentifier = @"Cell";
   
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

	cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [self taskTableViewCellWithIdentifier:CellIdentifier];
	

	
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	
	
	NSString *periorityImageName = @"";
    NSString *statusImageName = @"";
	NSString *tmpStr = @"";
	NSString *mTransactionDate = @"";
	
	
	if(self.searching) //while searching... 
	{	
        
		//Below four block for handling the task priority images... the image name is idicating the priority value..
		if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PRIORITY"] isEqualToString:@"Very High"])
		{
			periorityImageName = @"vhigh_icon.png";
		}
		else if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PRIORITY"] isEqualToString:@"Medium"])
		{
			periorityImageName = @"normal_icon.png";
		}
		else 
		{
			periorityImageName = @"low_icon.png";
		}
        //Below four block for handling the task status images... the image name is idicating the status value..
		if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"WAIT"])
		{
			statusImageName = @"ready.png";
		}
		else if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"ACPT"])
		{
			statusImageName = @"accept.png";
		}
        else if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"DEFR"])
		{
			statusImageName = @"deferred.png";
		}
		else if([[[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"COMP"])
		{
			statusImageName = @"completed.png";
		}
        
		else 
		{
			statusImageName = @"declined.png";
		}
        
		
		mTransactionDate = [NSString stringWithFormat: @"%@,", [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"DISPLAY_DUE_DATE"]];
        
        
		tmpStr = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@, %@, %@\nDoc# %@",	
                  
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"NAME_ORG1"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"NAME_ORG2"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"STRAS"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"ORT01"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"REGIO"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"PSTLZ"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"LAND1"],
                  [[self.dubArrayList objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"]
                  ];
        
        
        NSLog(@"d list %@",self.dubArrayList);
        
	}
	else ///When searching is False..
	{
		
		if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"PRIORITY"] isEqualToString:@"Very High"])
		{
			periorityImageName = @"vhigh_icon.png";
            
		}
		else if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"PRIORITY"] isEqualToString:@"Medium"])
		{
			periorityImageName = @"normal_icon.png";
		}
		else 
		{
			periorityImageName = @"low_icon.png";		
        }
        
        
        //Below four block for handling the task status images... the image name is idicating the status value..
		if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"WAIT"])
		{
			statusImageName = @"ready.png";
		}
		else if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"ACPT"])
		{
			statusImageName = @"accept.png";
		}
        else if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"DEFR"])
		{
			statusImageName = @"deferred.png";
		}
		else if([[[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"STATUS"] isEqualToString:@"COMP"])
		{
			statusImageName = @"completed.png";
		}       
		else 
		{
			statusImageName = @"declined.png";
		}
        
		
		mTransactionDate = [NSString stringWithFormat: @"%@,", [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"DISPLAY_DUE_DATE"]];
        
        //NSLog(@"Task list %@",objServiceManagementData.taskListArray);
        
		
		tmpStr = [NSString stringWithFormat:@"%@ %@\n%@\n%@, %@, %@, %@\nDoc# %@",
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"NAME_ORG1"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"NAME_ORG2"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"STRAS"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"ORT01"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"REGIO"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"PSTLZ"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"LAND1"],
                  [[objServiceManagementData.colleagueTaskListArray objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"]];
		
	}
    
	
	UILabel *lbl1 = (UILabel *)[cell viewWithTag:T_TEXT1_TAG];
	lbl1.text = [NSString stringWithFormat:@"%@ ", mTransactionDate];
	lbl1.font = [UIFont systemFontOfSize:12.0f];
	
	
	UILabel *lbl2 = (UILabel *)[cell viewWithTag:T_TEXT2_TAG];
	lbl2.text = [NSString stringWithFormat:@"%@ ", tmpStr];
	lbl2.font = [UIFont systemFontOfSize:12.0f];
	lbl2.numberOfLines = 5;
	lbl2.adjustsFontSizeToFitWidth = YES;
	lbl2.minimumFontSize = 8.0f;
	
	
	UIButton *statusButton = (UIButton *) [cell viewWithTag:T_IMAGE1_TAG];
	[statusButton setImage:[UIImage imageNamed:periorityImageName] forState:UIControlStateNormal];
	//[statusButton setTitle:indexPath.row forState:UIControlStateNormal];
	//[statusButtonutton addTarget:self action:@selector(FaulteditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
	UIButton *taskButton = (UIButton *) [cell viewWithTag:T_IMAGE2_TAG];
	[taskButton setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateNormal];
	
    return cell;
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
    
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(T_IMAGE1_OFFSET, 40, T_IMAGE1_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE1_TAG;
    
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(T_IMAGE2_OFFSET, 40, T_IMAGE2_WIDTH, 25);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = T_IMAGE2_TAG;
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
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	[searchArray addObjectsFromArray:objServiceManagementData.colleagueTaskListArray];	
	
	for (int i=0; i<[searchArray count]; i++) {
		
		//If 'searchText' is found in 'TASK_SEARCH_STRING' then add object in dubArrayList...
		if([[[searchArray objectAtIndex:i] objectForKey:@"TASK_SEARCH_STRING"] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)		
		{			
			[self.dubArrayList addObject:[searchArray objectAtIndex:i]];
		}
	}	
	
	[searchArray release], searchArray = nil;
	
}


#pragma mark -
#pragma mark Table view delegate

//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
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
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ZZKEYDATE" ascending:NO];
					self.dueDateOrderByFlag = FALSE;
				}
				else {		
					//orderByStr = @"ASC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ZZKEYDATE" ascending:YES];
					self.dueDateOrderByFlag = TRUE;
				}
				
				if(self.searching)
					[self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				else 
					[objServiceManagementData.colleagueTaskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				
				//[objServiceManagementData.colleagueTaskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY ZZKEYDATE %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
								
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
					[objServiceManagementData.colleagueTaskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				
				//[objServiceManagementData.colleagueTaskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY PRIORITY %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
				
				break;	
			case 2:			
				if(self.statusOrderByFlag == TRUE)
				{
					//orderByStr = @"DESC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STA" ascending:NO];
					self.statusOrderByFlag = FALSE;
				}
				else {		
					//orderByStr = @"ASC";
					aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"STA" ascending:YES];
					self.statusOrderByFlag = TRUE;
				}
				
				if(self.searching)
					[self.dubArrayList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				else 
					[objServiceManagementData.colleagueTaskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				//[objServiceManagementData.colleagueTaskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ORDER BY STATUS %@ ",[objServiceManagementData.dataTypeArray objectAtIndex:0],orderByStr]:-1];
				
				break;
			case 3:
				
				//[objServiceManagementData.colleagueTaskListArray removeAllObjects];
				//[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1 ",[objServiceManagementData.dataTypeArray objectAtIndex:0]]:-1];
				
				
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
					[objServiceManagementData.colleagueTaskListArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
				
				[aSortDescriptor release], aSortDescriptor = nil;
				break;
            case 4:
                [self movetoColleagueList];
                break;

		}
		
				
		[self.myTableView reloadData];
		
		NSLog(@"colleagueTaskListArray count=%d",[objServiceManagementData.colleagueTaskListArray count]);
	}
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
	[self.dubArrayList release], self.dubArrayList = nil;
    
}

@end

