//
//  DetailViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "TwitterNavigationController.h"

@interface DetailViewController () <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

// Button Actions
- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    
    // Initialize Date Formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    
    // Set up UI
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.tweetTextLabel.text = self.tweet.text;
    self.createdAtLabel.text = [self.dateFormatter stringFromDate:self.tweet.createdAt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ControllerViewController Delegate Methods
- (void)composeViewController:(ComposeViewController *)composeViewController didComposeMessage:(NSString *)message {
    [[TwitterClient sharedInstance] directMessageWithText:self.tweet.idStr screenName:self.tweet.user.screenName completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"OnReply Status: %@", tweet.description);
    }];
}

#pragma mark - Action Methods
- (IBAction)onReply:(id)sender {
    //Show User Tweet View Controller
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    [[TwitterClient sharedInstance] retweetStatusWithIdString:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Retweet Status: %@", tweet.description);
    }];
}

- (IBAction)onFavorite:(id)sender {
    [[TwitterClient sharedInstance] favoriteStatusWithIdString:self.tweet.idStr completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Favorite Tweet: %@", tweet.description);
    }];
}

@end
