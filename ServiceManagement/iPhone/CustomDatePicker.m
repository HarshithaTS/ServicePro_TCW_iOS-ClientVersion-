//Custom dat picker..
///
////

#import "CustomDatePicker.h"
#import "ServiceManagementData.h"
#import "Design.h"
@implementation NSDateFormatter (Locale);

- (id)initWithSafeLocale {
    static NSLocale* en_US_POSIX = nil;
    self = [self init];
    if (en_US_POSIX == nil) {
        en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    [self setLocale:en_US_POSIX];
    return self;
}


@end
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
	
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
    NSDateFormatter *dateFormatter2 = [[[NSDateFormatter alloc] initWithSafeLocale] autorelease];
    [dateFormatter2 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter2 setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter2 setDateFormat:@"g"];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] initWithSafeLocale];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [timeFormat setDateFormat:@"hh:MM:ss"];
			[self.theDatePicker setDate:[dateFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]]];
             
  			//[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
           
			[dateFormat release];
            [timeFormat release];
		}
        
	}
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    self.pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolbar sizeToFit];
	
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClick)];
    [barItems addObject:doneBtn];
	[doneBtn release], doneBtn =nil;
    
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerCancelClick)];
    [barItems addObject:cancelBtn];
    [cancelBtn release],cancelBtn =nil;
	
    [self.pickerToolbar setItems:barItems animated:YES];
    
    [barItems release],barItems = nil;
    
    [self.pickerViewDate addSubview:self.pickerToolbar];
    [self.pickerViewDate addSubview:self.theDatePicker];
    [self.pickerViewDate  showInView:sender];
    [self.pickerViewDate setBounds:CGRectMake(0.0, 0.0, 320.0, 470.0)];
    
    
}

//This function will call when date picker..Cancel button is clicked..
-(IBAction) datePickerCancelClick {
	[self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [pickerToolbar release];
    [pickerViewDate release];
	[theDatePicker release];
}

//When date picker date is changed this function will call
-(void)dateChanged{

	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	if([className isEqualToString:@"DueDate"]){
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
		//[dateFormat setDateFormat:@"yyyy-MM-dd" ];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
		NSString *selectedDate = [dateFormat stringFromDate:[self.theDatePicker date]];
		[dateFormat release];
		//NSLog(@"selected date %@",selectedDate);
		[objServiceManagementData.taskDataDictionary setObject:selectedDate forKey:@"ZZKEYDATE"];
		
	}	
	else if([className isEqualToString:@"ActDateFrom"]){
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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


//**Biren Changes datepicker for ipad on 01/02/2013****************

//****************************************************************************************
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown tableCell:(UITableViewCell *)cell:(NSString*)displaytext {
    
    className = identifire;
	
	self.sourceTableView = sender;
    //***************bIREN Changes- 8th feb
    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 85.0, 320.0, 470.0)];
    //    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    self.theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
//    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	//***************end
    NSDateFormatter *dateFormatter1 = [[[NSDateFormatter alloc] initWithSafeLocale] autorelease];
    [dateFormatter1 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter1 setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter1 setDateFormat:@"g"];
    
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] initWithSafeLocale];
			//[dateFormat setDateFormat:@"yyyy-MM-dd"];
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [timeFormat setDateFormat:@"hh:MM:ss"];
//			[self.theDatePicker setDate:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]];
            
//  		[self.theDatePicker setDate:[timeFormat dateFromString:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]]];
            
			[dateFormat release];
            [timeFormat release];
		}
        
	}
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerIpadDoneClick)];
    [barItems addObject:doneBtn];
    [doneBtn release],doneBtn = nil;
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerIpadCancelClick)];
    [barItems addObject:cancelBtn];
    [cancelBtn release], cancelBtn =nil;
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [self.theDatePicker addSubview:pickerToolbar];
    
    [barItems release],barItems = nil;
    //SELVAN
   //
    //Create view for Header text display
    UIView *headerView1;
    CGRect rectView= CGRectMake(0, 45, 320, 40);
    headerView1 = [[UIView alloc] initWithFrame:rectView];
    if (![displaytext isEqualToString:@""]) {
      
        //[headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [headerView1 setBackgroundColor:[UIColor blueColor]];
        headerView1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    
        UILabel *lblHeader1;// = [[UILabel alloc] init];
        lblHeader1 = [Design LabelFormationWithColorGray:40.0 :0.0 :300 :35:16.0f :1];
        //lblHeader1.text = [NSString stringWithFormat:@"%@",displaytext];
        lblHeader1.text = [NSString stringWithFormat:@"Estimated arrival at customer"];

        lblHeader1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        lblHeader1.font = [lblHeader1.font fontWithSize:16.0f];
        [headerView1 addSubview:lblHeader1];
    
    }
    else
    {
        CGRect thePickerFrame = self.theDatePicker.frame;
        thePickerFrame.origin.y = pickerToolbar.frame.size.height;
        [self.theDatePicker setFrame:thePickerFrame];
        
    }
  
   
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.theDatePicker];
    [view addSubview:self.pickerToolbar];
    
    if (![displaytext isEqualToString:@""]) {
        [view addSubview:headerView1];
        
    }
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setView:view];
    [vc setContentSizeForViewInPopover:CGSizeMake(320, 320)];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    [view release],view = nil;
    [vc release];
    [headerView1 release];
    
    //if([className isEqualToString:@"ETADate"])
    //popover.contentViewController.title = @"Estimated arrival at customer";
    
    [popover presentPopoverFromRect:dropDown inView:cell
    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //[dateFormatter1 release];
    
}

//for view
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown myView:(UIView *)cell {
    
    className = identifire;
	
	self.sourceTableView = sender;
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.theDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] initWithSafeLocale] autorelease];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]autorelease]];
    [dateFormatter setDateFormat:@"g"];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	if([className isEqualToString:@"DueDate"]){
		
		self.theDatePicker.datePickerMode = UIDatePickerModeDate;
		
		if(![[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"] isEqualToString:@""])
		{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithSafeLocale];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] initWithSafeLocale];
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
    [doneBtn release],doneBtn = nil;
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerIpadCancelClick)];
    [barItems addObject:cancelBtn];
    [cancelBtn release],cancelBtn = nil;
	
    [self.pickerToolbar setItems:barItems animated:YES];
    [barItems release],barItems = nil;
    [self.theDatePicker addSubview:pickerToolbar];
    
    
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 470)];
    CGRect thePickerFrame = self.theDatePicker.frame;
    thePickerFrame.origin.y = pickerToolbar.frame.size.height;
    [theDatePicker setFrame:thePickerFrame];
    
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:theDatePicker];
    [view addSubview:pickerToolbar];
    
    UIViewController *vc = [[UIViewController alloc] init];
    [vc setView:view];
    [vc setContentSizeForViewInPopover:CGSizeMake(320, 260)];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    
    [vc release];
    [view release];
    [popover presentPopoverFromRect:dropDown inView:cell
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(IBAction) datePickerIpadCancelClick {
	[self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [pickerToolbar release];
    [pickerViewDate release];
	[theDatePicker release];
    [popover dismissPopoverAnimated:YES];
    [popover release];
}

-(IBAction)datePickerIpadDoneClick{
	[self dateChanged];
	[self closeDatePicker:self];
    [popover dismissPopoverAnimated:YES];
//    [popover release];
}

//****************************End*****************



//Closing the date picker..
-(BOOL)closeDatePicker:(id)sender{   
    [self.pickerViewDate dismissWithClickedButtonIndex:0 animated:YES];
    [pickerToolbar release];
    [pickerViewDate release];
	[theDatePicker release];
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
