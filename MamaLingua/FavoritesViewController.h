//
//  FavoritesViewController.h
//  MamaLingua
//
//  Created by Michael Holp on 2/14/13.
//  Copyright (c) 2013 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FavoritesDetail.h"

@interface FavoritesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSUserDefaults *settings;
    UIButton *favoriteBtn;
    
    UIButton *vocabBtn;
    UIButton *phraseBtn;
    
    UIView *alphaView;
    UIView *bottomView;
    UILabel *alphaLbl;
    
    NSString *selectedTab;
    
    NSMutableArray *selectedArray;
    NSMutableArray *favorites;
    
    bool isSearch;
    bool isFiltered;
}

@property (nonatomic, retain) IBOutlet UITableView *favoritesTable;
@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) NSArray *searchResults;

@property (nonatomic, retain) NSMutableDictionary *selectedFavorites;
@property (nonatomic, retain) NSMutableDictionary *vocab_favorites;
@property (nonatomic, retain) NSMutableDictionary *phrase_favorites;

@property (nonatomic, retain) NSMutableArray *selectedIndex;
@property (nonatomic, retain) NSMutableArray *vocab_indexes;
@property (nonatomic, retain) NSMutableArray *phrase_indexes;

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@end
