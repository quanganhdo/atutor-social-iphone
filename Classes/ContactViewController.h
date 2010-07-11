//
//  ContactViewController.h
//  ATutor
//
//  Created by Quang Anh Do on 06/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactViewControllerDelegate.h"


@interface ContactViewController : ABUnknownPersonViewController {
	ABAddressBookRef addressBook;
	ContactViewControllerDelegate *delegate;
}

- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query;
- (id)initWithId:(int)identifier;
- (id)initWithId:(int)identifier name:(NSString *)name;

@end
