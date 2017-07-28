//
//  MainVCLogic.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "MainVCLogic.h"
#import "Deck.h"
#import "Scene.h"
#import "Arcana.h"
#import "Chain.h"
#import "Discard.h"
#import "Scene.h"
#import "SoundManager.h"

@import SCLAlertView_Objective_C;

@implementation MainVCLogic

-(void)deckToScene{
    // 山札の一番上のカードをシーンカードにする
    // --- バックエンドの処理
    if (![[Deck shared] showTopDeck]) {
        // --- 山札にカードがないのでエラー表示する
        [self showEmptyDeck];
        return;
    }
    
    // ---- 古いシーンカードは捨て札に移動する
    [[Scene shared] disacardArcana];
    
    // ---- 山札の一番上のカード
    Arcana* topArcana = [[Deck shared] takeTopDeck];
    
    // ---- 山札の一番上のカードをシーンカードに移動する
    [[Scene shared] putArcana:topArcana];
    
    // ---- 新しいシーンへ移行するボタンをDisableに
    [self.btnNewScene setEnabled:NO];
    
    // --- 映像処理
    // ---- 新しいUIImageViewを作る
    UIImageView* ivAnime = [[UIImageView alloc] initWithFrame:self.ivDeck.frame];
    
    // ---- 裏返しの画像を当てる
    [ivAnime setImage:[UIImage imageNamed:@"Back"]];
    [self.ivDeck.superview insertSubview:ivAnime aboveSubview:self.ivScene];

    // ---- アニメーション
    CGRect rect = ivAnime.frame;
    rect.size.width = 0;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         ivAnime.frame = rect;
                     }
                     completion:^(BOOL finished){
                         // ---- 表の画像を当てる
                         [ivAnime setImage:[topArcana getArcanaImage]];

                         // ---- アニメーション
                         [UIView animateWithDuration:0.4f
                                          animations:^{
                                              ivAnime.frame = self.ivScene.frame;
                                          }
                                          completion:^(BOOL finished){
                                              // ---- 終わったら「シーンカード」のUIImgeviewの画像をすり替え
                                              [self.ivScene setImage:[topArcana getArcanaImage]];
                                              // ---- 新しいUIImageViewの画像を消す
                                              [ivAnime removeFromSuperview];
                                              // ---- 新しいシーンに移行するボタンをEnableに
                                              [self.btnNewScene setEnabled:YES];

                                          }];
                     }];
    
}

-(void)showPutChain {
    // 渡された鎖が何であるかを表示するためのViewを表示する
    if (![self.coverView superview]) {
        [self.coverView setFrame:self.vc.view.frame];
        [self.vc.view addSubview:self.coverView];
        [self.coverView setAlpha:0.2f];
        [UIView animateWithDuration:0.25f animations:^{
            [self.coverView setAlpha:1.0f];
        }];
    }
    
    // --- Chainの最後（最後にChainに加えられたカード）を表示する
    Arcana* targetArcana = [[[Chain shared] getChainList] lastObject];
    [self.ivChain setImage:[targetArcana getArcanaImage]];
    NSDictionary* dicStrArcana = [targetArcana getArcanaText];
    [self.lblArcana setText:[NSString stringWithFormat:@"%@ %@", dicStrArcana[@"arcana"], dicStrArcana[@"status"]]];
}

-(void)putSceneToChain {
    // シーンカードを鎖として渡す
    Arcana* sceneArcana = [[Scene shared] getArcana];
    if (!sceneArcana) {
        // --- シーンにアルカナがない場合、メッセージを表示
        [self showEmptyScene];
        return;
    }
    
    // --- シーンカードを消す
    [self.ivScene setImage:nil];    
    [[SoundManager shared] playSoundWithName:SOUND_MEKURU];

    // --- シーンカードを鎖として渡して、表示Viewを出す
    [[Chain shared] putChain:sceneArcana];
    [self showPutChain];
    
}

#pragma mark - アラート表示

-(void)showEmptyAlert {
    // 山札が空になった通知を表示
    NSString* alertTitle = @"山札の補充";
    NSString* alertMessage = @"山札がなくなったので、捨て札をシャッフルして新しい山札にしました";
    SCLAlertViewBuilder* alertBuilder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"了解", nil)
    .showAnimationType(SCLAlertViewShowAnimationFadeIn)
    .hideAnimationType(SCLAlertViewHideAnimationFadeOut);
    
    SCLAlertViewShowBuilder* showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleInfo)
    .title(alertTitle)
    .subTitle(alertMessage)
    .duration(0);
    [showBuilder showAlertView:alertBuilder.alertView onViewController:self.vc];
    
}

