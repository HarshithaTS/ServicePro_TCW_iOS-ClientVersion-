//
//  ServiceConfCreation.h
//  ServiceManagement
//
//  Created by gss on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceConfCreation : UIViewController <UITableViewDelegate, UITextViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
	UIView *myView;
	UITableView *myTableView;
    
    IBOutlet UIToolbar *toolbarActivity;
    IBOutlet UIToolbar *toolbarSpares;
	IBOutlet UIToolbar *toolbar;
	UIView *activityView,*faultView,*SparesView,*imagePickerView,*headerView1,*headerView2;
	UITableView *activityTable,*faultTable,*sparesTable; 
	UITextView *displayServiceOrder,*displayActivity;
    UILabel *lblHeader1,*lblHeader2,*lblHeader3,*lblHeader4;
	UIButton *submitButton;
	UIButton *addButton;
    UIButton *imageButton;
    UIButton *imageScanButton;
	UIButton *addMaterialButton;
    UIButton *attachButton;
    UIButton *attachSignButton;
    int segmentIndex;
	int rowSelected;
	//Holding the response message array...
	NSMutableArray *updateResponseMsgArray;
	NSMutableArray *faultDataArray;
	//Task update flag....
	BOOL updateSucessFlag;
	NSMutableDictionary *checkBoxValueDictionary;
    NSMutableDictionary *checkBoxDictionary;
	UISegmentedControl *segmentedControl;
	UIAlertView *alert;
	NSString *DeleteQuery;
    
    //--for image capture
    UIImageView *imageView;
    UIImagePickerController *imagePicker;
    NSString *localSmallFilepathStr;
    NSString *encodedImageStr;
    
    UIView *pickerDisplayView;
    
    
    //Vivek Kumar - Start 
    
    
    UIButton *SegB1;
     UIButton *SegB2;
     UIButton *SegB3;
     UIButton *SegB4;
    
    int flag;
    
    //Vivek Kumar - End 
    

	
}
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSString *DeleteQuery;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbarActivity;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbarSpares;

@property (nonatomic, retain) UIView *myView;
@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) UITableView *activityTable;
@property (nonatomic, retain) UITableView *faultTable;
@property (nonatomic, retain) UITableView *sparesTable;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain)  UIButton *imageScanButton;
@property (nonatomic, retain) UIButton *attachButton;
@property (nonatomic, retain) UIButton *attachSignButton;
@property (nonatomic, retain) UIButton *addMaterialButton;

@property (nonatomic, retain) NSMutableArray *faultDataArray;
@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;
@property (nonatomic, assign) BOOL updateSucessFlag;

@property (nonatomic, retain) NSMutableDictionary *checkBoxValueDictionary;
@property (nonatomic, retain) NSMutableDictionary *checkBoxDictionary;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIAlertView *alert;

@property (nonatomic, retain) NSString *localSmallFilepathStr;
@property (nonatomic, retain) NSString *encodedImageStr;
//--image capture
@property (nonatomic, retain) UIImageView *imageView;

-(void) createActivityView;
-(void) createFaultView;
-(void) createSparesView;
-(void)createSegmentControl;
-(CGRect) customViewFrameWithSize;
-(void) submitButtonClicked: (id)sender;
//-(BOOL)updatetaskInSAPServer:(NSString *)strPar5:(NSString *)strPar6:(NSString *)strPar7:(NSString *)strPar8;
-(BOOL)updatetaskInSAPServer:(NSMutableArray *)sapRequestArray;
-(void)CallSAPUpdate;
-(void)segmentAction:(id)sender;

-(void) newMaterialButtonClicked: (NSInteger) option;
-(void) newButtonClicked:(NSInteger)option;
//-(void) newMaterialButtonClicked: (id)sender;
//-(void) newButtonClicked: (id)sender;



-(IBAction)ActivityeditButtonClicked: (id) sender;
-(IBAction)ActivitydeleteButtonClicked: (id) sender;
-(IBAction)ActivityeditCheckButtonClicked: (id) sender;
-(IBAction)FaulteditButtonClicked: (id) sender;
-(IBAction)FaultDeleteButtonClicked: (id) sender;
-(IBAction)SparesEditButtonClicked: (id) sender;
-(IBAction)SparesDeleteButtonClicked: (id) sender;
-(UITableViewCell *)activityTableViewCellWithIdentifier:(NSString *)identifier;
-(UITableViewCell *)faultTableViewCellWithIdentifier:(NSString *)identifier;
-(UITableViewCell *)sparesTableViewCellWithIdentifier:(NSString *)identifier;
-(void) goBack;
-(void) doMenu;
//--------------------------------------------
-(void)cameraBtnClicked;
//-(IBAction)cameraBtnClicked:(id)sender;
-(IBAction)attachBtnClicked:(id)sender;
-(IBAction)attachSignBtnClicked:(id)sender;
- (NSString *) filePath: (NSString *) fileName;
- (void) saveImage;
- (UIImage*)scaledImageForImage:(UIImage*)image newSize:(CGSize)newSize;
//--------------------------------------------
-(void) scanBtnClicked;
//-(void) scanBtnClicked:(id)sender;


//Vivek Kumar - Start 

// creating the button 
-(void) createButtonControl;


-(IBAction)SegButton1:(id)sender;
-(IBAction)SegButton2:(id)sender;
-(IBAction)SegButton3:(id)sender;
-(IBAction)SegButton4:(id)sender;


//Vivek Kumar - End 


@end
