//
//  FaultEditScr.h
//  ServiceManagement
//
//  Created by gss on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FaultEditScr : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	
	//Taken table view from XIB..
	IBOutlet UITableView *myTableView;
	IBOutlet UIButton *butDone;
	
	//Variables to display to the text..
	UITextView  *detailsTask;
	UITextView *taskReason;
	UITextField *taskCategory;
	UITextView *displayTask;
	
	UILabel *commonLabel;
	
	UITextField *textDuration;
	//Holding the response message array...
	NSMutableArray *updateResponseMsgArray;
	NSMutableArray *pickerSourceArray;
	
	//Task update flag....
	BOOL updateSucessFlag;
	
	UIAlertView *alert;
	
	UITextField *textSymptomGroup,*textSymptomCode;
	UITextField *textProblemGroup,*textProblemCode;
	UITextField *textCauseGroup,*textCauseCode;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextView *displayTask;

@property (nonatomic, retain ) UILabel *commonLabel;

@property (nonatomic,retain) UITextField *textDuratiobn;

@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;
@property (nonatomic, retain) NSMutableArray *pickerSourceArray;
@property (nonatomic, assign) BOOL updateSucessFlag;

@property (nonatomic, retain) UIAlertView *alert;

@property (nonatomic, retain) UITextField *textSymptomGroup;
@property (nonatomic, retain) UITextField *textSymptomCode;

@property (nonatomic, retain) UITextField *textProblemGroup;
@property (nonatomic, retain) UITextField *textProblemCode;

@property (nonatomic, retain) UITextField *textCauseGroup;
@property (nonatomic, retain) UITextField *textCauseCode;



-(void) saveData:(UITextField*)textfield ;
-(IBAction) SaveTask;

-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;
- (NSMutableArray *) searchTextInArray:(NSString *) code:(NSMutableArray*)array;
-(void) goBack;

@end
