//
//  Tweet.m
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

#pragma mark - Private Methods
- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        self.text = dictionary[@"text"];
        self.idStr = dictionary[@"id_str"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.favoriteCount = [[dictionary objectForKey:@"favorite_count"] integerValue];
        self.retweetCount = [[dictionary objectForKey:@"retweet_count"] integerValue];
        self.favorited = [[dictionary objectForKey:@"favorited"] boolValue];
        self.retweeted = [[dictionary objectForKey:@"retweeted"] boolValue];
        self.retweetedStatusIdStr = [dictionary valueForKeyPath:@"retweeted_status.id_str"];
    }
    
    return self;
}

- (NSString *)description {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:self.text];
    [array addObject:self.user.screenName];
    
    [array addObject:[NSString stringWithFormat:@"favorited=%d", self.favorited]];
    [array addObject:[NSString stringWithFormat:@"favorite_count=%ld", self.favoriteCount]];
    
    [array addObject:[NSString stringWithFormat:@"retweeted=%d", self.retweeted]];
    [array addObject:[NSString stringWithFormat:@"retweet_count=%ld", self.retweetCount]];
    
    [array addObject:[NSString stringWithFormat:@"id_str=%@", self.idStr]];
    [array addObject:[NSString stringWithFormat:@"retweeted_status.id_str=%@", self.retweetedStatusIdStr]];
    
    return [array componentsJoinedByString:@", "];
}

- (void)onFavoriteTweetWithCompletion:(void(^)(Tweet *tweet, NSError *error))completion {
    if (self.favorited) {
        [[TwitterClient sharedInstance]
         unFavoriteStatusWithIdString:self.idStr
         completion:^(Tweet *tweet, NSError *error) {
             if (tweet != nil) {
                 self.favorited = NO;
                 self.favoriteCount--;
                 completion(tweet, error);
                 NSLog(@"Unfavorite Tweet: %@", tweet.description);
             } else {
                 NSLog(@"%@", error);
             }
         }];
    } else {
        [[TwitterClient sharedInstance]
         favoriteStatusWithIdString:self.idStr
         completion:^(Tweet *tweet, NSError *error) {
             if (tweet != nil) {
                 self.favorited = YES;
                 self.favoriteCount++;
                 completion(tweet, error);
                 NSLog(@"Favorite Tweet: %@", tweet.description);
             } else {
                 NSLog(@"%@", error);
             }
         }];
    }
}

- (void)onRetweetTweetWithCompletion:(void(^)(Tweet *tweet, NSError *error))completion {
    if (self.retweeted) {
        // Search User time line for retweeted idStr
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[User currentUser].screenName forKey:@"screen_name"];
        [params setValue:self.idStr forKey:@"since_id"];
        [[TwitterClient sharedInstance]
         userTimelineWithParams:params
         completion:^(NSArray *tweets, NSError *error) {
             for (Tweet *tweet in tweets) {
                 if ([tweet.retweetedStatusIdStr isEqualToString:self.idStr]) {
                     NSLog(@"Found Retweeted Tweet: %@", tweet.description);
                     [[TwitterClient sharedInstance] destroyStatusWithIdString:tweet.idStr completion:^(Tweet *tweet, NSError *error) {
                         if (tweet != nil) {
                             self.retweeted = NO;
                             self.retweetCount--;
                             completion(tweet, error);
                         }
                         NSLog(@"Destroy Retweet Status: %@", tweet.description);
                     }];
                     break;
                 }
             }
         }];
        
    } else {
        [[TwitterClient sharedInstance]
         retweetStatusWithIdString:self.idStr
         completion:^(Tweet *tweet, NSError *error) {
             if (tweet != nil) {
                 self.retweeted = YES;
                 self.retweetCount++;
                 completion(tweet, error);
                 NSLog(@"Retweet Status: %@", tweet.description);
             } else {
                 NSLog(@"%@", error);
             }
         }];
    }

}

#pragma mark - Class Methods

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
