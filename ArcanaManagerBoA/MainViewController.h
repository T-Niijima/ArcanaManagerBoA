//
//  MainViewController.h
//  ArcanaManagerBoA
//
//  Created by Takahiro Niijima on 2017/07/17.
//  Copyright © 2017年 Takahiro Niijima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCLogic.h"

@interface MainViewController : UIViewController

@property(nonatomic, strong)IBOutlet MainVCLogic* logic;

@end

