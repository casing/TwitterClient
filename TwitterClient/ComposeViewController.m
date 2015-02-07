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
    // Setup tweet Text Label
    self.tweetTextLabel.text = self.text;
    
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
    [self.delegate composeViewController:self didComposeMessage:self.tweetTextLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
