//
//  StyleSheet.m
//  ATutor
//
//  Created by Quang Anh Do on 25/05/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import "StyleSheet.h"


@implementation StyleSheet

- (TTStyle*)launcherButton:(UIControlState)state {
	return
    [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE(launcherButtonImage:, state) next:
	 [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11] color:[UIColor blackColor]
				minimumFontSize:11 shadowColor:nil
				   shadowOffset:CGSizeZero next:nil]];
}

@end
