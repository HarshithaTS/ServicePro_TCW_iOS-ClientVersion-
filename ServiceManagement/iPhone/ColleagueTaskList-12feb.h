//
//  ServiceOrders.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ColleagueTaskList : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UITextViewDelegate> {

	IBOutlet UITableView *myTableView;
	
	// index of row.. in which task user cliked, hold that task id...
	NSInteger rowIndex;
	NSString *object_id;
    UITextView *textView;
	
	//below flags for ordering the task...tracking what will be next is Ascending or Descending 
	BOOL priorityOrderByFlag;
	BOOL dueDateOrderByFlag;
	BOOL statusOrderByFlag;
	BOOL subjectOrderByFlag;
	
	//Below variables for searching..
	UISearchBar *sBar;
	BOOL searching;	
	NSMutableArray *dubArrayList;	
	BOOL searchHaldleFlagWhenBack;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic) NSInteger rowIndex;
@property(nonatomic, retain) NSString *object_id;
@property (nonatomic, assign) BOOL priorityOrderByFlag;
@property (nonatomic, assign) BOOL dueDateOrderByFlag;
@property (nonatomic, assign) BOOL statusOrderByFlag;
@property (nonatomic, assign) BOOL subjectOrderByFlag;

@property (nonatomic, retain) UISearchBar *sBar;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, retain) NSMutableArray *dubArrayList;

@property (nonatomic, assign) BOOL searchHaldleFlagWhenBack;


-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay;
-(IBAction)orderingTask:(id)sender;
-(void) searchTableView;

-(UITableViewCell *)taskTableViewCellWithIdentifier:(NSString *)identifier;
-(void) dailNumber1;
-(void) dailNumber2;
-(void) movetoColleagueList;
@end

