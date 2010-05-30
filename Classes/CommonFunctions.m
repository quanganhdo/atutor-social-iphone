//
//  CommonFunctions.m
//  ATutor
//
//  Created by Quang Anh Do on 30/05/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "CommonFunctions.h"

#import <SystemConfiguration/SystemConfiguration.h>

@implementation CommonFunctions

void alertMessage(NSString *title, NSString *message) {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
														message:message 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];	
	[alertView release];
}

BOOL dataSourceAvailable() {
	Boolean success;    
	const char *host_name = "www.google.com";
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
	SCNetworkReachabilityFlags flags;
	success = SCNetworkReachabilityGetFlags(reachability, &flags);
	BOOL _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	CFRelease(reachability);
	
    return _isDataSourceAvailable;
} 

NSString *applicationDocumentsDirectory() {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
