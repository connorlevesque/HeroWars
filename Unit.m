//
//  Unit.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@implementation Unit

-(id)init {
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0,0);
        self.state = @"awake";
        self.health = 100;
        self.experience = 0;
        self.canMoveAndAttack = YES;
    }
    return self;
}

-(void)changeStateTo:(NSString *)state {
    self.state = state;
    if ([self.state isEqualToString:@"awake"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_gray", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else {
        NSLog(@"Error: unknown state named passed to unit %@", self);
    }
}

-(void)refreshTexture {
    if ([self.state isEqualToString:@"awake"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
            NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_gray", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    }
}

@end
