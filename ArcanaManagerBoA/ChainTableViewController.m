//
//  ChainTableViewController.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "ChainTableViewController.h"
#import "Chain.h"
#import "SoundManager.h"

@import SCLAlertView_Objective_C;

@interface ChainTableViewController () {
    NSMutableSet<Arcana*>* setSelectedArcana;   // 選択されているアルカナ
}

@end

@implementation ChainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"返す鎖の選択";
    
    setSelectedArcana = [NSMutableSet set];
    
    // --- 返却用のボタンを設定
    UIBarButtonItem* btnReturn = [[UIBarButtonItem alloc] initWithTitle:@"返却する"
                                                                  style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(tapBtnReturn:)];
    [[self navigationItem] setRightBarButtonItem:btnReturn];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TableBG"]];
    
    [btnReturn setEnabled:NO];  // デフォルトでは選択不可

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
    return [[Chain shared] getChainList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger idx = [[Chain shared] getChainList].count - indexPath.row - 1;    // 逆順表示
    // --- 表示対象になるアルカナ
    Arcana* arcanaForCell = [[Chain shared] getChainList][idx];
    NSDictionary* dicStrArcana = [arcanaForCell getArcanaText];
    
    // --- 本文
    [cell.textLabel setText:dicStrArcana[@"arcana"]];
    [cell.detailTextLabel setText:dicStrArcana[@"status"]];
    
    // --- チェックマーク
    if ([setSelectedArcana containsObject:arcanaForCell]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    // --- 状態によって文字色を変える
    switch (arcanaForCell.status) {
        case kArcanaStatus_Upright:
            [cell.detailTextLabel setTextColor:[UIColor blackColor]];
            break;
            
        case kArcanaStatus_Reverse:
            [cell.detailTextLabel setTextColor:[UIColor orangeColor]];
            break;
            
        case kArcanaStatus_Back:
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            break;
            
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの選択
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger idx = [[Chain shared] getChainList].count - indexPath.row - 1;    // 逆順表示
    // --- 表示対象になるアルカナ
    Arcana* arcanaForCell = [[Chain shared] getChainList][idx];

    // --- 選択状態を入れ替えて、セルの再表示を行う
    if ([setSelectedArcana containsObject:arcanaForCell]) {
        [setSelectedArcana removeObject:arcanaForCell];
    } else {
        [setSelectedArcana addObject:arcanaForCell];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([setSelectedArcana count] > 0) {
        // --- 選択されているアルカナが１個以上あれば、返却ボタンが押せるようになる
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        // --- 選択されているアルカナが１個以上あれば、返却ボタンは押せない
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
}

-(void)tapBtnReturn:(UIBarButtonItem*)sender {
    // --- 選択されたアルカナを返す
    NSString* alertTitle = @"確認";
    NSString* alertMessage = @"選択されたアルカナを捨て札に返却します";
    
    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;

    [alert addButton:@"返却する" actionBlock:^{
        // --- 選択されたアルカナを返す処理をして、画面を戻す
        for (Arcana* arcana in setSelectedArcana) {
            [[Chain shared] returnChainWithArcana:arcana];
        }
        [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert showQuestion:self title:alertTitle subTitle:alertMessage closeButtonTitle:@"キャンセル" duration:0];
}


@end
