//
//  ContactsDataSource.m
//  ATutor
//
//  Created by Quang Anh Do on 10/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ContactsDataSource.h"
#import "CommonFunctions.h"
#import "Contact.h"


@implementation ContactsDataSource

- (id)init {
	if (self = [super init]) {
		NSDictionary *contactList = [NSKeyedUnarchiver unarchiveObjectWithFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"contacts.plist"]];
		
		for (Contact *contact in contactList) {
			NSString *urlString = [NSString stringWithFormat:@"atutor://contact/%d/%@", contact.identifier, [contact.displayName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[self.items addObject:[TTTableTextItem itemWithText:contact.displayName URL:urlString]];
		}
	}
	
	return self;
}

@end
