//
//  ServiceOrderEdit.m
//  ServiceManagement
//
//  Created by Selvan Chellam on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceOrderEdit.h"
#import "ServiceOrders.h"
#import "ServiceConfirmation.h"
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

#import "CustomAlertView.h"
#import "CurrentDateTime.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"
#import "QSStrings.h"
#import "CheckedNetwork.h"
#import "ETAScreen.h"
#import "TableCellView.h"
#import "ModalView.h"
#import "SignatureCapture.h"
#import "SignaturePreview.h"
#import "ImagePreview.h"

#import "gss_qp_pastboard.h"
#import "iOSMacros.h"

//#import "gss_ServiceProWebService.h"

CustomPickerControl *pic;
StaticData *objStaticData;
CustomDatePicker *datePicker;
CurrentDateTime *objCurrentDateTime;

CustomAlertView *customAlt;
BOOL errStatus = FALSE;
//const NSInteger kViewTag2 = 1;
#define kOFFSET_FOR_KEYBOARD 250.0

@implementation ServiceOrderEdit

@synthesize object_id;

@synthesize myTableView;
@synthesize toolbar;
@synthesize detailsTask;
@synthesize taskReason;
@synthesize taskNotes;
@synthesize taskCategory;
@synthesize displayTask;
@synthesize commonLabel;

@synthesize updateResponseMsgArray;
@synthesize updateSucessFlag;
@synthesize ETAPopupShowFlag;

@synthesize alert;
@synthesize etaView;

@synthesize rgtLabel;
@synthesize butETAValue;
@synthesize canButton;
@synthesize savButton;
@synthesize etaTitle;

@synthesize txtStatus;
@synthesize txtTimeZone;
@synthesize txtReason;


@synthesize imageView;
@synthesize localSmallFilepathStr;
@synthesize encodedImageStr;

@synthesize rowIndex;

@synthesize iPadView;

@synthesize pickerToolbar, pickerViewActionSheet, pickerView, pickerValue;



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
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
    self.localSmallFilepathStr = [self filePath:@"MyPicture.png"];
    
    NSString * base64String = [[NSString alloc] init];
    base64String = [QSStrings encodeBase64WithData:imageData];
    
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.localImageFilePath = self.localSmallFilepathStr;	
    
    delegate.encryptedImageString = base64String;
    
    //---write the date to file--
    [imageData writeToFile:[self filePath:@"MyPicture.png"] atomically:YES];
    
    NSLog(@"image file path :%@ ",delegate.localImageFilePath);
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image;
    NSURL *mediaUrl;
    imageView.hidden = YES;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    
    if (mediaUrl == nil)
    {
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (image == nil)
        {
            image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            
            
            CGSize objCGSize = CGSizeMake(30, 30);
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
-(UIImage *)scaledImageForImage:(UIImage*)image newSize:(CGSize)newSize{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(IBAction)attachBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    ImagePreview *objImagePreview = [[ImagePreview alloc] init];
    [self presentModalViewController:objImagePreview animated:YES];
    
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
   
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];

    
    delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    //toolbar code
    NSArray *items;
    toolbar.barStyle = UIBarStyleBlackOpaque; // UIBarStyleDefault;

    
    
    UIBarButtonItem *menuItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu28-b.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doMenu)] autorelease];
    menuItem.title = @"Menu";
    
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

     
    
    UIBarButtonItem *fixSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];    


   
    [self ImageCheckingInDocFolder];    
    
    float _screenWidth = self.view.frame.size.width;
    //float _screenHieght = self.view.frame.size.height;
    
  
    if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length == 0) {
        fixSpaceItem.width = 89;
        items = [NSArray arrayWithObjects:signatureItem, fixSpaceItem, menuItem, nil];
    }
    else if (delegate.signatureCaptured == YES && delegate.localImageFilePath.length >0) {
        fixSpaceItem.width = 33;
        items = [NSArray arrayWithObjects:imageItem, signatureItem, fixSpaceItem, menuItem, nil];
    }
    else if (delegate.signatureCaptured == NO && delegate.localImageFilePath.length >0) {
        fixSpaceItem.width = 83;
        items = [NSArray arrayWithObjects:imageItem, fixSpaceItem, menuItem, nil];
    }

    else{
        fixSpaceItem.width = (_screenWidth/2) - 20;
        items = [NSArray arrayWithObjects:fixSpaceItem, menuItem, nil];

    }
        
     TaskStatus = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
    
    NSLog(@"Status %@",TaskStatus);
    
    
    toolbar.items = items;
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

    

}


