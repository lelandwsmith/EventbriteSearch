//
//  OJDResultsParser.h
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/26/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OJDResultsParser : NSObject

+(id)sharedResultsParser;
- (void)parseJSONForData:(NSData *)data withKeyword:(NSString *)keyword;

@end
