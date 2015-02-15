//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "TwitterClient.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)updateUIView;
- (void)updateUserTimeline;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup properties
    self.tweets = [[NSMutableArray alloc] init];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self updateUIView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self updateUIView];
}

#pragma mark - Private Methods
- (void)updateUIView {
    
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    self.descriptionLabel.text = self.user.tagLine;
    self.locationLabel.text = self.user.location;
    self.followersNumberLabel.text = [NSString stringWithFormat:@"%ld", self.user.followersCount];
    self.followingNumberLabel.text = [NSString stringWithFormat:@"%ld", self.user.friendsCount];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:self.user.backgroundImageUrl]];
    [self updateUserTimeline];
}

- (void)updateUserTimeline {
    [[TwitterClient sharedInstance]userTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

@end