-(void)EstimatedArrival_DataExchange:(NSString *)data
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    if([data isEqualToString:@"DateT"]){
        
        if (IS_IPHONE) {
            //calling date piker common class
            [datePicker datePickerView:self.myTableView :@"ETADate"];
        }
        else if (IS_IPAD) {
            //Biren changes on 01/02/2013
            //Call ipad pickerview control
            [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:estimatedArrival.MSG_view2.bounds myView:estimatedArrival.MSG_view1];
            //end
        }
    }
    
    
        //[datePicker datePickerView:self.myTableView :@"ETADate"];
        
        
        
        
    
    else if ([data isEqualToString:@"Done"])
    {
        
        ChkPopUpMenu = NO;
        //estimatedArrival.CDate = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"]];
        [estimatedArrival.view removeFromSuperview];
        // service_count = 0;
    }
    else
    {
        
        [objServiceManagementData.taskDataDictionary setObject:TaskStatus forKey:@"STATUS"];
        //commented by selvan 06/02/2013    [objServiceManagementData.taskDataDictionary setObject:@"0000-00-00" forKey:@"ZZETADATE"];
        [estimatedArrival.view removeFromSuperview];
        
    }
    
    
    ETAPopupShowFlag = YES;
    [self.myTableView reloadData];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIScreen *screen = [UIScreen mainScreen];
    //[self.view setFrame:[screen applicationFrame]];
    
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Edit_Task_title","");
	
	pic = [[CustomPickerControl alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
    objCurrentDateTime = [[CurrentDateTime alloc] init];
    imagePicker = [[UIImagePickerController alloc] init];

	ETAPopupShowFlag = YES;
    
    serviceOrderEditArray = [[NSArray alloc] init];
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;

    
 
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(SaveTask)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release], saveButton = nil;
    
	
	//Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
         //
    //serviceOrderEditArray = [objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId];
    //
    //NSLog(@" %@",objServiceManagementData.taskDataDictionary);
    
    //Get order to edit
    
    NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %d",[objServiceManagementData.dataTypeArray objectAtIndex:0],objServiceManagementData.editTaskId];
   
    serviceOrderEditArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :2];
    
    NSLog(@"EDIT ARRAY %@",serviceOrderEditArray);
    
    [objServiceManagementData.taskDataDictionary removeAllObjects];
     objServiceManagementData.taskDataDictionary = [serviceOrderEditArray objectAtIndex:0];
    
    //copy selected service order to temp dictionary
    
    //[objServiceManagementData.taskDataDictionary removeAllObjects];
    //objServiceManagementData.taskDataDictionary = [objServiceManagementData.taskListArray objectAtIndex:objServiceManagementData.editTaskId];
    
    
     //commented by selvan on 06/02/2013
   /* if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"ACPT"] ) {
        [objServiceManagementData.taskDataDictionary setObject:[objCurrentDateTime convertShortDateToStringFormat1:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]] forKey:@"ZZETADATE"];
    }   
    */
    
	//Set some extra keys for display in to page...
	[objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON"];
	[objServiceManagementData.taskDataDictionary 	setObject:@"" forKey:@"REASON_DESCRIPTION"];
	[objServiceManagementData.taskDataDictionary 	setObject:@"Indian Standard Time" forKey:@"TIME_ZONE"];
	
	
	
	//Adding the STATUS value to dictionary depending upon the 'taskStatusMappingArray' list..there status is mapped.. 
	[objServiceManagementData.taskDataDictionary 
     setObject:[[objStaticData.taskStatusMappingArray objectAtIndex:0] 
    objectForKey:[[serviceOrderEditArray objectAtIndex:0] objectForKey:@"STATUS"]] forKey:@"STATUS"];
    
 
    //Check queue processor Error
    NSString *sqlQryStr3 = [NSString stringWithFormat:@"SELECT * FROM 'TBL_ERRORLIST' WHERE apprefid = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    objServiceManagementData.errorlistArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr3 :objServiceManagementData.serviceReportsDB:@"error table" :1];
    NSMutableString *errDesc = [NSMutableString string];
    //Group error
    for (int cnt=0; cnt < [objServiceManagementData.errorlistArray count]; cnt++) {
        
        [errDesc appendString:[[objServiceManagementData.errorlistArray objectAtIndex:cnt] objectForKey:@"errdate"]];
        [errDesc appendString:@": "];
        [errDesc appendString:[[objServiceManagementData.errorlistArray objectAtIndex:cnt] objectForKey:@"errdesc"]];
        [errDesc appendString:@". "];
    }
    
    
    if ([objServiceManagementData.errorlistArray count] > 0) {
        errStatus = YES;
        UIAlertView *errAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Update Error Warning!"
                                 message:[[objServiceManagementData.errorlistArray objectAtIndex:0] objectForKey:@"errdesc"]
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                 otherButtonTitles:nil];
        errAlert.tag = 55;
        [errAlert show];
        [errAlert release];
        
    }
    else
    {
        errStatus = NO;
    }
    
   //[objServiceManagementData.taskDataDictionary setObject:[[objStaticData.taskStatusMappingArray objectAtIndex:0] 
   //      objectForKey:[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]] forKey:@"STATUS"];

    //NSLog(@"task disc %@",objServiceManagementData.taskDataDictionary);
    
    
    self.object_id =  [NSString stringWithFormat:@"%@", [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    
    delegate.taskTranFrom = self.object_id;

    
    ChkPopUpMenu = NO;
    
    
    service_count = 0;
    array_total_count=0;
    
   
    TableTitle = [[NSMutableArray alloc] init];
    TableData = [[NSMutableArray alloc]init];
    [self RemoveNullFeildsFromTable];

    
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
    objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVICE ORDER" :1]; 
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    
}	


-(void) doMenu{
    
    
    //Action sheet to go EditTadk, Mapview or Service confirmation page...against one task...
    
    //Action sheet to go EditTadk, Mapview or Service confirmation page...against one task...
	UIActionSheet *editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc]
                                                            initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
                                                            delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")
                                                            destructiveButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Service_Confirmation",@"")
                                                            otherButtonTitles:
                                                            NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Task_Location_in_MapView",@"") ,
                                                            
                                                            
                                                            NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Service_Transfer", @""),
                                                            NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_CaptureImage",@""),
                                                            
                                                            NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_AddSignature",@""),
                                                            
                                                            nil];
    
    //commented for some options are not removed in this version
	/*UIActionSheet *editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc]
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

                                                            nil];*/
	
	editTaskMapViewServiceConfActionSheet.tag = 2; //I have set tag, because two action sheet is present in this class..
	
	[editTaskMapViewServiceConfActionSheet showInView:self.view];
    
	[editTaskMapViewServiceConfActionSheet release], editTaskMapViewServiceConfActionSheet = nil;
}
//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
            
       /* case 1:
            //objServiceManagementData.editTaskId = self.rowIndex;
            objTaskLocationMapView = [[TaskLocationMapView alloc] initWithNibName:@"TaskLocationMapView" bundle:nil];
            [self.navigationController pushViewController:objTaskLocationMapView animated:YES];	
            [objTaskLocationMapView release], objTaskLocationMapView = nil;
            break;
           */
            default:
            break;
      }
    
}
//Delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	ServiceConfirmation *objServiceConfirmation;
   // AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//This below block will call when Service orders function will call..
	if (actionSheet.tag == 2 && buttonIndex == 0) {
		
        [customAlt removeAlertForView];
        [customAlt release], customAlt = nil;
        
        self.view.userInteractionEnabled = TRUE;
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.hidesBackButton = NO;

        delegate.localImageFilePath = @""; 
        delegate.signatureCaptured = FALSE;
        
        NSString *sqlQryStr;
        
        
        
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



    }
    else if(actionSheet.tag == 2 && buttonIndex == 2) {
        
        //Load collegue list view.
        //ColleagueList *objColleagueList = [[ColleagueList alloc] init];
        //[self presentModalViewController:objColleagueList animated:YES];
        
        if ([objServiceManagementData.colleagueListArray count] == 0) {
            BOOL returnValue;
            MainMenu *objMainMenu = [[MainMenu alloc] init];
            
            returnValue = [objMainMenu getColleagueListDownloadFromSAP];
            
        }
       // AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        delegate.colleagueAction = @"TransferColleague";
        delegate.taskTranFrom = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
        ColleagueList *objColleagueList = [[ColleagueList alloc] initWithNibName:@"ColleagueList" bundle:nil];
        [self.navigationController pushViewController:objColleagueList animated:YES];
        [objColleagueList release], objColleagueList = nil;
          delegate.localImageFilePath = @""; 
        
    }
    else if(actionSheet.tag == 2 && buttonIndex == 4){

        [self cameraBtnClicked];
    }
    else if(actionSheet.tag == 2 && buttonIndex == 5) {
            
            [self scanBtnClicked];
        }
    else {
        self.view.userInteractionEnabled = TRUE;
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.hidesBackButton = NO;
        
        printf("Some problem is occuared while downloading service Order Confirmation List from SAP!...");
    }
    
}

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
    //ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    //NSLog(@"status %@  arrct %d",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"],total_arrayc);

    
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
    else if(indexPath.row == 0)
        rowHeight = 110.0f;
    else if (([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Ready"] || [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString: @"Deferred - no parts"] || [[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString: @"Completed"] ) && indexPath.row == 6)
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
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
	{
		return 17-total_arrayc; 
	}
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"]) {
        return 16-total_arrayc;
    }
    
	return 15-total_arrayc;
    
    
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    int row_index = indexPath.row + 1;
    
    //if(row_index  == 1 || row_index ==11 || row_index == 12)
    if (row_index == 1 || rowIndex == row_index-1) 
    {
        //cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        if ([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"] && row_index == 11)
            cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
        
        
    }
    else
        cell.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    float _framewidth = self.view.frame.size.width;
    //CGFloat _framewidth1 = self.view.frame.size.width;
    //NSLog(@"FRAME WIDTH: %f", _framewidth);
    //NSLog(@"FRAME WIDTH in CGFloat: %f", _framewidth1);
    //float _frameheight = self.view.frame.size.height;
    
    //Change tableview background color
    tableView.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	//NSLog(@"index path %d",indexPath.row);
	
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
    
    
   // NSLog(@"The Current Date ::::::: %@",strETA1);
    
    
    //Relase textfields
    [txtStatus release],txtStatus = nil;
    [txtReason release],txtReason = nil;
    [txtTimeZone release], txtTimeZone = nil;
    
    
    if(indexPath.section == 0 && IS_IPHONE)
	{
		//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
        
        
        int total_count = indexPath.row - service_count;
        int flag = 0;
        
        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
        {
            
            if(total_count < 5)
                service_count =0;
            else
                service_count =2;
            
            
            switch (indexPath.row) {
                    
                case 5: {
                    commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Select_a_Reason",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    
                    //Set default reason as other
                    
                    if([[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@""])
                        [objServiceManagementData.taskDataDictionary setObject:@"Other" forKey:@"REASON"];
                    
                    
                    
                    
                    CGRect frame2 = CGRectMake(163, 5.0, 155.0, 35.0);
					txtReason = [[UITextField alloc] initWithFrame:frame2];
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
					
					txtReason.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					txtReason.rightViewMode = UITextFieldViewModeAlways;
					
					txtReason.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtReason];
                    
                    
                    flag = 1;
                    
                    
                    
                    break; }
                    
                case 6: {
                    
                    commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    
                    taskReason = [Design textViewFormation:163.0 :5.0 :155.0 :97.0 :2 :self];
                    taskReason.layer.masksToBounds = YES;
                    taskReason.layer.cornerRadius = 2.0;
                    taskReason.layer.borderWidth = 0.5;
                    taskReason.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    
                    
                    if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"] &&
                       [[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@"Other" ])
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
        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"]) {
            
            
            
            
            switch (indexPath.row) {
                    
                case 6: {
					commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Estimated",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Estimated",@"");
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:163.0 :5.0 :155.0 :[self labelHeightCalculation:strETA1:2]:15.0f :2];
					
                    if( ChkPopUpMenu == NO)
                        commonLabel.text = strETA1;
                    else
                    {
                        commonLabel.text = estimatedArrival.CDate;
                        // NSArray *splitA = [strETA1 componentsSeparatedByString:@" "];
                        
                        //[estimatedArrival.BDateT setTitle:[NSString stringWithFormat:@" %@ %@ %@",[splitA objectAtIndex:0],[splitA objectAtIndex:1],[splitA objectAtIndex:2]] forState:UIControlStateNormal];
                        
                        
                        [estimatedArrival.MSG_DATE setText:strETA1];
                        
                    }
                    
                    [cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    
                    
                    if (!(ETAPopupShowFlag))
                    {
                        
                        ETAPopupShowFlag = NO;
                        ChkPopUpMenu = YES;
                        
                        /* etaView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, 285, 150)];
                         self.etaView.layer.cornerRadius = 10.0;
                         self.etaView.backgroundColor = [UIColor grayColor];
                         
                         self.etaView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
                         self.etaView.alpha = 1;
                         
                         rgtLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 285, 30)];
                         rgtLabel.backgroundColor = [UIColor grayColor];
                         rgtLabel.text = @"Estimated arrival at customer:";
                         
                         
                         butETAValue = [UIButton buttonWithType:UIButtonTypeCustom];
                         butETAValue.frame = CGRectMake(50, 70, 180, 30);
                         butETAValue.backgroundColor = [UIColor clearColor];
                         [butETAValue setTitle:strETA1 forState:UIControlStateNormal];
                         [butETAValue addTarget:self action:@selector(butETAValueClicked:) forControlEvents: UIControlEventTouchUpInside];
                         
                         
                         
                         canButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         canButton.frame = CGRectMake(105, 110, 85, 30);
                         [canButton setTitle:@"Done" forState:UIControlStateNormal];
                         [canButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents: UIControlEventTouchDown];
                         
                         //savButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         // savButton.frame = CGRectMake(150, 110, 85, 30);
                         // [savButton setTitle:@"Save" forState:UIControlStateNormal];
                         // [savButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents: UIControlEventTouchDown];
                         
                         
                         
                         
                         [self.etaView addSubview:butETAValue];
                         [self.etaView addSubview:rgtLabel];
                         [self.etaView addSubview:canButton];
                         [self.etaView addSubview:savButton];
                         [self.view addSubview:self.etaView];*/
                        
                        
                        
                        
                        estimatedArrival= [[EstimatedArrival alloc] initWithNibName:@"EstimatedArrival" bundle:Nil];
                        [estimatedArrival setDelegate:self];
                        
                        estimatedArrival.CDate = strETA1;
                        
                        
                        
                        UIColor *VColor  = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                        
                        estimatedArrival.view.backgroundColor = VColor;
                        [self.view addSubview:estimatedArrival.view];
                        
                        [estimatedArrival.MSG_DATE setText:strETA1];
                        
                        
                    }
                    
                    
                    
                    
                    flag = 1;
                    service_count = 1;
                    
					break;
                }
                    
                    
                    
            }
            
            
            
            if(total_count < 6)
                service_count =0;
            else
                service_count =1;
            
            
        }
        
        
        
        if (flag == 0)
        {
            
            // int TableC = 7 - [TableData count];
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
                    
                    
                    //Create view for Header text display
                    CGRect rectView= CGRectMake(2, 2, self.view.frame.size.width-4, 41);
                    UIView *headerView1 = [[UIView alloc] initWithFrame:rectView];
                    [headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                    [headerView1 setBackgroundColor:[UIColor clearColor]];
                    headerView1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    headerView1.layer.masksToBounds = YES;
                    headerView1.layer.cornerRadius = 8.0;
                    headerView1.layer.borderWidth = 1.0f;
                    //headerView1.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    headerView1.layer.borderColor = [UIColor blackColor].CGColor;
                    
                    //Display Header line one and two
                    //UITextField *txtHeader1,*txtHeader2;
                    //UILabel *lblHeader1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, self.view.frame.size.width-20, 30)];
                    UILabel *lblHeader1 = [[UILabel alloc] init];
                    lblHeader1 = [Design LabelFormationWithColor:2.0 :0.0 :_framewidth-4:35:16.0f :1];
                    lblHeader1.text = [NSString stringWithFormat:@"Service Location"];
                    //lblHeader1.adjustsFontSizeToFitWidth=YES;
                    lblHeader1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader1.font = [lblHeader1.font fontWithSize:14.0f];
                    [headerView1 addSubview:lblHeader1];
                    
                    
                    //UILabel *lblHeader2 = [[UILabel alloc] initWithFrame:CGRectMake(2,32, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader2 = [[UILabel alloc] init];
                    lblHeader2 = [Design LabelFormationWithColor:2.0 :32.0 :_framewidth-4 :25:16.0f :1];
                    lblHeader2.text = [NSString stringWithFormat:@"%@ %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"]];
                    ////lblHeader2.adjustsFontSizeToFitWidth=YES;
                    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader2.font = [lblHeader2.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader2];
                    
                    //UILabel *lblHeader3 = [[UILabel alloc] initWithFrame:CGRectMake(2,58, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader3 = [[UILabel alloc] init];
                    lblHeader3 = [Design LabelFormationWithColor:2.0 :56.0 :_framewidth-4 :25:16.0f :1];
                    lblHeader3.text = [NSString stringWithFormat:@"%@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"]];
                    //lblHeader3.adjustsFontSizeToFitWidth=YES;
                    lblHeader3.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader3.font = [lblHeader3.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader3];
                    
                    
                    //UILabel *lblHeader4 = [[UILabel alloc] initWithFrame:CGRectMake(2,84, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader4 = [[UILabel alloc] init];
                    lblHeader4 = [Design LabelFormationWithColor:2.0 :77.0 :_framewidth-4 :25:16.0f :1];
                    
                    lblHeader4.text = [NSString stringWithFormat:@"%@, %@, %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"]];
                    //lblHeader4.adjustsFontSizeToFitWidth=YES;
                    lblHeader4.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader4.font = [lblHeader4.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader4];
                    
                    
                    cell.userInteractionEnabled = FALSE;
                    [cell.contentView addSubview:headerView1];
                    [headerView1 autorelease];
                    
                    
                    break;
                    
                    
                case 1:
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Category",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    break;
                    
                case 2:
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_serordertype",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_serordertype",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    break;
                    
                    
                case 3:
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Priority",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    
                    commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    break;
                    
                case 4:
                    
                    commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Status",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    CGRect frame1 = CGRectMake(163, 5.0, 155.0, 35.0);
					txtStatus = [[UITextField alloc] initWithFrame:frame1];
					txtStatus.borderStyle =  UITextBorderStyleRoundedRect;
					txtStatus.textColor = [UIColor blackColor];
					txtStatus.font = [UIFont systemFontOfSize:12.0];
					txtStatus.backgroundColor = [UIColor lightGrayColor];
					
					txtStatus.keyboardType = UIKeyboardTypeDefault;
					txtStatus.returnKeyType = UIReturnKeyDone;
					
					txtStatus.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtStatus.enabled = FALSE;
					txtStatus.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					
					// Add an accessibility label that describes the text field.
					[txtStatus setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtStatus.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					txtStatus.rightViewMode = UITextFieldViewModeAlways;
					
					txtStatus.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtStatus];
                    
                    
					break;
                    
                    
                case 5:
                    
                    //cell.textLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Due",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Due",@"");
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    break;
                    /* case 6:
                     
                     commonLabel = [Design LabelFormation:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Time_Zone",@""):1]:16.0f :1];
                     commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");
                     [cell.contentView addSubview:commonLabel];
                     [commonLabel release], commonLabel = nil;
                     
                     
                     
                     //commonLabel = [Design LabelFormation:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]:2]:15.0f :2];
                     // commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
                     // [cell.contentView addSubview:commonLabel];
                     // [commonLabel release], commonLabel = nil;
                     
                     CGRect frame3 = CGRectMake(163, 5.0, 155.0, 35.0);
                     txtTimeZone = [[UITextField alloc] initWithFrame:frame3];
                     txtTimeZone.borderStyle =  UITextBorderStyleRoundedRect;
                     txtTimeZone.textColor = [UIColor blackColor];
                     txtTimeZone.font = [UIFont systemFontOfSize:12.0];
                     txtTimeZone.backgroundColor = [UIColor lightGrayColor];
                     
                     txtTimeZone.keyboardType = UIKeyboardTypeDefault;
                     txtTimeZone.returnKeyType = UIReturnKeyDone;
                     
                     txtTimeZone.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
                     
                     //txtTimeZone.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
                     txtTimeZone.enabled = FALSE;
                     txtTimeZone.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
                     
                     // Add an accessibility label that describes the text field.
                     [txtTimeZone setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
                     
                     txtTimeZone.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
                     txtTimeZone.rightViewMode = UITextFieldViewModeAlways;
                     
                     txtTimeZone.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
                     [cell.contentView addSubview:txtTimeZone];
                     
                     
                     break;
                     
                     */
                case 6:
                    
                    //NSLog(@"Status %@",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]);
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Note",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Note",@"");
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    
                    
                    
                    taskNotes = [Design textViewFormation:163.0 :5.0 :_framewidth-180  :97.0 :2 :self];
                    taskNotes.layer.masksToBounds = YES;
                    taskNotes.layer.cornerRadius = 2.0;
                    taskNotes.layer.borderWidth = 0.5f;
                    //taskNotes.layer.borderColor = [[UIColor colorWithHue:1.0 saturation:1.5 brightness:0.75 alpha:1.0] CGColor];
                    taskNotes.layer.borderColor = [UIColor blackColor].CGColor;
                    cell.userInteractionEnabled = TRUE;
                    taskNotes.text = [objServiceManagementData.taskDataDictionary valueForKey:@"ZZFIELDNOTE"];
                    
                    [cell.contentView addSubview:taskNotes];
                    
                    break;
                    
                    
                case 7:
                    
                    
                    if([[TableTitle objectAtIndex:0] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [[serviceOrderEditArray objectAtIndex:0] objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:0];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }
                    
                    
                    
                    break;
                case 8:
                    
                    if([[TableTitle objectAtIndex:1] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:1];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }
                    
                    break;
                    
                case 9:
                    
                    if([[TableTitle objectAtIndex:2] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:2];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }
                    
                    break;
                    
                    
                case 10:
                    
                    
                    if([[TableTitle objectAtIndex:3] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:3];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                    }
                    
                    break;
                    
                case 11:
                    
                    if([[TableTitle objectAtIndex:4] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:4];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }
                    break;
                    
                case 12:
                    
                    if([[TableTitle objectAtIndex:5] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:5];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }
                    break;
                    
                    
                case 13:
                    
                    
                    if([[TableTitle objectAtIndex:6] isEqualToString:@"Other Details"])
                    {
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:6];
                        commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        break;
                        
                        
                    case 14:
                        
                        displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        break;
                        
                    }
            } //End of block while Status is Declined and that time  'Select a reason' and 'Enter the reason' block will displayed..
       		
        }
    }
    
    
	if(indexPath.section == 0 && IS_IPAD)
	{
        
        //ERASE SEPARATER
        tableView.separatorColor = [UIColor clearColor];
		
        
        
        //If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
        
        int total_count = indexPath.row - service_count;
        int flag = 0;
        
        if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
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
                    [commonLabel release], commonLabel = nil;
                    
                    
                
                    //Set default reason as other
                    
                    if([[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@""])
                        [objServiceManagementData.taskDataDictionary setObject:@"Other" forKey:@"REASON"];
                    
                
                   
                    CGRect frame2 = CGRectMake(188, 5.0, 155.0, 35.0);
					txtReason = [[UITextField alloc] initWithFrame:frame2];
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
					
					txtReason.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					txtReason.rightViewMode = UITextFieldViewModeAlways;
					
					txtReason.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtReason];
                    
                    
                    flag = 1;
                    
                    
                    
                    break; }
                    
                case 6: {
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Enter_the_Reason",@"");				
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    
                    taskReason = [Design textViewFormation:188.0 :5.0 :_framewidth-220 :97.0 :2 :self];
                    taskReason.layer.masksToBounds = YES;
                    taskReason.layer.cornerRadius = 2.0;
                    taskReason.layer.borderWidth = 0.5;
                    //taskReason.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    taskReason.layer.borderColor = [UIColor blackColor].CGColor;
                    
                    if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"]&&
                       [[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@"Other" ])
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
        else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"]) {
            
            switch (indexPath.row) {
                    
                case 6: {
					commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Estimated",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Estimated",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
					commonLabel = [Design LabelFormation:188.0 :5.0 :155.0 :[self labelHeightCalculation:strETA1:2]:15.0f :2];
					
                    if( ChkPopUpMenu == NO)
                        commonLabel.text = strETA1;
                    else
                    {    
                        commonLabel.text = estimatedArrival.CDate; 
                       // NSArray *splitA = [strETA1 componentsSeparatedByString:@" "];
                        
                        //[estimatedArrival.BDateT setTitle:[NSString stringWithFormat:@" %@ %@ %@",[splitA objectAtIndex:0],[splitA objectAtIndex:1],[splitA objectAtIndex:2]] forState:UIControlStateNormal];
                        
                        
                        [estimatedArrival.MSG_DATE setText:strETA1];
                        
                    }
                    
                    [cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    
                    
                    if (!(ETAPopupShowFlag))
                    {
                        
                        ETAPopupShowFlag = NO;
                        ChkPopUpMenu = YES;
                        
                        /* etaView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, 285, 150)];
                         self.etaView.layer.cornerRadius = 10.0;
                         self.etaView.backgroundColor = [UIColor grayColor];
                         
                         self.etaView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
                         self.etaView.alpha = 1;
                         
                         rgtLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 285, 30)];
                         rgtLabel.backgroundColor = [UIColor grayColor];
                         rgtLabel.text = @"Estimated arrival at customer:";
                         
                         
                         butETAValue = [UIButton buttonWithType:UIButtonTypeCustom];
                         butETAValue.frame = CGRectMake(50, 70, 180, 30);
                         butETAValue.backgroundColor = [UIColor clearColor];
                         [butETAValue setTitle:strETA1 forState:UIControlStateNormal];
                         [butETAValue addTarget:self action:@selector(butETAValueClicked:) forControlEvents: UIControlEventTouchUpInside];
                         
                         
                         
                         canButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         canButton.frame = CGRectMake(105, 110, 85, 30);
                         [canButton setTitle:@"Done" forState:UIControlStateNormal];
                         [canButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents: UIControlEventTouchDown];
                         
                         //savButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         // savButton.frame = CGRectMake(150, 110, 85, 30);
                         // [savButton setTitle:@"Save" forState:UIControlStateNormal];
                         // [savButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents: UIControlEventTouchDown];
                         
                         
                         
                         
                         [self.etaView addSubview:butETAValue];
                         [self.etaView addSubview:rgtLabel];
                         [self.etaView addSubview:canButton];
                         [self.etaView addSubview:savButton];
                         [self.view addSubview:self.etaView];*/
                        
                        
                        
                        
                        estimatedArrival= [[EstimatedArrival alloc] initWithNibName:@"EstimatedArrival_ipad" bundle:Nil];
                        [estimatedArrival setDelegate:self];
                        
                        estimatedArrival.CDate = strETA1;
                        
                        
                        
                        UIColor *VColor  = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                        
                        estimatedArrival.view.backgroundColor = VColor;
                        [self.view addSubview:estimatedArrival.view];
                        
                        [estimatedArrival.MSG_DATE setText:strETA1];
                        
                        
                    }
                    
                    
                    
                    
                    flag = 1;
                    service_count = 1;
                    
					break;
                }
                    
                    
                    
            }
            
            
            
            if(total_count < 6)
                service_count =0;  
            else
                service_count =1;  
            
            
        }
        
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
                    
                    
                    //Create view for Header text display
                    CGRect rectView= CGRectMake(29, 2, self.view.frame.size.width-510, 41);
                    UIView *headerView1 = [[UIView alloc] initWithFrame:rectView];
                    [headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                    [headerView1 setBackgroundColor:[UIColor clearColor]];
                    headerView1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    headerView1.layer.masksToBounds = YES;
                    headerView1.layer.cornerRadius = 8.0;
                    headerView1.layer.borderWidth = 1.0f;
                    //headerView1.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
                    headerView1.layer.borderColor = [UIColor blackColor].CGColor;
                    
                    //Display Header line one and two
                    //UITextField *txtHeader1,*txtHeader2;
                    //UILabel *lblHeader1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, self.view.frame.size.width-20, 30)];
                    UILabel *lblHeader1 = [[UILabel alloc] init];
                    lblHeader1 = [Design LabelFormationWithColor:2.0 :0.0 :_framewidth-500 :35:16.0f :1];
                    lblHeader1.text = [NSString stringWithFormat:@"Service Location"];
                    //lblHeader1.adjustsFontSizeToFitWidth=YES;
                    lblHeader1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader1.font = [lblHeader1.font fontWithSize:14.0f];
                    [headerView1 addSubview:lblHeader1];
                    
                    
                    //UILabel *lblHeader2 = [[UILabel alloc] initWithFrame:CGRectMake(2,32, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader2 = [[UILabel alloc] init];
                    lblHeader2 = [Design LabelFormationWithColor:2.0 :32.0 :_framewidth-500 :25:16.0f :1];
                    lblHeader2.text = [NSString stringWithFormat:@"%@ %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG2"]];
                    ////lblHeader2.adjustsFontSizeToFitWidth=YES;
                    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader2.font = [lblHeader2.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader2];
            
                    //UILabel *lblHeader3 = [[UILabel alloc] initWithFrame:CGRectMake(2,58, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader3 = [[UILabel alloc] init];
                    lblHeader3 = [Design LabelFormationWithColor:2.0 :56.0 :_framewidth-500 :25:16.0f :1];
                    lblHeader3.text = [NSString stringWithFormat:@"%@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"]];
                    //lblHeader3.adjustsFontSizeToFitWidth=YES;
                    lblHeader3.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader3.font = [lblHeader3.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader3];
                    
                    
                    //UILabel *lblHeader4 = [[UILabel alloc] initWithFrame:CGRectMake(2,84, self.view.frame.size.width-20, 25)];
                    UILabel *lblHeader4 = [[UILabel alloc] init];
                    lblHeader4 = [Design LabelFormationWithColor:2.0 :77.0 :_framewidth-500 :25:16.0f :1];
                    
                    lblHeader4.text = [NSString stringWithFormat:@"%@, %@, %@",
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"],
                                       [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"]];
                    //lblHeader4.adjustsFontSizeToFitWidth=YES;
                    lblHeader4.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                    lblHeader4.font = [lblHeader4.font fontWithSize:12.0f];
                    [headerView1 addSubview:lblHeader4];
                    
                    
                    cell.userInteractionEnabled = FALSE;
                    [cell.contentView addSubview:headerView1];
                    [headerView1 autorelease];
                    
                    
                    break;
                    
                    
                case 1:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Category",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Category",@"");				
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    break;
                    
                case 2:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_serordertype",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_serordertype",@"");				
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    NSString *strProcessType = [NSString stringWithFormat:@"%@ (%@)",[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE_DESCR"],[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]];
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"]:2]:15.0f :2];
                    commonLabel.text = strProcessType;
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    break;
                    
                    
                case 3:
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Priority",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Priority",@"");				
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    
                    commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"PRIORITY"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    break;
                    
                case 4:     
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Status",@""):1]:16.0f :1];
                    commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Status",@"");				
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    CGRect frame1 = CGRectMake(188, 5.0, 155.0, 35.0);
					txtStatus = [[UITextField alloc] initWithFrame:frame1];
					txtStatus.borderStyle =  UITextBorderStyleRoundedRect;
					txtStatus.textColor = [UIColor blackColor];
					txtStatus.font = [UIFont systemFontOfSize:12.0];
					txtStatus.backgroundColor = [UIColor lightGrayColor];
					
					txtStatus.keyboardType = UIKeyboardTypeDefault;
					txtStatus.returnKeyType = UIReturnKeyDone;	
					
					txtStatus.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtStatus.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtStatus.enabled = FALSE;
					txtStatus.text = [objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"];
					
					// Add an accessibility label that describes the text field.
					[txtStatus setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtStatus.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
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
                    [commonLabel release], commonLabel = nil;
                    
            
                    commonLabel = [Design LabelFormation:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]:2]:15.0f :2];
                    commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"];
                    [cell.contentView addSubview:commonLabel];
                    [commonLabel release], commonLabel = nil;
                    
                    
                    break;
               /* case 6:  temporary comment this row by selvan on 30/01/2013
                    
                    commonLabel = [Design LabelFormationWithColor:5.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Time_Zone",@""):1]:16.0f :1];	
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Time_Zone",@"");				
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
					
					
                    
                    //commonLabel = [Design LabelFormation:163.0 :5.0 :155.0 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"]:2]:15.0f :2];	
                    // commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
                    // [cell.contentView addSubview:commonLabel];
                    // [commonLabel release], commonLabel = nil;
                    
                    CGRect frame3 = CGRectMake(163, 5.0, 155.0, 35.0);
					txtTimeZone = [[UITextField alloc] initWithFrame:frame3];
					txtTimeZone.borderStyle =  UITextBorderStyleRoundedRect;
					txtTimeZone.textColor = [UIColor blackColor];
					txtTimeZone.font = [UIFont systemFontOfSize:12.0];
					txtTimeZone.backgroundColor = [UIColor lightGrayColor];
					
					txtTimeZone.keyboardType = UIKeyboardTypeDefault;
					txtTimeZone.returnKeyType = UIReturnKeyDone;	
					
					txtTimeZone.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
					
					//txtTimeZone.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
					txtTimeZone.enabled = FALSE;
					txtTimeZone.text = [objServiceManagementData.taskDataDictionary objectForKey:@"TIME_ZONE"];
					
					// Add an accessibility label that describes the text field.
					[txtTimeZone setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
					
					txtTimeZone.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_icon.gif"]];
					txtTimeZone.rightViewMode = UITextFieldViewModeAlways;
					
					txtTimeZone.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
					[cell.contentView addSubview:txtTimeZone];
                    
                    
                    break;*/
                case 6:
                    
                    NSLog(@"Status %@",[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"]);
                    
                    commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(@"Edit_Task_Label_Note",@""):1]:16.0f :1];
					commonLabel.text = NSLocalizedString(@"Edit_Task_Label_Note",@"");
					[cell.contentView addSubview:commonLabel];
					[commonLabel release], commonLabel = nil;
                    
                    
                    
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
                    
                case 7:
                    
                    
                    if([[TableTitle objectAtIndex:0] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        
                        /* displayTask = [self DisplayTextView:displayTask];
                         
                         displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                         
                         [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:0];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-500 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:0]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    } 
                    
                    
                    
                    break;
                case 8:
                    
                    if([[TableTitle objectAtIndex:1] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        
                        /* displayTask = [self DisplayTextView:displayTask];
                         
                         displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                         
                         [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        //Telephone Number
                        title = [TableTitle objectAtIndex:1];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                       /* commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;*/
                        
                        
                        //Create view for Header text display
                        CGRect rectView= CGRectMake(188.0,5.0,200, 41);
                        UIView *customView = [[UIView alloc] initWithFrame:rectView];
                        [customView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                        [customView setBackgroundColor:[UIColor clearColor]];
  
                        customView.layer.borderWidth = 0.0f;
                       // customView.layer.borderColor = [UIColor clearColor];
                           
                        UILabel *lblValue = [[UILabel alloc] init];
                        lblValue = [Design LabelFormationWithColor:2.0 :0.0 :150.0 :35:16.0f :1];
                        lblValue.text = [NSString stringWithFormat:@"%@",[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:1]]];
                        //lblValue.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                        lblValue.font = [lblValue.font fontWithSize:14.0f];
                        [customView addSubview:lblValue];
                        
                        UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        telButton.frame = CGRectMake(152.0, 2.0, 30, 30);
                        [telButton setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
                        [telButton addTarget:self action:@selector(dailNumber1) forControlEvents: UIControlEventTouchUpInside];
                        [customView addSubview:telButton];
                        
                        [cell.contentView addSubview:customView];
                        [customView release]; [lblValue release];
                        
                    }
                    
                    break;
                    
                case 9:
                    
                    if([[TableTitle objectAtIndex:2] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
 
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        //Alternative Telephone number
                        title = [TableTitle objectAtIndex:2];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        /*commonLabel = [Design LabelFormationWithColor:163.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]];
                                               
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;*/
                        
                        //Create view for Header text display
                        CGRect rectView= CGRectMake(188.0,5.0, 200, 41);
                        UIView *customView = [[UIView alloc] initWithFrame:rectView];
                        [customView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
                        [customView setBackgroundColor:[UIColor clearColor]];
                        
                        customView.layer.borderWidth = 0.0f;
                        // customView.layer.borderColor = [UIColor clearColor];
                        
                        UILabel *lblValue = [[UILabel alloc] init];
                        lblValue = [Design LabelFormationWithColor:2.0 :0.0 :150.0 :35:16.0f :1];
                        lblValue.text = [NSString stringWithFormat:@"%@",[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:2]]];
                        //lblValue.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
                        lblValue.font = [lblValue.font fontWithSize:14.0f];
                        [customView addSubview:lblValue];
                        
                        UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        telButton.frame = CGRectMake(153.0, 2.0, 30, 30);
                        [telButton setImage:[UIImage imageNamed:@"call_icon.jpg"] forState:UIControlStateNormal];
                        [telButton addTarget:self action:@selector(dailNumber1) forControlEvents: UIControlEventTouchUpInside];
                        [customView addSubview:telButton];
                        
                        [cell.contentView addSubview:customView];
                        [customView release]; [lblValue release];
                        
                    }
                    
                    break;
                    
                    
                case 10:
                    
                    
                    if([[TableTitle objectAtIndex:3] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        
                        /* displayTask = [self DisplayTextView:displayTask];
                         
                         displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                         
                         [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:3];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:3]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;                   
                    }   
                    
                    break;
                    
                case 11:
                    
                    if([[TableTitle objectAtIndex:4] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        
                        /* displayTask = [self DisplayTextView:displayTask];
                         
                         displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                         
                         [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:4];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:4]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                    }    
                    break;
                    
                case 12:
                    
                    if([[TableTitle objectAtIndex:5] isEqualToString:@"Other Details"]) 
                    {
                        
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        
                        /* displayTask = [self DisplayTextView:displayTask];
                         
                         displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                         [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                         [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                         
                         [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:5];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:5]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil; 
                        
                    }    
                    break;
                    
                    
                case 13:
                    
                    
                    if([[TableTitle objectAtIndex:6] isEqualToString:@"Other Details"]) 
                    {
                        [self createDetailContent];
                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];

                        
                       /* displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];*/
                        rowIndex = indexPath.row;

                        
                    }
                    else {
                        
                        title = [TableTitle objectAtIndex:6];
                        commonLabel = [Design LabelFormationWithColor:30.0 :5.0 :140.0 :[self labelHeightCalculation:NSLocalizedString(title,@""):1]:16.0f :1];
                        commonLabel.text = NSLocalizedString(title,@"");				
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        NSLog(@"FRAME WIDTH1: %f", _framewidth);
                        commonLabel = [Design LabelFormationWithColor:188.0 :5.0 :_framewidth-20 :[self labelHeightCalculation:[objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]]:2]:15.0f :2];
                        commonLabel.text = [objServiceManagementData.taskDataDictionary objectForKey:[TableData objectAtIndex:6]];
                        [cell.contentView addSubview:commonLabel];
                        [commonLabel release], commonLabel = nil;
                        
                        
                        break;
                        
                        
                    case 14:
                        
                        
                        rowIndex = indexPath.row;

                       
                        /*displayTask = [self DisplayTextView:displayTask];
                        
                        displayTask.text = [NSString stringWithFormat:@"Other Details \n Customer# %@ \n \n First Service Item \n %@",
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"],
                                            [objServiceManagementData.taskDataDictionary objectForKey:@"REFOBJ_PRODUCT_ID"]];
                        
                        [cell.contentView addSubview:displayTask];
                        break;*/
                        
                        [self createDetailContent];
                        
                      

                        cell.userInteractionEnabled = FALSE;
                        [cell.contentView addSubview:headerView22];
                        [headerView22 autorelease];
                        
                        break;
                        
                        
                        
                    }
            } //End of block while Status is Declined and that time  'Select a reason' and 'Enter the reason' block will displayed.. 
       		
        }
        
    }     
    
    return cell;
}

