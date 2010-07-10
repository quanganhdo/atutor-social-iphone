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
#import	"Contact.h"

@interface ATutorHelper (Private) 

- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response;
- (NSDictionary *)matchDisplayNameWithId:(NSArray *)data;

@end


@implementation ATutorHelper

@synthesize consumer;
@synthesize numberOfContacts;
@synthesize contacts;
@synthesize contactMapping;
@synthesize delegate;

- (void)dealloc {
	[consumer dealloc];
	[contacts dealloc];
	[contactMapping dealloc];
	[delegate release];
	
	[super dealloc];
}

- (id)initWithConsumer:(OSConsumer *)csm {
	if (self = [super init]) {
		self.consumer = csm;
		self.numberOfContacts = 0;
		self.contacts = [[NSMutableArray alloc] init];
		self.contactMapping = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)fetchContactList {
	NSLog(@"=-=-=-=-=-=-=-=-Fetching contact list-=-=-=-=-=-=-=-=");
	
	[consumer getDataForUrl:@"/people/@me/@contacts" 
			  andParameters:[NSArray arrayWithObjects:[OARequestParameter requestParameterWithName:@"count" value:@"100"], 
							 [OARequestParameter requestParameterWithName:@"startIndex" value:[NSString stringWithFormat:@"%d", numberOfContacts]], 
							 [OARequestParameter requestParameterWithName:@"sortBy" value:@"displayName"],
							 nil] 
				   delegate:self 
		  didFinishSelector:@selector(peopleCallback:didFinishWithResponse:)];	
}

- (void)peopleCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
	if (ticket.didSucceed) {
		NSError *error = nil;
		NSDictionary *data = [NSDictionary dictionaryWithJSONData:[response dataUsingEncoding:NSUTF8StringEncoding] error:&error];
		
		// Process fetched stuff
		numberOfContacts += [[data objectForKey:@"itemsPerPage"] intValue];
		
		// Mapping
		[contactMapping addObjectsFromArray:[data objectForKey:@"entry"]];
		
		// And the real deal
		for (NSDictionary *entry in [data objectForKey:@"entry"]) {
			Contact *contact = [[Contact alloc] init];
			contact.identifier = [[entry objectForKey:@"id"] intValue];
			contact.displayName = [entry objectForKey:@"displayName"];
			[contacts addObject:contact];
			[contact release];
		}		
		
		// Continue fetching or not?
		if (numberOfContacts < [[data objectForKey:@"totalResults"] intValue]) {
			[self fetchContactList];
		} else {
			NSLog(@"Archiving contact list");
			
			[NSKeyedArchiver archiveRootObject:[self matchDisplayNameWithId:contactMapping]
										toFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"contact_mapping.plist"]];
			
			[NSKeyedArchiver archiveRootObject:contacts 
										toFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"contacts.plist"]];
		}
		
		// Good to go
		if (delegate && [delegate respondsToSelector:@selector(doneFetchingContactList)]) {
			[delegate performSelector:@selector(doneFetchingContactList)];
		}
	} else {
		alertMessage(@"Error", @"Unable to process your request");
	}
}

- (NSDictionary *)matchDisplayNameWithId:(NSArray *)data {
	NSMutableDictionary *retVal = [[NSMutableDictionary alloc] init];
	
	for (NSDictionary *contact in data) {
		[retVal setObject:[contact objectForKey:@"displayName"] 
				   forKey:[contact objectForKey:@"id"]];
	}
	
	return [retVal autorelease];
}

@end
