//
//  CenterViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/14/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class CenterViewController;

@protocol CenterViewControllerDelegate <NSObject>

- (void)onShowMenuCenterViewController:(CenterViewController *)vc;

@end

@interface CenterViewController : UIViewController

@property (nonatomic, weak)id<CenterViewControllerDelegate> delegate;

- (void)showProfile;
- (void)showTweets;
- (void)updateHomeTimelineWithParams:(NSDictionary *)params;
- (void)updateMentionsTimelineWithParams:(NSDictionary *)params;
- (void)setUser:(User *)user;

@end
