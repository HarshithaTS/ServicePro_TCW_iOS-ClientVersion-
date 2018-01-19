//
//  SparesEdit.m
//  ServiceManagement
//
//  Created by gss on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SparesEdit.h"
#import "ServiceManagementData.h"
#import "CustomPickerControl.h"
#import "StaticData.h"
#import "CustomDatePicker.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate_iPhone.h"
#import "CurrentDateTime.h"

#import "CustomAlertView.h"


#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"

#import "CheckedNetwork.h"

CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;
CurrentDateTime *objCurrentDateTime;
CustomAlertView *customAlt;
const NSInteger kViewTag2 = 1;
#define kOFFSET_FOR_KEYBOARD 90.0

@implementation SparesEdit

@synthesize myTableView;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize textSparesDesc;
@synthesize commonLabel;
@synthesize mQuantity;
@synthesize materialQty;
@synthesize materialUnit;
@synthesize mSerialNumber;

@synthesize updateResponseMsgArray;
@synthesize updateSucessFlag;

@synthesize alert;

@synthesize textDuratiobn;
@synthesize textMaterialId;
@synthesize otherUnit;
@synthesize materialSerialNumber;

@synthesize scanImageButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.title = NSLocalizedString(@"Spares_title","");
	
	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
	objCurrentDateTime = [[CurrentDateTime alloc] init];

    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;

    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateSparesDataIntoDatabase)];
	self.navigationItem.rightBarButtonItem = barDoneButton;
	[barDoneButton release], barDoneButton = nil;

    
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    

    
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	[objServiceManagementData.SpareDataDictionary removeAllObjects];
    [objServiceManagementData.SpareDataDictionary setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"OBJECT_ID"] forKey:@"OBJECT_ID"];	
    [objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"NUMBER_EXT"] forKey:@"NUMBER_EXT"];
	[objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"PRODUCT_ID"] forKey:@"PRODUCT_ID"];
	[objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"QUANTITY"] forKey:@"QUANTITY"];
	[objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"PROCESS_QTY_UNIT"] forKey:@"PROCESS_QTY_UNIT"];
	[objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZITEM_DESCRIPTION"] forKey:@"ZZITEM_DESCRIPTION"];
	[objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"ZZITEM_TEXT"] forKey:@"ZZITEM_TEXT"];
    [objServiceManagementData.SpareDataDictionary 	setObject:[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:objServiceManagementData.selectedRowIndex] objectForKey:@"SERIAL_NUMBER"] forKey:@"SERIAL_NUMBER"];

    
    NSLog(@"sparesdictionary %@", objServiceManagementData.SpareDataDictionary);
    [super viewDidLoad];
}

