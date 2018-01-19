
//
//  ServiceConfCreation.m
//  ServiceManagement
//
//  Created by gss on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceConfCreation.h"
#import "Constants.h"
#import "Design.h"
#import "StaticData.h"
#import "QuartzCore/QuartzCore.h"
#import "ServiceManagementData.h"
#import "ServiceConfirmation.h"
#import "ServiceConfActivity.h"
#import "FaultEditScr.h"
#import "SparesEdit.h"
#import "CustomDatePicker.h"
#import "AppDelegate_iPhone.h"
#import "CurrentDateTime.h"
#import "CustomPickerControl.h"
#import "ServiceOrders.h"
#import "ImagePreview.h"
#import "SignatureCapture.h"
#import "SignaturePreview.h"

#import "QSStrings.h"

#import "CustomAlertView.h"
#import "MainMenu.h"
#import "ColleagueList.h"

#import "Z_GSSMWFM_HNDL_EVNTRQST00Service.h"
#import "TouchXML.h"


#import "CheckedNetwork.h"

StaticData *objStaticData;
CustomDatePicker *datePicker;
CurrentDateTime *objCurrentDateTime;
CustomAlertView *customAlt;
int mNUMBER_EXT,spareNUMBER_EXT;
int mSRCDOC_NUMBER_EXT;

#define kSegmentedControlHeight 40.0
#define kLabelHeight			20.0

@implementation ServiceConfCreation

@synthesize toolbarActivity;
@synthesize toolbarSpares;
@synthesize toolbar;

@synthesize activityTable,faultTable,sparesTable;
@synthesize submitButton;
@synthesize faultDataArray;
@synthesize updateResponseMsgArray;
@synthesize updateSucessFlag;
@synthesize addButton,imageButton,attachButton;
@synthesize addMaterialButton;
@synthesize segmentedControl;
@synthesize alert;
@synthesize DeleteQuery;
@synthesize myTableView,myView;
@synthesize imageView;
@synthesize localSmallFilepathStr;
@synthesize encodedImageStr;
@synthesize imageScanButton;
@synthesize attachSignButton;


@synthesize checkBoxValueDictionary,checkBoxDictionary;




//This function will call when back from the pushed viewcontroller..
-(void)viewWillAppear:(BOOL)animated{
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	
	if (delegate.activeFaultSegmentIndexFlag == 10) {
		segmentIndex = 0;
        //self.toolbarActivity.hidden = FALSE;
		//[self viewDidLoad];
	}
	else if (delegate.activeFaultSegmentIndexFlag == 11) {
		segmentIndex = 1;
		[self.faultTable reloadData];
	}
	
	if (delegate.activitySparesEditedFlag){
		segmentIndex = 2;
        segmentedControl.selectedSegmentIndex=2;
		[self.sparesTable reloadData];	
	}
	
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	//check activity edited
	if (objServiceManagementData.updatedActivityArrayFlag){
        objServiceManagementData.updatedActivityArrayFlag = FALSE;
		[self.activityTable reloadData];
	}
    
    
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
        fixSpaceItem.width = 133;
        items = [NSArray arrayWithObjects:fixSpaceItem, menuItem, nil];
        
    }
    
    toolbar.items = items;
    [self.view addSubview:toolbar];
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	delegate.activeFaultSegmentIndexFlag = 0;
	
	
	self.title = @"Service Confirmation";
    //customize title text
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=self.navigationItem.title;
    tlabel.textColor=[UIColor whiteColor];
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //end
    
    //set initial value
    mNUMBER_EXT = 5100;
    spareNUMBER_EXT = 0;
    
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	self.faultDataArray = [[NSMutableArray alloc] init];
	datePicker = [[CustomDatePicker alloc] init];
	objStaticData = [StaticData sharedStaticData];
	objCurrentDateTime = [[CurrentDateTime alloc] init];
	
	
	objServiceManagementData.faultEditFlag = FALSE;
	
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
	
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitButtonClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release]; saveButton = nil;
	
    
    //Create view for Header text display
    CGRect rectView= CGRectMake(4, 2, 310, 95);
    headerView1 = [[UIView alloc] initWithFrame:rectView];
    [headerView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[headerView1 setBackgroundColor:[UIColor clearColor]];
    headerView1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
	headerView1.layer.borderColor = [UIColor redColor].CGColor;
    headerView1.layer.borderWidth = 1.0f;
    [self.view addSubview:headerView1];
	[headerView1 autorelease];
    
    //Display Header line one and two
    //UITextField *txtHeader1,*txtHeader2;
    lblHeader1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, 70, 30)];
    lblHeader1.text = [NSString stringWithFormat:@"Start Date"];
    lblHeader1.adjustsFontSizeToFitWidth=YES;
    lblHeader1.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    [headerView1 addSubview:lblHeader1];
    
    lblHeader2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 2, 100, 30)];
    lblHeader2.text = [NSString stringWithFormat:@"%@",
                       [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"ZZKEYDATE"]];
    lblHeader2.adjustsFontSizeToFitWidth=YES;
    lblHeader2.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader2.font = [lblHeader2.font fontWithSize:12.0f];
    [headerView1 addSubview:lblHeader2];
    
    
    lblHeader3 = [[UILabel alloc] initWithFrame:CGRectMake(2, 25, 80, 25)];
    lblHeader3.text = [NSString stringWithFormat:@"Service Doc"];
    lblHeader3.adjustsFontSizeToFitWidth=YES;
    lblHeader3.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    [headerView1 addSubview:lblHeader3];
    
    
    lblHeader4 = [[UILabel alloc] initWithFrame:CGRectMake(90, 26, 200, 25)];
    lblHeader4.text = [NSString stringWithFormat:@"%@ %@",
                       [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
                       [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"ZZITEM_DESCRIPTION"]];
    lblHeader4.adjustsFontSizeToFitWidth=YES;
    lblHeader4.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    lblHeader4.font = [lblHeader4.font fontWithSize:12.0f];
    [headerView1 addSubview:lblHeader4];
    
    
    
	//display header activity
	//Creating textview to display the task deatils...
	displayActivity = [Design textViewFormation:5.0 :57.0 :310.0 :40.0 :3 :self];
	displayActivity.backgroundColor = [UIColor clearColor];
	displayActivity.textColor = [UIColor blackColor];
	
	displayActivity.layer.masksToBounds = YES;
	displayActivity.layer.cornerRadius = 2.0;
	displayActivity.layer.borderWidth = 0.9;
	displayActivity.layer.borderColor =  [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor];			
	displayActivity.backgroundColor = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
	displayActivity.text = [NSString stringWithFormat:@"           %@    %@",
							[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"NUMBER_EXT"],
							[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"PRODUCT_ID"]];
	
	[self.view addSubview:displayActivity];
	
	//This dictionary for...gathering the value of check box...you can changed the way..to collect the value of check box.. 
	checkBoxValueDictionary = [[NSMutableDictionary alloc] init];
	checkBoxDictionary = [[NSMutableDictionary alloc] init];
	[self.checkBoxValueDictionary removeAllObjects];
    [self.checkBoxDictionary removeAllObjects];
	
	imagePicker = [[UIImagePickerController alloc] init];
	
    segmentIndex =0;
    
    
    pickerDisplayView = [[UIView alloc]initWithFrame:CGRectMake(0, 185, 320, 275)];
    
    [self.view addSubview:pickerDisplayView];
    [self performSelector:@selector(animateIn) withObject:nil afterDelay:0.25];
    //pickerDisplayView.hidden = YES;
    
    
	
    [self createActivityView];
    
	[self createFaultView];
	[self createSparesView];
	
    //Vivek Kumar - Start , Now we are using buttons for controlling Events 
    //[self createSegmentControl];
    
    // Instead of above added this Line 
    [self createButtonControl];
    
    //Vivek Kumar - End 
    
    
    //copy record from activity table to temporary activity table
    [self newButtonClicked:1];
    
    //copy material to material temp table when first time material segment load
    [self newMaterialButtonClicked:1];
    
    flag=2;
    segmentIndex =0;

}

