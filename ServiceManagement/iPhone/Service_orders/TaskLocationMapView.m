//
//  TaskLocationMapView.m
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*--This class for map view... locating the task address in google map..*/

#import "TaskLocationMapView.h"
#import "CSMapAnnotation.h"
#import "ServiceManagementData.h"

#import "ShowDetailTaskLocation.h"
#import "ServiceOrderEdit.h"


@implementation TaskLocationMapView


@synthesize _mapView;
//@synthesize mapSelectSegmentControl;

@synthesize taskLat;
@synthesize taskLon;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self._mapView.delegate = self;
	
    //Added bar button to get the alert while back from this page..
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Servic_Orders_back",@"") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // __IPHONE_7_0
    barButton.tintColor = [UIColor whiteColor];
#endif
	self.navigationItem.leftBarButtonItem = barButton;
	[barButton release], barButton = nil;
    
    
	
	/*------------------Below code commented: I have taken one segment control to show the current location and map location...
	 as I have told in appDelegete page I have traking current location of Device...
	 And showing the current location in one segmnet and in enother one task location...
	 If you need this features then open the code..and alll segment control related code.. modify the code for proper calling the function..
	 ..------------------------------*/
	
	
	//NSArray *segmentControlValues = [NSArray arrayWithObjects:@"Task Location", @"Current Locaton", nil];
	//appDelegate = (Fortis_ClaimAppDelegate*)[[UIApplication sharedApplication] delegate];
	//motorClaimQuote = appDelegate.appMotorClaimQuote;
	
	//mapSelectSegmentControl = [[UISegmentedControl alloc] initWithItems:segmentControlValues];
	//mapSelectSegmentControl.frame = CGRectMake(30.0, 380.0, 260.0, 30.0);
	//mapSelectSegmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	//mapSelectSegmentControl.momentary = YES;
	//mapSelectSegmentControl.tintColor = [UIColor colorWithHue:0.1 saturation:0.0 brightness:0.5 alpha:0.85998];
	//[mapSelectSegmentControl addTarget:self action:@selector(segmentControlAction) forControlEvents:UIControlEventValueChanged];
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
    //	if([[objServiceManagementData.taskDataDictionary objectForKey:@"PSTLZ"]length] != 0){
    
    //		NSString *mTownNameLikeURL = [objServiceManagementData.taskDataDictionary  objectForKey:@"PSTLZ"];
    NSArray *dest = [[NSArray alloc]initWithObjects:
                     [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"],
                     [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"],
                     [objServiceManagementData.taskDataDictionary  objectForKey:@"PSTLZ"], nil];
    NSString *temp = [dest componentsJoinedByString:@" "];
    //		mTownNameLikeURL = [mTownNameLikeURL stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *finalString = [temp stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"Temp value: %@", finalString);
    double latitude = 0, longitude = 0;
    NSString *esc_addr = [finalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
        {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    self.taskLat = latitude;
    self.taskLon = longitude;
    //        CLLocationCoordinate2D center;
    //        center.latitude = latitude; center.longitude = longitude;
    
    //---------------------------------------------------------
    //GOOGLE STOPPED CSV based LAT/LONG Extraction
    //---------------------------------------------------------
    //Colleting the latitude and longitude from the specified postcode using Google API...
    //		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
    //							   [mTownNameLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //		NSLog(@"url:%@", urlString);
    //		NSError *error;
    //		NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    //		NSArray *listItems = [locationString componentsSeparatedByString:@","];
    //
    //		NSLog(@"Location Array=%@",listItems);
    //
    //		//Assigning lat and lon to calss variable..
    //		if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
    //			self.taskLat = [[listItems objectAtIndex:2] doubleValue];
    //			self.taskLon = [[listItems objectAtIndex:3] doubleValue];
    //		}
    //		else {
    //			//Show error
    //            if ([[listItems objectAtIndex:0] isEqualToString:@"602"]) {
    //                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Address is not valid. Unable to load Map." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    //                [av show];
    //                [av release];
    //            }
    //
    //		}
    
    //CLLocationCoordinate2D endLocation;
    //endLocation.latitude = latitude;
    //endLocation.longitude = longitude;
    
    //region.span = span;
    //region.center = endLocation;
    //[_mapView setRegion:region animated:YES];
    
    NSLog(@"lat: %f, lon: %f", self.taskLat, self.taskLon);
    
    //	}
	
	//[mapSelectSegmentControl setImage:[UIImage imageNamed:@"taskIcon.png"] forSegmentAtIndex:0];
	[self mapViewAnnotationSet:0];
	
    [super viewDidLoad];
}

//send back to previous screen without storing screen data in to faultdataarray
-(void) goBack{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
	
    /*ServiceOrderEdit *objServiceOrderEdit = [[ServiceOrderEdit alloc] initWithNibName:@"ServiceOrderEdit" bundle:nil];
     [self.navigationController pushViewController:objServiceOrderEdit animated:YES];
     [objServiceOrderEdit release];
     objServiceOrderEdit = nil;*/
}

-(void) mapViewAnnotationSet:(int) segmentValue {
	
	//_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[_mapView setDelegate:self];
	CSMapAnnotation* annotation = nil;
	
	//latitudeDelta and longitudeDelta variable value control the zooming of map...
	MKCoordinateRegion region;
	region.span.latitudeDelta = 0.025;
	region.span.longitudeDelta = 0.025;
	
    
	
	CLLocationCoordinate2D cordinate;
	//NSString *locationTitle= @"";
	
	ServiceManagementData *objServiceManagementData = [ServiceManagementData sharedManager];
	
	if(segmentValue == 0)
	{
		cordinate.latitude = self.taskLat;
		cordinate.longitude = self.taskLon;
		
		//Title for header of the pin in mapview..
		NSString *locationTitle = [NSString stringWithFormat:@"%@, %@, %@",[objServiceManagementData.taskDataDictionary objectForKey:@"NAME_ORG1"],
                                   [objServiceManagementData.taskDataDictionary objectForKey:@"STRAS"],
                                   [objServiceManagementData.taskDataDictionary objectForKey:@"ORT01"]
                                   ];
		
		//Annoting the location into the Map..
		annotation = [[[CSMapAnnotation alloc] initWithCoordinate: cordinate
												   annotationType: CSMapAnnotationTypeStart
															title:locationTitle] autorelease];
		
	}
	/*
     else
     {
     http://wikimapia.org/#lat=12.3229802&lon=76.581831&z=15&l=0&m=b
     cordinate.latitude = 12.3229802;
     cordinate.longitude = 76.581831;
     
     
     //cordinate.latitude = self.taskLat;
     //cordinate.longitude = self.taskLon;
     
     locationTitle = @"Current Location";
     
     annotation = [[[CSMapAnnotation alloc] initWithCoordinate: cordinate
     annotationType: CSMapAnnotationTypeStart
     title:locationTitle] autorelease];
     }
	 */
    
	region.center = cordinate;
	[_mapView setRegion:region animated:TRUE];
	
	
	[self._mapView addAnnotation:annotation];
	//[self._mapView addSubview:self.mapSelectSegmentControl];
	[self.view addSubview:self._mapView];
}


/*
 -(IBAction) segmentControlAction {
 switch (mapSelectSegmentControl.selectedSegmentIndex) {
 case 0:
 [self mapViewAnnotationSet:0];
 break;
 
 case 1:
 [self mapViewAnnotationSet:1];
 break;
 }
 
 }
 */



#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition.
	
	//_routeView.hidden = YES;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display.
	
	//_routeView.hidden = NO;
	//[_routeView setNeedsDisplay];
}


//Delegate function of Mapview..
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
	
	NSString *identifier = @"PinPoint";
	MKPinAnnotationView *pin = (MKPinAnnotationView*)[self._mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if(pin == nil)
		pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier]autorelease];
	
	[pin setPinColor:MKPinAnnotationColorPurple];
	
	UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[detailButton addTarget:self action:@selector(showDetailTaskLocation:) forControlEvents:UIControlEventTouchUpInside];
	pin.rightCalloutAccessoryView = detailButton;
	
	annotationView = pin;
    
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	
	return annotationView;
}

//if pin heder button is pressed go to the  ShowDetailTaskLocation page.. where display the address details ...
-(IBAction)showDetailTaskLocation:(id)sender
{
	ShowDetailTaskLocation *objShowDetailTaskLocation = [[ShowDetailTaskLocation alloc] initWithNibName:@"ShowDetailTaskLocation" bundle:nil];
	[self.navigationController pushViewController:objShowDetailTaskLocation animated:YES];
	[objShowDetailTaskLocation release], objShowDetailTaskLocation = nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"calloutAccessoryControlTapped");
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_mapView release], _mapView = nil;
	//[mapSelectSegmentControl release], mapSelectSegmentControl = nil;
    [super dealloc];
}


@end
