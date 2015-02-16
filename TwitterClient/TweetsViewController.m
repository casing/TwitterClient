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
#import "DetailViewController.h"
#import "TwitterNavigationController.h"

NSString * const kTweetCell = @"TweetCell";

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onTableRefresh;
//- (void)onReplyTweet:(Tweet *)tweet;
//- (void)onRetweetTweet:(Tweet *)inTweet;
//- (void)onFavoriteTweet:(Tweet *)inTweet;

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
    
    [self updateHomeTimelineWithParams:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - ComposeViewControllerDelegate Methods
//- (void)composeViewController:(ComposeViewController *)vc didComposeMessage:(NSString *)message {
//    if (vc.tweet != nil) {
//        [[TwitterClient sharedInstance]
//         replyStatusWithIdStr:vc.tweet.idStr
//         text:message
//         completion:^(Tweet *tweet, NSError *error) {
//            NSLog(@"OnReply Status: %@", tweet.description);
//            if (tweet != nil) {
//                [self.tweets insertObject:tweet atIndex:0]; //Insert at the beginning of array
//                [self.tableView reloadData];
//            }
//        }];
//    } else {
//        [[TwitterClient sharedInstance]
//         updateStatusWithText:message
//         completion:^(Tweet *tweet, NSError *error) {
//             NSLog(@"Just Tweeted: %@", tweet.description);
//             if (tweet != nil) {
//                 [self.tweets insertObject:tweet atIndex:0]; //Insert at the beginning of array
//                 [self.tableView reloadData];
//             }
//         }];
//    }
//}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Tweet *tweet = self.tweets[indexPath.row];
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTweetCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.tweet = tweet;
    cell.index = (int)indexPath.row;
    
    if (indexPath.row == self.tweets.count - 1) {
        NSInteger id = [tweet.idStr integerValue];
        id = id + 1;
        NSString *maxIdStr = [NSString stringWithFormat:@"%ld", id];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:maxIdStr forKey:@"max_id"];
        [self updateHomeTimelineWithParams:params];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate tweetsViewController:self onDetailsTweet:self.tweets[indexPath.row]];
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
    [self updateHomeTimelineWithParams:nil];
}

#pragma mark - TweetCellDelegate Methods
- (void)didReplyTweetCell:(TweetCell *)cell {
    [self.delegate tweetsViewController:self onReplyTweet:cell.tweet];
}

- (void)didRetweetTweetCell:(TweetCell *)cell {
    [self.delegate tweetsViewController:self onRetweetTweet:cell.tweet];
}

- (void)didFavoriteTweetCell:(TweetCell *)cell {
    [self.delegate tweetsViewController:self onFavoriteTweet:cell.tweet];
}

- (void)didTapProfileTweetCell:(TweetCell *)cell {
    [self.delegate tweetsViewController:self onUserProfile:cell.tweet.user];
}

#pragma mark - Public Methods
- (void)updateHomeTimelineWithParams:(NSDictionary *)params {
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        if (params == nil) {
            [self.tweets removeAllObjects];
        }
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        [self.tableRefreshControl endRefreshing];
    }];
}

- (void)updateMentionsTimelineWithParams:(NSDictionary *)params {
    
    [[TwitterClient sharedInstance] mentionsTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        if (params == nil) {
            [self.tweets removeAllObjects];
        }
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        [self.tableRefreshControl endRefreshing];
    }];
}

- (void)pushTweetToTable:(Tweet *)tweet {
    if (tweet != nil) {
        [self.tweets insertObject:tweet atIndex:0]; //Insert at the beginning of array
        [self.tableView reloadData];
    }
}

- (void)updateTable {
    [self.tableView reloadData];
}

#pragma mark - Private Methods
//- (void)onReplyTweet:(Tweet *)tweet {
//    ComposeViewController *vc = [[ComposeViewController alloc] init];
//    vc.delegate = self;
//    vc.tweet = tweet;
//    vc.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
//    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];
//}

//- (void)onRetweetTweet:(Tweet *)inTweet {
//    
//    if (inTweet.retweeted) {
//        
//        // Search User time line for retweeted idStr
//        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//        [params setValue:[User currentUser].screenName forKey:@"screen_name"];
//        [params setValue:inTweet.idStr forKey:@"since_id"];
//        [[TwitterClient sharedInstance]
//         userTimelineWithParams:params
//         completion:^(NSArray *tweets, NSError *error) {
//             for (Tweet *tweet in tweets) {
//                 if ([tweet.retweetedStatusIdStr isEqualToString:inTweet.idStr]) {
//                     NSLog(@"Found Retweeted Tweet: %@", tweet.description);
//                     [[TwitterClient sharedInstance] destroyStatusWithIdString:tweet.idStr completion:^(Tweet *tweet, NSError *error) {
//                         if (tweet != nil) {
//                             [inTweet setRetweeted:NO];
//                             [inTweet setRetweetCount:[inTweet retweetCount] - 1];
//                             [self.tableView reloadData];
//                             
//                             if (self.detailViewController != nil) {
//                                 [self.detailViewController refreshUI];
//                             }
//                         }
//                         NSLog(@"Destroy Retweet Status: %@", tweet.description);
//                     }];
//                     break;
//                 }
//             }
//        }];
//        
//    } else {
//        [[TwitterClient sharedInstance]
//         retweetStatusWithIdString:inTweet.idStr
//         completion:^(Tweet *tweet, NSError *error) {
//             if (tweet != nil) {
//                 [inTweet setRetweeted:YES];
//                 [inTweet setRetweetCount:[inTweet retweetCount] + 1];
//                 [self.tableView reloadData];
//                 
//                 if (self.detailViewController != nil) {
//                     [self.detailViewController refreshUI];
//                 }
//             }
//             NSLog(@"Retweet Status: %@", tweet.description);
//         }];
//    }
//}

//- (void)onFavoriteTweet:(Tweet *)inTweet{
//    
//    if (inTweet.favorited) {
//        [[TwitterClient sharedInstance]
//         unFavoriteStatusWithIdString:inTweet.idStr
//         completion:^(Tweet *tweet, NSError *error) {
//             if (tweet != nil) {
//                 [inTweet setFavorited:NO];
//                 [inTweet setFavoriteCount:[inTweet favoriteCount] - 1];
//                 
//                 [self.tableView reloadData];
//                 
//                 if (self.detailViewController != nil) {
//                     [self.detailViewController refreshUI];
//                 }
//             }
//             NSLog(@"Unfavorite Tweet: %@", tweet.description);
//         }];
//    } else {
//        [[TwitterClient sharedInstance]
//         favoriteStatusWithIdString:inTweet.idStr
//         completion:^(Tweet *tweet, NSError *error) {
//             if (tweet != nil) {
//                 [inTweet setFavorited:YES];
//                 [inTweet setFavoriteCount:[inTweet favoriteCount] + 1];
//                 [self.tableView reloadData];
//                 
//                 if (self.detailViewController != nil) {
//                     [self.detailViewController refreshUI];
//                 }
//             }
//             NSLog(@"Favorite Tweet: %@", tweet.description);
//         }];
//    }
//}

@end