//**********************************************************************************************************************
//Table View - Start
//**********************************************************************************************************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat rowHeight;
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	
	if(indexPath.row == 0 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Id",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
	}
	else if(indexPath.row == 1 )
	{
		rowHeight = 85.0f;
	}
	else if(indexPath.row == 2 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Qty",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]];
    }
	else if(indexPath.row == 3 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Unit",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
	}
	else if(indexPath.row == 4 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Other_Unit",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]];
	}
	else if(indexPath.row == 5 )
	{
		rowHeight = [self cellHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Serial",@""):[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]];
        
	}
    else {
		rowHeight =85.0f;
	}
	
	return rowHeight;	}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section
	return 5;
}
// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
		
   // static NSString *CellIdentifier = @"Cell";
    
	/*UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault] autorelease];
    }*/
    
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];


	
	cell.textLabel.numberOfLines = 1;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *mProductid = [objServiceManagementData.SpareDataDictionary objectForKey:@"PRODUCT_ID"];
	
	if(indexPath.section == 0)
	{
		
		
		
        if ( ![mProductid isEqualToString: @"OTHER"] ) {
       
            switch (indexPath.row) {
			case 0:
				//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
				//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
				
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Id",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Id",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				CGRect frame = CGRectMake(103, 5.0, 200.0, 30.0);
				textMaterialId = [[UITextField alloc] initWithFrame:frame];
				self.textMaterialId.borderStyle =  UITextBorderStyleRoundedRect;
				self.textMaterialId.textColor = [UIColor blackColor];
				self.textMaterialId.font = [UIFont systemFontOfSize:12.0];
				self.textMaterialId.placeholder = @"Select Material ID";
				self.textMaterialId.backgroundColor = [UIColor whiteColor];
				
				self.textMaterialId.keyboardType = UIKeyboardTypeDefault;
				self.textMaterialId.returnKeyType = UIReturnKeyDone;	
				
				self.textMaterialId.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textMaterialId.tag = kViewTag2;		// tag this control so we can remove it later for recycled cells
				self.textMaterialId.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"PRODUCT_ID"];
				
				
				// Add an accessibility label that describes the text field.
				[self.textMaterialId setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textMaterialId.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textMaterialId.rightViewMode = UITextFieldViewModeAlways;
				self.textMaterialId.enabled = FALSE;
				self.textMaterialId.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textMaterialId];					
				break;				
				
		
			case 1:				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Desc",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Desc",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				self.textSparesDesc = [Design textViewFormation:103.0 :5.0 :200.0 :70.0 :1 :self];
				self.textSparesDesc.editable = TRUE;
				self.textSparesDesc.text =[objServiceManagementData.SpareDataDictionary objectForKey:@"ZZITEM_DESCRIPTION"];
				self.textSparesDesc.layer.masksToBounds = YES;
				self.textSparesDesc.layer.cornerRadius = 3.0;
				self.textSparesDesc.layer.borderWidth = 1.0;
				self.textSparesDesc.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
				[cell.contentView addSubview:self.textSparesDesc];
				break;
				
			case 2:	
				commonLabel = [Design LabelFormation:5.0:5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Qty",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Qty",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
		
				self.materialQty = [Design textFieldFormation:103.0 :5.0 :200.0 :30.0 :1 :self];
				self.materialQty.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"QUANTITY"];
				self.materialQty.enabled = TRUE;
				self.materialQty.tag = 1;
                self.materialQty.keyboardType = UIKeyboardTypeNumberPad;
				[cell.contentView addSubview:self.materialQty];

				
                
				break;
			case 3:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Unit",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Unit",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				self.materialUnit = [Design textFieldFormation:103.0 :5.0 :200.0 :30.0 :1 :self];
				CGRect frame1 = CGRectMake(103, 5.0, 200.0, 30.0);
				self.materialUnit = [[UITextField alloc] initWithFrame:frame1];
				self.materialUnit.borderStyle =  UITextBorderStyleRoundedRect;
				self.materialUnit.textColor = [UIColor blackColor];
				self.materialUnit.font = [UIFont systemFontOfSize:12.0];
				self.materialUnit.placeholder = @"Select Unit";
				self.materialUnit.backgroundColor = [UIColor whiteColor];
				
				self.materialUnit.keyboardType = UIKeyboardTypeDefault;
				self.materialUnit.returnKeyType = UIReturnKeyDone;	
				
				self.materialUnit.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.materialUnit.tag = kViewTag2;		// tag this control so we can remove it later for recycled cells
				self.materialUnit.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"PROCESS_QTY_UNIT"];

				
				// Add an accessibility label that describes the text field.
				[self.materialUnit setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.materialUnit.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.materialUnit.rightViewMode = UITextFieldViewModeAlways;
				self.materialUnit.enabled = FALSE;
				self.materialUnit.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.materialUnit];					

		
				break;
			case 4:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Serial",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Serial",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				materialSerialNumber = [Design textFieldFormation:103.0 :5.0 :175.0 :30.0 :1 :self];
				self.materialSerialNumber.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"SERIAL_NUMBER"];
				self.materialSerialNumber.enabled = TRUE;
				self.materialSerialNumber.tag = 2;
				[cell.contentView addSubview:self.materialSerialNumber];
				
                
                scanImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.scanImageButton.frame = CGRectMake(283, 5.0,40,34);
                [self.scanImageButton setImage:[UIImage imageNamed:@"barcodescanimage.jpg"] forState:UIControlStateNormal];
                [self.scanImageButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.scanImageButton];
                //[self.scanImageButton autorelease];
                
                
				
				break;
            }
            }
            else if ([mProductid isEqualToString: @"OTHER"]){
                switch (indexPath.row) {
			case 0:
				//cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
				//cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
				
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Id",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Id",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				CGRect frame = CGRectMake(103, 5.0, 200.0, 30.0);
				textMaterialId = [[UITextField alloc] initWithFrame:frame];
				self.textMaterialId.borderStyle =  UITextBorderStyleRoundedRect;
				self.textMaterialId.textColor = [UIColor blackColor];
				self.textMaterialId.font = [UIFont systemFontOfSize:12.0];
				self.textMaterialId.placeholder = @"Select Material ID";
				self.textMaterialId.backgroundColor = [UIColor whiteColor];
				
				self.textMaterialId.keyboardType = UIKeyboardTypeDefault;
				self.textMaterialId.returnKeyType = UIReturnKeyDone;	
				
				self.textMaterialId.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
				
				self.textMaterialId.tag = kViewTag2;		// tag this control so we can remove it later for recycled cells
				self.textMaterialId.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"PRODUCT_ID"];
				
				
				// Add an accessibility label that describes the text field.
				[self.textMaterialId setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
				
				self.textMaterialId.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
				self.textMaterialId.rightViewMode = UITextFieldViewModeAlways;
				self.textMaterialId.enabled = FALSE;
				self.textMaterialId.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
				[cell.contentView addSubview:self.textMaterialId];					
				break;				
				
                
			case 1:				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Desc",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Desc",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				self.textSparesDesc = [Design textViewFormation:103.0 :5.0 :200.0 :70.0 :1 :self];
				self.textSparesDesc.editable = TRUE;
				self.textSparesDesc.text =[objServiceManagementData.SpareDataDictionary objectForKey:@"ZZITEM_DESCRIPTION"];
				self.textSparesDesc.layer.masksToBounds = YES;
				self.textSparesDesc.layer.cornerRadius = 3.0;
				self.textSparesDesc.layer.borderWidth = 1.0;
				self.textSparesDesc.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
				[cell.contentView addSubview:self.textSparesDesc];
				break;
				
			case 2:	
				commonLabel = [Design LabelFormation:5.0:5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Qty",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Qty",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
                
				self.materialQty = [Design textFieldFormation:103.0 :5.0 :200.0 :30.0 :1 :self];
				self.materialQty.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"QUANTITY"];
				self.materialQty.enabled = TRUE;
				self.materialQty.tag = 1;
                self.materialQty.keyboardType = UIKeyboardTypeNumberPad;
				[cell.contentView addSubview:self.materialQty];
                
				
                
				break;
			case 3:
				
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Other_Unit",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Other_Unit",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				otherUnit = [Design textFieldFormation:103.0 :5.0 :200.0 :30.0 :1 :self];
				self.otherUnit.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"PROCESS_QTY_UNIT"];
				self.otherUnit.enabled = TRUE;
				[cell.contentView addSubview:self.otherUnit];
				//[otherUnit release], otherUnit = nil;	
				break;
				
			case 4:
                
				commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Spares_Label_Material_Serial",@""):1]:16.0f :1];	
				commonLabel.text = NSLocalizedString(@"Spares_Label_Material_Serial",@"");				
				[cell.contentView addSubview:commonLabel];
				[commonLabel release], commonLabel = nil;
				
				
				materialSerialNumber = [Design textFieldFormation:103.0 :5.0 :175.0 :30.0 :1 :self];
				self.materialSerialNumber.text = [objServiceManagementData.SpareDataDictionary objectForKey:@"SERIAL_NUMBER"];
				self.materialSerialNumber.enabled = TRUE;
				self.materialSerialNumber.tag = 2;
				[cell.contentView addSubview:self.materialSerialNumber];
				
                
                scanImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.scanImageButton.frame = CGRectMake(283, 5.0,40,34);
                [self.scanImageButton setImage:[UIImage imageNamed:@"barcodescanimage.jpg"] forState:UIControlStateNormal];
                [self.scanImageButton addTarget:self action:@selector(scanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.scanImageButton];
                //[self.scanImageButton autorelease];
                
                
				
				break;
                
            }
		
        }
	}
    
    return cell;
}
//**********************************************************************************************************************
//Table View - End
//**********************************************************************************************************************


