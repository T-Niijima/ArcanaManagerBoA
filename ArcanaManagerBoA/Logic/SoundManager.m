//
//  SoundManager.m
//  SR5DiceTool
//
//  Created by Niijima Takahiro on 2016/03/04.
//  Copyright © 2016年 Takahiro Niijima. All rights reserved.
//

#import "SoundManager.h"
@import AudioToolbox;

SoundManager* soundManager;

@interface SoundManager(){
    NSMutableDictionary* dicSoundID;    // SoundIDを記憶する
    AVAudioPlayer* player;
}

@end


@implementation SoundManager

+(SoundManager*)shared{
    if(!soundManager){
        @synchronized(self) {
            soundManager = [[SoundManager alloc] init];
        }
    }
    return soundManager;
}

+(id)allocWithZone:(NSZone*)zone{
    // alloc時にシングルトンを保持するようにする
    if(!soundManager){
        @synchronized(self) {
            soundManager = [[super allocWithZone:zone] init];
        }
    }
    return soundManager;
}

-(id)copyWithZone:(NSZone*)zone{
    // selfを返す
    return self;
}

-(id)init{
    self = [super init];
    if(self) {
        dicSoundID = [NSMutableDictionary dictionary];
        [self prepareSound];
    }
    return self;
}

-(void)prepareSound {
    // 音の再生準備をする
    
    //AVFoundationのインスタンス
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
// --- 音楽再生を止めず、サイレントモードでも再生する
// http://stackoverflow.com/questions/32287569/ios-9-play-audio-in-silent-mode-but-keep-other-apps-music-playback-running
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:nil];
    
    //AVFoundation利用開始
    [audioSession setActive:YES error:nil];
    /*
    NSArray* arrSoundFilename = @[
                                  SOUND_BUTTON,
                                  SOUND_BUTTON_MODAL,
                                  SOUND_BUTTON_ROLL,
                                  SOUND_BUTTON_DONE,
                                  SOUND_BUTTON_CANCEL,
                                  SOUND_CLICK,
                                  ];
    
    for (NSString* filename in arrSoundFilename) {
        SystemSoundID sound;
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"caf"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &sound);
        
        [dicSoundID setObject:@(sound) forKey:filename];
        
    }
    */
}

-(void)playSoundWithName:(NSString *)name {
    
    BOOL enableSound = [[self fixUserDefaultStandardValueForKey:@"config_EnableSound"] boolValue];
    
    if (!enableSound) {
        // --- 設定でサウンドOFF
        return;
    }
    
    NSURL* fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"caf"]];
    
    if (player) {
        return;
    }
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.delegate = self;
    [player play];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag{
    // playerの開放
    player = nil;
}


-(id)fixUserDefaultStandardValueForKey:(NSString*)key{
    // Settings.bundleを弄る前に初期値を取得する
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    id value = [ud objectForKey:key];
    
    if (value == nil){
        // --- valueがない！
        
        // ---- Settings.bundle以下のRoot.plistを引っ張る
        NSString* bPath = [[NSBundle mainBundle] bundlePath];
        NSString* settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString* plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        
        // ---- 設定のArrayを引っ張る
        NSDictionary* settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
        NSArray* preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];

        for(NSDictionary* item in preferencesArray){
            // --- KeyとValueを拾得してDegaultValueにする。対象はkeyのものだけ（他のものはdefaultValueがすでに変わってる可能性もある
            NSString *keyValue = item[@"Key"];
            id defaultValue = item[@"DefaultValue"];
            
            if (keyValue && defaultValue && ([keyValue compare:key] == NSOrderedSame)) {
                [ud setObject:defaultValue forKey:keyValue];
                value = defaultValue;
                break;
            }
        }
        [ud synchronize];
    }
    
    return value;
    
}

@end
