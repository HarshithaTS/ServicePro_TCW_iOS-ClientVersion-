//
//  FaultEditScr.m
//  ServiceManagement
//
//  Created by gss on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FaultEditScr.h"

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
#import "Design.h"
CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;
CurrentDateTime *objCurrentDateTime;
CustomAlertView *customAlt;
const NSInteger kViewTag1 = 1;

@implementation FaultEditScr

@synthesize myTableView;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize commonLabel;

@synthesize updateResponseMsgArray;
@synthesize pickerSourceArray;
@synthesize updateSucessFlag;

@synthesize alert;

@synthesize textDuratiobn;

@synthesize textSymptomGroup,textSymptomCode;
@synthesize textProblemGroup,textProblemCode;
@synthesize textCauseGroup,textCauseCode;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = NSLocalizedString(@"Fault_title","");
	
    pickerSourceArray = [[NSMutableArray alloc] init];
	
	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];

		
	//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
	
    /*//Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;*/
    
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SaveTask)];
	self.navigationItem.rightBarButtonItem = barDoneButton;
	[barDoneButton release], barDoneButton = nil;

    
    
		
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	[objServiceManagementData.faultDataDictionary removeAllObjects];
    
    if (objServiceManagementData.faultEditFlag && [objServiceManagementData.faultAllDataArray count] > 0)
    objServiceManagementData.faultDataDictionary = [objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex];
    
    
    
	/*if (objServiceManagementData.faultEditFlag && [objServiceManagementData.faultAllDataArray count] > 0) {
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"NUMBER_EXT"] forKey:@"NUMBER_EXT"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZSYMPTMCODEGROUP"] forKey:@"ZZSYMPTMCODEGROUP"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZSYMPTMCODE"] forKey:@"ZZSYMPTMCODE"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZSYMPTMTEXT"] forKey:@"ZZSYMPTMTEXT"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZPRBLMCODEGROUP"] forKey:@"ZZPRBLMCODEGROUP"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZPRBLMCODE"] forKey:@"ZZPRBLMCODE"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZPRBLMTEXT"] forKey:@"ZZPRBLMTEXT"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZCAUSECODEGROUP"] forKey:@"ZZCAUSECODEGROUP"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZCAUSECODE"] forKey:@"ZZCAUSECODE"];
		[objServiceManagementData.faultDataDictionary setValue:[[objServiceManagementData.faultAllDataArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZCAUSETEXT"] forKey:@"ZZCAUSETEXT"];
	}*/
	
	
	/*
	 DATA-TYPE
	 [.]ZGSCSMST_SRVCCNFRMTNFAULT20
	 [.]NUMBER_EXT
	 [.]ZZSYMPTMCODEGROUP
	 [.]ZZSYMPTMCODE
	 [.]ZZSYMPTMTEXT
	 [.]ZZPRBLMCODEGROUP
	 [.]ZZPRBLMCODE
	 [.]ZZPRBLMTEXT
	 [.]ZZCAUSECODEGROUP
	 [.]ZZCAUSECODE
	 [.]ZZCAUSETEXT
	 */
	
	
	
	
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Table view data source start
//**********************************************************************************************************************
//Table View - Start
//**********************************************************************************************************************
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
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Group",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
	}
	else if(indexPath.row == 1 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Code",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
	}
	else if(indexPath.row == 2 )
	{
		//rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Confirmation_Activity_Label_StartTime",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]];
		rowHeight = 85.0f;
	}
	else if(indexPath.row == 3 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Group",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
	}
	else if(indexPath.row == 4 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Code",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]];
	}
	else if(indexPath.row == 5 )
	{
		rowHeight = 85.0f;
	}
	else if(indexPath.row == 6 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Group",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
	}
	else if(indexPath.row == 7 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Code",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]];
	}
	else if(indexPath.row == 8 )
	{
		rowHeight = 85.0f;
	}
	else {
		rowHeight =85.0f;
	}
	
	return rowHeight;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 9;
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
	if(indexPath.section == 0)
	{
		
		
		switch (indexPath.row) {
				
			case 0:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Group",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Group",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame = CGRectMake(113, 5.0, 200.0, 30.0);
				textSymptomGroup = [[UITextField alloc] initWithFrame:frame];
				self.textSymptomGroup.borderStyle =  UITextBorderStyleRoundedRect;
				self.textSymptomGroup.textColor = [UIColor blackColor];
				self.textSymptomGroup.font = [UIFont systemFontOfSize:12.0];
				self.textSymptomGroup.placeholder = @"Select Symptom Group";
				self.textSymptomGroup.backgroundColor = [UIColor whiteColor];
				
				self.textSymptomGroup.keyboardType = UIKeyboardTypeDefault;
				self.textSymptomGroup.returnKeyType = UIReturnKeyDone;	
				
				self.textSymptomGroup.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textSymptomGroup.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textSymptomGroup.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"];
				
				// Add an accessibility label that describes the text field.
				[self.textSymptomGroup setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textSymptomGroup.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textSymptomGroup.rightViewMode = UITextFieldViewModeAlways;
				self.textSymptomGroup.enabled = FALSE;
				self.textSymptomGroup.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textSymptomGroup];					break;				
				
			case 1:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Code",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Code",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame1 = CGRectMake(113, 5.0, 200.0, 30.0);
				textSymptomCode = [[UITextField alloc] initWithFrame:frame1];
				self.textSymptomCode.borderStyle =  UITextBorderStyleRoundedRect;
				self.textSymptomCode.textColor = [UIColor blackColor];
				self.textSymptomCode.font = [UIFont systemFontOfSize:12.0];
				self.textSymptomCode.placeholder = @"Select Symptom Code";
				self.textSymptomCode.backgroundColor = [UIColor whiteColor];
				
				self.textSymptomCode.keyboardType = UIKeyboardTypeDefault;
				self.textSymptomCode.returnKeyType = UIReturnKeyDone;	
				
				self.textSymptomCode.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textSymptomCode.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textSymptomCode.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"];
				
				// Add an accessibility label that describes the text field.
				[self.textSymptomCode setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textSymptomCode.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textSymptomCode.rightViewMode = UITextFieldViewModeAlways;
				self.textSymptomCode.enabled = FALSE;
				self.textSymptomCode.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textSymptomCode];					
				break;	
			
			case 2:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Symptom_Desc",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Symptom_Desc",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				UITextView *textSymptomDesc = [Design textViewFormation:113.0 :5.0 :200.0 :70.0 :1 :self];
				textSymptomDesc.editable = TRUE;
				textSymptomDesc.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"];
				textSymptomDesc.layer.masksToBounds = YES;
				textSymptomDesc.layer.cornerRadius = 4.0;
				textSymptomDesc.layer.borderWidth = 1.0;
				textSymptomDesc.layer.borderColor = [UIColor grayColor].CGColor;
				textSymptomDesc.font = [UIFont systemFontOfSize:12.0f];
				[cell.contentView addSubview:textSymptomDesc];
				
				break;
				
			case 3:	
				
				
				commonLabel = [Design LabelFormation:5.0:5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Group",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Group",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame2 = CGRectMake(113, 5.0, 200.0, 30.0);
				textProblemCode = [[UITextField alloc] initWithFrame:frame2];
				self.textProblemCode.borderStyle =  UITextBorderStyleRoundedRect;
				self.textProblemCode.textColor = [UIColor blackColor];
				self.textProblemCode.font = [UIFont systemFontOfSize:12.0];
				self.textProblemCode.placeholder = @"Select Problem Code";
				self.textProblemCode.backgroundColor = [UIColor whiteColor];
				
				self.textProblemCode.keyboardType = UIKeyboardTypeDefault;
				self.textProblemCode.returnKeyType = UIReturnKeyDone;	
				
				self.textProblemCode.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textProblemCode.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textProblemCode.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"];
				
				// Add an accessibility label that describes the text field.
				[self.textSymptomCode setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textProblemCode.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textProblemCode.rightViewMode = UITextFieldViewModeAlways;
				self.textProblemCode.enabled = FALSE;
				self.textProblemCode.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textProblemCode];					
				break;
			case 4:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Code",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Code",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame3 = CGRectMake(113, 5.0, 200.0, 30.0);
				textProblemCode = [[UITextField alloc] initWithFrame:frame3];
				self.textProblemCode.borderStyle =  UITextBorderStyleRoundedRect;
				self.textProblemCode.textColor = [UIColor blackColor];
				self.textProblemCode.font = [UIFont systemFontOfSize:12.0];
				self.textProblemCode.placeholder = @"Select Problem Code";
				self.textProblemCode.backgroundColor = [UIColor whiteColor];
				
				self.textProblemCode.keyboardType = UIKeyboardTypeDefault;
				self.textProblemCode.returnKeyType = UIReturnKeyDone;	
				
				self.textProblemCode.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textProblemCode.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textProblemCode.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODE"];
				
				// Add an accessibility label that describes the text field.
				[self.textProblemCode setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textProblemCode.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textProblemCode.rightViewMode = UITextFieldViewModeAlways;
				self.textProblemCode.enabled = FALSE;
				self.textProblemCode.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textProblemCode];					
				break;
	
			case 5:
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Problem_Desc",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Problem_Desc",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				UITextView *textProblemDesc = [Design textViewFormation:113.0 :5.0 :200.0 :70.0 :1 :self];
				textProblemDesc.editable = TRUE;
				textProblemDesc.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"];
				textProblemDesc.layer.masksToBounds = YES;
				textProblemDesc.layer.cornerRadius = 4.0;
				textProblemDesc.layer.borderWidth = 1.0;
				textProblemDesc.layer.borderColor = [UIColor grayColor].CGColor;
				textProblemDesc.font = [UIFont systemFontOfSize:12.0f];
				[cell.contentView addSubview:textProblemDesc];
				
				break;
				
			case 6:	
				
				commonLabel = [Design LabelFormation:5.0:5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Group",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Group",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame4 = CGRectMake(113, 5.0, 200.0, 30.0);
				textCauseGroup = [[UITextField alloc] initWithFrame:frame4];
				self.textCauseGroup.borderStyle =  UITextBorderStyleRoundedRect;
				self.textCauseGroup.textColor = [UIColor blackColor];
				self.textCauseGroup.font = [UIFont systemFontOfSize:12.0];
				self.textCauseGroup.placeholder = @"Select Cause Code";
				self.textCauseGroup.backgroundColor = [UIColor whiteColor];
				
				self.textCauseGroup.keyboardType = UIKeyboardTypeDefault;
				self.textCauseGroup.returnKeyType = UIReturnKeyDone;	
				
				self.textCauseGroup.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textCauseGroup.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textCauseGroup.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"];
				
				// Add an accessibility label that describes the text field.
				[self.textCauseGroup setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textCauseGroup.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
				self.textCauseGroup.rightViewMode = UITextFieldViewModeAlways;
				self.textCauseGroup.enabled = FALSE;
				self.textCauseGroup.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textCauseGroup];					
				break;
				

			case 7:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Code",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Code",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				CGRect frame5 = CGRectMake(113, 5.0, 200.0, 30.0);
				textCauseCode = [[UITextField alloc] initWithFrame:frame5];
				self.textCauseCode.borderStyle =  UITextBorderStyleRoundedRect;
				self.textCauseCode.textColor = [UIColor blackColor];
				self.textCauseCode.font = [UIFont systemFontOfSize:12.0];
				self.textCauseCode.placeholder = @"Select Cause Code";
				self.textCauseCode.backgroundColor = [UIColor whiteColor];
				
				self.textCauseCode.keyboardType = UIKeyboardTypeDefault;
				self.textCauseCode.returnKeyType = UIReturnKeyDone;	
				
				self.textCauseCode.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textCauseCode.tag = kViewTag1;		// tag this control so we can remove it later for recycled cells
				self.textCauseCode.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODE"];
				
				// Add an accessibility label that describes the text field.
				[self.textCauseCode setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textCauseCode.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
				self.textCauseCode.rightViewMode = UITextFieldViewModeAlways;
				self.textCauseCode.enabled = FALSE;
				self.textCauseCode.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textCauseCode];					
				break;
				

			case 8:
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Fault_Label_Cause_Desc",@""):1]:14.0f :1];	
				commonLabel.text = NSLocalizedString(@"Fault_Label_Cause_Desc",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				UITextView *textCauseDesc = [Design textViewFormation:113.0 :5.0 :200.0 :70.0 :1 :self];
				textCauseDesc.editable = TRUE;
				textCauseDesc.text = [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSETEXT"];
				textCauseDesc.layer.masksToBounds = YES;
				textCauseDesc.layer.cornerRadius = 4.0;
				textCauseDesc.layer.borderWidth = 1.0;
				textCauseDesc.layer.borderColor = [UIColor grayColor].CGColor;
				textCauseDesc.font = [UIFont systemFontOfSize:12.0f];
				[cell.contentView addSubview:textCauseDesc];
				
				break;
	
		}
		
	}
	
    
    return cell;
}
//**********************************************************************************************************************
//Table View - End
//**********************************************************************************************************************


#pragma mark -
#pragma mark Delegates
//**********************************************************************************************************************
//Delegate function start
//**********************************************************************************************************************
//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
		if(indexPath.row == 0)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.faultSymtmCodeGroupArrayPicker PickerName:@"SymtmCodeGroupList"];
		}
		else if(indexPath.row == 1)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:[self searchTextInArray:objServiceManagementData.SymptomGroupCode:objServiceManagementData.faultSymtmCodeListArray] PickerName:@"SymtmCodeList"];
		}
		else if(indexPath.row == 3)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.faultPrblmCodeGroupArrayPicker PickerName:@"PrblmCodeGroupList"];
			
		}
		else if(indexPath.row == 4)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:[self searchTextInArray:objServiceManagementData.ProblemGroupCode:objServiceManagementData.faultPrblmCodeListArray] PickerName:@"PrblmCodeList"];
			
		}
		else if(indexPath.row == 6)
		{
			//calling picker view
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.faultCauseCodeGroupArrayPicker PickerName:@"CauseCodeGroupList"];
		}
		else if(indexPath.row == 7)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:[self searchTextInArray:objServiceManagementData.CauseGroupCode:objServiceManagementData.faultCauseCodeListArray] PickerName:@"CauseCodeList"];	
			
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
//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
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
		//[self cancelDefaultAlertAndCallSAPUpdate];	
		
	}		
}
//**********************************************************************************************************************
//Delegate function end
//**********************************************************************************************************************


