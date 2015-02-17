//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

- (void)profileViewController:(ProfileViewController *)view onAccountsCurrentUser:(User *)currentUser;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic,weak) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic,strong) User* user;

@end
