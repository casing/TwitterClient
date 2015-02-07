//
//  TweetCell.m
//  TwitterClient
//
//  Created by Casing Chu on 2/4/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "TwitterNavigationController.h"
#import "ComposeViewController.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

- (NSString *)getCreatedDateLabel;

- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
    
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.tweetTextLabel.text = tweet.text;
    self.createdLabel.text = [self getCreatedDateLabel];
}

#pragma mark - ComposeViewControllerDelegate - Methods
- (void)composeViewController:(ComposeViewController *)composeViewController didComposeMessage:(NSString *)message {
    
}

#pragma mark - Private Methods
- (NSString *)getCreatedDateLabel {
    NSDate *current = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components =
    [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                fromDate:self.tweet.createdAt
                  toDate:current
                 options:0];
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ldY", components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ldM", components.month];
    } else if (components.day > 0) {
        return [NSString stringWithFormat:@"%ldD", components.day];
    } else if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ldh", components.hour];
    } else if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ldm", components.minute];
    } else {
        return [NSString stringWithFormat:@"%lds", components.second];
    }
}

- (IBAction)onReply:(id)sender {
    [self.delegate didReplyTweetCell:self];
}

- (IBAction)onRetweet:(id)sender {
    [self.delegate didRetweetTweetCell:self];
}

- (IBAction)onFavorite:(id)sender {
    [self.delegate didFavoriteTweetCell:self];
}

@end
