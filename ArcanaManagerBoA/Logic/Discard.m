//
//  Discard.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "Discard.h"
#import "Deck.h"

@interface Discard(){
    NSMutableArray<Arcana*>* arrDiscard; // 捨て札の山
}

@end

@implementation Discard

Discard* discard;

+(Discard*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        discard = [[Discard new] init];
    });
    return discard;
}

-(Discard*)init {
    self = [super init];
    if (self) {
        arrDiscard = [NSMutableArray array];
    }
    return self;
}

-(void)putArcana:(Arcana*)arcana{
    // 新しいアルカナがputされる
    [arrDiscard addObject:arcana];
}

-(NSArray*)getDiscardList {
    return (NSArray*)arrDiscard;
}

-(void)emptyDeck {
    // デッキが空になった場合の通知
    if (arrDiscard.count == 0) {
        NSLog(@"[Notice] 山札も無ければ捨て札もない。全てのカードが鎖になっている？");
        return;
    }
    
    // --- シャッフルする
    for (NSInteger i = 0 ; i < 1000 ; i++) {
        NSInteger idxA = arc4random() % arrDiscard.count;
        NSInteger idxB = arc4random() % arrDiscard.count;
        [arrDiscard exchangeObjectAtIndex:idxA withObjectAtIndex:idxB];
    }
    
    // --- 向きをシャッフルする
    for (Arcana* arcna in arrDiscard){
        arcna.status = (arc4random() % 2 == 0) ? kArcanaStatus_Upright : kArcanaStatus_Reverse;
    }
    
    // --- 山札に全てのカードを移して、捨て札を空にする
    [[Deck shared] putNewDackFromArray:arrDiscard];
    [arrDiscard removeAllObjects];
    
    // --- 画面に出す用途の通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emptyAlert" object:nil];
}

-(void)clear {
    // 初期状態に戻す
    [arrDiscard removeAllObjects];
}

@end
