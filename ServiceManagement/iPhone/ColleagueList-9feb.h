//
//  ColleagueList.h
//  ServiceManagement
//
//  Created by gss on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColleagueList : UIViewController<UIAlertViewDelegate,  UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    
    NSString *partnerId;
 
  	//these valiables are needed when donwloading data's from SAP, to show the users some activity is happening...
	UIImageView *loadingImgView;
	UIActivityIndicatorView *actView;
    
    
    //for cancel button and table view
    IBOutlet UIButton *buttonCancel;
    IBOutlet UITableView *tableViewColleague;
    
    
    //Below variables for searching..
	UISearchBar *sBar;
	BOOL searching;	
	NSMutableArray *dubArrayList;	
	BOOL searchHaldleFlagWhenBack;

    
    // index of row.. in which task user cliked, hold that task id...
	NSInteger rowIndex;
	NSString *object_id;
    
    UIAlertView *alert;
    NSIndexPath *mIndexPath;

}

//@property(nonatomic, retain) NSString *partnerId;
@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;


@property(nonatomic) NSInteger rowIndex;
@property(nonatomic, retain) NSString *object_id;

@property (nonatomic, retain) IBOutlet UITableView *tableViewColleague;
@property (nonatomic, retain) IBOutlet UIButton *buttonCancel;


@property (nonatomic, retain) UISearchBar *sBar;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, retain) NSMutableArray *dubArrayList;
@property (nonatomic, assign) BOOL searchHaldleFlagWhenBack;


@property (nonatomic, assign) UIAlertView *alert;
@property (nonatomic, assign) NSIndexPath *mIndexPath;

-(void)cancelButtonClick;
-(void) searchTableView;
-(BOOL) getColleagueTaskListDownloadFromSAP;
-(BOOL) transferColleagueTaskList;
-(void) callSAPDownload:(NSIndexPath *) IndexPath;
@end
