//
//  ServiceOrderEdit.m
//  ServiceManagement
//
//  Created by Selvan Chellam on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceOrderEdit.h"
#import "ServiceOrders.h"
//#import "ServiceConfirmation.h"
#import "Constants.h"
#import "TaskLocationMapView.h"
#import "ColleagueList.h"
#import "MainMenu.h"
#import "ServiceManagementData.h"
#import "CustomPickerControl.h"
#import "StaticData.h"
#import "CustomDatePicker.h"
#import "QuartzCore/QuartzCore.h"
#import "AppDelegate_iPhone.h"
#import "Design.h"
#import "TaskLocationMapView.h"
#import "AttachmentImages.h"
#import "CustomAlertView.h"
#import "CurrentDateTime.h"

//#import "Z_GSSMWFM_HNDL_EVNTRQST00Svc.h"
#import "TouchXML.h"
#import "QSStrings.h"
#import "CheckedNetwork.h"
#import "ETAScreen.h"
#import "TableCellView.h"
#import "ModalView.h"
#import "SignatureCapture.h"
#import "SignaturePreview.h"
#import "ImagePreview.h"
#import "MapViewController.h"

#import "gss_qp_pastboard.h"
#import "iOSMacros.h"

#import "PartnerViewController.h"
#import "ServiceNoteExpand.h"

//#import "gss_ServiceProWebService.h"

CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;
//CurrentDateTime *objCurrentDateTime;

CustomAlertView *customAlt;
BOOL butLeftHid = NO;
BOOL butRightHid = NO;


//const NSInteger kViewTag2 = 1;
#define kOFFSET_FOR_KEYBOARD 250.0

@implementation ServiceOrderEdit

@synthesize object_id;
@synthesize serviceOrderEditArray;
@synthesize myTableView;
@synthesize toolbar;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskNotes;
@synthesize taskCategory;
@synthesize displayTask;
//@synthesize commonLabel;

@synthesize updateResponseMsgArray;

@synthesize alert;
@synthesize etaView;
@synthesize contract_value;
@synthesize rgtLabel;
@synthesize butETAValue;
@synthesize canButton;
@synthesize savButton;
@synthesize etaTitle;

@synthesize txtStatus;
@synthesize txtTimeZone;


@synthesize txtResult,txtResultValue;

@synthesize errStatus;

@synthesize imageView;
@synthesize localSmallFilepathStr;
@synthesize encodedImageStr;

@synthesize rowIndex;

@synthesize iPadView;

@synthesize pickerToolbar, pickerViewActionSheet, pickerView, pickerValue;

@synthesize Service_Task_SV;

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


//************************************************************************************************
//Image capture related code start
//************************************************************************************************
-(void)cameraBtnClicked{
    imagePicker.delegate = self;
    //--source for photolibrary
    //imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //--source for camera
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //imagePicker.allowsImageEditing = YES;
    imagePickerView.hidden = NO;
    //-show the image picker-------
    [self presentModalViewController:imagePicker animated:YES];
    
}
-(NSString *) filePath: (NSString *) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}


-(void) saveImage{
    //--get the date from the ImageView---
    
    //NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    //self.localSmallFilepathStr = [self filePath:@"MyPicture.png"];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    NSString *tmpImgName = [NSString stringWithFormat:@"%@_img.png",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    
    self.localSmallFilepathStr = [self filePath:tmpImgName] ;
    
    
    NSString * base64String;
    base64String = [QSStrings encodeBase64WithData:imageData];
    
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.localImageFilePath = self.localSmallFilepathStr;
    
    delegate.encryptedImageString = base64String;
    
    //---write the date to file--
    [imageData writeToFile:[self filePath:tmpImgName] atomically:YES];
    
    NSLog(@"image file path :%@ ",delegate.localImageFilePath);
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //UIImage *image;
    NSURL *mediaUrl;
    imageView.hidden = YES;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    
    if (mediaUrl == nil)
    {
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (image == nil)
        {
            image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            
            
            CGSize objCGSize = CGSizeMake(100, 100);
            image = [self scaledImageForImage:image newSize:objCGSize];
            
            //store image into global variable
            //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
            delegate.attachmentImage = image;
            
            
            //load image in image view
            imageView.image = image;
            
            //Enable attachment icon once image captured
            //attachButton.hidden = NO;
            
            //---save the image captured----
            [self saveImage];
            imagePickerView.hidden = YES;
        }
        else
        {
            //CGRect rect = [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
            
            //load image in image view
            
            imageView.image = image;
            //////////////attachButton.hidden = NO;
            
            //--save the image captured---
            [self saveImage];
        }
        
    }
    // else
    // {
    //--video picked---
    
    //     MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:mediaUrl];
    //     [player play];
    
    // }
    
    [picker dismissModalViewControllerAnimated:YES];
    
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //--user did not select image/video; hide the image piker----
    [picker dismissModalViewControllerAnimated:YES];
    
}
-(UIImage *)scaledImageForImage:(UIImage*)mimage newSize:(CGSize)newSize{
    UIGraphicsBeginImageContext( newSize );
    [mimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//-(IBAction)attachBtnClicked:(id)sender{
//    //Load Image Preview screen when attachment image button clicked.
//    ImagePreview *objImagePreview = [[ImagePreview alloc] init];
//    [self presentModalViewController:objImagePreview animated:YES];
//
//
//
//}

-(IBAction)attachBtnServerClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    
    AttachmentImages *objAttachmentImages;
    if (IS_IPHONE) {
        
        objAttachmentImages = [[AttachmentImages alloc] initWithNibName:@"AttachmentImages" bundle:nil];
        [self.navigationController pushViewController:objAttachmentImages animated:YES];
        [objAttachmentImages release],objAttachmentImages = nil;
    }
    else{
        objAttachmentImages = [[AttachmentImages alloc] initWithNibName:@"AttachmentImages_ipad" bundle:nil];
        [self.navigationController pushViewController:objAttachmentImages animated:YES];
        [objAttachmentImages release],objAttachmentImages = nil;
        
    }
}
-(IBAction)attachBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    //    ImagePreview *objImagePreview = [[ImagePreview alloc] init];
    //    [self presentModalViewController:objImagePreview animated:YES];
    ImagePreview *showImage = [[[ImagePreview alloc]initWithNibName:@"ImagePreview" bundle:nil] autorelease];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:showImage];
    navController.modalInPopover=YES;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modalViewDone)];
    showImage.navigationItem.rightBarButtonItem = doneBarButton;
    showImage.navigationItem.title = @"Image Preview";
    
    showImage.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    showImage.view.superview.frame = CGRectMake(70, 70, 600, 600);
    
    [doneBarButton release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [navController release],navController =nil;
}

//************************************************************************************************
//image capture code ends here
//************************************************************************************************

//************************************************************************************************
//Signature capture related codes
//************************************************************************************************
-(void) scanBtnClicked{
    
    SignatureCapture *objSignatureCapture = [[SignatureCapture alloc] initWithNibName:@"SignatureCapture" bundle:nil];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    
    objSignatureCapture.TaskOrderID = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
    
    
    //objSignatureCapture.TaskOrderID = Sig_FilePath;
    
    [self.navigationController pushViewController:objSignatureCapture animated:YES];
    [objSignatureCapture release];
    objSignatureCapture = nil;
    
    
}
-(IBAction)attachSignBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    SignaturePreview *objSignaturePreview = [[SignaturePreview alloc] init];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    objSignaturePreview.TaskOrderID = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
    
    [self presentModalViewController:objSignaturePreview animated:YES];
    [objSignaturePreview release];
}


-(IBAction)partnerBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    objServiceManagementData.partnerTaskID = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
    objServiceManagementData.partnerTaskItem = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"];
   
    
    PartnerViewController *objPartnerViewController = [[PartnerViewController alloc] initWithNibName:@"PartnerViewController" bundle:nil];
    [self.navigationController pushViewController:objPartnerViewController animated:YES];
    [objPartnerViewController release],objPartnerViewController = nil;
    
}


//************************************************************************************************
//signature capture related code end
//************************************************************************************************

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark - View lifecycle

//This function will call when back from the pushed viewcontroller..
-(void)viewWillAppear:(BOOL)animated{
    [self loadToolBarItems];
   }

-(BOOL) checkServerAttachment {
    
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    //**************************************************************************
    //SERVER ATTACHMENT icon
    //**************************************************************************
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_ATTCHMNT01 WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
    NSMutableArray *tempPrtMast = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVERATTACHMENT" :1];
    
    if ([tempPrtMast count]>0)
        return YES;
    else
        return NO;
    //**************************************************************************
    
}
-(void) loadToolBarItems{
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    

    //toolbar code
    NSArray *items;
    toolbar.barStyle = UIBarStyleBlackOpaque; // UIBarStyleDefault;
    
    
    
    UIBarButtonItem *menuItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu28-b.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doMenu)] autorelease];
    menuItem.title = @"Menu";
    
    
    //Load service image attachment icon
    UIImage *buttonSImage = [UIImage imageNamed:@"attachment-1.jpeg"];
    //create the button and assign the image
    UIButton *sbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sbutton setImage:buttonSImage forState:UIControlStateNormal];
    [sbutton addTarget:self action:@selector(attachBtnServerClicked:) forControlEvents:UIControlEventTouchUpInside];
    //sets the frame of the button to the size of the image
    sbutton.frame = CGRectMake(0, 4, 45, 35);
    //creates a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *imageSItem = [[UIBarButtonItem alloc] initWithCustomView:sbutton];
    

    //Load the image
    UIImage *buttonImage = [UIImage imageNamed:@"attachment.png"];
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(attachBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //sets the frame of the button to the size of the image
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    //creates a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    //Load the image
    UIImage *buttonImage1 = [UIImage imageNamed:@"signature.png"];
    //create the button and assign the image
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:buttonImage1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(attachSignBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //sets the frame of the button to the size of the image
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width, buttonImage1.size.height);
    //creates a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *signatureItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    
    //Load the image
    UIImage *buttonImage2 = [UIImage imageNamed:@"partners_icon.png"];
    //create the button and assign the image
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:buttonImage2 forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(partnerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //sets the frame of the button to the size of the image
    button2.frame = CGRectMake(0, 0, 25.0f, 25.0f);
    //creates a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *partnerItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    
    
    UIBarButtonItem *fixSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *fixSpaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *fixSpaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    
    //Item Navigation button
    UIImage *imgPrevv = [UIImage imageNamed:@"left.png"];
    butPrevv = [UIButton buttonWithType:UIButtonTypeCustom];
    butPrevv.frame = CGRectMake(0.0f, 0.0f, 30.0f, 25.0f);
    [butPrevv setImage:imgPrevv forState:UIControlStateNormal];
    butPrevv.hidden = butLeftHid;
    butPrevv.tag = 1;
    [butPrevv addTarget:self action:@selector(loadEditDatatoDic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:butPrevv];
    
    
    
    
    UIImage *imgNextt = [UIImage imageNamed:@"right.png"];
    butNextt = [UIButton buttonWithType:UIButtonTypeCustom];
    butNextt.frame = CGRectMake(0.0f, 0.0f, 30.0f, 25.0f);
    [butNextt setImage:imgNextt forState:UIControlStateNormal];
    butNextt.hidden = butRightHid;
    butNextt.tag = 2;
    [butNextt addTarget:self action:@selector(loadEditDatatoDic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:butNextt];
    
    
    [self ImageCheckingInDocFolder];
    
    
    
    float _screenWidth = self.view.frame.size.width;
    //float _screenHieght = self.view.frame.size.height;
    
    fixSpaceItem1.width = (_screenWidth - (_screenWidth/2))/2;
    fixSpaceItem2.width = 5;
    
    NSLog(@"screen width %f", _screenWidth);
    
    int iconLoaded = 0;
    fixSpaceItem.width = (_screenWidth/2);
    
    NSLog(@"space %f", fixSpaceItem.width);
    
    NSMutableArray *toolbarItemArray = [[NSMutableArray alloc] init];
    
    if (delegate.signatureCaptured) {
        [toolbarItemArray addObject:signatureItem];
        iconLoaded = 1;
    }
    
    if (delegate.localImageFilePath.length > 0) {
        [toolbarItemArray addObject:imageItem];
        iconLoaded = iconLoaded + 1;
    }
    
    if ([self checkServerAttachment]) {
        [toolbarItemArray addObject:imageSItem];
        iconLoaded = iconLoaded + 1;
    }
    
    if ([self checkServiceOrderPartner]) {
        [toolbarItemArray addObject:partnerItem];
        iconLoaded = iconLoaded + 1;
    }
    
    
    fixSpaceItem.width = fixSpaceItem.width - (50 * iconLoaded);
    
//    if (iconLoaded > 1)
//        fixSpaceItem.width = (_screenWidth/2)/iconLoaded;
//    else
//        fixSpaceItem.width = fixSpaceItem.width/iconLoaded;
    
    [toolbarItemArray addObject:fixSpaceItem];
    [toolbarItemArray addObject:menuItem];
    [toolbarItemArray addObject:fixSpaceItem1];
    [toolbarItemArray addObject:leftItem];
    [toolbarItemArray addObject:fixSpaceItem2];
    [toolbarItemArray addObject:rightItem];
  
    NSLog(@"space %f", fixSpaceItem.width);
    
  /*  if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length == 0 && ![self checkServerAttachment] ) {
        fixSpaceItem.width = (_screenWidth/2)-89;
        items = [NSArray arrayWithObjects:signatureItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length >0 && ![self checkServerAttachment]) {
        fixSpaceItem.width = (_screenWidth/2)-33;
        items = [NSArray arrayWithObjects:imageItem, signatureItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == NO && delegate.localImageFilePath.length >0 && ![self checkServerAttachment]) {
        fixSpaceItem.width = (_screenWidth/2)-83;
        items = [NSArray arrayWithObjects:imageItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length == 0 && [self checkServerAttachment] ) {
        fixSpaceItem.width = (_screenWidth/2)-33;
        items = [NSArray arrayWithObjects:imageSItem, signatureItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length >0 && [self checkServerAttachment]) {
        fixSpaceItem.width = (_screenWidth/2)-3;
        items = [NSArray arrayWithObjects:imageSItem,imageItem, signatureItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == NO && delegate.localImageFilePath.length >0 && [self checkServerAttachment]) {
        fixSpaceItem.width = (_screenWidth/2)-33;
        items = [NSArray arrayWithObjects:imageSItem,imageItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else if (delegate.signatureCaptured == NO && delegate.localImageFilePath.length==0 && [self checkServerAttachment]) {
        fixSpaceItem.width = (_screenWidth/2)-89;
        items = [NSArray arrayWithObjects:imageSItem,fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
    }
    else{
        fixSpaceItem.width = (_screenWidth/2) - 20;
        items = [NSArray arrayWithObjects:partnerItem, fixSpaceItem, menuItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        
    }*/
    [imageSItem release], imageSItem = nil;
    [imageItem release], imageItem =nil;
    [partnerItem release], partnerItem = nil;
    [fixSpaceItem release]; fixSpaceItem = nil;
    [fixSpaceItem1 release]; fixSpaceItem1 = nil;
    [fixSpaceItem2 release]; fixSpaceItem2 = nil;
    [signatureItem release]; signatureItem = nil;
    [rightItem release],rightItem=nil;
    [leftItem release],leftItem = nil;
    
    
    
  
    
    
    //toolbar.items = items;
    
    toolbar.items = toolbarItemArray;
   
    [self.view addSubview:toolbar];
    
    
    
}


-(void)ImageCheckingInDocFolder
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    delegate.signatureCaptured = NO;
    
    Sig_FilePath = [NSString stringWithFormat:@"%@.png" , [self filePath:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]] ];
    delegate.attachmentSign = [UIImage imageWithContentsOfFile:Sig_FilePath];
    
    if(!(delegate.attachmentSign == NULL))
        delegate.signatureCaptured = YES;
    
    //Biren added code for Image Attachment
    
    delegate.imageAttached = NO;
    
    NSString *filePath1 = [NSString stringWithFormat:@"%@_img.png", [self filePath:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]]];
    delegate.attachmentImage = [UIImage imageWithContentsOfFile:filePath1];
    
    NSLog(@"value of filepath is : %@", filePath1);
    
    
    if (!(delegate.attachmentImage == NULL)) {
        delegate.localImageFilePath=filePath1;
        delegate.imageAttached = YES;
    }
    else
    {
        delegate.localImageFilePath=@"";
        delegate.imageAttached = NO;
    }
    
    //end.
    
    
}


