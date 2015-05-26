//
//  Tile.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@implementation Tile

- (id)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        // set anchor point, color, type, texture according to type, and size according to texture
        [self setAnchorPoint:CGPointZero];
        self.type = type;
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        NSDictionary *moveCosts = [[NSDictionary alloc]initWithObjectsAndKeys:@1,@"plains",@2,@"forest",@3,@"mountain",@1,@"road",@3,@"river",@100,@"sea", nil];
        self.moveCost = [[moveCosts objectForKey:self.type] integerValue];
    }
    return self;
}

-(id)init {
    //used for initializing buildings
    self = [super init];
    if (self) {
        [self setAnchorPoint:CGPointZero];
        self.moveCost = 1;
    }
    return self;
}

@end