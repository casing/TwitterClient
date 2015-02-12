//
//  AppDelegate.h
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (MainViewController *)mainViewController;

@property (strong, nonatomic) UIWindow *window;

@end

