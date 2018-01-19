//
//  ServiceOrderView.h
//  ServiceManagement
//
//  Created by gss on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColleagueTaskView : UIViewController <UIAlertViewDelegate, UITextFieldDelegate,UITextViewDelegate>{
//Taken table view from XIB..
IBOutlet UITableView *myTableView;

NSString *service_url;    
NSString *object_id;
    
    
//Variables to display to the text..
UITextView  *detailsTask;
UITextView *taskReason;
UITextField *taskCategory;
UITextView *displayTask;

UILabel *commonLabel;

//Holding the response message array...
NSMutableArray *updateResponseMsgArray;

//Task update flag....
BOOL updateSucessFlag;

UIAlertView *alert;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSString *service_url;

@property(nonatomic, retain) NSString *object_id;


@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextView *displayTask;

@property (nonatomic, retain ) UILabel *commonLabel;
@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;
@property (nonatomic, assign) BOOL updateSucessFlag;

@property (nonatomic, retain) UIAlertView *alert;


-(void) saveData:(UITextField*)textfield ;
-(void) SaveTask;
-(BOOL)updatetaskInSAPServer:(NSString *)strPar5;
-(void)cancelDefaultAlertAndCallSAPUpdate;
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;
-(BOOL) serviceOrderConfirmationListingDownloadFromSAP;
-(BOOL) getColleagueListDownloadFromSAP;
@end
