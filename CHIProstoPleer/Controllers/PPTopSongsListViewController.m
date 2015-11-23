//
//  PPTopSongsListViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 16.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPTopSongsListViewController.h"
#import "SessionManager.h"

@interface PPTopSongsListViewController ()  <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *topList;
@property (strong, nonatomic) NSArray *filteredList;

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
    
    self.title = @"Top songs list";
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] topSongsList:^(NSDictionary *topList, NSError *error) {
        
        weakSelf.topList = [topList allValues];
        [weakSelf.tableView reloadData];
    }];
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
    // Explictly set your cell's layout margins
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
@end
