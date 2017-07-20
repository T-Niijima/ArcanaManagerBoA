//
//  Discard.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arcana.h"

@interface Discard : NSObject

+(Discard*)shared;
-(void)putArcana:(Arcana*)arcana;
-(NSArray*)getDiscardList;
-(void)emptyDeck;
-(void)clear;

@end
