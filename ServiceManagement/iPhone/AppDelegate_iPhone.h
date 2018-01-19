//
//  AppDelegate_iPhone.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 11/07/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <corelocation/CLLocationManagerDelegate.h>

#import "TouchXML.h"
#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, CLLocationManagerDelegate,UINavigationControllerDelegate,NSXMLParserDelegate> {
    UIWindow *window;
	UINavigationController *mainController;
    NSString *deviceMACID;
    NSString *GDID;
    

    
    
    //SAP Server response error flag;
    BOOL mErrorFlagSAP;
    
	
	//service url which is needed when calling SAP 
	NSString *service_url;
    NSString *buildName;
    
    NSString *imenoStr;
	
	//these valiables are needed when donwloading data's from SAP, to show the users some activity is happening...
	UIImageView *loadingImgView;
	UIActivityIndicatorView *actView;
	
	/*--Below commented code is for tracking the current location */
	//CLLocationManager *locationManager;
	//double currentLat;
	//double currentLon;
	//BOOL locationDetectionFlag;
	
	
	
	//Searching Task related variable, when back edit task to task list page
	BOOL modifySearchWhenBackFalg;
	NSInteger activeFaultSegmentIndexFlag;
	BOOL activitySparesEditedFlag;
    
    
    //Confirmation Image Local Storage Path
    NSString *localImageFilePath;
    UIImage *attachmentImage;
    NSString *encryptedImageString;
    
    //SO Edit Image Local Storage Path
    NSString *localImageFilePathSO;
    UIImage *attachmentImageSO;
    NSString *encryptedImageStringSO;
   
    NSData *pdfFileData;
    
    //signature local storage path
    NSString *localSignFilePath;
    UIImage *attachmentSign;
    NSString *encryptedSignString;
    BOOL signatureCaptured;
    
    
    //colleague
    NSString *colleagueName;
    NSString *colleagueTelNo;
    NSString *colleagueTelNo2;
    
    NSString *colleagueAction;
    NSString *taskTranFrom;
    NSString *taskTranTo;
    
    
    
    
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *mainController;

@property (nonatomic, retain) NSString *deviceMACID;
@property (nonatomic, retain) NSString *GDID;
@property (nonatomic, retain) NSString *AltGDID;


@property (nonatomic, retain) NSString *activeApp;
@property (nonatomic, assign) BOOL DidBecomeActive;
@property (nonatomic, assign) BOOL ShowServiceUpdateDiagnosis;
@property (nonatomic, assign) BOOL CallContext;
@property (nonatomic, assign) BOOL FullSet;


@property (nonatomic, assign) BOOL mErrorFlagSAP;


@property (nonatomic, retain) NSString *imenoStr;

@property (nonatomic, retain) NSString *service_url;
@property (nonatomic, retain) NSString *buildName;
@property (nonatomic, assign) BOOL diagnoseSwitchStatus;



@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;

@property (nonatomic, retain) NSData *pdfFileData;

@property (nonatomic, assign) BOOL modifySearchWhenBackFalg;

@property (nonatomic, assign) NSInteger activeFaultSegmentIndexFlag;

@property (nonatomic, assign) BOOL activitySparesEditedFlag;

@property (nonatomic, retain)  NSString *localImageFilePath;

@property (nonatomic, retain) NSString *localAttachedImagePath;

@property (nonatomic, retain) UIImage *attachmentImage;
@property (nonatomic, retain)  NSString *encryptedImageString;
@property (nonatomic, retain)  NSString *localImageFilePathSO;
@property (nonatomic, retain) UIImage *attachmentImageSO;
@property (nonatomic, retain)  NSString *encryptedImageStringSO;

@property (nonatomic, retain)  NSString *localSignFilePath;
@property (nonatomic, retain) UIImage *attachmentSign;
@property (nonatomic, retain)  NSString *encryptedSignString;
@property (nonatomic, assign) BOOL signatureCaptured;

@property (nonatomic, assign) BOOL imageAttached;

//colleague
@property (nonatomic, retain)  NSString *colleagueName;
@property (nonatomic, retain)  NSString *colleagueTelNo;
@property (nonatomic, retain)  NSString *colleagueTelNo2;
@property (nonatomic, retain) NSString *colleagueAction;

@property (nonatomic, retain) NSString *taskTranFrom;
@property (nonatomic, retain) NSString *taskTranTo; 

//SOAP
@property (nonatomic, retain) Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *sapResponse;
@property (nonatomic, retain) CXMLDocument *xmlDocument;



-(BOOL)copyXMLfileIntoDocumnetDirectory;
-(void)loadDataFromXML;


-(void) GetDeviceid;

/*--Below commented code is for tracking the current location */
//@property (nonatomic, retain) CLLocationManager *locationManager;
//@property (nonatomic, assign) double currentLat;
//@property (nonatomic, assign) double currentLon;
//@property (nonatomic, assign) BOOL locationDetectionFlag;


/*--Below commented code is for tracking the current location, and calling when the application is launching.. */
//-(void)getCurrentLocation;



@end

