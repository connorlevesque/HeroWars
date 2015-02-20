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
    }
    return self;
}

-(void)changeStateTo:(NSString *)state {
    self.state = state;
    if ([self.state isEqualToString:@"awake"]) {
        NSArray *playerColors = @[@"blue",@"red"];
        NSString *playerColor = playerColors[self.owner - 1];
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", playerColor, self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_gray_%@", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else {
        NSLog(@"Error: unknown state named passed to unit %@", self);
    }
}

-(void)refreshTexture {
    if ([self.state isEqualToString:@"awake"]) {
        NSArray *playerColors = @[@"blue",@"red"];
        NSString *playerColor = playerColors[self.owner - 1];
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", playerColor, self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
            NSString *imageName = [NSString stringWithFormat:@"HeroWars_gray_%@", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    }
}

@end
