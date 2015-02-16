//
//  Tweet.h
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSString *retweetedStatusIdStr;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)onFavoriteTweetWithCompletion:(void(^)(Tweet *tweet, NSError *error))completion;
- (void)onRetweetTweetWithCompletion:(void(^)(Tweet *tweet, NSError *error))completion;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
