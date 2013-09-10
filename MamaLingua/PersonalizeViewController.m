//
//  PersonalizeViewController.m
//  MamaLingua
//
//  Created by Mike Holp on 2/27/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import "PersonalizeViewController.h"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

#define kTabViewColor [UIColor colorWithRed:251/255.0 green:198/255.0 blue:146/255.0 alpha:1.000]
#define kSelectedTabColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:228/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:253/255.0 green:221/255.0 blue:185/255.0 alpha:1.000]

@implementation PersonalizeViewController

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
    [logo setImage:[UIImage imageNamed:@"mamalingua_logo.png.png"]];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSettings)];
    [self.navigationItem setLeftBarButtonItem:settingsBtn];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,nil] forState:UIControlStateHighlighted];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabViewColor, UITextAttributeTextColor, [UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTintColor:kNavTintColor];
    [self.navigationItem.rightBarButtonItem setTintColor:kNavTintColor];
    [self.tabBarController.tabBar setTintColor:kNavTintColor];
    [[UISearchBar appearance] setTintColor:kNavTintColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    settings = [[NSUserDefaults alloc] init];
    [self setTabTitle];
}

- (void)setTabTitle
{
    int tab=0;
    for(UIViewController *vc in [self.tabBarController viewControllers]){
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
            switch (tab) {
                case 0:
                    vc.title = @"Alphabetical";
                    break;
                case 1:
                    vc.title = @"Categories";
                    break;
                case 2:
                    vc.title = @"Favorites";
                    break;
                case 3:
                    vc.title = @"Personalize";
                    break;
                default:
                    break;
            }
        }else{
            switch (tab) {
                case 0:
                    vc.title = @"Alfabética";
                    break;
                case 1:
                    vc.title = @"Categorías";
                    break;
                case 2:
                    vc.title = @"Favoritos";
                    break;
                case 3:
                    vc.title = @"Personalizar";
                    break;
                default:
                    break;
            }
        }
        tab++;
    }
}

- (IBAction)sendTweet:(id)sender
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSURL *url = [NSURL URLWithString:@"www.mama-lingua.com"];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"Teach your children a foreign language. Download MamaLingua for free now! %@", url]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (IBAction)postStatus:(id)sender
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled)
                    NSLog(@"Cancelled");
                else
                    NSLog(@"Done");
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler = myBlock;
            
            [controller setInitialText:@"Teach your children a foreign language. Download MamaLingua for free now!"];
            [controller addURL:[NSURL URLWithString:@"www.mama-lingua.com"]];
            [controller addImage:[UIImage imageNamed:@"AppIcon.png"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else{
            NSLog(@"Unavailable");
        }
    }
}

-(void)ShowSettings
{
    UITableViewController *MamaSettings = [self.storyboard instantiateViewControllerWithIdentifier:@"MamaSettings"];
    [self.navigationController pushViewController:MamaSettings animated:YES];
}

@end
