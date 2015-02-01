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
        _type = type;
    }
    return self;
}

@end