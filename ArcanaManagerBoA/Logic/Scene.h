//
//  Scene.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arcana.h"

@interface Scene : NSObject

+(Scene*)shared;
-(void)disacardArcana;  // （あれば）今のシーンカードを捨てる
-(void)putArcana:(Arcana*)arcana;   // アルカナを置く
-(Arcana*)showArcana;   // アルカナを見る
-(Arcana*)getArcana;    // アルカナを取り出す
-(void)ReverseArcana;

@end
