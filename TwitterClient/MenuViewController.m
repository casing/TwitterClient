//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/10/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "MenuUserCell.h"

NSString * const kMenuItemCell = @"MenuItemCell";
NSString * const kMenuUserCell = @"MenuUserCell";


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menu;

- (UIImage *)getMenuItemIconFromTitle:(NSString *)title;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Menu Item
    self.menu = @[@"User", @"Home Timeline", @"Mentions", @"Log Out"];
    
    // Initialize TableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kMenuItemCell bundle:nil] forCellReuseIdentifier:kMenuItemCell];
    [self.tableView registerNib:[UINib nibWithNibName:kMenuUserCell bundle:nil] forCellReuseIdentifier:kMenuUserCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MenuUserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMenuUserCell];
        cell.user = [User currentUser];
        return cell;
    } else {
        MenuItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMenuItemCell];
        NSString *title = self.menu[indexPath.row];
        cell.titleLabel.text = title;
        [cell.iconImageView setImage:[self getMenuItemIconFromTitle:title]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate menuViewController:self didSelectMenuTitle:self.menu[indexPath.row]];
}

#pragma mark - Private Methods
- (UIImage *)getMenuItemIconFromTitle:(NSString *)title {
    if ([title isEqualToString:@"Home Timeline"]) {
        return [UIImage imageNamed:@"home_gray_24.png"];
    } else if ([title isEqualToString:@"Mentions"]) {
        return [UIImage imageNamed:@"email_gray_24.png"];
    } else if ([title isEqual:@"Log Out"]) {
        return [UIImage imageNamed:@"logout_gray_24.png"];
    }
    return nil;
}

@end
