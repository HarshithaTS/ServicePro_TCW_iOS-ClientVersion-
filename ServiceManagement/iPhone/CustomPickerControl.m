/*This is custom picker view class...just call 'openPickerView' function with specifed parameters.. from  any class...
 I have called this function from EditTask.m file...
 */

#import "CustomPickerControl.h"
#import "AppDelegate_iPhone.h"
#import "ServiceManagementData.h"


NSMutableArray *temparray;

AppDelegate_iPhone *appDelegate;

@implementation CustomPickerControl
@synthesize pickerToolbar, pickerViewActionSheet, sourceTableView, pickerView, pickerValue, differenciatePickerName;
@synthesize loadingImgView, actView, controllerName;
@synthesize resultArray;

//Main calling function..
-(void)openPickerView:(UITableView*)sender classObjectName:(id)classObjSender pickerArray:(NSMutableArray*)array PickerName:(NSString*)tempPickerName {
	
	self.controllerName = classObjSender;
	
	self.differenciatePickerName = tempPickerName;
	temparray = array;
	self.sourceTableView = sender;
	
	self.pickerViewActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
	
	
	pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    self.pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolbar sizeToFit];
	
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
	self.pickerView.showsSelectionIndicator = YES;
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
    
	
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(customPickerDoneClick:)];
    [barItems addObject:doneBtn];
    [doneBtn release], doneBtn = nil;
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(customPickerCancelClick:)];
    [barItems addObject:cancelBtn];
    [cancelBtn release], cancelBtn = nil;
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [barItems release], barItems = nil;
    
    [self.pickerViewActionSheet addSubview:self.pickerToolbar];
	[self.pickerViewActionSheet addSubview:self.pickerView];
    [self.pickerViewActionSheet showInView:sender];
    [self.pickerViewActionSheet setBounds:CGRectMake(0.0, 0.0, 320.0, 470.0)];
    
}

//***************Biren Changes on 01/02/2013****************
//*****************************************************************************************

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
}

-(void)openPickerView:(UITableView *)sender classObjectName:(id)classObjSender pickerArray:(NSMutableArray*)array PickerName:(NSString*)tempPickerName uiElement:(CGRect)dropDown tableCell:(UITableViewCell *)cell

