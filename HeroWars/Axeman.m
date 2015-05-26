//
//  Axeman.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Axeman.h"

@implementation Axeman

-(id)initOnTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.x = tile.x;
        self.y = tile.y;
        self.owner = owner;
        self.teamColor = playerColors[self.owner - 1];
        // set type specific properties
        self.type = @"axeman";
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        // Set Gameplay Properties
        self.group = @"infantry";
        self.move = 4;
        self.range = @[@1,@1];
        self.power = 60;
        self.accuracy = 70;
        self.weapon = 50;
        self.armor = 30;
    }
    return self;
}

@end
