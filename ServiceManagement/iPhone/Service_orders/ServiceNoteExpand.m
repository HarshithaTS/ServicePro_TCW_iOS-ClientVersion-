//
//  ServiceNoteExpand.m
//  ServicePro
//
//  Created by GSS Mysore on 5/21/14.
//
//

#import "ServiceNoteExpand.h"

#import "ServiceManagementData.h"
#import "iOSMacros.h"
#import "Design.h"

@interface ServiceNoteExpand ()

@end

@implementation ServiceNoteExpand

@synthesize svServiceNote;
@synthesize myView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Adding the value of each key of a particular index of tasklistArry into dictionary...
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    
    self.title =  objServiceManagementData.serviceNoteViewTitle;
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
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    if ([SYSTEM_VERSION floatValue] >= 7.0) {
        [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
        barButton.tintColor = [UIColor whiteColor];
    }
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    
    
    
    
    
//    // CRETAE LABEL
//    //CGRect labelFrame = CGRectMake(10, 10, 740, 1950);
//    CGRect labelFrame = CGRectMake(0, 0, self.myView.frame.size.width, self.myView.frame.size.height);
//
//    UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
//    myLabel.textColor = [UIColor blueColor];
//    //[myLabel setBackgroundColor:[UIColor whiteColor ]];
//    //Set Service Note to global variable
//    NSString *labelText = objServiceManagementData.serviceNote;
//    //Set Service Note View Title
//    [myLabel setText:labelText];
//    // Tell the label to use an unlimited number of lines
//    [myLabel setNumberOfLines:0];
//    [myLabel sizeToFit];
//    [self.myView addSubview:myLabel];
    
    
    
    //Text View
    CGRect txtVeiwFrame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
    UITextView *tvServiceNote = [[UITextView alloc] initWithFrame:txtVeiwFrame];
    tvServiceNote.textColor = [UIColor blueColor];
    NSString *lblTxt = objServiceManagementData.serviceNote;
   // NSString *lblTxt = @"You can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsYou can spell check very long text areas without compromising any performance hitsenddndnfdfdnfdfnnfdfdfndnfdnfdnfdnfdnfdnfdnfndfndfndfdfdnfdnfdnfndfndfndfndfndfndnfdnfdnfdnfdnf";
    [tvServiceNote setText:lblTxt];
    tvServiceNote.editable = FALSE;

    [self.view addSubview:tvServiceNote];
    
    
    //ScrollView - IPAD View
    [self.svServiceNote setScrollEnabled:YES];
    [self.svServiceNote setShowsHorizontalScrollIndicator:YES];
    
    
}
//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
