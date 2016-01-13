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

@property NSInteger currentIndex;

@end

@implementation PPFavotireCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UITabBarItem *favoriteTabBar = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        
        self.tabBarItem = favoriteTabBar;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
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
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];

    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.collectionView.contentInset = adjustForTabbarInsets;
    self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Track *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = object.artist;
    
    UILabel *detailTextLabel = [[UILabel alloc] init];
    detailTextLabel.text = object.title;
    
    [cell addSubview:textLabel];
    [cell addSubview:detailTextLabel];
    
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
/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 4.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
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
