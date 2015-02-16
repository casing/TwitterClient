//
//  MainViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/11/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "MainViewController.h"
#import "TwitterNavigationController.h"
#import "MenuViewController.h"
#import "CenterViewController.h"

@interface MainViewController () <MenuViewControllerDelegate, CenterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) TwitterNavigationController *menuViewNavigationController;
@property (nonatomic, strong) TwitterNavigationController *centerNavigationController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) CenterViewController *centerViewController;
@property (nonatomic, assign) CGPoint mainViewCenter;
@property (nonatomic, assign) CGFloat panLimitX;
@property (nonatomic, assign) BOOL centerVisable;

- (void)showCenterView;
- (void)showMenuView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Menu View Controller
    self.menuViewController = [[MenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    // Setup Center View Controller
    self.centerViewController = [[CenterViewController alloc] init];
    self.centerViewController.delegate = self;
    
    // Setup Main Navigation Controllers
    self.menuViewNavigationController = [[TwitterNavigationController alloc] initWithRootViewController:self.menuViewController];
    self.centerNavigationController = [[TwitterNavigationController alloc] initWithRootViewController:self.centerViewController];
    
    // Setup up Main View
    self.mainView.frame = self.centerNavigationController.view.frame;
    [self.mainView addSubview:self.menuViewNavigationController.view];
    [self.mainView addSubview:self.centerNavigationController.view];
    
    // Setup the Pan limit, gives value of how much to pan the tweets view controller
    self.panLimitX = self.view.frame.size.width * 1.50;
    self.centerVisable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MenuViewControllerDelegate Methods
- (void)menuViewController:(MenuViewController *)vc didSelectMenuTitle:(NSString *)title {
    if ([title isEqualToString:@"User"]) {
        [self.centerViewController setUser:[User currentUser]];
        [self.centerViewController showProfile];
    } else if([title isEqualToString:@"Home Timeline"]) {
        [self.centerViewController updateHomeTimelineWithParams:nil];
        [self.centerViewController showTweets];
    } else if([title isEqualToString:@"Mentions"]) {
        [self.centerViewController updateMentionsTimelineWithParams:nil];
        [self.centerViewController showTweets];
    } else if([title isEqualToString:@"Log Out"]) {
        [User logout];
    }
    [self showCenterView];
}

#pragma mark - CenterViewControllerDelegate Methods
- (void)onShowMenuCenterViewController:(CenterViewController *)vc {
    if (self.centerVisable) {
        [self showMenuView];
    } else {
        [self showCenterView];
    }
}

#pragma mark - Gesture Methods
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.mainViewCenter = self.centerNavigationController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = self.mainViewCenter.x + translation.x;
        if (x >= self.panLimitX) {
            x = self.panLimitX;
        } else if (x <= self.view.center.x) {
            x = self.view.center.x;
        }
        self.centerNavigationController.view.center = CGPointMake(x, self.mainViewCenter.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (velocity.x > 0) {
            [self showMenuView];
        } else {
            [self showCenterView];
        }
    }

}
//
#pragma mark - Private Methods
- (void)showCenterView {
    [UIView animateWithDuration:0.2 animations:^{
        self.centerNavigationController.view.center = self.mainView.center;
        self.centerVisable = YES;
    }];
}

- (void)showMenuView {
    [UIView animateWithDuration:0.2 animations:^{
        self.centerNavigationController.view.center = CGPointMake(self.panLimitX, self.mainView.center.y);
        self.centerVisable = NO;
    }];
}

@end