#pragma mark -
#pragma mark camera access
//************************************************************************************************
//Image capture related codes
//************************************************************************************************
-(void)cameraBtnClicked{
//-(IBAction)cameraBtnClicked:(id)sender{
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

    NSString * base64String = [[[NSString alloc] init]autorelease];
    base64String = [QSStrings encodeBase64WithData:imageData];
    
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
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
            AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
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
            //attachButton.hidden = NO;
            
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
//************************************************************************************************
//image capture code ends here
//************************************************************************************************

#pragma mark -
#pragma mark signature
//************************************************************************************************
//signature capture related codes
//************************************************************************************************
-(void) scanBtnClicked{ 
//-(void) scanBtnClicked:(id)sender {
   SignatureCapture *objSignatureCapture = [[SignatureCapture alloc] initWithNibName:@"SignatureCapture" bundle:nil];
   [self.navigationController pushViewController:objSignatureCapture animated:YES];
   [objSignatureCapture release];
   objSignatureCapture = nil;

}
//************************************************************************************************
//signature capture related codes
//************************************************************************************************

#pragma mark -
#pragma mark custom view
//************************************************************************************************
//Custom View code start
//************************************************************************************************
-(CGRect)customViewFrameWithSize{
	
	//CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	//CGRect viewRect = CGRectMake(kLeftMargin, kSegmentedControlHeight + kControlYPlacement+2, 702, screenRect.size.height- (kSegmentedControlHeight+kControlYPlacement+44));
	//return viewRect;

	CGRect viewRect = CGRectMake(2, 100, 702, 275);
	return viewRect;
}
-(CGRect)customTableFrameWithSize{
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect viewRect = CGRectMake(0.00, 2.00, self.view.bounds.size.width - (kRightMargin + 3), screenRect.size.height- (kSegmentedControlHeight+18));
	return viewRect;	
}
-(void)createActivityView{
	
	
	activityView = [[UIView alloc] initWithFrame:[self customViewFrameWithSize]];
    [activityView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[activityView setBackgroundColor:[UIColor greenColor]];
	[self.view addSubview:activityView];
	activityView.hidden = YES;
	[activityView autorelease];
	
	
	self.activityTable = [[UITableView alloc] initWithFrame:
						  CGRectMake(2.00, 2.00, 700,activityView.bounds.size.height-48) ];
	self.activityTable.layer.masksToBounds = YES;
	self.activityTable.layer.cornerRadius = 5.0;
	self.activityTable.layer.borderWidth = 1.9;
	self.activityTable.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor]; 
	self.activityTable.alwaysBounceHorizontal= TRUE;
	[activityView addSubview:self.activityTable];
	
	self.activityTable.dataSource = self;
	self.activityTable.delegate  = self;
	
    self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(120, activityView.bounds.size.height-80, 30, 24)];
    [activityView addSubview:self.imageView];
    [self.imageView autorelease];
    
   
  	
	
}
-(void)createFaultView{
	
	faultView = [[UIView alloc] initWithFrame:[self customViewFrameWithSize]];
    [faultView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[faultView setBackgroundColor:[UIColor redColor]];
	[self.view addSubview:faultView];
	faultView.hidden = YES;
	[faultView autorelease];
	
	
	faultTable = [[UITableView alloc] initWithFrame:
				  CGRectMake(2.00, 2.00, 700, faultView.bounds.size.height-48) ];
	self.faultTable.layer.masksToBounds = YES;
	self.faultTable.layer.cornerRadius = 5.0;
	self.faultTable.layer.borderWidth = 1.9;
	self.faultTable.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor]; 
	[faultView addSubview:self.faultTable];
	self.faultTable.alwaysBounceHorizontal= TRUE;
	self.faultTable.dataSource = self;
	self.faultTable.delegate  = self;
	
}
-(void)createSparesView{
	
	SparesView = [[UIView alloc] initWithFrame:[self customViewFrameWithSize]];
    [SparesView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[SparesView setBackgroundColor:[UIColor greenColor]];
	[self.view addSubview:SparesView];
	SparesView.hidden = YES;
	//[SparesView release];
	
	self.sparesTable = [[UITableView alloc] initWithFrame:
						CGRectMake(2.00, 2.00, 700, SparesView.bounds.size.height-48) ];
	self.sparesTable.layer.masksToBounds = YES;
	self.sparesTable.layer.cornerRadius = 5.0;
	self.sparesTable.layer.borderWidth = 1.9;
	self.sparesTable.alwaysBounceHorizontal= TRUE;
	self.sparesTable.layer.borderColor = [[UIColor colorWithHue:0.0 saturation:0.5 brightness:0.75 alpha:1.0] CGColor]; 
	[SparesView addSubview:self.sparesTable];
	
	self.sparesTable.dataSource = self;
	self.sparesTable.delegate  = self;

}
-(void)createSegmentControl{
	
    //UIImage *segSelected = [[UIImage imageNamed:@"service_32_h.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    //[[UISegmentedControl appearance] setBackgroundImage:segSelected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    

	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Services", @"Fault", @"Spares",nil];
    /*NSArray *segmentImageContent = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"service_32_h.png"],
                                    [UIImage imageNamed:@"fault_32.png"],
                                    [UIImage imageNamed:@"spares_32.png"], nil];*/
	
	//label
	CGFloat yPlacement = kTopMargin;
	CGRect frame = CGRectMake(kLeftMargin, yPlacement, 230, kLabelHeight);
	
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	//yPlacement += kTweenMargin+kLabelHeight;
	frame = CGRectMake(kLeftMargin, 330, 230, kSegmentedControlHeight);
	segmentedControl.frame = frame;
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.alpha = 1;
	activityView.hidden = NO;
	//segmentedControl.tintColor = [UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
      
	[self.view addSubview:segmentedControl];
	[segmentedControl autorelease];

}


// Vivek Kumar G - Start 


-(void) createButtonControl{
    
    SegB1 = [UIButton buttonWithType:UIButtonTypeCustom];
    SegB1.frame = CGRectMake(0,329,80,43);
    [SegB1 setImage:[UIImage imageNamed:@"service1_32_new2.png"] forState:UIControlStateNormal];
    [SegB1 addTarget:self action:@selector(SegButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SegB1];
    
    SegB2 = [UIButton buttonWithType:UIButtonTypeCustom];
    SegB2.frame = CGRectMake(80,329,80,43);
    [SegB2 setImage:[UIImage imageNamed:@"fault1_32_new2.png"]  forState:UIControlStateNormal];
    [SegB2 addTarget:self action:@selector(SegButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SegB2];

    
    SegB3 = [UIButton buttonWithType:UIButtonTypeCustom];
    SegB3.frame = CGRectMake(160,329,80,43);
    [SegB3 setImage:[UIImage imageNamed:@"spareso1_32_new2.png"] forState:UIControlStateNormal];
    [SegB3 addTarget:self action:@selector(SegButton3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SegB3];

   /* 
    SegB4 = [UIButton buttonWithType:UIButtonTypeCustom];
    SegB4.frame = CGRectMake(240,329,80,43);
    [SegB4 setImage:[UIImage imageNamed:@"save1_32_new2.png"] forState:UIControlStateNormal];
    [SegB4 addTarget:self action:@selector(SegButton4:) forControlEvents:UIControlEventTouchUpInside];
    [SegB4 setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
    [self.view addSubview:SegB4];*/    
    
    
    activityView.hidden = NO;
    faultView.hidden = YES;
    SparesView.hidden = YES;
    self.activityTable.hidden = NO;
    self.faultTable.hidden = YES;
    self.sparesTable.hidden = YES;
    //[self.activityTable reloadData];
    
}
-(IBAction)SegButton1:(id)sender{
    
    if(flag == 1)
    {    
        
        segmentIndex=0;
        
        [SegB1 setImage:[UIImage imageNamed:@"service1_32_new2.png"] forState:UIControlStateNormal];
        [SegB2 setImage:[UIImage imageNamed:@"fault1_32_new2.png"]  forState:UIControlStateNormal];
        [SegB3 setImage:[UIImage imageNamed:@"spareso1_32_new2.png"] forState:UIControlStateNormal];
        [SegB4 setImage:[UIImage imageNamed:@"save1_32_new2.png"] forState:UIControlStateNormal];
        [SegB4 setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
          
        flag +=1;  
    }    

    
}
-(IBAction)SegButton2:(id)sender{
    if(flag == 2)
    {    
        [SegB1 setImage:[UIImage imageNamed:@"service1_32_h_new2.png"] forState:UIControlStateNormal];
        [SegB2 setImage:[UIImage imageNamed:@"fault1_32_h_new2.png"]  forState:UIControlStateNormal];
        [SegB3 setImage:[UIImage imageNamed:@"spares1_32_new2.png"] forState:UIControlStateNormal];
         [SegB3 setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        [SegB4 setImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        
        segmentIndex=1;
        
        activityView.hidden = YES;
        faultView.hidden = NO;
        SparesView.hidden = YES;
        self.activityTable.hidden = YES;
        self.faultTable.hidden = NO;
        self.sparesTable.hidden = YES;
        [self.faultTable reloadData];
        
        flag +=1; 
    }  
    else if (flag == 4)
    {
        
         segmentIndex=2;
        activityView.hidden = YES;
        faultView.hidden = YES;
        SparesView.hidden = NO;
        self.activityTable.hidden = YES;
        self.faultTable.hidden =YES;
        self.sparesTable.hidden = NO;
        [self.sparesTable reloadData];
         
       
        
        NSLog(@"User Clicked Spares Button");
        
    }

    
}
-(IBAction)SegButton3:(id)sender{
    
    if(flag == 3) {
        [SegB1 setImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        
        [SegB2 setImage:[UIImage imageNamed:@"sparesn_new2.png"]  forState:UIControlStateNormal];
        [SegB3 setImage:[UIImage imageNamed:@"service1_32_h_new2.png"] forState:UIControlStateNormal];
         [SegB3 setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        [SegB4 setImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        

        
        flag +=1;
        segmentIndex=2;
        activityView.hidden = YES;
        faultView.hidden = YES;
        SparesView.hidden = NO;
        self.activityTable.hidden = YES;
        self.faultTable.hidden =YES;
        self.sparesTable.hidden = NO;
        [self.sparesTable reloadData];

        
    } 
    else if (flag == 4)
    {
        
        segmentIndex=0;
        [SegB1 setImage:[UIImage imageNamed:@"service1_32_new2.png"] forState:UIControlStateNormal];
        [SegB2 setImage:[UIImage imageNamed:@"fault1_32_new2.png"]  forState:UIControlStateNormal];
        [SegB3 setImage:[UIImage imageNamed:@"spareso1_32_new2.png"] forState:UIControlStateNormal];
        [SegB4 setImage:[UIImage imageNamed:@"save1_32_new2.png"] forState:UIControlStateNormal];
         [SegB4 setBackgroundImage:[UIImage imageNamed:@"btn_bg2.png"] forState:UIControlStateNormal];
        
        activityView.hidden = NO;
        faultView.hidden = YES;
        SparesView.hidden = YES;
        self.activityTable.hidden = NO;
        self.faultTable.hidden = YES;
        self.sparesTable.hidden = YES;
        [self.activityTable reloadData];
        
        
        
        flag = 2;
        
    }
    

    
}
-(IBAction)SegButton4:(id)sender{
    
}



// End - Vivek Kumar G


//************************************************************************************************
//Custom View code end
//************************************************************************************************

#pragma mark -
#pragma mark Delegates
//************************************************************************************************
//Delegate function start
//************************************************************************************************
//Show menu
-(void) doMenu{
    
    UIActionSheet *editTaskMapViewServiceConfActionSheet;
    if (segmentIndex ==0)
    {
    //Action sheet to go Add new service, capture image,add signature...against one task...
	editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc] 
                                                            initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
                                                            delegate:self
                                                            cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")  
                                                            destructiveButtonTitle:NSLocalizedString(@"Confirmation_menu_newservice",@"")    
                                                            otherButtonTitles:                                                             
                                                            NSLocalizedString(@"Confirmation_menu_captureimage",@"") ,     
                                                            NSLocalizedString(@"Confirmation_menu_signature", @""),
                                                            nil];
	}
    else if (segmentIndex == 2)
    {
        //Action sheet to go Add new service, capture image,add signature...against one task...
      editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc] 
                                                                initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
                                                                delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")  
                                                                destructiveButtonTitle:NSLocalizedString(@"Confirmation_menu_newspares",@"")    
                                                                otherButtonTitles:                                                             
                                                                NSLocalizedString(@"Confirmation_menu_captureimage",@"") ,     
                                                                NSLocalizedString(@"Confirmation_menu_signature", @""),
                                                                nil];
    }
    else
    {
        //Action sheet to go Add new service, capture image,add signature...against one task...
       editTaskMapViewServiceConfActionSheet = [[UIActionSheet alloc] 
                                                                initWithTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_title",@"")
                                                                delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Servic_Orders_ActionSheet_Choose_Action_Cancel_title",@"")  
                                                                destructiveButtonTitle:NSLocalizedString(@"Confirmation_menu_captureimage",@"")    
                                                                otherButtonTitles:                                                               
                                                                NSLocalizedString(@"Confirmation_menu_signature", @""),
                                                                nil];
        
        
    }

    
    
	editTaskMapViewServiceConfActionSheet.tag = 2; //I have set tag, because two action sheet is present in this class..
	
	[editTaskMapViewServiceConfActionSheet showInView:self.view];
	[editTaskMapViewServiceConfActionSheet release], editTaskMapViewServiceConfActionSheet = nil;
}
//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    BOOL recDeletedFlag;
    recDeletedFlag = FALSE;
    
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.localImageFilePath = @"";
    delegate.signatureCaptured = FALSE;
	
    
    //Creating Sql string delete temporary record already created in acitity table
    NSString *DeleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"];
    
    if ([objServiceManagementData excuteSqliteQryString:DeleteSQl:objServiceManagementData.serviceReportsDB:@"DELETE ACTIVITY TEMP":1]) 
  
    //if([objServiceManagementData updateConfirmationDB:DeleteSQl])
        recDeletedFlag = TRUE;
    else
        recDeletedFlag = FALSE;
    
    //Creating Sql string delete temporary record already created
    NSString *deleteSQlSpare = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE 1"];
    
    if ([objServiceManagementData excuteSqliteQryString:deleteSQlSpare:objServiceManagementData.serviceReportsDB:@"DELETE SPARE TEMP":1]) 
    
    //if([objServiceManagementData updateConfirmationDB:deleteSQlSpare])
        recDeletedFlag = TRUE;
    else
        recDeletedFlag = FALSE;
    
    
    if (recDeletedFlag) 
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    
}	
-(void)segmentAction:(id)sender{
	//NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
	switch ([sender selectedSegmentIndex]) {
		case 0:
            
			activityView.hidden = NO;
			faultView.hidden = YES;
			SparesView.hidden = YES;
			self.activityTable.hidden = NO;
			self.faultTable.hidden = YES;
			self.sparesTable.hidden = YES;
			[self.activityTable reloadData];
            
            //self.toolbarActivity.hidden = FALSE;
            //self.toolbarSpares.hidden = YES;
			break;
		case 1:
			activityView.hidden = YES;
			faultView.hidden = NO;
			SparesView.hidden = YES;
			self.activityTable.hidden = YES;
			self.faultTable.hidden = NO;
			self.sparesTable.hidden = YES;
			[self.faultTable reloadData];
            //self.toolbarActivity.hidden = YES;
            //self.toolbarSpares.hidden = YES;
			break;
		case 2:
			activityView.hidden = YES;
			faultView.hidden = YES;
			SparesView.hidden = NO;
			self.activityTable.hidden = YES;
			self.faultTable.hidden =YES;
			self.sparesTable.hidden = NO;
			[self.sparesTable reloadData];
            //self.toolbarActivity.hidden = YES;
            //self.toolbarSpares.hidden = FALSE;
			break;
			
	}
	
	segmentIndex = [sender selectedSegmentIndex];
}
//delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	//ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	//EditTask *objEditTask;
    //ServiceOrderEdit *objServiceOrderEdit;
    
	//TaskLocationMapView *objTaskLocationMapView;
	//CGRect frame = CGRectMake(round((self.view.bounds.size.width - kImageWidth) / 2.0), kTopPlacement, kImageWidth, kImageHeight);
    //switch (buttonIndex) {
            //case 0:			
            //objServiceManagementData.editTaskId = self.rowIndex;			
            /*objEditTask = [[EditTask alloc] initWithNibName:@"EditTask" bundle:nil];
             [self.navigationController pushViewController:objEditTask animated:YES];	
             [objEditTask release], objEditTask = nil;*/
            
            //objServiceOrderEdit = [[ServiceOrderEdit alloc] initWithNibName:@"ServiceOrderEdit" bundle:nil];
            //[self.navigationController pushViewController:objServiceOrderEdit animated:YES];
            //[objServiceOrderEdit release],objServiceOrderEdit = nil;
            
            //     break;
       // case 0:		
       //     self.view.userInteractionEnabled = FALSE;
       //     self.navigationItem.rightBarButtonItem.enabled = FALSE;
       //     self.navigationItem.hidesBackButton = YES;
       //     customAlt = [[CustomAlertView alloc] init];
       //     [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):10.0 :160.0 :140.0 :125.0]];
            
      //      break;	
            
       // case 1:		
            //objServiceManagementData.editTaskId = self.rowIndex;
       //     objTaskLocationMapView = [[TaskLocationMapView alloc] initWithNibName:@"TaskLocationMapView" bundle:nil];
       //     [self.navigationController pushViewController:objTaskLocationMapView animated:YES];	
       //     [objTaskLocationMapView release], objTaskLocationMapView = nil;
       //     break;
   // }
    
}
//Delegate function of Action sheet..
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	//ServiceConfirmation *objServiceConfirmation;
	
	//call add new service activity
	if (actionSheet.tag == 2 && segmentIndex == 0 &&  buttonIndex == 0)
        [self newButtonClicked:2];
    //call add new spares
    else if(actionSheet.tag == 2 && segmentIndex == 2 && buttonIndex == 0)
        [self newMaterialButtonClicked:2];
    else if(actionSheet.tag == 2 && segmentIndex != 1 &&  buttonIndex == 1)
        [self cameraBtnClicked];
    else if(actionSheet.tag == 2 && segmentIndex != 1 &&  buttonIndex == 2)
        [self scanBtnClicked];
    else if(actionSheet.tag == 2 && segmentIndex == 1 &&  buttonIndex == 0)
        [self cameraBtnClicked];
    else if(actionSheet.tag == 2 && segmentIndex == 1 &&  buttonIndex == 1)
        [self scanBtnClicked];
    
    else {
        self.view.userInteractionEnabled = TRUE;
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.hidesBackButton = NO;
     }
    
}
//Delegate function for alert view..
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(buttonIndex==0)
	{	
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert release];
    }
	else {	
		
        [alert dismissWithClickedButtonIndex:1 animated:YES];
        [alert release];
        
        ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		
        if (alertView.tag == 2) {
            //Delete spares record
            if ([objServiceManagementData excuteSqliteQryString:self.DeleteQuery :objServiceManagementData.serviceReportsDB :@"DELETE SPARES TEMP":1])
            //if([objServiceManagementData updateConfirmationDB:self.DeleteQuery])
            {
                
                [objServiceManagementData.serviceOrderSpareTempArray removeAllObjects];	
                [objServiceManagementData fetchServiceOrderSpareTemp:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",@"ZGSCSMST_SRVCSPARE10_TEMP",objServiceManagementData.objectiveID]:-1];
                
                
                
                //Display the alert which is got from SAP response...
                
                alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Spares_Delete_Success_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Spares_Delete_Success_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
                alert.tag = 5;
                [alert show];
                segmentIndex = 2;
                [self.sparesTable reloadData];
            }	
            else {
                alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Spares_Delete_Failed_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Spares_Delete_Failed_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
                [alert show];
                alert.tag = 5;
                //[alert release];
            }
        }
        else if (alertView.tag == 1) {
            //Delete activity record
            if ([objServiceManagementData excuteSqliteQryString:self.DeleteQuery :objServiceManagementData.serviceReportsDB :@"DELETE ACTIVITY TEMP":1])
                //if([objServiceManagementData updateConfirmationDB:self.DeleteQuery])
            {
                
                [objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
                [objServiceManagementData fetchServiceOrderActivityTemp:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSCSMST_SRVCACTVTY10_TEMP"]:1];
				
                
                //Display the alert which is got from SAP response...
				
                alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Activity_Delete_Success_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Activity_Delete_Success_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
                [alert show];
                alert.tag = 6;
                segmentIndex = 0;
                [self.checkBoxDictionary removeAllObjects];
                [self.checkBoxValueDictionary removeAllObjects];
                
                [self.activityTable reloadData];
            }
            else {
                alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Activity_Delete_Failed_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Activity_Delete_Failed_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
                [alert show];
                alert.tag = 6;
            }
        }
        else if (alertView.tag == 3){
			
            if([objServiceManagementData updateConfirmationDB:self.DeleteQuery])
            {
				
				[objServiceManagementData.faultAllDataArray removeAllObjects];
				[objServiceManagementData fetchAndUpdateConfirmationFaultData:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT]:-1];			
				//Display the alert which is got from SAP response...			
				alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Fault_Delete_Success_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Fault_Delete_Success_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
				[alert show];
				alert.tag = 8;
				segmentIndex = 1;
                objServiceManagementData.NUMBER_EXT = @"";
				[self.faultTable reloadData];
                
				
				//segmentedControl.selectedSegmentIndex = 0;
                //segmentIndex = 0;
                //[self.activityTable reloadData];
			}	
            else {
				alert = [[UIAlertView alloc] 
                         initWithTitle:NSLocalizedString(@"Edit_Activity_Delete_Failed_alert_title",@"") 
                         message:@""  
                         delegate:self 
                         cancelButtonTitle:NSLocalizedString(@"Edit_Activity_Delete_Failed_alert_Cancel_title",@"") 
                         otherButtonTitles:nil];
				[alert show];
				alert.tag = 9;
                
			}
            
        }
        else if (alertView.tag == 10){
            [self CallSAPUpdate];	
            
        }
        
    }
    
}
// Declare animateIn
- (void)animateIn{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [pickerDisplayView setCenter:CGPointMake(0, 0)];
    [UIView commitAnimations];
}
//************************************************************************************************
//Delegate function end
//************************************************************************************************


#pragma mark -
#pragma mark Table view data source start
//**********************************************************************************************************************
//Table View - Start
//**********************************************************************************************************************
-(CGFloat)cellHeightCalculation:(NSString *)cellLabelValue{
	int countChar = cellLabelValue.length;
	
	if(countChar>90)
		return 78.0f;
	else if(countChar>70)
		return 68.0f;
	else if(countChar>45)
		return 58.0f;
	else
		return 43.0f;
	
	
}
-(CGFloat) labelHeightCalculation:(NSString *)cellTextDisplay{
	int countChar =  cellTextDisplay.length;
	
	if(countChar>90)
		return 65.0f;
	else if(countChar>70)
		return 60.0f;
	else if(countChar>45)
		return 50.0f;
	else
		return 35.0f;
	
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// Return the number of rows in the section.
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];    
	//return [objServiceManagementData fetchTotalRecordsCount:objServiceManagementData.serviceReportsDB:@"ZGSCSMST_SRVCRPRTDATA10"];
	if (self.segmentedControl.selectedSegmentIndex == 0){
		NSLog(@"activity count %d",[objServiceManagementData.serviceOrderActivityTempArray count]);
		return [objServiceManagementData.serviceOrderActivityTempArray count];
		
	}
	else if (self.segmentedControl.selectedSegmentIndex == 1) {
		return 1;
	}
	else if (self.segmentedControl.selectedSegmentIndex == 2) {
		NSLog(@"spares count %d",[objServiceManagementData.serviceOrderSpareTempArray count]);
		return [objServiceManagementData.serviceOrderSpareTempArray count];
		
	}
	else {
		return [objServiceManagementData.serviceOrderSelectedActivityArray count];
	}
	
	
	
	
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	displayActivity.text = [NSString stringWithFormat:@"           %@    %@",
							[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:[indexPath row]] objectForKey:@"PRODUCT_ID"],
							[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:[indexPath row]] objectForKey:@"QUANTITY"]
							];
	[self.view addSubview:displayServiceOrder];
}
// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	static NSString *identifier = @"MyCell";
	NSInteger mNumnerExt;
	NSInteger mActivityId;
	NSInteger mActivityIdDelete;
	NSInteger mSRCDOC_NUMBER_EXT;
	NSString *mSpareid;
	NSString *imageName;
	NSString *mStrNumberExt;
	UITableViewCell *cell;
	
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
	
	delegate.activitySparesEditedFlag = NO;
	
	delegate.activeFaultSegmentIndexFlag = 0;
	
		
	if (segmentIndex == 0){
		//if(cell == nil) 
        
        NSLog(@"activt %@",objServiceManagementData.serviceOrderActivityTempArray);
        
        
		cell = [self activityTableViewCellWithIdentifier:identifier];

		
		UILabel *lbl = (UILabel *)[cell viewWithTag:F_NUMBER1_TAG];
		lbl.text =  [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"QUANTITY"]];
		lbl.font = [UIFont systemFontOfSize:12.0f];
		lbl.textColor = [UIColor blueColor];
		
		UILabel *lbl1 = (UILabel *)[cell viewWithTag:F_NUMBER2_TAG];
		lbl1.text =  @"";// [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:[indexPath row]] objectForKey:@"PRODUCT_ID"]];
		lbl1.font = [UIFont systemFontOfSize:12.0f];
		lbl1.textColor = [UIColor blueColor];
		
		UILabel *lblText = (UILabel *)[cell viewWithTag:F_TEXT1_TAG];
		lblText.text =  [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"ZZITEM_DESCRIPTION"];
		lblText.font = [UIFont systemFontOfSize:12.0f];
		lblText.adjustsFontSizeToFitWidth = YES;
		lblText.minimumFontSize = 8.0f;
		
		UILabel *lblText1 = (UILabel *)[cell viewWithTag:F_TEXT2_TAG];
		lblText1.text = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"DATETIME_FROM"];
		lblText1.font = [UIFont systemFontOfSize:12.0f];
		lblText1.adjustsFontSizeToFitWidth = YES;
		lblText1.minimumFontSize = 8.0f;
		
		UILabel *lblText2 = (UILabel *)[cell viewWithTag:F_TEXT3_TAG];
		lblText2.text = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"DATETIME_TO"];
		lblText2.font = [UIFont systemFontOfSize:12.0f];
		lblText2.adjustsFontSizeToFitWidth = YES;
		lblText2.minimumFontSize = 8.0f;
		
		UILabel *lblText3 = (UILabel *)[cell viewWithTag:F_TEXT4_TAG];
		lblText3.text = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"TIME_ZONE"];
		lblText3.font = [UIFont systemFontOfSize:12.0f];
		lblText3.adjustsFontSizeToFitWidth = YES;
		lblText3.minimumFontSize = 8.0f;
		
		
		mNumnerExt = [[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"NUMBER_EXT"] intValue];
		mActivityId = [[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"ZGSCSMST_SRVCACTVTY10Id"] intValue];
		mActivityIdDelete = [[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"ZGSCSMST_SRVCACTVTY10Id"] intValue];
		mSRCDOC_NUMBER_EXT =[[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:[indexPath row]] objectForKey:@"SRCDOC_NUMBER_EXT"] intValue];
		
		if (mSRCDOC_NUMBER_EXT != 0) {
			mActivityIdDelete = 9999;
			mStrNumberExt = [NSString stringWithFormat:@"%d",mNumnerExt];
		}
		else {
			//mActivityIdDelete = mActivityId;
			mStrNumberExt = [NSString stringWithFormat:@"%d",mNumnerExt];
		}

		NSString *tempStr = [NSString stringWithFormat:@"%d",mActivityId];
		//Display the check box...is checkd or uncheked... depending upon the dictionary value...
		if([[self.checkBoxValueDictionary objectForKey:tempStr] boolValue] == YES)
			imageName = @"checked.png";
		else 
			imageName = @"unchecked.png";
		
		
		NSString *deleteid = [NSString stringWithFormat:@"%d",mActivityIdDelete];
		
		NSInteger rowIndex = [indexPath row];
		NSString *strRowIndex = [NSString stringWithFormat:@"%d",rowIndex];
		UIButton *editButton = (UIButton *) [cell viewWithTag:F_IMAGE1_TAG];
		[editButton setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
		[editButton setTitle:strRowIndex forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(ActivityeditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIButton *deleteButton = (UIButton *) [cell viewWithTag:F_IMAGE2_TAG];
		[deleteButton setTitle:deleteid forState:UIControlStateNormal];
		[deleteButton setImage:[UIImage imageNamed:@"delete.jpg"] forState:UIControlStateNormal];
		//deleteButton.tag = mActivityId;
		[deleteButton addTarget:self action:@selector(ActivitydeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *checkButton = (UIButton *) [cell viewWithTag:F_IMAGE3_TAG];
		[checkButton setTitle:mStrNumberExt forState:UIControlStateNormal];
		[checkButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		checkButton.tag = mActivityId;
		[checkButton addTarget:self action:@selector(ActivityeditCheckButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		[checkBoxDictionary setObject:checkButton forKey:mStrNumberExt];
        
        
		CGRect tvbounds = [tableView bounds];
		[self.activityTable setBounds:CGRectMake(tvbounds.origin.x, 
												 tvbounds.origin.y, 
												 tvbounds.size.width, 
												 tvbounds.size.height)];
        segmentedControl.selectedSegmentIndex = 0;
		
	}
	else if (segmentIndex == 1){
		
		//if(cell == nil) 
		cell = [self faultTableViewCellWithIdentifier:identifier];

        //Get check box selected record
        NSString *strIndexPathRow = [NSString stringWithFormat:@"%d",[indexPath row]+1];
        NSString *rowChecked= [self.checkBoxValueDictionary valueForKey:strIndexPathRow ];
        
        
		//fetch fault data records
		[objServiceManagementData.faultAllDataArray removeAllObjects];
		if (objServiceManagementData.NUMBER_EXT.length != 0) {

			//[objServiceManagementData fetchAndUpdateConfirmationFaultData:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT]:-1];
            
            //NSLog(@"sql %@",[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT,objServiceManagementData.objectiveID]);
            
            NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSCSMST_SRVCCNFRMTNFAULT20",objServiceManagementData.NUMBER_EXT];
            objServiceManagementData.faultAllDataArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOFAULTTEMP" :1]; 
            
            
		}
        NSLog(@"fault array %@", objServiceManagementData.faultAllDataArray);
        NSLog(@" check dic %@ %d",self.checkBoxValueDictionary, [indexPath row]);
      
		if ([objServiceManagementData.faultAllDataArray count] >0) {
            
           // ([[self.checkBoxDictionary objectForKey:[[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"SRVCCNFRMTNFAULT20Id"]] isEqualToString: @"TRUE"]) ) {
			
           // NSString *serId = [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"SRVCCNFRMTNFAULT20Id"];
            //NSLog(@" service id %@",serId);
           // NSLog(@"check status %@",[self.checkBoxValueDictionary objectForKey:serId]);
            
            
            //if ([[self.checkBoxValueDictionary objectForKey:[[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"SRVCCNFRMTNFAULT20Id"]] isEqualToString:@"TRUE" ]) {
      
            if ([indexPath row] < 1) {
           
			//Add edited fault code edited data into fault data array
						
			UILabel *lbl = (UILabel *)[cell viewWithTag:C_TEXT1_TAG];
			lbl.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZSYMPTMCODEGROUP"]];
			lbl.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lblText = (UILabel *)[cell viewWithTag:C_TEXT2_TAG];
			lblText.text =  [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZSYMPTMCODE"];
			lblText.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lbl3 = (UILabel *)[cell viewWithTag:C_TEXT3_TAG];
			lbl3.text = [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZPRBLMCODEGROUP"];
			lbl3.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lbl4 = (UILabel *)[cell viewWithTag:C_TEXT4_TAG];
			lbl4.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZPRBLMCODE"]];
			lbl4.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lbl5 = (UILabel *)[cell viewWithTag:C_TEXT5_TAG];
			lbl5.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZCAUSECODEGROUP"]];
			lbl5.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lbl6 = (UILabel *)[cell viewWithTag:C_TEXT6_TAG];
			lbl6.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZCAUSECODE"]];
			lbl6.font = [UIFont systemFontOfSize:12.0f];
			
			//mNumnerExt = [[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:[indexPath row]] objectForKey:@"NUMBER_EXT"] intValue];
            
            mNumnerExt  = [objServiceManagementData.NUMBER_EXT intValue];

			
			NSInteger rowIndex = [indexPath row];
			NSString *strRowIndex = [NSString stringWithFormat:@"%d",rowIndex];
            
			UIButton *editButton = (UIButton *) [cell viewWithTag:C_IMAGE1_TAG];
			[editButton setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
			[editButton setTitle:strRowIndex forState:UIControlStateNormal];
			[editButton addTarget:self action:@selector(FaulteditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			
			UIButton *deleteButton = (UIButton *) [cell viewWithTag:C_IMAGE2_TAG];
			[deleteButton setImage:[UIImage imageNamed:@"delete.jpg"] forState:UIControlStateNormal];
			[deleteButton setTitle:strRowIndex forState:UIControlStateNormal];
			deleteButton.tag = mNumnerExt;
			[deleteButton addTarget:self action:@selector(FaultDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			CGRect tvbounds = [tableView bounds];
			[self.faultTable setBounds:CGRectMake(tvbounds.origin.x, 
												  tvbounds.origin.y, 
												  tvbounds.size.width, 
												  tvbounds.size.height)];
		}
        }
		else if ([rowChecked isEqualToString:@"TRUE"]) {
			if (objServiceManagementData.NUMBER_EXT.length != 0) 
			{
				FaultEditScr *objFaultEditScr = [[FaultEditScr alloc] initWithNibName:@"FaultEditScr" bundle:nil];
				[self.navigationController pushViewController:objFaultEditScr animated:YES];
				[objFaultEditScr release];
				objFaultEditScr = nil;
			}
			else {
				UILabel *lbl = (UILabel *)[cell viewWithTag:C_TEXT1_TAG];
				lbl.text = @"";// [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZSYMPTMCODEGROUP"]];
				lbl.font = [UIFont systemFontOfSize:12.0f];
				
				
				UILabel *lblText = (UILabel *)[cell viewWithTag:C_TEXT2_TAG];
				lblText.text = @"";// [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZSYMPTMCODE"];
				lblText.font = [UIFont systemFontOfSize:12.0f];
				
				
				UILabel *lbl3 = (UILabel *)[cell viewWithTag:C_TEXT3_TAG];
				lbl3.text = @"";//[[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZPRBLMCODEGROUP"];
				lbl3.font = [UIFont systemFontOfSize:12.0f];
				
				
				UILabel *lbl4 = (UILabel *)[cell viewWithTag:C_TEXT4_TAG];
				lbl4.text =@"";// [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZPRBLMCODE"]];
				lbl4.font = [UIFont systemFontOfSize:12.0f];
				
				
				UILabel *lbl5 = (UILabel *)[cell viewWithTag:C_TEXT5_TAG];
				lbl5.text = @"";//[NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZCAUSECODEGROUP"]];
				lbl5.font = [UIFont systemFontOfSize:12.0f];
				
				
				UILabel *lbl6 = (UILabel *)[cell viewWithTag:C_TEXT6_TAG];
				lbl6.text = @"";//[NSString stringWithFormat:@"%@ ", [[objServiceManagementData.faultAllDataArray objectAtIndex:[indexPath row]] objectForKey:@"ZZCAUSECODE"]];
				lbl6.font = [UIFont systemFontOfSize:12.0f];
				
				
				
				NSInteger rowIndex = [indexPath row];
				NSString *strRowIndex = [NSString stringWithFormat:@"%d",rowIndex];
				UIButton *editButton2 = (UIButton *) [cell viewWithTag:C_IMAGE1_TAG];
				[editButton2 setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
				[editButton2 setTitle:strRowIndex forState:UIControlStateNormal];
				[editButton2 addTarget:self action:@selector(FaulteditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
				editButton2.enabled = FALSE;
				
				CGRect tvbounds = [tableView bounds];
				[self.faultTable setBounds:CGRectMake(tvbounds.origin.x, 
													  tvbounds.origin.y, 
													  tvbounds.size.width, 
													  tvbounds.size.height)];
			}
			
		}
		
		
	}
	else if (segmentIndex == 2){
		
        NSLog(@"spares count %d",[objServiceManagementData.serviceOrderSpareTempArray count]);
		//if(cell == nil) 
			cell = [self sparesTableViewCellWithIdentifier:identifier];
		if ([objServiceManagementData.serviceOrderSpareTempArray count] >= ([indexPath row]+1)) {
			
			UILabel *lblText = (UILabel *)[cell viewWithTag:S_TEXT1_TAG];
			lblText.text = [NSString stringWithFormat:@"%@",[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"PRODUCT_ID"]];
			lblText.font = [UIFont systemFontOfSize:12.0f];
			
			UILabel *lblText1 = (UILabel *)[cell viewWithTag:S_TEXT2_TAG];
			lblText1.text = [NSString stringWithFormat:@"%@",[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"ZZITEM_DESCRIPTION"]];
			lblText1.font = [UIFont systemFontOfSize:12.0f];
			
			UILabel *lbl = (UILabel *)[cell viewWithTag:S_NUMBER_TAG];
			lbl.text = [NSString stringWithFormat:@"%@ ", [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"QUANTITY"]];
			lbl.font = [UIFont systemFontOfSize:12.0f];
			
			
			UILabel *lblText2 = (UILabel *)[cell viewWithTag:S_TEXT3_TAG];
			lblText2.text =  [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"PROCESS_QTY_UNIT"];
			lblText2.font = [UIFont systemFontOfSize:12.0f];
			
			UILabel *lblText3 = (UILabel *)[cell viewWithTag:S_TEXT4_TAG];
			lblText3.text =  [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"SERIAL_NUMBER"];
			lblText3.font = [UIFont systemFontOfSize:12.0f];
			
			mSpareid = [NSString stringWithFormat:@"%@",[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:[indexPath row]] objectForKey:@"ZGSCSMST_SRVCSPARE10Id"]];
			NSInteger rowIndex = [indexPath row];
			NSString *strRowIndex = [NSString stringWithFormat:@"%d",rowIndex];

			
			UIButton *editButton1 = (UIButton *) [cell viewWithTag:S_IMAGE1_TAG];
			[editButton1 setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
			[editButton1 addTarget:self action:@selector(SparesEditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[editButton1 setTitle:strRowIndex forState:UIControlStateNormal];
			
			UIButton *deleteButton1 = (UIButton *) [cell viewWithTag:S_IMAGE2_TAG];
			[deleteButton1 setImage:[UIImage imageNamed:@"delete.jpg"] forState:UIControlStateNormal];
			[deleteButton1 addTarget:self action:@selector(SparesDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[deleteButton1 setTitle:mSpareid forState:UIControlStateNormal];
			

			CGRect tvbounds = [tableView bounds];
			[self.sparesTable setBounds:CGRectMake(tvbounds.origin.x, 
												   tvbounds.origin.y, 
												   tvbounds.size.width, 
												   tvbounds.size.height)];
			
		}		
	}
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 510, 24)];
	UILabel *HeaderLabel;
	//NSString *tblHeaderText = [NSString stringWithFormat:@"%@            %@        %@",@"Date",@"SO ID",@"Customer"];
    HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 510, 24)] ;
	HeaderLabel.textColor = [UIColor blackColor];
	HeaderLabel.backgroundColor = [UIColor grayColor];
	HeaderLabel.font = [UIFont systemFontOfSize:13.0f];
	
	if (segmentIndex == 0)
		HeaderLabel.text = [NSString stringWithFormat:@" %@            %@  %@      %@    %@    %@",@"         ",@"Service Description",@"Duration Hrs",@"Start Dt.Time",@"End Dt.Time",@"Notes"];
	else if (segmentIndex == 1) 
		HeaderLabel.text = [NSString stringWithFormat:@" %@                 %@     %@     %@     %@     %@     %@",@"Options",@"Symptom Grp",@"Symptom Code",@"Problem Grp",@"Problem Code",@"Cause Grp",@"Cause Code"];
	else if (segmentIndex == 2) 
		HeaderLabel.text = [NSString stringWithFormat:@" %@       %@    %@           %@       %@       %@",@"Options",@"Material Id",@"Mat Desc",@"Qty",@"Unit",@"Serial#"];
	
	[customView addSubview:HeaderLabel];
	[HeaderLabel release];
	
	return customView;
    
}
-(UITableViewCell *)activityTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
	
	//Now we have to create the two labels.
	UILabel *label;
	
	//Now we have to create the 3 buttons with images
	UIButton *but;
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(F_TEXT1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_TEXT1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = F_TEXT1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	cellRectangle = CGRectMake(F_TEXT2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_TEXT2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = F_TEXT2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(F_TEXT3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_TEXT3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = F_TEXT3_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(F_TEXT4_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_TEXT4_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = F_TEXT4_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(F_NUMBER1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_NUMBER1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.numberOfLines = 3;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = F_NUMBER1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(F_NUMBER2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_NUMBER2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.numberOfLines = 3;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = F_NUMBER2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(F_IMAGE1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_IMAGE1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = F_IMAGE1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(F_IMAGE2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_IMAGE2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = F_IMAGE2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(F_IMAGE3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, F_IMAGE3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = F_IMAGE3_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	return cell;
}
-(UITableViewCell *)faultTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
	
	//Now we have to create the two labels.
	UILabel *label;
	
	//Now we have to create the 3 buttons with images
	UIButton *but;
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(C_TEXT1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = C_TEXT1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(C_TEXT2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = C_TEXT2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(C_TEXT3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = C_TEXT3_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(C_TEXT4_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT4_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.numberOfLines = 1;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = C_TEXT4_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(C_TEXT5_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT5_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.numberOfLines = 1;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = C_TEXT5_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(C_TEXT6_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_TEXT6_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	label.numberOfLines = 1;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8.0f;
	//Mark the label with a tag
	label.tag = C_TEXT6_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(C_IMAGE1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_IMAGE1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = C_IMAGE1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(C_IMAGE2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_IMAGE2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = C_IMAGE2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	/*
	 //Create a rectangle container for the date text.
	 cellRectangle = CGRectMake(C_IMAGE3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, C_IMAGE3_WIDTH, LABEL_HEIGHT);
	 //Initialize the label with the rectangle.
	 but = [[UIButton alloc] initWithFrame:cellRectangle];
	 //Mark the label with a tag
	 but.tag = C_IMAGE3_TAG;
	 //Add the label as a sub view to the cell.
	 [cell.contentView addSubview:but];
	 [but release];*/
	
	
	return cell;
}
-(UITableViewCell *)sparesTableViewCellWithIdentifier:(NSString *)identifier {
	
	//Rectangle which will be used to create labels and table view cell.
	CGRect cellRectangle;
	
	//Returns a rectangle with the coordinates and dimensions.
	cellRectangle = CGRectMake(0.0, 0.0, CELL_WIDTH, ROW_HEIGHT);
	
	//Initialize a UITableViewCell with the rectangle we created.
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRectangle] autorelease];
	
	//Now we have to create the two labels.
	UILabel *label;
	//Now we have to create the 3 buttons with images
	UIButton *but;
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(S_TEXT1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_TEXT1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = S_TEXT1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(S_TEXT2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_TEXT2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = S_TEXT2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(S_TEXT3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_TEXT3_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = S_TEXT3_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	
	//Create a rectangle container for the custom text.
	cellRectangle = CGRectMake(S_TEXT4_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_TEXT4_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = S_TEXT4_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the number text.
	cellRectangle = CGRectMake(S_NUMBER_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_NUMBER_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	label = [[UILabel alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	label.tag = S_NUMBER_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:label];
	[label release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(S_IMAGE1_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_IMAGE1_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = S_IMAGE1_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	//Create a rectangle container for the date text.
	cellRectangle = CGRectMake(S_IMAGE2_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_IMAGE2_WIDTH, LABEL_HEIGHT);
	//Initialize the label with the rectangle.
	but = [[UIButton alloc] initWithFrame:cellRectangle];
	//Mark the label with a tag
	but.tag = S_IMAGE2_TAG;
	//Add the label as a sub view to the cell.
	[cell.contentView addSubview:but];
	[but release];
	
	
	
    //Create a rectangle container for the date text.
    cellRectangle = CGRectMake(S_IMAGE3_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, S_IMAGE3_WIDTH, LABEL_HEIGHT);
    //Initialize the label with the rectangle.
    but = [[UIButton alloc] initWithFrame:cellRectangle];
    //Mark the label with a tag
    but.tag = S_IMAGE3_TAG;
    //Add the label as a sub view to the cell.
    [cell.contentView addSubview:but];
    [but release];
	
	
	return cell;
}
//**********************************************************************************************************************
//Table View - End
//**********************************************************************************************************************

#pragma mark - 
#pragma mark custom button event
//**********************************************************************************************************************
//Button Event Start
//**********************************************************************************************************************
-(IBAction)ActivityeditButtonClicked: (id) sender {
	if (segmentIndex == 0) {
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		UIButton *but = [UIButton alloc];
		but= sender;
		objServiceManagementData.selectedRowIndex = [but.currentTitle intValue];
		ServiceConfActivity *objServiceConfActivity = [[ServiceConfActivity alloc] initWithNibName:@"ServiceConfActivity" bundle:nil];
		[self.navigationController pushViewController:objServiceConfActivity animated:YES];
		[objServiceConfActivity release];
		objServiceConfActivity = nil;
	}	
}
-(IBAction)ActivitydeleteButtonClicked: (id) sender{
	NSString *mRowIndex;
	
	if (segmentIndex == 0) {
		
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		UIButton *but = [UIButton alloc];
		but= sender;
		mRowIndex = [NSString stringWithFormat:@"%@",but.currentTitle];
		
		
		NSInteger mIntRowIndex = [mRowIndex intValue];

		if ([objServiceManagementData.serviceOrderActivityTempArray count] > 1 && mIntRowIndex != 9999) {
			
			//Creating Sql string for delete activity..
			self.DeleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE ZGSCSMST_SRVCACTVTY10Id = %d",mIntRowIndex];
			
			//Alert while try to delete
			alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_title",@"") 
											   message:NSLocalizedString(@"Service_Cnf_Delete_alert_msg",@"")
											  delegate:self 
									 cancelButtonTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_Cancel_title",@"")											
									 otherButtonTitles:NSLocalizedString(@"Service_Cnf_Delete_alert_Other_title",@""),
					 nil];
			alert.tag = 1; //Set the tag to tack, which alert is clicked..
			[alert show];
		}
		else {
			alert = [[UIAlertView alloc] 
											initWithTitle:NSLocalizedString(@"Edit_Activity_Delete_Norecord_alert_title",@"") 
											message:@""  
											delegate:self 
											cancelButtonTitle:NSLocalizedString(@"Edit_Activity_Delete_Norecord_alert_Cancel_title",@"") 
											otherButtonTitles:nil];
			[alert show];
			alert.tag = 7;
		}
			
		
	}
}
-(IBAction)ActivityeditCheckButtonClicked: (id) sender {
	if (segmentIndex == 0) {
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];	
		NSString *mNumberExt,*mgetChkButTitle;
		NSInteger mActivityId;
		
		UIButton *btn = (UIButton *)sender;
		mNumberExt = [NSString stringWithFormat:@"%@",btn.currentTitle];
		//mActivityId = [btn tag];
		//NSString *tempStr = [NSString stringWithFormat:@"%d",mActivityId];
        
        NSLog(@"dictionary %@",self.checkBoxDictionary);
        NSLog(@"n=%@  act=%d",mNumberExt, mActivityId);
        for (NSString* key in self.checkBoxDictionary) {
            id value = [self.checkBoxDictionary objectForKey:key];
            UIButton *chkbtn = (UIButton *)value;
            mgetChkButTitle = [NSString stringWithFormat:@"%@",chkbtn.currentTitle];
            mActivityId = [chkbtn tag];
            NSString *tempStr = [NSString stringWithFormat:@"%d",mActivityId];
 
            
            if ([mNumberExt isEqualToString:mgetChkButTitle]) {
                if([[self.checkBoxValueDictionary objectForKey:tempStr] boolValue] == NO){
                    [self.checkBoxValueDictionary setObject:@"TRUE" forKey:tempStr];
                    [sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                    objServiceManagementData.NUMBER_EXT = mNumberExt; // tempStr;
                    objServiceManagementData.SRVCACTVTY10ID = mActivityId;
                }
                else
                {
                    [self.checkBoxValueDictionary setObject:@"FALSE" forKey:tempStr];
                    [sender setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
                    objServiceManagementData.NUMBER_EXT = mNumberExt; // tempStr;
                    objServiceManagementData.SRVCACTVTY10ID = mActivityId;

                }
            }
            else
            {
                [self.checkBoxValueDictionary setObject:@"FALSE" forKey:tempStr];
                [sender setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            }            
        }    	
        
       /* 
		if([[self.checkBoxValueDictionary objectForKey:tempStr] boolValue] == YES){
			[self.checkBoxValueDictionary setObject:@"FALSE" forKey:tempStr];
			[sender setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            objServiceManagementData.NUMBER_EXT = @"";
            objServiceManagementData.SRVCACTVTY10ID = 0;
			
		}
		else {
			[self.checkBoxValueDictionary setObject:@"TRUE" forKey:tempStr];
			[sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
			objServiceManagementData.NUMBER_EXT = mNumberExt; // tempStr;
			objServiceManagementData.SRVCACTVTY10ID = mActivityId;
		}*/
		
		segmentIndex = 0;
		[self.activityTable reloadData];
		
	}
	
}
-(IBAction)FaulteditButtonClicked: (id) sender {
	if (segmentIndex == 1) {
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		UIButton *but = [UIButton alloc];
		but= sender;
		objServiceManagementData.selectedRowIndex = [but.currentTitle intValue];
		objServiceManagementData.faultEditFlag = TRUE;
		FaultEditScr *objFaultEditScr = [[FaultEditScr alloc] initWithNibName:@"FaultEditScr" bundle:nil];
		[self.navigationController pushViewController:objFaultEditScr animated:YES];
		[objFaultEditScr release];
		objFaultEditScr = nil;
	}
}
-(IBAction)FaultDeleteButtonClicked: (id) sender{
	if (segmentIndex == 1) {
		UIButton *but = [UIButton alloc];
		but= sender;
		//Creating Sql string for updating a task..
		self.DeleteQuery = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE NUMBER_EXT = %d",
							  @"ZGSCSMST_SRVCCNFRMTNFAULT20",but.tag];
		
		//Alert while try to delete...
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_title",@"") 
										   message:NSLocalizedString(@"Service_Cnf_Delete_alert_msg",@"")
										  delegate:self 
								 cancelButtonTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_Cancel_title",@"")											
								 otherButtonTitles:NSLocalizedString(@"Service_Cnf_Delete_alert_Other_title",@""),
				 nil];
		alert.tag = 3; //Set the tag to tack, which alert is clicked..
		[alert show];
		
	}
}
-(IBAction)SparesEditButtonClicked: (id) sender {
	if (segmentIndex == 2) {
		ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
		UIButton *but = [UIButton alloc];
		but= sender;
		objServiceManagementData.selectedRowIndex = [but.currentTitle intValue];
		
		SparesEdit *objSparesEdit = [[SparesEdit alloc] initWithNibName:@"SparesEdit" bundle:nil];
		[self.navigationController pushViewController:objSparesEdit animated:YES];
		[objSparesEdit release];
		objSparesEdit = nil;
        
     
       
        
	}
}
-(IBAction)SparesDeleteButtonClicked: (id) sender{
	if (segmentIndex == 2) {
		
		//Build spares delete query
		
		UIButton *but = [UIButton alloc];
		but= sender;
		//Creating Sql string for updating a task..
		self.DeleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE ZGSCSMST_SRVCSPARE10Id = %d",
							  [but.currentTitle intValue]];

		//Alert while try to delete...
		alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_title",@"") 
										   message:NSLocalizedString(@"Service_Cnf_Delete_alert_msg",@"")
										  delegate:self 
								 cancelButtonTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_Cancel_title",@"")											
								 otherButtonTitles:NSLocalizedString(@"Service_Cnf_Delete_alert_Other_title",@""),
				 nil];
		alert.tag = 2; //Set the tag to tack, which alert is clicked..
		[alert show];

	}		

}
-(void) newButtonClicked:(NSInteger) option{	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    int totalRecord;
	//NSString *recordid;
    mSRCDOC_NUMBER_EXT = [[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"NUMBER_EXT"] intValue];
    mNUMBER_EXT = mNUMBER_EXT + 10;
	
	NSString *tempValueStr; 
    if (option == 2) {
    tempValueStr= [NSString stringWithFormat:@"'%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
							  [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
                              @"",
                              mNUMBER_EXT,
							  @"",
                              @"",
							  [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"PROCESS_QTY_UNIT"],
							  @"",
                              @"",
							  [objCurrentDateTime currentdate],
                              [objCurrentDateTime currentdate],
							  [objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]],
							  [objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]],
							  [objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]],
							  [objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]],
                              [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"TIMEZONE_FROM"]
                              ];
    } else if (option == 1) 
    {
    tempValueStr= [NSString stringWithFormat:@"'%@',%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
                   mSRCDOC_NUMBER_EXT,
                   mNUMBER_EXT,
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"PRODUCT_ID"],
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"QUANTITY"],
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"PROCESS_QTY_UNIT"],
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"ZZITEM_DESCRIPTION"],
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"ZZITEM_TEXT"],
                   [objCurrentDateTime currentdate],
                   [objCurrentDateTime currentdate],
                   [objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]],
                   [objCurrentDateTime getDateFromString: [objCurrentDateTime currentdate]],
                   [objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]],
                   [objCurrentDateTime getTimeFromString: [objCurrentDateTime currentdate]],
                   [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"TIMEZONE_FROM"]
                   ];
    
    }

	//Build SQlQuery
	NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  ZGSCSMST_SRVCACTVTY10_TEMP (%@) VALUES (%@)",
						  @"OBJECT_ID,SRCDOC_NUMBER_EXT,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,DATETIME_FROM,DATETIME_TO,DATE_FROM,DATE_TO,TIME_FROM,TIME_TO,TIMEZONE_FROM",
						  tempValueStr];
	
	//Run SQLQuery
    [objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
    
        //Fetch activity data from activity temp to activity temp array
	[objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
    //[objServiceManagementData fetchServiceOrderActivityTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"]:-1];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"];
    objServiceManagementData.serviceOrderActivityTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SOACTIVITYTEMP" :2]; 
    
    
    
	segmentIndex = 0;
    
    //Activity Array Count
    totalRecord = [objServiceManagementData.serviceOrderActivityTempArray count];
    objServiceManagementData.selectedRowIndex = totalRecord-1;
    NSLog(@"act temp %@",objServiceManagementData.serviceOrderActivityTempArray);
    
    if (option == 2) {
        //Move to Activity Edit Screen
        ServiceConfActivity *objServiceConfActivity = [[ServiceConfActivity alloc] initWithNibName:@"ServiceConfActivity" bundle:nil];
        [self.navigationController pushViewController:objServiceConfActivity animated:YES];
        [objServiceConfActivity release];
        objServiceConfActivity = nil;

    }
  	
}
-(void) newMaterialButtonClicked: (NSInteger) option{
	
    NSString *sqlQuery;
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
        int totalRecord;
    
	if (option ==2){
        spareNUMBER_EXT = spareNUMBER_EXT + 10;

        //While add new spare
        NSString *tempValueStr = [NSString stringWithFormat:@"'%@','%d','%@','%@','%@','%@','%@','%@'",
							  [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
                              spareNUMBER_EXT,@"",@"",@"",@"",@"",@""];
	
        sqlQuery = [NSString stringWithFormat:@"INSERT INTO  ZGSCSMST_SRVCSPARE10_TEMP (%@) VALUES (%@)",
						  @"OBJECT_ID,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,SERIAL_NUMBER",tempValueStr];

    }
    else if (option == 1) {
    //Initital call
        sqlQuery = [NSString stringWithFormat:@"INSERT INTO  ZGSCSMST_SRVCSPARE10_TEMP SELECT ZGSCSMST_SRVCSPARE10id, OBJECT_ID,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,SERIAL_NUMBER FROM ZGSXSMST_SRVCSPARE10 WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]];
    }
	NSLog(@"sql query %@",sqlQuery);
    
	[objServiceManagementData insertDataIntoServiceManagemenetDB:sqlQuery:objServiceManagementData.serviceReportsDB];
	[objServiceManagementData.serviceOrderSpareTempArray removeAllObjects];	
	[objServiceManagementData fetchServiceOrderSpareTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]]:-1];
    
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE OBJECT_ID = %@",[[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"]];
    objServiceManagementData.serviceOrderSpareTempArray = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SO ACTIVITY TEMP" :1]; 
    
 
    if (option == 1)
    {
        if ([objServiceManagementData.serviceOrderSpareArray count] > 0)
            spareNUMBER_EXT = [[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"NUMBER_EXT"] intValue];
     
    }   
 	
    if (option == 2){
        
        segmentIndex = 2;
        //Spares Array Count
        totalRecord = [objServiceManagementData.serviceOrderSpareTempArray count];
        //set flag for new spares created
        objServiceManagementData.spareAddFlag = TRUE;
        objServiceManagementData.selectedRowIndex = totalRecord-1;
    
    
        SparesEdit *objSparesEdit = [[SparesEdit alloc] initWithNibName:@"SparesEdit" bundle:nil];
        [self.navigationController pushViewController:objSparesEdit animated:YES];
        [objSparesEdit release];
        objSparesEdit = nil;
	}
}
-(IBAction)attachBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    ImagePreview *objImagePreview = [[ImagePreview alloc] init];
    [self presentModalViewController:objImagePreview animated:YES];
    
}
-(IBAction)attachSignBtnClicked:(id)sender{
    //Load Image Preview screen when attachment image button clicked.
    SignaturePreview *objSignaturePreview = [[SignaturePreview alloc] init];
    [self presentModalViewController:objSignaturePreview animated:YES];
}
-(void) submitButtonClicked: (id)sender{
	
	//Alert while try to delete...
	alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Service_Cnf_Delete_alert_title",@"") 
									   message:NSLocalizedString(@"Are you fully done? Once saved can't be edited further",@"")
									  delegate:self 
							 cancelButtonTitle:NSLocalizedString(@"Cancel",@"")											
							 otherButtonTitles:NSLocalizedString(@"Yes",@""),
			 nil];
	alert.tag = 10; //Set the tag to tack, which alert is clicked..
	[alert show];
	
	
}
//**********************************************************************************************************************
//Button Event - End
//**********************************************************************************************************************


#pragma mark -
#pragma mark custom methods
//**********************************************************************************************************************
//Custom Method Start
//**********************************************************************************************************************
//caling function to update in SAP as well as sqlite 
-(void)CallSAPUpdate{
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
    
	NSMutableArray *sapRequestArray = [[NSMutableArray alloc] init];
	
	//***************Fetch All Activity data
	//[objServiceManagementData.serviceOrderSelectedActivityArray removeAllObjects];	
	//[objServiceManagementData fetchAndUpdateServiceOrderActivity:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@ AND OBJECT_ID = %@",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:0],objServiceManagementData.ACTIVITY_NUMBER_EXT,objServiceManagementData.objectiveID]:-1];
    [objServiceManagementData.serviceOrderActivityTempArray removeAllObjects];	
    [objServiceManagementData fetchServiceOrderActivityTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCACTVTY10_TEMP WHERE 1"]:-1];

	
	//***************Fetch All Fault data
	[objServiceManagementData.faultAllDataArray removeAllObjects];
	[objServiceManagementData fetchAndUpdateConfirmationFaultData:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCCNFRMTNFAULT20 WHERE 1"]:-1];
    
    
    //***************Fetch All Spare data
	//[objServiceManagementData.serviceOrderSpareArray removeAllObjects];	
	//[objServiceManagementData fetchAndUpdateServiceOrderSpare:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",[objServiceManagementData.serviceOrderConfirmationListingDataTypeArray objectAtIndex:1],objServiceManagementData.objectiveID]:-1];
    [objServiceManagementData.serviceOrderSpareTempArray removeAllObjects];	
	[objServiceManagementData fetchServiceOrderSpareTemp:[NSString stringWithFormat:@"SELECT * FROM ZGSCSMST_SRVCSPARE10_TEMP WHERE 1"]:-1];
    
	
	self.updateResponseMsgArray = [[NSMutableArray alloc] init];
	self.updateSucessFlag = TRUE;
	
	if([CheckedNetwork connectedToNetwork]) //Checking for net connection...
	{
		customAlt = [[CustomAlertView alloc] init];
		[self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):90.0 :160.0 :140.0 :125.0]];
		
		objStaticData = [StaticData sharedStaticData];
		//Creating Confirmation the parameter of SOAP call to pass SAP...
		NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTN20[.]%@[.]%@[.]",
							 [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"],
							 [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"PROCESS_TYPE"]];
		
		[sapRequestArray addObject:strPar5];
		
		//NSString *mSRCDOC_NUMBER_EXT = [NSString stringWithFormat:@"%@",@"10"];
		//NSString *mNumberExt = [NSString stringWithFormat:@"%@",@""];
		for (int arrIndex=0; arrIndex < [objServiceManagementData.serviceOrderActivityTempArray count]; arrIndex++) {
		
			//NSString *strNumberExt = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"NUMBER_EXT"];
			//NSString *strSrcDocNumberExt = [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"SRCDOC_NUMBER_EXT"];
			
			//if ([mNumberExt isEqualToString:strNumberExt]) 
			//	strNumberExt = strSrcDocNumberExt;
			
			//Creating Activity the parameter of SOAP call to pass SAP...
			NSString *strActivityData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNACTVTY20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"SRCDOC_NUMBER_EXT"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"NUMBER_EXT"],		 
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"PRODUCT_ID"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"QUANTITY"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"PROCESS_QTY_UNIT"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"ZZITEM_DESCRIPTION"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"ZZITEM_TEXT"],
                                 [objCurrentDateTime convertMMMDDformattoyyyMMdd:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"DATE_FROM"]],
                                 [objCurrentDateTime convertMMMDDformattoyyyMMdd:[[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"DATE_TO"]],
  								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"TIME_FROM"],
								 [[objServiceManagementData.serviceOrderActivityTempArray objectAtIndex:arrIndex] objectForKey:@"TIME_TO"],
								 @"-18000000"
								 ];			
			
			[sapRequestArray addObject:strActivityData];
			[strActivityData release],strActivityData = nil;
			//mSRCDOC_NUMBER_EXT = @"";
			//mNumberExt = strNumberExt;
		}

		if ([objServiceManagementData.faultAllDataArray count] !=0 ) {
			for (int arrIndex=0; arrIndex< [objServiceManagementData.faultAllDataArray count]; arrIndex++) {
				//Creating Fault the parameter of SOAP call to pass SAP...		
				
				NSString *strFaultData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNFAULT20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"NUMBER_EXT"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZSYMPTMCODEGROUP"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZSYMPTMCODE"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZSYMPTMTEXT"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZPRBLMCODEGROUP"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZPRBLMCODE"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZPRBLMTEXT"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZCAUSECODEGROUP"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZCAUSECODE"],
										  [[objServiceManagementData.faultAllDataArray objectAtIndex:0] objectForKey:@"ZZCAUSETEXT"]
										  ];
				
				[sapRequestArray addObject:strFaultData];
				[strFaultData release],strFaultData = nil;
				
				
			}
		}
		
		for (int arrIndex=0; arrIndex < [objServiceManagementData.serviceOrderSpareArray count]; arrIndex++) {
            
            int msrcdoc_number_ext = 1000 + [[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"ZGSCSMST_SRVCSPARE10Id"] intValue];

		//Creating Spares the parameter of SOAP call to pass SAP...
		
		NSString *strSparesData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNMTRL20[.]%@[.]%d[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"NUMBER_EXT"],
                             msrcdoc_number_ext,
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"PRODUCT_ID"],
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"QUANTITY"],
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"PROCESS_QTY_UNIT"],
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"ZZITEM_DESCRIPTION"],
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"ZZITEM_TEXT"],
							 [[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"SERIAL_NUMBER"]
							 ];
			[sapRequestArray addObject:strSparesData];
			[strSparesData release],strSparesData = nil;
            
            NSLog(@"spares %@",strSparesData);

		}
        
        
        AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];


        //Attach image as a document
        if (self.localSmallFilepathStr != nil) {
       
            NSString *SrcdocObjIdStr = [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"];

            NSString *strDocumentData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",SrcdocObjIdStr,self.localSmallFilepathStr,delegate.encryptedImageString ];
            [sapRequestArray addObject:strDocumentData];
             [strDocumentData release],strDocumentData = nil;
           
        }
        
        //Attach signature image as a document

        if (delegate.localSignFilePath !=nil) {
            
            NSString *SrcSignObjIdStr = [[objServiceManagementData.serviceOrderSelectedActivityArray objectAtIndex:0] objectForKey:@"OBJECT_ID"];
            
            NSString *strSignData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",SrcSignObjIdStr,delegate.localSignFilePath,delegate.encryptedSignString ];
            [sapRequestArray addObject:strSignData];
            [strSignData release],strSignData = nil;

        }
        
        
  	
		if([self updatetaskInSAPServer:sapRequestArray])
		{			
			//Removing custome alert view...
			[customAlt removeAlertForView];
			[customAlt release];
			
			NSString *alertMsg = @"";
			
			for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
			{
				alertMsg =[self.updateResponseMsgArray objectAtIndex:i];
				
			}
						
			/*//Display the alert which is got from SAP response...			
			UIAlertView *responseSuccess = [[UIAlertView alloc] 
											initWithTitle:@"Service Confirmation"
											message:@""  
											delegate:self 
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
			[responseSuccess show];
			responseSuccess.tag = 5;
			[responseSuccess release];*/
            
            
            //Display the alert which is got from SAP response...		
            alert = [[UIAlertView alloc] initWithTitle:@"Service Confirmation"
                                               message:@""
                                              delegate:self 
                                     cancelButtonTitle:@"OK" 											
                                    otherButtonTitles:nil];
                     alert.tag = 20; //Set the tag to tack, which alert is clicked..
                     [alert show];

            ServiceOrders *objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
            [self.navigationController pushViewController:objServiceOrders animated:YES];
            [objServiceOrders release];

            delegate.localImageFilePath = @"";	
            delegate.signatureCaptured = FALSE;

				
			
		}
		else {
			
			//Removing custome alert view...
			[customAlt removeAlertForView];
			[customAlt release];
			
			NSString *alertMsg = @"";
			
			for(int i=0 ;i<[self.updateResponseMsgArray count] ;i++)
			{
				
				alertMsg =[self.updateResponseMsgArray objectAtIndex:i];

			}
			
				
            
            //Alert while try to delete...
            alert = [[UIAlertView alloc] initWithTitle:@"Service Confirmation"
                                               message:alertMsg
                                              delegate:self 
                                     cancelButtonTitle:@"OK" 											
                                     otherButtonTitles:nil];
            alert.tag = 30; //Set the tag to tack, which alert is clicked..
            [alert show];


			
			ServiceOrders *objServiceOrders = [[ServiceOrders alloc] initWithNibName:@"ServiceOrders" bundle:nil];
			[self.navigationController pushViewController:objServiceOrders animated:YES];
			[objServiceOrders release];

            delegate.localImageFilePath = @"";
            delegate.signatureCaptured = FALSE;
		}	
	}
	else {
		self.view.userInteractionEnabled = TRUE;
		self.navigationItem.leftBarButtonItem.enabled = TRUE;
		
		//NET conenction checking laert...
		UIAlertView *netCoennectionCheckingAlert = [[UIAlertView alloc] 
													initWithTitle:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_title",@"")
													message:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_msg",@"")
													delegate:self
													cancelButtonTitle:NSLocalizedString(@"Edit_Task_NetworkConnection_alert_Cancel_title",@"") 
													otherButtonTitles:nil];
		[netCoennectionCheckingAlert show];
		netCoennectionCheckingAlert.tag = 3;
		[netCoennectionCheckingAlert release];		
	}
	
	
	
}
//-(BOOL)updatetaskInSAPServer:(NSString *)strPar5:(NSString *)strPar6:(NSString *)strPar7:(NSString *)strPar8
-(BOOL)updatetaskInSAPServer:(NSMutableArray *)sapRequestArray{
	
	//Calling SOAP to update in SAP......
	
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];	
	Z_GSSMWFM_HNDL_EVNTRQST00Binding *binding1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service Z_GSSMWFM_HNDL_EVNTRQST00Binding] initWithAddress:delegate.service_url];	
	binding1.logXMLInOut = YES;  	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par1.Cdata = @"DEVICE-ID:000000000000000:DEVICE-TYPE:IOS:APPLICATION-ID:SERVICEPRO";	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par2 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par2.Cdata = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par3 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par3.Cdata = @"EVENT[.]SERVICE-CONF-CREATE[.]VERSION[.]0";	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par4 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par4.Cdata = @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTN20[.]SRCDOC_OBJECT_ID[.]SRCDOC_PROCESS_TYPE[.]ZZSRVCORDRCMPLT";	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par5 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par5.Cdata = @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNACTVTY20[.]SRCDOC_NUMBER_EXT[.]NUMBER_EXT[.]PRODUCT_ID[.]QUANTITY[.]PROCESS_QTY_UNIT[.]ZZITEM_DESCRIPTION[.]ZZITEM_TEXT[.]DATE_FROM[.]DATE_TO[.]TIME_FROM[.]TIME_TO[.]TIMEZONE_FROM";	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par6 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par6.Cdata = @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNFAULT20[.]NUMBER_EXT[.]ZZSYMPTMCODEGROUP[.]ZZSYMPTMCODE[.]ZZSYMPTMTEXT[.]ZZPRBLMCODEGROUP[.]ZZPRBLMCODE[.]ZZPRBLMTEXT[.]ZZCAUSECODEGROUP[.]ZZCAUSECODE[.]ZZCAUSETEXT";	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *par7 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
	par7.Cdata = @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNMTRL20[.]SRCDOC_NUMBER_EXT[.]NUMBER_EXT[.]PRODUCT_ID[.]QUANTITY[.]PROCESS_QTY_UNIT[.]ZZITEM_DESCRIPTION[.]ZZITEM_TEXT[.]SERIAL_NUMBER";	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 *objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01 alloc] init];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par1];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par2];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par3];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par4];
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par5];
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par6];	
	[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:par7];
	for (int rowIndex=0; rowIndex < [sapRequestArray count]; rowIndex++) {
		Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 *mPara = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbssDatarcrd01 alloc] init];	
        mPara.Cdata = [sapRequestArray objectAtIndex:rowIndex];
		NSLog(@"sap request array %@",[sapRequestArray objectAtIndex:rowIndex]);
		[objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update.item addObject:mPara];
	}
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 *request1 = [[Z_GSSMWFM_HNDL_EVNTRQST00Service_ZGssmwfmHndlEvntrqst00 alloc] init];
	request1.DpistInpt = objZ_GSSMWFM_HNDL_EVNTRQST00Service_ZgssmbstDatarcrd01_update;	
	
	
	Z_GSSMWFM_HNDL_EVNTRQST00BindingResponse *resp1 = [binding1 ZGssmwfmHndlEvntrqst00UsingParameters:request1];
	
	
	CXMLDocument *doc1 = [[CXMLDocument alloc] initWithData:resp1.getResponseData options:0 error:nil];
	
	
	//Release variable
	[par1 release];
	[par2 release];
	[par3 release];
	[par4 release];
	[par5 release];
	[par6 release];
	[par7 release];
	
	
	//Parsing the response...
	NSArray *nodes = NULL;
	nodes = [doc1 nodesForXPath:@"//DpostOtpt" error:nil];
	
	for(CXMLDocument *node in nodes)
	{		
		for(CXMLNode *childNode in [node children])
		{	
			
			if(![[childNode name] isEqualToString:@"item"])
			{
				break;
			}
			
			if([[childNode name] isEqualToString:@"item"])
			{						
				for(CXMLNode *childNode2 in [childNode children])
				{
					
					if([childNode2 stringValue]!=nil)
					{
						if([[childNode2 stringValue] rangeOfString:@"EVENT-RESPONSE"].location != NSNotFound)
						{
							[self.updateResponseMsgArray addObject:[childNode2 stringValue]];
							self.updateSucessFlag = TRUE; 
						}
						
					}						
				}
			}
		}
	}
	
	
	//Parsing response... while any error occur.. at that time 'DpostOtpt' will be nill and value will be in 'DpostMssg' tag..
	NSArray *nodes2 = NULL;
	nodes2 = [doc1 nodesForXPath:@"//DpostMssg" error:nil];
	
	for(CXMLDocument *node in nodes2)
	{		
		for(CXMLNode *childNode in [node children])
		{				
			if([[childNode name] isEqualToString:@"item"])
			{						
				for(CXMLNode *childNode2 in [childNode children])
				{
					
					if([[childNode2 name] isEqualToString:@"Message"] && [childNode2 stringValue]!=nil )
					{
						[self.updateResponseMsgArray addObject:[childNode2 stringValue]];						
						self.updateSucessFlag = FALSE;
					}											
				}
			}
		}
	}
	
	
	[doc1 release];
	return self.updateSucessFlag;
}
//**********************************************************************************************************************
//Custom Method End
//**********************************************************************************************************************
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}



-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewDidUnload {
	
	[self.activityTable release];
	[displayActivity release];
	[displayServiceOrder release];
    [self.attachButton release];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc {
	
	[self.updateResponseMsgArray release], updateResponseMsgArray = nil;
    [super dealloc];
}


@end