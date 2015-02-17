//
//  AccountsViewController.m
//  TwitterClient
//
//  Created by Casing Chu on 2/17/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "AccountsViewController.h"
#import "MenuUserCell.h"

@interface AccountsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userAccounts;

@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userAccounts = [[NSMutableArray alloc] init];
    
    self.title = @"Accounts";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuUserCell" bundle:nil] forCellReuseIdentifier:@"MenuUserCell"];
    
    // Initialize Accounts
    self.userAccounts = [[NSMutableArray alloc] init];
    [self.userAccounts addObject:[User currentUser]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuUserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuUserCell"];
    cell.user = self.userAccounts[indexPath.row];
    return cell;
}

@end