-(void)createDetailContent {
   
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    BOOL _dispNote = FALSE;
    BOOL _discrip = FALSE;
    float h1y;


    //Create view for Header text display
    CGRect rectView;
    if(![[objServiceManagementData.taskDataDictionary objectForKey:@"DESCRIPTION"] isEqualToString:@""]){
        rectView = CGRectMake(29, 2, self.view.frame.size.width-510, 145);
        h1y = 102.0;
        _discrip = TRUE;
    }
    else {
        rectView = CGRectMake(29, 2, self.view.frame.size.width-510, 45);
        h1y = 2.0;
        _discrip = FALSE;
    }
    
    headerView22 = [[UIView alloc] initWithFrame:rectView];
    [headerView22 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView22 setBackgroundColor:[UIColor clearColor]];
    //headerView22.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    
    
    CGRect rectView2;
    if([[objServiceManagementData.taskDataDictionary objectForKey:@"NOTE"] isEqualToString:@""]){
     rectView2= CGRectMake(2, h1y, self.view.frame.size.width-510, 40);
     _dispNote = FALSE;
     }
     else {
     rectView2= CGRectMake(2, h1y, self.view.frame.size.width-510, 145);
     _dispNote = TRUE;
     }
    
    headerView2 = [[UIView alloc] initWithFrame:rectView2];
    [headerView2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView2 setBackgroundColor:[UIColor clearColor]];
    headerView2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    headerView2.layer.masksToBounds = YES;
    headerView2.layer.cornerRadius = 8.0;
    headerView2.layer.borderWidth = 1.0f;
    //headerView2.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
    //headerView2.layer.borderColor = [UIColor blackColor].CGColor;
    
    //Display Header line one and two
    UILabel *lblHeader11 = [[UILabel alloc] init];
    lblHeader11 = [Design LabelFormationWithColor:2.0 :0.0 :self.view.frame.size.width-100 :35:16.0f :1];
    lblHeader11.text = [NSString stringWithFormat:@"Other Details"];
    lblHeader11.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader11.font = [lblHeader11.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader11];
    
    UILabel *lblHeader12 = [[UILabel alloc] init];
    lblHeader12 = [Design LabelFormationWithColor:2.0 :32.0 :self.view.frame.size.width-100 :25:16.0f :1];
    lblHeader12.text = [NSString stringWithFormat:@"Customer# %@",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"PARTNER"]];
    lblHeader12.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader12.font = [lblHeader12.font fontWithSize:12.0f];
    [headerView2 addSubview:lblHeader12];
    
    
    UILabel *lblHeader13 = [[UILabel alloc] init];
    lblHeader13 = [Design LabelFormationWithColor:2.0 :54.0 :self.view.frame.size.width-100 :35:16.0f :1];
    lblHeader13.text = [NSString stringWithFormat:@"First Service Item"];
    lblHeader13.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader13.font = [lblHeader13.font fontWithSize:14.0f];
    [headerView2 addSubview:lblHeader13];
    
    UILabel *lblHeader14 = [[UILabel alloc] init];
    lblHeader14 = [Design LabelFormationWithColor:2.0 :85.0 :self.view.frame.size.width-100 :25:16.0f :1];
    lblHeader14.text = [NSString stringWithFormat:@"%@ %@",
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCT"],
                        [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEPRODUCTDESCR"]];
    lblHeader14.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader14.font = [lblHeader14.font fontWithSize:12.0f];
    [headerView2 addSubview:lblHeader14];
    
    if (_dispNote) {
      
        UILabel *lblHeader15 = [[UILabel alloc]init];
        lblHeader15 = [Design LabelFormationWithColor:5.0 :107.0 :self.view.frame.size.width-100 :35:16.0f :1];
        lblHeader15.text = [NSString stringWithFormat:@"Service Note"];
        lblHeader15.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        lblHeader15.font = [lblHeader15.font fontWithSize:14.0f];
        [headerView2 addSubview:lblHeader15];
    
        UILabel *lblHeader16 = [[UILabel alloc]init];
        lblHeader16 = [Design LabelFormationWithColor:5.0 :130.0 :self.view.frame.size.width-100 :50:16.0f :1];
        lblHeader16.numberOfLines = 5;
        lblHeader16.text = [NSString stringWithFormat:@"%@",
                           [objServiceManagementData.taskDataDictionary objectForKey:@"NOTE"]];
        lblHeader16.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        lblHeader16.font = [lblHeader16.font fontWithSize:12.0f];
        [headerView2 addSubview:lblHeader16];
    
    }
    
    CGRect rectView1 = CGRectMake(2, 2, self.view.frame.size.width-510, 6);
   
    //Display Header line one and two
     headerView21 = [[UIView alloc] initWithFrame:rectView1];
    [headerView21 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView21 setBackgroundColor:[UIColor clearColor]];
    headerView21.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    headerView21.layer.masksToBounds = YES;
    headerView21.layer.cornerRadius = 8.0;
    headerView21.layer.borderWidth = 1.0f;
    //headerView2.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];
    //headerView21.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *lblHeader51 = [[UILabel alloc] init];
    lblHeader51 = [Design LabelFormationWithColor:2.0 :2.0 :self.view.frame.size.width-100 :20:16.0f :1];
    lblHeader51.text = [NSString stringWithFormat:@"ServiceOrder Description"];
    lblHeader51.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader51.font = [lblHeader51.font fontWithSize:14.0f];
    [headerView21 addSubview:lblHeader51];
    
    UILabel *lblHeader52 = [[UILabel alloc] init];
    lblHeader52.numberOfLines = 2;
    lblHeader52 = [Design LabelFormationWithColor:2.0 :24.0 :self.view.frame.size.width-100 :20:16.0f :1];
    lblHeader52.text = [NSString stringWithFormat:@"%@",
                              [objServiceManagementData.taskDataDictionary objectForKey:@"DESCRIPTION"]];
    lblHeader52.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader52.font = [lblHeader52.font fontWithSize:12.0f];
    [headerView21 addSubview:lblHeader52];
    
    [headerView22 addSubview:headerView2];
    if(_discrip){
        [headerView22 addSubview:headerView21];
    }
    
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
-(UITableViewCell *)activityTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
	
	//Now we have to create the 3 buttons with images
	UIButton *button;
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(F_IMAGE1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_IMAGE1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	button = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	button.tag = F_IMAGE1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:button];
	[button release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(F_IMAGE2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_IMAGE2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	button = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	button.tag = F_IMAGE2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:button];
	[button release];

	return cell;
}


-(void) butETAValueClicked:(id)sender{
    [self.etaView removeFromSuperview];
    [self.etaView release];
    ETAPopupShowFlag = YES;
    //[datePicker datePickerView:self.myTableView :@"ETADate"];
    
    if (IS_IPHONE) {
        //calling date piker common class
        [datePicker datePickerView:self.myTableView :@"ETADate"];
    }
    else if (IS_IPAD) {
        //Biren changes on 01/02/2013
        //Call ipad pickerview control
        [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:estimatedArrival.MSG_view2.bounds myView:estimatedArrival.MSG_view1];
        //end
    }
    }


-(void) cancelButtonClicked:(id)sender{
    ETAPopupShowFlag = YES;
    [self.etaView removeFromSuperview];
    [self.etaView release];
}
-(void) saveButtonClicked:(id)sender{
    ETAPopupShowFlag = NO;
    [self.etaView removeFromSuperview];
    [self.etaView release];
    
 }


//Delegate function of table view..
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 	
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    //Biren changes on 01/02/2013
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //********end
    
	//If Status is Declined, 'Select a reason' and 'Enter the reason' block will displayed..
	if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
	{
        ETAPopupShowFlag = NO;
        
		if(indexPath.row == 4)
		{
            
            if (IS_IPHONE) {
             
			//calling picker view for iphone commented by selvan temporarly
			[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus"];
            }
            else if (IS_IPAD)
            {
            //Biren changes on 01/02/2013
              //Call ipad pickerview control
              [pic openPickerView:tableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
            //********end******************
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
			[datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell];
            //end
            }
		}
        
		else if(indexPath.row == 9)
		{
			//[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];
			
		}
	}
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"])
    {
        if(indexPath.row == 4)
		{
            if (IS_IPHONE) {
                
                //calling picker view for iphone commented by selvan temporarly
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus"];
            }
            else if (IS_IPAD)
            {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [pic openPickerView:tableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
                //********end******************
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
                [datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell];
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
                [datePicker datePickerView:self.myTableView :@"ETADate" uiElement:cell.bounds tableCell:cell];
                //end
            }

            
 		}
        
		else if(indexPath.row == 7)
		{
			//[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];
			
		}
        
        
    }
	else {
        ETAPopupShowFlag = NO;
        
		if(indexPath.row == 4)
		{
            if (IS_IPHONE) {
                
                //calling picker view for iphone commented by selvan temporarly
                [pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus"];
            }
            else if (IS_IPAD)
            {
                //Biren changes on 01/02/2013
                //Call ipad pickerview control
                [pic openPickerView:tableView classObjectName:self pickerArray:objStaticData.taskStatusArray PickerName:@"TaskStatus" uiElement:cell.bounds tableCell:cell];
                //********end******************
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
                [datePicker datePickerView:self.myTableView :@"DueDate" uiElement:cell.bounds tableCell:cell];
                //end
            }
		}
        
		else if(indexPath.row == 6)
		{
			//[pic openPickerView:self.myTableView classObjectName:self pickerArray:objStaticData.taskTimeZoneArray PickerName:@"TaskTimeZone"];
		}
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	CGPoint pt;
	pt = self.myTableView.contentOffset;	
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
		[objServiceManagementData.taskDataDictionary setObject:textView.text forKey:@"REASON_DESCRIPTION"];
    else if(textView == self.taskNotes)
        [objServiceManagementData.taskDataDictionary setObject:textView.text forKey:@"ZZFIELDNOTE"];
	
    if (textView == self.taskNotes || textView == self.taskReason )
    {
		_textField = textView;
        
        //move the main view, so that the keyboard does not hide it.
        //if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:NO];
        }
    }
    
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
    
    if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"] && [[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"] isEqualToString:@"Other"])
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
    
    
   
    
}



//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex==0)
	{	
		if(alertView.tag==3 || alertView.tag==4)
		{			
			//AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
			delegate.modifySearchWhenBackFalg = TRUE;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
		}
		else if(alertView.tag==5)
		{		
			//AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
			delegate.modifySearchWhenBackFalg = TRUE;
			self.view.userInteractionEnabled = TRUE;
			self.navigationItem.leftBarButtonItem.enabled = TRUE;
            if (!delegate.mErrorFlagSAP) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
		}
		else {
			if (alertView.tag != 55)
                if (!delegate.mErrorFlagSAP)
                    [self goBack];
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
    
    NSLog(@"task edit disc selvan %@",objServiceManagementData.taskDataDictionary);
    
    //Service Order UPDATE
    NSString *responseValue;
    NSString *_soUpdateQry = @"";
    
    
if ([objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"] != [NSNull null]) {
    
    
    //********DELETE ERROR MESSAGES RELATED TO THIS OBJECT_ID FROM TBL_ERRORLIST TABLE
    NSString *sqlQryStr3 = [NSString stringWithFormat:@"DELETE FROM 'TBL_ERRORLIST' WHERE apprefid = '%@'",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
    
    [objServiceManagementData excuteSqliteQryString:sqlQryStr3 :objServiceManagementData.serviceReportsDB :@"ERRORTABLE" :1];
    //********DELETE ERROR END.
    
    
    
    NSMutableArray *_inptArray = [[NSMutableArray alloc] init];
	[alert dismissWithClickedButtonIndex:1 animated:YES];
	[alert release];
	
	self.updateResponseMsgArray = [[NSMutableArray alloc] init];
	self.updateSucessFlag = TRUE;
    
   /* //Show processing Alert to User
    self.view.userInteractionEnabled = FALSE;
    customAlt = [[CustomAlertView alloc] init];
    [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
    */
    
    
    //Show processing Alert to User
    float _screenWidth = self.view.frame.size.width;
    float _screenHieght = self.view.frame.size.height;
    self.view.userInteractionEnabled = FALSE;
    customAlt = [[CustomAlertView alloc] init];
    [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(_screenWidth/2)-150 :(_screenHieght/2)-20 :140 :125.0]];
    
    
    
    objStaticData = [StaticData sharedStaticData];
    
    NSString *statusStr = @"";
    if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Accepted"])
        statusStr = @"ACPT";
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Deferred - no parts"])
        statusStr = @"DEFR";
    
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Ready"])
        statusStr = @"WAIT";
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Declined"])
        statusStr = @"RJCT";
    else if([[objServiceManagementData.taskDataDictionary objectForKey:@"STATUS"] isEqualToString:@"Completed"])
        statusStr = @"COMP";
    else
        statusStr = @"OPEN";
    
    
    
    //Creating datatype of service confirmation
    NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCDCMNT21[.]OBJECT_ID[.]PROCESS_TYPE[.]ZZKEYDATE[.]STATUS[.]STATUS_REASON[.]TIMEZONE_FROM[.]ZZETADATE[.]ZZETATIME[.]ZZFIELDNOTE"];
    [_inptArray addObject:strPar4];
    
    NSLog(@"task dic %@",objServiceManagementData.taskDataDictionary);
    
    //Creating the parameter of SOAP call to pass SAP...
    NSString *strPar5 = @"";
    if (statusStr == @"ACPT") {
        strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT21[.]%@[.]%@[.]%@[.]%@[.][.]%@[.]%@[.]%@[.]%@",
                   [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                   [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                   statusStr,
                   [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                   [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]
                   ];
        
        _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', ZZETADATE='%@', ZZETATIME='%@',ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' ",
                       [objServiceManagementData.dataTypeArray objectAtIndex:0],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       statusStr,
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZETADATE"]],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZETATIME"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]
                       ];
        
        
    }
    else if(statusStr == @"RJCT")
    {
        NSString *rejReason = [NSString stringWithFormat:@"%@ %@",[objServiceManagementData.taskDataDictionary objectForKey:@"REASON"],[objServiceManagementData.taskDataDictionary objectForKey:@"REASON_DESCRIPTION"]];
        
        strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT21[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.][.][.]%@",
                   [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                   [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                   statusStr,rejReason,
                    [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]
                   ];
        
        _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', STATUS_REASON='%@' ,ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' ",
                       [objServiceManagementData.dataTypeArray objectAtIndex:0],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       statusStr,
                       rejReason,
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        
        
    }
    else
    {
        strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT21[.]%@[.]%@[.]%@[.]%@[.][.]%@[.][.][.]%@",
                   [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"PROCESS_TYPE"],
                   [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                   statusStr,
                   [objServiceManagementData.taskDataDictionary objectForKey:@"TIMEZONE_FROM"],
                   [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"]];
        
        
        
        _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@',ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' ",
                       [objServiceManagementData.dataTypeArray objectAtIndex:0],
                       [objCurrentDateTime convertMMMDDformattoyyyMMdd:[objServiceManagementData.taskDataDictionary objectForKey:@"ZZKEYDATE"]],
                       statusStr,
                       [objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIELDNOTE"],
                       [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
        
        
    }
    
    [_inptArray addObject:strPar5];
    
        
    //AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    NSString *strDocumentData;
    NSString *strSignData;
    BOOL _updateStatus = FALSE;
    //Attach image as a document
    if (self.localSmallFilepathStr != nil) {
        
        NSString *SrcdocObjIdStr = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
        
        strDocumentData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",SrcdocObjIdStr,self.localSmallFilepathStr,delegate.encryptedImageString ];
        [_inptArray addObject:strDocumentData];
        //[strDocumentData release],strDocumentData = nil;
        
    }
    
    //Attach signature image as a document
    
    if (delegate.localSignFilePath !=nil) {
        
        NSString *SrcSignObjIdStr = [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"];
        
        strSignData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",SrcSignObjIdStr,delegate.localSignFilePath,delegate.encryptedSignString ];
        [_inptArray addObject:strSignData];
        //[strSignData release],strSignData = nil;
        
    }
    
    //If Internet connection is there call do sap updates here
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {
        //Normal service task edit save to local db
        
        
        
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        responseValue = [CheckedNetwork getResponseFromSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
        
        
        //responseValue = [gss_ServiceProWebService sendRequestSAP:_inptArray :@"SERVICE-DOX-STATUS-UPDATE":objServiceManagementData.serviceReportsDB:2:@"UPDATEDATA"];
        
        //if ( [responseValue isEqualToString:@"555-Success"] )
        if (delegate.mErrorFlagSAP) {
            UIAlertView *errAlert = [[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"AppDelegate_response_alert_title",@"")
                                     message:responseValue
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"AppDelegate_netChecking_alert_cancel_title",@"")
                                     otherButtonTitles:nil];
            [errAlert show];
            errAlert.tag = 4;
            [errAlert release];
            
            /*[objServiceManagementData.taskListArray removeAllObjects];
            NSString *_qryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]];
            //[objServiceManagementData fetchAndUpdateTaskList:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[objServiceManagementData.dataTypeArray objectAtIndex:0]]:-1];
            objServiceManagementData.taskListArray = [objServiceManagementData fetchDataFrmSqlite:_qryStr :objServiceManagementData.serviceReportsDB :@"SERVICE ORDER" :1];*/
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
        NSMutableArray *pastboardItemArray = [[[NSMutableArray alloc] init] autorelease];
        pastboardItemArray = [obj_gss_qp_pastboard getItemFromPastBord:@"servicepro"];
        
        //*******************************************************************************
        //SET PASTBOARD DETAILS
        //*******************************************************************************
        //[pastboardItemArray removeAllObjects];
        [pastboardItemArray addObject:serviceEditDataDic];
        
        BOOL setPastBoardStatus = [obj_gss_qp_pastboard setItemIntoPastBord:pastboardItemArray :@"servicepro"];
        _updateStatus = TRUE;
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"queueprocessor://com.gss.queueprocessor?sender#servicepro"]];
        
        
        //The following code fragment illustrates how one app can request the services of another app (“todolist” in this example is a hypothetical custom scheme registered by an app):
        
        //NSURL *myURL = [NSURL URLWithString:@"todolist://www.acme.com?Quarterly%20Report#200806231300"];
        //[[UIApplication sharedApplication] openURL:myURL];
        
        
        
        //NSLog(@"past arra %@", pastboardItemArray);
        //NSLog(@"pastboard %c", setPastBoardStatus);
        //back process code ended
    }
    
    
    if (_updateStatus){
        
        NSLog(@"UPDTE QUEYR %@",_soUpdateQry);
        
        //Update service order table
        if([objServiceManagementData excuteSqliteQryString:_soUpdateQry:objServiceManagementData.serviceReportsDB:@"UPDATE TASK":1]) {
            
            //Delete if any Declined SO in service order table
            NSString *soDltQry = [NSString stringWithFormat:
                                  @"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND STATUS='RJCT'",
                                  [objServiceManagementData.dataTypeArray objectAtIndex:0],
                                  [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
            //[objServiceManagementData deleteDataFromServiceManagmentDB:soDltQry];
            
            [objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.serviceReportsDB :@"DELETE REJECTED TASK" :0];
            
            
            //Delete if any rejected SO in service order table
            soDltQry = [NSString stringWithFormat:
                                  @"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND STATUS = 'COMP'",
                                  [objServiceManagementData.dataTypeArray objectAtIndex:0],
                                  [objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"]];
            //[objServiceManagementData deleteDataFromServiceManagmentDB:soDltQry];
            
            [objServiceManagementData excuteSqliteQryString:soDltQry :objServiceManagementData.serviceReportsDB :@"DELETE REJECTED TASK" :0];
            
            
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
            
            //NSLocalizedString(@"Edit_Task_TaskUpdation_Success_alert_title",@"")
            //Display the alert which is got from SAP response...
            //selvan  "message:alertMsg" i changed this line for demo purpose
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
        else {
            
            NSString *alertMsg = @"";
            
            for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
            {
                alertMsg =[self.updateResponseMsgArray objectAtIndex:i];
            }
            
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
    
    
    
    
     //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
}
    else
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
    }
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
}





@end
