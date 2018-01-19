//
//  AppDelegate_iPad.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 27/07/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *mainController;
    //SAP Server response error flag;
    BOOL mErrorFlagSAP;
    
	
	//service url which is needed when calling SAP
	NSString *service_url;
    
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

@property (nonatomic, assign) BOOL mErrorFlagSAP;


@property (nonatomic, retain) NSString *imenoStr;

@property (nonatomic, retain) NSString *service_url;

@property (nonatomic, retain) UIImageView *loadingImgView;
@property (nonatomic, retain) UIActivityIndicatorView *actView;

@property (nonatomic, assign) BOOL modifySearchWhenBackFalg;

@property (nonatomic, assign) NSInteger activeFaultSegmentIndexFlag;

@property (nonatomic, assign) BOOL activitySparesEditedFlag;

@property (nonatomic, retain)  NSString *localImageFilePath;
@property (nonatomic, retain) UIImage *attachmentImage;
@property (nonatomic, retain)  NSString *encryptedImageString;
@property (nonatomic, retain)  NSString *localImageFilePathSO;
@property (nonatomic, retain) UIImage *attachmentImageSO;
@property (nonatomic, retain)  NSString *encryptedImageStringSO;

@property (nonatomic, retain)  NSString *localSignFilePath;
@property (nonatomic, retain) UIImage *attachmentSign;
@property (nonatomic, retain)  NSString *encryptedSignString;
@property (nonatomic, assign) BOOL signatureCaptured;

//colleague
@property (nonatomic, retain)  NSString *colleagueName;
@property (nonatomic, retain)  NSString *colleagueTelNo;
@property (nonatomic, retain)  NSString *colleagueTelNo2;
@property (nonatomic, retain) NSString *colleagueAction;

@property (nonatomic, retain) NSString *taskTranFrom;
@property (nonatomic, retain) NSString *taskTranTo;



@end

