//
//  Archer.m
//  HeroWars
//
//  Created by Connor Levesque on 2/21/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Archer.h"

@implementation Archer

-(id)initOnTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.x = tile.x;
        self.y = tile.y;
        self.owner = owner;
        self.teamColor = playerColors[self.owner - 1];
        // set type specific properties
        self.type = @"archer";
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        // Set Gameplay Properties
        self.group = @"archer";
        self.move = 4;
        self.range = @[@2,@2];
        self.power = 75;
        self.accuracy = 80;
        self.weapon = 5;
        self.armor = 0;
    }
    return self;
}

@end
