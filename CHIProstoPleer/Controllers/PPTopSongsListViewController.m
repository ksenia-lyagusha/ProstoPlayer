//
//  PPTopSongsListViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 16.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPTopSongsListViewController.h"
#import "PPMusicViewController.h"

#import "UIAlertController+Category.h"
#import "ProstoPleerProtocols.h"

#import "SessionManager.h"
#import "Track.h"
#import "TrackInfo.h"
#import "CoreDataManager.h"

@interface PPTopSongsListViewController ()  <UISearchBarDelegate, PPTopSongsListViewControllerDelegate>

@property (strong, nonatomic) UISearchBar    *searchBar;
@property (strong, nonatomic) NSMutableArray *topList;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSNumber       *count;

@property NSInteger currentIndex;
@property NSInteger currentPage;

@property (strong, nonatomic) PPMusicViewController *musicVC;

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

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 40)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.topList = [NSMutableArray array];
    
    self.currentPage = 1;
    [self refreshTableView:self.currentPage withComplitionHandler:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.topList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetNotReachable:) name:PPSessionManagerInternetConnectionLost object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.title = @"Top songs list";
    self.tabBarController.navigationItem.hidesBackButton = YES;
    [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
    }
    id <PPTrackInfoProtocol>value;
    if (self.filteredList)
    {
        value = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        value = [self.topList objectAtIndex:indexPath.row];
        
    }
    
//    UIButton *favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 43)];
//    [favoriteButton setImage:[UIImage imageNamed:@"favorite-outline"] forState:UIControlStateNormal];
//    [favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateSelected];
//    [favoriteButton addTarget:self action:@selector(addToFavoritesAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.accessoryView = favoriteButton;
//    favoriteButton.tag = indexPath.row;
//    favoriteButton.userInteractionEnabled = YES;
    
    cell.textLabel.text = value.artist;
    cell.detailTextLabel.text = value.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    Track *trackObj = [Track objectWithTrackID:value.track_id];
    
//    favoriteButton.selected = trackObj != nil;

    [cell setPreservesSuperviewLayoutMargins:NO];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topList.count - 10 == indexPath.row) {
        self.currentPage += 1;
        [self refreshTableView:self.currentPage withComplitionHandler:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.musicVC = [[PPMusicViewController alloc] init];
    self.musicVC.info = self.filteredList ? [self.filteredList objectAtIndex:indexPath.row] : [self.topList objectAtIndex:indexPath.row];
    self.musicVC.delegate = self;
    self.musicVC.index = indexPath.row;
    
    self.currentIndex  = indexPath.row;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:self.musicVC animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBar.text length] > 0)
    {
        [self doSearch];
    } else
    {
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

#pragma mark - Private methods

- (void)refresh:(id)sender
{
    if (self.refreshControl)
    {
        [self.refreshControl beginRefreshing];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        self.currentPage = 1;
        self.topList = nil;
        
        __weak typeof(self) weakSelf = self;
        [self refreshTableView:self.currentPage withComplitionHandler:^ {
              
            [weakSelf.refreshControl endRefreshing];
 
        }];
    }
}

- (void)refreshTableView:(NSInteger)page withComplitionHandler:(void(^)(void))complitionHandler
{
    if ([self.topList count] && [self.topList count] >= [self.count integerValue])
    {
        UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"No more tracks", nil)];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] topSongsListForPage:page withComplitionHandler:^(NSDictionary *topList, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSDictionary *values = [topList objectForKey:@"data"];
           
            NSArray *tracks = [TrackInfo trackDescription:values];
           
            self.count = [topList objectForKey:@"count"];
            
            if (weakSelf.topList)
            {
                [weakSelf.topList addObjectsFromArray:tracks];
            }
            else
            {
                weakSelf.topList = [tracks mutableCopy];
                
                if(complitionHandler)
                {
                    complitionHandler();
                }
            }
        
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - Reachability

- (void)internetNotReachable:(NSNotification *)notification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NoInternet", nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    [alert addAction:closeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - PPTopSongsListViewControllerDelegate

- (id <PPTrackInfoProtocol>)topSongsList:(PPTrackDirection)direction
{
   id <PPTrackInfoProtocol>song;
    NSArray *choise = self.filteredList ? self.filteredList : self.topList;
    
    switch (direction) {
        case PPTrackDirectionFastForward:
        {
            if (choise.count -1 == self.currentIndex) {
                song = [choise firstObject];
                self.currentIndex = 0;
                break;
            }
            song = [choise objectAtIndex:self.currentIndex +1];
            self.currentIndex += 1;
            break;
        }
        case PPTrackDirectionFastRewind:
        {
            if (self.currentIndex == 0) {
                song = [choise firstObject];
                break;
            }
            song = [choise objectAtIndex:self.currentIndex -1];
            self.currentIndex -= 1;
            break;
        }
        default:
            break;
    }
   
    return song;
}

#pragma mark - Actions methods

//- (void)addToFavoritesAction:(UIButton *)sender
//{
//    id <PPTrackInfoProtocol>value = [self.topList objectAtIndex:sender.tag];
//    Track *trackObj = [Track objectWithTrackID:value.track_id];
//    
//    NSString *login = [[CoreDataManager sharedInstanceCoreData] currentUserLogin];
//    User *currentUser = [User objectWithLogin:login];
//    
//    if (sender.selected)
//    {
//        [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] deleteObject:trackObj];
//        sender.selected = NO;
//    }
//    else
//    {
//        Track *trackObj = [[CoreDataManager sharedInstanceCoreData] addNewTrack];
//        [trackObj createTrackWithTrackInfoObject:value];
//
//        [currentUser addTracksObject:trackObj];
//        
//        sender.selected = YES;
//        
//    }
//
//    [[CoreDataManager sharedInstanceCoreData] saveContext];
//}

@end

