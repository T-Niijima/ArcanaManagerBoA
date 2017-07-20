//
//  Chain.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "Chain.h"
#import "Discard.h"

@interface Chain(){
    NSMutableArray<Arcana*>* arrChain;
}

@end

@implementation Chain

Chain* chain;

+(Chain*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chain = [[Chain new] init];
    });
    return chain;
}

-(Chain*)init {
    self = [super init];
    if (self) {
        arrChain = [NSMutableArray array];
    }
    return self;
}

-(void)putChain:(Arcana*)arcana {
    // 鎖を渡す
    [arrChain addObject:arcana];
}

-(void)returnChain:(NSInteger)idx {
    // 鎖を返す
    if ((idx < 0) || (idx >= arrChain.count)) {
        NSLog(@"%s:idxが範囲外[%ld]", __func__, (long)idx);
        return;
    }
    Arcana* targetReturn = arrChain[idx];
    [[Discard shared] putArcana:targetReturn];
    [arrChain removeObjectAtIndex:idx];
}

-(void)returnChainWithArcana:(Arcana*)arcana {
    // アルカナを指定して捨て札に送る
    if (![arrChain containsObject:arcana]) {
        NSLog(@"%s:指定されたアルカナをarrayに含んでいない", __func__);
    }
    [[Discard shared] putArcana:arcana];
    [arrChain removeObject:arcana];
}

-(NSArray*)getChainList {
    // 鎖の一覧を返す
    return (NSArray*)arrChain;
}

-(void)doRestraint {
    // 束縛を起こす
    Arcana* ventus = nil;
    for (Arcana* arcana in arrChain) {
        arcana.status = kArcanaStatus_Back;
        if (arcana.no == 0) {
            ventus = arcana;
        }
    }
    // --- ウェントスのアルカナがあった場合、捨て札にする
    if (ventus) {
        [[Discard shared] putArcana:ventus];
        [arrChain removeObject:ventus];
    }
}

-(void)clear {
    // 初期状態に戻す
    [arrChain removeAllObjects];
}

@end