-(void)showEmptyScene {
    // シーンカードがないのに鎖として渡そうとした
    NSString* alertTitle = @"シーンカードなし";
    NSString* alertMessage = @"シーンカードがないので、鎖として渡せません";
    SCLAlertViewBuilder* alertBuilder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"了解", nil)
    .showAnimationType(SCLAlertViewShowAnimationFadeIn)
    .hideAnimationType(SCLAlertViewHideAnimationFadeOut);
    
    SCLAlertViewShowBuilder* showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleWarning)
    .title(alertTitle)
    .subTitle(alertMessage)
    .duration(0);
    [showBuilder showAlertView:alertBuilder.alertView onViewController:self.vc];
}

-(void)showEmptyDiscard {
    // 捨て札が空である
    NSString* alertTitle = @"捨て札なし";
    NSString* alertMessage = @"現在捨て札には１枚もカードがありません";
    SCLAlertViewBuilder* alertBuilder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"了解", nil)
    .showAnimationType(SCLAlertViewShowAnimationFadeIn)
    .hideAnimationType(SCLAlertViewHideAnimationFadeOut);
    
    SCLAlertViewShowBuilder* showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleWarning)
    .title(alertTitle)
    .subTitle(alertMessage)
    .duration(0);
    [showBuilder showAlertView:alertBuilder.alertView onViewController:self.vc];
}

-(void)showEmptyDeck {
    // 山札が空になり、補充できない
    NSString* alertTitle = @"山札が作成できません";
    NSString* alertMessage = @"山札がなく、捨て札にも札がありません。全て「鎖」として渡されてると思われるので、鎖の返却の処理をして、特殊操作の'捨て札から山札の作成'を行って下さい";
    SCLAlertViewBuilder* alertBuilder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"了解", nil)
    .showAnimationType(SCLAlertViewShowAnimationFadeIn)
    .hideAnimationType(SCLAlertViewHideAnimationFadeOut);

    SCLAlertViewShowBuilder* showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleError)
    .title(alertTitle)
    .subTitle(alertMessage)
    .duration(0);
    [showBuilder showAlertView:alertBuilder.alertView onViewController:self.vc];
}