#pragma mark - 
#pragma mark custom button event
//**********************************************************************************************************************
//Button Event Start
//**********************************************************************************************************************
- (NSMutableArray *) searchTextInArray:(NSString *) code:(NSMutableArray*)array{
	
	
	[self.pickerSourceArray removeAllObjects];
	
    NSString *searchText = code;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	[searchArray addObjectsFromArray:array];	
    
	
	for (int i=0; i<[searchArray count]; i++) {
		
		if([[[searchArray objectAtIndex:i] objectForKey:@"CODEGRUPPE"] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)		
		{
			//NSLog(@"searchText %@ -- %@",searchText,[[searchArray objectAtIndex:i] objectForKey:@"CODEGRUPPE"]);
            
			[self.pickerSourceArray addObject:[[searchArray objectAtIndex:i] objectForKey:@"SEARCH_STRING"]];
			
		}
	}	
	
	[searchArray release], searchArray = nil;
  	
	return self.pickerSourceArray;			
}
//Saving the task... caling while trying to back Service Orders (Task) list page
-(IBAction) SaveTask{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	if (objServiceManagementData.faultEditFlag)
		
	{
		//Creating Sql string for updating a task..
		NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE ZGSCSMST_SRVCCNFRMTNFAULT20 SET ZZSYMPTMCODEGROUP = '%@',ZZSYMPTMCODE = '%@',ZZSYMPTMTEXT = '%@',ZZPRBLMCODEGROUP = '%@',ZZPRBLMCODE = '%@', ZZPRBLMTEXT = '%@',ZZCAUSECODEGROUP = '%@',ZZCAUSECODE = '%@',ZZCAUSETEXT = '%@' WHERE NUMBER_EXT = %@",
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSETEXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"NUMBER_EXT"]];
		
		//AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
		if ([objServiceManagementData excuteSqliteQryString:sqlQuery:objServiceManagementData.serviceReportsDB:@"FAULT UPDATE":1]) 		
        //if([objServiceManagementData updateConfirmationDB:sqlQuery])
		{
			
			[objServiceManagementData.faultAllDataArray removeAllObjects];
			//[objServiceManagementData fetchAndUpdateConfirmationFaultData:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT]:-1];
            NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT];
            objServiceManagementData.faultAllDataArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOFAULTTEMP" :1]; 

			
			//Display the alert which is got from SAP response...
			
			//selvan  "message:alertMsg" i changed this line for demo purpose
			/*
			 UIAlertView *responseSuccess = [[UIAlertView alloc] 
			 initWithTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_title",@"") 
			 message:@""  
			 delegate:self 
			 cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_Cancel_title",@"") 
			 otherButtonTitles:nil];
			 [responseSuccess show];
			 responseSuccess.tag = 5;
			 [responseSuccess release];*/
			
		}	
		
	}
	else {

	[objServiceManagementData.faultDataDictionary setObject:objServiceManagementData.NUMBER_EXT forKey:@"NUMBER_EXT"];
		[objServiceManagementData.faultDataDictionary setObject:[NSString stringWithFormat:@"%d", objServiceManagementData.SRVCACTVTY10ID] forKey:@"SRCDOC_ACTIVITY_ID"];
	
	//Insert Fault code data into database
	NSString *tempValueStr = [NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
							 [objServiceManagementData.faultDataDictionary objectForKey:@"NUMBER_EXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMCODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSECODE"],
							  [objServiceManagementData.faultDataDictionary objectForKey:@"ZZCAUSETEXT"]];
	
	NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",
						  @"ZGSCSMST_SRVCCNFRMTNFAULT20",
						  @"NUMBER_EXT,ZZSYMPTMCODEGROUP,ZZSYMPTMCODE, ZZSYMPTMTEXT,ZZPRBLMCODEGROUP,ZZPRBLMCODE,ZZPRBLMTEXT, ZZCAUSECODEGROUP,ZZCAUSECODE,ZZCAUSETEXT",tempValueStr];

	[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
	
		[objServiceManagementData.faultAllDataArray removeAllObjects];
		//[objServiceManagementData fetchAndUpdateConfirmationFaultData:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT]:-1];
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT];
        objServiceManagementData.faultAllDataArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOFAULTTEMP" :1]; 

		
	}
	
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.activeFaultSegmentIndexFlag = 11;
	[self.navigationController popViewControllerAnimated:YES];
	
	
}
//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
	//ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//objServiceManagementData.NUMBER_EXT=@"";
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.activeFaultSegmentIndexFlag = 10;    
    
    
	[self.navigationController popViewControllerAnimated:YES];
}	
//**********************************************************************************************************************
//Button Event - End
//**********************************************************************************************************************

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

	
	[pic release];
	[datePicker release]; 

	
	
    [super dealloc];
	
}




@end
