//
//  AudioPlayerController.h
//  AudioPlayer
//
//  Created by Ian on 11/05/2010.
//  Copyright Elastik Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AudioPlayerController;

@protocol AudioPlayerDelegate
- (void)playerDidReachEndOfAudioFile:(AudioPlayerController *)controller;
@end

@interface AudioPlayerController : UIViewController <AVAudioPlayerDelegate>
{
  NSString *fileName_;
	AVAudioPlayer *player_;
  UISlider *progressSlider_;
  UILabel *progressLabel_;
  UILabel *remainingLabel_;
  UIButton *playPauseButton_;
  NSTimer *updateTimer_;
}

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UILabel *remainingLabel;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) NSTimer *updateTimer;

- (id)initWithAudioFileNamed:(NSString *)fileName;

- (IBAction)playPause;
- (IBAction)progressSliderMoved:(UISlider *)sender;

@end

