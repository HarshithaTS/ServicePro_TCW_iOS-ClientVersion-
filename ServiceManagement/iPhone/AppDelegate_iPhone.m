//
//  AppDelegate_iPhone.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "MainMenu.h"


/*--this header file for SOAP call--*/
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
//#import "Z_GSSMWFM_HNDL_EVNTRQST00.h"


#import "TouchXML.h"
#import "ServiceManagementData.h"

#import "Serviceorders.h"

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>

#import <sqlite3.h>
#import "CheckedNetwork.h"

#import "OpenUDID.h"
#import "iOSMacros.h"
#import <AdSupport/ASIdentifierManager.h>
#import "UIDevice+IdentifierAddition.h"

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize mainController;
@synthesize deviceMACID;
@synthesize GDID;
@synthesize AltGDID;

@synthesize activeApp;
@synthesize DidBecomeActive;
@synthesize ShowServiceUpdateDiagnosis;
@synthesize CallContext;
@synthesize FullSet;


@synthesize mErrorFlagSAP;

@synthesize service_url;
@synthesize buildName;
@synthesize imenoStr;
@synthesize diagnoseSwitchStatus;


@synthesize loadingImgView, actView;
@synthesize modifySearchWhenBackFalg;

@synthesize activeFaultSegmentIndexFlag;
@synthesize activitySparesEditedFlag;

@synthesize attachmentImage;
@synthesize localImageFilePath;

@synthesize localAttachedImagePath;

@synthesize pdfFileData;

@synthesize encryptedImageString;
@synthesize attachmentImageSO;
@synthesize localImageFilePathSO;
@synthesize encryptedImageStringSO;

@synthesize encryptedSignString;
@synthesize attachmentSign;
@synthesize localSignFilePath;
@synthesize signatureCaptured;

@synthesize imageAttached;
//colleague
@synthesize colleagueName;
@synthesize colleagueTelNo;
@synthesize colleagueTelNo2;
@synthesize colleagueAction;

@synthesize taskTranFrom;
@synthesize taskTranTo; 


@synthesize sapResponse, xmlDocument;

/*
@synthesize locationManager;
@synthesize currentLat;
@synthesize currentLon;
@synthesize locationDetectionFlag;
*/

#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	//self.currentLat = 0.00;
	//self.currentLon = 0.00;
	//self.locationDetectionFlag = TRUE;

	//Calling the function to get current location..
	//[self getCurrentLocation];
	
    [self readplistfile];
    
    self.activeApp = @"";
    self.DidBecomeActive = FALSE;
    self.ShowServiceUpdateDiagnosis = FALSE;
	 
   //Thompsoncreek link
     /* QA LINK
     //self.service_url =@"http://TCW-MAS02.ThompsonCreek.com:8200/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/200/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00_bndng";
     */
   /*PRODUCTION
     
    //self.service_url = @"http://TCW-MAS01.ThompsonCreek.com:8300/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/300/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00";
     */
    
    //create setting table
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    [objServiceManagementData createEditableCopyOfDatabaseIfNotThere:@"Settings.sqlite"];
    
    
    //Very first time update load context value to true
    //Updating Setting
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    objAppDelegate_iPHone.CallContext = TRUE;
    NSString *sqlQryStr = [NSString stringWithFormat:@"UPDATE TBL_SETTING SET loadContext = %d", 1];
    [objServiceManagementData excuteSqliteQryString:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];

    
    
    
    [self GetDeviceid];
    
 
    
    
   
//    self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO",[[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString]];
    
//    self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO",[[OpenUDID value] uppercaseString]];
    
    NSLog(@"Unique Device Identifier:\n%@",self.deviceMACID);
    
   // NSLog(@"DEVICE ID %@",DEVICE_TYPE);
    
    //Searching Task related variable, when back edit task to task list page
	modifySearchWhenBackFalg = FALSE;
	
	//calling the function for splash screen or welcome screen
	//[self splashScreen];
    
    
    //Old code [self GETCONTEXTDATA];
    
//   //CODE Changed to LOAD CONTEXT DATA in a Secondary thread - 06-03-2013
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_group_t context = dispatch_group_create();
//    dispatch_group_async(context, queue, ^{
//        
//        [self GETCONTEXTDATA];
//    });
//    
//    //END
    
   MainMenu *objMainMenu;
      
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        objMainMenu = [[[MainMenu alloc] initWithNibName:@"MainMenu_iPad" bundle:nil] autorelease];
    }
    else{
        objMainMenu = [[[MainMenu alloc] initWithNibName:@"MainMenu_iPad" bundle:nil] autorelease];
        
    }
    mainController = [[UINavigationController alloc] initWithRootViewController:objMainMenu];
	mainController.navigationBarHidden = YES;
//     [window setRootViewController:mainController];
	[window addSubview:mainController.view];
    [window makeKeyAndVisible];
    
	return YES;
}

