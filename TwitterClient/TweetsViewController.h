//
//  TweetsViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/4/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"

@interface TweetsViewController : UIViewController <ComposeViewControllerDelegate>

- (void)updateHomeTimelineWithParams:(NSDictionary *)params;
- (void)updateMentionsTimelineWithParams:(NSDictionary *)params;

@end
