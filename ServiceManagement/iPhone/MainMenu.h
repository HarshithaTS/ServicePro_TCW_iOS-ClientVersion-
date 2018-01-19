//
//  MainMenu.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MainMenu : UIViewController <UINavigationControllerDelegate> {

 	
	//these valiables are needed when donwloading data's from SAP, to show the users some activity is happening...
	UIImageView *loadingImgView;
	UIActivityIndicatorView *actView;
		
	
	//Searching Task related variable, when back edit task to task list page
	BOOL modifySearchWhenBackFalg;
	NSInteger activeFaultSegmentIndexFlag;
	BOOL activitySparesEditedFlag;
    
    
    //image local storage path
    NSString *localImageFilePath;
    UIImage *attachmentImage;
    NSString *encryptedImageString;

        
	//These all are buttons taken in xib
	IBOutlet UIButton *btnServiceOrder;
	IBOutlet UIButton *btnCompletedTasks;
	IBOutlet UIButton *btnVanStock;
	IBOutlet UIButton *btnInstBaseReport;
	IBOutlet UIButton *btnMyUtilization;
	IBOutlet UIButton *btnBillableSO;
    IBOutlet UIButton *btnRestartApp;
    
    UIScrollView *scroll;
    
    //Get Apple System Configuration
    NSMutableString *log;
	IBOutlet UITextView *textView;
   //End System Configuration
    
    IBOutlet UITextView *textField;
    
    
    
    NSMutableArray *getInputArray;
    
}

//Get Apple System Configuration
@property (retain) NSMutableString *log;
@property (retain) UITextView *textView;
@property (nonatomic, retain) IBOutlet UITextView *textField;

@property (nonatomic, retain)UIScrollView *scroll;
//End System Configuration


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainController;

@property (nonatomic, retain) NSString *service_url;

@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;

@property (nonatomic, assign) BOOL modifySearchWhenBackFalg;

@property (nonatomic, assign) NSInteger activeFaultSegmentIndexFlag;

@property (nonatomic, assign) BOOL activitySparesEditedFlag;

@property (nonatomic, retain)  NSString *localImageFilePath;
@property (nonatomic, retain) UIImage *attachmentImage;
@property (nonatomic, retain)  NSString *encryptedImageString;







-(BOOL) getColleagueListDownloadFromSAP;

-(IBAction)gotoServiceOrders:(id)sender;
-(IBAction)gotoCompletedTasks:(id)sender;
-(IBAction)gotoVanStock:(id)sender;
-(IBAction)gotoInstBaseReport:(id)sender;
-(IBAction)gotoMyUtilization:(id)sender;
-(IBAction)gotoBillableSO:(id)sender;
-(IBAction)gotoRestartApp:(id)sender;
-(IBAction)gotoGssInfoView:(id)sender;

-(void) GETCONTEXTDATA;
-(void) GETSERVICETASKDATA;

@end
