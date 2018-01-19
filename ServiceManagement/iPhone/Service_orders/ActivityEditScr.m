//
//  ActivityEditScr.m
//  ServiceManagement
//
//  Created by gss on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityEditScr.h"

#import "ServiceManagementData.h"
#import "CustomPickerControl.h"
#import "StaticData.h"
#import "CustomDatePicker.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate_iPhone.h"

#import "CustomAlertView.h"


//#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

#import "CheckedNetwork.h"

CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;

CustomAlertView *customAlt;

@implementation ActivityEditScr

@synthesize myTableView;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize commonLabel;

@synthesize updateResponseMsgArray;
@synthesize updateSucessFlag;

@synthesize alert;

@synthesize textDuratiobn;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = NSLocalizedString(@"Activity_title","");
	

	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
	
	//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_title",@"") style:UIBarButtonItemStylePlain target:self action:@selector(SaveTask)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
	
	
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	[objServiceManagementData.taskDataDictionary removeAllObjects];
    objServiceManagementData.taskDataDictionary = [objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId];    
    
	/*
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"OBJECT_ID"] forKey:@"OBJECT_ID"];	
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PROCESS_TYPE"] forKey:@"PROCESS_TYPE"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"ZZKEYDATE"] forKey:@"ZZKEYDATE"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PARTNER"] forKey:@"PARTNER"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"NAME_ORG1"] forKey:@"NAME_ORG1"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"NAME_ORG2"] forKey:@"NAME_ORG2"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"CITY"] forKey:@"CITY"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"POSTL_COD1"] forKey:@"POSTL_COD1"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STREET"] forKey:@"STREET"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"HOUSE_NO"] forKey:@"HOUSE_NO"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STR_SUPPL1"] forKey:@"STR_SUPPL1"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"COUNTRYISO"] forKey:@"COUNTRYISO"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"REGION"] forKey:@"REGION"];
	
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"TXT30"] forKey:@"TXT30"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"TXT30"] forKey:@"TXT30"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"CP1_NAME1_TEXT"] forKey:@"CP1_NAME1_TEXT"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"CP2_TEL_NO"] forKey:@"CP2_TEL_NO"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"CP2_TEL_NO2"] forKey:@"CP2_TEL_NO2"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"DESCRIPTION"] forKey:@"DESCRIPTION"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PRIORITY"] forKey:@"PRIORITY"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"IB_IBASE"] forKey:@"IB_IBASE"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"IB_INSTANCE"] forKey:@"IB_INSTANCE"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"SERIAL_NUMBER"] forKey:@"SERIAL_NUMBER"];
	[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"REFOBJ_PRODUCT_ID"] forKey:@"REFOBJ_PRODUCT_ID"];
	*/
    
	//Set some extra keys for display in to page...
	[objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON"];
	[objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON_DESCRIPTION"];
	[objServiceManagementData.taskDataDictionary 	setObject:@"Indian Standard Time" forKey:@"TIME_ZONE"];
	
	
	
	//Adding the STATUS value to dictionary depending upon the 'taskStatusMappingArray' list..there status is mapped.. 
	[objServiceManagementData.taskDataDictionary setObject:[[objStaticData.taskStatusMappingArray objectAtIndex:0] 
															objectForKey:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STATUS"]] 
													forKey:@"STATUS"];
	
	
	
    [super viewDidLoad];
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
	
	if(indexPath.row == 0 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Activity",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
	}
	else if(indexPath.row == 1 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_DurationHrs",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
	}
	else if(indexPath.row == 2 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_StartTime",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]];
	}
	else if(indexPath.row == 3 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_EndDateTime",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
	}
	else if(indexPath.row == 4 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Notese",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]];
	}
	else 
		rowHeight = 45.0f;
	
	
	return rowHeight;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed.. 
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"]) 
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
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	
	cell.textLabel.numberOfLines = 1;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	/*
	 "Confirmation_Activity_Label_Activity" ="Activity";
	 "Confirmation_Activity_Label_DurationHrs" = "Duration Hrs";
	 "Confirmation_Activity_Label_StartDateTime" = "Start Dt. Time";
	 "Confirmation_Activity_Label_EndDateTime" = "End Dt. Time";
	 "Confirmation_Activity_Label_Notes" = "Notes";
	 "Confirmation_Activity_Button_Label_Done" = "Done";
	 */
	
	if(indexPath.section == 0)
	{
		
			switch (indexPath.row) {
					
				case 0:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Group",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Group",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :13.0 :100.0 :20.0 :1];
					 commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					break;
					
					
				case 1:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Code",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Code",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					textDuration  = [Design textFieldFormation:153.0 :5.0 :140.0 :30.0 :1 :self];
					textDuration.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
					[cell.contentView addSubview:textDuration];
					
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]:2]:15.0f :2];	
					 commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 
					 commonLabel = [Design LabelFormation:153.0 :13.0 :100.0 :20.0 :1];
					 commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"];
					 
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					break;
				case 2:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Desc",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Desc",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					UITextView *textSymptomDesc = [Design textViewFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					textSymptomDesc.editable = TRUE;
					textSymptomDesc.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					textSymptomDesc.layer.masksToBounds = YES;
					textSymptomDesc.layer.cornerRadius = 3.0;
					textSymptomDesc.layer.borderWidth = 1.0;
					textSymptomDesc.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
					[cell.contentView addSubview:textSymptomDesc];
					
					//taskCategory = [Design textFieldFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					//taskCategory.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
				    //taskCategory.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					//[cell.contentView addSubview:taskCategory];
					
					break;
				
					
				case 3:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Group",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Group",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :13.0 :180.0 :20.0 :1];			
					 
					 commonLabel.text = 	[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];			
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					
					break;
					
				case 4:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Code",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Code",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :13.0 :100.0 :20.0 :1];
					 commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					break;
					
				case 5:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Desc",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Desc",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					UITextView *textProblemDesc = [Design textViewFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					textProblemDesc.editable = TRUE;
					textProblemDesc.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					textProblemDesc.layer.masksToBounds = YES;
					textProblemDesc.layer.cornerRadius = 3.0;
					textProblemDesc.layer.borderWidth = 1.0;
					textProblemDesc.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
					[cell.contentView addSubview:textProblemDesc];
					
					//taskCategory = [Design textFieldFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					//taskCategory.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
				    //taskCategory.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					//[cell.contentView addSubview:taskCategory];
					
					break;
					
				case 6:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Group",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Group",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :13.0 :180.0 :20.0 :1];			
					 
					 commonLabel.text = 	[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];			
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					
					break;
					
				case 7:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Code",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Code",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:153.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]:2]:15.0f :2];	
					commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					/*
					 commonLabel = [Design LabelFormation:153.0 :13.0 :100.0 :20.0 :1];
					 commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					 commonLabel.textColor = [UIColor blackColor];
					 commonLabel.font = [UIFont systemFontOfSize:15.0f];
					 [cell.contentView addSubview:commonLabel];
					 [commonLabel release], commonLabel = nil;
					 */
					break;
					
				case 8:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Desc",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Desc",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					UITextView *textCauseDesc = [Design textViewFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					textCauseDesc.editable = TRUE;
					textCauseDesc.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					textCauseDesc.layer.masksToBounds = YES;
					textCauseDesc.layer.cornerRadius = 3.0;
					textCauseDesc.layer.borderWidth = 1.0;
					textCauseDesc.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
					[cell.contentView addSubview:textCauseDesc];
					
					//taskCategory = [Design textFieldFormation:153.0 :5.0 :140.0 :70.0 :1 :self];
					//taskCategory.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
				    //taskCategory.text = @"sdsdfffffffffffffffffffffffffffffffwerwerewrewrewrwerwrwerwrewrewrwerwerwerewrewrewdsfsdgfdgfrfggngfbgfbfbdfvdfvdvdfvdfvfegergergerrebreberberb";
					//[cell.contentView addSubview:taskCategory];
					
					break;
					
				
		}
		
	}
	
    
    return cell;
}


