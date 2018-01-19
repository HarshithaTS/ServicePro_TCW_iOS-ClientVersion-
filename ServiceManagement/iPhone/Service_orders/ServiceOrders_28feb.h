//
//  ServiceOrders.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 25/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceManagementData;


@interface ServiceOrders : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
	IBOutlet UITableView *myTableView;
    IBOutlet UIScrollView *Table_ScrollView;
	
	// index of row.. in which task user cliked, hold that task id...
	NSInteger rowIndex;
	NSString *object_id;
    IBOutlet UIToolbar *toolbar;
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
    
    NSString *periorityImageName;
    NSString *statusImageName;
	NSString *tmpStr;
	NSString *mTransactionDate;
    
    NSString *Est_Arrival;
    NSString *ServiceDoc;
    NSString *ContactName;
    NSString *ProductDesc;
    
    ServiceManagementData *objServiceManagementData;
    
    BOOL Service_Task_Status;
    BOOL errStatus;
    
}

//Start Vivek Kumar - G
//Variable Declaring for Table Header

@property (nonatomic, retain)  UIView *headerView;
@property (nonatomic, retain)  UIColor *BorderColor;


@property (nonatomic, retain) UILabel *service_H_STS;
@property (nonatomic, retain) UILabel *service_H_StartDate;
@property (nonatomic, retain) UIButton *service_H_CustL;
@property (nonatomic, retain) UILabel *service_H_EstA;
@property (nonatomic, retain) UIButton *service_H_SerDoc;
@property (nonatomic, retain) UILabel *service_H_CName;
@property (nonatomic, retain) UILabel *service_H_PDesc;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) IBOutlet UIScrollView *Table_ScrollView;


@property(nonatomic) NSInteger rowIndex;
@property(nonatomic, retain) NSString *object_id;
@property (nonatomic, assign) BOOL priorityOrderByFlag;
@property (nonatomic, assign) BOOL dueDateOrderByFlag;
@property (nonatomic, assign) BOOL statusOrderByFlag;
@property (nonatomic, assign) BOOL subjectOrderByFlag;

@property (nonatomic, retain) IBOutlet UISearchBar *sBar;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, retain) NSMutableArray *dubArrayList;

@property (nonatomic, assign) BOOL searchHaldleFlagWhenBack;


-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay;
-(IBAction)orderingTask:(id)sender;
-(void) searchTableView;

-(UITableViewCell *)taskTableViewCellWithIdentifier:(NSString *)identifier;
-(UITableViewCell *)taskTableViewCellWithIdentifier_ipad:(NSString *)identifier;
-(void) movetoColleagueList;
-(void) gotoServiceDetailPage: (NSIndexPath *) indexPath;


//Start - Vivek Kumar G
//Header Action Buttons Function

-(UILabel*)Underline_ButtonTitle:(UIButton*)button;

-(void)Click_Cust_Location_HTB:(id)sender;
-(void)Click_Service_Doc_HTB:(id)sender;
-(void) createStatusButtonImage:(NSMutableDictionary *) _marray;

-(void)Header_Button_Click_Event_Service_Task:(id)sender;
-(void)Menu_ActionSheet_Sorting:(NSInteger)Index;



@end

