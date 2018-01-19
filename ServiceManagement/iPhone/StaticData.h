//
//  StaticData.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StaticData : NSObject {
	
	NSMutableArray *taskStatusArray;
	NSMutableArray *taskReasonArray;
	NSMutableArray *taskPriorityArray;
	NSMutableArray *taskTimeZoneArray;
	NSMutableArray *unitsArray;
	NSArray *taskStatusMappingArray;
	

}

@property (nonatomic, retain) NSMutableArray *taskStatusArray;
@property (nonatomic, retain) NSMutableArray *taskReasonArray;
@property (nonatomic, retain) NSMutableArray *taskPriorityArray;
@property (nonatomic, retain) NSMutableArray *taskTimeZoneArray;
@property (nonatomic, retain) NSMutableArray *unitsArray;

@property (nonatomic, retain) NSArray *taskStatusMappingArray;


+(StaticData*) sharedStaticData;


@end