//**********************************************************************************************************************
//Delegate function start
//**********************************************************************************************************************
//Delegate function of table view..
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	
		if(indexPath.row == 0)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.materialListArrayPicker PickerName:@"MaterialCodeList"];
		}
		else if (indexPath.row == 3)
		{
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.unitsArray PickerName:@"MaterialUnit"];	
		}

}
//Text View delegate functions Start
-(void)textViewDidBeginEditing:(UITextView *)textView {
	
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
    [objServiceManagementData.SpareDataDictionary setObject:self.textSparesDesc.text forKey:@"ZZITEM_DESCRIPTION"];

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {		
		[textView resignFirstResponder];
		return FALSE;
	}
    return YES;
}
-(void)textViewDidChangeSelection:(UITextView *)textView {
	textView.text = @"";
	textView.textColor = [UIColor blackColor];
}
//End of Text View delegate functions
//Text filed delegate functions
-(void)textFieldDidBeginEditing:(UITextField *)sender {
	
    	if ([sender isEqual: otherUnit] || [sender isEqual: materialSerialNumber] )
{
		
		_textField = sender;

        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
	
	
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    self.mQuantity = self.materialQty.text;
	self.mSerialNumber = self.materialSerialNumber.text;
	[objServiceManagementData.SpareDataDictionary setObject:self.mQuantity forKey:@"QUANTITY"];
	[objServiceManagementData.SpareDataDictionary setObject:self.mSerialNumber forKey:@"SERIAL_NUMBER"];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return TRUE;
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp{
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
-(void)keyboardWillShow:(NSNotification *)notif{
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
//**********************************************************************************************************************
//Delegate function end
//**********************************************************************************************************************

//**********************************************************************************************************************
//custom button event  start
//**********************************************************************************************************************
//--End of delegate function of textfiled
-(IBAction) updateSparesDataIntoDatabase{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    self.mQuantity = self.materialQty.text;
	self.mSerialNumber = self.materialSerialNumber.text;

    NSString *mProductid = [objServiceManagementData.SpareDataDictionary objectForKey:@"PRODUCT_ID"];

	[objServiceManagementData.SpareDataDictionary setObject:self.mQuantity forKey:@"QUANTITY"];
	[objServiceManagementData.SpareDataDictionary setObject:self.mSerialNumber forKey:@"SERIAL_NUMBER"];
    [objServiceManagementData.SpareDataDictionary setObject:self.textSparesDesc.text forKey:@"ZZITEM_DESCRIPTION"];
	 NSLog(@"%@",self.textSparesDesc.text);
    
    if ([mProductid isEqualToString:@"OTHER"]) 
        [objServiceManagementData.SpareDataDictionary setObject:self.otherUnit.text forKey:@"PROCESS_QTY_UNIT"];
    
    
    
		//Creating Sql string for updating a task..
		NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE '%@' SET PRODUCT_ID = '%@',QUANTITY = '%@',PROCESS_QTY_UNIT = '%@',ZZITEM_DESCRIPTION = '%@',ZZITEM_TEXT = '%@',SERIAL_NUMBER = '%@' WHERE NUMBER_EXT = '%@' AND OBJECT_ID=%@",
							  @"ZGSCSMST_SRVCSPARE10_TEMP",
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"PRODUCT_ID"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"QUANTITY"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"PROCESS_QTY_UNIT"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"ZZITEM_DESCRIPTION"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"ZZITEM_TEXT"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"SERIAL_NUMBER"],
							  [objServiceManagementData.SpareDataDictionary objectForKey:@"NUMBER_EXT"],
                              [objServiceManagementData.SpareDataDictionary objectForKey:@"OBJECT_ID"]];
		

    
		AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
		
     if ([objServiceManagementData excuteSqliteQryString:sqlQuery:objServiceManagementData.serviceReportsDB:@"SPARES UPDATE":1]) 		
         //if([objServiceManagementData updateConfirmationDB:sqlQuery])
		{
			
            [objServiceManagementData.serviceOrderSpareTempArray removeAllObjects];	
            //[objServiceManagementData fetchServiceOrderSpareTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]]:-1];
            
            
            NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]];
            objServiceManagementData.serviceOrderSpareTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOSPARESTEMP" :1]; 

            
			
            NSLog(@"spares qtyr %@",[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]]);
            
			delegate.activitySparesEditedFlag = TRUE;
			
			[self.navigationController popViewControllerAnimated:YES];
			
		}	
		else {
			delegate.activitySparesEditedFlag = FALSE;
		}
	


}
//Send back service confirmation activity screen
-(void) goBack{		
        //modifySearchWhenBackFalg this flag for modify the search list.. if any text is present..modify the list with specified search string......
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
        AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
		delegate.modifySearchWhenBackFalg = TRUE;
    
        //Creating Sql string delete temporary record already created
        NSString *DeleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE NUMBER_EXT = %d",
                                [[objServiceManagementData.SpareDataDictionary objectForKey:@"NUMBER_EXT"] intValue]];
    

        if([objServiceManagementData excuteSqliteQryString:DeleteQuery:objServiceManagementData.serviceReportsDB:@"DELETE SPARES":1])
        {
        
            [objServiceManagementData.serviceOrderSpareTempArray removeAllObjects];	
            NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[objServiceManagementData.SpareDataDictionary objectForKey:@"OBJECT_ID"]];
             objServiceManagementData.serviceOrderSpareTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOSPARES" :1]; 
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    
}
//**********************************************************************************************************************
//custom button event end
//**********************************************************************************************************************


