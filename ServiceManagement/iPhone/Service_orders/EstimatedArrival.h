//
//  EstimatedArrival.h
//  ServiceManagement
//
//  Created by Vivek Kumar G on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@protocol EstimatedArrivalDelegate <NSObject>

@required
-(void)EstimatedArrival_DataExchange:(NSString *)data;

@end



@interface EstimatedArrival : UIViewController
{
    
    NSString *CDate;
    id <EstimatedArrivalDelegate> delegate;  
    IBOutlet UIButton *butDone;
}

@property (retain) id delegate;

@property (nonatomic, retain) IBOutlet UIButton *butDone;

@property (nonatomic,retain) IBOutlet UIButton *BDateT;
@property (nonatomic,retain) IBOutlet UIView *MSG_view1;
@property (nonatomic,retain) IBOutlet UIView *MSG_view2;

@property (nonatomic,retain) IBOutlet UILabel *MSG_DATE;

@property (nonatomic,retain) NSString *CDate;


-(IBAction)ClickDateTime:(id)sender;
-(IBAction)ClickDone:(id)sender;
-(IBAction)ClickCancel:(id)sender;


@end
