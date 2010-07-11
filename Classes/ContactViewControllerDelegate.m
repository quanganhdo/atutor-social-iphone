//
//  ContactViewControllerDelegate.m
//  ATutor
//
//  Created by Quang Anh Do on 11/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "ContactViewControllerDelegate.h"


@implementation ContactViewControllerDelegate

#pragma mark -
#pragma mark Delegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person {
	if (person != NULL) {
		[unknownPersonView.navigationController popViewControllerAnimated:NO];
		[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"atutor://contact"] 
												applyQuery:[NSDictionary dictionaryWithObject:(id)person forKey:@"person"]]];
	}	
}

@end
