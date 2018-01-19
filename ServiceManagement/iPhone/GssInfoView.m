//
//  GssInfoView.m
//  ServiceManagement
//
//  Created by Selvan Chellam on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GssInfoView.h"
#import "MainMenu.h"
#import "AppDelegate_iPhone.h"
#import "UIDevice+IdentifierAddition.h"
#import "OpenUDID.h"
#import "iOSMacros.h"

#import "GssSettingViewController.h"
#import "ServiceManagementData.h"
#import "CheckedNetwork.h"

#import "CustomAlertView.h"
CustomAlertView *customAlt;

@implementation GssInfoView

@synthesize deviceId,altDeviceId, systemVersion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    
    systemVersion.text = [[UIDevice currentDevice]systemVersion];
    
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        
    NSRange endRange = [objAppDelegate_iPHone.service_url rangeOfString:@".com"];
    NSRange searchRange = NSMakeRange(8, endRange.location-4);
    NSString *rstString = [objAppDelegate_iPHone.service_url substringWithRange:searchRange];
  
//    if ([SYSTEM_VERSION floatValue] >= 7.0)
//        deviceId.text =[[OpenUDID value] uppercaseString];
//    else
//        deviceId.text = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString];
    
    deviceId.text = objAppDelegate_iPHone.GDID;
    altDeviceId.text = objAppDelegate_iPHone.AltGDID;
    
    server.text = rstString;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack:)];
    if ([SYSTEM_VERSION floatValue] >= 7.0)
    barBackButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = barBackButton;
    [barBackButton release],barBackButton = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Servicepro" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSLog(@"%@",dictionary);
    edition = [dictionary objectForKey:@"Edition"];
    //    self.service_url = [dictionary objectForKey:@"SERVICEURL_QA"];
    suppVersion = [dictionary objectForKey:@"Version"];

    
}
-(IBAction)gotoBack:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

-(IBAction)Settings:(id)sender {
    
    GssSettingViewController *objGssSettingViewController;
    if (IS_IPHONE) {
        objGssSettingViewController = [[[GssSettingViewController alloc] initWithNibName:@"GssSettingViewController" bundle:[NSBundle mainBundle]] autorelease];
    }
    else {
        objGssSettingViewController = [[[GssSettingViewController alloc] initWithNibName:@"GssSettingViewController" bundle:[NSBundle mainBundle]] autorelease];
    }
    [self.navigationController pushViewController:objGssSettingViewController animated:YES];
    

    
}

-(NSString *) GetCurrentTimeStamp {
    //Find Device Date and Time
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd HHmmss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    
    NSLog(@"Date String %@", dateString);
    
    return dateString;
    //End
}


