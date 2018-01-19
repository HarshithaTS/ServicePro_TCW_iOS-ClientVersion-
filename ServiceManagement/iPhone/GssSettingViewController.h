//
//  GssSettingViewController.h
//  ServicePro
//
//  Created by GSS Mysore on 3/28/14.
//
//

#import <UIKit/UIKit.h>

@interface GssSettingViewController : UIViewController
{
    IBOutlet UISwitch *DiagnoseSwitch;

}

-(IBAction)gotoBack:(id)sender;
-(IBAction)DiagnoseSwith:(id)sender;
-(void) DisablePopup;
-(void) RememberDianosePopupShow:(int) popupStatus;

@end
