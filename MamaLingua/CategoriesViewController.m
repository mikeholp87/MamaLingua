//
//  CategoriesViewController.m
//  MamaLingua
//
//  Created by Mike Holp on 12/15/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import "CategoriesViewController.h"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

#define kTabViewColor [UIColor colorWithRed:251/255.0 green:198/255.0 blue:146/255.0 alpha:1.000]
#define kSelectedTabColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:228/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:253/255.0 green:221/255.0 blue:185/255.0 alpha:1.000]

@implementation CategoriesViewController
@synthesize searchBar, categories, categoryTable, category_favorites, searchResults, searchDisplayController;

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
    
    categoryTable.backgroundColor = kSelectedTabColor;
    
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 8.0, 320.0, 40.0)];
    }else{
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 81.0)];
        alphaLbl = [[UILabel alloc] initWithFrame:CGRectMake(320.0, 5.0, 698.0, 40.0)];
    }
    
    if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
        [alphaLbl setText:@"CATEGORIES"];
    else
        [alphaLbl setText:@"CATEGORÍAS"];
    
    [alphaLbl setTextColor:[UIColor blackColor]];
    [alphaLbl setTextAlignment:NSTextAlignmentCenter];
    [alphaLbl setBackgroundColor:[UIColor clearColor]];
    [alphaLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    
    categoryBtn.layer.cornerRadius = 15;
    
    [alphaView setBackgroundColor:kTabViewColor];
    
    [self.view addSubview:alphaView];
    [alphaView addSubview:alphaLbl];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://mama-lingua.com/API/mamalingua_api.php"]];
        [request setPostValue:@"true" forKey:@"use_category"];
        [request setPostValue:[settings objectForKey:@"LangType"] forKey:@"language"];
        [request setPostValue:@"fetch_vocab" forKey:@"cmd"];
        [request setDelegate:self];
        [request setTag:0];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
        return [searchResults count];
    else
        return [[categories objectForKey:@"categories"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (tableView == searchDisplayController.searchResultsTableView)
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    else{
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.tag = indexPath.row;
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFavorite:)];
        tapped.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:tapped];
        
        cell.textLabel.text = [[categories objectForKey:@"categories"] objectAtIndex:indexPath.row];
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
    CategoryDetail *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetail"];
    if (tableView == searchDisplayController.searchResultsTableView)
        [self.searchDisplayController setActive:NO animated:NO];
    
    detailView.category = [[categories objectForKey:@"categories"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)local_request
{
    NSString *jsonString = [local_request responseString];
    //NSLog(@"Refresh Response String is: %@",jsonString);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    categories = [[NSMutableDictionary alloc] init];
    [categories setDictionary:[parser objectWithString:jsonString error:NULL]];
    
    [categoryTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)local_request
{
    NSError *local_error = [local_request error];
    NSLog(@"%@",local_error.localizedDescription);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    searchResults = [[categories objectForKey:@"categories"] filteredArrayUsingPredicate:resultPredicate];
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
