//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"5ujGW6puP0gWOVSDJ4bvSyYEj";
NSString * const kTwitterConsumerSecret = @"w2JLdrXKrPvgdhrOxJ4NqeXDOcGOWVyseVMepDhN8NTIhZDL1N";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";
NSString * const kHomeTimelineKey = @"home_timeline";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc]
                        initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                            consumerKey:kTwitterConsumerKey
                        consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET"
                        callbackURL:[NSURL URLWithString:@"ytwitterdemo://oauth"] scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSLog(@"Got the Request Token");
                                
                                NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                [[UIApplication sharedApplication] openURL:authUrl];
                                
                            } failure:^(NSError *error) {
                                self.loginCompletion(nil, error);
                            }];
}

- (void)openUrl:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST"
        requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
        success:^(BDBOAuth1Credential *accessToken) {
            NSLog(@"Got Access Token");
            [self.requestSerializer saveAccessToken:accessToken];
                                                         
            [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    User *user = [[User alloc] initWithDictionary:responseObject];
                    [User setCurrentUser:user];
                    self.loginCompletion(user, nil);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Failed to get access credentials");
                    self.loginCompletion(nil, error);
                }];
                                                         
        } failure:^(NSError *error) {
            NSLog(@"Failed to get Access Token");
            self.loginCompletion(nil, error);
        }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
        // Store responseObject
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kHomeTimelineKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Try to get UserDefaults if No Network
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kHomeTimelineKey];
        if (data != nil) {
            NSLog(@"Retreived Tweets from NSUserDefaults");
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSArray *tweets = [Tweet tweetsWithArray:array];
            completion(tweets, error);
        } else {
            completion(nil, error);
        }
    }];
}

@end
