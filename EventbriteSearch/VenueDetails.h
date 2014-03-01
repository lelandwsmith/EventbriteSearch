//
//  VenueDetails.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/27/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface VenueDetails : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) Event *event;

@end
