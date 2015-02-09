//
//  Tweet.m
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

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

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