-(IBAction)diagnose:(id)sender{
    
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    [objServiceManagementData.diagonseArray removeAllObjects];
    
    
    customAlt = [[CustomAlertView alloc] init];
    
    
    //APTURE DEVICE START TIME
    [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"START-OF-PROCESSING DEVICE %@",[self GetCurrentTimeStamp]]];

    //ADD EVENT TITLE
    [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-FOR-EVENT DIAGNOSIS-AND-CHECKST"]];
    
    //CAPTURE API START TIME
    [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-BEGIN-TIME DEVICE %@",[self GetCurrentTimeStamp]]];

    
    dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Concurrent_Queue_High,^{
        
        

        dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
            //Show processing Alert to User
            self.view.userInteractionEnabled = FALSE;
            self.navigationItem.leftBarButtonItem.enabled = FALSE;
            float _screenWidth = self.view.frame.size.width;
            float _screenHieght = self.view.frame.size.height;
            
            if (IS_IPAD) {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
            else {
                [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Loading_View",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
            }
        });
        
        
        NSString *responseValue;
        //Add Input Strings into nsmutablearray
        NSMutableArray *getInputArray = [[NSMutableArray alloc] init];
        //getInputArray = [[NSMutableArray alloc] init];
        [getInputArray addObject:[NSString stringWithFormat:@"%@",[self GetCurrentTimeStamp]]];
        
        
        
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        responseValue = [CheckedNetwork getResponseFromSAP:getInputArray :@"DIAGNOSIS-AND-CHECKS":objServiceManagementData.serviceReportsDB:99:@"GETDATA"];
    
        
        dispatch_group_async(objServiceManagementData.Task_Group, objServiceManagementData.Main_Queue, ^{
            //Stop Active Indicator
            [customAlt removeAlertForView];
            [customAlt release],customAlt=nil;
            self.view.userInteractionEnabled = TRUE;
            self.navigationItem.leftBarButtonItem.enabled =  TRUE;
            
            if ( ![responseValue isEqualToString:@"555-Success"] && ![responseValue isEqualToString:@""] ){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                                      message:responseValue
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYYMMddHHmmss"];
                
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                
                [formatter release];  // maybe; you might want to keep the formatter
                // if you're doing this a lot.
                
                
                [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"API-END-TIME DEVICE %@",dateString]];
                [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"STOP-PROCESSING DEVICE %@",[self GetCurrentTimeStamp]]];

                if ([objServiceManagementData.diagonseArray count] >  0) {
                    NSLog(@"SAP Response Time %@", objServiceManagementData.diagonseArray);
                    
                    diagPopupView = [[UIView alloc] initWithFrame:CGRectMake(135, 475, 500, 200)];
                    //[diagPopupView setBackgroundColor:[UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0]];
                    [diagPopupView setBackgroundColor:[UIColor whiteColor]];
                    diagPopupView.layer.borderColor = [UIColor blackColor].CGColor;
                    diagPopupView.layer.borderWidth = 1.0f;
                    [self.view addSubview:diagPopupView];
                    
                    NSString *emailBodyStr = @"";
                    
                    for (NSString *diagnoseStrng in objServiceManagementData.diagonseArray) {
                        
                        emailBodyStr =  [NSString stringWithFormat:@"%@  \n%@",emailBodyStr, diagnoseStrng];
                        
                    }
                    
                    NSLog(@"Email Body String %@", emailBodyStr);
                    UILabel *headerBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, 400, 25)];
                    headerBarTitle.text =@"Gss Mobile Diagnosis & Checks";
                    
                    //100-149-237
                    UIView *headerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 30)];
                    [headerBar setBackgroundColor:[UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0]];
                    [diagPopupView addSubview:headerBar];
                    
                    [headerBar addSubview:headerBarTitle];
                    
                    UITextView *diagTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 32, 442, 132)];
                    [diagTextView setBackgroundColor:[UIColor whiteColor]];
                    diagTextView.text = emailBodyStr;
                    [diagPopupView addSubview:diagTextView];
                    [diagTextView release], diagTextView = nil;
                    
                    //Create Done button to cloase popup
                    UIButton *butDiagDone = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
                    butDiagDone.frame = CGRectMake(444.0, 2.0, 50.0, 20.0);
                    [butDiagDone setTitle:@"Done" forState:UIControlStateNormal];
                    butDiagDone.backgroundColor = [UIColor clearColor];
                    [butDiagDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [butDiagDone addTarget:self action:@selector(DiagPopupDone) forControlEvents:UIControlEventTouchDown];
                    [headerBar addSubview:butDiagDone];
                    [butDiagDone release], butDiagDone = nil;
                    
                    
                    //create email button to send email
                    //Create Done button to cloase popup
                    UIButton *butDiagEmail = [[UIButton alloc] initWithFrame:CGRectMake(435, 120, 60, 60)];
                    //[butDiagEmail setTitle:@"Email" forState:UIControlStateNormal];
                    [butDiagEmail setBackgroundImage:[UIImage imageNamed:@"sendemail1.jpeg"] forState:UIControlStateNormal];
                    [butDiagEmail addTarget:self action:@selector(sendDiagnoseEmail) forControlEvents:UIControlEventTouchDown];
                    [diagPopupView addSubview:butDiagEmail];
                    [butDiagEmail release], butDiagEmail = nil;
                    
                    [headerBarTitle release], headerBarTitle = nil;
                    [headerBar release], headerBar = nil;
                    // [self openMail];
                }

            }
            
         
            
        });
        
    });
}



-(void)DiagPopupDone {
    
    [diagPopupView removeFromSuperview];
}

- (void)sendDiagnoseEmail
{
    ServiceManagementData * objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSRange endRange = [delegate.service_url rangeOfString:@".com"];
    NSRange searchRange = NSMakeRange(8, endRange.location-4);
    NSString *rstString = [delegate.service_url substringWithRange:searchRange];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Gss Mobile Diagnosis & Checks"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"Gss.Mobile@globalsoft-solutions.com", nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody;
        
        emailBody = [NSString stringWithFormat:@"\nBuild Name: %@ \n GDID: %@ \n Alt.GDID: %@ \n iOS Version: %@ \n Server: %@", delegate.buildName,delegate.GDID,delegate.AltGDID,[[UIDevice currentDevice]systemVersion],rstString];
        
        emailBody = [NSString stringWithFormat:@"%@ \n\nAPI Diagnosis Report:",emailBody];
       
        
        if ([objServiceManagementData.diagonseArray count]>0) {
            
            for (NSString *diagnoseStrng in objServiceManagementData.diagonseArray) {
                emailBody =  [NSString stringWithFormat:@"%@ \n%@",emailBody, diagnoseStrng];
                
                NSLog(@"Email body string %@", emailBody);
            }
            
            
        }
        
        
        [mailer setMessageBody:emailBody isHTML:NO];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)openMail:(id)sender
{
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"A Message from TCW Servicepro User"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"Gss.Mobile@globalsoft-solutions.com", nil];
        [mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        //NSString *emailBody = @"Have you seen the MobileTuts+ web site?";
        /*NSString *emailBody =[NSString stringWithFormat: @"<html><body><table><tr><td>Edition: iOS 5.1,6.1</td></tr><tr><td>Version: 2.4</td></tr><tr><td>Integrated with:SAP CRM 7.0 SAP ECC 6.0</td></tr><tr><td>GDID:%@</td></tr><tr><td></td></tr><tr><td>iOS Version:%@</td></tr></table></body></html>",[[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString],[[UIDevice currentDevice]systemVersion]];*/
        
        
        NSString *emailBody = [NSString stringWithFormat:@"My device information: \n\nBuild Name: %@ \n\nEdition: %@ \n Version:%@ \n GDID: %@ \n Alt.GDID: %@ \n iOS Version: %@ \n Server: %@", objAppDelegate_iPHone.buildName,edition, suppVersion,deviceId.text,altDeviceId.text,systemVersion.text,server.text];
                
        
        [mailer setMessageBody:emailBody isHTML:NO];
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:nil];
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
