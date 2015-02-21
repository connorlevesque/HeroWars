//
//  Axeman.h
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Unit.h"

@interface Axeman : Unit

-(id)initOnTile:(Tile *)tile withOwner:(NSInteger)owner;

/* gameplay properties to set
    type
    group
    move
    range
    power
    weapon
    accuracy
    armor
 */

@end
