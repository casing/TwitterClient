//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Casing Chu on 2/10/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void)menuViewController:(MenuViewController *)vc didSelectMenuTitle:(NSString *)title;

@end

@interface MenuViewController : UIViewController

@property (nonatomic,weak) id<MenuViewControllerDelegate> delegate;

@end