-(BOOL) checkServiceOrderPartner {
    
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    //**************************************************************************
    //SERVER ATTACHMENT icon
    //**************************************************************************
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_DCMNTPRTNR10EC WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
    NSMutableArray *tempPrtMast = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"PARTNER" :1];
    
    if ([tempPrtMast count]>0){
        
               return YES;
    }
    else
        return NO;
    //**************************************************************************
    
}

-(IBAction)loadEditDatatoDic:(id)sender{
 
//Get order to edit
    int rctcnt = [self.serviceOrderEditArray count];
    UIButton *myButton = (UIButton *)sender;
    
    if (myButton.tag == 2) {
        ++currentRcd;
        butLeftHid = FALSE;
        if (rctcnt == currentRcd+1) {
            butRightHid = TRUE;
        }
        
        NSLog(@"current  %d   %d",currentRcd,rctcnt);
    }
    else if (myButton.tag ==1) {
        currentRcd--;
        if (currentRcd == 0) {
            butLeftHid = TRUE;
        }
        if (rctcnt > 1) {
            butRightHid = FALSE;
        }
        else{
            butRightHid = TRUE;
        }
        NSLog(@"current1 %d   %d",currentRcd,rctcnt);
    }
    else
        currentRcd =0;
      
    
    if (rctcnt >= currentRcd) {
        [self populateTaskDataDic];
        [TableTitle removeAllObjects];
        [TableData removeAllObjects];
        [self RemoveNullFeildsFromTable];
         [self.myTableView reloadData];
    }
    [self loadToolBarItems];
}

-(void) populateTaskDataDic {
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    [self getTaskEditData];
    
    
    //[objServiceManagementData.taskDataDictionary removeAllObjects];
    objServiceManagementData.taskDataDictionary = [self.serviceOrderEditArray objectAtIndex:currentRcd];
    
    NSLog(@"task disc %@",objServiceManagementData.taskDataDictionary);
    
    
    //**************************************************************************
    //PRIORITY icon
    //**************************************************************************
    //Below four block for handling the task PRIORITY images... the image name is indicating the PRIORITY value..
    
    NSString *sqlPrQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_PRRTY10 WHERE PRIORITY = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]];
    NSMutableArray *tempPrtMast = [objServiceManagementData fetchDataFrmSqlite:sqlPrQryStr :objServiceManagementData.gssSystemDB:@"PRIORITY" :1];
    
    if ([tempPrtMast count]>0) {
        [objServiceManagementData.taskDataDictionary setObject:[NSString stringWithFormat:@"%@ - %@",[[tempPrtMast objectAtIndex:0] objectForKey:@"PRIORITY"],[[tempPrtMast objectAtIndex:0] objectForKey:@"PRIORITY_DESCRIPTION"]]     forKey:@"PRIORITY"];
    
    }
    //***************************************************************************
    
    //CUSTOMER DON'T WANT TO DISPLAY TELEPHONE NUMBER. I AM MAKING TEL NUMBER TO NULL TO NOT DISPLAY IN DETAIL SCREEN
    [objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"CP1_TEL_NO"];
    [objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"CP1_TEL_NO2"];
    
    
    
    //Set some extra keys for display in to page...
    [objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON"];
    [objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON_DESCRIPTION"];
    [objServiceManagementData.taskDataDictionary 	setObject:@"Indian Standard Time" forKey:@"TIME_ZONE"];
    [objServiceManagementData.taskDataDictionary    setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] forKey:@"STATUS_ACTUAL"];
    
    
    //Get master data  modify on 23/12/2013 by selvan. In query string added extra condition as process type
    //Refresh status description table
    NSString *sqlQryStr1 = [NSString stringWithFormat:@"SELECT B.TXT30 FROM ZGSXCAST_STTSFLOW10 A INNER JOIN ZGSXCAST_STTS10 B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@' AND A.PROCESS_TYPE ='%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ACTUAL"], [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
    objServiceManagementData.taskStatusTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr1 :objServiceManagementData.gssSystemDB:@"STATUS" :2];

    //Old code before add process type in query condition
//    NSString *sqlQryStr1 = [NSString stringWithFormat:@"SELECT B.TXT30 FROM ZGSXCAST_STTSFLOW10 A INNER JOIN ZGSXCAST_STTS10 B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ACTUAL"]];
//    objServiceManagementData.taskStatusTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr1 :objServiceManagementData.gssSystemDB:@"STATUS" :2];

    
  

    
    //Refresh RESULT table
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT SRV_RESULT || '  ' || DESCRIPTION FROM ZCRMV_RESULT_T WHERE PROCESS_TYPE='%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
    objServiceManagementData.taskResultTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULT" :2];
    
    
    //Added by sahana on sep 27 2016
    
    NSString *sqlQryStr12 = [NSString stringWithFormat:@"SELECT * FROM ZTCCST_SETTYPET" ];
    objServiceManagementData.taskSetTypeArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr12 :objServiceManagementData.gssSystemDB:@"SETTYPE" :2];
    NSLog(@"SET TYPE ARRAY %@",objServiceManagementData.taskSetTypeArray);
    

    
    NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@ AND NUMBER_EXT = %@",[objServiceManagementData.dataTypeArray objectAtIndex:16],objServiceManagementData.editTaskId,[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
    
    NSMutableArray *tmpResultArry = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"YTCCSMST_SRVCDCMNT10" :2];
    
    NSLog(@"%@",tmpResultArry);
    
    if ([tmpResultArry count] >0) {
    
        NSMutableArray *mResultArry;
        sqlQryStr = [NSString stringWithFormat:@"SELECT SRV_RESULT || '  ' || DESCRIPTION FROM ZCRMV_RESULT_T WHERE SRV_RESULT = '%@'",[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZRESULT"]];
        
        mResultArry = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULTTYPE" :2];
        
        if ([mResultArry count] >0) {
            [objServiceManagementData.taskDataDictionary setObject:[mResultArry objectAtIndex:0] forKey:@"ZRESULT"];}
        
        NSLog(@"%@",mResultArry);
        
        sqlQryStr = [NSString stringWithFormat:@"SELECT SRV_RESULT_TYPE || '  ' || DESCRIPTION FROM ZCRMV_RESULTTY_T WHERE SRV_RESULT = '%@' AND SRV_RESULT_TYPE = '%@'",[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZRESULT"],[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZRESULTTYPE"]];
        
        
        mResultArry = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULTTYPE" :2];
        if ([mResultArry count] >0) {
            [objServiceManagementData.taskDataDictionary setObject:[mResultArry objectAtIndex:0] forKey:@"ZZRESULTTYPE"];}
        
        NSLog(@"%@",mResultArry);
        
        
        
        [objServiceManagementData.taskDataDictionary setObject:[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZCONTRACT_VALUE"] forKey:@"ZZCONTRACT_VALUE"];
       
        [objServiceManagementData.taskDataDictionary setObject:[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZSETTYPE"] forKey:@"ZZSETTYPE"];
        [objServiceManagementData.taskDataDictionary setObject:[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZSETTYPE_TXT"] forKey:@"ZZSETTYPE_TXT"];

        
        
        
        //Refresh RESULT TYPE table
        sqlQryStr = [NSString stringWithFormat:@"SELECT SRV_RESULT_TYPE || '  ' || DESCRIPTION FROM ZCRMV_RESULTTY_T WHERE SRV_RESULT LIKE '%@' AND PROCESS_TYPE LIKE '%@'",[[tmpResultArry objectAtIndex:0] objectForKey:@"ZZRESULT"],[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
        objServiceManagementData.taskResultTypeTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULTTYPE" :2];
        
    }
    else{
        [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"ZRESULT"];
        [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"ZZRESULTTYPE"];
        [objServiceManagementData.taskDataDictionary setObject:@"0.00" forKey:@"ZZCONTRACT_VALUE"];
    }
    
    
    //Adding the STATUS value to dictionary depending upon the 'taskStatusMappingArray' list..there status is mapped..
//    [objServiceManagementData.taskDataDictionary
//     setObject:[[objStaticData.taskStatusMappingArray objectAtIndex:0]
//                objectForKey:[[serviceOrderEditArray objectAtIndex:0] objectForKey:@"STATUS"]] forKey:@"STATUS"];
   
//    NSLog(@"task disc %@", objServiceManagementData.taskStatusMappingArray);
//    
//    [objServiceManagementData.taskDataDictionary
//         setObject:[[objServiceManagementData.taskStatusMappingArray objectAtIndex:0]
//                     objectForKey:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]] forKey:@"STATUS"];

    
    //Get status context
    //NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE STATUS = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]];
    
    sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE STATUS = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ACTUAL"]];
    
//     NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT B.STATUS,B.TXT30,B.ZZSTATUS_POSTSETACTION FROM ZGSXCAST_STTSFLOW10 A INNER JOIN ZGSXCAST_STTS10 B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ACTUAL"]];
    
    NSMutableArray *tempStatusArr = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :1];
    if ([tempStatusArr count] >0) {
      
        [objServiceManagementData.taskDataDictionary setObject:[[tempStatusArr objectAtIndex:0] objectForKey:@"TXT30"] forKey:@"STATUS_TXT30"];
        [objServiceManagementData.taskDataDictionary setObject:[[tempStatusArr objectAtIndex:0] objectForKey:@"ZZSTATUS_POSTSETACTION"] forKey:@"STATUS_ZZSTATUS_POSTSETACTION"];
        [objServiceManagementData.taskStatusTxtArray addObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]];
    }
    else
    {
        BOOL recFoundFlag = NO;
        
        NSLog(@"temp status %@",objServiceManagementData.taskStatusTxtArray);
        
        if ([objServiceManagementData.taskStatusTxtArray count] >0) {
            
            for (int i=0;i<=[objServiceManagementData.taskStatusTxtArray count]-1; i++) {
                
                if ([[objServiceManagementData.taskStatusTxtArray objectAtIndex:i] isEqualToString:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]]) {
                    
                    recFoundFlag = YES;
                    break;
                }
            }
        }
        
        //COMMENTED BY SELVAN
        //        if (!recFoundFlag) {
        //            [objServiceManagementData.taskStatusTxtArray addObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]];
        //        }
        
        [objServiceManagementData.taskStatusTxtArray addObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]];

        
        
        [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"STATUS_ZZSTATUS_POSTSETACTION"];
        
        [objServiceManagementData.taskStatusMaster_temp removeAllObjects];
        [objServiceManagementData.taskStatusMaster_temp setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"] forKey:@"TXT30"];
        [objServiceManagementData.taskStatusMaster_temp setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] forKey:@"STATUS"];
        
        
        /*
        recFoundFlag = NO;
        
        if ([objServiceManagementData.taskStatusMappingArray count] >0) {
            
            for (int i=0;i<=[objServiceManagementData.taskStatusMappingArray count]-1; i++) {
                
                if ([[[objServiceManagementData.taskStatusMappingArray objectAtIndex:i] objectForKey:@"TXT30"] isEqualToString:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"]]) {
                    
                    recFoundFlag = YES;
                    break;
                }
            }
        }
        
        if (!recFoundFlag) {
            //If unknown status that is status not found in status master then create new array
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [tempDic setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"] forKey:@"TXT30"];
            [tempDic setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] forKey:@"STATUS"];
            
            //[objServiceManagementData.taskStatusMappingArray removeAllObjects];
            [objServiceManagementData.taskStatusMappingArray addObject:tempDic];
            [tempDic release],tempDic =nil;
        }
         */
        NSLog(@"STATUS MAPPING %@",objServiceManagementData.taskStatusMaster_temp);

        
    }
    
    NSLog(@"temp status %@",objServiceManagementData.taskStatusTxtArray);
    
    
    //Check queue processor Error
    NSString *sqlQryStr3 = [NSString stringWithFormat:@"SELECT * FROM 'tbl_errorlist' WHERE apprefid = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr3 :objServiceManagementData.gssSystemDB:@"error table" :1];
    NSMutableString *errDesc = [NSMutableString string];
    //Group error
    for (int cnt=0; cnt < [objServiceManagementData.errorlistArray count]; cnt++) {
        
        [errDesc appendString:[[objServiceManagementData.errorlistArray objectAtIndex:cnt] objectForKey:@"errdate"]];
        [errDesc appendString:@": "];
        [errDesc appendString:[[objServiceManagementData.errorlistArray objectAtIndex:cnt] objectForKey:@"errdesc"]];
        [errDesc appendString:@". "];
    }
    
    if ([objServiceManagementData.errorlistArray count] > 0)
        errStatus = YES;
    else
        errStatus = NO;
    
    
    self.object_id =  [NSString stringWithFormat:@"%@", [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    
    delegate.taskTranFrom = self.object_id;
    
   
    
}

-(void) getTaskEditData {
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",[objServiceManagementData.dataTypeArray objectAtIndex:0],objServiceManagementData.editTaskId];
    
    self.serviceOrderEditArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :2];
    
    NSLog(@"EDIT ARRAY %@",self.serviceOrderEditArray);

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    ChkPopUpMenu = YES;
    
    
    
    //UIScreen *screen = [UIScreen mainScreen];
    //[self.view setFrame:[screen applicationFrame]];
    
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Edit_Task_title","");
	//customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.font = [UIFont systemFontOfSize:18];
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    [tlabel release],tlabel =nil;
    //end
    
	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
    //objCurrentDateTime = [[CurrentDateTime alloc] init];
    imagePicker = [[UIImagePickerController alloc] init];
    
    
    	ETAPopupShowFlag = YES;
    
    serviceOrderEditArray = [[NSMutableArray alloc] init];
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0) {
    [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
        barButton.tintColor = [UIColor whiteColor];
    }
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    
    
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(SaveTask)];
    if ([SYSTEM_VERSION floatValue] >= 7.0)
    saveButton.tintColor = [UIColor whiteColor];

	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release], saveButton = nil;
    
    
    //Get task edit data based on object id
    [self getTaskEditData];
    
    
    currentRcd = [self searchTableView];
    NSLog(@"current record :%d",currentRcd);
    
    //check navigation button status
    if ([self.serviceOrderEditArray count] ==currentRcd+1  && currentRcd >0) {
        butRightHid = TRUE;
        butLeftHid = FALSE;
    }
    else if ([self.serviceOrderEditArray count] > currentRcd+1 && currentRcd ==0) {
        butRightHid = FALSE;
        butLeftHid = TRUE;
    }
    else if ([self.serviceOrderEditArray count] > currentRcd+1 && currentRcd >0){
        butRightHid = FALSE;
        butLeftHid = FALSE;
        
    }
    else{
        butRightHid = TRUE;
        butLeftHid = TRUE;
    } 
    //COMMENTED BY SELVAN ON 29/03/2013 FOR TCW STATUS CHANGE
    
//    //Get master data
//    //Refresh status description table
//    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT TXT30 FROM ZGSXCAST_STTS10 WHERE 1"];
//    objServiceManagementData.taskStatusTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"STATUS" :2];
    
//    //Refresh RESULT table
//    //NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT ZRESULT || '  ' || ZRESULTTEXT FROM ZCRMV_RESULT_T WHERE 1"];
//    objServiceManagementData.taskResultTxtArray = [objServiceManagementData fetchDataFrmSqlite_v2:sqlQryStr :objServiceManagementData.gssSystemDB:@"RESULT" :2];

    
   //Load current task edit data to dictionary 
    
    [self populateTaskDataDic];
    
 
    
    ChkPopUpMenu = NO;
    
    
    service_count = 0;
    array_total_count=0;
    
    
    TableTitle = [[NSMutableArray alloc] init];
    TableData = [[NSMutableArray alloc]init];
    [self RemoveNullFeildsFromTable];
    
    
    //ScrollView - IPAD View
    
    [self.Service_Task_SV setScrollEnabled:YES];
    [self.Service_Task_SV setShowsHorizontalScrollIndicator:YES];
   //[self.Service_Task_SV setContentSize:(CGSizeMake(758,800))];
    
}

//calling when searching is TRUE..
- (int) searchTableView {
	
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    int rtnValue = 0;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
    [searchArray addObjectsFromArray:self.serviceOrderEditArray];
	
	for (int i=0; i<[searchArray count]; i++) {
		
		//If 'searchText' is found in 'TASK_SEARCH_STRING' then add object in dubArrayList...
		if([[[searchArray objectAtIndex:i] objectForKey:@"ZZFIRSTSERVICEITEM"] rangeOfString:objServiceManagementData.itemId options:NSCaseInsensitiveSearch ].location != NSNotFound)
		{
			rtnValue = i;
            break;
		}
	}
	
	[searchArray release], searchArray = nil;
	return rtnValue;
}



//
-(void)RemoveNullFeildsFromTable
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    int flag=0;
    
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"CP1_NAME1_TEXT"] isEqualToString:@""]|| [objServiceManagementData.taskDataDictionary objectForKey:@"CP1_NAME1_TEXT"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_ContactName"];
        [TableData addObject:@"CP1_NAME1_TEXT"];
    }
    
    
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"CP1_TEL_NO"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"CP1_TEL_NO"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_Telno"];
        [TableData addObject:@"CP1_TEL_NO"];
    }
    
    
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"CP1_TEL_NO2"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"CP1_TEL_NO2"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_Atelno"];
        [TableData addObject:@"CP1_TEL_NO2"];
    }
    
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"IB_INST_DESCR"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"IB_INST_DESCR"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_ProdDesc"];
        [TableData addObject:@"IB_INST_DESCR"];
    }
    
    
    
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"SERIAL_NUMBER"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"SERIAL_NUMBER"]) )
    {
        [TableTitle addObject:@"Edit_Task_Label_Serial#"];
        [TableData addObject:@"SERIAL_NUMBER"];
    }
    
    if (!([[objServiceManagementData.taskDataDictionary objectForKey:@"IB_DESCR"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"IB_DESCR"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_InstBaseDesc"];
        [TableData addObject:@"IB_DESCR"];
    }
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"IB_INST_DESCR"] isEqualToString:@""] || [objServiceManagementData.taskDataDictionary objectForKey:@"IB_INST_DESCR"] == NULL))
    {
        [TableTitle addObject:@"Edit_Task_Label_CompDesc"];
        [TableData addObject:@"IB_INST_DESCR"];
    }
    
    //NSString *Tvalue = [[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"PARTNER"];
    NSString *Tvalue = [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"];
    
    if(!([Tvalue isEqualToString:@""] || Tvalue == NULL))
        flag=1;
    
    //Tvalue = [[objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId] objectForKey:@"REFOBJ_PRODUCT_ID"];
    Tvalue = [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"];
    
    
    if(!([Tvalue isEqualToString:@""] || Tvalue == NULL))
        flag=1;
    
    
    if(flag == 1)
        [TableTitle addObject:@"Other Details"];
    
    
}
//

//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    //Retrieving all service list data.
    [objServiceManagementData.taskListArray removeAllObjects];
    //[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]]:-1];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
    objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVICE ORDER" :2];
    
    
    delegate.modifySearchWhenBackFalg = TRUE;
   
  	delegate.activeApp = @"ServiceOrders";
    
    
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    
}


