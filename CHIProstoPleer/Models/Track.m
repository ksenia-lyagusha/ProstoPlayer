//
//  Track.m
//  
//
//  Created by Оксана on 21.12.15.
//
//

#import "Track.h"
#import "CoreDataManager.h"

@implementation Track

// Insert code here to add functionality to your managed object subclass

- (instancetype)trackWithTitle:(NSString *)title withArtist:(NSString *)artist withTrackID:(NSString *)trackID withDuration:(NSNumber *)duration withTextID:(NSString *)text_id
{
    
    self.title = title;
    self.artist = artist;
    self.track_id = trackID;
    self.duration = [[NSNumberFormatter alloc] numberFromString:(NSString *)duration];
    self.text_id = ([text_id isKindOfClass:[NSNull class]]) ?  @"" : text_id;
    
    return self;
}

- (instancetype)objectWithTrackID:(NSString *)trackID
{
    Track *track;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Track"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"track_id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *tmpData = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return track;
}

@end
