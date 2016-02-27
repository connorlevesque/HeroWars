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

NSInteger INCOME_PER_BUILDING = 100;

-(id)initWithLevelNamed:(NSString *)levelFile {
    self = [super init];
    if (self) {
        // parse the level from file and retrieve relevant data
        self.levelParser = [[LevelParser alloc]init];
        [self.levelParser makeGridsFromLevelFile:levelFile];
        self.levelName = self.levelParser.levelName;
        self.width = self.levelParser.width;
        self.height = self.levelParser.height;
        self.players = self.levelParser.players;
        self.playerColors = self.levelParser.playerColors;
        self.tileGrid = self.levelParser.tileGrid;
        self.unitGrid = self.levelParser.unitGrid;
        // set other properties
        self.currentPlayer = 1;
        self.turn = 1;
        self.startingTileCoords = [[NSMutableArray alloc]init];
        // set up funds
        self.funds = [[NSMutableArray alloc]init];
        for (int i = 0; i < [self.playerColors count]; i++) {
            [self.funds addObject:@0];
        }
        [self adjustFundsForPlayer:self.currentPlayer byAmount:[self getIncomeForPlayer:self.currentPlayer]];
    }
    return self;
}

-(NSString *)currentPlayerColor {
    return self.playerColors[self.currentPlayer - 1];
}

-(NSInteger)getFundsForPlayer:(NSInteger)player {
    // returns the players funds
    if (0 < player && player <= self.players) {
        return [self.funds[player - 1] integerValue];
    } else {
        NSLog(@"Error: invalid player number for getFunds");
        return -1;
    }
}

-(NSInteger)getIncomeForPlayer:(NSInteger)player {
    // returns the player's income
    NSInteger buildings = 0;
    for (NSArray *tileRow in self.tileGrid) {
        for (Tile *tile in tileRow) {
            if ([tile.type isEqualToString:@"building"] || [tile.type isEqualToString:@"production"]) {
                Tile *building = tile;
                if (building.owner == player) {
                    buildings++;
                }
            }
        }
    }
    return buildings * INCOME_PER_BUILDING;
}

-(void)adjustFundsForPlayer:(NSInteger)player byAmount:(NSInteger)amount {
    // adjusts a players funds by the amount given
    self.funds[player - 1] = [NSNumber numberWithInteger:([self getFundsForPlayer:player] + amount)];
}

-(BOOL)isUnit:(Unit *)a withinRangeOfUnit:(Unit *)b {
    NSInteger dx = a.tile.x - b.tile.x;
    NSInteger dy = a.tile.y - b.tile.y;
    NSInteger distance = abs(dx) + abs(dy);
    if ((distance >= [(NSNumber *)[b.range objectAtIndex:0] integerValue]) &&
        (distance <= [(NSNumber *)[b.range objectAtIndex:1] integerValue])) {
        return YES;
    } else {
        return NO;
    }
}

-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile {
    [self.startingTileCoords removeAllObjects];
    [self.startingTileCoords addObject:[NSNumber numberWithInteger:unit.tile.x]];
    [self.startingTileCoords addObject:[NSNumber numberWithInteger:unit.tile.y]];
    [self removeUnitFromTile:unit.tile];
    unit.tile = tile;
    self.unitGrid[tile.y - 1][tile.x - 1] = unit;
}

-(void)undoMoveUnit:(Unit *)unit {
    [self removeUnitFromTile:unit.tile];
    NSInteger x = [(NSNumber *)self.startingTileCoords[0] integerValue];
    NSInteger y = [(NSNumber *)self.startingTileCoords[1] integerValue];
    unit.tile = [self tileAtX:x andY:y];
    self.unitGrid[y - 1][x - 1] = unit;
}

-(void)carryUnit:(Unit *)unit withUnit:(Unit *)carrier {
    [self.startingTileCoords removeAllObjects];
    [self.startingTileCoords addObject:[NSNumber numberWithInteger:unit.tile.x]];
    [self.startingTileCoords addObject:[NSNumber numberWithInteger:unit.tile.y]];
    [self removeUnitFromTile:unit.tile];
    carrier.cargo = unit;
    unit.carrier = carrier;
}

-(void)undoCarryUnit:(Unit *)unit {
    unit.carrier.cargo = (Unit *)[NSNull null];
    NSInteger x = [(NSNumber *)self.startingTileCoords[0] integerValue];
    NSInteger y = [(NSNumber *)self.startingTileCoords[1] integerValue];
    unit.tile = [self tileAtX:x andY:y];
    self.unitGrid[y - 1][x - 1] = unit;
}

-(void)dropUnit:(Unit *)unit onTile:(Tile *)tile {
    unit.carrier.cargo = (Unit *)[NSNull null];
    unit.carrier = (Unit *)[NSNull null];
    unit.tile = tile;
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

-(BOOL)isUnitAtX:(NSInteger)x andY:(NSInteger)y {
    id unitMaybe = [self unitAtX:x andY:y];
    if (unitMaybe == (id)[NSNull null]) {
        return NO;
    } else {
        return YES;
    }
}

-(void)setUnit:(Unit *)unit OnTile:(Tile *)tile {
    self.unitGrid[tile.y - 1][tile.x - 1] = unit;
}

-(void)removeUnitFromTile:(Tile *)tile {
    self.unitGrid[tile.y - 1][tile.x - 1] = [NSNull null];
}

@end