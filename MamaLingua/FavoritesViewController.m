//
//  FavoritesViewController.m
//  MamaLingua
//
//  Created by Michael Holp on 2/14/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import "FavoritesViewController.h"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

#define kTabViewColor [UIColor colorWithRed:251/255.0 green:198/255.0 blue:146/255.0 alpha:1.000]
#define kSelectedTabColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:228/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:253/255.0 green:221/255.0 blue:185/255.0 alpha:1.000]

@implementation FavoritesViewController
@synthesize searchBar, vocab_favorites, phrase_favorites, phrase_indexes, vocab_indexes, favoritesTable, searchResults, selectedFavorites, selectedIndex, searchDisplayController;

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
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar)];
    [self.navigationItem setRightBarButtonItem:searchBtn];
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSettings)];
    [self.navigationItem setLeftBarButtonItem:settingsBtn];
    
    favoritesTable.backgroundColor = kSelectedTabColor;
    
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
    
    phraseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vocabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 81.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 320.0, 40.0)];
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 81.0, 320.0, 15.0)];
        phraseBtn.frame = CGRectMake(160.0, 42.0, 158, 50.0);
        vocabBtn.frame = CGRectMake(2.0, 42.0, 158, 50.0);
    }else{
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 81.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(320.0, 5.0, 698.0, 40.0)];
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 81.0, 768.0, 15.0)];
        phraseBtn.frame = CGRectMake(384.0, 42.0, 382.0, 50.0);
        vocabBtn.frame = CGRectMake(2.0, 42.0, 382.0, 50.0);
    }
    
    [phraseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    phraseBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
        [phraseBtn setTitle:@"PHRASES" forState:UIControlStateNormal];
    else
        [phraseBtn setTitle:@"FRASES" forState:UIControlStateNormal];
    [phraseBtn addTarget:self action:@selector(chooseTab:) forControlEvents:UIControlEventTouchUpInside];
    [phraseBtn setTag:0];
    phraseBtn.layer.cornerRadius = 15;
    
    [vocabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    vocabBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
        [vocabBtn setTitle:@"VOCABULARY" forState:UIControlStateNormal];
    else
        [vocabBtn setTitle:@"VOCABULARIO" forState:UIControlStateNormal];
    [vocabBtn addTarget:self action:@selector(chooseTab:) forControlEvents:UIControlEventTouchUpInside];
    [vocabBtn setTag:1];
    vocabBtn.layer.cornerRadius = 15;
    
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
        self.title = @"Favorites";
        [alphaLbl setText:@"FAVORITES"];
    }else{
        self.title = @"Favoritos";
        [alphaLbl setText:@"FAVORITOS"];
    }
    [alphaLbl setTextColor:[UIColor blackColor]];
    [alphaLbl setTextAlignment:NSTextAlignmentCenter];
    [alphaLbl setBackgroundColor:[UIColor clearColor]];
    [alphaLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    
    [alphaView setBackgroundColor:kTabViewColor];
    [bottomView setBackgroundColor:kSelectedTabColor];
    [phraseBtn setBackgroundColor:kSelectedTabColor];
    
    [self.view addSubview:alphaView];
    [alphaView addSubview:alphaLbl];
    [alphaView addSubview:bottomView];
    [alphaView addSubview:phraseBtn];
    [alphaView addSubview:vocabBtn];
    [alphaView bringSubviewToFront:phraseBtn];
    [alphaView bringSubviewToFront:vocabBtn];
    [alphaView bringSubviewToFront:bottomView];
    
    selectedTab = [settings objectForKey:@"selected_tab"];
    
    vocab_favorites = [[settings objectForKey:@"vocab_favorites"] mutableCopy];
    vocab_indexes = [[settings objectForKey:@"vocab_indexes"] mutableCopy];
    phrase_favorites = [[settings objectForKey:@"phrase_favorites"] mutableCopy];
    phrase_indexes = [[settings objectForKey:@"phrase_indexes"] mutableCopy];
    
    selectedFavorites = [selectedTab isEqualToString:@"vocabulary"] ? vocab_favorites : phrase_favorites;
    selectedIndex = [selectedTab isEqualToString:@"vocabulary"] ? vocab_indexes : phrase_indexes;
    
    favorites = [[NSMutableArray alloc] init];
    
    if(selectedTab == nil)
        selectedTab = @"phrases";
    
    if([selectedTab isEqualToString:@"phrases"]){
        [vocabBtn setSelected:NO];
        [phraseBtn setSelected:YES];
        [phraseBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
        [phraseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [vocabBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
        [vocabBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else{
        [phraseBtn setSelected:NO];
        [vocabBtn setSelected:YES];
        [vocabBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
        [vocabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [phraseBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
        [phraseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    [favoritesTable reloadData];
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

- (void)chooseTab:(id)sender
{
    if(((UIControl*)sender).tag == 0){
        selectedTab = @"phrases";
        [vocabBtn setSelected:NO];
        [phraseBtn setSelected:YES];
        [phraseBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
        [phraseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [vocabBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
        [vocabBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else{
        selectedTab = @"vocabulary";
        [phraseBtn setSelected:NO];
        [vocabBtn setSelected:YES];
        [vocabBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
        [vocabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [phraseBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
        [phraseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    selectedFavorites = [selectedTab isEqualToString:@"vocabulary"] ? vocab_favorites : phrase_favorites;
    
    [settings setObject:selectedTab forKey:@"selected_tab"];
    [settings synchronize];
    
    [favoritesTable reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
        return [searchResults count];
    else
        return [[selectedFavorites allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (tableView == searchDisplayController.searchResultsTableView)
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    else{
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.tag = indexPath.row;
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFavorite:)];
        tapped.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:tapped];
        
        cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
            if([selectedTab isEqualToString:@"phrases"]){
                cell.textLabel.text = [[selectedFavorites objectForKey:[phrase_indexes objectAtIndex:indexPath.row]] objectAtIndex:0];
                cell.detailTextLabel.text = [[selectedFavorites objectForKey:[phrase_indexes objectAtIndex:indexPath.row]] objectAtIndex:3];
            }else{
                cell.textLabel.text = [[selectedFavorites objectForKey:[vocab_indexes objectAtIndex:indexPath.row]] objectAtIndex:0];
                cell.detailTextLabel.text = [[selectedFavorites objectForKey:[vocab_indexes objectAtIndex:indexPath.row]] objectAtIndex:3];
            }
        }else{
            if([selectedTab isEqualToString:@"phrases"]){
                cell.textLabel.text = [[selectedFavorites objectForKey:[phrase_indexes objectAtIndex:indexPath.row]] objectAtIndex:3];
                cell.detailTextLabel.text = [[selectedFavorites objectForKey:[phrase_indexes objectAtIndex:indexPath.row]] objectAtIndex:0];
            }else{
                cell.textLabel.text = [[selectedFavorites objectForKey:[vocab_indexes objectAtIndex:indexPath.row]] objectAtIndex:3];
                cell.detailTextLabel.text = [[selectedFavorites objectForKey:[vocab_indexes objectAtIndex:indexPath.row]] objectAtIndex:0];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = kSelectedTabColor;
    }else{
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = kNormalTabColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoritesDetail *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesDetail"];
    
    selectedIndex = [selectedTab isEqualToString:@"vocabulary"] ? vocab_indexes : phrase_indexes;
    
    if (tableView == searchDisplayController.searchResultsTableView){
        [self.searchDisplayController setActive:NO animated:NO];
        
        detailView.english_singular = [searchResults objectAtIndex:0];
        /*
        detailView.english_plural = [searchResults objectAtIndex:1];
        detailView.english_pho = [searchResults objectAtIndex:2];
        detailView.spanish_fm = [searchResults objectAtIndex:3];
        detailView.spanish_nofm = [searchResults objectAtIndex:4];
        detailView.spanish_plural = [searchResults objectAtIndex:5];
        detailView.spanish_pho = [searchResults objectAtIndex:6];
        detailView.selectedTab = [searchResults objectAtIndex:7];
        detailView.langType = [settings objectForKey:@"LangType"];
        */
    }else{
        detailView.english_singular = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:0];
        detailView.english_plural = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:1];
        detailView.english_pho = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:2];
        detailView.spanish_fm = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:3];
        detailView.spanish_nofm = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:4];
        detailView.spanish_plural = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:5];
        detailView.spanish_pho = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:6];
        detailView.selectedTab = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:indexPath.row]] objectAtIndex:7];
        detailView.langType = [settings objectForKey:@"LangType"];
    }
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)removeFavorite:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    
    selectedIndex = [selectedTab isEqualToString:@"vocabulary"] ? vocab_indexes : phrase_indexes;
    
    if([selectedTab isEqualToString:@"vocabulary"]){
        [selectedFavorites removeObjectForKey:[selectedIndex objectAtIndex:gesture.view.tag]];
        [vocab_indexes removeObject:[selectedIndex objectAtIndex:gesture.view.tag]];
        [settings setObject:selectedIndex forKey:@"vocab_indexes"];
        [settings setValue:selectedFavorites forKey:@"vocab_favorites"];
    }else{
        [selectedFavorites removeObjectForKey:[selectedIndex objectAtIndex:gesture.view.tag]];
        [phrase_indexes removeObject:[selectedIndex objectAtIndex:gesture.view.tag]];
        [settings setObject:selectedIndex forKey:@"phrase_indexes"];
        [settings setValue:selectedFavorites forKey:@"phrase_favorites"];
    }
        
    [settings synchronize];
    
    [favoritesTable reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    NSLog(@"%@", selectedFavorites);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i=0; i<[[selectedFavorites allKeys] count]; i++){
        NSString *match = [[selectedFavorites objectForKey:[selectedIndex objectAtIndex:i]] objectAtIndex:0];
        [array addObject:match];
    }
    
    searchResults = [array filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.hidden = YES;
}

-(void)showSearchBar
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 38.0)];
    searchBar.delegate = self;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    [alphaView addSubview:searchBar];
    [searchBar becomeFirstResponder];
}

-(void)ShowSettings
{
    UITableViewController *MamaSettings = [self.storyboard instantiateViewControllerWithIdentifier:@"MamaSettings"];
    [self.navigationController pushViewController:MamaSettings animated:YES];
}

-(NSString *)saveFilePath:(NSString *)pathName{
    NSArray *path =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[path objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",pathName]];
}

@end
