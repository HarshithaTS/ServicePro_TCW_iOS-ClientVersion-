    //
//  ServiceConfActivity.m
//  ServiceManagement
//
//  Created by gss on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceConfActivity.h"
#import "ServiceManagementData.h"
#import "CustomPickerControl.h"
#import "StaticData.h"
#import "CustomDatePicker.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate_iPhone.h"
#import "CurrentDateTime.h"

#import "CustomAlertView.h"
#import "Constants.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

#import "CheckedNetwork.h"

CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;
CurrentDateTime *objCurrentDateTime;
CustomAlertView *customAlt;
const NSInteger kViewTag = 1;
#define kOFFSET_FOR_KEYBOARD 90.0


@implementation ServiceConfActivity

@synthesize myTableView;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize commonLabel;
@synthesize durationhrs;
@synthesize arrayIndex;
@synthesize textNotes;


@synthesize alert;
@synthesize done;
@synthesize textDuratiobn;
@synthesize textFieldActivity,textFieldTimezone;

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = NSLocalizedString(@"Edit_Task_title","");

    self.title =  NSLocalizedString(@"Servic_Orders_title",@""); 
    
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //end

	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		
	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
	objCurrentDateTime = [[CurrentDateTime alloc] init];
	
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;

	/*//Added bar button to get the alert while back from this page..
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release], cancelButton = nil;*/

	//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barSaveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick:)];
	self.navigationItem.rightBarButtonItem = barSaveButton;
	[barSaveButton release], barSaveButton = nil;
    


		
	//if (objServiceManagementData.updatedActivityArrayFlag == FALSE){
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	[objServiceManagementData.taskDataDictionary removeAllObjects];
	
	durationhrs = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"QUANTITY"];


		[objServiceManagementData.taskDataDictionary 	setObject:[NSString stringWithFormat:@"%D",objServiceManagementData.selectedRowIndex] forKey:@"ROWINDEX"];	
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZGSCSMST_SRVCACTVTY10Id"] forKey:@"ZGSCSMST_SRVCACTVTY10Id"];
        [objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"SRCDOC_NUMBER_EXT"] forKey:@"SRCDOC_NUMBER_EXT"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"NUMBER_EXT"] forKey:@"NUMBER_EXT"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"PRODUCT_ID"] forKey:@"PRODUCT_ID"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"QUANTITY"] forKey:@"QUANTITY"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"PROCESS_QTY_UNIT"] forKey:@"PROCESS_QTY_UNIT"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZITEM_DESCRIPTION"] forKey:@"ZZITEM_DESCRIPTION"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZITEM_TEXT"] forKey:@"ZZITEM_TEXT"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"DATE_FROM"] forKey:@"DATE_FROM"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"DATE_TO"] forKey:@"DATE_TO"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"TIME_FROM"] forKey:@"TIME_FROM"];
		[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"TIME_TO"] forKey:@"TIME_TO"];
		//[objServiceManagementData.taskDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"TIMEZONE_FROM"] forKey:@"TIMEZONE_FROM"];
		[objServiceManagementData.taskDataDictionary 	setObject:@"Eastern Standard Time" forKey:@"TIMEZONE_FROM"];
	
		[objServiceManagementData.taskDataDictionary 	setObject:[objCurrentDateTime getDateFromString:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"DATETIME_FROM"]] forKey:@"DATETIME_FROM"];
		[objServiceManagementData.taskDataDictionary 	setObject:[objCurrentDateTime getDateFromString:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"DATETIME_TO"]] forKey:@"DATETIME_TO"];
		[objServiceManagementData.taskDataDictionary    setObject: [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"OBJECT_ID"] forKey:@"OBJECT_ID"];
        [objServiceManagementData.taskDataDictionary    setObject: [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"PRODUCT_ID"] forKey:@"ACTIVITYLIST"];

        
    NSLog(@"taskdata %@",objServiceManagementData.taskDataDictionary);
		
	//	}
	//else {
	//	durationhrs = [objServiceManagementData.taskDataDictionary objectForKey:@"QUANTITY"];

	//}
		
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
//calculatinf cell height...
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue{
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
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType{
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Timezone",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
		}
		else if(indexPath.row == 5 )
		{
			rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Notese",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]];
		}
		else 
			rowHeight = 45.0f;

	
	return rowHeight;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
    NSString *strDATEFROM;
    NSString *strDATETO;
        
    strDATEFROM = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"DATE_FROM"],[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_FROM"]];
    
    
    strDATETO = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"DATE_TO"],[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_TO"]];
   
    
	cell.textLabel.numberOfLines = 1;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	

	
	if(indexPath.section == 0)
	{
		
			switch (indexPath.row) {
				
				case 0:
	
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
                    
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Activity",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_Activity",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					CGRect frame = CGRectMake(113, 5.0, 200.0, 30.0);
					textFieldActivity = [[UITextField alloc] initWithFrame:frame];
					self.textFieldActivity.borderStyle =  UITextBorderStyleRoundedRect;
					self.textFieldActivity.textColor = [UIColor blackColor];
					self.textFieldActivity.font = [UIFont systemFontOfSize:17.0];
					self.textFieldActivity.placeholder = @"Select Activity";
					self.textFieldActivity.backgroundColor = [UIColor whiteColor];
					
					self.textFieldActivity.keyboardType = UIKeyboardTypeDefault;
					self.textFieldActivity.returnKeyType = UIReturnKeyDone;	
					
					self.textFieldActivity.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					self.textFieldActivity.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					self.textFieldActivity.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ACTIVITYLIST"];
					
					// Add an accessibility label that describes the text field.
					[self.textFieldActivity setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					self.textFieldActivity.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					self.textFieldActivity.rightViewMode = UITextFieldViewModeAlways;
					self.textFieldActivity.enabled = FALSE;
					self.textFieldActivity.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:self.textFieldActivity];					
					
					break;	

				case 1:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_DurationHrs",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_DurationHrs",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					textDuration  = [Design textFieldFormation:113.0 :5.0 :80.0 :30.0 :1 :self];
					textDuration.text = self.durationhrs;
					textDuration.enabled = YES;
					textDuration.textAlignment= UITextAlignmentRight;
					textDuration.clearsOnBeginEditing = YES;
                    textDuration.keyboardType = UIKeyboardTypeNumberPad;
					[cell.contentView addSubview:textDuration];
				//NSLog(@"durationhrs %@",durationhrs);
					
					
					break;
				case 2:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
      				commonLabel = [Design LabelFormation:5.0:5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_StartTime",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_StartTime",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:113.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"]:2]:12.0f :2];	
					//commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"];
                    commonLabel.text = strDATEFROM;
                    
                    //commonLabel.text = [objCurrentDateTime getDateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"]];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
									
					break;
				case 3:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_EndDateTime",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_EndDateTime",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:113.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"]:2]:12.0f :2];	
					//commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"];
                    commonLabel.text = strDATETO;
                    
                    //commonLabel.text = [objCurrentDateTime getDateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"] ];
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
		
					break;
					
				case 4:
					//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Timezone",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_Timezone",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					CGRect frame1 = CGRectMake(113, 5.0, 200.0, 30.0);
					textFieldTimezone = [[UITextField alloc] initWithFrame:frame1];
					self.textFieldTimezone.borderStyle =  UITextBorderStyleRoundedRect;
					self.textFieldTimezone.textColor = [UIColor blackColor];
					self.textFieldTimezone.font = [UIFont systemFontOfSize:12.0];
					self.textFieldTimezone.placeholder = @"Select Time Zone";
					self.textFieldTimezone.backgroundColor = [UIColor whiteColor];
					
					self.textFieldTimezone.keyboardType = UIKeyboardTypeDefault;
					self.textFieldTimezone.returnKeyType = UIReturnKeyDone;	
					
					self.textFieldTimezone.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					self.textFieldTimezone.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					self.textFieldTimezone.enabled = FALSE;
					self.textFieldTimezone.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"];
					
					// Add an accessibility label that describes the text field.
					[self.textFieldTimezone setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					self.textFieldTimezone.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					self.textFieldTimezone.rightViewMode = UITextFieldViewModeAlways;
					
					self.textFieldTimezone.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:self.textFieldTimezone];	
					
					break;
				case 5:

                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
					//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
					
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_Notes",@""):1]:14.0f :1];	
					commonLabel.text = NSLocalizedString(@"Confirmation_Activity_Label_Notes",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
                    
					textNotes = [Design textViewFormation:113.0 :5.0 :200.0 :70.0 :1 :self];
					self.textNotes.editable = TRUE;
					self.textNotes.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZITEM_DESCRIPTION"];
					self.textNotes.layer.masksToBounds = YES;
					self.textNotes.layer.cornerRadius = 3.0;
					self.textNotes.layer.borderWidth = 1.0;
					self.textNotes.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
					[cell.contentView addSubview:self.textNotes];
					break;

		}
			
	}
	
    
    return cell;
}


//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		if(indexPath.row == 0)
		{
			if ([[objServiceManagementData.taskDataDictionary objectForKey:@"ROWINDEX"] intValue] > 0) {
                
               
				//calling picker view
				[pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.activityListArrayPicker PickerName:@"ActivityList"];
				
			}
					
		}
		else if(indexPath.row == 1)
		{
			durationhrs = textDuration.text;
			[objServiceManagementData.taskDataDictionary setObject:durationhrs forKey:@"QUANTITY"];

		}
		else if(indexPath.row == 2)
		{
			//calling date piker common class
			[datePicker datePickerView:self.myTableView :@"ActDateFrom"];
		}
		else if(indexPath.row == 3)
		{
			//calling date piker common class
			[datePicker datePickerView:self.myTableView :@"ActDateTo"];
		}
		else if(indexPath.row == 4)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];
		}
    

}




