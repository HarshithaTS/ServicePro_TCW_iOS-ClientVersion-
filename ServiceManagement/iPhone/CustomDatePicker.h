//
//This is custom date picker calss
//Just call the sepcified functions with sepcified prameters...
//

#import <UIKit/UIKit.h>

@interface NSDateFormatter (Locale)

- (id)initWithSafeLocale;

@end

@interface CustomDatePicker : UIViewController <UIActionSheetDelegate> {
	UIDatePicker *theDatePicker;
	UIToolbar* pickerToolbar;
	UIActionSheet* pickerViewDate;
	
	UITableView *sourceTableView;
	NSString *className;

    //**Biren Changes on 01/02/2013****************
    
    UIPopoverController *popover;
    
    //****************************End*****************
    
    
}

@property (nonatomic, retain) UIDatePicker *theDatePicker;
@property (nonatomic, retain) UIToolbar* pickerToolbar;
@property (nonatomic, retain) UIActionSheet* pickerViewDate;

@property (nonatomic, retain) UITableView *sourceTableView;

@property (nonatomic, retain) NSString *className;

//***************Biren Changes on 01/02/2013****************



//****************************End*****************



-(void)datePickerView:(UITableView*)sender :(NSString*)identifire;
-(void)dateChanged;

//**************Biren Changes on 01/02/2013****************
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown tableCell:(UITableViewCell *)cell:(NSString*)displaytext;
-(void)datePickerView:(UITableView*)sender :(NSString*)identifire uiElement:(CGRect)dropDown myView:(UIView *)cell;
//****************************End*****************

@end