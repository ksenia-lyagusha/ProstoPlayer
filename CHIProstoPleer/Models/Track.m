//
//  Track.m
//  
//
//  Created by Оксана on 21.12.15.
//
//

#import "Track.h"
#import "CoreDataManager.h"

#import "Track+CoreDataProperties.h"

@implementation Track



// Insert code here to add functionality to your managed object subclass

- (instancetype)trackWithTitle:(NSString *)title withArtist:(NSString *)artist withTrackID:(NSString *)trackID withDuration:(NSNumber *)duration withTextID:(NSString *)text_id
{
    
    self.title    = title;
    self.artist   = artist;
    self.track_id = trackID;
    self.duration = [[NSNumberFormatter alloc] numberFromString:(NSString *)duration];
    self.text_id  = ([text_id isKindOfClass:[NSNull class]]) ?  @"" : text_id;
    
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

@end
