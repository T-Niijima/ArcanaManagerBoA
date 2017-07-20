//
//  Deck.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "Deck.h"
#import "Discard.h"
#import "Chain.h"
#import "Scene.h"

@interface Deck() {
    NSMutableArray<Arcana*>* arrDeck;    // 実際の山札
}

@end

@implementation Deck

Deck* deck;

+(Deck*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deck = [[Deck new] init];
    });
    return deck;
}

-(Deck*)init {
    // --- 初期化する
    self = [super init];
    if (self) {
        arrDeck = [NSMutableArray array];
        [self initDeck];
    }
    return self;
}

-(void)initDeck {
    // 山札の初期化
    // --- 山札に22枚のカード
    for (NSInteger i = 0 ; i < 22; i++) {
        Arcana* newArcana = [[Arcana alloc] initWithNo:i];
        newArcana.status = (arc4random() % 2 == 0) ? kArcanaStatus_Upright : kArcanaStatus_Reverse;
        [arrDeck addObject:newArcana];
    }
    
    // --- 1000回シャッフルする
    for (NSInteger i = 0 ; i < 1000 ; i++) {
        NSInteger idxA = arc4random() % arrDeck.count;
        NSInteger idxB = arc4random() % arrDeck.count;
        [arrDeck exchangeObjectAtIndex:idxA withObjectAtIndex:idxB];
    }
}

-(Arcana*)showTopDeck{
    // 一番上のカードを「見る」（見るだけなので、戻す）
    if (arrDeck.count == 0) {
        // --- 空っぽ
        return nil;
    }
    return arrDeck[0];
}

-(Arcana*)takeTopDeck{
    // 一番上のカードを「取り出す」
    if (arrDeck.count == 0) {
        return nil;
    }
    Arcana* top = arrDeck[0];
    [arrDeck removeObjectAtIndex:0];
    if (arrDeck.count == 0) {
        // --- 「山札が尽きた」メッセージ
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDeckImage" object:nil];
        [[Discard shared] emptyDeck];
    }
    return top;
}

-(void)putNewDackFromArray:(NSArray<Arcana*>*)arr{
    // 新しい山札を作る
    [arrDeck removeAllObjects];
    [arrDeck addObjectsFromArray:arr];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createDeck" object:nil];
}

-(void)allReset {
    // オールリセット
    [[Scene shared] disacardArcana];
    [[Discard shared] clear];
    [[Chain shared] clear];
    [arrDeck removeAllObjects];
    [self initDeck];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createDeck" object:nil];
}

@end
