//
//  SoundManager.h
//  SR5DiceTool
//
//  Created by Niijima Takahiro on 2016/03/04.
//  Copyright © 2016年 Takahiro Niijima. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface SoundManager : NSObject<AVAudioPlayerDelegate>

#define SOUND_MEKURU @"page08_mekuru"

+(SoundManager*)shared;
//-(void)prepareSound;
-(void)playSoundWithName:(NSString*)name;

@end
