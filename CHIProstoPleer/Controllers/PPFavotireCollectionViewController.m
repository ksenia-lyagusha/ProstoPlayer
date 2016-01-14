//
//  PPFavotireCollectionViewController.m
//  ProstoPleerApp
//
//  Created by CHI Software on 13.01.16.
//  Copyright © 2016 CHI Software. All rights reserved.
//

#import "PPFavotireCollectionViewController.h"
#import "PPMusicViewController.h"

#import "CoreDataManager.h"
#import "Track.h"
#import "ProstoPleerProtocols.h"
#import <UICollectionView+NSFetchedResultsController.h>

@interface PPFavotireCollectionViewController () <PPTopSongsListViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic)         NSInteger currentIndex;
@property (nonatomic)         BOOL shouldReloadCollectionView;
@property (strong, nonatomic) NSBlockOperation *blockOperation;

@end

@implementation PPFavotireCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    self = [super initWithCollectionViewLayout:collectionViewFlowLayout];
    if (self)
    {
        UITabBarItem *favoriteTabBar = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        
        self.tabBarItem = favoriteTabBar;
    }
    return self;
}

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.collectionView.contentInset = adjustForTabbarInsets;
    self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"Favorites";
}

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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"DB objects %li", [[self.fetchedResultsController fetchedObjects] count]);
    return [[self.fetchedResultsController fetchedObjects] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Track *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = object.artist;
    textLabel.numberOfLines = 0;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *detailTextLabel = [[UILabel alloc] init];
    detailTextLabel.text = object.title;
    detailTextLabel.numberOfLines = 0;
    detailTextLabel.adjustsFontSizeToFitWidth = YES; 
    detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:textLabel];
    [cell.contentView addSubview:detailTextLabel]; 
    
    NSDictionary *views = NSDictionaryOfVariableBindings(detailTextLabel, textLabel, imageView);
    
    NSDictionary *metrics = @{@"verticalSpacing" : @50.0};
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[textLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[textLabel]-[detailTextLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[detailTextLabel]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel(50)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailTextLabel(50)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textLabel(50)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailTextLabel(50)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPMusicViewController *musicVC = [[PPMusicViewController alloc] init];
    musicVC.info = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    musicVC.delegate = self;
    
    self.currentIndex = indexPath.row;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:musicVC animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView commitEditingStyle:(UICollectionViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UICollectionViewCellEditingStyleDelete)
//    {
//        Track *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] deleteObject:object];
//        
//        NSError *error;
//        [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:object.download] error:&error];
//        
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//    }
//    
//    [[CoreDataManager sharedInstanceCoreData] saveContext];
//}

// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 150);
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

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.shouldReloadCollectionView = NO;
    self.blockOperation = [[NSBlockOperation alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            if ([self.collectionView numberOfSections] > 0) {
                if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                    self.shouldReloadCollectionView = YES;
                } else {
                    [self.blockOperation addExecutionBlock:^{
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            } else {
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                self.shouldReloadCollectionView = YES;
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
    if (self.shouldReloadCollectionView)
    {
        [self.collectionView reloadData];
    } else
    {
        [self.collectionView performBatchUpdates:^{
            
            [self.blockOperation start];
        } completion:nil];
    }
}

@end