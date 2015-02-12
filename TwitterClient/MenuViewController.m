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

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Menu Item
    self.menu = @[@"User", @"Home Timeline", @"Mentions"];
    
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
        cell.titleLabel.text = self.menu[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
