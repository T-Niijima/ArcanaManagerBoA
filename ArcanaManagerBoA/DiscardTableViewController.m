//
//  DiscardTableViewController.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "DiscardTableViewController.h"
#import "Discard.h"

@interface DiscardTableViewController ()

@end

@implementation DiscardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"捨て札";
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TableBG"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Discard shared] getDiscardList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Arcana* arcanaForCell = [[Discard shared] getDiscardList][indexPath.row];
    
    NSDictionary* dic = [arcanaForCell getArcanaText];
    
    [cell.textLabel setText:dic[@"arcana"]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
