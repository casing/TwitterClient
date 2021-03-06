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

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

// Button Icons
- (UIImage *)getFavoriteImageEnabled:(BOOL)enable;
- (UIImage *)getRetweetImageEnabled:(BOOL)enable;

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
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUI {
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.tweetTextLabel.text = self.tweet.text;
    self.createdAtLabel.text = [self.dateFormatter stringFromDate:self.tweet.createdAt];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    [self.favoriteButton setImage:[self getFavoriteImageEnabled:self.tweet.favorited] forState:UIControlStateNormal];
    [self.retweetButton setImage:[self getRetweetImageEnabled:self.tweet.retweeted] forState:UIControlStateNormal];
}

#pragma mark - Private Methods
- (UIImage *)getFavoriteImageEnabled:(BOOL)enable {
    if (enable) {
        return [UIImage imageNamed:@"favorite_orange_24.png"];
    } else {
        return [UIImage imageNamed:@"favorite_gray_24.png"];
    }
}

- (UIImage *)getRetweetImageEnabled:(BOOL)enable {
    if (enable) {
        return [UIImage imageNamed:@"retweet_green_24.png"];
    } else {
        return [UIImage imageNamed:@"retweet_gray_24.png"];
    }
}

#pragma mark - Action Methods
- (IBAction)onReply:(id)sender {
    [self.delegate didReply:self];
}

- (IBAction)onRetweet:(id)sender {
    [self.delegate didRetweet:self];
}

- (IBAction)onFavorite:(id)sender {
    [self.delegate didFavorite:self];
}

@end
