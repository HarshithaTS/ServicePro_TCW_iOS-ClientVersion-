//
//  ViewController.m
//  ServicePro
//
//  Created by gss on 2/9/13.
//
//

#import "MapViewController.h"
#import "ServiceManagementData.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize coords = _coords;
@synthesize currentLocation = _currentLocation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (NSString *)finalUrlString
{
    
    
    //for ADDRESS in d WEBVIEW
    ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
    
    NSArray *addressList = [[NSArray alloc]initWithObjects:
                            [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"],
                            [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                            [objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"],
                            [objServiceManagementData.taskDataDictionary objectForKey:@"LAND1"], nil];
    NSLog(@"ADDeRSS STRING:%@", addressList);
    
    NSString *temp = [addressList componentsJoinedByString:@","];
    NSString *finalString = [temp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"final String %@",finalString);
    return finalString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentLocation = locationManager.location.coordinate;
    
    [self finalUrlString];

    [self showGoogleWebMap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showRouteDetails:) name:@"showRoute" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)showGoogleWebMap {
    
    NSString *sourceloc = [NSString stringWithFormat:@"%f,%f",_currentLocation.latitude, _currentLocation.longitude];
    
    NSString *destinationloc = [self finalUrlString];
    
    //Sample URL
    // http://maps.google.com/?saddr=22.718019,75.884460&daddr=33.391823,-111.961731&zoom=10&output=embed

    NSString *fullUrl = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%@&daddr=%@&output=embed", sourceloc,destinationloc];
    
    NSLog(@"Full URL %@", fullUrl);
    
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    NSLog(@"request: %@", requestObj);
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	webView.delegate= self;
    
    
    //iframe code start
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,webView.frame.size.width,webView.frame.size.height, url];
    
    [webView loadHTMLString:embedHTML baseURL:url];
    
    
  
    //iframe code end
    
    
    
    
   // [webView loadRequest:requestObj];
    [self setView:webView];
    
    [webView release];
}

- (void)showRouteDetails:(id)sender {
   
    
    
    //Google Map API Integration Help
    //https://developers.google.com/maps/documentation/ios/start#getting_the_google_maps_sdk_for_ios
    
    
    NSString *fullUrl = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%@",[self finalUrlString]];
    
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSLog(@"request: %@", requestObj);

    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	webView.delegate= self;
    
  
    [webView loadRequest:requestObj];
    [self setView:webView];
    [webView release];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	printf("\n started");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	printf("\n stopped");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
