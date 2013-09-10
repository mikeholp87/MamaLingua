//
//  PhrasesDetail.m
//  MamaLingua
//
//  Created by Mike Holp on 12/9/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import "PhrasesDetail.h"

#define kTabViewColor [UIColor colorWithRed:251/255.0 green:198/255.0 blue:146/255.0 alpha:1.000]
#define kSelectedTabColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:228/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:253/255.0 green:221/255.0 blue:185/255.0 alpha:1.000]

#define kSelectedLangColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kNormalLangColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.000]

@implementation PhrasesDetail
@synthesize english_singular, english_plural, english_pho, spanish_nofm, spanish_fm, spanish_plural, spanish_pho, primaryLbl, secondaryLbl, phoneticLbl, pluralLbl, langType, selectedTab;
@synthesize playBtn, forwardBtn, rewindBtn, slider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, 140, 36)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 140, 36)];
    [logo setImage:[UIImage imageNamed:@"mamalingua_logo.png"]];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 81.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 320.0, 40.0)];
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 81.0, 320.0, 15.0)];
        typeBtn.frame = CGRectMake(160.0, 42.0, 158.0, 50.0);
    }else{
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 81.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 768.0, 40.0)];
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 81.0, 768.0, 15.0)];
        typeBtn.frame = CGRectMake(440.0, 42.0, 320.0, 50.0);
    }
    
    [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    
    settings = [[NSUserDefaults alloc] init];
    
    if([selectedTab isEqualToString:@"Phrase"]){
        if([langType isEqualToString:@"English-Spanish"])
            [typeBtn setTitle:@"PHRASES" forState:UIControlStateNormal];
        else
            [typeBtn setTitle:@"FRASES" forState:UIControlStateNormal];
    }else{
        if([langType isEqualToString:@"English-Spanish"])
            [typeBtn setTitle:@"VOCABULARY" forState:UIControlStateNormal];
        else
            [typeBtn setTitle:@"VOCABULARIO" forState:UIControlStateNormal];
    }
    typeBtn.layer.cornerRadius = 15;
    
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
        [alphaLbl setText:@"ALPHABETICAL LIST"];
    else
        [alphaLbl setText:@"LISTA ALFABÉTICA"];
    [alphaLbl setTextAlignment:NSTextAlignmentCenter];
    [alphaLbl setTextColor:[UIColor blackColor]];
    [alphaLbl setBackgroundColor:[UIColor clearColor]];
    [alphaLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    
    [alphaView setBackgroundColor:kTabViewColor];
    [bottomView setBackgroundColor:kSelectedTabColor];
    [typeBtn setBackgroundColor:kSelectedTabColor];
    
    [self.view addSubview:alphaView];
    [alphaView addSubview:alphaLbl];
    [alphaView addSubview:bottomView];
    [alphaView addSubview:typeBtn];
    [alphaView bringSubviewToFront:typeBtn];
    [alphaView bringSubviewToFront:bottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self stopPlaying];
    
    [primaryLbl setTextColor:kNormalLangColor];
    [secondaryLbl setTextColor:kSelectedLangColor];
    
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
        [primaryLbl setText:spanish_fm];
        [secondaryLbl setText:english_singular];
        [phoneticLbl setText:spanish_pho];
        [pluralLbl setText:spanish_plural];
    }else{
        [primaryLbl setText:english_singular];
        [secondaryLbl setText:spanish_nofm];
        [phoneticLbl setText:english_pho];
        [pluralLbl setText:english_plural];
    }
    
    NSString *langName = [[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"] ? spanish_nofm : english_singular;
    langName = [langName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"%@", langName);
    
    audioFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3", [[NSBundle mainBundle] resourcePath], langName]];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFile error:nil];
    audioDuration = audioPlayer.duration;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 325, 300, 3)];
    else
        slider = [[UISlider alloc] initWithFrame:CGRectMake(35, 750, 700, 3)];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(setValue) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = audioDuration;
    
    slider.minimumValue = 0;
    slider.value = 0;
    [slider setThumbImage:[UIImage imageNamed:@"slider_button.png"] forState:UIControlStateNormal];
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed:@"slider_left_track.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    UIImage *sliderRightTrackImage = [[UIImage imageNamed:@"slider_right_track.png"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0];
    [slider setMinimumTrackImage: sliderLeftTrackImage forState: UIControlStateNormal];
    [slider setMaximumTrackImage: sliderRightTrackImage forState: UIControlStateNormal];
}

-(IBAction)playRecording
{
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:audioDuration target:self selector:@selector(stopPlaying) userInfo:nil repeats:NO];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
    [audioPlayer play];
    
    if(audioPlayer.isPlaying)
        [playBtn setEnabled:NO];

}

-(void)stopPlaying
{
    [timer invalidate];
    //[playBtn setImage:[UIImage imageNamed:@"mama_play.png"] forState:UIControlStateNormal];
    //[playBtn addTarget:self action:@selector(playRecording) forControlEvents:UIControlEventTouchUpInside];
    slider.value = 0;
    [audioPlayer stop];
    
    [playBtn setEnabled:YES];
}

-(void)updateSlider
{
    slider.value = audioPlayer.currentTime;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
