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
#import "TweetsViewController.h"

@interface MainViewController () <MenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) TwitterNavigationController *menuViewNavigationController;
@property (nonatomic, strong) TwitterNavigationController *tweetsNavigationViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) TweetsViewController *tweetsViewController;
@property (nonatomic, assign) CGPoint mainViewCenter;
@property (nonatomic, assign) CGFloat panLimitX;

- (void)showTweetsView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Menu View Controller
    self.menuViewController = [[MenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    // Setup Tweets View Controller
    self.tweetsViewController = [[TweetsViewController alloc] init];
    
    // Setup Main Navigation Controllers
    self.menuViewNavigationController = [[TwitterNavigationController alloc] initWithRootViewController:self.menuViewController];
    self.tweetsNavigationViewController = [[TwitterNavigationController alloc] initWithRootViewController:self.tweetsViewController];
    
    // Setup up Main View
    self.mainView.frame = self.tweetsNavigationViewController.view.frame;
    [self.mainView addSubview:self.menuViewNavigationController.view];
    [self.mainView addSubview:self.tweetsNavigationViewController.view];
    
    // Setup the Pan limit, gives value of how much to pan the tweets view controller
    self.panLimitX = self.view.frame.size.width * 1.50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MenuViewControllerDelegate Methods
- (void)menuViewController:(MenuViewController *)vc didSelectMenuTitle:(NSString *)title {
    if ([title isEqualToString:@"User"]) {
        
    } else if([title isEqualToString:@"Home Timeline"]) {
        [self.tweetsViewController updateHomeTimelineWithParams:nil];
        [self showTweetsView];
    } else if([title isEqualToString:@"Mentions"]) {
        [self.tweetsViewController updateMentionsTimelineWithParams:nil];
        [self showTweetsView];
    }
}

#pragma mark - Gesture Methods
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.mainViewCenter = self.tweetsNavigationViewController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = self.mainViewCenter.x + translation.x;
        if (x >= self.panLimitX) {
            x = self.panLimitX;
        } else if (x <= self.view.center.x) {
            x = self.view.center.x;
        }
        self.tweetsNavigationViewController.view.center = CGPointMake(x, self.mainViewCenter.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (velocity.x > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.tweetsNavigationViewController.view.center = CGPointMake(self.panLimitX, self.mainViewCenter.y);
            }];
        } else {
            [self showTweetsView];
        }
    }

}

#pragma mark - Private Methods
- (void)showTweetsView {
    [UIView animateWithDuration:0.2 animations:^{
        self.tweetsNavigationViewController.view.center = self.mainView.center;
    }];
}

@end
