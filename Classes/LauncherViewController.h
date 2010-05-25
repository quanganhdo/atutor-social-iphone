//
//  LauncherViewController.h
//  ATutor
//
//  Created by Quang Anh Do on 25/05/2010.
//  Copyright 2010 Quang Anh Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface LauncherViewController : UIViewController <TTLauncherViewDelegate> {
	TTLauncherView *launcherView;
}

@end
