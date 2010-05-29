//
//  OSProvider.m
//  ATutor
//
//  Created by Quang Anh Do on 29/05/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "OSProvider.h"
#import "OARequestParameter.h"


@implementation OSProvider

@synthesize requestUrl, authorizeUrl, accessUrl, endpointUrl, extraRequestUrlParams, isOpenSocial, consumerKey, consumerSecret, name;

- (void)dealloc {
	[requestUrl release];
	[authorizeUrl release];
	[accessUrl release];
	[endpointUrl release];
	[consumerKey release];
	[consumerSecret release];
	[name release];
	
	[super dealloc];
}

+ (OSProvider *)getATutorProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
	OSProvider *atutor = [[[OSProvider alloc] init] autorelease];
	atutor.requestUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/request_token.php";
	atutor.authorizeUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/authorize.php";
	atutor.accessUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/access_token.php";
	atutor.endpointUrl = @"http://localhost:8888/shindig/php/social/rest";
	
	atutor.isOpenSocial = YES;
	
	atutor.consumerKey = key;
	atutor.consumerSecret = secret;
	
	atutor.name = @"ATutor";
	
	return atutor;
}

@end
