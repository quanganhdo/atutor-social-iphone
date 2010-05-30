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

@interface LauncherViewController (Private)

- (void)logout;

@end

@implementation LauncherViewController

@synthesize launcherView;
@synthesize logoutButton;

- (id)init {
	if (self = [super init]) {
		
	}
	
	return self;
}

- (void)dealloc {
	[launcherView release];
	[logoutButton release];
	
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	logoutButton = [[UIBarButtonItem alloc] initWithTitle:TTLocalizedString(@"Logout", @"") 
													style:UIBarButtonItemStyleBordered 
												   target:self action:@selector(logout)];
	
	self.title = TTLocalizedString(@"ATutor Social", @"");
	self.navigationItem.rightBarButtonItem = logoutButton;
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

#pragma mark -
#pragma mark TTLauncherViewDelegate

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							  target:launcherView
																							  action:@selector(endEditing)] autorelease] 
									  animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:logoutButton animated:YES];

	// Persist data the ugly way
	NSData *pages = [NSKeyedArchiver archivedDataWithRootObject:launcherView.pages];
	[[NSUserDefaults standardUserDefaults] setObject:pages forKey:@"launcher.pages"];
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	if ([item.title isEqualToString:TTLocalizedString(@"Activities", @"")]) {
#warning TODO: Move this to ATutorHelper
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
}

#pragma mark -
#pragma mark Misc

- (void)restorePages {
	NSData *pages = [[NSUserDefaults standardUserDefaults] objectForKey:@"launcher.pages"];
	if (pages != nil) {
		launcherView.pages = [NSKeyedUnarchiver unarchiveObjectWithData:pages];
	} else {
		for (NSString *module in [NSArray arrayWithObjects:@"Activities", @"Contacts", @"Gadgets", @"Groups", nil]) {
			[launcherView addItem:[[[TTLauncherItem alloc] initWithTitle:TTLocalizedString(module, @"") 
																   image:[NSString stringWithFormat:@"bundle://%@.png", module]
																	 URL:[NSString stringWithFormat:@"atutor://modules/%@", module] 
															   canDelete:NO] autorelease] 
						 animated:NO];
		}
	}
}

- (void)logout {
	[[(OSConsumer *)[[UIApplication sharedApplication] delegate] consumer] clearAuthentication];
	
	NSLog(@"You have been logged out");
}

@end
