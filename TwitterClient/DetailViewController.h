//
//  DetailViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)didReply:(DetailViewController *)vc;
- (void)didRetweet:(DetailViewController *)vc;
- (void)didFavorite:(DetailViewController *)vc;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, assign) int index;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak)id<DetailViewControllerDelegate> delegate;

- (void)refreshUI;

@end
