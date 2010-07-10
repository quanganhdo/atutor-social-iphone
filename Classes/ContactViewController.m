//
//  ContactViewController.m
//  ATutor
//
//  Created by Quang Anh Do on 06/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ContactViewController.h"


@implementation ContactViewController

- (id)initWithId:(int)identifier name:(NSString *)name {
	addressBook = ABAddressBookCreate();
	
	ABRecordRef person = NULL;
	CFArrayRef matches = ABAddressBookCopyPeopleWithName(addressBook, (CFStringRef)name);
	
	if (matches && CFArrayGetCount(matches)) {
		person = (id)CFArrayGetValueAtIndex(matches, 0);
		
		ABMultiValueRef urls = ABRecordCopyValue(person, kABPersonURLProperty);
		ABMutableMultiValueRef mutableURLs = NULL;
		if (urls) {
			mutableURLs = ABMultiValueCreateMutableCopy(urls);
			CFRelease(urls);
		} else {
			mutableURLs = ABMultiValueCreateMutable(kABStringPropertyType);
		}
		ABMultiValueAddValueAndLabel(mutableURLs, [NSString stringWithFormat:@"%@/mods/_standard/social/sprofile.php?id=%d", kATutorURL, identifier], CFSTR("ATutor"), NULL);
		CFRelease(mutableURLs);
	} else {
		person = ABPersonCreate();
		ABRecordSetValue(person, kABPersonFirstNameProperty, name, NULL);
		
		ABMutableMultiValueRef urls = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		ABMultiValueAddValueAndLabel(urls, [NSString stringWithFormat:@"%@/mods/_standard/social/sprofile.php?id=%d", kATutorURL, identifier], CFSTR("ATutor"), NULL);
		ABRecordSetValue(person, kABPersonURLProperty, urls, NULL);
		CFRelease(urls);
		[(id)person autorelease];
	}
	
	if (ABRecordGetRecordID(person) != kABRecordInvalidID) {
		self = [[ABPersonViewController alloc] init];
		self.allowsEditing = YES;
	} else {
		self = [[ABUnknownPersonViewController alloc] init];
		[(ABUnknownPersonViewController *)self setAllowsActions:YES];
		[(ABUnknownPersonViewController *)self setAllowsAddingToAddressBook:YES];
	}
	
	self.displayedPerson = person;
	
	if (matches) CFRelease(matches);
	
	return self;
}

- (void)dealloc {
	CFRelease(addressBook);
	
	[super dealloc];
}

@end
