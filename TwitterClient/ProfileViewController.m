//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "ProfileCell.h"
#import "TwitterClient.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

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
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
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
    
    [self updateUserTimeline];
    [self.tableView reloadData];
}

- (void)updateUserTimeline {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.user.screenName forKey:@"screen_name"];
    [[TwitterClient sharedInstance]userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;//Profile Cell is only 1 row
        case 1:
            return self.tweets.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"Tweets";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.user = self.user;
        return cell;
    } else if(indexPath.section == 1) {
        TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        cell.tweet = self.tweets[indexPath.row];
        return cell;
    }
    return nil;
}

@end
