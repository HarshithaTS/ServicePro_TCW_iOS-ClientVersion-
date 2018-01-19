//
//  ActivityEditScr.h
//  ServiceManagement
//
//  Created by gss on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityEditScr : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	//Taken table view from XIB..
	IBOutlet UITableView *myTableView;
	
	//Variables to display to the text..
	UITextView  *detailsTask;
	UITextView *taskReason;
	UITextField *taskCategory;
	UITextView *displayTask;
	
	UILabel *commonLabel;
	
	UITextField *textDuration;
	//Holding the response message array...
	NSMutableArray *updateResponseMsgArray;
	
	//Task update flag....
	BOOL updateSucessFlag;
	
	UIAlertView *alert;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextView *displayTask;

@property (nonatomic, retain ) UILabel *commonLabel;

@property (nonatomic,retain) UITextField *textDuratiobn;

@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;
@property (nonatomic, assign) BOOL updateSucessFlag;

@property (nonatomic, retain) UIAlertView *alert;


-(void) saveData:(UITextField*)textfield ;
-(void) SaveTask;
-(BOOL)updatetaskInSAPServer:(NSString *)strPar5;
-(void)cancelDefaultAlertAndCallSAPUpdate;
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;

@end
