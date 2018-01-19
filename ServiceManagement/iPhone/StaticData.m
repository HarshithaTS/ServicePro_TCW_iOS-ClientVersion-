//
//  StaticData.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*-----
 This class I have taken for the static data.... like drop down data....
 Now I have integrated this class in EditTask page...
 in 'init' functions I have declared all the static arrays....
 ----*/

#import "StaticData.h"


static StaticData *sharedSingleton = NULL;

@implementation StaticData

@synthesize taskStatusArray, taskReasonArray, taskPriorityArray, taskTimeZoneArray ;
@synthesize taskStatusMappingArray;
@synthesize unitsArray;

//Creating singletone class...
+(StaticData*) sharedStaticData
{
	@synchronized(self)
	{
		if(!sharedSingleton)
			sharedSingleton = [[StaticData alloc] init];
	}
	
	return sharedSingleton;
}



-(id)init
{
	if(self=[super init])
	{
        self.taskStatusArray = [[NSMutableArray alloc] initWithObjects:@"Ready",@"Accepted",@"Deferred - no parts",@"Declined",@"Completed", nil];
		self.taskReasonArray = [[NSMutableArray alloc] initWithObjects:@"On Leave",@"Sick",@"Engaged in another Job",@"Training",@"Travelling",@"Other", nil];
		self.taskPriorityArray = [[NSMutableArray alloc] initWithObjects:@"Very High",@"High",@"Medium",@"Low", nil];
		self.taskTimeZoneArray = [[NSMutableArray alloc] initWithObjects:@"Greenwich Mean Time GMT",@"Universal Coordinated Time GMT",@"European Central Time GMT+1:00",@"Eastern European Time GMT+2:00",@"(Arabic) Egypt Standard Time GMT+2:00",@"Eastern African Time GMT+3:00",@"Middle East Time GMT+3:30",@"Near East Time GMT+4:00",@"Pakistan Lahore Time GMT+5:00",@"India Standard Time GMT+5:30",@"Bangladesh Standard Time GMT+6:00",@"Vietnam Standard Time GMT+7:00",@"China Taiwan Time GMT+8:00",@"Japan Standard Time GMT+9:00",@"Australia Central Time GMT+9:30",@"Australia Eastern Time GMT+10:00",@"Solomon Standard Time GMT+11:00",@"New Zealand Standard Time GMT+12:00",@"Midway Islands Time GMT-11:00",@"Hawaii Standard Time GMT-10:00",@"Alaska Standard Time GMT-9:00",@"Pacific Standard Time GMT-8:00",@"Phoenix Standard Time GMT-7:00",@"Mountain Standard Time GMT-7:00",@"Central Standard Time GMT-6:00",@"Eastern Standard Time GMT-5:00",@"Indiana Eastern Standard Time GMT-5:00",@"Puerto Rico and US Virgin Islands Time GMT-4:00",@"Canada Newfoundland Time GMT-3:30",@"Argentina Standard Time GMT-3:00",@"Brazil Eastern Time GMT-3:00",@"Central African Time GMT-1:00", nil];
		self.unitsArray = [[NSMutableArray alloc] initWithObjects:@"PC",@"EA",nil];        
        self.taskStatusMappingArray = [NSArray arrayWithObject:									   
									   [NSDictionary dictionaryWithObjectsAndKeys:
										@"Ready",@"WAIT",
										@"Accepted", @"ACPT",
										@"Deferred - no parts", @"DEFR",
										@"Declined", @"RJCT",
										@"Completed", @"COMP",
                                        nil]];
               
                                       
                                       }
	
	return self;
}


@end
