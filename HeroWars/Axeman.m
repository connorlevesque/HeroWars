//
//  Axeman.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Axeman.h"

@implementation Axeman

-(id)initOnTile:(Tile *)tile withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.x = tile.x;
        self.y = tile.y;
        self.owner = owner;
        self.type = @"axeman";
        self.move = 4;
        if (self.owner == 1) {
            self.texture = [SKTexture textureWithImageNamed:@"HeroWars_blue_axeman"];
        } else if (self.owner == 2) {
            self.texture = [SKTexture textureWithImageNamed:@"HeroWars_red_axeman"];
        } else {
            NSLog(@"Error: invalid owner integer for Axeman unit %@", self);
        }
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}

@end
