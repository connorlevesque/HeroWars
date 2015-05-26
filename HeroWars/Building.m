//
//  Building.m
//  HeroWars
//
//  Created by Connor Levesque on 4/29/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Building.h"

@implementation Building

-(id)init {
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0,0);
        self.control = 20;
    }
    return self;
}


-(id)initTownWithColors:(NSArray *)playerColors andOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.owner = owner;
        self.playerColors = playerColors;
        self.teamColor = playerColors[owner - 1];
        self.control = 20;
        self.type = @"town";
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}

@end
