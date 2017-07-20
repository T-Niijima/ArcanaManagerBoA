//
//  Arcana.m
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/18.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import "Arcana.h"

@implementation Arcana

-(Arcana*)initWithNo:(NSInteger)arcanaNo{
    // 初期化
    self = [super init];
    if (self) {
        _no = arcanaNo;
    }
    return self;
}

-(UIImage*)getArcanaFace{
    // アルカナの表向きの画像
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)self.no]];
}

-(UIImage*)getArcanaImage{
   // アルカナの向きを踏まえた画像
    UIImage* image = nil;
    switch (self.status) {
        case kArcanaStatus_Upright:
            // --- 正位置
            image = [self getArcanaFace];
            break;
            
        case kArcanaStatus_Reverse:
            // --- 逆位置
            image = [self getReverceImage];
            break;
            
        case kArcanaStatus_Back:
            // --- 裏向き
            image = [UIImage imageNamed:@"Back"];
            break;
            
        default:
            break;
    }
    return image;
}

- (UIImage*)getReverceImage{
    // 逆向きの画像を作成する
    UIImage* original = [self getArcanaFace];
    
    UIGraphicsBeginImageContextWithOptions(original.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, -1.0, -1.0);
    
    CGContextTranslateCTM(context, -original.size.width, -original.size.height);
    
    [original drawInRect:CGRectMake(0, 0, original.size.width, original.size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

-(NSDictionary*)getArcanaText {
    // 現在の状態をStringで返す
    const NSArray* arrStrArcana = @[
                                    @"ウェントス",
                                    @"エフェクトス",@"クレアータ",@"マーテル",@"コロナ",
                                    @"フィニス",@"エルス",@"アダマス",@"アルドール",
                                    @"ファンタスマ",@"アクシス",@"レクス",@"アクア",
                                    @"グラディウス",@"アングルス",@"ディアボルス",@"フルキフェル",
                                    @"ステラ",@"ルナ",@"デクストラ",@"イグニス",
                                    @"オービス",
                                    ];
    
    NSString* strArcana = arrStrArcana[self.no];
    NSString* status = @"";
    switch (self.status) {
        case kArcanaStatus_Upright:
            status = @"正位置";
            break;
            
        case kArcanaStatus_Reverse:
            status = @"逆位置";
            break;
            
        case kArcanaStatus_Back:
            status = @"裏向き";
            break;
            
        default:
            break;
    }
    
    return @{
             @"arcana" : strArcana,
             @"status" : status,
             };
}

@end
