//
//  Chain.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arcana.h"

@interface Chain : NSObject
+(Chain*)shared;
-(void)putChain:(Arcana*)arcana;
-(void)returnChain:(NSInteger)idx;
-(void)returnChainWithArcana:(Arcana*)arcana;
-(NSArray*)getChainList;
-(void)doRestraint;
-(void)clear;

@end
