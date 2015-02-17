//
//  CenterViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/14/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "CenterViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "TwitterNavigationController.h"
#import "TwitterClient.h"
#import "User.h"

@interface CenterViewController () <TweetsViewControllerDelegate, DetailViewControllerDelegate, ComposeViewControllerDelegate>

@property (nonatomic, strong)TweetsViewController *tweetsViewController;
@property (nonatomic, strong)ProfileViewController *profileViewController;

- (void)onMenu;
- (void)onCompose;
- (void)onReplyWithTweet:(Tweet *)tweet;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Menu Button
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self
                                                                              action:@selector(onMenu)];
    
    NSArray *leftActionButtonItems = @[menuItem];
    self.navigationItem.leftBarButtonItems = leftActionButtonItems;
    
    // Setup Tweet Button
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                              target:self
                                                                              action:@selector(onCompose)];
    
    NSArray *rightActionButtonItems = @[composeItem];
    self.navigationItem.rightBarButtonItems = rightActionButtonItems;
    
    // Setup Title
    self.title = @"YTwitter";
    
    self.tweetsViewController = [[TweetsViewController alloc] init];
    [self.tweetsViewController.view setUserInteractionEnabled:YES];
    self.tweetsViewController.delegate = self;
    self.profileViewController = [[ProfileViewController alloc] init];
    [self.profileViewController.view setUserInteractionEnabled:YES];
    
    [self.view addSubview:self.tweetsViewController.view];
    [self.view addSubview:self.profileViewController.view];
    
    [self showTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)onMenu {
    [self.delegate onShowMenuCenterViewController:self];
}

- (void)onCompose {
    //Show User Tweet View Controller
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = nil;
    vc.text = @"What's happening?";
    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onReplyWithTweet:(Tweet *)tweet {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.delegate = self;
    composeViewController.tweet = tweet;
    composeViewController.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - TweetsViewControllerDelegate Methods
- (void)tweetsViewController:(TweetsViewController *)vc onUserProfile:(User *)user {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)tweetsViewController:(TweetsViewController *)vc onDetailsTweet:(Tweet *)tweet {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.tweet = tweet;
    detailViewController.delegate = self;
    [detailViewController.view setUserInteractionEnabled:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tweetsViewController:(TweetsViewController *)vc onReplyTweet:(Tweet *)tweet {
    [self onReplyWithTweet:tweet];
}

- (void)tweetsViewController:(TweetsViewController *)vc onRetweetTweet:(Tweet *)tweet {
    [tweet onRetweetTweetWithCompletion:^(Tweet *tweet, NSError *error) {
        [vc updateTable];
    }];
}

- (void)tweetsViewController:(TweetsViewController *)vc onFavoriteTweet:(Tweet *)tweet {
    [tweet onFavoriteTweetWithCompletion:^(Tweet *tweet, NSError *error) {
        [vc updateTable];
    }];
}

#pragma mark - DetailViewControllerDelegate Methods
- (void)didReply:(DetailViewController *)vc {
    [self onReplyWithTweet:vc.tweet];
}

- (void)didRetweet:(DetailViewController *)vc {
    [vc.tweet onRetweetTweetWithCompletion:^(Tweet *tweet, NSError *error) {
        [vc refreshUI];
    }];

}

- (void)didFavorite:(DetailViewController *)vc {
    [vc.tweet onFavoriteTweetWithCompletion:^(Tweet *tweet, NSError *error) {
        [vc refreshUI];
    }];
}

#pragma mark - ComposeViewControllerDelegate Methods
- (void)composeViewController:(ComposeViewController *)vc didComposeMessage:(NSString *)message {
    if (vc.tweet != nil) {
        [[TwitterClient sharedInstance]
         replyStatusWithIdStr:vc.tweet.idStr
         text:message
         completion:^(Tweet *tweet, NSError *error) {
             NSLog(@"OnReply Status: %@", tweet.description);
             [self.tweetsViewController pushTweetToTable:tweet];
         }];
    } else {
        [[TwitterClient sharedInstance]
         updateStatusWithText:message
         completion:^(Tweet *tweet, NSError *error) {
             NSLog(@"Just Tweeted: %@", tweet.description);
             [self.tweetsViewController pushTweetToTable:tweet];
         }];
    }
}


#pragma mark - Public Methods
- (void)showProfile {
    self.tweetsViewController.view.hidden = YES;
    self.profileViewController.view.hidden = NO;
}

- (void)showTweets {
    self.tweetsViewController.view.hidden = NO;
    self.profileViewController.view.hidden = YES;
}

- (void)updateHomeTimelineWithParams:(NSDictionary *)params {
    [self.tweetsViewController updateHomeTimelineWithParams:params];
}

- (void)updateMentionsTimelineWithParams:(NSDictionary *)params {
    [self.tweetsViewController updateMentionsTimelineWithParams:params];
}

- (void)setUser:(User *)user {
    [self.profileViewController setUser:user];
}

@end
