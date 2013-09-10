//
//  CategoryDetail.h
//  MamaLingua
//
//  Created by Mike Holp on 12/15/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "PhrasesViewController.h"
#import "CategoryExtra.h"

@interface CategoryDetail : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSUserDefaults *settings;
    UIButton *categoryBtn;
    
    UIButton *vocabBtn;
    UIButton *phraseBtn;
    
    UIView *alphaView;
    NSArray *content;
    NSArray *indices;
    NSArray *detailedSearch;
    
    UILabel *alphaLbl;
    UIView *bottomView;
    
    bool isSearch, isFiltered;
    NSInteger genreCnt;
    NSString *selectedTab;
}

@property (nonatomic, retain) IBOutlet UITableView *categoryTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSString *category;

@property (nonatomic, retain) NSMutableDictionary *vocabulary;
@property (nonatomic, retain) NSMutableDictionary *vocab_favorites;
@property (nonatomic, retain) NSMutableDictionary *phrase_favorites;
@property (nonatomic, retain) NSMutableArray *vocab_indexes;
@property (nonatomic, retain) NSMutableArray *phrase_indexes;
@property (nonatomic, retain) NSMutableDictionary *searchResults;

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@end
