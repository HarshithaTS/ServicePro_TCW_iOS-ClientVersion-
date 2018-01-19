//
//  SparesEdit.h
//  ServiceManagement
//
//  Created by gss on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SparesEdit : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate> {//,ZBarReaderDelegate> {

	//Taken table view from XIB..
	IBOutlet UITableView *myTableView;
	IBOutlet UIButton *butDone;
	
	//Variables to display to the text..
	UITextView  *detailsTask;
	UITextView *taskReason;
	UITextField *taskCategory;
	UITextField *materialQty;
    UITextField *materialUnit;
	UITextView *displayTask;
	UITextView *textSparesDesc;
	UILabel *commonLabel;
	
	UITextField *textDuration, *textMaterialId;
	//Holding the response message array...
	NSMutableArray *updateResponseMsgArray;
	NSString *mQuantity;
	NSString *mSerialNumber;
	//Task update flag....
	BOOL updateSucessFlag;
	id _textField;
	UIAlertView *alert;
	UITextField *otherUnit;
	UITextField *materialSerialNumber;
    
    
    //barcode decoder
    UIButton *scanImageButton;

    

}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextField *materialQty;
@property (nonatomic, retain) UITextField *materialUnit;
@property (nonatomic, retain) UITextView *displayTask;
@property (nonatomic, retain) UITextView *textSparesDesc;

@property (nonatomic, retain ) UILabel *commonLabel;

@property (nonatomic,retain) UITextField *textDuratiobn;
@property (nonatomic,retain) UITextField *textMaterialId;

@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;
@property (nonatomic, assign) BOOL updateSucessFlag;
@property (nonatomic, retain) NSString *mQuantity;
@property (nonatomic, retain) NSString *mSerialNumber;

@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UITextField *otherUnit;
@property (nonatomic, retain) UITextField *materialSerialNumber;

//barcode decoder
@property (nonatomic, retain) UIButton *scanImageButton;

- (IBAction) scanButtonTapped:(id)sender;
//end


-(void) goBack;
-(IBAction) updateSparesDataIntoDatabase;
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;
-(void)setViewMovedUp:(BOOL)movedUp;
- (void)keyboardWillShow:(NSNotification *)notif;

@end
