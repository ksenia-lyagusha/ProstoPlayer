//
//  PPTopSongsListViewController.h
//  ProstoPleerApp
//
//  Created by Оксана on 16.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPTopSongsListViewControllerDelegate  <NSObject>

- (NSDictionary *)topSongsList:(NSInteger)tag;

@end

@interface PPTopSongsListViewController : UITableViewController

@end
