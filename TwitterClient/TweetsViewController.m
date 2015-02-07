//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/4/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "TwitterNavigationController.h"

NSString * const kTweetCell = @"TweetCell";

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate,
ComposeViewControllerDelegate, TweetCellDelegate, DetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

- (void)updateTweets;
- (void)onLogout;
- (void)onTableRefresh;
- (void)onCompose;
- (void)onReplyTweet:(Tweet *)tweet;
- (void)onRetweetTweet:(Tweet *)tweet;
- (void)onFavoriteTweet:(Tweet *)tweet;
- (void)goToDetailsPage:(int)index;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize Tweet Array
    self.tweets = [[NSMutableArray alloc] init];
    
    // Table Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kTweetCell bundle:nil] forCellReuseIdentifier:kTweetCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Setup Title
    self.title = @"YTwitter";
    
    // Setup Logout Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onLogout)];
    
    // Setup Tweet Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCompose)];
    
    [self updateTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ComposeViewControllerDelegate Methods
- (void)composeViewController:(ComposeViewController *)composeViewController didComposeMessage:(NSString *)message {
    if (composeViewController.tweet != nil) {
        [[TwitterClient sharedInstance]
         directMessageWithText:composeViewController.tweet.idStr
         screenName:composeViewController.tweet.user.screenName
         completion:^(Tweet *tweet, NSError *error) {
             NSLog(@"OnReply Status: %@", tweet.description);
             if (tweet != nil) {
                 [self.tweets insertObject:tweet atIndex:0]; //Insert at the beginning of array
                 [self.tableView reloadData];
             }
        }];
    } else {
        [[TwitterClient sharedInstance]
         updateStatusWithText:message
         completion:^(Tweet *tweet, NSError *error) {
             NSLog(@"Just Tweeted: %@", tweet.description);
             if (tweet != nil) {
                 [self.tweets insertObject:tweet atIndex:0]; //Insert at the beginning of array
                 [self.tableView reloadData];
             }
         }];
    }
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTweetCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToDetailsPage:(int)indexPath.row];
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
    
    [self updateTweets];
}

#pragma mark - DetailViewControllerDelegate Methods
- (void)didReply:(DetailViewController *)vc {
    [self onReplyTweet:vc.tweet];
}

- (void)didRetweet:(DetailViewController *)vc {
    [self onRetweetTweet:vc.tweet];
}

- (void)didFavorite:(DetailViewController *)vc {
    [self onFavoriteTweet:vc.tweet];
}

#pragma mark - TweetCellDelegate Methods
- (void)didReplyTweetCell:(TweetCell *)cell {
    [self onReplyTweet:cell.tweet];
}

- (void)didRetweetTweetCell:(TweetCell *)cell {
    [self onRetweetTweet:cell.tweet];
}

- (void)didFavoriteTweetCell:(TweetCell *)cell {
    [self onFavoriteTweet:cell.tweet];
}

#pragma mark - Private Methods
- (void)updateTweets {
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        [self.tableRefreshControl endRefreshing];
    }];
}

- (void)onLogout {
    [User logout];
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

- (void)onReplyTweet:(Tweet *)tweet {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = tweet;
    vc.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRetweetTweet:(Tweet *)tweet {
    [[TwitterClient sharedInstance] retweetStatusWithIdString:tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Retweet Status: %@", tweet.description);
    }];
}

- (void)onFavoriteTweet:(Tweet *)tweet {
    [[TwitterClient sharedInstance] favoriteStatusWithIdString:tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Favorite Tweet: %@", tweet.description);
    }];
}

- (void)goToDetailsPage:(int)index {
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.tweet = self.tweets[index];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
