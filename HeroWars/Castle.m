//
//  Castle.m
//  HeroWars
//
//  Created by Connor Levesque on 5/26/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Castle.h"

@implementation Castle

-(id)initWithColors:(NSArray *)playerColors andOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self.owner = owner;
        self.playerColors = playerColors;
        if (owner == 0) {
            self.teamColor = @"gray";
        } else {
            self.teamColor = playerColors[owner - 1];
        }
        self.control = 20;
        self.type = @"castle";
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}


@end