//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
	{		
		if(indexPath.row == 1)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus"];
		}
		else if(indexPath.row == 2)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskReasonArray PickerName:@"TaskReason"];
			
		}
		else if(indexPath.row == 4)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskPriorityArray PickerName:@"TaskPriority"];
			
		}
		else if(indexPath.row == 5)
		{
			//calling date piker common class
			[datePicker datePickerView:self.myTableView :@"DueDate"];
		}
		else if(indexPath.row == 6)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];	
			
		}
	}
	else {
		if(indexPath.row == 1)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus"];
		}		
		else if(indexPath.row == 2)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskPriorityArray PickerName:@"TaskPriority"];			
		}
		else if(indexPath.row == 3)
		{
			[datePicker datePickerView:self.myTableView :@"DueDate"];
		}
		else if(indexPath.row == 4)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];				
		}
	}
	
	
}


//Text View delegate functions Start

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	CGPoint pt;
	pt = self.myTableView.contentOffset;	
	/*
	 if(pt.y >= 0 && pt.y <= 150){
	 if(textView == soleOwnerTextView && touchCountSecureProperty%2 != 0)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+70.0) animated:YES];
	 else if(textView == unoccupiedTextView)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+90.0) animated:YES];
	 else if(textView == propertyLentTextView)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+110.0) animated:YES];
	 }
	 */
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//Enter the reason into the dictionary..
	if(textView ==self.taskReason)
		[objServiceManagementData.taskDataDictionary setObject:textView.text forKey:@"REASON_DESCRIPTION"];
	
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {		
		[textView resignFirstResponder];
		return FALSE;
	}
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
	textView.text = @"";
	textView.textColor = [UIColor blackColor];
}
//End of Text View delegate functions