{
    self.controllerName = classObjSender;
    self.differenciatePickerName = tempPickerName;
    temparray = array;
    self.sourceTableView = sender;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(customPickerIpadCancelClick:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(customPickerIpadDoneClick:)];
    
    
    
    [toolbar setItems:[NSArray arrayWithObjects:doneButton,cancelButton, nil]];
    
    [cancelButton release],cancelButton = nil;
    [doneButton release], doneButton = nil;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    CGRect thePickerFrame = pickerView.frame;
    thePickerFrame.origin.y = toolbar.frame.size.height;
    [pickerView setFrame:thePickerFrame];
    
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:pickerView];
    [view addSubview:toolbar];
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setView:view];
    [vc setContentSizeForViewInPopover:CGSizeMake(320, 260)];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    
    [toolbar release], toolbar = nil;
    [view release], view =nil;
    [vc release],vc= nil;
    
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    
    [popover presentPopoverFromRect:dropDown inView:cell
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

-(IBAction) customPickerIpadCancelClick:(id)sender {
    [self.pickerViewActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [pickerToolbar release];
    [pickerViewActionSheet release];
	[pickerView release];
    [popover dismissPopoverAnimated:YES];
    [popover release];
}
-(IBAction)customPickerIpadDoneClick:(id)sender {
	
	[self pickPickerValue];
    
	[self closeCustomPicker:self];
    [popover dismissPopoverAnimated:YES];
    [popover release];
    [pickerToolbar release];
}



//*****************************************************************************************
//****************************End*****************





//when picker view is canceled..
-(IBAction) customPickerCancelClick:(id)sender {
	[self.pickerViewActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [pickerViewActionSheet release];
	[pickerView release];
    [pickerToolbar release];
}
//when Done button is clicked in picker view..
-(IBAction)customPickerDoneClick:(id)sender {
	
	[self pickPickerValue];
	[self closeCustomPicker:self];
    [pickerToolbar release];
}
//This is the function ... where you just check the value of 'differenciatePickerName' and called form several classes..
-(void) pickPickerValue {
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	resultArray = [[NSMutableArray alloc] init];
    
    
    NSLog(@"PICKER VALUE %@",self.pickerValue);
	
	if([self.differenciatePickerName isEqualToString:@"TaskStatus"]) {
		[objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"STATUS_TXT30"];

        //Get status context
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE TXT30 = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]];
        
//         NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT B.STATUS,B.TXT30,B.ZZSTATUS_POSTSETACTION FROM ZGSXCAST_STTSFLOW10 A INNER JOIN ZGSXCAST_STTS10 B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ACTUAL"]];
        
        
        NSMutableArray *tempStatusArr = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS_TXT30" :1];
    
        if ([tempStatusArr count]>0) {
            [objServiceManagementData.taskDataDictionary setObject:[[tempStatusArr objectAtIndex:0] objectForKey:@"STATUS"] forKey:@"STATUS"];
            [objServiceManagementData.taskDataDictionary setObject:[[tempStatusArr objectAtIndex:0] objectForKey:@"ZZSTATUS_POSTSETACTION"] forKey:@"STATUS_ZZSTATUS_POSTSETACTION"];
        }
        else {
            
            NSLog(@"STATUS MAPPING %@",objServiceManagementData.taskStatusMappingArray);
            
            if ([objServiceManagementData.taskStatusMaster_temp count] >0) {
                
                [objServiceManagementData.taskDataDictionary setObject:[objServiceManagementData.taskStatusMaster_temp objectForKey:@"STATUS"] forKey:@"STATUS"];
            }
            [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"STATUS_ZZSTATUS_POSTSETACTION"];
            
        }
             
        
        
	}
    else if([self.differenciatePickerName isEqualToString:@"TaskResult"]) {
        
        [objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"ZRESULT"];
        
        [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"ZZRESULTTYPE"];
        
        NSString *string =[objServiceManagementData.taskDataDictionary objectForKey:@"ZRESULT"];
        NSString *strResult = @"";
        NSString *str= @"";
        
        for (NSUInteger index = 0; index < [string length]; index++) {
            NSLog(@"string %c",[string characterAtIndex:index]);
            if ([string characterAtIndex:index] != ' ') {
                str = [NSString stringWithFormat :@"%c",[string characterAtIndex:index]];
                strResult =[strResult stringByAppendingString:str];
                NSLog(@"result %@",strResult);
            }
            else
                break;
        }

        
        //Refresh RESULT TYPE table
        NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT SRV_RESULT_TYPE || '  ' || DESCRIPTION FROM ZCRMV_RESULTTY_T WHERE SRV_RESULT LIKE '%@' AND PROCESS_TYPE LIKE '%@'",strResult,[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
        objServiceManagementData.taskResultTypeTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULTTYPE" :2];

         
        NSLog(@"%@",objServiceManagementData.taskResultTypeTxtArray );
        
        
        
       }
    else if([self.differenciatePickerName isEqualToString:@"TaskResultType"]){
    [objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"ZZRESULTTYPE"];
    }
	else if([self.differenciatePickerName isEqualToString:@"TaskReason"])
	{
		[objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"REASON"];
	}
	else if([self.differenciatePickerName isEqualToString:@"TaskPriority"])
	{
		[objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"PRIORITY"];
        NSLog(@"Priority value %@",[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]);
	}
    // added by Sahana on sep 27 2016
    else if([self.differenciatePickerName isEqualToString:@"TaskSetType"])
	{
        NSString *pickerString = self.pickerValue;
        
        NSArray *items = [pickerString componentsSeparatedByString:@"("];
        NSString *setTypeText;
        if ([[items objectAtIndex:1] length] > 0) {
            
           setTypeText = [[items objectAtIndex:1] substringToIndex:[[items objectAtIndex:1] length] - 1];
            
        }
        
		[objServiceManagementData.taskDataDictionary setObject: [items objectAtIndex:0]forKey:@"ZZSETTYPE_TXT"];
        [objServiceManagementData.taskDataDictionary setObject:setTypeText forKey:@"ZZSETTYPE"];

       
	}
	else if([self.differenciatePickerName isEqualToString:@"TaskTimeZone"])
	{
		
		if ([pickerValue isEqualToString:(@"Greenwich Mean Time GMT")])
			pickerValue = @"GMT";
		else if ([pickerValue isEqualToString:( @"Universal Coordinated Time GMT")])
			pickerValue = @"UTC";
		else if ([pickerValue isEqualToString:( @"European Central Time GMT+1:00")])
			pickerValue = @"ECT";
		else if ([pickerValue isEqualToString:( @"Eastern European Time GMT+2:00")])
			pickerValue = @"EET";
		else if ([pickerValue isEqualToString:( @"(Arabic) Egypt Standard Time GMT+2:00")])
			pickerValue = @"ART";
		else if ([pickerValue isEqualToString:( @"Eastern African Time GMT+3:00")])
			pickerValue = @"EAT";
		else if ([pickerValue isEqualToString:(@"Middle East Time GMT+3:30")])
			pickerValue = @"MET";
		else if ([pickerValue isEqualToString:( @"Near East Time GMT+4:00")])
			pickerValue = @"NET";
		else if ([pickerValue isEqualToString:( @"Pakistan Lahore Time GMT+5:00")])
			pickerValue = @"PLT";
		else if ([pickerValue isEqualToString:( @"India Standard Time GMT+5:30")])
			pickerValue = @"IST";
		else if ([pickerValue isEqualToString:( @"Bangladesh Standard Time GMT+6:00")])
			pickerValue = @"BST";
		else if ([pickerValue isEqualToString:( @"Vietnam Standard Time GMT+7:00")])
			pickerValue = @"VST";
		else if ([pickerValue isEqualToString:( @"China Taiwan Time GMT+8:00")])
			pickerValue = @"CTT";
		else if ([pickerValue isEqualToString:( @"Japan Standard Time GMT+9:00")])
			pickerValue = @"JST";
		else if ([pickerValue isEqualToString:( @"Australia Central Time GMT+9:30")])
			pickerValue = @"ACT";
		else if ([pickerValue isEqualToString:(@"Australia Eastern Time GMT+10:00")])
			pickerValue = @"AET";
		else if ([pickerValue isEqualToString:( @"New Zealand Standard Time GMT+12:00")])
			pickerValue = @"NST";
		else if ([pickerValue isEqualToString:( @"Midway Islands Time GMT-11:00")])
			pickerValue = @"MIT";
		
		else if ([pickerValue isEqualToString:( @"Hawaii Standard Time GMT-10:00")])
			pickerValue = @"HST";
		else if ([pickerValue isEqualToString:( @"Alaska Standard Time GMT-9:00")])
			pickerValue = @"AST";
		else if ([pickerValue isEqualToString:( @"Pacific Standard Time GMT-8:00")])
			pickerValue = @"PST";
		else if ([pickerValue isEqualToString:( @"Phoenix Standard Time GMT-7:00")])
			pickerValue = @"PNT";
		else if ([pickerValue isEqualToString:( @"Mountain Standard Time GMT-7:00")])
			pickerValue = @"MST";
		else if ([pickerValue isEqualToString:( @"Central Standard Time GMT-6:00")])
			pickerValue = @"CST";
		else if ([pickerValue isEqualToString:( @"Eastern Standard Time GMT-5:00")])
			pickerValue = @"EST";
		else if ([pickerValue isEqualToString:( @"Indiana Eastern Standard Time GMT-5:00")])
			pickerValue = @"IET";
		else if ([pickerValue isEqualToString:( @"Puerto Rico and US Virgin Islands Time GMT-4:00")])
			pickerValue = @"PRT";
		else if ([pickerValue isEqualToString:( @"Canada Newfoundland Time GMT-3:30")])
			pickerValue = @"CNT";
		else if ([pickerValue isEqualToString:( @"Argentina Standard Time GMT-3:00")])
			pickerValue = @"AGT";
		else if ([pickerValue isEqualToString:( @"Brazil Eastern Time GMT-3:00")])
			pickerValue = @"BET";
		else if ([pickerValue isEqualToString:( @"Central African Time GMT-1:00")])
			pickerValue = @"CAT";
        
		
		
		[objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"TIMEZONE_FROM"];
	}
	else if([self.differenciatePickerName isEqualToString:@"ActivityList"])
	{
		[objServiceManagementData.taskDataDictionary setObject:self.pickerValue forKey:@"ACTIVITYLIST"];
		[objServiceManagementData.taskDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.activityListArray:3] forKey:@"PRODUCT_ID"];
        NSLog(@"activity array %@", objServiceManagementData.activityListArray);
	}
	else if([self.differenciatePickerName isEqualToString:@"SymtmCodeGroupList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultSymtmCodeGroupArray:0] forKey:@"ZZSYMPTMCODEGROUP"];
		objServiceManagementData.SymptomGroupCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"PrblmCodeGroupList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultPrblmCodeGroupArray:0] forKey:@"ZZPRBLMCODEGROUP"];
		objServiceManagementData.ProblemGroupCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"CauseCodeGroupList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultCauseCodeGroupArray:0] forKey:@"ZZCAUSECODEGROUP"];
		objServiceManagementData.CauseGroupCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"SymtmCodeList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultSymtmCodeListArray:1] forKey:@"ZZSYMPTMCODE"];
		[objServiceManagementData.faultDataDictionary setObject:objServiceManagementData.FaultResultText forKey:@"ZZSYMPTMTEXT"];
		objServiceManagementData.SymptomListCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"PrblmCodeList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultPrblmCodeListArray:1] forKey:@"ZZPRBLMCODE"];
		[objServiceManagementData.faultDataDictionary setObject:objServiceManagementData.FaultResultText forKey:@"ZZPRBLMTEXT"];
		objServiceManagementData.ProblemListCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"CauseCodeList"])
	{
		[objServiceManagementData.faultDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.faultCauseCodeListArray:1] forKey:@"ZZCAUSECODE"];
		[objServiceManagementData.faultDataDictionary setObject:objServiceManagementData.FaultResultText forKey:@"ZZCAUSETEXT"];
		objServiceManagementData.CauseListCode =objServiceManagementData.FaultResultCode;
	}
	else if([self.differenciatePickerName isEqualToString:@"MaterialCodeList"])
	{
		[objServiceManagementData.SpareDataDictionary setObject:[self searchTextInArray:self.pickerValue:objServiceManagementData.materialListArray:2] forKey:@"PRODUCT_ID"];
		[objServiceManagementData.SpareDataDictionary setObject:objServiceManagementData.MatResultText forKey:@"ZZITEM_DESCRIPTION"];
        
	}
	else if ([self.differenciatePickerName isEqualToString:@"MaterialUnit"]){
		
		[objServiceManagementData.SpareDataDictionary setObject:self.pickerValue forKey:@"PROCESS_QTY_UNIT"];
	}
	   
	
	[self.sourceTableView reloadData];
	
}
- (NSString *) searchTextInArray:(NSString *) mpickerValue:(NSMutableArray*)array:(NSInteger)option{
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];		[self.resultArray removeAllObjects];
	objServiceManagementData.FaultResultCode = @"";
	objServiceManagementData.FaultResultText = @"";
    NSString *searchText = mpickerValue;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	[searchArray addObjectsFromArray:array];
    
	for (int i=0; i<[searchArray count]; i++) {
		
		//NSLog(@"DISPLAY_DUE_DATE=%@",[[searchArray objectAtIndex:i] objectForKey:@"DISPLAY_DUE_DATE"]);
		
		if([[[searchArray objectAtIndex:i] objectForKey:@"SEARCH_STRING"] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound)
		{
			
			[self.resultArray addObject:[searchArray objectAtIndex:i]];
			
		}
	}
	
	[searchArray release], searchArray = nil;
	NSString *rtnResult;
	if (option == 0) {
		rtnResult = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"CODEGRUPPE"]];
		objServiceManagementData.FaultResultCode = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"CODEGRUPPE"]];
	    objServiceManagementData.FaultResultText = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"KURZTEXT"]];
	}
	else if (option == 1) {
		rtnResult = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"CODE"]];
		objServiceManagementData.FaultResultCode = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"CODE"]];
	    objServiceManagementData.FaultResultText = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"KURZTEXT"]];	}
	
	else if (option == 2) {
		rtnResult = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"MATNR"]];
		objServiceManagementData.MatResultText = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"MAKTX_INSYLANGU"]];
	}
	else if (option == 3) {
		rtnResult = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"PRODUCT_ID"]];
	}
	else
        rtnResult = nil;
	//rtnResult = [NSString stringWithFormat:@"%@",[[self.resultArray objectAtIndex:0] objectForKey:@"SEARCH_STRING"]];
    
	
	
	return rtnResult;
}
///Call while closing the picker view..
-(BOOL)closeCustomPicker:(id)sender {
    [self.pickerViewActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [pickerToolbar release];
    [pickerViewActionSheet release];
	[pickerView release];
	
    return YES;
}

#pragma mark UIPickerViewDelegate & UIPickerViewDataSource methods
//Delegate function of picker view..
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
//Delegate function of picker view..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [temparray count];
}
//Delegate function of picker view..
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	self.pickerValue = [temparray objectAtIndex:0];
	return [temparray objectAtIndex:row];
}
//Delegate function of picker view..
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	self.pickerValue = [temparray objectAtIndex:row];
}


- (void)dealloc {
    [super dealloc];
}


@end
