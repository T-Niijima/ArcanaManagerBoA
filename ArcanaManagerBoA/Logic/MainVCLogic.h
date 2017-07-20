//
//  MainVCLogic.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface MainVCLogic : NSObject<UIDocumentInteractionControllerDelegate>

@property(nonatomic, weak)IBOutlet UIImageView* ivDeck;     // 山札
@property(nonatomic, weak)IBOutlet UIImageView* ivScene;    // シーンカード

@property(nonatomic, weak)IBOutlet UIButton* btnNewScene;   // 「新しいシーン」ボタン
@property(nonatomic, weak)IBOutlet UIButton* btnDeckToChain;    //  山札から鎖
@property(nonatomic, weak)IBOutlet UIButton* btnDiscardChain;   //  鎖から捨て札
@property(nonatomic, weak)IBOutlet UIButton* btnSpecial;        // 特殊
@property(nonatomic, weak)IBOutlet UIButton* btnSceneToChain;   // シーンカードを鎖として渡す

@property(nonatomic, weak)IBOutlet UIViewController* vc;

@property(nonatomic, weak)IBOutlet UIView* coverView;
@property(nonatomic, weak)IBOutlet UILabel* lblArcana;      // 鎖として渡されたアルカナ
@property(nonatomic, weak)IBOutlet UIImageView* ivChain;    // 鎖として渡されたアルカナ

-(void)deckToScene;
-(void)putSceneToChain;

-(void)showEmptyAlert;
-(void)showPutChainActionSheet:(UIButton*)sender;
-(void)showEmptyChainAlert;
-(void)showSpecialActionSheet:(UIButton*)sender;

@end