-(void) doMenu{
    
    //Action sheet to go EditTadk, Mapview or Service confirmation page...against one task...
	/*  commented and replaced code below menu function by selvan for time being on 9th feb, 2013
     
     UIActionSheet *editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc]
     initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")
     destructiveButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Service_Confirmation",@"")
     otherButtonTitles:
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Task_Location_in_MapView",@"") ,
     
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Service_Transfer", @""),
     
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Entitlements",@"") ,
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_CaptureImage",@""),
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_AddSignature",@""),
     
     nil]; end selvan*/
    
    UIActionSheet *editTaskMapViewServiceConfActionSheet =
    [[UIActionSheet alloc]initWithTitle:
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")
                 destructiveButtonTitle:nil
                      otherButtonTitles:
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Task_Location_in_MapView",@"") ,
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Service_Transfer", @""),
     
     NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_CaptureImage",@""),
     
     nil];
	
	editTaskMapViewServiceConfActionSheet.tag = 2; //I have set tag, because two action sheet is present in this class..
	
	[editTaskMapViewServiceConfActionSheet showInView:self.view];
    
	[editTaskMapViewServiceConfActionSheet release], editTaskMapViewServiceConfActionSheet = nil;
    
}
//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* Commented and replaced code by selvan due to removed some items from popup menu on 9th feb , 2013
     
     
     //TaskLocationMapView *objTaskLocationMapView;
     //CGRect frame = CGRectMake(round((self.view.bounds.size.width - kImageWidth) / 2.0), kTopPlacement, kImageWidth, kImageHeight);
     switch (buttonIndex) {
     case 0:
     self.view.userInteractionEnabled = FALSE;
     self.navigationItem.rightBarButtonItem.enabled = FALSE;
     self.navigationItem.hidesBackButton = YES;
     customAlt = [[CustomAlertView alloc] init];
     [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
     
     break;
     
     case 1:
     //objServiceManagementData.editTaskId = self.rowIndex;
     objTaskLocationMapView = [[TaskLocationMapView alloc] initWithNibName:@"TaskLocationMapView" bundle:nil];
     [self.navigationController pushViewController:objTaskLocationMapView animated:YES];
     [objTaskLocationMapView release], objTaskLocationMapView = nil;
     break;
     
     
     }
     */
    switch (buttonIndex) {
        default:
            break;
    }
}
//Delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//ServiceConfirmation *objServiceConfirmation;
    // AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//This below block will call when Service orders function will call..
	if (actionSheet.tag == 2 && buttonIndex == 5) {
		
        [customAlt removeAlertForView];
        [customAlt release], customAlt = nil;
        
        self.view.userInteractionEnabled = TRUE;
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.hidesBackButton = NO;
        
        delegate.localImageFilePath = @"";
        delegate.signatureCaptured = FALSE;
        
       /* NSString *sqlQryStr;
        
       
        
        [objServiceManagementData.serviceOrderActivityArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID= %@",[objServiceManagementData.dataTypeArray objectAtIndex:13],[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        objServiceManagementData.serviceOrderActivityArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOACTIVITY" :1];
        
        [objServiceManagementData.serviceOrderSpareArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID= %@",[objServiceManagementData.dataTypeArray objectAtIndex:14],[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        objServiceManagementData.serviceOrderSpareArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOSPARES" :1];
        
        
        [objServiceManagementData.serviceOrderConfirmationArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:15]];
        objServiceManagementData.serviceOrderConfirmationArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOCONFIRMATION" :1];
        
        
        [objServiceManagementData.materialListArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:8]];
        objServiceManagementData.materialListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"MATERIAL MASTER DATA" :1];
        
        [objServiceManagementData.activityListArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",
                     [objServiceManagementData.dataTypeArray objectAtIndex:1]];
        
        NSLog(@"Qur str %@", sqlQryStr);
        objServiceManagementData.activityListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"ACTIVITY LIST MASTER DATA" :1];
        
        
        [objServiceManagementData.faultSymtmCodeGroupArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:7]];
        objServiceManagementData.faultSymtmCodeGroupArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT SYMTM GROUP MASTER DATA" :1];
        
        
        [objServiceManagementData.faultPrblmCodeGroupArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:5]];
        objServiceManagementData.faultPrblmCodeGroupArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT PROBLEM GROUP MASTER DATA" :1];
        
        
        
        [objServiceManagementData.faultCauseCodeGroupArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:3]];
        objServiceManagementData.faultCauseCodeGroupArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT CAUSE GROUP MASTER DATA" :1];
        
        
        [objServiceManagementData.faultSymtmCodeListArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:6]];
        objServiceManagementData.faultSymtmCodeListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT SYMTM CODE MASTER DATA" :1];
        
        
        
        [objServiceManagementData.faultPrblmCodeListArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:4]];
        objServiceManagementData.faultPrblmCodeListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT PROBLEM CODE MASTER DATA" :1];
        
        
        
        [objServiceManagementData.faultCauseCodeListArray removeAllObjects];
        sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:2]];
        objServiceManagementData.faultCauseCodeListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"FAULT CAUSE CODE MASTER DATA" :1];
        //End Service Confirmation
        
        
        objServiceConfirmation = [[ServiceConfirmation alloc] initWithNibName:@"ServiceConfirmation" bundle:nil];
        [self.navigationController pushViewController:objServiceConfirmation animated:YES];
        [objServiceConfirmation release], objServiceConfirmation = nil;
        
        */
        
    }
    else if(actionSheet.tag == 2 && buttonIndex == 1) {
        
        //Load collegue list view.
        //ColleagueList *objColleagueList = [[ColleagueList alloc] init];
        //[self presentModalViewController:objColleagueList animated:YES];
        
       /*commented by selvaan on 3rd march if ([objServiceManagementData.colleagueListArray count] == 0) {

            MainMenu *objMainMenu = [[[MainMenu alloc] init] autorelease];
            
            [objMainMenu getColleagueListDownloadFromSAP];
            
        }*/
        // AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        delegate.colleagueAction = @"TransferColleague";
        delegate.taskTranFrom = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
        ColleagueList *objColleagueList = [[ColleagueList alloc] initWithNibName:@"ColleagueList" bundle:nil];
        [self.navigationController pushViewController:objColleagueList animated:YES];
        [objColleagueList release], objColleagueList = nil;
        delegate.localImageFilePath = @"";
        
      

        
    }
    else if(actionSheet.tag == 2 && buttonIndex == 2){
        
        [self cameraBtnClicked];
    }
    else if(actionSheet.tag == 2 && buttonIndex == 6) {
        
        [self scanBtnClicked];
    }
    else if (actionSheet.tag == 2 && buttonIndex == 0) {
        [self showTaskLocation];
    }
    else {
        self.view.userInteractionEnabled = TRUE;
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.hidesBackButton = NO;
        
        printf("Some problem is occuared while downloading service Order Confirmation List from SAP!...");
    }
    
}

//Code added for Loading MAP VIEW- TASK LOCATION
-(void)showTaskLocation {
    
    TaskLocationMapView *taskLocation = [[TaskLocationMapView alloc]initWithNibName:@"TaskLocationMapView" bundle:nil];
    [self.navigationController pushViewController:taskLocation animated:YES];
    [taskLocation release];
}

