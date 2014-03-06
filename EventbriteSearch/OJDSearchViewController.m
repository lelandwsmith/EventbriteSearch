//
//  OJDViewController.m
//  EventbriteSearch
//
//  Created by Oliver Dormody on 2/26/14.
//  Copyright (c) 2014 Oliver Dormody. All rights reserved.
//

#import "OJDSearchViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "OJDResultsParser.h"
#import "OJDSearchResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const BaseURLString = @"https://www.eventbrite.com/json/event_search?app_key=%@&keywords=%@&city=%@";
static NSString *const AppKey = @"S7MAIC4DPB5TFGTMDN";

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
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(displaySearchResults:)
												 name:@"JSONParseComplete"
											   object:nil];
	
	//dismisses keyboard if tapped outside of text field
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
	
	//change textfield border to Eventbrite orange
	self.keywordTextField.layer.borderColor = [UIColor colorWithRed:253/255.0 green:125/255.0 blue:34/255.0 alpha:1.0].CGColor;
	self.keywordTextField.layer.cornerRadius = 0;
    self.keywordTextField.layer.masksToBounds = YES;
	self.keywordTextField.layer.borderWidth = 1.0f;
	
	self.cityTextField.layer.borderColor = [UIColor colorWithRed:253/255.0 green:125/255.0 blue:34/255.0 alpha:1.0].CGColor;
	self.cityTextField.layer.cornerRadius = 0;
    self.cityTextField.layer.masksToBounds = YES;
	self.cityTextField.layer.borderWidth = 1.0f;
	
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
	[self.view endEditing:YES];
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if (textField == self.keywordTextField) {
		self.searchKeyword = textField.text;
	} else if (textField == self.cityTextField){
		self.searchCity = textField.text;
	}
	
	[textField resignFirstResponder];
	[self.view endEditing:YES];
	
	return YES;
}

- (IBAction)searchButtonTapped:(id)sender
{
	if (!(self.searchKeyword || self.searchCity) || ([self.searchCity isEqualToString:@""] || [self.searchKeyword isEqualToString:@""])) {
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

- (void)displaySearchResults:(id)sender
{
	[self performSegueWithIdentifier:@"SearchCompleted" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"SearchCompleted"])
    {
        // Get reference to the destination view controller
        OJDSearchResultsViewController *vc = [segue destinationViewController];
		
		vc.keyword = self.searchKeyword;
		vc.city = [self.searchCity capitalizedString];
    }
}

- (NSString *)buildURLString
{
	NSString *cityString = [self.searchCity stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSString *keywordString = [self.searchKeyword stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	
	NSString *requestURL = [NSString stringWithFormat:BaseURLString, AppKey, keywordString, cityString];
	
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
		
		[[OJDResultsParser sharedResultsParser] parseJSONForData:responseObject withKeyword:self.searchKeyword];
		
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

@end
