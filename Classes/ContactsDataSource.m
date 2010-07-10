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
#import "ContactItemCell.h"


@implementation ContactsDataSource

- (id)init {
	if (self = [super init]) {
		NSDictionary *contactList = [NSKeyedUnarchiver unarchiveObjectWithFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"contacts.plist"]];
		
		NSMutableDictionary *nameIndexes = [NSMutableDictionary dictionary];
		
		for (Contact *contact in contactList) {
			// Setup contact item
			NSString *urlString = [NSString stringWithFormat:@"atutor://contact/%d/%@", contact.identifier, [contact.displayName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			TTTableTextItem *contactItem = [TTTableTextItem itemWithText:contact.displayName URL:urlString];
			
			// Setup name indexes for section headers
			NSString *firstLetter = [contact.displayName substringToIndex:1];
			NSMutableArray *existingArray;
			if (existingArray = [nameIndexes valueForKey:firstLetter]) {
				[existingArray addObject:contactItem];
			} else {
				NSMutableArray *tempArray = [NSMutableArray array];
				[nameIndexes setObject:tempArray forKey:firstLetter];
				[tempArray addObject:contactItem];
			}			
			
			[self.items addObject:contactItem];
		}
		
		// Final touches
		self.sections = [[nameIndexes allKeys] mutableCopy];
		self.items = [NSMutableArray array];
		
		for (NSString *index in self.sections) {
			[self.items addObject:[nameIndexes objectForKey:index]];
		}
	}
	
	return self;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
	return [TTSectionedDataSource lettersForSectionsWithSearch:NO summary:NO];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	return [ContactItemCell class];
}

@end
