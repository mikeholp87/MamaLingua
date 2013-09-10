//
//  CategoriesViewController.h
//  MamaLingua
//
//  Created by Mike Holp on 12/15/12.
//  Copyright (c) 2012 Holp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "PhrasesViewController.h"
#import "CategoryDetail.h"

@interface CategoriesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSUserDefaults *settings;
    UIButton *categoryBtn;
    
    UIView *alphaView;
    UIView *bottomView;
    UILabel *alphaLbl;
    
    bool isSearch;
    bool isFiltered;
    NSInteger catCnt;
}

@property (nonatomic, retain) IBOutlet UITableView *categoryTable;
@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) NSMutableDictionary *category_favorites;

@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@end
