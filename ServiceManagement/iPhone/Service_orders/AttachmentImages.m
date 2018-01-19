

#import "AttachmentImages.h"
#import "ServiceManagementData.h"
#import "ImagePreview.h"
#import "AppDelegate_iPhone.h"
#import "CheckedNetwork.h"
#import "QSStrings.h"
#import "CustomAlertView.h"
#import "PDFViewer.h"
#import "iOSMacros.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7

#pragma mark -


@interface AttachmentImages ()


 
@end

@implementation AttachmentImages

@synthesize entries;
@synthesize imageDownloadsInProgress;


#pragma mark 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView.rowHeight = kCustomRowHeight;
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Service Attachments";
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        barButton.tintColor = [UIColor whiteColor];
	self.navigationItem.leftBarButtonItem = barButton;
    
    
	[barButton release], barButton = nil;
    
    
    
    
    [self getServerAttachment];
    NSLog(@"entry %@",self.entries);
}

//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
    
}
- (void)dealloc
{
    [entries release];
	[imageDownloadsInProgress release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = [entries count];
	
   
    
    
	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"LazyTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
     NSLog(@"entry %@",self.entries);
    
    //Change tableview background color
    tableView.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
         
		cell.textLabel.text = [[self.entries objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@", [[self.entries objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"],[[self.entries objectAtIndex:indexPath.row] objectForKey:@"NUMBER_EXT"]];
		cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        
        
        
//        // Only load cached images; defer new downloads until scrolling ends
//        if (!appRecord.appIcon)
//        {
//            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
//            {
//                [self startIconDownload:appRecord forIndexPath:indexPath];
//            }
//            // if a download is deferred or in progress, return a placeholder image
//            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
//        }
//        else
//        {
//           cell.imageView.image = appRecord.appIcon;
//        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    customAlt = [[CustomAlertView alloc] init];
    [self.view addSubview:[customAlt customAlertAppear:NSLocalizedString(@"Edit_Task_customAlert_msg",@""):(self.view.frame.size.width/2)-150 :(self.view.frame.size.height/2)-20 :140 :125.0]];

    
    [self loadImageFromSAP:indexPath];
    
    //If data is downloaded sucessfully from SAP, stop animating activity indicator..and go to the main menu page..
    [customAlt removeAlertForView];
    [customAlt release], customAlt = nil;
    

    //Load Image Preview screen when attachment image button clicked.
    //    ImagePreview *objImagePreview = [[ImagePreview alloc] init];
    //    [self presentModalViewController:objImagePreview animated:YES];
   
    if ([self searchTableView:indexPath]) {
       
        PDFViewer *showImage = [[[PDFViewer alloc]initWithNibName:@"PDFViewer_ipad" bundle:nil] autorelease];

        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:showImage];
        navController.modalInPopover=YES;
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modalViewDone)];
        showImage.navigationItem.rightBarButtonItem = doneBarButton;
        showImage.navigationItem.title = @"View Attachment";
        
        showImage.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        showImage.view.superview.frame = CGRectMake(30, 30, 800, 900);
        
        [doneBarButton release];
        
        [self.navigationController presentModalViewController:navController animated:YES];
        [navController release],navController =nil;
    }
    else
    {
    
        ImagePreview *showImage = [[[ImagePreview alloc]initWithNibName:@"ImagePreview" bundle:nil] autorelease];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:showImage];
        navController.modalInPopover=YES;
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modalViewDone)];
        showImage.navigationItem.rightBarButtonItem = doneBarButton;
        showImage.navigationItem.title = @"View Attachment";
        
        showImage.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        showImage.view.superview.frame = CGRectMake(70, 70, 600, 600);
        
        [doneBarButton release];
        
        [self.navigationController presentModalViewController:navController animated:YES];
        [navController release],navController =nil;
    }
}

#pragma mark -
#pragma mark Table cell image support

