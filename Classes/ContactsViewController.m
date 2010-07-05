//
//  ContactsViewController.m
//  ATutor
//
//  Created by Quang Anh Do on 03/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ContactsViewController.h"
#import "Friend.h"
#import "CommonFunctions.h"

@implementation ContactsViewController

- (id)init {
	if (self = [super init]) {
		self.title = @"Contacts";
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	NSDictionary *friendList = [NSKeyedUnarchiver unarchiveObjectWithFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"friends.plist"]];
	
	TTListDataSource *dataSource = [[[TTListDataSource alloc] init] autorelease];
	for (Friend *friend in friendList) {
		[dataSource.items addObject:[TTTableTextItem itemWithText:friend.displayName URL:nil]];
	}
	self.dataSource = dataSource;
}

@end
