//
//  ProstoPleerProtocols.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/24/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#ifndef ProstoPleerProtocols_h
#define ProstoPleerProtocols_h

@protocol PPTrackInfoProtocol <NSObject>

@property (nonatomic, strong) NSString *trackTitle;
@property (nonatomic, strong) NSString *trackArtist;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *textID;
@property (nonatomic, strong) NSNumber *trackDuration;

@end

#endif /* ProstoPleerProtocols_h */