//Text filed delegate functions
-(void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	[self saveData:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return TRUE;
}
//--End of delegate function of textfiled

-(void) saveData:(UITextField*)textfield {
	
	
}

//Saving the task... caling while trying to back Service Orders (Task) list page
-(void) SaveTask
{
	if([taskReason isFirstResponder])
		[taskReason resignFirstResponder];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];	
	
	if( 
	   (![[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"STATUS"]]) ||
	   (![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:[[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"ZZKEYDATE"]])	   
	   )
	{
		//Alert while try to back ..previous page...
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit_Task_SaveTask_alert_title",@"") 
										   message:NSLocalizedString(@"Edit_Task_SaveTask_alert_msg",@"")
										  delegate:self 
								 cancelButtonTitle:NSLocalizedString(@"Edit_Task_SaveTask_alert_Cancel_title",@"")											
								 otherButtonTitles:NSLocalizedString(@"Edit_Task_SaveTask_alert_Other_title",@""),
				 nil];
		alert.tag = 2; //Set the tag to tack, which alert is clicked..
		[alert show];
		//[alert release];
	}
	else {
		
		//modifySearchWhenBackFalg this flag for modify the search list.. if any text is present..modify the list with specified search string......
		AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
		delegate.modifySearchWhenBackFalg = TRUE;
		
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}



//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex==0)
	{	
		if(alertView.tag==3 || alertView.tag==4)
		{			
			AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
			delegate.modifySearchWhenBackFalg = TRUE;
			
			[self.navigationController popViewControllerAnimated:YES];
		}
		else if(alertView.tag==5)
		{		
			AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
			delegate.modifySearchWhenBackFalg = TRUE;
			
			self.view.userInteractionEnabled = TRUE;
			self.navigationItem.leftBarButtonItem.enabled = TRUE;
			[self.navigationController popViewControllerAnimated:YES];
		}
		else {
			[alert release];
			
			AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
			delegate.modifySearchWhenBackFalg = TRUE;
			
			[self.navigationController popViewControllerAnimated:YES];
		}
		
	}
	else {	
		
		//In this block caling function to update in SAP as well as sqlite 
		self.view.userInteractionEnabled = FALSE;
		self.navigationItem.leftBarButtonItem.enabled = FALSE;
		[self cancelDefaultAlertAndCallSAPUpdate];	
		
		
		
		//[self performSelector:@selector(cancelDefaultAlertAndCallSAPUpdate) withObject:@"" afterDelay:1.1];
	}		
}


