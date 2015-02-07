//
//  AppDelegate.h
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (TwitterNavigationController *)tweetsViewController;

@property (strong, nonatomic) UIWindow *window;

@end

