//
//  AudioPlayerController.m
//  AudioPlayer
//
//  Created by Ian on 11/05/2010.
//  Copyright Elastik Mobile 2010. All rights reserved.
//

#import "AudioPlayerController.h"

@interface AudioPlayerController ()
- (void)startAudio;
- (void)pauseAudio;
- (NSURL *)getURLForFile:(NSString *)fileName;
- (void)updateViewForPlayerState;
- (void)updateCurrentTime;
@end

@implementation AudioPlayerController

@synthesize fileName = fileName_;
@synthesize player = player_;
@synthesize progressSlider = progressSlider_;
@synthesize progressLabel = progressLabel_;
@synthesize remainingLabel = remainingLabel_;
@synthesize playPauseButton = playPauseButton_;
@synthesize updateTimer = updateTimer_;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithAudioFileNamed:(NSString *)fileName
{
    if (self = [super initWithNibName:@"AudioPlayer" bundle:[NSBundle bundleForClass:[self class]]]) 
    {
      [self setFileName:fileName];
    }
    return self;
}

- (void)dealloc 
{
  [updateTimer_ release];
  [fileName_ release];
  [player_ setDelegate:nil];
  [player_ release];
  [progressSlider_ release];
  [progressLabel_ release];
  [remainingLabel_ release];
  [playPauseButton_ release];
  [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  NSError *error = nil;
  NSURL *fileURL = [self getURLForFile:[self fileName]];
  [self setPlayer:[[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error] autorelease]];
  [[self player] setDelegate:self];
  
  [[self progressSlider] setMaximumValue:[[self player] duration]];
  [self updateCurrentTime];
  [self startAudio];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)startAudio
{
  if([[self player] isPlaying])
  {
    [self pauseAudio];
  }
  
  if([[self player] play])
  {
    [self setUpdateTimer:[NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:[self player] repeats:YES]];
  }
}

- (void)pauseAudio
{
  if(![[self player] isPlaying])
  {
    return;
  }
  
  [[self player] pause];
  
  [[self updateTimer] invalidate];
  [self setUpdateTimer:nil];
}

- (IBAction)playPause
{
  if([[self player] isPlaying])
  {
    [self pauseAudio];
  }
  else 
  {
    [self startAudio];
  }
}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
	[[self player] setCurrentTime:[sender value]];
	[self updateCurrentTime];
}

- (void)updateViewForPlayerState
{
  
}

- (void)updateCurrentTime
{
  int currentTime = (int)[[self player] currentTime];
  [[self progressLabel] setText:[NSString stringWithFormat:@"%d:%02d", currentTime / 60, currentTime % 60]];
  
  int timeRemaining = (int)([[self player] duration] - [[self player] currentTime]);
  [[self remainingLabel] setText:[NSString stringWithFormat:@"-%d:%02d", timeRemaining / 60, timeRemaining % 60]];
  
	[[self progressSlider] setValue:[[self player] currentTime]];
}

- (NSURL *)getURLForFile:(NSString *)fileName
{
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"mp3"];
  return [NSURL fileURLWithPath:filePath];
  /*
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName]];
   */
}

#pragma mark AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
  
	[player setCurrentTime:0];
	//[self updateViewForPlayerState];
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	// the object has already been paused,	we just need to update UI
	[self updateViewForPlayerState];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	[self startAudio];
}

@end
