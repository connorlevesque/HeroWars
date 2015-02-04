//
//  Gameboard.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Gameboard.h"
#import "Tile.h"
#import "Map.h"


@interface Gameboard ()

@end

@implementation Gameboard


-(id)initWithMap:(Map *)map {
    self = [super init];
    if (self) {
        self.grid = [[NSMutableArray alloc]init];
        for (int r = 0; r < map.height; r++) {
            NSMutableArray *row = [[NSMutableArray alloc]init];
            for (int c = 0; c < map.width; c++) {
                Tile *tile = map.tileArray[r * map.width + c];
                [row addObject:tile];
            }
            [self.grid addObject:row];
        }
        for (NSMutableArray *row in self.grid) {
            for (Tile *tile in row) {
                NSLog(@"%@",tile.type);
            }
            NSLog(@" ");
        }
    }
    return self;
}

@end