//calling when searching is TRUE..
- (BOOL) searchTableView:(NSIndexPath *)indexPath {
   
    BOOL strFoundFlag = NO;
	
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
    [searchArray addObjectsFromArray:self.entries];

		//If 'searchText' is found in 'TASK_SEARCH_STRING' then add object in dubArrayList...
		if([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"] rangeOfString:@".pdf" options:NSCaseInsensitiveSearch ].location != NSNotFound)
		{
			strFoundFlag = TRUE;
           
		}
        else if([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"] rangeOfString:@".tif" options:NSCaseInsensitiveSearch ].location != NSNotFound)
        {   
            strFoundFlag = TRUE;
        
        }
        else if([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"] rangeOfString:@".png" options:NSCaseInsensitiveSearch ].location != NSNotFound)
        {
            strFoundFlag = TRUE;
        
        }
        else if([[[searchArray objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"] rangeOfString:@".BMP" options:NSCaseInsensitiveSearch ].location != NSNotFound)
        {
            strFoundFlag = TRUE;
        
        }
        else
            strFoundFlag = NO;
	[searchArray release], searchArray = nil;
	return strFoundFlag;
}


-(void) loadImageFromSAP:(NSIndexPath *)indexPath{
    
    // Navigation logic may go here. Create and push another view controller.
	AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
       
    BOOL _updateStatus= NO;
    
         NSMutableArray *_inptArray = [[[NSMutableArray alloc] init] autorelease];
    //Creating datatype of service confirmation
    NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE ZGSXCAST_ATTCHMNTKEY01[.]OBJECT_ID[.]OBJECT_TYPE[.]NUMBER_EXT[.]ATTCHMNT_ID"];
    [_inptArray addObject:strPar4];
    
    NSString *strPar5 = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNTKEY01[.]%@[.]%@[.]%@[.]%@",[[self.entries objectAtIndex:indexPath.row] objectForKey:@"OBJECT_ID"],
        [[self.entries objectAtIndex:indexPath.row] objectForKey:@"OBJECT_TYPE"],
        [[self.entries objectAtIndex:indexPath.row] objectForKey:@"NUMBER_EXT"],
        [[self.entries objectAtIndex:indexPath.row] objectForKey:@"ATTCHMNT_ID"]];
    
    [_inptArray addObject:strPar5];
    
    //If Internet connection is there call do sap updates here
    if([CheckedNetwork connectedToNetwork]) // checking for internet connection in Device
    {
        //If create db flag = 1 then create new db/overwrite existing db..... It will erase all old data and insert new data
        NSString *responseValue =[CheckedNetwork getResponseFromSAP:_inptArray :@"DOCUMENT-ATTACHMENT-GET":@"":2:@"GETDATA"];
        
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
    //SHOW ATTACHED IMAGE
    NSData* imageData = [QSStrings decodeBase64WithString:[objServiceManagementData.serviceAttachment objectAtIndex:4]];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    NSLog(@"attachment %@",image);
    delegate.attachmentImage = image;
    
  
    //SHOW ATTACHED PDF
    //[imageData writeToFile:@"test.pdf" atomically:YES];
    delegate.pdfFileData = imageData;
    
    
   }
                            
                            
-(NSString *) filePath: (NSString *) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}
                            
                            
-(void) getServerAttachment {
    
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    NSLog(@"TASKDATADIC %@",objServiceManagementData.taskDataDictionary);
    
    //**************************************************************************
    //SERVER ATTACHMENT icon
    //**************************************************************************
    NSString *sqlQryStr = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_ATTCHMNT01 WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",[objServiceManagementData.taskDataDictionary objectForKey:@"OBJECT_ID"],[objServiceManagementData.taskDataDictionary objectForKey:@"ZZFIRSTSERVICEITEM"]];
    self.entries = [objServiceManagementData fetchDataFrmSqlite:sqlQryStr :objServiceManagementData.serviceReportsDB:@"SERVERATTACHMENT" :1];
    
    
    NSLog(@"entries %@",self.entries);
    //**************************************************************************
    
}
//METHOD FOR DISMISSING present modal MAP View
- (void)modalViewDone {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end