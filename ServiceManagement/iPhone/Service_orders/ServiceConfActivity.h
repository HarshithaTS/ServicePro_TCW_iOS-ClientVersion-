//
//  ServiceConfActivity.h
//  ServiceManagement
//
//  Created by gss on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceConfActivity : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

	//Taken table view from XIB..
	IBOutlet UITableView *myTableView;
	
	IBOutlet UIButton *done;
	
	
	//Variables to display to the text..
	UITextView  *detailsTask;
	UITextView *taskReason,*textNotes;
	UITextField *taskCategory;
	UITextView *displayTask;
	
	UILabel *commonLabel;
	NSString *durationhrs;
	NSString *arrayIndex;
	
	UITextField *textDuration;

	
	UIAlertView *alert;
	
	UITextField	*textFieldActivity, *textFieldTimezone;
	id *_textField;


	
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIButton *done;

@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason,*textNotes;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextView *displayTask;

@property (nonatomic, retain ) UILabel *commonLabel;

@property (nonatomic, retain) NSString *durationhrs;
@property (nonatomic, retain) NSString *arrayIndex;


@property (nonatomic,retain) UITextField *textDuratiobn;



@property (nonatomic, retain) UIAlertView *alert;

@property (nonatomic, retain, readonly) UITextField	*textFieldActivity;
@property (nonatomic, retain, readonly) UITextField	*textFieldTimezone;

-(void) saveData:(UITextField*)textfield ;
-(void) goBack;

-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;
-(IBAction) doneButtonClick:(id) sender;
-(void)setViewMovedUp:(BOOL)movedUp;
- (void)keyboardWillShow:(NSNotification *)notif;

	
	
	
	

@end
