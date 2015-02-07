//
//  TwitterNavigationController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/6/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TwitterNavigationController.h"

@interface TwitterNavigationController ()

@end

@implementation TwitterNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithRed:58.0/255 green:200.0/255 blue:254.0/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
