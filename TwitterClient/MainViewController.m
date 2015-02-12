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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) TwitterNavigationController *menuViewController;
@property (nonatomic, strong) TwitterNavigationController *tweetsViewController;
@property (nonatomic, assign) CGPoint mainViewCenter;
@property (nonatomic, assign) CGFloat panLimitX;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuViewController = [[TwitterNavigationController alloc] initWithRootViewController:[[MenuViewController alloc] init]];
    self.tweetsViewController = [[TwitterNavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    
    self.mainView.frame = self.tweetsViewController.view.frame;
    [self.mainView addSubview:self.menuViewController.view];
    [self.mainView addSubview:self.tweetsViewController.view];
    
    self.panLimitX = self.view.frame.size.width * 1.50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.mainViewCenter = self.tweetsViewController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = self.mainViewCenter.x + translation.x;
        if (x >= self.panLimitX) {
            x = self.panLimitX;
        } else if (x <= self.view.center.x) {
            x = self.view.center.x;
        }
        self.tweetsViewController.view.center = CGPointMake(x, self.mainViewCenter.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (velocity.x > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.tweetsViewController.view.center = CGPointMake(self.panLimitX, self.mainViewCenter.y);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.tweetsViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y);
            }];
        }
    }

}
@end
