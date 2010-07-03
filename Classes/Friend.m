//
//  Friend.m
//  ATutor
//
//  Created by Quang Anh Do on 03/07/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@synthesize identifier;
@synthesize displayName;


/* dealloc */
- (void) dealloc {
    [displayName release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Keyed Archiving

/*  Keyed Archiving */
//
- (void) encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeInt: [self identifier] forKey: @"identifier"];
    [encoder encodeObject: [self displayName] forKey: @"displayName"];
}

- (id) initWithCoder: (NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self setIdentifier: [decoder decodeIntForKey: @"identifier"]];
        [self setDisplayName: [decoder decodeObjectForKey: @"displayName"]];
    }
    return self;
}

@end