# pragma mark - Table View Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    service_count = 0;
    return 1;
}
//calculatinf cell height...
-(CGFloat)cellHeightCalculation:(NSString *)cellLabel:(NSString *)cellLabelValue
{
	int countCharLabel =  cellLabel.length;
	int countCharLabelValue = cellLabelValue.length;
	
	if(countCharLabel>countCharLabelValue)
	{
		if(countCharLabel>32)
			return 80.0f;
		else if(countCharLabel>16)
			return 60.0f;
		else
			return 40.0f;
	}
	else
	{
		if(countCharLabelValue>42)
			return 80.0f;
		else if(countCharLabelValue>21)
			return 60.0f;
		else
			return 40.0f;
	}
}
//Calculating label height... caling from cell for row at index path.. to display the text in table view...
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay:(int)displayType
{
	return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
	CGFloat rowHeight;
    
    int total_arrayc = 7 - [TableData count];
    
   
    /*old commented by selvan on 21/02/2013 for status
     
    if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"] && (indexPath.row == (16-total_arrayc) || indexPath.row == 6))
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"] && indexPath.row == 8)
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"] && indexPath.row == (15-total_arrayc))
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"] && indexPath.row == 7)
        rowHeight = 115.0f;
    else if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]  isEqualToString:@"Accepted"]) && !([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"]) && indexPath.row == (14-total_arrayc))
        rowHeight = 115.0f;
    else if(indexPath.row == 0 && !(errStatus))
        rowHeight = 115.0f;
    else if(indexPath.row == 0 && (errStatus))
        rowHeight = 170.0f;
    else if (([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Ready"] || [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString: @"Deferred - no parts"] || [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString: @"Completed"] ) && indexPath.row == 6)
        rowHeight = 115.0f;
    else
        rowHeight = 45.0f;
    
    */
    if(([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound) && (indexPath.row == (20-total_arrayc) || indexPath.row == 7))
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound && indexPath.row == 12)
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && indexPath.row == (19-total_arrayc))
        rowHeight = 115.0f;
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && indexPath.row == 11)
        rowHeight = 115.0f;
    else if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound) && !([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound) && indexPath.row == (18-total_arrayc))
        rowHeight = 300.0f;
    else if(indexPath.row == 0 && !(errStatus))
        rowHeight = 115.0f;
    else if(indexPath.row == 0 && (errStatus))
        rowHeight = 170.0f;
    else if (( [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location == NSNotFound && [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location == NSNotFound ) && indexPath.row == 10)
        rowHeight = 115.0f;
    else
        rowHeight = 45.0f;
 
    
    
    
    
    
	return rowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    int total_arrayc = 7 - [TableData count];
	
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)
	{
		return 20-total_arrayc;
	}
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound) {
        return 19-total_arrayc;
    }
    
	return 19-total_arrayc;
    
    
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    int row_index = indexPath.row + 1;
    
    //if(row_index  == 1 || row_index ==11 || row_index == 12)
    if (row_index == 1 || rowIndex == row_index-1)
    {
        //cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
//        if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"] && row_index == 11)
//            cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
        
        
        if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && row_index == 15)
            cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
        
    }
    else
        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    
    
    //check estimated arrival time
    CurrentDateTime *objCurrentDateTime = [[CurrentDateTime alloc] init];
    NSString *strETA1;
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] ||[[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@""])) {
        
        strETA1 = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]];
        
    }
    
    else
        
        strETA1 = [NSString stringWithFormat:@"%@ %@",[objCurrentDateTime currentdate],@"00:00:00"];
    
    
    [objCurrentDateTime release];
    
    
    if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && row_index == 7 && (ChkPopUpMenu))
        [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:cell.bounds tableCell:cell:strETA1];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    float _framewidth = self.view.frame.size.width;
    //Change tableview background color
    tableView.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    
    
   /* static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }*/
    UITableViewCell *cell = (UITableViewCell*)[self.myTableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            }
    
     
	
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //check estimated arrival time
    CurrentDateTime *objCurrentDateTime = [[CurrentDateTime alloc] init];
    
    
    NSString *strETA1;
    if(!([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] ||[[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"] isEqualToString:@""])) {
        
        strETA1 = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]];
        
    }
    
    else
        
        strETA1 = [NSString stringWithFormat:@"%@ %@",[objCurrentDateTime currentdate],@"00:00:00"];
    [objCurrentDateTime release];
    
    // NSLog(@"The Current Date ::::::: %@",strETA1);
    
    
    //Relase textfields
    //[txtStatus release],txtStatus = nil;
    //[txtReason release],txtReason = nil;
    //[txtTimeZone release], txtTimeZone = nil;
    
    // UILabel *label = (UILabel *)[tableviewCell.contentView viewWithTag:100];
    NSLog(@"task list %@",objServiceManagementData.taskDataDictionary );
    
	if(indexPath.section == 0 && IS_IPAD)
	{
        
        //ERASE SEPARATER
        tableView.separatorColor = [UIColor clearColor];
        
        //If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
        
        int total_count = indexPath.row - service_count;
        int flag = 0;
        
        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)
        {
            
            if(total_count < 5)
                service_count =0;
            else
                service_count =2;
            
            
            switch (indexPath.row) {
                    
                case 5: {
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@"");
                    [cell.contentView addSubview:commonLabel];
                    ////[commonLabel release], commonLabel = nil;
                    
                    
                    
                    //Set default reason as other
                    
                    if([[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@""])
                        [objServiceManagementData.taskDataDictionary setObject:@"Other" forKey:@"REASON"];
                    
                    
                    
                    CGRect frame2 = CGRectMake(188, 5.0, 155.0, 35.0);
					txtReason = [[[UITextField alloc] initWithFrame:frame2] autorelease];
					txtReason.borderStyle =  UITextBorderStyleRoundedRect;
					txtReason.textColor = [UIColor blackColor];
					txtReason.font = [UIFont systemFontOfSize:12.0];
					txtReason.backgroundColor = [UIColor lightGrayColor];
                    
					
					txtReason.keyboardType = UIKeyboardTypeDefault;
					txtReason.returnKeyType = UIReturnKeyDone;
					txtReason.placeholder = @"Click to Select a Reason";
					txtReason.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtField.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtReason.enabled = FALSE;
					txtReason.text = [objServiceManagementData.taskDataDictionary objectForKey:@"REASON"];
					
					// Add an accessibility label that describes the text field.
					[txtReason setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtReason.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
					txtReason.rightViewMode = UITextFieldViewModeAlways;
					
					txtReason.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
                    
                    
					[cell.contentView addSubview:txtReason];
                    
                   
                    
                    flag = 1;
                    
                    
                    
                    break; }
                    
                case 6: {
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@"");
                    [cell.contentView addSubview:commonLabel];
                    ////[commonLabel release], commonLabel = nil;
                    
                    
                    
                    taskReason = [Design textViewFormation:188.0 :5.0 :_framewidth-220 :97.0 :2 :self];
                    taskReason.layer.masksToBounds = YES;
                    taskReason.layer.cornerRadius = 2.0;
                    taskReason.layer.borderWidth = 0.5;
                    //taskReason.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    taskReason.layer.borderColor = [UIColor blackColor].CGColor;
                    
                    if(([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)&&[[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@"Other" ])
                    {
                        cell.userInteractionEnabled = TRUE;
                        taskReason.text = [objServiceManagementData.taskDataDictionary valueForKey:@"REASON_DESCRIPTION"];
                    }
                    else {
                        cell.userInteractionEnabled = FALSE;
                        taskReason.text = @"";
                        [objServiceManagementData.taskDataDictionary setObject:@"" forKey:@"REASON_DESCRIPTION"];
                    }
                    
                    [cell.contentView addSubview:taskReason];
                    
                    
                    flag = 1;
                    service_count = 2;
                    
                    break;
                }
                    
                    
            }
            
            
        }
        //COMMENTED BY SELVAN ON 04/04/2013
                //        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound) {
                //            
                //            switch (indexPath.row) {
                //                    
                //                case 6: {
                //                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Estimated",@""):1]:16.0f :1];
                //					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Estimated",@"");
                //					[cell.contentView addSubview:commonLabel];
                //					//[commonLabel release], commonLabel = nil;
                //					
                //					
                //					commonLabel = [Design LabelFormation:188.0 :5.0 :155.0 :[self labelHeightCalculation:strETA1:2]:15.0f :2];
                //					commonLabel.text = strETA1;
                //                    [cell.contentView addSubview:commonLabel];
                //					//[commonLabel release], commonLabel = nil;
                //                    ChkPopUpMenu = NO;
                //                    
                //                    
                //                    
                //                    
                //                    flag = 1;
                //                    service_count = 1;
                //                    
                //					break;
                //                }
                //                    
                //                    
                //                    
                //            }
                //        
                //            
                //            
                //            if(total_count < 6)
                //                service_count =0;
                //            else
                //                service_count =1;
                //            
                //            
                //        }
        //END
        
        //NSLog(@"Table title %@", TableTitle);
        
        if (flag == 0)
        {
            
            // int TableC = 7 - [TableData count];
            NSString *title;
            
            
			switch (total_count) {
                case 0:
                    
                    /*CGSize s = [[UIScreen mainScreen] bounds].size;
                     width = s.width;
                     height = s.height;
                     
                     UIScreen *screen = [UIScreen mainScreen];
                     [myView setFrame:[screen applicationFrame]];
                     */
                    NSLog(@"width %f",self.view.frame.size.width);
                    cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                    /*detailsTask = [Design textViewFormation:10.0 :5.0 :self.view.frame.size.width - 20 :80.0 :1 :self];
                     detailsTask.backgroundColor = [UIColor clearColor];
                     detailsTask.textColor = [UIColor blackColor];
                     
                     detailsTask.layer.masksToBounds = YES;
                     detailsTask.layer.cornerRadius = 8.0;
                     detailsTask.layer.borderWidth = 0.5;
                     detailsTask.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                     
                     
                     detailsTask.text = [NSString stringWithFormat:@"Service Location \n%@ %@\n%@\n%@, %@, %@, %@",
                     
                     [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"REGIO"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"]
                     ];
                     
                     cell.userInteractionEnabled = FALSE;
                     
                     [cell.contentView addSubview:detailsTask];*/
                    
                    
                    //Standard Header details cgrect
                    CGRect rectView= CGRectMake(29, 2, self.Service_Task_SV.frame.size.width-60, 108);
                    
                    
                    //Display Error details
                    if ([objServiceManagementData.errorlistArray count]>0) {
                        
                        //Create view for error text display
                        CGRect erectView= CGRectMake(29, 2, self.Service_Task_SV.frame.size.width-60, 55.0);
                        UIView *eheaderView1 = [[UIView alloc] initWithFrame:erectView];
                        //[eheaderView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                        [eheaderView1 setBackgroundColor:[UIColor blackColor]];
                        eheaderView1.layer.masksToBounds = YES;
                        eheaderView1.layer.cornerRadius = 8.0;
                        eheaderView1.layer.borderWidth = 1.0f;
                        eheaderView1.layer.borderColor = [UIColor blackColor].CGColor;
                        
                        //Display Header line one and two
                        UILabel *elblHeader1;
                        elblHeader1 = [Design LabelFormationWithColor:2.0 :0.0 :self.view.frame.size.width-10 :25:16.0f :1];
                        elblHeader1.text = @"Update Error Notification";
                        elblHeader1.font = [elblHeader1.font fontWithSize:14.0f];
                        [eheaderView1 addSubview:elblHeader1];
                        //[elblHeader1 release]; elblHeader1 =nil;
                        
                        //Display Header line one and two
                        UILabel *elblHeader2;
                        elblHeader2 = [Design LabelFormationMultiWithColorGray:2.0 :22.0 :self.Service_Task_SV.frame.size.width-100 :50:16.0f :2];
                        elblHeader2.text = [[objServiceManagementData.errorlistArray objectAtIndex:0] objectForKey:@"errdesc"];
                        elblHeader2.font = [elblHeader2.font fontWithSize:14.0f];
                        [eheaderView1 addSubview:elblHeader2];
                        //[elblHeader2 release]; elblHeader2 =nil;
                        
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:eheaderView1];
                        [eheaderView1 release]; eheaderView1 = nil;
                        //If error then change header x y position
                        rectView= CGRectMake(29, 60, self.Service_Task_SV.frame.size.width-60, 108);
                    }
                    
                    UIView *headerView1 = [[UIView alloc] initWithFrame:rectView];
                    //[headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                    [headerView1 setBackgroundColor:[UIColor clearColor]];
                    headerView1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    headerView1.layer.masksToBounds = YES;
                    headerView1.layer.cornerRadius = 8.0;
                    headerView1.layer.borderWidth = 1.0f;
                    //headerView1.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    headerView1.layer.borderColor = [UIColor blackColor].CGColor;
                    
                    //Biren- 9th feb
                    UIImage *dd = [UIImage imageNamed:@"dd.png"];
                    
                    UIButton *ddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [ddBtn setFrame:CGRectMake(650.0f, 35.0f, 45.0f, 40.0f)];
                    [ddBtn setBackgroundImage:dd forState:UIControlStateNormal];
                    // [ddBtn setEnabled:YES];
                    [ddBtn setUserInteractionEnabled:YES];
                    [ddBtn addTarget:self action:@selector(loadWebMap) forControlEvents:UIControlEventTouchUpInside];
                    
                    [headerView1 addSubview:ddBtn];
                 
                    //end
                    
                    //Display Header line one and two
                    //UITextField *txtHeader1,*txtHeader2;
                    //UILabel *lblHeader1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, self.view.frame.size.width-20, 30)];
                    UILabel *lblHeader1;
                    lblHeader1 = [Design LabelFormationWithColor:2.0 :0.0 :_framewidth-500 :35:16.0f :1];
                    lblHeader1.text = [NSString stringWithFormat:@"Service Location"];
                    //lblHeader1.adjustsFontSizeToFitWidth=YES;
                    lblHeader1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader1.font = [lblHeader1.font fontWithSize:14.0f];
                    [headerView1 addSubview:lblHeader1];
                    //[lblHeader1 release]; lblHeader1 =nil;
                    
                    
                    //UILabel *lblHeader2 = [[UILabel alloc] initWithFrame:CGRectMake(2,32, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader2;
                    lblHeader2 = [Design LabelFormationWithColor:2.0 :32.0 :_framewidth-500 :25:16.0f :2];
                    
                    lblHeader2.text = [NSString stringWithFormat:@"%@ %@; %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NICKNAME"]];
                    
                    
                    ////lblHeader2.adjustsFontSizeToFitWidth=YES;
                    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader2.font = [lblHeader2.font fontWithSize:14.0f];
                    [headerView1 addSubview:lblHeader2];
                    //[lblHeader2 release]; lblHeader2 =nil;
                    
                    //UILabel *lblHeader3 = [[UILabel alloc] initWithFrame:CGRectMake(2,58, self.view.frame.size.width-20, 25)];
                   // UILabel *lblHeader3;
                    lblHeader2 = [Design LabelFormationWithColor:2.0 :56.0 :_framewidth-500 :25:16.0f :2];
                    lblHeader2.text = [NSString stringWithFormat:@"%@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"]];
                    //lblHeader3.adjustsFontSizeToFitWidth=YES;
                    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader2.font = [lblHeader2.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader2];
                    //[lblHeader3 release]; lblHeader3 =nil;
                    
                    //UILabel *lblHeader4 = [[UILabel alloc] initWithFrame:CGRectMake(2,84, self.view.frame.size.width-20, 25)];
                   // UILabel *lblHeader4;
                    lblHeader2 = [Design LabelFormationWithColor:2.0 :77.0 :_framewidth-500 :25:16.0f :2];
                    
                    lblHeader2.text = [NSString stringWithFormat:@"%@, %@, %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"]];
                    //lblHeader4.adjustsFontSizeToFitWidth=YES;
                    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader2.font = [lblHeader2.font fontWithSize:14.0f];
                    [headerView1 addSubview:lblHeader2];
                    //[lblHeader4 release]; lblHeader4 =nil;
                    
                    
                    cell.userInteractionEnabled = TRUE;
                    [cell.contentView addSubview:headerView1];
                    [headerView1 release];headerView1=nil;
                    
                    
                    break;
                    
                    
                case 1:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Category",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    break;
                    
                case 2:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_serordertype",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_serordertype",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    NSString *strProcessType = [NSString stringWithFormat:@"%@ (%@)",[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE_DESCR"],[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]:2]:15.0f :2];
                    commonLabel.text = strProcessType;
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    break;
                    
                    
                case 3:
                    /*        Original code commented On Sep 19 2016
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Priority",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"];
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                     */
                    
                    //added On Sep 19 2016
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_SetType",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_SetType",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    
                    CGRect frame0 = CGRectMake(188, 5.0, 200.0, 35.0);
					txtStatus = [[[UITextField alloc] initWithFrame:frame0] autorelease];
					txtStatus.borderStyle =  UITextBorderStyleRoundedRect;
					txtStatus.textColor = [UIColor blackColor];
					txtStatus.font = [UIFont systemFontOfSize:15.0];
					//txtStatus.backgroundColor = [UIColor lightGrayColor];
                    txtStatus.backgroundColor = [UIColor whiteColor];
                    
					
					txtStatus.keyboardType = UIKeyboardTypeDefault;
					txtStatus.returnKeyType = UIReturnKeyDone;
					
					txtStatus.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtStatus.enabled = FALSE;
                    NSString *joinString = [NSString stringWithFormat:@"%@ (%@)",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE_TXT"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE"]];
                    
					txtStatus.text = joinString ;
					
					// Add an accessibility label that describes the text field.
					[txtStatus setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtStatus.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
                    
					txtStatus.rightViewMode = UITextFieldViewModeAlways;
					
					txtStatus.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtStatus];


                    
                    break;
                    
                    
                case 4:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Status",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    CGRect frame1 = CGRectMake(188, 5.0, 200.0, 35.0);
					txtStatus = [[[UITextField alloc] initWithFrame:frame1] autorelease];
					txtStatus.borderStyle =  UITextBorderStyleRoundedRect;
					txtStatus.textColor = [UIColor blackColor];
					txtStatus.font = [UIFont systemFontOfSize:15.0];
					//txtStatus.backgroundColor = [UIColor lightGrayColor];
                    txtStatus.backgroundColor = [UIColor whiteColor];

					
					txtStatus.keyboardType = UIKeyboardTypeDefault;
					txtStatus.returnKeyType = UIReturnKeyDone;
					
					txtStatus.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtStatus.enabled = FALSE;
					txtStatus.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"];
					
					// Add an accessibility label that describes the text field.
					[txtStatus setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtStatus.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
                    
					txtStatus.rightViewMode = UITextFieldViewModeAlways;
					
					txtStatus.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtStatus];
                    
                    
					break;
                    
                    
                case 5:
                    
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Due",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    commonLabel = [Design LabelFormation:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"];
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    break;
                    
                case 6:
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Estimated",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Estimated",@"");
					[cell.contentView addSubview:commonLabel];
					//[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:188.0 :5.0 :155.0 :[self labelHeightCalculation:strETA1:2]:15.0f :2];
					commonLabel.text = strETA1;
                    [cell.contentView addSubview:commonLabel];
                    
					break;
                    

                case 7:
                    
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Result",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Result",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    
                    
                    CGRect frame2 = CGRectMake(188, 5.0, 200.0, 35.0);
					self.txtResult = [[[UITextField alloc] initWithFrame:frame2] autorelease];
					self.txtResult.borderStyle =  UITextBorderStyleRoundedRect;
					self.txtResult.textColor = [UIColor blackColor];
					self.txtResult.font = [UIFont systemFontOfSize:15.0];
					//self.txtResult.backgroundColor = [UIColor lightGrayColor];
                    self.txtResult.backgroundColor = [UIColor whiteColor];
					
					self.txtResult.keyboardType = UIKeyboardTypeDefault;
					self.txtResult.returnKeyType = UIReturnKeyDone;
					
					self.txtResult.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					self.txtResult.enabled = FALSE;
					self.txtResult.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZRESULT"];
					
					// Add an accessibility label that describes the text field.
					[self.txtResult setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					self.txtResult.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
                    
					self.txtResult.rightViewMode = UITextFieldViewModeAlways;
					
					self.txtResult.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:self.txtResult];
                    
                    break;
                case 8:
                    
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Result_Value",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Result_Value",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    CGRect frame3 = CGRectMake(188, 5.0, 200.0, 35.0);
					self.txtResultValue = [[[UITextField alloc] initWithFrame:frame3] autorelease];
					self.txtResultValue.borderStyle =  UITextBorderStyleRoundedRect;
					self.txtResultValue.textColor = [UIColor blackColor];
					self.txtResultValue.font = [UIFont systemFontOfSize:15.0];
                    //self.txtResultValue.backgroundColor = [UIColor lightGrayColor];
                    self.txtResultValue.backgroundColor = [UIColor whiteColor];
					
					self.txtResultValue.keyboardType = UIKeyboardTypeDefault;
					self.txtResultValue.returnKeyType = UIReturnKeyDone;
					
					self.txtResultValue.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					self.txtResultValue.enabled = FALSE;
					self.txtResultValue.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZRESULTTYPE"];
					
					// Add an accessibility label that describes the text field.
					[self.txtResultValue setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					self.txtResultValue.rightView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]] autorelease];
                    
					self.txtResultValue.rightViewMode = UITextFieldViewModeAlways;
					
					self.txtResultValue.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:self.txtResultValue];
                    
                    
                    if ([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZRESULTTYPE"] isEqualToString:@"Select Result Type"])
                        cell.userInteractionEnabled = NO;
                    else
                        cell.userInteractionEnabled = YES;
                    
                    
                    break;
                case 9:
                    
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Contract",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Contract",@"");
                    [cell.contentView addSubview:commonLabel];
                    //[commonLabel release], commonLabel = nil;
                    
                    self.contract_value = [Design textFieldFormation:188.0 andY:5.0 andWidth:200.0  andHeight:37.0 withTag:2 sender:self];
                    self.contract_value.layer.masksToBounds = YES;
                    self.contract_value.layer.cornerRadius = 2.0;
                    self.contract_value.layer.borderWidth = 0.5f;
                    self.contract_value.layer.borderColor = [UIColor blackColor].CGColor;
                    self.contract_value.textAlignment = UITextAlignmentRight;
                    self.contract_value.backgroundColor = [UIColor whiteColor];
                    [self.contract_value setKeyboardType:UIKeyboardTypeNumberPad];
                    cell.userInteractionEnabled = TRUE;
                    self.contract_value.text = [objServiceManagementData.taskDataDictionary valueForKey:@"ZZCONTRACT_VALUE"];
                    
                    [cell.contentView addSubview:self.contract_value];

                    break;


                case 10:
                                        
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Note",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Note",@"");
					[cell.contentView addSubview:commonLabel];
					//[commonLabel release], commonLabel = nil;
                    
                    taskNotes = [Design textViewFormation:188.0 :5.0 :_framewidth-220  :97.0 :2 :self];
                    taskNotes.layer.masksToBounds = YES;
                    taskNotes.layer.cornerRadius = 2.0;
                    taskNotes.layer.borderWidth = 0.5f;
                    //taskNotes.layer.borderColor = [[UIColor colorWithHue:1.0 saturation:1.5 brightness:0.75 alpha:1.0] CGColor];
                    taskNotes.layer.borderColor = [UIColor blackColor].CGColor;
                    cell.userInteractionEnabled = TRUE;
                    taskNotes.text = [objServiceManagementData.taskDataDictionary valueForKey:@"ZZFIELDNOTE"];
                    
                    [cell.contentView addSubview:taskNotes];
                    
                    break;
                    
                case 11:
                    
                    
                    if([[TableTitle objectAtIndex:0] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                    
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                        [cell.contentView addSubview:[self createDetailContent]];
                        
                        
                        rowIndex = indexPath.row;
                        
                        
                        
                     }
                    else {
                        
                        title = [TableTitle objectAtIndex:0];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-500 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]];
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                    }
                    
                    
                    
                    break;
                case 12:
                    
                    if([[TableTitle objectAtIndex:1] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                       [cell.contentView addSubview:[self createDetailContent]];                        
                      
                        rowIndex = indexPath.row;
                        
                    }
                    else {
                        //Telephone Number
                        title = [TableTitle objectAtIndex:1];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        
                        /* commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]]:2]:15.0f :2];
                         commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]];
                         [cell.contentView addSubview:commonLabel];
                         //[commonLabel release], commonLabel = nil;*/
                        
                       
                                               
                            //Create view for Header text display
                            CGRect rectView= CGRectMake(188.0,5.0,200, 41);
                            UIView *customView = [[[UIView alloc] initWithFrame:rectView] autorelease];
                            [customView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                            [customView setBackgroundColor:[UIColor clearColor]];
                            
                            customView.layer.borderWidth = 0.0f;
                            // customView.layer.borderColor = [UIColor clearColor];
                            
                            UILabel *lblValue;
                            lblValue = [Design LabelFormationWithColor:2.0 :0.0 :150.0 :35:16.0f :2];
                            lblValue.text = [NSString stringWithFormat:@"%@",[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]]];
                            //lblValue.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                            lblValue.font = [lblValue.font fontWithSize:14.0f];
                            [customView addSubview:lblValue];
                             if ([title isEqualToString:@"Edit_Task_Label_Telno"]) {
                                UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                telButton.frame = CGRectMake(152.0, 2.0, 30, 30);
                                [telButton setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
                                [telButton addTarget:self action:@selector(dailNumber1) forControlEvents: UIControlEventTouchUpInside];
                                [customView addSubview:telButton];
                             }
                            [cell.contentView addSubview:customView];
                        
                                                    
                        
                    }
                    
                    break;
                    
                case 13:
                    
                    if([[TableTitle objectAtIndex:2] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                       [cell.contentView addSubview:[self createDetailContent]];
                        
                        rowIndex = indexPath.row;
                        
                      //[cell.contentView addSubview:[self createItemNavigationBut]];
                        
                    }
                    else {
                        //Alternative Telephone number
                        title = [TableTitle objectAtIndex:2];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        
                        /*commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]]:2]:15.0f :2];
                         commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]];
                         
                         [cell.contentView addSubview:commonLabel];
                         //[commonLabel release], commonLabel = nil;*/
                        
                        //Create view for Header text display
                        CGRect rectView= CGRectMake(188.0,5.0, 200, 41);
                        UIView *customView1 = [[[UIView alloc] initWithFrame:rectView] autorelease];
                        [customView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                        [customView1 setBackgroundColor:[UIColor clearColor]];
                        
                        customView1.layer.borderWidth = 0.0f;
                        // customView.layer.borderColor = [UIColor clearColor];
                        
                        UILabel *lblValue;// = [[UILabel alloc] init];
                        lblValue = [Design LabelFormationWithColor:2.0 :0.0 :150.0 :35:16.0f :2];
                        lblValue.text = [NSString stringWithFormat:@"%@",[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]]];
                        //lblValue.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                        lblValue.font = [lblValue.font fontWithSize:14.0f];
                        [customView1 addSubview:lblValue];
                        
                        
                        if ([title isEqualToString:@"Edit_Task_Label_Atelno"]) {
                            UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            telButton.frame = CGRectMake(153.0, 2.0, 30, 30);
                            [telButton setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
                            [telButton addTarget:self action:@selector(dailNumber1) forControlEvents: UIControlEventTouchUpInside];
                            [customView1 addSubview:telButton];
                        }
                        
                        [cell.contentView addSubview:customView1];
                        //[customView release];
                        //[lblValue release];
                        
                    }
                    
                    break;
                    
                    
                case 14:
                    
                    
                    if([[TableTitle objectAtIndex:3] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                       [cell.contentView addSubview:[self createDetailContent]];
                        
                        rowIndex = indexPath.row;
                        
                        
                        //[cell.contentView addSubview:[self createItemNavigationBut]];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:3];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]];
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                    }
                    
                    break;
                    
                case 15:
                    
                    if([[TableTitle objectAtIndex:4] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                        [cell.contentView addSubview:[self createDetailContent]];
                        rowIndex = indexPath.row;
                        
                  
                        //[cell.contentView addSubview:[self createItemNavigationBut]];

                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:4];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]];
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                    }
                    break;
                    
                case 16:
                    
                    if([[TableTitle objectAtIndex:5] isEqualToString:@"Other Details"])
                    {
                        
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                        [cell.contentView addSubview:[self createDetailContent]];
                        rowIndex = indexPath.row;
                        
                        
                        //[cell.contentView addSubview:[self createItemNavigationBut]];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:5];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]];
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                    }
                    break;
                    
                    
                case 17:
                    
                    
                    if([[TableTitle objectAtIndex:6] isEqualToString:@"Other Details"])
                    {
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                        [cell.contentView addSubview:[self createDetailContent]];
                        
                          rowIndex = indexPath.row;
                        
                      //[cell.contentView addSubview:[self createItemNavigationBut]];

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:6];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]];
                        [cell.contentView addSubview:commonLabel];
                        //[commonLabel release], commonLabel = nil;
                        
                        
                        break;
                        
                        
                case 18:
                        
                        
                        rowIndex = indexPath.row;
                        cell.userInteractionEnabled = TRUE;
                        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
                        [cell.contentView addSubview:[self createDetailContent]];
                        
                        
                        //[cell.contentView addSubview:[self createItemNavigationBut]];

                        break;
                        
                        
                        
                    }
            } //End of block while Status is Declined and that time  'Select a reason' and 'Enter the reason' block will displayed..
       		
        }
        
    }

    return cell;
}
//Load Service Note view
-(void)loadNoteView {
    
    //Service Task  SO#  Customer Name - Service Note
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    objServiceManagementData.serviceNoteViewTitle = [NSString stringWithFormat:@"Service Task %@ %@ %@ %@ - Service Note", [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"], [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                                                     [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"],
                                                     [objServiceManagementData.taskDataDictionary objectForKey:@"NICKNAME"]];
    

    
    
    ServiceNoteExpand *objServiceNoteExpand;
    if (IS_IPHONE) {
        objServiceNoteExpand = [[ServiceNoteExpand alloc] initWithNibName:@"ServiceNoteExpand_iphone" bundle:nil];
        [self.navigationController pushViewController:objServiceNoteExpand animated:YES];
        [objServiceNoteExpand release],objServiceNoteExpand = nil;
    }
    else{
        objServiceNoteExpand = [[ServiceNoteExpand alloc] initWithNibName:@"ServiceNoteExpand" bundle:nil];
        [self.navigationController pushViewController:objServiceNoteExpand animated:YES];
        [objServiceNoteExpand release],objServiceNoteExpand = nil;
    }
}

