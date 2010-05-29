//
//  OpenSocialProvider.m
//  OSCientLibrary
//
//  Created by Cassie Doll on 1/29/09.
//  Copyright Google 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "OpenSocialProvider.h"
#import "OARequestParameter.h"

@implementation OpenSocialProvider

@synthesize requestUrl, authorizeUrl, accessUrl, endpointUrl, extraRequestUrlParams, 
isOpenSocial, consumerKey, consumerSecret, name;

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

+ (OpenSocialProvider *) getATutorProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
  OpenSocialProvider *atutor = [[[OpenSocialProvider alloc] init] autorelease];
  atutor.requestUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/request_token.php";
  atutor.authorizeUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/authorize.php";
  atutor.accessUrl = @"http://localhost:8888/atutor/docs/mods/_standard/social/lib/oauth/access_token.php";
  atutor.endpointUrl = @"http://localhost:8888/shindig/php/social/rest";
  
  atutor.isOpenSocial = FALSE;
  
  atutor.consumerKey = key;
  atutor.consumerSecret = secret;
  
  atutor.name = @"ATutor";
  
  return atutor;
}

+ (OpenSocialProvider *) getPlaxoProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
	OpenSocialProvider *plaxo = [[[OpenSocialProvider alloc] init] autorelease];
	plaxo.requestUrl = @"http://www.plaxo.com/oauth/request";
	plaxo.authorizeUrl = @"http://www.plaxo.com/oauth/authorize";
	plaxo.accessUrl = @"http://www.plaxo.com/oauth/activate";
	plaxo.endpointUrl = @"http://www.plaxo.com/pdata/contacts";
	
	plaxo.isOpenSocial = FALSE;
	
	plaxo.consumerKey = key;
	plaxo.consumerSecret = secret;
	
	plaxo.name = @"Plaxo";
	
	return plaxo;
}

+ (OpenSocialProvider *) getGoogleProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
  OpenSocialProvider *google = [[[OpenSocialProvider alloc] init] autorelease];
  google.requestUrl = @"https://www.google.com/accounts/OAuthGetRequestToken";
  google.authorizeUrl = @"https://www.google.com/accounts/OAuthAuthorizeToken";
  google.accessUrl = @"https://www.google.com/accounts/OAuthGetAccessToken";
  google.endpointUrl = @"http://www-opensocial.googleusercontent.com/api";
  
  google.isOpenSocial = TRUE;
  google.extraRequestUrlParams = [NSArray arrayWithObject:
                                  [OARequestParameter 
                                   requestParameterWithName:@"scope" 
                                   value:@"http://www-opensocial.googleusercontent.com/api/people"]];
  
  google.consumerKey = key;
  google.consumerSecret = secret;
  
  google.name = @"Google";
  
  return google;
}

+ (OpenSocialProvider *) getPartuzaProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
  OpenSocialProvider *partuza = [[[OpenSocialProvider alloc] init] autorelease];
  partuza.requestUrl = @"http://www.partuza.nl/oauth/request_token";
  partuza.authorizeUrl = @"http://www.partuza.nl/oauth/authorize";
  partuza.accessUrl = @"http://www.partuza.nl/oauth/access_token";
  partuza.endpointUrl = @"http://modules.partuza.nl/social/rest";
  
  partuza.isOpenSocial = TRUE;
  
  partuza.consumerKey = key;
  partuza.consumerSecret = secret;
  
  partuza.name = @"Partuza";
  
  return partuza;
}

+ (OpenSocialProvider *) getMySpaceProviderWithKey:(NSString *)key withSecret:(NSString *)secret {
  OpenSocialProvider *myspace = [[[OpenSocialProvider alloc] init] autorelease];
  myspace.requestUrl = @"http://api.myspace.com/request_token";
  myspace.authorizeUrl = @"http://api.myspace.com/authorize";
  myspace.accessUrl = @"http://api.myspace.com/access_token";
  myspace.endpointUrl = @"http://api.myspace.com/v2";
  
  myspace.isOpenSocial = TRUE;
  
  myspace.consumerKey = key;
  myspace.consumerSecret = secret;
  
  myspace.name = @"MySpace";
  
  return myspace;
}

@end
