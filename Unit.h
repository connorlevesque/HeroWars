//
//  Unit.h
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Tile.h"

@interface Unit : SKSpriteNode

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

@property (nonatomic) NSInteger move;
@property (nonatomic) NSInteger owner;

@end