//**********************************************************************************************************************
//Scan Barcode - start
//**********************************************************************************************************************
- (IBAction) scanButtonTapped:(id)sender{
  
    /*comment by selvan 8 feb 2013 for some architecture error got while debug in device     
     
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
     
     
     */
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info{
   
    /*comment by selvan 8 feb 2013 for some architecture error got while debug in device 
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    materialSerialNumber.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
     
     */
}
//**********************************************************************************************************************
//Scan Barcode end
//**********************************************************************************************************************


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return(YES);
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
	
	/*[self.myTableView release], myTableView = nil;
	[self.detailsTask release], detailsTask = nil;
	[self.taskReason release], taskReason = nil;
	[self.taskCategory release], taskCategory = nil;
	[self.displayTask release], displayTask = nil;
	[self.updateResponseMsgArray release], updateResponseMsgArray = nil;
	[self.textMaterialId release], updateResponseMsgArray = nil;
	[self.mQuantity release],self.mQuantity= nil;
	[self.materialQty release], self.materialQty = nil;
	[self.otherUnit release], self.otherUnit = nil;	
	
	[self.materialSerialNumber release], self.materialSerialNumber = nil;
	*/
    
  
    //self.resultText = nil;

	//[self.updateResponseStr release], self.updateResponseStr = nil;
    [super dealloc];
	
}


@end
