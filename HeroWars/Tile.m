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

NSInteger MAX_CONTROL = 20;

-(id)initTileNamed:(NSString *)tileName {
    self = [super init];
    if (self) {
        // set implicit properties
        [self setAnchorPoint:CGPointZero];
        if ([tileName isEqualToString:@"empty"]) {
            self.name = @"empty";
        } else {
            // parse tile statistics
            TileParser *parser = [[TileParser alloc]init];
            [parser parseStatsForTileNamed:tileName];
            // set name specific properties
            self.name = parser.tileName;
            NSString *imageName = [NSString stringWithFormat:@"%@", self.name];
            self.texture = [SKTexture textureWithImageNamed:imageName];
            self.size = self.texture.size;
            self.color = [UIColor whiteColor];
            // set other properties
            self.type = parser.type;
            self.movecosts = parser.movecosts;
            self.cover = parser.cover;
            self.elevation = parser.elevation;
        }
    }
    return self;
}

-(id)initBuildingNamed:(NSString *)tileName withColors:(NSArray *)playerColors withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        self = [self initTileNamed:tileName];
        self.owner = owner;
        self.control = MAX_CONTROL;
        self.playerColors = playerColors;
        // adjust image
        if (owner == 0) {
            NSString *imageName = [NSString stringWithFormat:@"%@_neutral", self.name];
            self.texture = [SKTexture textureWithImageNamed:imageName];
        } else {
            self.teamColor = playerColors[self.owner - 1];
            NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.name, self.teamColor];
            self.texture = [SKTexture textureWithImageNamed:imageName];
        }
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}

-(BOOL)isBeingCaptured {
    if ([self.type isEqualToString:@"building"] || [self.type isEqualToString:@"production"]) {
        if (self.control < MAX_CONTROL) {
            return YES;
        }
    }
    return NO;
}

-(void)cancelCapture {
    if ([self.type isEqualToString:@"building"] || [self.type isEqualToString:@"production"]) {
        self.control = MAX_CONTROL;
    }
}

-(void)captureWithOwner:(NSInteger)owner {
    if ([self.type isEqualToString:@"building"] || [self.type isEqualToString:@"production"]) {
        self.owner = owner;
        self.control = MAX_CONTROL;
        // adjust image
        self.teamColor = self.playerColors[self.owner - 1];
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.name, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    } else {
        NSLog(@"Error: tried to capture non-building");
    }
}

@end