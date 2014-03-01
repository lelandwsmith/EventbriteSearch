//
//  OJDAppDelegate.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/26/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OJDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (OJDAppDelegate *)sharedAppDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