//Method for LOADING MAP

-(void)loadWebMap {
    
    MapViewController *map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:map];
    navController.modalInPopover=YES;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modalViewDone)];
    map.navigationItem.rightBarButtonItem = doneBarButton;
    map.navigationItem.title = @"Map";
    
    //Route btn code
    UIBarButtonItem *route = [[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStyleBordered target:self action:@selector(navigateToRouteView)];
    map.navigationItem.leftBarButtonItem = route;
    
    map.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //    map.view.superview.frame = CGRectMake(70, 70, 600, 600);
    
    [doneBarButton release];
    [route release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    [navController release],navController =nil;
    
}

//METHOD FOR DISMISSING present modal MAP View
- (void)modalViewDone {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)navigateToRouteView {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showRoute" object:nil];
}


-(UIView *)createDetailContent {
    
    UIView *headerView21;
    UIView *headerView22;
     UIView *headerView2;
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    BOOL _dispNote = FALSE;
    BOOL _discrip = FALSE;
    float h1y;
    
    
    //Create view for Header text display
    CGRect rectView;
    if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DESCRIPTION"] isEqualToString:@""]){
        rectView = CGRectMake(29, 2, self.view.frame.size.width-60, 225);
        h1y = 65.0;
        _discrip = TRUE;
    }
    else {
        rectView = CGRectMake(29, 2, self.view.frame.size.width-60, 125);
        h1y = 2.0;
        _discrip = FALSE;
    }
    
    headerView22 = [[UIView alloc] initWithFrame:rectView];
    //[headerView22 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView22 setBackgroundColor:[UIColor clearColor]];
    [headerView22 setUserInteractionEnabled:TRUE];
    
    CGRect rectView2;
    if([[objServiceManagementData.taskDataDictionary objectForKey:@"NOTE"] isEqualToString:@""]){
      //  rectView2= CGRectMake(2, h1y, self.view.frame.size.width-60, 144);  original code commented On Sep 19 2016
        rectView2= CGRectMake(2, h1y, self.view.frame.size.width-60, 124);     // added on sep 19 2016
        _dispNote = FALSE;
    }
    else {
       //  rectView2= CGRectMake(2, h1y, self.view.frame.size.width-60, 224);      original code commented On Sep 19 2016
        rectView2= CGRectMake(2, h1y, self.view.frame.size.width-60, 204);       // added on sep 19 2016
        _dispNote = TRUE;
    }
    
    headerView2 = [[UIView alloc] initWithFrame:rectView2];
    //[headerView2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView2 setBackgroundColor:[UIColor clearColor]];
    headerView2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    headerView2.layer.masksToBounds = YES;
    headerView2.layer.cornerRadius = 8.0;
    headerView2.layer.borderWidth = 1.0f;

    
    //Display Header line one and two
    UILabel *lblHeader11;// = [[UILabel alloc] init];
    lblHeader11 = [Design LabelFormationWithColor:2.0 :0.0 :self.view.frame.size.width-100 :35:16.0f :1];
    lblHeader11.text = [NSString stringWithFormat:@"Other Details"];
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader11];
    //[lblHeader11 release]; lblHeader11 = nil;
    
    
    //UILabel *lblHeader12;// = [[UILabel alloc] init];
    lblHeader11 = [Design LabelFormationWithColor:2.0 :30.0 :self.view.frame.size.width-100 :25:16.0f :2];
    lblHeader11.text = [NSString stringWithFormat:@"Customer# %@",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"]];
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader11];
    //[lblHeader12 release]; lblHeader12 = nil;
    
   /*  Original code commented On sep 19 2016
    //DISPLAY SET TYPE ADDED ON 09/04/2013 BY SELVAN
    lblHeader11 = [Design LabelFormationWithColor:2.0 :54.0 :self.view.frame.size.width-100 :25:16.0f :2];
    lblHeader11.text = [NSString stringWithFormat:@"Set Type: %@ (%@)",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE_TXT"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE"]];
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader11];
    
    
    */
    
    //UILabel *lblHeader13;// = [[UILabel alloc] init];
    //lblHeader11 = [Design LabelFormationWithColor:2.0 :78.0 :self.view.frame.size.width-100 :35:16.0f :1];  Original code commented On sep 19 2016
    lblHeader11 = [Design LabelFormationWithColor:2.0 :54.0 :self.view.frame.size.width-100 :35:16.0f :1];    // added on sep 19 2016
    lblHeader11.text = [NSString stringWithFormat:@"Service Item"];
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader11];
    //[lblHeader13 release]; lblHeader13 = nil;
    
    
    //UILabel *lblHeader14;// = [[UILabel alloc] init];
    //lblHeader11 = [Design LabelFormationWithColor:2.0f :106.0f :self.view.frame.size.width-100 :25:16.0f :2];    Orginal code commented on sep 19 2016
     lblHeader11 = [Design LabelFormationWithColor:2.0f :82.0f :self.view.frame.size.width-100 :25:16.0f :2];    // added on sep 19 2016
    if ([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCT"] isEqualToString:
         [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCTDESCR"]]) {
        lblHeader11.text = [NSString stringWithFormat:@"%@ - %@",
                            [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                            [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCT"]
                            ];

    }
    else {
    lblHeader11.text = [NSString stringWithFormat:@"%@ - %@ %@",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCT"],
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCTDESCR"]];
    }
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:12.0f];
    [headerView2 addSubview:lblHeader11];
    //[lblHeader14 release]; lblHeader14 = nil;
    
   
    if (_dispNote) {
        
        headerView2.userInteractionEnabled = TRUE;
        
        UILabel *lblHeader15;
      //  lblHeader15 = [Design LabelFormationWithColor:2.0 :131.0 :self.view.frame.size.width-100 :35:16.0f :1]; Original code commented On sep 19 2016
         lblHeader15 = [Design LabelFormationWithColor:2.0 :110.0 :self.view.frame.size.width-100 :35:16.0f :1];    // added on sep 19 2016
        lblHeader15.text = [NSString stringWithFormat:@"Service Note"];
        lblHeader15.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        lblHeader15.font = [lblHeader15.font fontWithSize:14.0f];
        [headerView2 addSubview:lblHeader15];

       // lblHeader15 = [Design LabelFormationWithColor:2.0 :155.0 :self.view.frame.size.width-100 :35:16.0f :2];    Original code commented On sep 19 2016
        lblHeader15 = [Design LabelFormationWithColor:2.0 :138.0 :self.view.frame.size.width-100 :35:16.0f :2];      // added on sep 19 2016
        lblHeader15.numberOfLines = 5;
        lblHeader15.text = [NSString stringWithFormat:@"%@",
                            [objServiceManagementData.taskDataDictionary objectForKey:@"NOTE"]];
        lblHeader15.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        lblHeader15.font = [lblHeader15.font fontWithSize:14.0f];
        [headerView2 addSubview:lblHeader15];

        //copy service note value for service note detail page
        objServiceManagementData.serviceNote = [objServiceManagementData.taskDataDictionary objectForKey:@"NOTE"];
        
        UIButton *butMoreNote = [UIButton buttonWithType:UIButtonTypeCustom];
        [butMoreNote setFrame:CGRectMake(630.0f, 180.0f, 65.0f, 5.0f)];
        [butMoreNote setTitle:@"More..." forState:UIControlStateNormal];
        [butMoreNote.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        [butMoreNote setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [butMoreNote setUserInteractionEnabled:YES];
        [butMoreNote addTarget:self action:@selector(loadNoteView) forControlEvents:UIControlEventTouchUpInside];
        [headerView2 addSubview:butMoreNote];
 
    }
    
    CGRect rectView1 = CGRectMake(2, 2, self.view.frame.size.width-60, 60.0f);
    
    //Display Header line one and two
    headerView21 = [[UIView alloc] initWithFrame:rectView1];
    //[headerView21 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView21 setBackgroundColor:[UIColor clearColor]];
    headerView21.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    headerView21.layer.masksToBounds = YES;
    headerView21.layer.cornerRadius = 8.0;
    headerView21.layer.borderWidth = 1.0f;
    [headerView21 setUserInteractionEnabled:TRUE];
    //headerView2.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
    //headerView21.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *lblHeader51;// = [[UILabel alloc] init];
    lblHeader51 = [Design LabelFormationWithColor:2.0 :2.0 :self.view.frame.size.width-100 :20:16.0f :1];
    lblHeader51.text = [NSString stringWithFormat:@"Service Order Description"];
    lblHeader51.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader51.font = [lblHeader51.font fontWithSize:14.0f];
    [headerView21 addSubview:lblHeader51];
    //[lblHeader51 release]; lblHeader51 = nil;
    
    
    //UILabel *lblHeader52;// = [[UILabel alloc] init];
    
    lblHeader51 = [Design LabelFormationWithColor:2.0 :24.0 :self.view.frame.size.width-100 :20:16.0f :2];
    lblHeader51.numberOfLines = 2;
    lblHeader51.text = [NSString stringWithFormat:@"%@",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"DESCRIPTION"]];
    lblHeader51.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader51.font = [lblHeader51.font fontWithSize:14.0f];
    [headerView21 addSubview:lblHeader51];
    //[lblHeader52 release]; lblHeader52 = nil;
    
    [headerView22 addSubview:headerView2];
    [headerView2 release];
    
    
    if(_discrip){
        [headerView22 addSubview:headerView21];
    }

    [headerView21 release];
    [headerView22 autorelease];
  
    return headerView22;
    
}

-(UIView *)createItemNavigationBut {
        //selvan- 18th feb
        UIView *headerView23;
        headerView23 = [[UIView alloc] initWithFrame:CGRectMake(29, 270, self.view.frame.size.width-60, 30)];
        [headerView23 setBackgroundColor:[UIColor blackColor]];
        [headerView23 setUserInteractionEnabled:TRUE];
    
        UIImage *imgPrev = [UIImage imageNamed:@"left.png"];
        UIButton *butPrev = [UIButton buttonWithType:UIButtonTypeCustom];
        [butPrev setFrame:CGRectMake(600.0f, 2.0f, 30.0f, 25.0f)];
        [butPrev setBackgroundImage:imgPrev forState:UIControlStateNormal];
        [butPrev setUserInteractionEnabled:YES];
        butPrev.enabled = TRUE;
        butPrev.tag = 1;
        [butPrev addTarget:self action:@selector(loadEditDatatoDic:) forControlEvents:UIControlEventTouchUpInside];
        [headerView23 addSubview:butPrev];
         
        
        UIImage *imgNext = [UIImage imageNamed:@"right.png"];
        UIButton *butNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [butNext setFrame:CGRectMake(650.0f, 2.0f, 30.0f, 25.0f)];
        [butNext setBackgroundImage:imgNext forState:UIControlStateNormal];
        [butNext setUserInteractionEnabled:YES];
        butNext.enabled = TRUE;
        butNext.tag = 2;
        [butNext addTarget:self action:@selector(loadEditDatatoDic:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView23 addSubview:butNext];
    
        [headerView23 autorelease];
    
        return headerView23;
    
    
    //end
    
}

-(UITextView *)DisplayTextView:(UITextView *)DtextView
{
    
    DtextView = [Design textViewFormation:5.0 :5.0 :300.0 :105.0 :3 :self];
    DtextView.backgroundColor = [UIColor clearColor];
    DtextView.textColor = [UIColor blackColor];
    
    DtextView.layer.masksToBounds = YES;
    DtextView.layer.cornerRadius = 8.0;
    DtextView.layer.borderWidth = 0.5;
    DtextView.layer.borderColor =  [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
    
    return DtextView;
    
}




//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    //Biren changes on 01/02/2013
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //********end
    
    NSLog(@"stats arry %@",objServiceManagementData.taskStatusTxtArray);
    
    NSLog(@"Index Row %d", indexPath.row);
    
    //Added on sep 19 2016
    if(indexPath.row == 3)
    {
        if ([objServiceManagementData.taskStatusTxtArray count] >0) {
            if (IS_IPHONE) {
                
                //calling picker view for iphone commented by selvan temporarly
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskSetTypeArray PickerName:@"TaskSetType"];
            }
            else if (IS_IPAD)
            {
                
                //Call ipad pickerview control
                NSMutableArray *setTypePickerArray = [[NSMutableArray alloc]init];
                NSString *pickerString = @" ";
                NSLog(@"TASK SET TYPE %@",objServiceManagementData.taskSetTypeArray);
                for(int i=0;i<[objServiceManagementData.taskSetTypeArray count];i++){
            pickerString=[NSString stringWithFormat:@"%@ (%@)",[[objServiceManagementData.taskSetTypeArray objectAtIndex:i]objectForKey:@"SETTYPE_TXT"],[[objServiceManagementData.taskSetTypeArray objectAtIndex:i]objectForKey:@"SETTYPE"]];
                    [setTypePickerArray addObject:pickerString];
                 
                }
                NSLog(@"Set type pivker array %@",setTypePickerArray);
                [pic openPickerView:tableView classObjectName:self pickerArray:setTypePickerArray PickerName:@"TaskSetType" uiElement:cell.bounds tableCell:cell];
                //********end******************
            }
        }
        
    }

    
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)
	{
        ETAPopupShowFlag = NO;
        
		if(indexPath.row == 4)
		{
            if ([objServiceManagementData.taskStatusTxtArray count] >0) {
                if (IS_IPHONE) {
                    
                    //calling picker view for iphone commented by selvan temporarly
                    [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus"];
                }
                else if (IS_IPAD)
                {
                    //Biren changes on 01/02/2013
                    //Call ipad pickerview control
                    [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
                    //********end******************
                }
            }
            
		}
		else if(indexPath.row == 5)
		{
			//calling picker view
			//[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskReasonArray PickerName:@"TaskReason"];
            
            
            if (IS_IPHONE) {
                
                //calling picker view for iphone commented by selvan temporarly
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskReasonArray PickerName:@"TaskReason"];
            }
            else if (IS_IPAD)
            {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [pic openPickerView:tableView classObjectName:self pickerArray:objStaticData.taskReasonArray PickerName:@"TaskReason" uiElement:cell.bounds tableCell:cell];
                //********end******************
            }
            
            
			
		}
   
		//else if(indexPath.row == 4)
		//{
		//	//calling picker view
		//	[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskPriorityArray PickerName:@"TaskPriority"];
        
		//}
		else if(indexPath.row == 7)
		{
            if (IS_IPHONE) {
                //calling date piker common class for iphone temporarly commented by selvan
                [datePicker datePickerView:self.myTableView :@"DueDate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
		}
        else if(indexPath.row == 8)
		{
            
            
            if (IS_IPHONE) {
                //calling date piker common class
                [datePicker datePickerView:self.myTableView :@"ETADate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
            
            
 		}
		else if(indexPath.row == 9)
		{
            if (IS_IPHONE) {
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult"];
            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult" uiElement:cell.bounds tableCell:cell];
                
            }
		}
        
        else if(indexPath.row == 10)
		{
            if (IS_IPHONE) {
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType"];
            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType" uiElement:cell.bounds tableCell:cell];
                
            }
        }
	}
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound)
    {
        if(indexPath.row == 4)
		{
            if ([objServiceManagementData.taskStatusTxtArray count] >0) {
                if (IS_IPHONE) {
                    
                    //calling picker view for iphone commented by selvan temporarly
                    [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus"];
                }
                else if (IS_IPAD)
                {
                    //Biren changes on 01/02/2013
                    //Call ipad pickerview control
                    [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
                    //********end******************
                }
            }
		}
		else if(indexPath.row == 5)
		{
            if (IS_IPHONE) {
                //calling date piker common class for iphone temporarly commented by selvan
                [datePicker datePickerView:self.myTableView :@"DueDate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
		}
        else if(indexPath.row == 6)
		{
            
            
            if (IS_IPHONE) {
                //calling date piker common class
                [datePicker datePickerView:self.myTableView :@"ETADate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
            
            
 		}
        
		else if(indexPath.row == 7)
		{
            if (IS_IPHONE) {
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult"];
            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult" uiElement:cell.bounds tableCell:cell];
                
            }
		}
        
        else if(indexPath.row == 8)
		{
            if (IS_IPHONE) {
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType"];
            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType" uiElement:cell.bounds tableCell:cell];
                
            }
        }
        
        
    }
	else {
        ETAPopupShowFlag = NO;
        
		if(indexPath.row == 4)
		{
            if ([objServiceManagementData.taskStatusTxtArray count] >0) {
                if (IS_IPHONE) {
                    
                    //calling picker view for iphone commented by selvan temporarly
                    [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus"];
                }
                else if (IS_IPAD)
                {
                    //Biren changes on 01/02/2013
                    //Call ipad pickerview control
                    
                    cellbound = cell.bounds;
                    mCell = cell;
                    ChkPopUpMenu = YES;
                    [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskStatusTxtArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
                    //********end******************
                }
            }
            
		}
		else if(indexPath.row == 5)
		{
            if (IS_IPHONE) {
                //calling date piker common class for iphone temporarly commented by selvan
                [datePicker datePickerView:self.myTableView :@"DueDate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
		}
        else if(indexPath.row == 6)
		{
            
            
            if (IS_IPHONE) {
                //calling date piker common class
                [datePicker datePickerView:self.myTableView :@"ETADate"];
            }
            else if (IS_IPAD) {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:cell.bounds tableCell:cell:@""];
                //end
            }
            
            
 		}
        
		else if(indexPath.row == 7)
		{
            if (IS_IPHONE) {
               [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult"];
                            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTxtArray PickerName:@"TaskResult" uiElement:cell.bounds tableCell:cell];

            }
        
		}
        
        else if(indexPath.row == 8)
		{
            if (IS_IPHONE) {
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType"];
            }
            else if (IS_IPAD) {
                cellbound = cell.bounds;
                mCell = cell;
                ChkPopUpMenu = NO;
                [pic openPickerView:tableView classObjectName:self pickerArray:objServiceManagementData.taskResultTypeTxtArray PickerName:@"TaskResultType" uiElement:cell.bounds tableCell:cell];
                
                NSLog(@"result type array %@",objServiceManagementData.taskResultTypeTxtArray);
            }
        }
        else if (indexPath.row == 11)
        { [self loadNoteView];}
	}
    
    
	
}

-(void) dailNumber2 {
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    [objServiceManagementData dailNumber2];
    
}

-(void) dailNumber1 {
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    [objServiceManagementData dailNumber2];
}





//Text View delegate functions Start

-(void)textViewDidBeginEditing:(UITextView *)textView {
	
	//CGPoint pt;
	//pt = self.myTableView.contentOffset;
	/*
	 if(pt.y >= 0 && pt.y <= 150){
	 if(textView == soleOwnerTextView && touchCountSecureProperty%2 != 0)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+70.0) animated:YES];
	 else if(textView == unoccupiedTextView)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+90.0) animated:YES];
	 else if(textView == propertyLentTextView)
	 [self.myTableView setContentOffset:CGPointMake(0.0, pt.y+110.0) animated:YES];
	 }
	 */
    if (textView == self.taskNotes || textView == self.taskReason )
    {
		
		_textField = textView;
        
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//Enter the reason into the dictionary..
	if(textView ==self.taskReason)
		[objServiceManagementData.taskDataDictionary setObject:[textView.text stringByReplacingOccurrencesOfString:@"'" withString:@"`"] forKey:@"REASON_DESCRIPTION"];
    else if(textView == self.taskNotes)
        [objServiceManagementData.taskDataDictionary setObject:[textView.text stringByReplacingOccurrencesOfString:@"'" withString:@"`"] forKey:@"ZZFIELDNOTE"];
	
    if (textView == self.taskNotes || textView == self.taskReason )
    {
		_textField = textView;
        
        //move the main view, so that the keyboard does not hide it.
        //if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:NO];
        }
    }
    
    
    NSLog(@"textview %@", textView);
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return FALSE;
	}
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
	//textView.text = @"";
	textView.textColor = [UIColor blackColor];
}
//End of Text View delegate functions



//Text filed delegate functions

-(void)textFielddDidBeginEditing:(UITextField *)sender {
 
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    if(textField == self.contract_value)
        [objServiceManagementData.taskDataDictionary setObject:[textField.text stringByReplacingOccurrencesOfString:@"'" withString:@"`"] forKey:@"ZZCONTRACT_VALUE"];
    
    
	[self saveData:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];	
	return TRUE;
}
//--End of delegate function of textfiled

-(void) saveData:(UITextField*)textfield {
	
	
}

//Saving the task... caling while trying to back Service Orders (Task) list page
-(void) SaveTask
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    

    if([taskReason isFirstResponder])
		[taskReason resignFirstResponder];
 
    //Alert commented by selvan on 30/01/2012 based on sree instruction
	/*
     alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit_Task_SaveTask_alert_title",@"")
     message:NSLocalizedString(@"Edit_Task_SaveTask_alert_msg",@"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"Edit_Task_SaveTask_alert_Cancel_title",@"")
     otherButtonTitles:NSLocalizedString(@"Edit_Task_SaveTask_alert_Other_title",@""),
     nil];
     alert.tag = 2; //Set the tag to tack, which alert is clicked..
     [alert show];
     
     */
    

    
    
    if(([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound) && [[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@"Other"])
    {
        if ([objServiceManagementData.taskDataDictionary valueForKey:@"REASON_DESCRIPTION"] == @"" || [[objServiceManagementData.taskDataDictionary valueForKey:@"REASON_DESCRIPTION"] length] == 0) {
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit_Task_Reason_alert_title",@"")
                                               message:NSLocalizedString(@"Edit_Task_Reason_alert_msg",@"")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Edit_Task_Reason_alert_Cancel_title",@"")
                                     otherButtonTitles:nil,nil];
            alert.tag = 55; //Set the tag to tack, which alert is clicked..
            [alert show];
            
        }
        else
        {
            //In this block caling function to update in SAP as well as sqlite
            self.view.userInteractionEnabled = FALSE;
            self.navigationItem.leftBarButtonItem.enabled = FALSE;
            
            //added new method for update service order by selvan 28/08/2012
            [self updateServiceOrder];
            
        }
    }
    else
    {
        //In this block caling function to update in SAP as well as sqlite
        self.view.userInteractionEnabled = FALSE;
        self.navigationItem.leftBarButtonItem.enabled = FALSE;
        
        //added new method for update service order by selvan 28/08/2012
        [self updateServiceOrder];
        
    }
    
//    else if ([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZRESULT" ] isEqualToString: @"Select Result"]) {
//        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit_Task_Reason_alert_title",@"")
//                                           message:NSLocalizedString(@"Edit_Task_Reason_alert_msg",@"")
//                                          delegate:self
//                                 cancelButtonTitle:NSLocalizedString(@"Edit_Task_Reason_alert_Cancel_title",@"")
//                                 otherButtonTitles:nil,nil];
//        alert.tag = 55; //Set the tag to tack, which alert is clicked..
//        [alert show];
//    }
//    else if ([[objServiceManagementData.taskDataDictionary objectForKey:@"ZZRESULTTYPE" ] isEqualToString: @"Select Result Text"])
//    {
//        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Edit_Task_Reason_alert_title",@"")
//                                           message:NSLocalizedString(@"Edit_Task_Reason_alert_msg",@"")
//                                          delegate:self
//                                 cancelButtonTitle:NSLocalizedString(@"Edit_Task_Reason_alert_Cancel_title",@"")
//                                 otherButtonTitles:nil,nil];
//        alert.tag = 55; //Set the tag to tack, which alert is clicked..
//        [alert show];
//    }

   
    
    
    
}



//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
	if(buttonIndex==0)
	{
		if(alertView.tag==3 || alertView.tag==4)
		{
			//AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
            delegate.activeApp = @"ServiceOrders";
			delegate.modifySearchWhenBackFalg = TRUE;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
		}
		else if(alertView.tag==5)
		{
			//AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
           
             delegate.activeApp = @"ServiceOrders";
			delegate.modifySearchWhenBackFalg = TRUE;
			self.view.userInteractionEnabled = TRUE;
			self.navigationItem.leftBarButtonItem.enabled = TRUE;
            if (!delegate.mErrorFlagSAP) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
		}
        else if (alertView.tag ==6)
        {
            self.view.userInteractionEnabled = TRUE;
			self.navigationItem.leftBarButtonItem.enabled = TRUE;
        }
		else {
			if (alertView.tag != 55)
            {
                if (!delegate.mErrorFlagSAP)
                {
                      delegate.activeApp = @"ServiceOrders";
                    
                    [self goBack];
                
                }
            }
		}
        
	}
	else {
		
		//In this block caling function to update in SAP as well as sqlite
		self.view.userInteractionEnabled = FALSE;
		self.navigationItem.leftBarButtonItem.enabled = FALSE;
        
        //added new method for update service order by selvan 28/08/2012
        [self updateServiceOrder];
        
        //commented and added above updateserveorder method for testing by selvan 28/08/2012
		//[self cancelDefaultAlertAndCallSAPUpdate];
		
	}
}



-(void) updateServiceOrder{
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
   // AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    delegate.ShowServiceUpdateDiagnosis = FALSE;
    
    
    NSLog(@"task edit disc selvan %@",objServiceManagementData.taskDataDictionary);
    
    //Service Order UPDATE
    NSString *responseValue;
    NSString *_soUpdateQry = @"";
    NSString *_soRsltUpdateQry1 = @"";
    NSString *_soRsltUpdateQry2 = @"";
    
    
        
    
    if ([objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"] != [NSNull null])
    {
       
        //********DELETE ERROR MESSAGES RELATED TO THIS OBJECT_ID FROM TBL_ERRORLIST TABLE
        NSString *sqlQryStr3 = [NSString stringWithFormat:@"DELETE FROM 'tbl_errorlist' WHERE apprefid = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        
        [objServiceManagementData excuteSqliteQryString:sqlQryStr3 :objServiceManagementData.gssSystemDB :@"ERRORTABLE" :1];
        //********DELETE ERROR END.
        
        
        
        NSMutableArray *_inptArray = [[[NSMutableArray alloc] init] autorelease];
        [alert dismissWithClickedButtonIndex:1 animated:YES];
        [alert release];
        
        self.updateResponseMsgArray = [[NSMutableArray alloc] init];
        //updateSucessFlag = TRUE;
        
        /* //Show processing Alert to User
         self.view.userInteractionEnabled = FALSE;
         customAlt = [[CustomAlertView alloc] init];
         [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
         */
        
        
        //Show processing Alert to User
        //float _mscreenWidth = self.view.frame.size.width;
        //float _mscreenHieght = self.view.frame.size.height;
        self.view.userInteractionEnabled = FALSE;
        customAlt = [[CustomAlertView alloc] init];
        [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(self.view.frame.size.width/2)-150 :(self.view.frame.size.height/2)-20 :140 :125.0]];
        //[customAlt release], customAlt =nil;
        
        
        objStaticData = [StaticData sharedStaticData];
        
       // NSString *statusStr = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
        
        //COMMENTED BY SELVAN ON 21/02/2012
//        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"])
//            statusStr = @"ACPT";
//        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Deferred - no parts"])
//            statusStr = @"DEFR";
//        
//        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Ready"])
//            statusStr = @"WAIT";
//        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
//            statusStr = @"RJCT";
//        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Completed"])
//            statusStr = @"COMP";
//        else
//            statusStr = @"OPEN";
        
         
        NSString *string =[objServiceManagementData.taskDataDictionary objectForKey:@"ZRESULT"];
        NSString *ZZRESULT = @"";
        NSString *ZZRESULTTYPE = @"";
        NSString *str= @"";
        
        for (NSUInteger index = 0; index < [string length]; index++) {
            if ([string characterAtIndex:index] != ' ') {
                str = [NSString stringWithFormat :@"%c",[string characterAtIndex:index]];
                ZZRESULT =[ZZRESULT stringByAppendingString:str];
                NSLog(@"result %@",ZZRESULT);
            }
            else
                break;
        }
        string =[objServiceManagementData.taskDataDictionary objectForKey:@"ZZRESULTTYPE"];
        for (NSUInteger index = 0; index < [string length]; index++) {
            if ([string characterAtIndex:index] != ' ') {
                str = [NSString stringWithFormat :@"%c",[string characterAtIndex:index]];
                ZZRESULTTYPE =[ZZRESULTTYPE stringByAppendingString:str];
                NSLog(@"result %@",ZZRESULTTYPE);
            }
            else
                break;
        }

       
        CurrentDateTime *objCurrentDateTime = [[CurrentDateTime alloc] init];
        //Creating datatype of service confirmation
        NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCDCMNT20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]ZZKEYDATE[.]STATUS[.]STATUS_REASON[.]TIMEZONE_FROM[.]ZZETADATE[.]ZZETATIME[.]ZZFIELDNOTE"];
        
        [_inptArray addObject:strPar4];
        
        NSString *strPar6 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]YTCCSMST_SRVCDCMNT20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]ZZRESULT[.]ZZRESULTTYPE[.]ZZCONTRACT_VALUE[.]ZZSETTYPE"];
        
        [_inptArray addObject:strPar6];
        
        
        
        NSString *strPar7 = [NSString stringWithFormat:@"YTCCSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
                   [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                   ZZRESULT,
                   ZZRESULTTYPE,
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZCONTRACT_VALUE"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE"]
                             ];

        _soRsltUpdateQry1= [NSString stringWithFormat:@"UPDATE '%@' SET ZZRESULT='%@', ZZRESULTTYPE='%@',ZZCONTRACT_VALUE='%@' WHERE OBJECT_ID='%@' AND NUMBER_EXT = '%@'",
                       [objServiceManagementData.dataTypeArray objectAtIndex:16],
                      ZZRESULT,ZZRESULTTYPE,[objServiceManagementData.taskDataDictionary objectForKey:@"ZZCONTRACT_VALUE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]
                       ];
       // Added by sahana on sep 27 2016
        _soRsltUpdateQry2= [NSString stringWithFormat:@"UPDATE '%@' SET ZZSETTYPE='%@', ZZSETTYPE_TXT='%@' WHERE OBJECT_ID='%@' ",
                           [objServiceManagementData.dataTypeArray objectAtIndex:16],
                          [objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZSETTYPE_TXT"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]
                           ];

        NSLog(@"task dic %@",objServiceManagementData.taskDataDictionary);
        
        //Creating the parameter of SOAP call to pass SAP...
        NSString *strPar5 = @"";
        if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound) {
            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.][.]%@[.]%@[.]%@[.]%@",
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]
                       ];
            
            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', ZZETADATE='%@', ZZETATIME='%@',ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@' ",
                           [objServiceManagementData.dataTypeArray objectAtIndex:0],
                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]
                           ];
            
        }
        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)
        {
            NSString *rejReason = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"],[objServiceManagementData.taskDataDictionary objectForKey:@"REASON_DESCRIPTION"]];
            
            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.][.][.]%@",
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],rejReason,
                       [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]
                       ];
            
            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', STATUS_REASON='%@' ,ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@' ",
                           [objServiceManagementData.dataTypeArray objectAtIndex:0],
                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                           rejReason,
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
         }
        else
        {
            
            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.][.]%@[.]%@[.]%@[.]%@",
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]
                       ];
            
            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', ZZETADATE='%@', ZZETATIME='%@',ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@' ",
                           [objServiceManagementData.dataTypeArray objectAtIndex:0],
                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]
                           ];
                            //COMMENTED BY SELVAN ON 04/04/2013 FOR ETA UPDATE
                            //            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.][.]%@[.][.][.]%@",
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],
                            //                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                            //                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]];
                            //            
                            //            
                            //            
                            //            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@',ZZFIELDNOTE = '%@',STATUS_TXT30= '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@' ",
                            //                           [objServiceManagementData.dataTypeArray objectAtIndex:0],
                            //                           [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                                //                           [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],
                            //                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                            //                           [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_TXT30"],
                            //                           [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                            //                           [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
         }
        
        [_inptArray addObject:strPar5];
        
        [_inptArray addObject:strPar7];

        [objCurrentDateTime release];
        /* UIAlertView *errAlert = [[UIAlertView alloc]
         initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
         message:strPar5
         delegate:nil
         cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
         otherButtonTitles:nil];
         [errAlert show];
         [errAlert release];
         */
        
        
        
        //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        NSString *strDocumentData;
        //NSString *strSignData;
        BOOL _updateStatus = FALSE;
        //Attach image as a document
        
        if (self.localSmallFilepathStr != nil) {
            
            NSString *SrcdocObjIdStr = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
            
            strDocumentData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.]%@[.]%@[.]%@[.]%@",SrcdocObjIdStr,[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"],self.localSmallFilepathStr,delegate.encryptedImageString ];
            [_inptArray addObject:strDocumentData];
            //[strDocumentData release],strDocumentData = nil;
            
        }
       
        //Attach signature image as a document
        
