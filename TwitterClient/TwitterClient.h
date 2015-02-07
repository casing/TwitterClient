//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openUrl:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)updateStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetStatusWithIdString:(NSString *)id_str completion:(void(^)(Tweet *tweet, NSError *error))completion;
- (void)directMessageWithText:(NSString *)text screenName:(NSString *)screenName completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteStatusWithIdString:(NSString *)id_str completion:(void(^)(Tweet *tweet, NSError *error))completion;
- (void)unFavoriteStatusWithIdString:(NSString *)id_str completion:(void(^)(Tweet *tweet, NSError *error))completion;

@end
