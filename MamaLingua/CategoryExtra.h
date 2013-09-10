//
//  CategoryExtra.h
//  MamaLingua
//
//  Created by Michael Holp on 2/14/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CategoryExtra : UIViewController
{
    NSUserDefaults *settings;
    AVAudioPlayer *audioPlayer;
    UIButton *playBtn;
    NSTimer *timer;
    
    UIButton *englishBtn;
    UIButton *spanishBtn;
    
    UIView *alphaView;
    UIView *bottomView;
    UILabel *alphaLbl;
    
    NSURL *audioFile;
    NSString *seletedTab;
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
@property(nonatomic,assign) NSString *category;
@property(nonatomic,assign) NSString *selectedTab;

@property(nonatomic,retain) IBOutlet UILabel *primaryLbl;
@property(nonatomic,retain) IBOutlet UILabel *secondaryLbl;
@property(nonatomic,retain) IBOutlet UILabel *phoneticLbl;
@property(nonatomic,retain) IBOutlet UILabel *pluralLbl;

@property(nonatomic,retain) IBOutlet UISlider *slider;

@property(nonatomic,retain) IBOutlet UIButton *playBtn;
@property(nonatomic,retain) IBOutlet UIButton *rewindBtn;
@property(nonatomic,retain) IBOutlet UIButton *forwardBtn;

@end
