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

#import "OARequestParameter.h"
#import "CommonFunctions.h"
#import "OAServiceTicket.h"
#import "NSDictionary_JSONExtensions.h"

@interface ATutorAppDelegate (Private) 

- (void)wireUpNavigator;
- (void)fetchFriendList;
- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response;
- (NSDictionary *)matchDisplayNameWithId:(NSArray *)data;

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
	numberOfFriends = 0;
	friends = [[NSMutableArray alloc] init];
	[self fetchFriendList];
	
	[self wireUpNavigator];
	
	return YES;
}


- (void)dealloc {
    [window release];
	[consumer release];
	[launcher release];
	[webController release];
	
	[friends release];
	
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
	NSLog(@"=-=-=-=-=-=-=-=-Fetching friend list-=-=-=-=-=-=-=-=");
	
	[consumer getDataForUrl:@"/people/@me/@friends" 
			  andParameters:[NSArray arrayWithObjects:[OARequestParameter requestParameterWithName:@"count" value:@"100"], 
							 [OARequestParameter requestParameterWithName:@"startIndex" value:[NSString stringWithFormat:@"%d", numberOfFriends]], nil] 
				   delegate:self 
		  didFinishSelector:@selector(peopleCallback:didFinishWithResponse:)];
}

- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
	if (ticket.didSucceed) {
		NSError *error = nil;
		NSDictionary *data = [NSDictionary dictionaryWithJSONData:[response dataUsingEncoding:NSUTF8StringEncoding] error:&error];
		
		numberOfFriends += [[data objectForKey:@"itemsPerPage"] intValue];
		[friends addObjectsFromArray:[data objectForKey:@"entry"]];
		
		// Continue fetching or not?
		if (numberOfFriends < [[data objectForKey:@"totalResults"] intValue]) {
			[self fetchFriendList];
		} else {
			NSLog(@"Archiving friend list");
			
			[NSKeyedArchiver archiveRootObject:[self matchDisplayNameWithId:friends]
										toFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"friends.plist"]];
		}
		
		// Good to go
		[self wireUpNavigator];
	} else {
		alertMessage(@"Error", @"Unable to process your request");
	}
}

- (NSDictionary *)matchDisplayNameWithId:(NSArray *)data {
	NSMutableDictionary *retVal = [[NSMutableDictionary alloc] init];
	
	for (NSDictionary *friend in data) {
		[retVal setObject:[friend objectForKey:@"displayName"] 
				   forKey:[friend objectForKey:@"id"]];
	}
	
	return [retVal autorelease];
}


@end