-(void)showPutChainActionSheet:(UIButton*)sender {
    // 鎖を渡す場合のアクションシート
    NSString* alertTitle = @"鎖を渡す";
    NSString* alertMessage = @"渡す鎖の種類を選んで下さい";
    
    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;

    [alert addButton:@"通常の鎖" actionBlock:^{
        Arcana* target = [[Deck shared] takeTopDeck];
        if (!target) {
            [self showEmptyDeck];
            return;
        }
        
        // --- 鎖を渡す
        [[Chain shared] putChain:target];
        [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
        [self showPutChain];
    }];
    
    [alert addButton:@"逆位置で鎖を渡す（悪徳）" actionBlock:^{
        Arcana* target = [[Deck shared] takeTopDeck];
        if (!target) {
            [self showEmptyDeck];
            return;
        }
        target.status = kArcanaStatus_Reverse;
        
        // --- 鎖を渡す
        [[Chain shared] putChain:target];
        [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
        [self showPutChain];
    }];
    
    [alert addButton:@"正位置で鎖を渡す" actionBlock:^{
        Arcana* target = [[Deck shared] takeTopDeck];
        target.status = kArcanaStatus_Upright;
        if (!target) {
            [self showEmptyDeck];
            return;
        }
        
        // --- 鎖を渡す
        [[Chain shared] putChain:target];
        [[SoundManager shared] playSoundWithName:SOUND_MEKURU];
        [self showPutChain];
    }];
    
    [alert showCustom:self.vc
                image:[UIImage imageNamed:@"Chain"]
                color:[UIColor lightGrayColor]
                title:alertTitle
             subTitle:alertMessage
     closeButtonTitle:@"キャンセル"
             duration:0];
}

-(void)showEmptyChainAlert {
    // 山札が空になり、補充できない
    NSString* alertTitle = @"鎖がありません";
    NSString* alertMessage = @"鎖は一枚も配られていません";
    SCLAlertViewBuilder* alertBuilder = [SCLAlertViewBuilder new]
    .addButtonWithActionBlock(@"了解", nil)
    .showAnimationType(SCLAlertViewShowAnimationFadeIn)
    .hideAnimationType(SCLAlertViewHideAnimationFadeOut);

    SCLAlertViewShowBuilder* showBuilder = [SCLAlertViewShowBuilder new]
    .style(SCLAlertViewStyleWarning)
    .title(alertTitle)
    .subTitle(alertMessage)
    .duration(0);
    [showBuilder showAlertView:alertBuilder.alertView onViewController:self.vc];
}

-(void)showSpecialActionSheet:(UIButton*)sender {
    // 特殊アクションのアクションシートを出す
    
    NSString* alertTitle = @"特殊な操作";
    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;

    [alert addButton:@"捨て札の一覧" actionBlock:^{
        if ([[Discard shared] getDiscardList].count == 0) {
            // --- 捨て札がない
            [self showEmptyDiscard];
        } else {
            [self.vc performSegueWithIdentifier:@"discardList" sender:nil];
        }
    }];
    
    [alert addButton:@"束縛の発生" actionBlock:^{
        [self showConfirmRestraint];
    }];
    
    if (![[Deck shared] showTopDeck] && ([[Discard shared] getDiscardList].count > 0)) {
        // --- 山札にカードが無く、捨て札にカードがある場合の手動シャッフル
        [alert addButton:@"捨て札から山札の作成" actionBlock:^{
            // --- 捨て札から山札を再作成する
            [[Discard shared] emptyDeck];
        }];
    }
    
    [alert addButton:@"PL用シートの表示" actionBlock:^{
        NSURL* fileURL = [[NSBundle mainBundle] URLForResource:@"Sheet" withExtension:@"pdf"];
        UIDocumentInteractionController* controller =
        [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        controller.delegate = self;
        
        [controller presentPreviewAnimated:YES];
        
    }];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    BOOL canChainScene = [ud boolForKey:@"option_SceneToChain"];
    if (canChainScene && [[Scene shared] showArcana]) {
        [alert addButton:@"捨て札から山札の作成" actionBlock:^{
            // --- シーンカードの正逆を入れ替える
            [[Scene shared] ReverseArcana];
            Arcana* sceneArcana = [[Scene shared] showArcana];
            if (sceneArcana) {
                [self.ivScene setImage:[sceneArcana getArcanaImage]];
            }
        }];
    }
    
    SCLButton* resetButton =  [alert addButton:@"オールリセット" actionBlock:^{
        [self confirmAllReset];
    }];
    
    [alert showCustom:self.vc
                image:[UIImage imageNamed:@"Tarot"]
                color:[UIColor lightGrayColor]
                title:alertTitle
             subTitle:nil
     closeButtonTitle:@"キャンセル"
             duration:0];
    resetButton.backgroundColor = [UIColor orangeColor];    // 表示した後で変える
}

-(void)showConfirmRestraint {
    // 束縛の確認
    NSString* alertTitle = @"確認";
    NSString* alertMessage = @"束縛を起こします（配られている鎖を全て裏返します）。鎖にウェントスのカードがあった場合、自動的に捨て札に移動します。よろしいですか";
    
    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;
    
    [alert addButton:@"束縛を起こす" actionBlock:^{
        // --- 束縛を起こす
        [[Chain shared] doRestraint];
    }];
    
    [alert showQuestion:self.vc title:alertTitle subTitle:alertMessage closeButtonTitle:@"キャンセル" duration:0];
}

-(void)confirmAllReset {
    // オールリセットの確認
    NSString* alertTitle = @"確認";
    NSString* alertMessage = @"全てのカードを山札に戻して切り直します。この操作は取り消せません。よろしいですか";

    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;

    SCLButton* resetButton = [alert addButton:@"リセット実行" actionBlock:^{
        // --- オールリセット
        [[Deck shared] allReset];
        [self.ivDeck setImage:[UIImage imageNamed:@"Back"]];
        [self.ivScene setImage:nil];
    }];
    
    [alert showWarning:self.vc title:alertTitle subTitle:alertMessage closeButtonTitle:@"キャンセル" duration:0];
    resetButton.backgroundColor = [UIColor orangeColor];    // 表示した後で変える
}

-(void)showSwipeGuideWithOrigin:(CGPoint)origin imageName:(NSString*)imageName {
    // スワイプガイドを表示する（そして消す）
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(origin.x, MAX(origin.y - 44,0), 200, 44)];
    [iv setImage:[UIImage imageNamed:imageName]];
    [iv setAlpha:0.6f];
    [self.vc.view addSubview:iv];
    [UIView animateWithDuration:1.0f animations:^{
        [iv setAlpha:0.0f];
    } completion:^(BOOL finished){
        [iv removeFromSuperview];
    }];
}

#pragma mark - 初期値設定
#pragma mark - Delegate

-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.vc;
}

@end
