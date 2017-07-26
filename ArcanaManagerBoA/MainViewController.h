//
//  MainViewController.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/17.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCLogic.h"

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic, strong)IBOutlet MainVCLogic* logic;
@property(nonatomic, weak)IBOutlet UISwipeGestureRecognizer* gestureNewScene;
@property(nonatomic, weak)IBOutlet UISwipeGestureRecognizer* gestureNewChain;
@property(nonatomic, weak)IBOutlet UISwipeGestureRecognizer* gestureCollectionChain;

@end

