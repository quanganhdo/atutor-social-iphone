//
//  ATutorHelper.h
//  ATutor
//
//  Created by Quang Anh Do on 07/06/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSConsumer.h"

@protocol ATutorHelperDelegate;

@interface ATutorHelper : NSObject {
	OSConsumer *consumer;
	
	int numberOfFriends;
	NSMutableArray *friends;
	NSMutableArray *friendMapping;
	
	id delegate;
}

@property (nonatomic, retain) OSConsumer *consumer;
@property int numberOfFriends;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSMutableArray *friendMapping;
@property (nonatomic, assign) id<ATutorHelperDelegate> delegate;

- (id)initWithConsumer:(OSConsumer *)csm;
- (void)fetchFriendList;

@end

@protocol ATutorHelperDelegate

- (void)doneFetchingFriendList;

@end