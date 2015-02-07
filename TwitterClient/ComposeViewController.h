//
//  ComposeViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

- (void)composeViewController:(ComposeViewController *)composeViewController didComposeMessage:(NSString *)message;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *text;

@end
