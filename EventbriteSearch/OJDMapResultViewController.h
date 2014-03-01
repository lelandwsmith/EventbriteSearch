//
//  OJDMapResultViewController.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 3/1/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VenueDetails.h"

@interface OJDMapResultViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) VenueDetails *venue;
@property (nonatomic, strong) NSString *eventTitle;

@end
