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

@implementation ATutorAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
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
    [super dealloc];
}


@end
