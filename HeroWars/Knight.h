//
//  Knight.h
//  HeroWars
//
//  Created by Connor Levesque on 5/26/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@interface Knight : Unit

-(id)initOnTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner;

@end
