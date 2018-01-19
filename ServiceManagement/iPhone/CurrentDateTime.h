//
//  CurrentDateTime.h
//  ServiceManagement
//
//  Created by gss on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentDateTime : UIViewController {

}
-(NSString *)currentdate;
-(NSString *)currentdatewithnexthour;
-(NSString *)getDateFromString: (NSString *)paraDateTime;
-(NSString *)getTimeFromString: (NSString *)paraDateTime;
-(NSString *)getShortDateFromString: (NSDate *)paraDateTime;

-(NSString *) convertMMMDDformattoyyyMMdd:(NSString *)dateString;
-(NSString *) convertMMMDDYYYYHHMMSSformattoyyyMMdd:(NSString *)dateString;
-(NSString*)StringConverttoFormat:(NSString *)dateString;
-(NSString *) convertShortDateToStringFormat:(NSString *)dateString;
-(NSString *) convertShortDateToStringFormat1:(NSString *)dateString;
@end