//Text View delegate functions Start

- (void)textViewDidBeginEditing:(UITextView *)sender {
 
	//_textField = textNotes;
	CGPoint pt;
	pt = self.myTableView.contentOffset;	
	if ([sender isEqual: textDuration] || [sender isEqual: textFieldTimezone] || [sender isEqual:textNotes])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//Enter the reason into the dictionary..
	[objServiceManagementData.taskDataDictionary setObject:self.textNotes.text forKey:@"ZZITEM_DESCRIPTION"];
	[self setViewMovedUp:NO];
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
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
 }

-(void)textFieldDidEndEditing:(UITextField *)textField {
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	durationhrs = textDuration.text;
	[objServiceManagementData.taskDataDictionary setObject:durationhrs forKey:@"QUANTITY"];

}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
	
    if ([_textField isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![_textField isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return TRUE;
}
//--End of delegate function of textfiled

-(void) saveData:(UITextField*)textfield {
	
	
}


//Done button touch down click event
-(IBAction) doneButtonClick:(id) sender
{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	NSInteger mDuration;
	//NSInteger mHour;
	BOOL mValidationFlag = FALSE;
	
    
    durationhrs = textDuration.text;
	[objServiceManagementData.taskDataDictionary setObject:durationhrs forKey:@"QUANTITY"];
    
    //Enter the reason into the dictionary..
	[objServiceManagementData.taskDataDictionary setObject:self.textNotes.text forKey:@"ZZITEM_DESCRIPTION"];
	[self setViewMovedUp:NO];

	
	//***************VALIDATE DURATION NOT EQUAL TO ZERO*******************************************************************************************
	mDuration = [textDuration.text intValue];

	if (mDuration != 0) {
		mValidationFlag = TRUE;
	}
	else {
		mValidationFlag = FALSE;
		
		UIAlertView *durationError = [[UIAlertView alloc] 
										initWithTitle:@"Duration Error" 
										message:@"Duration Should not be blank/zero"  
										delegate:self 
										cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_Cancel_title",@"") 
										otherButtonTitles:nil];
		[durationError show];
		durationError.tag = 5;
		[durationError release];
		
	}
	//*************************************************************************************************

	
	if (mDuration != 0) {
		objServiceManagementData.updatedActivityArrayFlag = YES;
		
		//Creating Sql string for updating a task..
		NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE ZGSCSMST_SRVCACTVTY10_TEMP SET PRODUCT_ID = '%@',QUANTITY = '%@',PROCESS_QTY_UNIT = '%@',ZZITEM_DESCRIPTION = '%@',ZZITEM_TEXT = '%@', DATETIME_FROM = '%@',DATETIME_TO = '%@', DATE_FROM = '%@',DATE_TO = '%@',TIME_FROM = '%@',TIME_TO = '%@' WHERE ZGSCSMST_SRVCACTVTY10Id = %@",
							  

							  [objServiceManagementData.taskDataDictionary objectForKey:@"PRODUCT_ID"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"QUANTITY"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_QTY_UNIT"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"ZZITEM_DESCRIPTION"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"ZZITEM_TEXT"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"DATE_FROM"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"DATE_TO"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_FROM"],
							  [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_TO"],
                             [objServiceManagementData.taskDataDictionary objectForKey:@"ZGSCSMST_SRVCACTVTY10Id"]];
		
        NSLog(@"update query %@",sqlQuery);
		//if([objServiceManagementData updateConfirmationDB:sqlQuery])
        if ([objServiceManagementData excuteSqliteQryString:sqlQuery:objServiceManagementData.serviceReportsDB:@"SOACTIVITYUPDATETEMP":1]) 
		{
            [objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
            NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"];
            objServiceManagementData.serviceOrderActivityTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOACTIVITYTEMP" :1]; 

			
			//[objServiceManagementData fetchServiceOrderActivityTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"]:1];
            
            NSLog(@"activity temp array %@", objServiceManagementData.serviceOrderActivityTempArray);
            
			[self.navigationController popViewControllerAnimated:YES];
			
		}	
		
	}
	else {
		objServiceManagementData.updatedActivityArrayFlag = NO;
		
	}
	

	

	//***********************VALIDATE DATE'S ARE EQUAL TO DURATION ENTERED********************************************
	
	 // Get the system calendar
/*	 NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
	
	 NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	 [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	 [dateFormatter setDateFormat:@"HH:mm:ss"];
	

	 NSDate *firstDate = [dateFormatter dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_FROM"]];
	 NSDate *secondDate = [dateFormatter dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_TO"]];
	
	 //NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
	 // Get conversion to months, days, hours, minutes
	 unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
	 NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:firstDate  toDate:secondDate  options:0];
	 mHour = [conversionInfo hour];
	 //NSLog(@"Conversion: %dmin %dhours %ddays %dmoths",[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]);
	 if (mHour != mDuration) {
		 UIAlertView *durationError = [[UIAlertView alloc] 
									   initWithTitle:@"DateTime Error" 
									   message:@"Date Time is not matching with duration!"  
									   delegate:self 
									   cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_Cancel_title",@"") 
									   otherButtonTitles:nil];
		 [durationError show];
		 durationError.tag = 5;
		 [durationError release];
		 
		 mValidationFlag = FALSE;
	 }
	else {
		mValidationFlag = TRUE;
	}
	***********************************************************************************************************************
	
	**************************SET ACTIVITY EDITED STATUS****************************************************************

	
	if (mValidationFlag && mDuration != 0) {
		objServiceManagementData.updatedActivityArrayFlag = YES;
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		objServiceManagementData.updatedActivityArrayFlag = NO;

	}

	***********************************************************************************************************************
	*/
	
}

//Saving the task... caling while trying to back Service Orders (Task) list page
-(void) goBack
{
	//set activity is not edited
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	objServiceManagementData.updatedActivityArrayFlag = NO;
	
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.modifySearchWhenBackFalg = TRUE;

    //Creating Sql string delete temporary record already created
    NSString *DeleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE NUMBER_EXT = %d",
                             [[objServiceManagementData.taskDataDictionary objectForKey:@"NUMBER_EXT"] intValue]];
    
    if ([objServiceManagementData excuteSqliteQryString:DeleteQuery:objServiceManagementData.serviceReportsDB:@"DELETE ACTIVITY":1]) {
        
        [objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE OBJECT_ID = %@",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        objServiceManagementData.serviceOrderActivityTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOACTIVITY" :1];
                                 
        [self.navigationController popViewControllerAnimated:YES];    
    
    
    }    
    
    
   /* if([objServiceManagementData updateConfirmationDB:DeleteQuery])
    {
        
        [objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
        [objServiceManagementData fetchServiceOrderActivityTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE OBJECT_ID = %@",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]]:1];  
        
        [self.navigationController popViewControllerAnimated:YES];
    }*/

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

- (void)viewWillDisappear:(BOOL)animated
{
	// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}



- (void)dealloc {
	
	[self.myTableView release], myTableView = nil;
	[self.detailsTask release], detailsTask = nil;
	[self.taskReason release], taskReason = nil;
	[self.taskCategory release], taskCategory = nil;
	[self.displayTask release], displayTask = nil;
	
	[pic release];
	[datePicker release];

		
	
	//[self.updateResponseStr release], self.updateResponseStr = nil;
    [super dealloc];
	
}


@end
