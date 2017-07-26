//
//  MainViewController.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/17.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "MainViewController.h"
#import "Chain.h"
#import "SoundManager.h"

@interface MainViewController () {
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --- 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emptyAlert:)
                                                 name:@"emptyAlert"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeDeckImage:)
                                                 name:@"removeDeckImage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createDeck:)
                                                 name:@"createDeck"
                                               object:nil];
    
    // --- シーンカードを鎖として渡す場合
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    BOOL canChainScene = [ud boolForKey:@"option_SceneToChain"];
    if (canChainScene) {
        [self.logic.btnSceneToChain setHidden:NO];
    }
    
    // --- スワイプに必要なタップ数を設定する
    NSInteger numberOfTouchForNewScene = [ud integerForKey:@"option_NumberOfTouchForNewScene"];
    if (numberOfTouchForNewScene == 0) {
        // --- スワイプ無効
        self.gestureNewScene.enabled = NO;
    } else {
        self.gestureNewScene.numberOfTouchesRequired = numberOfTouchForNewScene;
    }
    
    NSInteger numberOfTouchForNewChain = [ud integerForKey:@"option_NumberOfTouchForNewChain"];
    if (numberOfTouchForNewChain == 0) {
        // --- スワイプ無効
        self.gestureNewChain.enabled = NO;
    } else {
        self.gestureNewChain.numberOfTouchesRequired = numberOfTouchForNewChain;
    }
    
    NSInteger numberOfTouchForCollectionChain = [ud integerForKey:@"option_NumberOfTouchForCollectionChain"];
    if (numberOfTouchForCollectionChain == 0) {
        // --- スワイプ無効
        self.gestureCollectionChain.enabled = NO;
    } else {
        self.gestureCollectionChain.numberOfTouchesRequired = numberOfTouchForCollectionChain;
    }
    
    
    // --- iPhone4の場合、高さが足りないので文字列でのアルカナ表示をしない
    if (self.view.frame.size.height <= 480) {
        [self.logic.lblArcana setHidden:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tapBtnNewScene:(id)sender {
    // シーンカードを更新する
    [self.logic deckToScene];
    [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
}

-(IBAction)tapBtnSendChain:(id)sender {
    // 鎖を配布する（配布先は管理しない）
    [self.logic showPutChainActionSheet:sender];
    // --- ジェスチャを一時的に無効にする
    self.gestureNewScene.enabled = NO;
    self.gestureCollectionChain.enabled = NO;
}

-(IBAction)tapEndPutChain:(id)sender {
    // 鎖の配布を終了する
    [self.logic.coverView removeFromSuperview];
    // --- ジェスチャを有効にする
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSInteger numberOfTouchForNewScene = [ud integerForKey:@"option_NumberOfTouchForNewScene"];
    if (numberOfTouchForNewScene > 0) {
        self.gestureNewScene.enabled = YES;
    }
    
    NSInteger numberOfTouchForCollectionChain = [ud integerForKey:@"option_NumberOfTouchForCollectionChain"];
    if (numberOfTouchForCollectionChain > 0) {
        self.gestureCollectionChain.enabled = YES;
    }
}

-(IBAction)tapPutNextChain:(UIButton*)sender {
    // 再び鎖を配る
    [self.logic showPutChainActionSheet:sender];
}

-(IBAction)tapBtnReturnChain:(UIButton*)sender {
    // 鎖の返却をする
    if ([[Chain shared] getChainList].count == 0) {
        [self.logic showEmptyChainAlert];
        return;
    }
    [self performSegueWithIdentifier:@"ChainList" sender:nil];
}

-(IBAction)tapBtnSpecialAction:(UIButton*)sender {
    // 特殊な操作
    [self.logic showSpecialActionSheet:sender];
}

-(IBAction)tabBtnSceneToChain:(id)sender {
    // シーンカードを鎖として渡す
    [self.logic putSceneToChain];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // スワイプ動作の指定
    if ([gestureRecognizer isEqual:self.gestureNewScene]) {
        // --- 新しいシーン
        [self.logic deckToScene];
        [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
    } else if ([gestureRecognizer isEqual:self.gestureNewChain]) {
        // --- 鎖を渡す
        [self tapBtnSendChain:nil];
    } else if ([gestureRecognizer isEqual:self.gestureCollectionChain]) {
        // --- 鎖を返す
        [self tapBtnReturnChain:nil];
    }

    return YES;
}

#pragma mark - Notification

-(void)emptyAlert:(NSNotification*)notification {
    // 山札が空になったことをアラートで表示する
    [self.logic showEmptyAlert];
}

-(void)removeDeckImage:(NSNotification*)notification {
    // 山札を空にする
    [self.logic.ivDeck setImage:nil];
}

-(void)createDeck:(NSNotification*)notification {
    // 山札が作られた
    [self.logic.ivDeck setImage:[UIImage imageNamed:@"Back"]];
}

@end
