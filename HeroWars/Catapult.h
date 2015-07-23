//
//  Catapult.h
//  HeroWars
//
//  Created by Connor Levesque on 7/23/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@interface Catapult : Unit

-(id)initOnTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner;

@end
