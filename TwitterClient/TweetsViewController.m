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

NSString * const kTweetCell = @"TweetCell";

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onTableRefresh;

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

@end
