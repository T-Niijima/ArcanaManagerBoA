//
//  Deck.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arcana.h"

@interface Deck : NSObject

+(Deck*)shared;
-(Arcana*)showTopDeck;
-(Arcana*)takeTopDeck;
-(void)putNewDackFromArray:(NSArray<Arcana*>*)arr;
-(void)allReset;

@end
