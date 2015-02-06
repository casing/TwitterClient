//
//  ComposeViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (void)onCancelButton;
- (void)onTweetButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    
    // Setup Image View
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    
    // Setup the User profile
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    // Navigation Setup
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTweetButton)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    [[TwitterClient sharedInstance]
     updateStatusWithText:self.tweetTextLabel.text
     completion:^(Tweet *tweet, NSError *error) {
         NSLog(@"Just Tweeted: %@", tweet.text);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
