//
//  TaskLocationMapView.h
//  ServiceManagement
//
//  Created by Kousik Kumar Ghosh on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*--This class for map view... locating the task address in google map..*/

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TaskLocationMapView : UIViewController <MKMapViewDelegate> {

	IBOutlet MKMapView *_mapView;
	//UISegmentedControl *mapSelectSegmentControl;
	
	//Latitude and longitude variable..
	double taskLat;
	double taskLon;
}

@property (nonatomic, retain) IBOutlet MKMapView *_mapView;
//@property (nonatomic, retain) UISegmentedControl *mapSelectSegmentControl;

@property (nonatomic,assign) double taskLat;
@property (nonatomic,assign) double taskLon;


-(void) mapViewAnnotationSet:(int) segmentValue;
//-(IBAction) segmentControlAction;
-(void) goBack;

@end
