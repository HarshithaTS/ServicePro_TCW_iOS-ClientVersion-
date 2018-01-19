//
//  AppDelegate_iPad.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 27/07/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate_iPad.h"
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
@implementation AppDelegate_iPad

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
@synthesize encryptedImageString;
@synthesize attachmentImageSO;
@synthesize localImageFilePathSO;
@synthesize encryptedImageStringSO;

@synthesize encryptedSignString;
@synthesize attachmentSign;
@synthesize localSignFilePath;
@synthesize signatureCaptured;

//colleague
@synthesize colleagueName;
@synthesize colleagueTelNo;
@synthesize colleagueTelNo2;
@synthesize colleagueAction;

@synthesize taskTranFrom;
@synthesize taskTranTo;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	
    //self.currentLat = 0.00;
	//self.currentLon = 0.00;
	//self.locationDetectionFlag = TRUE;
	
	
	//Calling the function to get current location..
	//[self getCurrentLocation];
	
    
    
    //Thompsoncreek link
   /* old self.service_url =@"http://TCW-MAS02.ThompsonCreek.com:8200/sap/bc/srt/rfc/sap/z_gssmwfm_hndl_evntrqst00/200/z_gssmwfm_hndl_evntrqst00/z_gssmwfm_hndl_evntrqst00_bndng";
    
    
   //self.service_url = @"http://TCW-MAS01.ThompsonCreek.com:8300/sap/bc/srt/wsdl/srvc_005056B400121ED2ACAFF767BCD0D531/wsdl11/allinone/ws_policy/document?sap-client=300";
    */
    //Searching Task related variable, when back edit task to task list page
	modifySearchWhenBackFalg = FALSE;
	
	//calling the function for splash screen or welcome screen
	//[self splashScreen];
    
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
    [objMainMenu release];
	return YES;

    //[window makeKeyAndVisible];
	
	//return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
