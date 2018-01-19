//
//  ServiceOrderView.m
//  ServiceManagement
//
//  Created by gss on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColleagueTaskView.h"
#import "ServiceManagementData.h"
#import "CustomPickerControl.h"
#import "StaticData.h"
#import "CustomDatePicker.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate_iPhone.h"
#import "ServiceOrders.h"
#import "ServiceConfirmation.h"
#import "Constants.h"
#import "TaskLocationMapView.h"
#import "ColleagueList.h"
#import "MainMenu.h"
#import "CustomAlertView.h"


#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

#import "CheckedNetwork.h"



CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;

CustomAlertView *customAlt;

@implementation ColleagueTaskView

@synthesize myTableView;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize commonLabel;

@synthesize updateResponseMsgArray;
@synthesize updateSucessFlag;

@synthesize alert;
@synthesize object_id;
@synthesize service_url;


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

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"View_Task_title","");
	

	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
	
	//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;

		
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
        
    
	[objServiceManagementData.colleagueTaskDataDictionary removeAllObjects];
	
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"OBJECT_ID"] forKey:@"OBJECT_ID"];	
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PROCESS_TYPE"] forKey:@"PROCESS_TYPE"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"ZZKEYDATE"] forKey:@"ZZKEYDATE"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PARTNER"] forKey:@"PARTNER"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"NAME_ORG1"] forKey:@"NAME_ORG1"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"NAME_ORG2"] forKey:@"NAME_ORG2"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"CITY"] forKey:@"CITY"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"POSTL_COD1"] forKey:@"POSTL_COD1"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STREET"] forKey:@"STREET"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"HOUSE_NO"] forKey:@"HOUSE_NO"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STR_SUPPL1"] forKey:@"STR_SUPPL1"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"COUNTRYISO"] forKey:@"COUNTRYISO"];
	[objServiceManagementData.colleagueTaskDataDictionary 	setObject:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"REGION"] forKey:@"REGION"];
	
	
	//Adding the STATUS value to dictionary depending upon the 'taskStatusMappingArray' list..there status is mapped.. 
	[objServiceManagementData.colleagueTaskDataDictionary setObject:[[objStaticData.taskStatusMappingArray objectAtIndex:0] 
															objectForKey:[[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STA"]] 
													forKey:@"STA"];
	
	
    self.object_id =  [NSString stringWithFormat:@"%@", [[objServiceManagementData.colleagueTaskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"OBJECT_ID"]];

    [super viewDidLoad];

}
//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
	/*ServiceOrders *objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
	[self.navigationController pushViewController:objServiceOrders animated:YES];
	[objServiceOrders release];
	objServiceOrders = nil;*/
    [self.navigationController popViewControllerAnimated:YES];
    
}	


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//calculatinf cell height...
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue
{
	int countCharLabel =  cellLabel.length;
	int countCharLabelValue = cellLabelValue.length;
	
	if(countCharLabel>countCharLabelValue)
	{
		if(countCharLabel>32)
			return 80.0f;
		else if(countCharLabel>16)
			return 60.0f;
		else
			return 40.0f;
	}
	else
	{
		if(countCharLabelValue>42)
			return 80.0f;
		else if(countCharLabelValue>21)
			return 60.0f;
		else
			return 40.0f;
	}	
}

//Calculating label height... caling from cell for row at index path.. to display the text in table view...
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType
{
	int countChar =  cellTextDisplay.length;
	
	if(displayType==1)
	{
		if(countChar>38)
			return 70.0f;
		else if(countChar>16)
			return 50.0f;
		else
			return 30.0f;
	}
	else if(displayType==2)
	{
		if(countChar>42)
			return 70.0f;
		else if(countChar>21)
			return 50.0f;
		else
			return 30.0f;		
	}
	
	return 30.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat rowHeight;
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	if([[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STA"] isEqualToString:@"Declined"]) 
	{
		if(indexPath.row == 0 )
		{
			rowHeight = 95.0f;
		}
		else if(indexPath.row == 1 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Status",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STA"]];
		}
		else if(indexPath.row == 2 )
		{
			if([[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STA"] isEqualToString:@"Declined"])
			{
				rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"REASON"]];
			}
			else {
				rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@""):@""];
			}		
		}
		else if(indexPath.row == 3 )
		{
			rowHeight = 110.0f;
		}
		else if(indexPath.row == 4 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Priority",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PRIORITY"]];
		}
		else if(indexPath.row == 5 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Due",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"ZZKEYDATE"]];
		}
		else if(indexPath.row == 6 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Time_Zone",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"TIME_ZONE"]];
		}
		else if(indexPath.row == 7 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Category",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"OBJECT_ID"]];
		}
		else if(indexPath.row == 8)
			rowHeight = 240.0f;
		else 
			rowHeight = 45.0f;
	}
	else {
		
		if(indexPath.row == 0 )
		{
			rowHeight = 95.0f;
		}
		else if(indexPath.row == 1 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Status",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STA"]];
		}
		else if(indexPath.row == 2 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Priority",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PRIORITY"]];
		}
		else if(indexPath.row == 3 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Due",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"ZZKEYDATE"]];
		}
		else if(indexPath.row == 4 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Time_Zone",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"TIME_ZONE"]];
		}
		else if(indexPath.row == 5 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Category",@""):[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"OBJECT_ID"]];
		}
		else if(indexPath.row == 6)
			rowHeight = 240.0f;
		else 
			rowHeight = 45.0f;
	}
    
	
	
	return rowHeight;	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed.. 
	if([[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STA"] isEqualToString:@"Declined"]) 
	{
		return 9;
	}
	else {
		return 7;
	}
    
	return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];

    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	if(indexPath.section == 0)
	{
            switch (indexPath.row) {
				case 0:				
					
					detailsTask = [Design textViewFormation:10.0 :5.0 :300.0 :80.0 :1 :self];
					detailsTask.backgroundColor = [UIColor clearColor];
					detailsTask.textColor = [UIColor blackColor];
					
					detailsTask.layer.masksToBounds = YES;
					detailsTask.layer.cornerRadius = 8.0;
					detailsTask.layer.borderWidth = 0.5;
					detailsTask.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
					
                    detailsTask.text = [NSString stringWithFormat:@"%@\n %@\n %@",
                                        delegate.colleagueName,
                                        delegate.colleagueTelNo,
                                        delegate.colleagueTelNo2 ]; 
					
					cell.userInteractionEnabled = FALSE;	
					
					[cell.contentView addSubview:detailsTask];
					
					break;
				case 1:
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:@"Object ID:":1]:16.0f :1];	
					commonLabel.text = @"Object ID:";				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"OBJECT_ID"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"OBJECT_ID"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					

					break;
					
                    
				case 2:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:@"Process Type:":1]:16.0f :1];	
					commonLabel.text = @"Process Type:";				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PROCESS_TYPE"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PROCESS_TYPE"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					

					break;
				case 3:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:@"Due:":1]:16.0f :1];	
					commonLabel.text = @"Due:";				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"ZZKEYDATE"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"ZZKEYDATE"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;

					break;
				case 4:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:@"Partner:":1]:16.0f :1];	
					commonLabel.text = @"Partner:";				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PARTNER"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"PARTNER"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    
               
					break;
                    
                  case 5:  
                    commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:@"Organization:":1]:16.0f :1];	
					commonLabel.text = @"Organization:";				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;

 
                    NSString *strValue = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",[objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"NAME_ORG1"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"NAME_ORG2"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"CITY"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"POSTL_CODE1"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STREET"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"HOUSE_NO"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"STR_SUPPL1"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"COUNTRYISO"],
                                          [objServiceManagementData.colleagueTaskDataDictionary objectForKey:@"REGION"]
                                          
                                          ];

                    commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :200:15.0f :2];
					commonLabel.text = strValue;
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    

                    
                    break;

					
            }
    }
    return cell;
}


//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
		
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
