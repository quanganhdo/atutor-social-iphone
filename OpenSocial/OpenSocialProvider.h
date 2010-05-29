//
//  OpenSocialProvider.h
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

#import <Foundation/Foundation.h>

@interface OpenSocialProvider : NSObject {
  NSString *requestUrl;
  NSString *authorizeUrl;
  NSString *accessUrl;
  NSString *endpointUrl;
  
  NSArray *extraRequestUrlParams;
  BOOL isOpenSocial;
  
  NSString *consumerKey;
  NSString *consumerSecret;
  
  NSString *name;  
}

@property(retain) NSString *requestUrl;
@property(retain) NSString *authorizeUrl;
@property(retain) NSString *accessUrl;
@property(retain) NSString *endpointUrl;

@property(retain) NSArray *extraRequestUrlParams;
@property BOOL isOpenSocial;

@property(retain) NSString *consumerKey;
@property(retain) NSString *consumerSecret;

@property(retain) NSString *name;

+ (OpenSocialProvider *) getATutorProviderWithKey:(NSString *)key withSecret:(NSString *)secret;
+ (OpenSocialProvider *) getPlaxoProviderWithKey:(NSString *)key withSecret:(NSString *)secret;
+ (OpenSocialProvider *) getGoogleProviderWithKey:(NSString *)key withSecret:(NSString *)secret;
+ (OpenSocialProvider *) getPartuzaProviderWithKey:(NSString *)key withSecret:(NSString *)secret;
+ (OpenSocialProvider *) getMySpaceProviderWithKey:(NSString *)key withSecret:(NSString *)secret;

@end
