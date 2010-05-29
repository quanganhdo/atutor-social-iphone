//
//  ATutorAppDelegate.m
//  ATutor
//
//  Created by Quang Anh Do on 25/05/2010.
//  Copyright Quang Anh Do 2010. All rights reserved.
//

#import "ATutorAppDelegate.h"
#import "LauncherViewController.h"
#import "StyleSheet.h"
#import "OSConsumer.h"

@implementation ATutorAppDelegate

@synthesize window;
@synthesize consumer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Set service consumer
	consumer = [[OSConsumer alloc] init];
	
	// Set global stylesheet
	[TTDefaultStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];	
	
	// Wire up navigator
	TTNavigator *navigator = [TTNavigator navigator];
	navigator.window = window;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"atutor://launcher" toViewController:[LauncherViewController class]];
	
	// Display launcher if there's no view controller to restore
	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"atutor://launcher"]];
	}
	
	return YES;
}


- (void)dealloc {
    [window release];
	[consumer release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Misc

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	// We have been called back by a successful OAuth token grant
	// Now we need to fetch the access token
	NSLog(@"Handling URL: %@", url);
	
	[consumer finishAuthProcess];
	
	return YES;
}

@end
