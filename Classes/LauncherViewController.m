//
//  LauncherViewController.m
//  ATutor
//
//  Created by Quang Anh Do on 25/05/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "LauncherViewController.h"
#import "ATutorAppDelegate.h"
#import "OSConsumer.h"
#import "OAServiceTicket.h"
#import "NSDictionary_JSONExtensions.h"
#import "CommonFunctions.h"

@implementation LauncherViewController

@synthesize launcherView;

- (id)init {
	if (self = [super init]) {
		self.title = @"ATutor Social";
	}
	
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadView {
	[super loadView];
	
	launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	
	launcherView.delegate = self;
	launcherView.backgroundColor = [UIColor colorWithRed:0.875 green:0.871 blue:0.925 alpha:1.000];
	launcherView.columnCount = 2;
	
	// Attempt to restore data if exists
	[self restorePages];
	
	[self.view addSubview:launcherView];
}


- (void)dealloc {
	[launcherView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							  target:launcherView
																							  action:@selector(endEditing)] autorelease] 
									  animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];

	// Persist data the ugly way
	NSData *pages = [NSKeyedArchiver archivedDataWithRootObject:launcherView.pages];
	[[NSUserDefaults standardUserDefaults] setObject:pages forKey:@"launcher.pages"];
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	if ([item.title isEqualToString:@"Activities"]) {
		[[(OSConsumer *)[[UIApplication sharedApplication] delegate] consumer] getDataForUrl:@"/activities/@supportedFields" 
																			   andParameters:nil 
																					delegate:self 
																		   didFinishSelector:@selector(activitiesCallback:didFinishWithResponse:)];
	}
}

- (void)activitiesCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
	alertMessage(@"Response", response);
}

#pragma mark -
#pragma mark QAWebControllerDelegate

- (void)didFinishAuthorizationInWebViewController:(QAWebController *)webViewController {
	[self.navigationController popViewControllerAnimated:YES];
	
	[[(OSConsumer *)[[UIApplication sharedApplication] delegate] consumer] finishAuthProcess];
	[[(OSConsumer *)[[UIApplication sharedApplication] delegate] consumer] getDataForUrl:@"/activities/@supportedFields" 
																		   andParameters:nil 
																				delegate:self 
																	   didFinishSelector:@selector(activitiesCallback:didFinishWithResponse:)];
}

#pragma mark -
#pragma mark Misc

- (void)restorePages {
	NSData *pages = [[NSUserDefaults standardUserDefaults] objectForKey:@"launcher.pages"];
	if (pages != nil) {
		launcherView.pages = [NSKeyedUnarchiver unarchiveObjectWithData:pages];
	} else {
		for (NSString *module in [NSArray arrayWithObjects:@"Activities", @"Contacts", @"Gadgets", @"Groups", nil]) {
			[launcherView addItem:[[[TTLauncherItem alloc] initWithTitle:module 
																   image:[NSString stringWithFormat:@"bundle://%@.png", module]
																	 URL:[NSString stringWithFormat:@"atutor://modules/%@", module] 
															   canDelete:NO] autorelease] 
						 animated:NO];
		}
	}
}

@end
