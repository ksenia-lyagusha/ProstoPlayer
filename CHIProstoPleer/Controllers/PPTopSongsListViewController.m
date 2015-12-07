//
//  PPTopSongsListViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 16.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPTopSongsListViewController.h"
#import "PPMusicViewController.h"
#import "SessionManager.h"

#import "UIAlertController+Category.h"

@interface PPTopSongsListViewController ()  <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar    *searchBar;
@property (strong, nonatomic) NSMutableArray *topList;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSNumber       *count;
@property NSInteger currentPage;

@end
@implementation PPTopSongsListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITabBarItem *topSongsListTabBar = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
        
        self.tabBarItem = topSongsListTabBar;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.topList = [NSMutableArray array];
    
    self.currentPage = 1;
    [self refrashTableView:self.currentPage];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refrash:) forControlEvents:UIControlEventValueChanged];
    
    self.topList = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.parentViewController.tabBarController.title = @"Top songs list";
    self.parentViewController.tabBarController.navigationItem.hidesBackButton = YES;
}

#pragma mark - TableViewDataSource and TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredList)
    {
        return [self.filteredList count];
    }
    else
    {
        return [self.topList count];
    }
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *value;
    if (self.filteredList)
    {
       value = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        value = [self.topList objectAtIndex:indexPath.row];

    }
    
    cell.textLabel.text = [value objectForKey:@"artist"];
    cell.detailTextLabel.text = [value objectForKey:@"track"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topList.count - 10 == indexPath.row) {
        self.currentPage += 1;
        [self refrashTableView:self.currentPage];
    }
    
    // for ios 8 and later
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // for ios 7
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPMusicViewController *musicVC = [[PPMusicViewController alloc] init];
    musicVC.topList = self.topList;
    musicVC.index = indexPath.row;
    [self.navigationController pushViewController:musicVC animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBar.text length] > 0) {
        [self doSearch];
    } else {
        self.filteredList = self.topList;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    // Clear search bar text
    self.searchBar.text = @"";
    self.filteredList = nil;
    // Hide the cancel button
    self.searchBar.showsCancelButton = NO;
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self doSearch];
}

- (void)doSearch
{
    // 1. Get the text from the search bar.
    NSString *searchText = self.searchBar.text;
    
    self.filteredList = [NSMutableArray arrayWithArray:[self.topList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"artist contains[c] %@", searchText]]];
    
    // 3. Reload the table to show the query results.
    [self.tableView reloadData];
}

- (void)refrash:(id)sender
{
    [self.refreshControl beginRefreshing];
    [self reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.refreshControl endRefreshing];
    });
    
}

- (void)reloadData
{
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        self.currentPage = 1;
        self.topList = nil;
        [self refrashTableView:self.currentPage];
        
    }
}

- (void)refrashTableView:(NSInteger)page
{
//     dispatch_async(dispatch_get_main_queue(), ^{
//         //все userInterface методы делать в главном потоке (типа reloadData)
//     });
//    
    if ([self.topList count] && [self.topList count] >= [self.count integerValue])
    {
        UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"No more tracks", nil)];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] topSongsListForPage:page withComplitionHandler:^(NSDictionary *topList, NSError *error) {
        
       
        NSDictionary *values = [topList objectForKey:@"data"];
        NSArray *innerArray = [values allValues];
        
        self.count = [topList objectForKey:@"count"];
        
        if (weakSelf.topList)
        {
            [weakSelf.topList addObjectsFromArray:innerArray];
            [weakSelf.tableView reloadData];
        }
        else
        {
            weakSelf.topList = [[NSMutableArray arrayWithArray:innerArray] mutableCopy];
        }
            
    }];
}
@end

