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
#import "TwitterNavigationController.h"
#import "User.h"

@interface CenterViewController ()

@property (nonatomic, strong)TweetsViewController *tweetsViewController;
@property (nonatomic, strong)ProfileViewController *profileViewController;

- (void)onLogout;
- (void)onCompose;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.tweetsViewController = [[TweetsViewController alloc] init];
    self.profileViewController = [[ProfileViewController alloc] init];
    
    [self.view addSubview:self.tweetsViewController.view];
    [self.view addSubview:self.profileViewController.view];
    
    [self showTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)onLogout {
    [User logout];
}

- (void)onCompose {
    //Show User Tweet View Controller
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self.tweetsViewController;
    vc.tweet = nil;
    vc.text = @"What's happening?";
    TwitterNavigationController *nvc = [[TwitterNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
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