/*        if (delegate.localSignFilePath !=nil) {
            
            NSString *SrcSignObjIdStr = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
            
            strSignData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.]%@[.]%@[.]%@",SrcSignObjIdStr,[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],delegate.localSignFilePath,delegate.encryptedSignString ];
            [_inptArray addObject:strSignData];
            //[strSignData release],strSignData = nil;
            
        }*/
        
        [objServiceManagementData.diagonseArray removeAllObjects];
        //APTURE DEVICE START TIME
        [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"+ START-PROCESSING DEVICE %@",[self GetCurrentTimeStamp]]];
        
        //If Internet connection is there call do sap updates here
        if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
        {
            //Normal service task edit save to local db
            
            //ADD EVENT TITLE
            [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"EVENT: SERVICE-DOX-STATUS-UPDATE"]];
            
            //CAPTURE API START TIME
            [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"+ API-BEGIN-TIME DEVICE %@",[self GetCurrentTimeStamp]]];

            
            //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
            responseValue = [CheckedNetwork getResponseFromSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
            
            
            [objServiceManagementData.diagonseArray addObject: [NSString stringWithFormat:@"- API-END-TIME DEVICE %@",[self GetCurrentTimeStamp]]];
            
            
            delegate.ShowServiceUpdateDiagnosis = TRUE;
            
            //responseValue = [gss_ServiceProWebService sendRequestSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
            
            //if ( [responseValue isEqualToString:@"555-Success"] )
            if (delegate.mErrorFlagSAP) {
                
                if (![responseValue isEqualToString:@""]) {
                    
                    UIAlertView *errAlert = [[UIAlertView alloc]
                                             initWithTitle:NSLocalizedString(@"AppDelegate_response_error_alert_title",@"")
                                             message:responseValue
                                             delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                             otherButtonTitles:nil];
                    [errAlert show];
                    errAlert.tag = 6;
                    [errAlert release];
                }
                
                _updateStatus = FALSE;
                
            }
            else
                _updateStatus = TRUE;
                
            

        }
        else
        {
            //******************************************************************************
            //call queue processor code
            //******************************************************************************
            //Convert input array as string to past it in clipboard
            NSString *soapStr = [_inptArray componentsJoinedByString:@","];

            //*******************************************************************************
            //BUILD INPUT STRING
            //*******************************************************************************
            NSMutableDictionary *serviceEditDataDic = [[NSMutableDictionary alloc] init];
            [serviceEditDataDic setObject:@"SERVICE-DOX-STATUS-UPDATE" forKey:@"apiName"];
            [serviceEditDataDic setObject:@"servicepro://tasklistpage" forKey:@"packageName"];
            [serviceEditDataDic setObject:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"] forKey:@"appRefId"];
            [serviceEditDataDic setObject:@"SERVICEPRO" forKey:@"appName"];
            [serviceEditDataDic setObject:delegate.deviceMACID forKey:@"deviceid"];
            [serviceEditDataDic setObject:soapStr forKey:@"soapInput"];
            //*******************************************************************************
            //GET PASTBOARD DETAILS
            //*******************************************************************************
            gss_qp_pastboard *obj_gss_qp_pastboard = [[[gss_qp_pastboard alloc] init] autorelease];
            NSMutableArray *pastboardItemArray;
            pastboardItemArray = [obj_gss_qp_pastboard getItemFromPastBord:@"servicepro"];
            
            //*******************************************************************************
            //SET PASTBOARD DETAILS
            //*******************************************************************************
            //[pastboardItemArray removeAllObjects];
            [pastboardItemArray addObject:serviceEditDataDic];
            [serviceEditDataDic release],serviceEditDataDic = nil;
             [obj_gss_qp_pastboard setItemIntoPastBord:pastboardItemArray :@"servicepro"];
            _updateStatus = TRUE;
            responseValue =@"No connectivity:Update queued for processing later";
            
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"queueprocessor://com.gss.queueprocessor?sender#servicepro"]];
            
            
            //The following code fragment illustrates how one app can request the services of another app (“todolist” in this example is a hypothetical custom scheme registered by an app):
            
            //NSURL *myURL = [NSURL URLWithString:@"todolist://www.acme.com?Quarterly%20Report#200806231300"];
            //[[UIApplication sharedApplication] openURL:myURL];
            
            
            
            //NSLog(@"past arra %@", pastboardItemArray);
            //NSLog(@"pastboard %c", setPastBoardStatus);
            //back process code ended
        }
        
        //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
        [customAlt removeAlertForView];
        [customAlt release], customAlt = nil;

        
        if (_updateStatus){
            
            //Update service order table
            if([objServiceManagementData excuteSqliteQryString:_soUpdateQry:objServiceManagementData.serviceReportsDB:@"UPDATE TASK":1]){
                if([objServiceManagementData excuteSqliteQryString:_soRsltUpdateQry1:objServiceManagementData.serviceReportsDB:@"UPDATE TASK":1]) {
                    if([objServiceManagementData excuteSqliteQryString:_soRsltUpdateQry2:objServiceManagementData.serviceReportsDB:@"UPDATE TASK":1])
                    {

            
                
                        //Delete if any Declined SO in service order table
                        NSString *soDltQry = [NSString stringWithFormat:
                                              @"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@'",
                                              [objServiceManagementData.dataTypeArray objectAtIndex:0],
                                              [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                                              [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
                        //[objServiceManagementData deleteDataFromServiceManagmentDB:soDltQry];
                        
                        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"DROP-FROM-DEVICE-DB"].location != NSNotFound)
                        {
                        
                            [objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.serviceReportsDB :@"DELETE REJECTED TASK" :0];
                        
                        }
                       /* COMMENTED BY SELVAN//Delete if any rejected SO in service order table
                        soDltQry = [NSString stringWithFormat:
                                    @"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@'",
                                    [objServiceManagementData.dataTypeArray objectAtIndex:0],
                                    [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                                    [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
                        //[objServiceManagementData deleteDataFromServiceManagmentDB:soDltQry];
                        
                        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS_ZZSTATUS_POSTSETACTION"] rangeOfString:@"DROP-FROM-DEVICE-DB"].location != NSNotFound)
                        {
                            
                            [objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.serviceReportsDB :@"DELETE REJECTED TASK" :0];
                        }*/
                        
                        [objServiceManagementData.taskListArray removeAllObjects];
                        NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
                        objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :1];
                        
                        
                        
                       
                        NSString *alertMsg = @"";
                        for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
                        {
                            alertMsg =[self.updateResponseMsgArray objectAtIndex:i];
                        }
                        
                        //  AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
                        delegate.localImageFilePath = @"";
                        delegate.localSignFilePath=@"";
                        
                        
                        //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
                        [customAlt removeAlertForView];
                        [customAlt release], customAlt = nil;
                        
                        //NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_title",@"")
                        //Display the alert which is got from SAP response...
                        if (![responseValue isEqualToString:@""]) {
                            UIAlertView *responseSuccess = [[UIAlertView alloc]
                                                            initWithTitle:nil
                                                            message:responseValue
                                                            delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_Cancel_title",@"")
                                                            otherButtonTitles:nil];
                            [responseSuccess show];
                            responseSuccess.tag = 5;
                            [responseSuccess release];
                        }
                     }
                }
            }
            else {
                
                //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
                [customAlt removeAlertForView];
                [customAlt release], customAlt = nil;
                
                NSString *alertMsg = @"";
                
                for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
                {
                    alertMsg =[self.updateResponseMsgArray objectAtIndex:i];
                }
                if (![responseValue isEqualToString:@""]) {
                    UIAlertView *responseError = [[UIAlertView alloc]
                                                  initWithTitle:nil
                                                  message:alertMsg //NSLocalizedString(@"Edit_Task_TaskUpdation_alert_msg",@"")
                                                  delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_alert_Cancel_title",@"")
                                                  otherButtonTitles:nil];
                    [responseError show];
                    responseError.tag = 4;
                    [responseError release];
                }
            }
        }
        
        //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
        [customAlt removeAlertForView];
        [customAlt release], customAlt = nil;

        
      
    }
    /*  else
     {
     
     //In this block caling function to update in SAP as well as sqlite
     self.view.userInteractionEnabled = TRUE;
     self.navigationItem.leftBarButtonItem.enabled = TRUE;
     
     
     UIAlertView *responseError = [[UIAlertView alloc]
     initWithTitle:nil
     message:@"Try Again"
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"Edit_Task_TaskUpdation_alert_Cancel_title",@"")
     otherButtonTitles:nil];
     [responseError show];
     responseError.tag = 4;
     [responseError release];
     }*/
    
    //Show diagnosis popup
