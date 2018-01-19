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

/*This header file is needed for rendering the, image, textfiled, textview like that*/
#import <QuartzCore/QuartzCore.h>

#import <sqlite3.h>
#import "CheckedNetwork.h"

#import "UIDevice+IdentifierAddition.h"

#import "OpenUDID.h"
#import "iOSMacros.h"


@implementation AppDelegate_iPhone

@synthesize window;
@synthesize mainController;
@synthesize deviceMACID;
@synthesize mErrorFlagSAP;

@synthesize service_url;
@synthesize imenoStr;

@synthesize loadingImgView, actView;
@synthesize modifySearchWhenBackFalg;

@synthesize activeFaultSegmentIndexFlag;
@synthesize activitySparesEditedFlag;

@synthesize attachmentImage;
@synthesize localImageFilePath;

@synthesize localAttachedImagePath;

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


/*
@synthesize locationManager;
@synthesize currentLat;
@synthesize currentLon;
@synthesize locationDetectionFlag;
*/

#pragma mark -
#pragma mark Application lifecycle



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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	//self.currentLat = 0.00;
	//self.currentLon = 0.00;
	//self.locationDetectionFlag = TRUE;
	
	
	//Calling the function to get current location..
	//[self getCurrentLocation];
	

	 
   //Thompsoncreek link
    self.service_url =@"http://TCW-MAS02.ThompsonCreek.com:8200/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/200/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00_bndng";
    
 
   
    //NSString* openUDID = [OpenUDID value];
    //NSLog(@"UDID: %@", openUDID);
    
    
    self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO",[[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString]];
    
    //self.deviceMACID = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO",[[OpenUDID value] uppercaseString]];
    
    NSLog(@"Unique Device Identifier:\n%@",self.deviceMACID);
    
   // NSLog(@"DEVICE ID %@",DEVICE_TYPE);
    
    //Searching Task related variable, when back edit task to task list page
	modifySearchWhenBackFalg = FALSE;
	
	//calling the function for splash screen or welcome screen
	//[self splashScreen];
        
    
    [self GETCONTEXTDATA];
    
    
   MainMenu *objMainMenu;
      
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        objMainMenu = [[MainMenu alloc] initWithNibName:@"MainMenu_iPad" bundle:nil];
    }
    else{
        objMainMenu = [[MainMenu alloc] initWithNibName:@"MainMenu" bundle:nil];
        
    }
    mainController = [[UINavigationController alloc] initWithRootViewController:objMainMenu];
	mainController.navigationBarHidden = YES;
	[window addSubview:mainController.view];
	[window makeKeyAndVisible];
       
	return YES;
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


-(void) GETCONTEXTDATA{
    NSString *responseValue;
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
 
    
    //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
    
    //Delete if any Declined SO in service order table
    //NSString *soDltQry = [NSString stringWithFormat:
    //                     @"DELETE FROM ZGSXCAST_STTS10 WHERE 1"];
    
    //[objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.gssSystemDB :@"DELETE ALL STATUS":0];
    
    
    responseValue = [CheckedNetwork getResponseFromSAP:nil :@"SERVICE-DOX-CONTEXT-DATA-GET":objServiceManagementData.gssSystemDB:99:@"GETDATA"];
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
 
    //Get status description from status master
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT TXT30 FROM ZGSXCAST_STTS10 WHERE 1"];
    objServiceManagementData.taskStatusTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :1];
    
   // NSLog(@"status aarray %@", objServiceManagementData.taskStatusTxtArray);
    
    
//    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE 1"];
//    objServiceManagementData.taskStatusMaster = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :1];
//    
//    NSLog(@"status map aarray %@", objServiceManagementData.taskStatusMaster);
//    
//   // NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
//    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
//    for (int i=0; i<= [objServiceManagementData.taskStatusMaster count]-1; i++) {
//        
//        //[tempDic setObject:[[objServiceManagementData.taskStatusMaster objectAtIndex:i] objectForKey:@"TXT30"] forKey:[[objServiceManagementData.taskStatusMaster objectAtIndex:i] objectForKey:@"STATUS"]];
//        
//        [tempArr addObject:[[objServiceManagementData.taskStatusMaster objectAtIndex:i] objectForKey:@"TXT30"]];
//        
//    }
//    //[objServiceManagementData.taskStatusMappingArray removeAllObjects];
//    //[objServiceManagementData.taskStatusMappingArray addObject:tempDic];
//    
//    [objServiceManagementData.taskStatusTxtArray removeAllObjects];
//    objServiceManagementData.taskStatusTxtArray = tempArr;
//    
//    
//    //[tempDic release],tempDic =nil;
//    [tempArr release],tempArr = nil;
//    
//    NSLog(@"status aarray %@", objServiceManagementData.taskStatusTxtArray);
    
    
      
}
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
