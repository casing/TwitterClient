//
//  TweetCell.h
//  TwitterClient
//
//  Created by Casing Chu on 2/4/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)didReplyTweetCell:(TweetCell *)cell;
- (void)didRetweetTweetCell:(TweetCell *)cell;
- (void)didFavoriteTweetCell:(TweetCell *)cell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, assign) int index;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak)id<TweetCellDelegate> delegate;

@end
