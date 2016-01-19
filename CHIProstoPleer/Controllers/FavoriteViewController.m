//
//  FavoriteViewController.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/19/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "FavoriteViewController.h"
#import "PPMusicViewController.h"
#import "CustomTableViewCell.h"

#import "CoreDataManager.h"
#import "Track.h"

#import "ProstoPleerProtocols.h"

@interface FavoriteViewController () <NSFetchedResultsControllerDelegate, PPTopSongsListViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property NSInteger currentIndex;

@end

@implementation FavoriteViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UITabBarItem *favoriteTabBar = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        
        self.tabBarItem = favoriteTabBar;
    }
    return self;
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Favorites";
}

#pragma mark - TableViewDataSource and TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    
    if (!cell)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CustomCell"];
    }
   
    Track *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.customTextLabel.text = object.artist;
    cell.customDetailTextLabel.text = object.title;
    return cell;
}

- (void)configureTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Track *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] deleteObject:object];
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:object.download] error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
    }
    
     [[CoreDataManager sharedInstanceCoreData] saveContext];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPMusicViewController *musicVC = [[PPMusicViewController alloc] init];
    musicVC.info = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    musicVC.delegate = self;
    
    self.currentIndex = indexPath.row;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:musicVC animated:YES];
}

#pragma mark - NSFetchedResultsController & Delegate

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSString *user = [[CoreDataManager sharedInstanceCoreData] currentUserLogin];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY user.login = %@", user];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - PPTopSongsListViewControllerDelegate

- (id <PPTrackInfoProtocol>)topSongsList:(PPTrackDirection)direction
{
    id <PPTrackInfoProtocol>song;
    
    switch (direction) {
        case PPTrackDirectionFastForward:
        {
            if (self.currentIndex == [[self.fetchedResultsController fetchedObjects] count] - 1) {
                self.currentIndex = 0;
                song = [[self.fetchedResultsController fetchedObjects] firstObject];
                break;
            }
            song = [[self.fetchedResultsController fetchedObjects] objectAtIndex:self.currentIndex +1];
            self.currentIndex += 1;
            break;
        }
        case PPTrackDirectionFastRewind:
        {
            if (self.currentIndex == 0) {
                song = [[self.fetchedResultsController fetchedObjects] firstObject];
                break;
            }
            song = [[self.fetchedResultsController fetchedObjects] objectAtIndex:self.currentIndex -1];
            self.currentIndex -= 1;
            break;
        }
        default:
            break;
    }
    return song;
}
@end
