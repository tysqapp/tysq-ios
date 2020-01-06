//
//  SQIJKPlayerTool.m
//  SheQu
//
//  Created by gm on 2019/6/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import "SQIJKPlayerTool.h"
@interface SQIJKPlayerTool()
@property(atomic,strong) NSURL *url;
@property (nonatomic, copy) SQIJKPlayerToolCallBack callBack;
@end

@implementation SQIJKPlayerTool

- (instancetype)initWithURL:(NSURL *)url callBack:(SQIJKPlayerToolCallBack) callBack {
    if (self = [super init]) {
        self.player = [[IJKAVMoviePlayerController alloc] initWithContentURL:url];
        [self installMovieNotificationObservers];
        //[self.player prepareToPlay];
        self.callBack = callBack;
    }
    return self;
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
       //NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n _player.duration = %.f", (int)loadState, _player.duration);
        if (self.callBack) {
            self.callBack(_player);
        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        self.isPlayError = false;
        //NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n _player.duration = %.f", (int)loadState, _player.duration);
        
    } else {
        //NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    dispatch_async(dispatch_get_main_queue(), ^{
        int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        
        switch (reason)
        {
            case IJKMPMovieFinishReasonPlaybackEnded:
               //NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
                break;
            
            case IJKMPMovieFinishReasonUserExited:
               //NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
                break;
            
            case IJKMPMovieFinishReasonPlaybackError:
               //NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
                self.isPlayError = true;
                if (self.callBack) {
                    self.callBack(self->_player);
                }
                break;
                
            default:
               //NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
                break;
        }
    });
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
   //NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
           //NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

- (void)play {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.player.isPlaying) {
            [self.player play];
        }else{
            [self.player pause];
        }
        if (self.callBack) {
            self.callBack(self.player);
        }
    });
}
- (void)pause {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player pause];
        if (self.callBack) {
            self.callBack(self.player);
        }
    });
}

- (void)removePlayer{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player pause];
        [self.player shutdown];
        [self removeMovieNotificationObservers];
    });
}
@end
