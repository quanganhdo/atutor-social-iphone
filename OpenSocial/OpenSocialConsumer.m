//
//  OpenSocialApi.m
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

#import "OpenSocialConsumer.h"
#import "SFHFKeychainUtils.h"
#import "ProviderListController.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAToken.h"
#import "OAToken_KeychainExtensions.h"
#import "OpenSocialProvider.h"

@interface OpenSocialConsumer (Private)
- (void) setupConsumer;
- (void) getRequestToken;
- (void) getAccessToken;
@end

@interface OpenSocialConsumer()
@property(nonatomic, copy)NSString *callbackScheme;
@property(nonatomic, retain)UIWindow *window;
@property(nonatomic, retain)OAToken *accessToken;
@property(nonatomic, retain)OAConsumer *consumer;
@property(nonatomic, readwrite, retain)OpenSocialProvider *currentProvider;
@property(nonatomic, retain)ProviderListController *providerList;
@end

@implementation OpenSocialConsumer

@synthesize callbackScheme, window, consumer, currentProvider, providerList;
@synthesize accessToken, providers;

// providers is an array of OpenSocialProvider objects
- (id)initWithProviders:(NSArray *)newProviders andCallbackScheme:(NSString *)newCallbackScheme 
      andMainWindow:(UIWindow *)newWindow {
  if (self = [super init]) {
    self.providers = newProviders;    
    self.callbackScheme = newCallbackScheme;
    self.window = newWindow;
    
    // Look up accessToken in keystore. 
    self.accessToken = [[[OAToken alloc] initWithKeychainUsingAppName:@"atutor" 
                                                            tokenType:@"accessToken"] autorelease];
    
    // Look up the currentProvider. then setup the provider and  consumer
    NSString *currentProviderName = [SFHFKeychainUtils getPasswordForUsername:@"currentProvider" 
                   andServiceName:@"atutor" error:nil];
    for (OpenSocialProvider *provider in providers) {
      if ([[provider name] isEqualToString:currentProviderName]) {
        self.currentProvider = provider;
        [self setupConsumer];
        break;
      }
    }
  }
  return self;
}

- (void) clearAuthentication {
  [SFHFKeychainUtils storeUsername:@"accessToken" andPassword:@"" forServiceName:@"atutor" updateExisting:TRUE error:nil];
  [SFHFKeychainUtils storeUsername:@"requestToken" andPassword:@"" forServiceName:@"atutor" updateExisting:TRUE error:nil];
  [SFHFKeychainUtils storeUsername:@"currentProvider" andPassword:@"" forServiceName:@"atutor" updateExisting:TRUE error:nil];
  
  self.accessToken = nil;
  self.currentProvider = nil;
}

// Pop up the list of providers for the user to choose from
// The list will call the chooseProviderAtIndex method
- (void) startAuthProcess {
  self.providerList = [[[ProviderListController alloc] initWithConsumer:self] autorelease];
  [window addSubview:[providerList view]];
  [window makeKeyAndVisible];
}

// Should be called within a handleOpenUrl method. 
// This method assumes the request token was authorized and will retrieve the access token
- (void) finishAuthProcess {
  [self getAccessToken];
}

- (void) chooseProviderAtIndex:(NSInteger) index {
  currentProvider = [self.providers objectAtIndex:index];
  [SFHFKeychainUtils storeUsername:@"currentProvider"  andPassword:[currentProvider name] 
            forServiceName:@"atutor" updateExisting:TRUE error:nil];
  NSLog(@"Stored this current provider: %@", [currentProvider name]);
  
  [self setupConsumer];
  [self getRequestToken];
}

- (void) setupConsumer {
  self.consumer = [[[OAConsumer alloc] initWithKey:[currentProvider consumerKey] 
                                            secret:[currentProvider consumerSecret]] autorelease];
}

- (void) getRequestToken {  
  OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] 
                                   initWithURL:[NSURL URLWithString:[currentProvider requestUrl]] 
                                   parameters:[currentProvider extraRequestUrlParams]
                                   consumer:consumer 
                                   token:nil] autorelease];
  [request setHTTPMethod:@"GET"];
  
  [OADataFetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(requestTokenCallback:didFinishWithResponse:)];
}

- (void)requestTokenCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
  if (ticket.didSucceed) {
    OAToken *requestToken = [[OAToken alloc] initWithHTTPResponseBody:response];
    [requestToken storeInDefaultKeychainWithAppName:@"atutor" tokenType:@"requestToken"];    
    NSLog(@"Stored this secret and key: %@ : %@", [requestToken key], [requestToken secret]);
    
    NSString *urlString = [NSString stringWithFormat:@"%@?oauth_callback=%@://&oauth_token=%@", 
                           [currentProvider authorizeUrl], callbackScheme, [requestToken key]];
    
    NSLog(@"Request string: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
  } else {
    NSString *error = [NSString stringWithFormat:@"Got error while requesting request token. %@", response];
    NSLog(@"%@", error);
    
    @throw [NSException exceptionWithName:@"RequestTokenException" reason:error  userInfo:nil];
  }
}

- (void) getAccessToken {  
  OAToken *requestToken = [[OAToken alloc] initWithKeychainUsingAppName:@"atutor" 
                                                              tokenType:@"requestToken"];
  NSLog(@"Getting access token for request token: %@ : %@", [requestToken key], [requestToken secret]);
  
  OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] 
                                   initWithURL:[NSURL URLWithString:[currentProvider accessUrl]]
                                   consumer:consumer token:requestToken] autorelease];
  [request setHTTPMethod:@"GET"];
  
  [OADataFetcher fetchDataWithRequest:request delegate:self
                    didFinishSelector:@selector(accessTokenCallback:didFinishWithResponse:)];
}

- (void)accessTokenCallback:(OAServiceTicket *)ticket didFinishWithResponse:(id)response {
  if (ticket.didSucceed) {
    self.accessToken = [[[OAToken alloc] initWithHTTPResponseBody:response] autorelease];
    [accessToken storeInDefaultKeychainWithAppName:@"atutor" tokenType:@"accessToken"];
    
    NSLog(@"Got an access token: %@ : %@", [accessToken key], [accessToken secret]);
    
  } else {
    NSString *error = [NSString stringWithFormat:@"Got error while requesting access token. %@", response];
    NSLog(@"%@", error);
    
    @throw [NSException exceptionWithName:@"AccessTokenException" reason:error  userInfo:nil];
  }
}
  
- (void)getDataForUrl:(NSString *)relativeUrl andParameters:(NSArray*)params 
             delegate:(id)delegate didFinishSelector:(SEL)didFinishSelector {
  if (!accessToken || !currentProvider) {
    [self startAuthProcess];  
    return;
  }
  
  NSLog(@"Getting data with access token: %@ : %@", [accessToken key], [accessToken secret]);
  
  NSString *url = [[currentProvider endpointUrl] stringByAppendingString:relativeUrl];  
  OAMutableURLRequest *request = [[[OAMutableURLRequest alloc] 
                                   initWithURL:[NSURL URLWithString:url]
                                   consumer:consumer token:accessToken] autorelease]; 
  [request setHTTPMethod:@"GET"];
  
  [OADataFetcher fetchDataWithRequest:request delegate:delegate
                    didFinishSelector:didFinishSelector];
}

- (void)dealloc {
  [providers release];
  [callbackScheme release];
  [window release];
  [currentProvider release];
  [consumer release];
  [accessToken release];
  [providerList release];
  [super dealloc];
}


@end
