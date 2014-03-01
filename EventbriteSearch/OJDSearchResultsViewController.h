//
//  OJDSearchResultsViewController.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/27/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OJDSearchResultsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *city;

@end
