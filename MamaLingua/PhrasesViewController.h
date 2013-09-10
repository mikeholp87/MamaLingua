//
//  PhrasesViewController.h
//  MamaLingua
//
//  Created by Mike Holp on 12/15/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "PhrasesDetail.h"
#import "Reachability.h"
#import "MamaSettings.h"
#import "DataGenerator.h"
#import "MBProgressHUD.h"

@interface PhrasesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSUserDefaults *settings;
    
    NSInteger oldSection;
    NSInteger curIndex;
    
    UIButton *vocabBtn;
    UIButton *phraseBtn;
    
    UIView *alphaView;
    NSArray *content;
    NSArray *indices;
    NSArray *detailedSearch;
    
    UILabel *alphaLbl;
    UIView *bottomView;
    
    bool isSearch;
    bool isFiltered;
    NSString *selectedTab;
    NSInteger genreCnt;
}

@property (nonatomic, retain) IBOutlet UITableView *alphaTable;
@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableDictionary *vocab_favorites;
@property (nonatomic, retain) NSMutableDictionary *phrase_favorites;
@property (nonatomic, retain) NSMutableArray *vocab_indexes;
@property (nonatomic, retain) NSMutableArray *phrase_indexes;
@property (nonatomic, retain) NSMutableDictionary *vocabulary;
@property (nonatomic, retain) NSMutableDictionary *searchResults;
@property (nonatomic, retain) NSMutableDictionary *alphabet;

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@end
