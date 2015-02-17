//
//  ProfileCell.h
//  TwitterClient
//
//  Created by Casing Chu on 2/16/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ProfileCell;

@protocol ProfileCellDelegate <NSObject>

- (void)profileCell:(ProfileCell *)cell withLongPressGestureRecognizer:(UILongPressGestureRecognizer *)sender;

@end

@interface ProfileCell : UITableViewCell

@property (nonatomic,strong) User* user;
@property (nonatomic,weak) id<ProfileCellDelegate> delegate;

@end
