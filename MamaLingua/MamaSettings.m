//
//  MamaSettings.m
//  MamaLingua
//
//  Created by Mike Holp on 12/30/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import "MamaSettings.h"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

@implementation MamaSettings

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Settings";
    self.clearsSelectionOnViewWillAppear = YES;
    
    [[UINavigationBar appearance] setTintColor:kNavTintColor];
    self.navigationItem.leftBarButtonItem.tintColor = kNavTintColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    settings = [[NSUserDefaults alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0) {
        if([settings objectForKey:@"LangType"] == nil || [[settings objectForKey:@"LangType"] isKindOfClass:[NSNull class]]){
            if (indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                langIndexPath = indexPath;
            }
        }
        if (indexPath.row == 0)
            cell.textLabel.text = @"English-Spanish";
        else if (indexPath.row == 1)
            cell.textLabel.text = @"Español-Inglés";
        
        if([cell.textLabel.text isEqualToString:[settings objectForKey:@"LangType"]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            langIndexPath = indexPath;
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if (!langIndexPath) {
            langIndexPath = indexPath;
        }
        
        if ([langIndexPath row] != [indexPath row])
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:langIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            [settings setObject:newCell.textLabel.text forKey:@"LangType"];
            
            langIndexPath = indexPath;
        }
        else {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [settings setObject:newCell.textLabel.text forKey:@"LangType"];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [settings synchronize];
    }
}

@end
