//
//  ATutorAppDelegate.m
//  ATutor
//
//  Created by Quang Anh Do on 25/05/2010.
//  Copyright Quang Anh Do 2010. All rights reserved.
//

#import "ATutorAppDelegate.h"
#import "StyleSheet.h"
#import "OSConsumer.h"

@implementation ATutorAppDelegate

@synthesize window;
@synthesize consumer;
@synthesize launcher;
@synthesize webController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Set service consumer
	consumer = [[OSConsumer alloc] init];
	
	// Set global stylesheet
	[TTDefaultStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];	
	
	// Set web controller handler
	launcher = [[LauncherViewController alloc] init];
	
	webController = [[QAWebController alloc] init];
	webController.oAuthDelegate = launcher;
	
	// Wire up navigator
	TTNavigator *navigator = [TTNavigator navigator];
	navigator.window = window;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:webController];
	[map from:@"atutor://launcher" toViewController:launcher];
	
	// Display launcher if there's no view controller to restore
	if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"atutor://launcher"]];
	}
	
	return YES;
}


- (void)dealloc {
    [window release];
	[consumer release];
	[launcher release];
	[webController release];
	
    [super dealloc];
}

@end
