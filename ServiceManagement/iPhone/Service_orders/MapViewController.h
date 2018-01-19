//
//  ViewController.h
//  ServicePro
//
//  Created by gss on 2/9/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <UIWebViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager*      locationManager;
}

@property CLLocationCoordinate2D coords;
@property CLLocationCoordinate2D currentLocation;

- (void)showRouteDetails:(id)sender;

@end
