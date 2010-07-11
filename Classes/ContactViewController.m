//
//  ContactViewController.m
//  ATutor
//
//  Created by Quang Anh Do on 06/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ContactViewController.h"
#import "CommonFunctions.h"

@implementation ContactViewController

- (void)dealloc {
	CFRelease(addressBook);
	[delegate release];
	
	[super dealloc];
}

- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query {
	NSLog(@"QAD");
	if (self = [[ABPersonViewController alloc] init]) {
		[(ABPersonViewController *)self setAllowsEditing:YES];
		self.displayedPerson = [query objectForKey:@"person"];
	}
	
	return self;
}

- (id)initWithId:(int)identifier {
	NSDictionary *contactList = [NSKeyedUnarchiver unarchiveObjectWithFile:[applicationDocumentsDirectory() stringByAppendingPathComponent:@"contact_mapping.plist"]];
	
	return [self initWithId:identifier 
					   name:[contactList objectForKey:[NSString stringWithFormat:@"%d", identifier]]];
}

- (id)initWithId:(int)identifier name:(NSString *)name {
	delegate = [[ContactViewControllerDelegate alloc] init];
	
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
		[(ABPersonViewController *)self setAllowsEditing:YES];
	} else {
		self = [[ABUnknownPersonViewController alloc] init];
		[(ABUnknownPersonViewController *)self setAllowsActions:YES];
		[(ABUnknownPersonViewController *)self setAllowsAddingToAddressBook:YES];
		[(ABUnknownPersonViewController *)self setUnknownPersonViewDelegate:delegate];
	}
	
	self.displayedPerson = person;
	
	if (matches) CFRelease(matches);
	
	return self;
}

@end
