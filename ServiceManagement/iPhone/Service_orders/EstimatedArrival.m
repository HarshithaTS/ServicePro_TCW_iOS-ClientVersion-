//
//  EstimatedArrival.m
//  ServiceManagement
//
//  Created by Vivek Kumar G on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EstimatedArrival.h"

@implementation EstimatedArrival

@synthesize delegate;
@synthesize BDateT;
@synthesize CDate;
@synthesize MSG_view1;
@synthesize MSG_view2;
@synthesize MSG_DATE;

@synthesize butDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)ClickDateTime:(id)sender
{
    self.butDone.enabled = TRUE;
    [self.delegate EstimatedArrival_DataExchange:@"DateT"];
    
}
-(IBAction)ClickDone:(id)sender
{
    
    [self.delegate EstimatedArrival_DataExchange:@"Done"]; 
    
}
-(IBAction)ClickCancel:(id)sender
{
    
   [self.delegate EstimatedArrival_DataExchange:@"Cancel"]; 
    
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
    
   // NSArray *splitA = [CDate componentsSeparatedByString:@" "];
   // [BDateT setTitle:[NSString stringWithFormat:@" %@ %@ %@",[splitA objectAtIndex:0],[splitA objectAtIndex:1],[splitA objectAtIndex:2]] forState:UIControlStateNormal];
    
    self.MSG_view1.layer.cornerRadius = 4.0;
    self.MSG_view2.layer.cornerRadius = 10.0;
    
    self.MSG_DATE.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    self.MSG_DATE.layer.borderWidth = 2.0f;
    self.MSG_DATE.layer.cornerRadius = 5.0;
    
    self.butDone.enabled=FALSE;
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // __IPHONE_7_0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    #endif
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
