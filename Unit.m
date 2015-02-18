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
    }
    return self;
}

-(void)changeState {
    if ([self.state isEqualToString:@"awake"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_gray_%@", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
        NSArray *playerColors = @[@"blue",@"red"];
        NSString *playerColor = playerColors[self.owner - 1];
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", playerColor, self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else {
        NSLog(@"Error: unknown state named passed to unit %@", self);
    }
}

@end
