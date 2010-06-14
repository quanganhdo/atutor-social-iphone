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

#import "ActivitiesViewController.h"

#import "CommonFunctions.h"
#import "OAServiceTicket.h"
#import "NSDictionary_JSONExtensions.h"

@interface ATutorAppDelegate (Private) 

- (void)wireUpNavigator;
- (void)fetchFriendList;
- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response;
- (NSDictionary *)matchDisplayNameWithId:(NSDictionary *)data;

@end


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
	launcher = [[LauncherViewController alloc] initWithConsumer:consumer];
	
	webController = [[QAWebController alloc] init];
	webController.oAuthDelegate = launcher;
	
	// Update friend list
	[self fetchFriendList];
	
	[self wireUpNavigator];
	
	return YES;
}


- (void)dealloc {
    [window release];
	[consumer release];
	[launcher release];
	[webController release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Misc

- (void)wireUpNavigator {
	TTNavigator *navigator = [TTNavigator navigator];
	navigator.window = window;
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
	
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:webController];
	[map from:@"atutor://launcher" toViewController:launcher];
	[map from:@"atutor://activities" toViewController:[ActivitiesViewController class]];
	
	// Display launcher 
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"atutor://launcher"]];
}

- (void)fetchFriendList {
#warning TODO: Fetch all friends, not only the first 20
	[consumer getDataForUrl:@"/people/@me/@friends" 
			  andParameters:nil 
				   delegate:self 
		  didFinishSelector:@selector(peopleCallback:didFinishWithResponse:)];
}

- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
	if (ticket.didSucceed) {
		NSError *error = nil;
		NSDictionary *data = [NSDictionary dictionaryWithJSONData:[response dataUsingEncoding:NSUTF8StringEncoding] error:&error];
	
		[NSKeyedArchiver archiveRootObject:[self matchDisplayNameWithId:data]
									toFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"friends.plist"]];
		
		// Good to go
		[self wireUpNavigator];
	} else {
		alertMessage(@"Error", @"Unable to process your request");
	}
}

- (NSDictionary *)matchDisplayNameWithId:(NSDictionary *)data {
	NSMutableDictionary *retVal = [[NSMutableDictionary alloc] init];
	
	for (NSDictionary *friend in [data objectForKey:@"entry"]) {
		[retVal setObject:[friend objectForKey:@"displayName"] 
				   forKey:[friend objectForKey:@"id"]];
	}
	
	return [retVal autorelease];
}


@end
