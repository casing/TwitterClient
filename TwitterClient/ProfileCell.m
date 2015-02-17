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

@interface ProfileCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) BOOL pageControlBeingUsed;
@property (nonatomic, strong) NSMutableArray *views;

- (void)updateUIView;
- (void)setTextColor:(UIColor *)color;
- (void)setupScrollView;
- (IBAction)changePage:(UIPageControl *)sender;
- (IBAction)onLongPressHeader:(UILongPressGestureRecognizer *)sender;

@end

@implementation ProfileCell

- (void)awakeFromNib {
    self.views = [[NSMutableArray alloc] init];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.scrollView.delegate = self;
    self.pageControlBeingUsed = NO;
    [self.scrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressHeader:)]];
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
    self.tweetsNumberLabel.text = [NSString stringWithFormat:@"%ld", self.user.tweetsCount];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self setupScrollView];
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
    self.tweetsNumberLabel.textColor = color;
    self.tweetsLabel.textColor = color;
}

- (void)setupScrollView {
    [self.views removeAllObjects];
    
    if (self.user.profileBannerImageUrl != nil) {
        UIImageView *bannerImageView = [[UIImageView alloc] init];
        bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [bannerImageView setImageWithURL:[NSURL URLWithString:self.user.profileBannerImageUrl]];
        [self.views addObject:bannerImageView];
    }
    
    if (self.user.profileBackgroundImageUrl != nil) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
        [self.views addObject:backgroundImageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.views.count, self.scrollView.frame.size.height);
    
    // Add Views to Scroll View
    for (UIImageView *view in self.views) {
        view.frame = self.scrollView.frame;
        view.center = self.scrollView.center;
        [self.scrollView addSubview:view];
    }
    
}

- (IBAction)changePage:(UIPageControl *)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed = YES;
}

- (IBAction)onLongPressHeader:(UILongPressGestureRecognizer *)sender {
    [self.delegate profileCell:self withLongPressGestureRecognizer:sender];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Control opacity of scroll view
    CGFloat percent = ((int)(self.scrollView.contentOffset.x) % (int)(self.scrollView.frame.size.width)) / self.scrollView.frame.size.width;
    if (percent > 0.0 && percent < 1.0) { // Of course, you can specify your own range of alpha values
        UIImageView *view = self.views[self.pageControl.currentPage];
        view.alpha = percent;
        NSLog(@"ImageView Alpha: %f", percent);
    }
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"ScrollView Begin Dragging");
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView End Decelerating");
    self.pageControlBeingUsed = NO;
}

@end
