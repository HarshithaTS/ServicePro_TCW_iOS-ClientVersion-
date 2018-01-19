//
//  SignatureCapture.m
//  ServiceManagement
//
//  Created by gss on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignatureCapture.h"
#import "AppDelegate_iPhone.h"
#import "QSStrings.h"

@implementation SignatureCapture

@synthesize butDone,viewControllerSignature;
@synthesize TaskOrderID;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Write your signature";
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame =  self.view.frame;
    [self.view addSubview:drawImage];
    self.view.backgroundColor = [UIColor lightGrayColor];
    mouseMoved = 0;


    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barRightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick)];
	self.navigationItem.rightBarButtonItem = barRightButton;
	[barRightButton release], barRightButton = nil;
    
    
   

}
//Send back service confirmation activity screen
-(void) goBack
{

    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    delegate.signatureCaptured = FALSE;

    
    [self.navigationController popViewControllerAnimated:YES];

	
}

-(void) doneClick {
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    if ([self saveImage]) {
        
        delegate.signatureCaptured = TRUE;

        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *durationError = [[UIAlertView alloc] 
                                      initWithTitle:@"Status" 
                                      message:@"Please try again, we are facing some problem while saving signature"  
                                      delegate:self 
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
		[durationError show];
		durationError.tag = 5;
		[durationError release];
        delegate.signatureCaptured = FALSE;
    }
    
}

- (NSString *) filePath: (NSString *) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
    
    
}
- (BOOL) saveImage{
    UIImage *image;
    @try {
        //--get the date from the ImageView---
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(drawImage.image)];
        
        image = [UIImage imageWithData:imageData];
        
        
        
        
        //self.localSmallFilepathStr = [self filePath:@"MyPicture.png"];
        //NSLog(@"file path %@",[self filePath:@"Mysign.png"]);
        
        
        // vivek 2 Aug   - Start  
        //Purpose - Now we saving the image according to Task ID 
        NSString *FilePath = [NSString stringWithFormat:@"%@.png",TaskOrderID];
        
        
        NSString * base64String = [[NSString alloc] init];
        base64String = [QSStrings encodeBase64WithData:imageData];
        
        AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
        delegate.localSignFilePath = [self filePath:FilePath];	
        delegate.encryptedSignString = base64String;
        
        
        //Now checking the image is their or not in folder , ServiceOrderEdit :- -(void)viewWillAppear
        //delegate.attachmentSign = [UIImage imageWithContentsOfFile:[self filePath:FileName]];
        
       
        
        
        [imageData writeToFile:[self filePath:FilePath] atomically:YES];
        
        
        // -vivek End 
        
      
        
        //---write the date to file--
        
        
        
        
        return TRUE;
        
    }
    @catch (NSException *exception) {
        return FALSE;
    }

   

    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
    
	lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];
	currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