//    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
//
//    //Show Diagnosis popup
//    if (objAppDelegate_iPHone.diagnoseSwitchStatus)
//    {
//        //CustomDiagnosisPopup *objCustomDiagnosisPopup = [[CustomDiagnosisPopup alloc] init];
//        //[objCustomDiagnosisPopup showDiagnosisPopup:self.view];
//        [self showDiagnosisPopup];
//        
//    }

    
    
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

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}
-(void)keyboardWillShow:(NSNotification *)notif{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
	
    if ([_textField isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![_textField isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [serviceOrderEditArray release];
}


#pragma mark-
#pragma mark Diagnosis


-(void)DiagPopupDone {
    
    [diagPopupView removeFromSuperview];
}

- (void)sendDiagnoseEmail
{
    ServiceManagementData * objServiceManagementData = [ServiceManagementData sharedManager];
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
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
        UIAlertView *alertEdit = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alertEdit show];
        [alertEdit release];
    }
}

-(void) showDiagnosisPopup {
    ServiceManagementData * objServiceManagementData = [ServiceManagementData sharedManager];
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    
    if ([objServiceManagementData.diagonseArray count] >  0) {
        NSLog(@"SAP Response Time %@", objServiceManagementData.diagonseArray);
        
        diagPopupView = [[UIView alloc] initWithFrame:CGRectMake(135, 375, 500, 200)];
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
        UIButton *butDiagEmail = [[UIButton alloc] initWithFrame:CGRectMake(435, 145, 60, 60)];
        //[butDiagEmail setTitle:@"Email" forState:UIControlStateNormal];
        [butDiagEmail setBackgroundImage:[UIImage imageNamed:@"sendemail1.jpeg"] forState:UIControlStateNormal];
        [butDiagEmail addTarget:self action:@selector(sendDiagnoseEmail) forControlEvents:UIControlEventTouchDown];
        [diagPopupView addSubview:butDiagEmail];
        [butDiagEmail release], butDiagEmail = nil;
        
        //Create disable popup button
        UIButton *butDisablePopup = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        butDisablePopup.frame = CGRectMake(270.0, 165.0, 160.0, 25.0);
        [butDisablePopup setTitle:@"Disable Diagnosis" forState:UIControlStateNormal];
        butDisablePopup.backgroundColor = [UIColor redColor];
        [butDisablePopup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [butDisablePopup addTarget:self action:@selector(DisablePopup) forControlEvents:UIControlEventTouchDown];
        [diagPopupView addSubview:butDisablePopup];
        [butDisablePopup release], butDisablePopup = nil;
        
        
        [headerBarTitle release], headerBarTitle = nil;
        [headerBar release], headerBar = nil;
        // [self openMail];
    }
    
}

-(void) DisablePopup {
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"Servicepro" ofType:@"plist"];
    //    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    //    [dictionary setValue:[NSNumber numberWithBool:NO] forKey:@"DiagnosePopup"];
    //    [dictionary writeToFile:path atomically:YES];
    int popupStatus =0;
    ServiceManagementData * objServiceManagementData = [ServiceManagementData sharedManager];
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"UPDATE TBL_SETTING SET diagnosepopup = %d", popupStatus];
    [objServiceManagementData excuteSqliteQryString:sqlQryStr :@"Settings.sqlite":@"SETTING" :1];
    
    
    
    AppDelegate_iPhone *objAppDelegate_iPHone = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    objAppDelegate_iPHone.diagnoseSwitchStatus = NO;
    
    NSLog(@"Diag Status %hhd", objAppDelegate_iPHone.diagnoseSwitchStatus);
    [self DiagPopupDone];
    
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


@end
