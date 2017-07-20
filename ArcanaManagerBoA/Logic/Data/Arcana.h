//
//  Arcana.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSInteger, kArcanaStatus){
    kArcanaStatus_Upright,  // 正位置
    kArcanaStatus_Reverse,  // 逆位置
    kArcanaStatus_Back,     // 裏向き（正位置でも、逆位置でもない）
};

@interface Arcana : NSObject

-(Arcana*)initWithNo:(NSInteger)arcanaNo;   // アルカナ番号を添えた初期化
-(UIImage*)getArcanaFace;   // アルカナの表向きの画像
-(UIImage*)getArcanaImage;  // アルカナの向きを踏まえた画像
-(NSDictionary*)getArcanaText;

@property(nonatomic, readonly)NSInteger no;          // アルカナの番号
@property(nonatomic, readwrite)kArcanaStatus status; // アルカナのステータス

@end
