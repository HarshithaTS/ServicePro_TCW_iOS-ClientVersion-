//Custom dat picker..
///
////

#import "CustomDatePicker.h"
#import "ServiceManagementData.h"


@implementation CustomDatePicker
@synthesize theDatePicker, pickerToolbar, pickerViewDate, sourceTableView, className;

//Calling this function from where you want to display date picker..
//Depending upon the 'identifire' parameter... can distinguished the each other date picker... just change the identifire name..
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire {
	className = identifire;
	
	
	self.sourceTableView = sender;
	
    self.pickerViewDate = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:self
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:nil];
	
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter setDateFormat:@"g"];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            NSLog(@"dddd %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]);
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]]];		
			[dateFormat release];
		}
	
	}
	else if([className isEqualToString:@"ActDateFrom"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"]]];		
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ActDateTo"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"]]];		
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ETADate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;// UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [timeFormat setDateFormat:@"hh:MM:ss"];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]];
             
  			//[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
           
			[dateFormat release];
            [timeFormat release];
		}
        
	}
    self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    self.pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolbar sizeToFit];
	
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClick)];
    [barItems addObject:doneBtn];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerCancelClick)];
    [barItems addObject:cancelBtn];
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [self.pickerViewDate addSubview:pickerToolbar];
    [self.pickerViewDate addSubview:theDatePicker];
    [self.pickerViewDate  showInView:sender];
    [self.pickerViewDate setBounds:CGRectMake(0.0, 0.0, 320.0, 470.0)];

}

