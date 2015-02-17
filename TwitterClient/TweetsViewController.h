//
//  TweetsViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/4/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "User.h"
#import "Tweet.h"

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>

- (void)tweetsViewController:(TweetsViewController *)vc onUserProfile:(User *)user;
- (void)tweetsViewController:(TweetsViewController *)vc onReplyTweet:(Tweet *)tweet;
- (void)tweetsViewController:(TweetsViewController *)vc onRetweetTweet:(Tweet *)tweet;
- (void)tweetsViewController:(TweetsViewController *)vc onFavoriteTweet:(Tweet *)tweet;
- (void)tweetsViewController:(TweetsViewController *)vc onDetailsTweet:(Tweet *)tweet;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak)id<TweetsViewControllerDelegate> delegate;

- (void)updateHomeTimelineWithParams:(NSDictionary *)params;
- (void)updateMentionsTimelineWithParams:(NSDictionary *)params;
- (void)pushTweetToTable:(Tweet *)tweet;
- (void)updateTable;

@end
