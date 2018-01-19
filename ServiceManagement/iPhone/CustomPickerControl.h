
//This the common picker custom view class.

#import <UIKit/UIKit.h>


@interface CustomPickerControl : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
	UIToolbar* pickerToolbar;
	UIActionSheet* pickerViewActionSheet;
	UITableView *sourceTableView;
	
	UIPickerView *pickerView;
	NSString *pickerValue;
	
	NSString *differenciatePickerName;
	
	NSMutableArray *resultArray;
	id controllerName;

    //**Biren Changes on 01/02/2013****************
    UIPopoverController *popover;
    
    
    //****************************End*****************
    
    
    
}

@property (nonatomic, retain) id controllerName;

@property (nonatomic, retain) UIToolbar* pickerToolbar;
@property (nonatomic, retain) UIActionSheet* pickerViewActionSheet;
@property (nonatomic, retain) UITableView *sourceTableView;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSString *pickerValue;
@property (nonatomic, retain) NSString *differenciatePickerName;

@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;

@property (nonatomic, retain) NSMutableArray *resultArray;

-(void)openPickerView:(UITableView*)sender classObjectName:(id)classObjSender pickerArray:(NSMutableArray*)array PickerName:(NSString*)tempPickerName;
-(BOOL)closeCustomPicker:(id)sender;
-(void) pickPickerValue;
-(NSString *) searchTextInArray:(NSString *) mpickerValue:(NSMutableArray*)array:(NSInteger)option;
//**Biren Changes on 01/02/2013****************

-(void)openPickerView:(UITableView*)sender classObjectName:(id)classObjSender pickerArray:(NSMutableArray*)array PickerName:(NSString*)tempPickerName uiElement:(CGRect)dropDown tableCell:(UITableViewCell *)cell;

//****************************End*****************


@end
