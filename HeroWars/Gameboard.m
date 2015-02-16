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

@interface Gameboard ()

@end

@implementation Gameboard


-(id)initWithMapNamed:(NSString *)levelName {
    self = [super init];
    if (self) {
        [self makeGridsFromLevelName:levelName];
    }
    return self;
}

-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile {
    self.unitGrid[unit.y - 1][unit.x - 1] = [NSNull null];
    unit.x = tile.x;
    unit.y = tile.y;
    self.unitGrid[tile.y - 1][tile.x - 1] = unit;
}

-(Tile *)tileAtX:(NSInteger)x andY:(NSInteger)y {
    Tile *tile = [[Tile alloc]init];
    tile = self.tileGrid[y - 1][x - 1];
    return tile;
}

-(Unit *)unitAtX:(NSInteger)x andY:(NSInteger)y {
    Unit *unit = [[Unit alloc]init];
    unit = self.unitGrid[y - 1][x - 1];
    return unit;
}

-(Unit *)makeUnitOnTile:(Tile *)tile withName:(NSString *)name andOwner:(NSInteger)owner {
    if ([name isEqualToString:@"Axeman"]) {
        Axeman *axeman = [[Axeman alloc]initOnTile:tile withOwner:owner];
        return axeman;
    } else {
        NSLog(@"Error: unknown unit name");
        return nil;
    }
}

-(void)makeGridsFromLevelName:(NSString *)levelName {
    //parses levelString and sets width, height, tileGrid, unitGrid
    NSString *levelString = [self getLevelString:levelName];
    NSArray *levelComponents = [levelString componentsSeparatedByString:@":"];
    NSString *mapString = levelComponents[1];
    mapString = [mapString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *mapRows = [mapString componentsSeparatedByString:@"/"];
    self.height = [mapRows count];
    NSMutableArray *squareStringGrid = [[NSMutableArray alloc]init];
    for (NSString *rowString in mapRows) {
        NSArray *rowComponents = [rowString componentsSeparatedByString:@","];
        if (self.width == 0) {
            self.width = [rowComponents count];
        }
        [squareStringGrid addObject:rowComponents];
    }
    //init the grids from parsed string
    self.tileGrid = [[NSMutableArray alloc]init];
    self.unitGrid = [[NSMutableArray alloc]init];
    for (int r = 0; r < self.height; r++) {
        NSMutableArray *tileRow = [[NSMutableArray alloc]init];
        NSMutableArray *unitRow = [[NSMutableArray alloc]init];
        for (int c = 0; c < self.width; c++) {
            NSString *squareString = squareStringGrid[r][c];
            NSArray *squareComponents = [squareString componentsSeparatedByString:@"-"];
            NSString *type = squareComponents[0];
            Tile *tile = [[Tile alloc]initWithType:type];
            tile.x = c + 1;
            tile.y = r + 1;
            [tileRow addObject:tile];
            //make unit if there is one
            if ([squareComponents count] == 3) {
                NSString *ownerString = squareComponents[1];
                NSInteger owner = [ownerString integerValue];
                NSString *unitString = squareComponents[2];
                NSString *unitName = [self findUnitNameFromAbbreviation:unitString];
                Unit *unit = [self makeUnitOnTile:tile withName:unitName andOwner:owner];
                [unitRow addObject:unit];
            } else {
                [unitRow addObject:[NSNull null]];
            }
        }
        [self.tileGrid addObject:tileRow];
        [self.unitGrid addObject:unitRow];
    }
}

-(NSString *)getLevelString:(NSString *)levelName {
    //uses levelName to find the contents string of the corresponding level
    NSString *pathString = [NSString stringWithFormat:@"/%@", levelName];
    NSString *path = [[NSBundle mainBundle] pathForResource:pathString ofType:@"txt"];
    NSString *levelString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return levelString;
}

-(NSString *)findUnitNameFromAbbreviation:(NSString *)abbreviation {
    NSDictionary *unitAbbreviationGuide = [[NSDictionary alloc]initWithObjectsAndKeys:@"Axeman",@"x", nil];
    NSString *unitName = [unitAbbreviationGuide objectForKey:abbreviation];
    return unitName;
}

@end