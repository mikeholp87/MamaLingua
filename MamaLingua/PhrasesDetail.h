//
//  PhrasesDetail.h
//  MamaLingua
//
//  Created by Mike Holp on 12/9/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface PhrasesDetail : UIViewController
{
    NSUserDefaults *settings;
    AVAudioPlayer *audioPlayer;
    UIButton *playBtn;
    NSTimer *timer;
    NSURL *audioFile;
    
    UIView *alphaView;
    UIView *bottomView;
    UILabel *alphaLbl;
    
    float audioDuration;
}

@property(nonatomic,retain) NSString *english_singular;
@property(nonatomic,retain) NSString *english_plural;
@property(nonatomic,retain) NSString *english_pho;
@property(nonatomic,retain) NSString *spanish_fm;
@property(nonatomic,retain) NSString *spanish_nofm;
@property(nonatomic,retain) NSString *spanish_plural;
@property(nonatomic,retain) NSString *spanish_pho;
@property(nonatomic,retain) NSString *langType;
@property(nonatomic,retain) NSString *selectedTab;

@property(nonatomic,retain) IBOutlet UILabel *primaryLbl;
@property(nonatomic,retain) IBOutlet UILabel *secondaryLbl;
@property(nonatomic,retain) IBOutlet UILabel *phoneticLbl;
@property(nonatomic,retain) IBOutlet UILabel *pluralLbl;

@property(nonatomic,retain) IBOutlet UISlider *slider;

@property(nonatomic,retain) IBOutlet UIButton *playBtn;
@property(nonatomic,retain) IBOutlet UIButton *rewindBtn;
@property(nonatomic,retain) IBOutlet UIButton *forwardBtn;

@end
