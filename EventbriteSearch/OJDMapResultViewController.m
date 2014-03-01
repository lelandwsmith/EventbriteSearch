//
//  OJDMapResultViewController.m
//  EventbriteSearch
//
//  Created by Oliver Dormody on 3/1/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import "OJDMapResultViewController.h"

@interface OJDMapResultViewController ()

@end

@implementation OJDMapResultViewController

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
    self.mapView.delegate = self;
	
	MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([self.venue.latitude doubleValue], [self.venue.longitude doubleValue]);;
    point.title = self.title;
    point.subtitle = self.venue.name;
	[self.mapView addAnnotation:point];
	
	self.mapView.centerCoordinate = point.coordinate;
	
	//set visible region
	MKCoordinateRegion mapRegion;
	mapRegion.center = point.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
	
    [self.mapView setRegion:mapRegion animated: YES];
	
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	
	//gets user location
	MKMapItem *myLocation = [MKMapItem mapItemForCurrentLocation];
	
	//turns venue location into a MKMapItem
	id <MKAnnotation> annotation = view.annotation;
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
	
	[self findDirectionsFrom:myLocation to:destination];
}

- (void)findDirectionsFrom:(MKMapItem *)source to:(MKMapItem *)destination
{
    //provide loading animation here
	
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.destination = destination;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //__block typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
		 
         //stop loading animation here
		 
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             //do something about the response, like draw it on map
             MKRoute *route = [response.routes firstObject];
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         }
     }];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
