//
//  ServiceOrderEdit.h
//  ServiceManagement
//
//  Created by Selvan Chellam on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "TableCellView.h"
#import "EstimatedArrival.h"
#import <MessageUI/MessageUI.h>


@class ServiceManagementData;
@class EstimatedArrival;
@class AppDelegate_iPhone;

@interface ServiceOrderEdit : UIViewController <UITableViewDelegate,UITableViewDataSource,  UIAlertViewDelegate, UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,EstimatedArrivalDelegate, NSObject,MFMailComposeViewControllerDelegate>{
	id _textField;
    NSString *object_id;
    NSInteger rowIndex;
    int currentRcd;
	//Taken table view from XIB..
	IBOutlet UITableView *myTableView;
	IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIView *iPadView;
    //UIScroll View
    IBOutlet UIScrollView *Service_Task_SV;
    
    
	//Variables to display to the text..
	UITextView  *detailsTask;
    UITextView *taskNotes;
	UITextField *taskCategory;
	UITextView *displayTask;
    UITextField *txtField;
    UITextField *contract_value;
    UIButton *but;
    UILabel *commonLabel;
	
	//Holding the response message array...
	NSMutableArray *updateResponseMsgArray;
	
	//Task update flag....
	BOOL updateSucessFlag;
    BOOL ETAPopupShowFlag;
	
	UIAlertView *alert;
    UIView *etaView;
    UILabel *rgtLabel;
    UIButton *butETAValue;
    UIButton *canButton;
    UIButton *savButton;
    UIButton *etaTitle;
    
    UITextField *txtStatus;
    UITextField *txtTimeZone;
    UITextField *txtReason;
    
    UITextField *txtResult;
    UITextField *txtResultValue;
    
    NSMutableArray *serviceOrderEditArray;
    
    IBOutlet TableCellView *tblCell;
    
    IBOutlet UIView *modalView;
   
    
    UIButton *butPrevv;
    UIButton *butNextt;
    //************************************************************************************************
    //Image capture declaration code start
    //************************************************************************************************
    UIView *imagePickerView;
    UIImageView *imageView;
    UIImage *image;
    UIImagePickerController *imagePicker;
    NSString *localSmallFilepathStr;
    NSString *encodedImageStr;
    //************************************************************************************************
    //Image capture declaration code end
    //************************************************************************************************
    
    //ServiceManagementData *objServiceManagementData;
    AppDelegate_iPhone *delegate;
    
    int service_count;
    int array_total_count;
    
    NSString *TaskStatus;
    
    BOOL ChkPopUpMenu;
    BOOL errStatus;
    
    NSMutableArray *TableTitle;
    NSMutableArray *TableData;
    
    EstimatedArrival *estimatedArrival;
    
    UIImage *Sig_Image;
    NSString *Sig_FilePath;
    
    //********picker control
    UIToolbar* pickerToolbar;
	UIActionSheet* pickerViewActionSheet;
	UIPickerView *pickerView;
	NSString *pickerValue;

    
    CGRect cellbound;
    UITableViewCell *mCell;
    
    
    UIView *diagPopupView;

}

@property (nonatomic, retain) NSMutableArray *serviceOrderEditArray;

@property(nonatomic, retain) NSString *object_id;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIView *iPadView;

@property (nonatomic,retain) IBOutlet UIScrollView *Service_Task_SV;


@property(nonatomic) NSInteger rowIndex;
@property (nonatomic, retain) UITextView *detailsTask;
@property (nonatomic, retain) UITextView *taskReason;
@property (nonatomic, retain) UITextView *taskNotes;
@property (nonatomic, retain) UITextField *taskCategory;
@property (nonatomic, retain) UITextView *displayTask;

@property (nonatomic, retain) UITextField *contract_value;


@property (nonatomic, retain) UITextField *txtResult;
@property (nonatomic, retain) UITextField *txtResultValue;


//@property (nonatomic, retain ) UILabel *commonLabel;
@property (nonatomic, retain) NSMutableArray *updateResponseMsgArray;

@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIView *etaView;


@property (nonatomic, retain) UILabel *rgtLabel;
@property (nonatomic, retain) UIButton *butETAValue;
@property (nonatomic, retain) UIButton *canButton;
@property (nonatomic, retain) UIButton *savButton;
@property (nonatomic, retain) UIButton *etaTitle;

@property (nonatomic, retain) UITextField *txtStatus;
@property (nonatomic, retain) UITextField *txtTimeZone;


@property (assign) BOOL errStatus;

-(void) saveData:(UITextField*)textfield ;
-(void) SaveTask;
//-(BOOL)updatetaskInSAPServer:(NSMutableArray *)sapRequestArray;

//-(void)cancelDefaultAlertAndCallSAPUpdate;
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue;
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType;
-(IBAction)cancelButtonClicked:(id)sender;
-(IBAction) saveButtonClicked:(id)sender;
-(IBAction) butETAValueClicked:(id)sender;
-(IBAction)attachSignBtnClicked:(id)sender;

//************************************************************************************************
//Image capture declaration code start
//************************************************************************************************
@property (nonatomic, retain) NSString *localSmallFilepathStr;
@property (nonatomic, retain) NSString *encodedImageStr;
@property (nonatomic, retain) UIImageView *imageView;

-(void)cameraBtnClicked;
-(IBAction)attachBtnServerClicked:(id)sender;
-(IBAction)attachBtnClicked:(id)sender;
-(IBAction)attachSignBtnClicked:(id)sender;
-(IBAction)partnerBtnClicked:(id)sender;
-(NSString *) filePath: (NSString *) fileName;
-(void) saveImage;
-(UIImage*)scaledImageForImage:(UIImage*)image newSize:(CGSize)newSize;
-(IBAction)attachBtnClicked:(id)sender;
- (void)navigateToRouteView;

//************************************************************************************************
//Image capture declaration code end
//**************************************************************************************************
//***********picker
@property (nonatomic, retain) UIToolbar* pickerToolbar;
@property (nonatomic, retain) UIActionSheet* pickerViewActionSheet;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSString *pickerValue;
//**********picker


-(void)loadNoteView;
-(IBAction)loadEditDatatoDic:(id)sender;

- (NSString *) filePath: (NSString *) fileName;
-(void)RemoveNullFeildsFromTable;
-(UITextView *)DisplayTextView:(UITextView *)DtextView;

-(void)ImageCheckingInDocFolder;
-(void) updateServiceOrder;

-(void) dailNumber2;
-(void) dailNumber1;

-(void)setViewMovedUp:(BOOL)movedUp;
- (void)keyboardWillShow:(NSNotification *)notif;

-(UIView *)createDetailContent;
-(void) loadToolBarItems;
-(void) getTaskEditData;
-(void) populateTaskDataDic;
-(BOOL) checkServerAttachment;
-(BOOL) checkServiceOrderPartner;


-(IBAction)sendDiagnoseEmail;
-(IBAction)diagnose:(id)sender;
-(void) showDiagnosisPopup;


@end
