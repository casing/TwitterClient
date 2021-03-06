//
//  User.h
//  TwitterClient
//
//  Created by Casing Chu on 2/3/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger tweetsCount;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, strong) NSString *profileBannerImageUrl;
@property (nonatomic, strong) NSString *profileTextColor;
@property (nonatomic, strong) NSString *profileBackgroundColor;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)logout;

@end
