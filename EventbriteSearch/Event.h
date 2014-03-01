//
//  Event.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/27/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VenueDetails;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) VenueDetails *venue;

@end
