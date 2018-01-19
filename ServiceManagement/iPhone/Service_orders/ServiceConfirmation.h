//
//  ServiceConfirmation.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*...This page for service confirmation and activity listing........
 ...Please consult with Ibrahim...for deatils of this page..after that proceed*/

#import <UIKit/UIKit.h>


@interface ServiceConfirmation : UIViewController <UITableViewDelegate, UITextViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *myTableView;
	
	UITextView *displayServiceOrder;
	IBOutlet UIButton *addNewConfirmationButton;
	
	NSMutableArray *isAnyCheckboxSelectedArray;
	
	NSMutableDictionary *checkBoxValueDictionary;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) UITextView *displayServiceOrder;
@property (nonatomic, retain) IBOutlet UIButton *addNewConfirmationButton;

@property (nonatomic, retain) NSMutableArray *isAnyCheckboxSelectedArray;

@property (nonatomic, retain) NSMutableDictionary *checkBoxValueDictionary;


-(IBAction) checkBoxedClicked:(id)sender;
-(IBAction) pressedAddNewConfirmationButton:(id)sender;
-(void) goBack;




@end