//This function will call when date picker..Cancel button is clicked..
-(IBAction) datePickerCancelClick {
	[self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [self.pickerToolbar release];
    [self.pickerViewDate release];
	[self.theDatePicker release];
}

//When date picker date is changed this function will call
-(void)dateChanged{

	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	if([className isEqualToString:@"DueDate"]){
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		//[dateFormat setDateFormat:@"yyyy-MM-dd" ];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDate = [dateFormat stringFromDate:[self.theDatePicker date]];
		[dateFormat release];
		//NSLog(@"selected date %@",selectedDate);
		[objServiceManagementData.taskDataDictionary setObject:selectedDate forKey:@"ZZKEYDATE"];
		
	}	
	else if([className isEqualToString:@"ActDateFrom"]){
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS" ];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDateTime = [dateFormat stringForObjectValue:[self.theDatePicker date]];
		//[dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDate = [dateFormat stringForObjectValue:[self.theDatePicker date]];
		[dateFormat setDateFormat:@"HH:mm:SS"];
		NSString *selectedTime = [dateFormat stringForObjectValue:[self.theDatePicker date]]; 
		
		[dateFormat release];
		//NSLog(@"selected date %@, %@, %@",selectedDateTime,selectedDate,selectedTime);
		[objServiceManagementData.taskDataDictionary setObject:selectedDateTime forKey:@"DATETIME_FROM"];
		[objServiceManagementData.taskDataDictionary setObject:selectedDate forKey:@"DATE_FROM"];
		[objServiceManagementData.taskDataDictionary setObject:selectedTime forKey:@"TIME_FROM"];
		
	}
	else if([className isEqualToString:@"ActDateTo"]){
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS" ];
		NSString *selectedDateTime = [dateFormat stringFromDate:[self.theDatePicker date]];
		//[dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDate = [dateFormat stringForObjectValue:[self.theDatePicker date]];
		[dateFormat setDateFormat:@"HH:mm:SS"];
		NSString *selectedTime = [dateFormat stringForObjectValue:[self.theDatePicker date]]; 
		
		[dateFormat release];
		//NSLog(@"selected date %@",selectedDate);
		[objServiceManagementData.taskDataDictionary setObject:selectedDateTime forKey:@"DATETIME_TO"];
		[objServiceManagementData.taskDataDictionary setObject:selectedDate forKey:@"DATE_TO"];
		[objServiceManagementData.taskDataDictionary setObject:selectedTime forKey:@"TIME_TO"];

	}
    else if([className isEqualToString:@"ETADate"]){
		
		/*self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [timeFormat setDateFormat:@"hh:MM:ss"];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]];
            
  			[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
            
			[dateFormat release];
            [timeFormat release];
		}*/
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS" ];
		//NSString *selectedDateTime = [dateFormat stringForObjectValue:[self.theDatePicker date]];
		//[dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDate = [dateFormat stringForObjectValue:[self.theDatePicker date]];
		[dateFormat setDateFormat:@"HH:mm:SS"];
		NSString *selectedTime = [dateFormat stringForObjectValue:[self.theDatePicker date]]; 
		
		[dateFormat release];
		//NSLog(@"selected date %@, %@, %@",selectedDateTime,selectedDate,selectedTime);
		[objServiceManagementData.taskDataDictionary setObject:selectedDate forKey:@"ZZETADATE"];
		[objServiceManagementData.taskDataDictionary setObject:selectedTime forKey:@"ZZETATIME"];        
        
        
        
        
	}
	[self.sourceTableView reloadData];
}
//****************************************************************************************


//**Biren Changes on 01/02/2013****************

//****************************************************************************************



-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown tableCell:(UITableViewCell *)cell {
    
    className = identifire;
	
	self.sourceTableView = sender;
    
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter setDateFormat:@"g"];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            NSLog(@"dddd %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]);
			//[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]]];
			[dateFormat release];
		}
        
	}
	else if([className isEqualToString:@"ActDateFrom"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"]]];
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ActDateTo"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"]]];
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ETADate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;// UIDatePickerModeDate;
		
		//if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"])
        if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] ||[[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@""])) 
            
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [timeFormat setDateFormat:@"hh:MM:ss"];
            
            
            NSLog(@"eta %@",[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]);
            
			//[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]];
            
  			//[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
            
			[dateFormat release];
            [timeFormat release];
		}
        
	}
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerIpadDoneClick)];
    [barItems addObject:doneBtn];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerIpadCancelClick)];
    [barItems addObject:cancelBtn];
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [self.theDatePicker addSubview:pickerToolbar];
    
    
    
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 470)];
    CGRect thePickerFrame = theDatePicker.frame;
    thePickerFrame.origin.y = pickerToolbar.frame.size.height;
    [theDatePicker setFrame:thePickerFrame];
    
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:theDatePicker];
    [view addSubview:pickerToolbar];
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setView:view];
    [vc setContentSizeForViewInPopover:CGSizeMake(320, 260)];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    
    
    [popover presentPopoverFromRect:dropDown inView:cell
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

//for view
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown myView:(UIView *)cell {
    
    className = identifire;
	
	self.sourceTableView = sender;
    
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter setDateFormat:@"g"];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            NSLog(@"dddd %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]);
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]]];
			[dateFormat release];
		}
        
	}
	else if([className isEqualToString:@"ActDateFrom"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_FROM"]]];
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ActDateTo"]){
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"DATETIME_TO"]]];
			[dateFormat release];
		}
		
	}
	else if([className isEqualToString:@"ETADate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;// UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [timeFormat setDateFormat:@"hh:MM:ss"];
			//[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]];
            
  			//[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
            
			[dateFormat release];
            [timeFormat release];
		}
        
	}
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerIpadDoneClick)];
    [barItems addObject:doneBtn];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerIpadCancelClick)];
    [barItems addObject:cancelBtn];
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [self.theDatePicker addSubview:pickerToolbar];
    
    
    
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 470)];
    CGRect thePickerFrame = theDatePicker.frame;
    thePickerFrame.origin.y = pickerToolbar.frame.size.height;
    [theDatePicker setFrame:thePickerFrame];
    
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:theDatePicker];
    [view addSubview:pickerToolbar];
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setView:view];
    [vc setContentSizeForViewInPopover:CGSizeMake(320, 260)];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    
    
    [popover presentPopoverFromRect:dropDown inView:cell
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(IBAction) datePickerIpadCancelClick {
	[self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [self.pickerToolbar release];
    [self.pickerViewDate release];
	[self.theDatePicker release];
    [popover dismissPopoverAnimated:YES];
    [popover release];
}

-(IBAction)datePickerIpadDoneClick{
	[self dateChanged];
	[self closeDatePicker:self];
    [popover dismissPopoverAnimated:YES];
    [popover release];
}

//****************************End*****************



//Closing the date picker..
-(BOOL)closeDatePicker:(id)sender{   
    [self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [self.pickerToolbar release];
    [self.pickerViewDate release];
	[self.theDatePicker release];
    return YES;
}

//When done button is pressed..
-(IBAction)datePickerDoneClick{   
	[self dateChanged];
	[self closeDatePicker:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}

@end
