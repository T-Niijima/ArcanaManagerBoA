//
//  ArcanaManagerBoATestCase.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/28.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "ArcanaManagerBoATestCase.h"

@implementation ArcanaManagerBoATestCase

-(void)beforeEach {
    NSLog(@"テストケースが始まる --- ");
}

-(void)afterEach {
    NSLog(@"テストケースが終わる --- ");
}

-(void)testSample {
    // prefixに"test"を入れると、それぞれが1つのテストケースとして認識される
    // --- シーンを２シーン回す
    [tester waitForViewWithAccessibilityLabel:@"ChangeScene"];  // ChangeSceneボタンが表示されるまで待つ
    
    // --- シーンを21回変える
    for (NSInteger i = 0 ; i < 22 ; i++) {
        [tester waitForTappableViewWithAccessibilityLabel:@"ChangeScene"];
        [tester tapViewWithAccessibilityLabel:@"ChangeScene"];
    }
    
    // --- 22シーン目で山札がなくなるので、山札補充のアラートが出る
    [tester waitForViewWithAccessibilityLabel:@"Alert_OK"];
    [tester waitForTappableViewWithAccessibilityLabel:@"AlertBtn_OK"];
    [tester tapViewWithAccessibilityLabel:@"AlertBtn_OK"];
    
    // --- 新しい鎖を渡す
    [tester waitForTappableViewWithAccessibilityLabel:@"NewChain"];
    [tester tapViewWithAccessibilityLabel:@"NewChain"];

    [tester waitForViewWithAccessibilityLabel:@"Alert_NewChain"];
    [tester waitForTappableViewWithAccessibilityLabel:@"AlertBtn_NormalChain"];
    [tester tapViewWithAccessibilityLabel:@"AlertBtn_NormalChain"];
    
    sleep(5);
    
    // --- もう１枚鎖を渡す
    [tester waitForTappableViewWithAccessibilityLabel:@"AddNewChain"];
    [tester tapViewWithAccessibilityLabel:@"AddNewChain"];
    [tester waitForViewWithAccessibilityLabel:@"Alert_NewChain"];
    [tester waitForTappableViewWithAccessibilityLabel:@"AlertBtn_NormalChain"];
    [tester tapViewWithAccessibilityLabel:@"AlertBtn_NormalChain"];
    
    sleep(5);
    
    // --- 鎖を渡すのを閉じる
    [tester waitForTappableViewWithAccessibilityLabel:@"CloseChain"];
    [tester tapViewWithAccessibilityLabel:@"CloseChain"];
    
    // --- 鎖を受け取る
    [tester waitForTappableViewWithAccessibilityLabel:@"CollectChain"];
    [tester tapViewWithAccessibilityLabel:@"CollectChain"];
    
    // --- 画面遷移して、鎖の一覧が出てくるので、一枚返す
    sleep(5);
    
    // --- あんまりよくないが、UITableViewControllerを呼び出して、セルをタップして鎖を返す
    // AccessibilityLabelの設定がうまく行かなかった
    UINavigationController* nav = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UITableViewController* tvc = ((UITableViewController*)[nav.viewControllers lastObject]);
    
    XCTAssertTrue([tvc.tableView numberOfRowsInSection:0] == 2, @"配った鎖の枚数とリストのセル数の一致がしない");
    
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                  inTableView:tvc.tableView];
    [tester tapViewWithAccessibilityLabel:@"ButtonReturn"];
    
    // --- 鎖を返すボタンを叩く
    [tester waitForTappableViewWithAccessibilityLabel:@"OK"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
    
    sleep(10);
    
    
}

@end
