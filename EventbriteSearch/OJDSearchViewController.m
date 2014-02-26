//
//  OJDViewController.m
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/26/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import "OJDSearchViewController.h"
#import "AFNetworking.h"
#import "XMLReader.h"
#import "MBProgressHUD.h"

static NSString *const BaseURLString = @"https://www.eventbrite.com/json/event_search?app_key=%@&keywords=%@&city=%@";
static NSString *const appKey = @"S7MAIC4DPB5TFGTMDN";

@interface OJDSearchViewController ()

@property (strong, nonatomic) IBOutlet UITextField *keywordTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;

@property (strong, nonatomic) NSString *searchKeyword;
@property (strong, nonatomic) NSString *searchCity;

@property (strong, nonatomic) NSDictionary *responseDictionary;

@end

@implementation OJDSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	
    tapGesture.cancelsTouchesInView = NO;
	
    [self.view addGestureRecognizer:tapGesture];

}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
	[self.view endEditing:YES];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.keywordTextField) {
		self.searchKeyword = textField.text;
	} else if (textField == self.cityTextField){
		self.searchCity = textField.text;
	}
	
	[textField resignFirstResponder];
	
	return YES;
}

- (IBAction)searchButtonTapped:(id)sender
{
	if (!self.searchKeyword || !self.searchCity) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
														message:NSLocalizedString(@"FIELD_ERROR", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"OKAY", nil)
											  otherButtonTitles:nil];
		[alert show];
	} else {
		[self makeRequestWithURL:[self buildURLString]];
	}
}

- (NSString *)buildURLString
{
	NSString *cityString = [self.searchCity stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString *keywordString = [self.searchKeyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	
	NSString *requestURL = [NSString stringWithFormat:BaseURLString, appKey, keywordString, cityString];
	
	return requestURL;
}


- (void) makeRequestWithURL:(NSString *)requestURL
{
    NSLog(@"Making request");
	
	MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText = @"Searching";
	
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSError *error = nil;
		
		self.responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
		
		[HUD hide:YES];
		
	} failure:^(AFHTTPRequestOperation *operation, id responseObject) {
	
		NSLog(@"%@", @"Network operation failed");
		
	}];
	
	[operation start];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parsing lifecycle

//- (void)startTheParsingProcess:(NSData *)parserData
//{
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:parserData]; //parserData passed to NSXMLParser delegate which starts the parsing process
//	
//    [parser setDelegate:self];
//    [parser parse]; // starts the event-driven parsing operation.
//}
//
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
//{
//    if ([elementName isEqualToString:@"yweather:astronomy"])
//    {
//        NSLog(@"Sunrise: %@,  Sunset: %@", [attributeDict valueForKey:@"sunrise"], [attributeDict valueForKey:@"sunset"]);
//    }
//	
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    self.tmpInnerTagText = string; // Make a temp NSString to store the text in-between tags
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
//{
//    if ([elementName isEqualToString:@"title"])
//    {
//        NSLog(@"%@", self.tmpInnerTagText);
//    }
//    if ([elementName isEqualToString:@"description"])
//    {
//        NSLog(@"%@", self.tmpInnerTagText);
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
//{
//    NSLog(@"Paser Error = %@", parseError);
//    //TODO: Create Alert message error
//}

@end
