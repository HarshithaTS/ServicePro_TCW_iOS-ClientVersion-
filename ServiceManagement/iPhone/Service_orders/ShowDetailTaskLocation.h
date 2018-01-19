//
//  ShowDetailTaskLocation.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*--Displaying deatils is task location address....*/

#import <UIKit/UIKit.h>


@interface ShowDetailTaskLocation : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *myTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;


-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue;

@end
