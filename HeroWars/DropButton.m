//
//  DropButton.m
//  HeroWars
//
//  Created by Connor Levesque on 8/22/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "DropButton.h"
#import "Unit.h"

@implementation DropButton

- (id)initWithUnit:(Unit *)unit {
    self = [super init];
    if (self) {
        self.name = @"drop";
        self.unit = unit;
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", unit.name, unit.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        // alter texture size here
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}

@end
