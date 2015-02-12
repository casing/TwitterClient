//
//  MenuUserCell.m
//  TwitterClient
//
//  Created by Casing Chu on 2/10/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "MenuUserCell.h"
#import "UIImageView+AFNetworking.h"

@interface MenuUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end

@implementation MenuUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",user.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
}

@end
