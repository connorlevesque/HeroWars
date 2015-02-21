//
//  Footman.m
//  HeroWars
//
//  Created by Connor Levesque on 2/21/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Footman.h"

@implementation Footman

-(id)initOnTile:(Tile *)tile withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.x = tile.x;
        self.y = tile.y;
        self.owner = owner;
        NSArray *playerColors = @[@"blue",@"red"];
        self.teamColor = playerColors[self.owner - 1];
        // set type specific properties
        self.type = @"footman";
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.teamColor, self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        // Set Gameplay Properties
        self.group = @"infantry";
        self.move = 4;
        self.range = @[@1,@1];
        self.power = 30;
        self.weapon = 1;
        self.accuracy = 90;
        self.armor = 1;
    }
    return self;
}

@end
