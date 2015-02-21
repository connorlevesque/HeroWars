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
        self.width = 0;
        self.height = 0;
        [self makeGridsFromLevelName:levelName];
        self.currentPlayer = 1;
        self.day = 1;
        self.lastMoveInfo = [[NSMutableArray alloc]init];
        self.players = 2;
    }
    return self;
}

-(BOOL)isUnit:(Unit *)a withinRangeOfUnit:(Unit *)b {
    NSInteger dx = a.x - b.x;
    NSInteger dy = a.y - b.y;
    NSInteger distance = abs(dx) + abs(dy);
    if ((distance >= [(NSNumber *)[b.range objectAtIndex:0] integerValue]) &&
        (distance <= [(NSNumber *)[b.range objectAtIndex:1] integerValue])) {
        return YES;
    } else {
        return NO;
    }
}

-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile {
    [self.lastMoveInfo removeAllObjects];
    [self.lastMoveInfo addObject:[NSNumber numberWithInteger:unit.x]];
    [self.lastMoveInfo addObject:[NSNumber numberWithInteger:unit.y]];
    [self.lastMoveInfo addObject:[NSNumber numberWithInteger:tile.x]];
    [self.lastMoveInfo addObject:[NSNumber numberWithInteger:tile.y]];
    self.unitGrid[unit.y - 1][unit.x - 1] = [NSNull null];
    unit.x = tile.x;
    unit.y = tile.y;
    self.unitGrid[tile.y - 1][tile.x - 1] = unit;
}

-(Unit *)undoMoveUnit {
    NSInteger x1 = [self.lastMoveInfo[0] integerValue];
    NSInteger y1 = [self.lastMoveInfo[1] integerValue];
    NSInteger x2 = [self.lastMoveInfo[2] integerValue];
    NSInteger y2 = [self.lastMoveInfo[3] integerValue];
    Unit *unit = [self unitAtX:x2 andY:y2];
    self.unitGrid[y1 - 1][x1 - 1] = unit;
    unit.x = x1;
    unit.y = y1;
    self.unitGrid[y2 - 1][x2 - 1] = [NSNull null];
    return unit;
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

-(Unit *)addUnitOnTile:(Tile *)tile withName:(NSString *)name andOwner:(NSInteger)owner {
    if ([name isEqualToString:@"footman"]) {
        Footman *footman = [[Footman alloc]initOnTile:tile withOwner:owner];
        return footman;
    } else if ([name isEqualToString:@"axeman"]) {
        Axeman *axeman = [[Axeman alloc]initOnTile:tile withOwner:owner];
        return axeman;
    } else if ([name isEqualToString:@"archer"]) {
        Archer *archer = [[Archer alloc]initOnTile:tile withOwner:owner];
        return archer;
    } else {
        NSLog(@"Error: unknown unit name");
        return nil;
    }
}

-(void)removeUnitFromTile:(Tile *)tile {
    Unit *unit = [self unitAtX:tile.x andY:tile.y];
    self.unitGrid[tile.y - 1][tile.x - 1] = [NSNull null];
    NSLog(@"%@ %@ died", unit.teamColor, unit.type);
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
                Unit *unit = [self addUnitOnTile:tile withName:unitName andOwner:owner];
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
    NSDictionary *unitAbbreviationGuide = [[NSDictionary alloc]initWithObjectsAndKeys:@"footman",@"f",@"axeman",@"x",@"archer",@"a", nil];
    NSString *unitName = [unitAbbreviationGuide objectForKey:abbreviation];
    return unitName;
}

@end