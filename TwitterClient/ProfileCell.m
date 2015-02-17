//
//  ProfileCell.m
//  TwitterClient
//
//  Created by Casing Chu on 2/16/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+HexString.h"

@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

- (void)updateUIView;
- (void)setTextColor:(UIColor *)color;

@end

@implementation ProfileCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self updateUIView];
}

#pragma mark - Private Methods
- (void)updateUIView {
    
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    self.descriptionLabel.text = self.user.tagLine;
    self.locationLabel.text = self.user.location;
    self.followersNumberLabel.text = [NSString stringWithFormat:@"%ld", self.user.followersCount];
    self.followingNumberLabel.text = [NSString stringWithFormat:@"%ld", self.user.friendsCount];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    if (self.user.profileBannerImageUrl != nil) {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:self.user.profileBannerImageUrl]];
    } else {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
    }
    [self setBackgroundColor:[UIColor colorFromHexString:self.user.profileBackgroundColor withAlpha:1.0]];
    [self setTextColor:[UIColor colorFromHexString:self.user.profileTextColor withAlpha:1.0]];
}

- (void)setTextColor:(UIColor *)color {
    self.nameLabel.textColor = color;
    self.screenNameLabel.textColor = color;
    self.descriptionLabel.textColor = color;
    self.locationLabel.textColor = color;
    self.followersNumberLabel.textColor = color;
    self.followingNumberLabel.textColor = color;
    self.followingLabel.textColor = color;
    self.followersLabel.textColor = color;
}

@end
