//
//  CompletedTasks.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompletedTasks : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIActionSheetDelegate> {
	
	UISearchBar *sBar;
	UITableView *myTableView;
	UIScrollView *myScrollView;
	NSMutableArray *completedArrayList;
	NSMutableArray *mainArrayList;
	NSMutableArray *dubArrayList;
	//these valiables are needed when donwloading data's from SAP, to show the users some activity is happening...
	UIImageView *loadingImgView;
	UIActivityIndicatorView *actView;
	
	BOOL searching;
	BOOL letUserSelectRow;
	UIScrollView *previewScrollView;
	float kvcPreviewScrollViewHeight;
	
	BOOL postingDateFlag;
	BOOL soldToPartyFlag;
	BOOL objectidFlag;
	
	
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UISearchBar *sBar;
@property (nonatomic, retain) NSMutableArray *mainArrayList;
@property (nonatomic, retain) NSMutableArray *dubArrayList;
@property (nonatomic, assign) BOOL searching;


@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;


@property (nonatomic, assign) BOOL postingDateFlag;
@property (nonatomic, assign) BOOL soldToPartyFlag;
@property (nonatomic, assign) BOOL objectidFlag;




-(UITableViewCell *)reuseTableViewCellWithIdentifier:(NSString *)identifier;
-(void) callSAPDownloadMethod;
-(BOOL)downloadDataFromSAP;
-(void)searchTableView;
//-(void)gotoSorting;
-(IBAction)orderingTask:(id)sender;

@end
