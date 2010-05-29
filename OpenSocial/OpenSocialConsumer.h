//
//  OpenSocialApi.h
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
#import <UIKit/UIKit.h>

@class OpenSocialProvider;
@class OAConsumer;
@class OAToken;
@class ProviderListController;

@interface OpenSocialConsumer : NSObject {
 @private
  NSArray *providers;
  NSString *callbackScheme;
  UIWindow *window;
  
  OpenSocialProvider *currentProvider;
  OAConsumer *consumer;
  
  OAToken *accessToken;
  ProviderListController *providerList;
}

@property(nonatomic, copy)NSArray *providers;
@property(nonatomic, readonly, retain)OpenSocialProvider *currentProvider;

- (id)initWithProviders:(NSArray *)providers 
    andCallbackScheme:(NSString *)callbackScheme 
      andMainWindow:(UIWindow *)window;

- (void)getDataForUrl:(NSString *)relativeUrl 
        andParameters:(NSArray*)params 
           delegate:(id)delegate 
      didFinishSelector:(SEL)didFinishSelector;

- (void) finishAuthProcess;
- (void) clearAuthentication;

// Should only be used by ProviderListController
- (void) chooseProviderAtIndex:(NSInteger)index;

@end
