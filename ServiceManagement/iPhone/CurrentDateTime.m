    //
//  CurrentDateTime.m
//  ServiceManagement
//
//  Created by gss on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentDateTime.h"


@implementation CurrentDateTime


-(NSString *)currentdate

{
	
	NSDate* mDate = [NSDate date];

    //Create the dateformatter object
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	//Set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:00"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];

	//Get the string date
	NSString* str = [formatter stringFromDate:mDate];
	//Display on the console
 	//Set in the lable
	return str;
	
}
-(NSString *)currentdatewithnexthour

{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

	NSDate* mDate = [NSDate date];
	// now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: mDate options:0];
    [offsetComponents release];
    [gregorian release];
	
	
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	//Set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:00"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	//Get the string date
	NSString* str = [formatter stringFromDate:nextDate];
	NSLog(@"next date %@",str);
	return str;
	
}

-(NSString *)getDateFromString: (NSString *)paraDateTime
{
	NSDate* mDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	//[formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *str = [formatter stringFromDate:mDate];
	NSLog(@"DATE %@, %@", mDate,str);
    [formatter release],formatter=nil;
	return str;
}


-(NSString *)getShortDateFromString: (NSDate *)paraDateTime
{
    NSDateFormatter *simpleDateFormat = [[NSDateFormatter alloc] init];
    simpleDateFormat.dateFormat = @"yyyy-MM-dd";
	//[simpleDateFormat setDateFormat:@"yyyy-MM-dd"];
	NSString *str = [simpleDateFormat stringFromDate:paraDateTime];
	NSLog(@"DATE %@, %@", paraDateTime,str);
    [simpleDateFormat release],simpleDateFormat =nil;
	return str;
}

-(NSString *)getTimeFromString: (NSString *)paraDateTime
{
	NSDate *mDate = [NSDate date];
	
    //Convert String to date
	//create the dateformater object
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	//set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	//Get the string date
	mDate = [formatter dateFromString:paraDateTime];
	
	//Convert date to string
	[formatter setDateFormat:@"HH:MM:SS"];
	NSString *str = [formatter stringFromDate:mDate];
	return str;
	
	
}

-(NSString *) convertShortDateToStringFormat:(NSString *)dateString
{
    NSString *dateStr = @"";

    @try {
        // Convert string to date object
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormat dateFromString:dateString];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"MMM d, yyyy"];
        dateStr = [dateFormat stringFromDate:date];
        [dateFormat release];
        
       // NSLog(@"%@, %@ %@",dateString,date,dateStr);
        return dateStr;
    }
    @catch (NSException *exception) {
        return dateStr;
    }
       
}
-(NSString *) convertShortDateToStringFormat1:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"MMM d"];
    dateStr = [dateFormat stringFromDate:date];
    [dateFormat release];
    
    //NSLog(@"%@, %@ %@",dateString,date,dateStr);
    return dateStr;
   
}

-(NSString *) convertMMMDDformattoyyyMMdd:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    NSDate *date = [dateFormat dateFromString:dateString];  
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];  
    [dateFormat release];        
    
    //NSLog(@"%@, %@ %@",dateString,date,dateStr);
    return dateStr;
    
}
-(NSString *) convertMMMDDYYYYHHMMSSformattoyyyMMdd:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY hh:MM:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];  
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];  
    [dateFormat release];        
    return dateStr;
    
}

-(NSString*)StringConverttoFormat:(NSString *)dateString
{
    
    NSArray *date_array1 = [dateString componentsSeparatedByString:@" "];
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MMM"];
    NSDate* myDate = [dateFormatter dateFromString:[date_array1 objectAtIndex:0]];
    
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:myDate];
    
    NSArray *date_array2 = [[date_array1 objectAtIndex:1] componentsSeparatedByString:@","]; 
    
    
    NSString *dateFormat = [NSString stringWithFormat:@"%@-%@-%@",[date_array2 objectAtIndex:1],month,[date_array2 objectAtIndex:0]];
    
    return dateFormat;
}/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super dealloc];
}


@end
