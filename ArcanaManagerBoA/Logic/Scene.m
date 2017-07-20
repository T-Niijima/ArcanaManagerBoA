//
//  Scene.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "Scene.h"
#import "Discard.h"

@interface Scene() {
    Arcana* currentArcana;  // 現在のアルカナ
}

@end

@implementation Scene

Scene* scene;

+(Scene*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scene = [[Scene new] init];
    });
    return scene;
}

-(void)disacardArcana {
    // （あれば）シーンカードを捨て札にする
    if (currentArcana) {
        [[Discard shared] putArcana:currentArcana];
    }
}

-(void)putArcana:(Arcana*)arcana {
    // アルカナを置く、古いアルカナは捨て札にする
    // --- 新しいcurrentArcanaを設定
    currentArcana = arcana;
}

-(Arcana*)showArcana{
    // シーンタロットのアルカナ
    return currentArcana;
}

-(Arcana*)getArcana {
    // シーンタロットのアルカナを取り出す
    Arcana* arcana = currentArcana;
    currentArcana = nil;
    return arcana;
}

-(void)ReverseArcana{
    // シーンカードのアルカナの正逆を入れ替える
    if (currentArcana) {
        switch (currentArcana.status) {
            case kArcanaStatus_Upright:
                currentArcana.status = kArcanaStatus_Reverse;
                break;
                
            case kArcanaStatus_Reverse:
                currentArcana.status = kArcanaStatus_Upright;
                break;
 
            default:
                break;
        }
    }
}

@end
