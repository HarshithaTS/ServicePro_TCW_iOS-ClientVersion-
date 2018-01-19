//
//  SignaturePreview.m
//  ServiceManagement
//
//  Created by gss on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignaturePreview.h"
#import "AppDelegate_iPhone.h"


@implementation SignaturePreview



@synthesize buttonClose;
@synthesize imagePreview;
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



- (NSString *) filePath: (NSString *) fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    AppDelegate_iPhone *delegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
    
    //Vivek Start 
    
    //NSString *FileName = [NSString stringWithFormat:@"%@.png",TaskOrderID];
    self.imagePreview.image = delegate.attachmentSign;	
    
    
    //Vivek End 
    
     

}

//Send back service confirmation activity screen
-(IBAction)closeButtonClick:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