//caling function to update in SAP as well as sqlite 
-(void)cancelDefaultAlertAndCallSAPUpdate
{
	[alert dismissWithClickedButtonIndex:1 animated:YES];
	[alert release];
	
	self.updateResponseMsgArray = [[NSMutableArray alloc] init];
	self.updateSucessFlag = TRUE;
	
	if([CheckedNetwork connectedToNetwork]) //Checking for net connection...
	{
		customAlt = [[CustomAlertView alloc] init];
		[self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):90.0 :160.0 :140.0 :125.0]];
		
		
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		objStaticData = [StaticData sharedStaticData];
		
		NSString *statusStr = @"";		
		if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"In Process"])
			statusStr = @"INPR";
		else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Released"])
			statusStr = @"WAIT";
		else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
			statusStr = @"RJCT";
		else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Completed"])
			statusStr = @"COMP";
		else 
			statusStr = @"OPEN";
		
		
		//Creating Sql string for updating a task..
		NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', PRIORITY='%@' WHERE OBJECT_ID='%@' ",
							  [objServiceManagementData.dataTypeArray objectAtIndex:0],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"],
							  statusStr,
							  [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
		
		
		//Creating the parameter of SOAP call to pass SAP...
		NSString *strPar5 = [NSString stringWithFormat:@"ZGSCSMST_SRVCDCMNT21[.]00%@[.]%@[.]%@[.]%@",
							 [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
							 [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
							 [objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"],
							 statusStr];
		
		
		
		
		
		if([self updatetaskInSAPServer:strPar5]) //Update sqlite DB..
		{			
			if([objServiceManagementData updateTaskList:sqlQuery])
			{
				ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
				//NSLog(@"taskListArray count edit task page=%d",[objServiceManagementData.taskListArray count]);
				
				[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID='%@'",
																  [objServiceManagementData.dataTypeArray objectAtIndex:0],
																  [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]]:objServiceManagementData.editTaskId];
				
				
				//Delete Existing Records from table
				NSString *sqlDeleteQuery = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND STATUS='RJCT'",
											[objServiceManagementData.dataTypeArray objectAtIndex:0],
											[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
				NSLog(@"%@",sqlDeleteQuery);
				[objServiceManagementData deleteDataFromServiceManagmentDB:sqlDeleteQuery];	
				
				
				//Removing custome alert view...
				[customAlt removeAlertForView];
				[customAlt release];
				
				NSString *alertMsg = @"";
				
				for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
				{
					alertMsg = [alertMsg stringByAppendingString:[self.updateResponseMsgArray objectAtIndex:i]]; 
					
					if(i<([self.updateResponseMsgArray count]- 1))
					{
						alertMsg = [alertMsg stringByAppendingString:@"\n"];
					}
				}
				
				
				
				
				
				//Display the alert which is got from SAP response...
				
				//selvan  "message:alertMsg" i changed this line for demo purpose
				
				UIAlertView *responseSuccess = [[UIAlertView alloc] 
												initWithTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_title",@"") 
												message:@""  
												delegate:self 
												cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_Cancel_title",@"") 
												otherButtonTitles:nil];
				[responseSuccess show];
				responseSuccess.tag = 5;
				[responseSuccess release];
				
				//[self.navigationController popViewControllerAnimated:YES];	
				
			}			
			
		}
		else {
			
			//Removing custome alert view...
			[customAlt removeAlertForView];
			[customAlt release];
			
			NSString *alertMsg = @"";
			
			for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
			{
				alertMsg = [alertMsg stringByAppendingString:[self.updateResponseMsgArray objectAtIndex:i]]; 
				
				if(i<([self.updateResponseMsgArray count]- 1))
				{
					alertMsg = [alertMsg stringByAppendingString:@"\n"];
				}
			}
			
			//NSLog(@"alertMsg=%@",alertMsg);
			
			
			UIAlertView *responseError = [[UIAlertView alloc] 
										  initWithTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_alert_title",@"") 
										  message:alertMsg //NSLocalizedString(@"Edit_Task_TaskUpdation_alert_msg",@"")  
										  delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_alert_Cancel_title",@"") 
										  otherButtonTitles:nil];
			[responseError show];
			responseError.tag = 4;
			[responseError release];
		}	
	}
	else {
		self.view.userInteractionEnabled = TRUE;
		self.navigationItem.leftBarButtonItem.enabled = TRUE;
		
		//NET conenction checking laert...
		UIAlertView *netCoennectionCheckingAlert = [[UIAlertView alloc] 
													initWithTitle:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_title",@"")
													message:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_msg",@"")
													delegate:self
													cancelButtonTitle:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_Cancel_title",@"") 
													otherButtonTitles:nil];
		[netCoennectionCheckingAlert show];
		netCoennectionCheckingAlert.tag = 3;
		[netCoennectionCheckingAlert release];		
	}
	
	
	
}

-(BOOL)updatetaskInSAPServer:(NSString *)strPar5
{
	
	
	//Calling SOAP to update in SAP......
	
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];	
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:delegate.service_url];	
	binding1.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:BB";
	//par1.Cdata = @"DEVICE-ID:D971615B-5C09-5EA9-8809-A317C65D1C40:DEVICE-TYPE:BB";
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par3.Cdata = @"EVENT[.]SERVICE-DOX-STATUS-UPDATE[.]VERSION[.]0";	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par4 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par4.Cdata = @"DATA-TYPE[.]ZGSCSMST_SRVCDCMNT21[.]OBJECT_ID[.]PROCESS_TYPE[.]ZZKEYDATE[.]STATUS";	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par5 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	//par5.Cdata = @"ZGSCSMST_SRVCDCMNT21[.]0060000017[.]ZFSO[.]2011-02-09[.]INPR";	
	par5.Cdata = strPar5;
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par3];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par4];
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par5];
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request1.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update;	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp1 = [binding1 ZGssmwfmHndlEvntrqst00UsingParameters:request1];
	
	
	
	//NSString *str = @"<DpostOtpt><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-C-A[.]Cylinder Type A[.][.]EA</Cdata></item><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-C-STD-A[.]Cylinder Type Standard A[.][.]EA</Cdata></item><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-C-STD-B[.]Cylinder Type Standard B[.][.]EA</Cdata></item><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-N01-509[.]Liquid Nitrogen 509 SCF[.]EA[.]FT3</Cdata></item><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-P-1[.]Pallet  1 for Bigger Cylinders[.][.]EA</Cdata></item><item><Cdata>ZGSCSMST_EMPLYMTRLLIST10[.]SCHADHA[.]TCC-P-2[.]Pallet  2 for Smaller Cylinders[.][.]EA</Cdata></item></DpostOtpt>";
	CXMLDocument *doc1 = [[CXMLDocument alloc] initWithData:resp1.getResponseData options:0 error:nil];
	//CXMLDocument *doc1 = [[CXMLDocument alloc] initWithData:[NSMutableData dataWithLength:[str length]] options:0 error:nil];
	
	
	
	
	//Parsing the response...
	NSArray *nodes = NULL;
	nodes = [doc1 nodesForXPath:@"//DpostOtpt" error:nil];
	
	for(CXMLDocument *node in nodes)
	{		
		for(CXMLNode *childNode in [node children])
		{	
			
			if(![[childNode name] isEqualToString:@"item"])
			{
				break;
			}
			
			if([[childNode name] isEqualToString:@"item"])
			{		
				//NSLog(@"childNode name=%@",[childNode name]);
				//NSLog(@"childNode value=%@",[childNode stringValue]);
				
				for(CXMLNode *childNode2 in [childNode children])
				{
					//NSLog(@"childNode2 name=%@",[childNode2 name]);
					//NSLog(@"childNode2 value=%@",[childNode2 stringValue]);
					
					if([childNode2 stringValue]!=nil)
					{
						if([[childNode2 stringValue] rangeOfString:@"EVENT-RESPONSE"].location != NSNotFound)
						{
							//self.updateResponseStr = [[childNode2 stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
							//self.updateResponseStr = @"ERROR";
							[self.updateResponseMsgArray addObject:[childNode2 stringValue]];
							self.updateSucessFlag = TRUE; 
						}
						
					}						
				}
			}
		}
	}
	
	
	//Parsing response... while any error occur.. at that time 'DpostOtpt' will be nill and value will be in 'DpostMssg' tag..
	NSArray *nodes2 = NULL;
	nodes2 = [doc1 nodesForXPath:@"//DpostMssg" error:nil];
	
	for(CXMLDocument *node in nodes2)
	{		
		for(CXMLNode *childNode in [node children])
		{				
			if([[childNode name] isEqualToString:@"item"])
			{		
				//NSLog(@"childNode name=%@",[childNode name]);
				//NSLog(@"childNode value=%@",[childNode stringValue]);
				
				for(CXMLNode *childNode2 in [childNode children])
				{
					//NSLog(@"childNode2 name=%@",[childNode2 name]);
					//NSLog(@"childNode2 value=%@",[childNode2 stringValue]);					
					
					if([[childNode2 name] isEqualToString:@"Message"] && [childNode2 stringValue]!=nil )
					{
						[self.updateResponseMsgArray addObject:[childNode2 stringValue]];						
						self.updateSucessFlag = FALSE;
					}											
				}
			}
		}
	}
	
	
	
	return self.updateSucessFlag;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	
	[self.myTableView release], myTableView = nil;
	[self.detailsTask release], detailsTask = nil;
	[self.taskReason release], taskReason = nil;
	[self.taskCategory release], taskCategory = nil;
	[self.displayTask release], displayTask = nil;
	[self.updateResponseMsgArray release], updateResponseMsgArray = nil;
	//[self.updateResponseStr release], self.updateResponseStr = nil;
    [super dealloc];
	
}


@end
