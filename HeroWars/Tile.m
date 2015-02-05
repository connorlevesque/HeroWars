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

- (id)initWithType: (NSString *) type
{
    self = [super init];
    
    if (self) {
        // set anchor point, color, type, texture according to type, and size according to texture
        [self setAnchorPoint:CGPointZero];
        _type = type;
        if ([_type isEqualToString:@"p"]) {
            self.texture = [SKTexture textureWithImageNamed:@"heroWars_tile_100_lightGreen"];
        } else if ([_type isEqualToString:@"f"]) {
            self.texture = [SKTexture textureWithImageNamed:@"heroWars_tile_100_darkGreen"];
        } else {
            self.texture = [SKTexture textureWithImageNamed:@"heroWars_tile_100_white"];
        }
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}

@end