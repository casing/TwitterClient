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
    }
    
    return self;
}

- (NSString *)description {
    NSString *print =
    [NSString stringWithFormat:@"%@, %@, favourite_count=%ld, retweet_count=%ld, favorited=%d, retweeted=%d",
     self.text,self.user.screenName, self.favoriteCount, self.retweetCount, self.favorited, self.retweeted];
    return print;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
