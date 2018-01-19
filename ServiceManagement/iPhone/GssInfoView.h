//
//  GssInfoView.h
//  ServiceManagement
//
//  Created by Selvan Chellam on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface GssInfoView : UIViewController<MFMailComposeViewControllerDelegate>

{
    
    IBOutlet UILabel *deviceId;
    IBOutlet UILabel *altDeviceId;
    IBOutlet UILabel *systemVersion;
    IBOutlet UILabel *server;
    IBOutlet UIButton *btnMail;
    NSString *edition;
    NSString *suppVersion;
    
    
    IBOutlet UIButton *butDiagnose;
    IBOutlet UIButton *butSettings;
    
    UIView *diagPopupView;
}

@property(nonatomic, retain) IBOutlet UILabel *deviceId;
@property (nonatomic, retain) IBOutlet UILabel *altDeviceId;
@property(nonatomic, retain) IBOutlet UILabel *systemVersion;


-(IBAction)gotoBack:(id)sender;
-(IBAction)openMail:(id)sender;
-(IBAction)diagnose:(id)sender;
-(IBAction)Settings:(id)sender;

-(NSString *) GetCurrentTimeStamp;
@end
