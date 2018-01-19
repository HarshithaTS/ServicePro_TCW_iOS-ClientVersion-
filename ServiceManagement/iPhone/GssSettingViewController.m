//
//  GssSettingViewController.m
//  ServicePro
//
//  Created by GSS Mysore on 3/28/14.
//
//

#import "GssSettingViewController.h"
#import "iOSMacros.h"
#import  "AppDelegate_iPhone.h"
#import "ServiceManagementData.h"


@interface GssSettingViewController ()

@end

@implementation GssSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBarHidden = NO;
	self.title = NSLocalizedString(@"Setting_Page",@"");

  
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack:)];
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        barBackButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = barBackButton;
    [barBackButton release],barBackButton = nil;
    
    
    //Get Diagnose value from plist and set it for switch
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    [DiagnoseSwitch setOn:objAppDelegate_iPHone.diagnoseSwitchStatus animated:YES];
    
    

}

-(IBAction)gotoBack:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(IBAction)DiagnoseSwith:(id)sender{
    if ([sender isOn]) {
        [self RememberDianosePopupShow:1];
    }
    else
        [self RememberDianosePopupShow:0];
    
    
}

-(void) RememberDianosePopupShow:(int) popupStatus {
    //Update Diagnose Status
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"Servicepro" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    [dictionary setValue:[NSNumber numberWithBool:popupStatus] forKey:@"DiagnosePopup"];
    [dictionary writeToFile:path atomically:YES];*/
    
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    objAppDelegate_iPHone.diagnoseSwitchStatus = popupStatus;
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"UPDATE TBL_SETTING SET diagnosepopup = %d", popupStatus];
    [objServiceManagementData excuteSqliteQryString:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];

    

    NSLog(@"Diag Status %hhd", objAppDelegate_iPHone.diagnoseSwitchStatus);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
