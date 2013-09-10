//
//  RootTabController.m
//  MamaLingua
//
//  Created by Michael Holp on 4/5/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import "RootTabController.h"

@implementation RootTabController

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
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = appDelegate;
}

@end
