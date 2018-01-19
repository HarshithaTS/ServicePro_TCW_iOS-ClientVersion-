//
//  ServiceTaskEdit.m
//  ServicePro
//
//  Created by GSS Mysore on 07/02/13.
//
//

#import "ServiceTaskEdit.h"
#import "iOSMacros.h"
@interface ServiceTaskEdit ()

@end

@implementation ServiceTaskEdit

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
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
