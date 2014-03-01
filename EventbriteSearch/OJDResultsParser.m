//
//  OJDResultsParser.m
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/26/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import "OJDResultsParser.h"
#import "Event.h"
#import "VenueDetails.h"
#import "OJDAppDelegate.h"

@interface OJDResultsParser()

@property (nonatomic, strong) NSManagedObjectContext  *managedObjectContext;

@end

@implementation OJDResultsParser

+ (id)sharedResultsParser {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
	
    return _sharedObject;
}

-(id)init {
	self = [super init];
	if (self) {
		self.managedObjectContext = [OJDAppDelegate sharedAppDelegate].managedObjectContext;
	}
	return self;
}

- (NSArray *)removeDuplicates:(NSMutableArray *)data withContext:(NSManagedObjectContext *)context {
	
	NSArray *listOfIds = [data valueForKeyPath:@"event.id"];
	
	NSError *error = nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(eventId IN %@)", listOfIds]];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *dataCopy = [[NSMutableArray alloc] initWithArray:data];
	
	
	for (Event *event in fetchedObjects) {
	
		//if the event already exists in core data....
		if ([listOfIds containsObject:event.eventId]) {
			
			//find and delete the object with that eventId in the search results
			[data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if ([[obj valueForKeyPath:@"event.id"] isEqual: event.eventId]) {
					[dataCopy removeObject:obj];
				}
			}];
			
		}
	}

	return dataCopy;
}

- (void)parseJSONForData:(NSData *)data withKeyword:(NSString *)keyword
{

	NSError *error = nil;
	
	//parses the JSON into an array
	NSArray *responseArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] mutableCopy];
	
	//this code gets only the event data, discarding the summary information at the beginning
	NSMutableArray *events = [[responseArray valueForKeyPath:@"events"] mutableCopy];
	[events removeObjectAtIndex:0];
	
	//avoids putting the same events into the database multiple times
	NSArray *uniqueEvents = [self removeDuplicates:events withContext:self.managedObjectContext];
	
		
	[uniqueEvents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Event *event = [NSEntityDescription
										  insertNewObjectForEntityForName:@"Event"
										  inManagedObjectContext:self.managedObjectContext];
										 
		event.title = [obj valueForKeyPath:@"event.title"];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *date = [dateFormat dateFromString:[obj valueForKeyPath:@"event.start_date"]];
		
		NSDateFormatter *readableDateFormatter = [[NSDateFormatter alloc] init];
		[readableDateFormatter setDateFormat:@"hh:mm a MM/dd/yyyy "];
		NSString *dateString = [readableDateFormatter stringFromDate:date];
		
		event.startDate = dateString;
		event.eventId = [obj valueForKeyPath:@"event.id"];
		event.keyword = keyword;
		
		VenueDetails *venueDetails = [NSEntityDescription
												insertNewObjectForEntityForName:@"VenueDetails"
												inManagedObjectContext:self.managedObjectContext];
											
	
		venueDetails.name = [obj valueForKeyPath:@"event.venue.name"];
		venueDetails.latitude = [obj valueForKeyPath:@"event.venue.latitude"];
		venueDetails.longitude = [obj valueForKeyPath:@"event.venue.longitude"];
		venueDetails.street = [obj valueForKeyPath:@"event.venue.address"];
		venueDetails.city = [obj valueForKeyPath:@"event.venue.city"];
		venueDetails.zip = @([[obj valueForKeyPath:@"event.venue.postal_code"] intValue]);
		venueDetails.state = [obj valueForKeyPath:@"event.venue.region"];
		
		venueDetails.event = event;
		event.venue = venueDetails;
		
	}];
	
	[self.managedObjectContext save:nil];
		
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JSONParseComplete" object:self];
	
	// Test events are in the store
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
											  inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	for (Event *info in fetchedObjects) {
		NSLog(@"Name: %@", info.title);
		VenueDetails *details = info.venue;
		NSLog(@"Zip: %@", details.zip);
	}
}

@end
