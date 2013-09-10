//
//  CategoryDetail.m
//  MamaLingua
//
//  Created by Mike Holp on 12/15/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import "CategoryDetail.h"

#define kNavTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]
#define kTabTintColor [UIColor colorWithRed:35/255.0 green:153/255.0 blue:151/255.0 alpha:1.000]

#define kTabViewColor [UIColor colorWithRed:251/255.0 green:198/255.0 blue:146/255.0 alpha:1.000]
#define kSelectedTabColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:228/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:253/255.0 green:221/255.0 blue:185/255.0 alpha:1.000]

@implementation CategoryDetail
@synthesize searchBar, vocabulary, category, categoryTable, searchResults, searchDisplayController, vocab_favorites, phrase_favorites, vocab_indexes, phrase_indexes;

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
    
    categoryTable.backgroundColor = kSelectedTabColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    settings = [[NSUserDefaults alloc] init];
    
    vocab_favorites = [[settings objectForKey:@"vocab_favorites"] mutableCopy];
    vocab_indexes = [[settings objectForKey:@"vocab_indexes"] mutableCopy];
    phrase_favorites = [[settings objectForKey:@"phrase_favorites"] mutableCopy];
    phrase_indexes = [[settings objectForKey:@"phrase_indexes"] mutableCopy];
    
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
    
    [alphaLbl setText:category];
    
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
    
    vocabulary = [[NSMutableDictionary alloc] init];
    searchResults = [[NSMutableDictionary alloc] init];
    
    if(selectedTab == nil)
        selectedTab = @"vocabulary";
    
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://mama-lingua.com/API/mamalingua_api.php"]];
        [request setPostValue:category forKey:@"category"];
        [request setPostValue:selectedTab forKey:@"genre"];
        [request setPostValue:[settings objectForKey:@"LangType"] forKey:@"language"];
        [request setPostValue:@"fetch_vocab" forKey:@"cmd"];
        [request setDelegate:self];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)chooseTab:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://mama-lingua.com/API/mamalingua_api.php"]];
        [request setPostValue:[settings objectForKey:@"LangType"] forKey:@"language"];
        [request setPostValue:category forKey:@"category"];
        [request setPostValue:selectedTab forKey:@"genre"];
        [request setPostValue:@"fetch_vocab" forKey:@"cmd"];
        [request setDelegate:self];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(((UIControl*)sender).tag == 0){
                selectedTab = @"phrases";
                [vocabBtn setSelected:NO];
                [phraseBtn setSelected:YES];
                [phraseBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
                [phraseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [vocabBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
                [vocabBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                [request setPostValue:selectedTab forKey:@"genre"];
            }else{
                selectedTab = @"vocabulary";
                [phraseBtn setSelected:NO];
                [vocabBtn setSelected:YES];
                [vocabBtn setBackgroundImage:[UIImage imageNamed:@"selected_tab.png"] forState:UIControlStateSelected];
                [vocabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [phraseBtn setBackgroundImage:[UIImage imageNamed:@"normal_tab.png"] forState:UIControlStateNormal];
                [phraseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                [request setPostValue:selectedTab forKey:@"genre"];
            }
            
            [settings setObject:selectedTab forKey:@"selected_tab"];
            [settings synchronize];
            
            [request startAsynchronous];
        });
    });
}

#pragma mark - TABLEVIEW DELEGATE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
            return [[searchResults objectForKey:@"english_singulars"] count];
        else
            return [[searchResults objectForKey:@"spanish_nofm"] count];
    else
        return genreCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (tableView == searchDisplayController.searchResultsTableView){
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
            cell.textLabel.text = [[searchResults objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[searchResults objectForKey:@"spanish_nofm"] objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [[searchResults objectForKey:@"spanish_nofm"] objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[searchResults objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
        }
    }else{
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.tag = indexPath.row;
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFavorite:)];
        tapped.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:tapped];
        
        if([selectedTab isEqualToString:@"vocabulary"] && [vocab_favorites objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]])
            cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        else if([selectedTab isEqualToString:@"phrases"] && [phrase_favorites objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]])
            cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
        
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"]){
            cell.textLabel.text = [[vocabulary objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[vocabulary objectForKey:@"spanish_fm"] objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [[vocabulary objectForKey:@"spanish_nofm"] objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[vocabulary objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
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
    CategoryExtra *categoryExtra = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryExtra"];
    
    if (tableView == searchDisplayController.searchResultsTableView){
        [self.searchDisplayController setActive:NO animated:NO];
        
        categoryExtra.english_singular = [[searchResults objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
        categoryExtra.english_plural = [[searchResults objectForKey:@"english_plurals"] objectAtIndex:indexPath.row];
        categoryExtra.english_pho = [[searchResults objectForKey:@"english_phonetics"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_nofm = [[searchResults objectForKey:@"spanish_nofm"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_fm = [[searchResults objectForKey:@"spanish_fm"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_plural = [[searchResults objectForKey:@"spanish_plurals"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_pho = [[searchResults objectForKey:@"spanish_phonetics"] objectAtIndex:indexPath.row];
    }else{
        categoryExtra.english_singular = [[vocabulary objectForKey:@"english_singulars"] objectAtIndex:indexPath.row];
        categoryExtra.english_plural = [[vocabulary objectForKey:@"english_plurals"] objectAtIndex:indexPath.row];
        categoryExtra.english_pho = [[vocabulary objectForKey:@"english_phonetics"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_fm = [[vocabulary objectForKey:@"spanish_fm"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_nofm = [[vocabulary objectForKey:@"spanish_nofm"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_plural = [[vocabulary objectForKey:@"spanish_plurals"] objectAtIndex:indexPath.row];
        categoryExtra.spanish_pho = [[vocabulary objectForKey:@"spanish_phonetics"] objectAtIndex:indexPath.row];
    }
    categoryExtra.langType = [settings objectForKey:@"LangType"];
    if([selectedTab isEqualToString:@"phrases"]){
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
            categoryExtra.selectedTab = @"Phrases";
        else
            categoryExtra.selectedTab = @"Frases";
    }else{
        if([[settings objectForKey:@"LangType"] isEqualToString:@"English-Spanish"])
            categoryExtra.selectedTab = @"Vocabulary";
        else
            categoryExtra.selectedTab = @"Vocabulario";
    }
    categoryExtra.category = category;
    
    [self.navigationController pushViewController:categoryExtra animated:YES];
}

- (void)addFavorite:(id)sender
{
    if(vocab_favorites == nil)
        vocab_favorites = [[NSMutableDictionary alloc] init];
    if(phrase_favorites == nil)
        phrase_favorites = [[NSMutableDictionary alloc] init];
    if(phrase_indexes == nil)
        phrase_indexes = [[NSMutableArray alloc] init];
    if(vocab_indexes == nil)
        vocab_indexes = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UITableViewCell *cell = [categoryTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:gesture.view.tag inSection:0]];
    
    NSArray *array = [NSArray arrayWithObjects:[[vocabulary objectForKey:@"english_singulars"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"english_plurals"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"english_phonetics"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"spanish_fm"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"spanish_nofm"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"spanish_plurals"] objectAtIndex:gesture.view.tag], [[vocabulary objectForKey:@"spanish_phonetics"] objectAtIndex:gesture.view.tag], selectedTab, nil];
    
    if([selectedTab isEqualToString:@"vocabulary"] && cell.imageView.image == [UIImage imageNamed:@"star_on.png"]){
        cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
        [vocab_favorites removeObjectForKey:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [vocab_indexes removeObject:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [settings setObject:vocab_indexes forKey:@"vocab_indexes"];
    }else if([selectedTab isEqualToString:@"vocabulary"] && cell.imageView.image == [UIImage imageNamed:@"star_off.png"]){
        cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        [vocab_favorites setObject:array forKey:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [vocab_indexes addObject:[NSString stringWithFormat:@"%d", gesture.view.tag]];
        [settings setObject:vocab_indexes forKey:@"vocab_indexes"];
    }else if([selectedTab isEqualToString:@"phrases"] && cell.imageView.image == [UIImage imageNamed:@"star_on.png"]){
        cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
        [phrase_favorites removeObjectForKey:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [phrase_indexes removeObject:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [settings setObject:phrase_indexes forKey:@"phrase_indexes"];
    }else if([selectedTab isEqualToString:@"phrases"] && cell.imageView.image == [UIImage imageNamed:@"star_off.png"]){
        cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        [phrase_favorites setObject:array forKey:[NSString stringWithFormat:@"%d",gesture.view.tag]];
        [phrase_indexes addObject:[NSString stringWithFormat:@"%d", gesture.view.tag]];
        [settings setObject:phrase_indexes forKey:@"phrase_indexes"];
    }
    
    [settings setObject:vocab_favorites forKey:@"vocab_favorites"];
    [settings setObject:phrase_favorites forKey:@"phrase_favorites"];
    [settings synchronize];
}

- (void)requestFinished:(ASIHTTPRequest *)local_request
{
    NSString *jsonString = [local_request responseString];
    //NSLog(@"Refresh Response String is: %@",jsonString);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if(local_request.tag == 0)
        [vocabulary setDictionary:[parser objectWithString:jsonString error:NULL]];
    else if(local_request.tag == 1)
        [searchResults setDictionary:[parser objectWithString:jsonString error:NULL]];
    
    genreCnt = [[vocabulary objectForKey:@"genres"] intValue];
    
    [categoryTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)local_request
{
    NSError *local_error = [local_request error];
    NSLog(@"%@",local_error.localizedDescription);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://mama-lingua.com/API/mamalingua_api.php"]];
    [request setPostValue:@"true" forKey:@"both"];
    [request setPostValue:[settings objectForKey:@"LangType"] forKey:@"language"];
    [request setPostValue:searchText forKey:@"search_text"];
    [request setPostValue:@"fetch_vocab" forKey:@"cmd"];
    [request setDelegate:self];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTag:1];
    [request startAsynchronous];
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
