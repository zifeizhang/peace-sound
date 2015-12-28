//
//  SoundViewController.h
//  peacesound
//
//  Created by zhangzifei on 15/12/25.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAudioPlayer;
@interface SoundViewController : UIViewController
@property(nonatomic,strong)AVAudioPlayer *wavePlayer;
@property(nonatomic,strong)AVAudioPlayer *windPlayer;
@property(nonatomic,strong)AVAudioPlayer *rainPlayer;
@property(nonatomic,strong)AVAudioPlayer *thunderPlayer;
@property(nonatomic,strong)AVAudioPlayer *clockPlayer;
@property(nonatomic,strong)AVAudioPlayer *birdsPlayer;
@end
