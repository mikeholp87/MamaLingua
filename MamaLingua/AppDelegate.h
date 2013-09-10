//
//  AppDelegate.h
//  MamaLingua
//
//  Created by Michael Holp on 12/1/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSUserDefaults *settings;
}

@property (strong, nonatomic) UIWindow *window;

@end