-(void) GetDeviceid {
    
    //AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    NSString *diagMode=@"";
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM TBL_SETTING WHERE 1"];
    NSMutableArray *objSetting = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];
    NSLog(@"setting array %@", objSetting);
    
    self.diagnoseSwitchStatus = [[[objSetting objectAtIndex:0] objectForKey:@"diagnosepopup"] boolValue];
    self.CallContext= [[[objSetting objectAtIndex:0] objectForKey:@"loadContext"] boolValue];
    self.FullSet = [[[objSetting objectAtIndex:0] objectForKey:@"FullSet"] boolValue];
    
    
    //self.diagnoseSwitchStatus = [[[[objServiceManagementData fetchDataFrmSqlite:sqlQryStr :@"Settings.sqlite":@"SETTING" :1] objectAtIndex:0] objectForKey:@"diagnosepopup"] boolValue];
    //self.CallContext = [[[[objServiceManagementData fetchDataFrmSqlite:sqlQryStr :@"Settings.sqlite":@"SETTING" :1] objectAtIndex:0] objectForKey:@"loadContext"] boolValue];
    
    
    if (self.diagnoseSwitchStatus)
        diagMode = @"D";
    else
        diagMode = @"";
    
    
    
    
    if ([SYSTEM_VERSION floatValue] >= 7.0){
        
        self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO:DEVICE-ALTID:%@:MODE:%@",[[OpenUDID value] uppercaseString],[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString], diagMode];
        self.GDID = [[OpenUDID value] uppercaseString];
        self.AltGDID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    else
    {
        self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO:MODE:%@",[[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString],diagMode];
        self.GDID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString];
        self.AltGDID = @"N/A";
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
   
    
    if ([activeApp isEqualToString:@"ServiceOrders"]) {
        //self.DidBecomeActive= TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadServiceTaskData" object:nil];
    }
    
    if ([activeApp isEqualToString:@"ServiceOrderEdit"]) {
        self.DidBecomeActive= TRUE;
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    return YES;   
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

-(void) readplistfile {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Servicepro" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSLog(@"%@",dictionary);
    self.service_url = [dictionary objectForKey:@"SERVICEURL_PRD"];
//    self.service_url = [dictionary objectForKey:@"SERVICEURL_QA"];
    self.buildName = [dictionary objectForKey:@"BUILDNAME"];
    self.diagnoseSwitchStatus = [[dictionary objectForKey:@"DiagnosePopup"] boolValue];
    
}

/*--Below two commented functions for traking the current location--*/
/*
 -(void)getCurrentLocation
 {
 self.locationManager = [[CLLocationManager alloc] init];
 if([CLLocationManager locationServicesEnabled] == NO)
 {
 self.locationDetectionFlag = FALSE;
 }
 else
 {
 self.locationDetectionFlag = TRUE;
 
 [self.locationManager setDelegate:self];
 [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
 [self.locationManager startUpdatingLocation];
 }
 
 }*/


/*
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 
 CLLocationCoordinate2D loc = [newLocation coordinate];
 self.currentLat = loc.latitude;
 self.currentLon = loc.longitude;
 
 [self.locationManager stopUpdatingLocation];
 
 NSLog(@"Lat:%f , Long:%f", self.currentLat, self.currentLon);
 
 }
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
 {
 if([error code])
 {
 self.locationDetectionFlag = FALSE;
 [self.locationManager stopUpdatingLocation];
 }
 }
 */

/*

-(void) splashScreen
{
	UIViewController *splashView = [[UIViewController alloc] init];
	splashView.view.frame = CGRectMake(0, -15, 320, 480);
	
	UIImageView *splashImageView = [[UIImageView alloc] initWithFrame:splashView.view.bounds];
	[splashImageView setImage:[UIImage imageNamed:@"splash-bg.png"]];
	
	UIButton *skipSplashButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	skipSplashButton.frame = CGRectMake(60, 232, 200, 35);
	[skipSplashButton addTarget:self action:@selector(skipSplashMethod:) forControlEvents:UIControlEventTouchUpInside];
	//[skipSplashButton setImage:[UIImage imageNamed:@"skipSplash.png"] forState:UIControlStateNormal];
	[skipSplashButton setTitle:NSLocalizedString(@"AppDelegate_Skip_button_title",@"") forState:UIControlStateNormal];
	skipSplashButton.backgroundColor = [UIColor lightGrayColor];
	
	[splashView.view addSubview:splashImageView];
	[splashView.view addSubview:skipSplashButton];
	[splashImageView release], splashImageView = nil;
	
	
	//Calling main view controller...
	mainController = [[UINavigationController alloc] initWithRootViewController:splashView];	
	mainController.navigationBarHidden = YES;
	[window addSubview:mainController.view];
	[window makeKeyAndVisible];
	
}
 
 // GSS Link commented by selvan on 3march self.service_url = @"http://75.99.152.10:8050/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/110/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00";
 
 

*/



- (void)dealloc {
    [window release];
	[mainController release], mainController = nil;
    [super dealloc];
}


@end
