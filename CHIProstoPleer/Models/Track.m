//
//  Track.m
//  
//
//  Created by CHI Software on 12/28/15.
//
//

#import "Track.h"
#import "CoreDataManager.h"

#import "Track+CoreDataProperties.h"

@implementation Track

// Insert code here to add functionality to your managed object subclass

- (instancetype)createTrackWithTrackInfoObject:(TrackInfo *)trackInfo
{
    self.title    = trackInfo.title;
    self.artist   = trackInfo.artist;
    self.track_id = trackInfo.track_id;
    self.duration = [[NSNumberFormatter alloc] numberFromString:(NSString *)trackInfo.duration];
    self.text_id  = ([trackInfo.text_id isKindOfClass:[NSNull class]]) ?  @"" : trackInfo.text_id;

    return self;
}

+ (instancetype)objectWithTrackID:(NSString *)trackID
{
    Track *track;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Track"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"track_id == %@", trackID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSArray *filtered = [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    if (filtered.count > 0) {
        track = [filtered objectAtIndex:0];
    }
    
    return track;
}

- (void)saveTrackInExternalFileWithLocation:(NSString *)location
{
    self.download = location;
}

@end
