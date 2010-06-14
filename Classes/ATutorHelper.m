//
//  ATutorHelper.m
//  ATutor
//
//  Created by Quang Anh Do on 07/06/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ATutorHelper.h"
#import "OARequestParameter.h"
#import "CommonFunctions.h"
#import "OAServiceTicket.h"
#import "NSDictionary_JSONExtensions.h"

@interface ATutorHelper (Private) 

- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response;
- (NSDictionary *)matchDisplayNameWithId:(NSArray *)data;

@end


@implementation ATutorHelper

@synthesize consumer;
@synthesize numberOfFriends;
@synthesize friends;
@synthesize delegate;

- (void)dealloc {
	[consumer dealloc];
	[friends dealloc];
	[delegate release];
	
	[super dealloc];
}

- (id)initWithConsumer:(OSConsumer *)csm {
	if (self = [super init]) {
		self.consumer = csm;
		self.numberOfFriends = 0;
		self.friends = [[NSMutableArray alloc] init];
	}
	
	return self;
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
		if (delegate && [delegate respondsToSelector:@selector(doneFetchingFriendList)]) {
			[delegate performSelector:@selector(doneFetchingFriendList)];
		}
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
