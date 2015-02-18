//
//  Pather.m
//  HeroWars
//
//  Created by Connor Levesque on 2/11/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Pather.h"

@implementation Pather

-(id)init {
    self = [super init];
    if (self) {
        self.path = [[NSMutableArray alloc]init];
        self.paths = [[NSMutableDictionary alloc]init];
    }
    return self;
}

//-(NSMutableArray *)tileCoordsForUnit:(Unit *)unit andBoard:(Gameboard *)board {
//    //test method to highlight some tiles
//    self.unit = unit;
//    self.board = board;
//    self.unitTile = [self.board tileAtX:self.unit.x andY:self.unit.y];
//    NSMutableArray *tileCoords = [[NSMutableArray alloc]init];
//    for (int r = 0; r < self.board.height; r++) {
//        for (int c = 0; c < self.board.width; c++) {
//            Tile *tile = self.board.tileGrid[r][c];
//            if (abs(self.unitTile.x - tile.x) + abs(self.unitTile.y - tile.y) <= 3) {
//                NSNumber *tileXNumb = [NSNumber numberWithInteger:tile.x];
//                NSNumber *tileYNumb = [NSNumber numberWithInteger:tile.y];
//                NSArray *tileCoord = @[tileXNumb,tileYNumb];
//                [tileCoords addObject:tileCoord];
//            }
//        }
//    }
//    return tileCoords;
//}

-(NSMutableDictionary *)findPathsForUnit:(Unit *)unit andBoard:(Gameboard *)board {
    self.movePoints = unit.move;
    self.board = board;
    self.unitOwner = unit.owner;
    self.originTile = [self.board tileAtX:unit.x andY:unit.y];
    self.currentTile = self.originTile;
    self.pathsFound = NO;
    [self.path removeAllObjects];
    [self.paths removeAllObjects];
    [self resetMoveRecords];
    [self walkInDirection:0];
    [self walkInDirection:2];
    return self.paths;
}

-(void)resetMoveRecords {
    if (!self.moveRecords) {
        self.moveRecords = [[NSMutableArray alloc]init];
    } else {
        [self.moveRecords removeAllObjects];
    }
    for (int r = 0; r < self.board.height; r++) {
        NSMutableArray *row = [[NSMutableArray alloc]init];
        for (int c = 0; c < self.board.width; c++) {
            [row addObject:[NSNull null]];
        }
        [self.moveRecords addObject:row];
    }
    self.moveRecords[self.originTile.y - 1][self.originTile.x - 1] = [NSNumber numberWithInteger:self.movePoints];
}

-(void)setMoveRecordAtX:(NSInteger)x andY:(NSInteger)y To:(NSInteger)integer {
    NSNumber *number = [NSNumber numberWithInteger:integer];
    self.moveRecords[y - 1][x - 1] = number;
}

-(void)walkInDirection:(NSInteger)oldDirection {
    //walks recursively through a path to every possible tile and adds paths to paths array
    //try to move in each possible turn
        //Left = 0
        //Forwards = 1
        //Right = 2
        //Back = 3
    for (NSInteger turn = 0; turn < 4; turn++) {
        //set function variables
        NSInteger newDirection = [self findNewDirectionFromTurn:turn withOldDirection:oldDirection];
        //if the tile exists
        id targetTileMaybe = [self findTileInDirection:newDirection];
        if (targetTileMaybe != (id)[NSNull null]) {
            Tile *targetTile = (Tile *)targetTileMaybe;
            //if you aren't moving back
            if (turn < 3) {
                if ([self canMoveToTile:targetTile]) {
                    [self moveForwardToTile:targetTile];
                    [self.path addObject:[NSNumber numberWithInteger:newDirection]];
                    [self walkInDirection:newDirection];
                }
            } else { //if you are moving back
                [self moveBackToTile:targetTile];
            }
        }
    }
}

-(void)moveForwardToTile:(Tile *)targetTile {
    self.movePoints = self.movePoints - targetTile.moveCost;
    [self setMoveRecordAtX:targetTile.x andY:targetTile.y To:self.movePoints];
    self.currentTile = targetTile;
}

-(void)moveBackToTile:(Tile *)targetTile {
    if (self.currentTile != self.originTile) {
        [self addCoordPairToDictionary];
        [self.path removeLastObject];
        self.movePoints = self.movePoints + self.currentTile.moveCost;
        self.currentTile = targetTile;
    } else {
        [self addCoordPairToDictionary];
        [self.path removeLastObject];
    }
}

-(void)addCoordPairToDictionary {
    NSString *coordString = [NSString stringWithFormat:@"%d,%d", self.currentTile.x, self.currentTile.y];
    [self.paths setObject:self.path forKey:coordString];
}

-(BOOL)canMoveToTile:(Tile *)targetTile {
    //returns true if the unit can move to the target Tile
    // if there is enough movepoints
    if (self.movePoints >= targetTile.moveCost) {
        // if there is a unit on the tile
        id targetUnitMaybe = [self.board unitAtX:targetTile.x andY:targetTile.y];
        if (targetUnitMaybe != (id)[NSNull null]) {
            Unit *targetUnit = (Unit *)targetUnitMaybe;
            // if it is an enemy unit
            if (targetUnit.owner != self.unitOwner) {
                return NO;
            }
        }
        // if there is a move record
        if (self.moveRecords[targetTile.y - 1][targetTile.x - 1] != (id)[NSNull null]) {
            NSInteger targetMoveRecord = [self.moveRecords[targetTile.y - 1][targetTile.x - 1] integerValue];
            // if you can set a better moverecord
            if ((self.movePoints - targetTile.moveCost) > targetMoveRecord) {
                return YES;
            } else {
                return NO;
            }
        } else {
        // if there's no a move record
            return YES;
        }
    } else {
        return NO;
    }
}

-(NSInteger)findNewDirectionFromTurn:(NSInteger)turn withOldDirection:(NSInteger)oldDirection {
    //returns the new cardinal direction given the old cardinal direction and what relative direction you are turning in
    NSInteger newDirection = (oldDirection + turn + 3) % 4;
    return newDirection;
}

-(Tile *)findTileInDirection:(NSInteger)direction {
    //returns the tile in the given cardinal direction
    Tile *tile = [[Tile alloc]init];
    tile.x = self.currentTile.x;
    tile.y = self.currentTile.y;
    switch (direction) {
        case 0:
            tile.y = tile.y + 1;
            break;
        case 1:
            tile.x = tile.x + 1;
            break;
        case 2:
            tile.y = tile.y - 1;
            break;
        case 3:
            tile.x = tile.x - 1;
            break;
        default:
            NSLog(@"Error: cannot find tile in non-cardinal direction");
            break;
    }
    if ((tile.x >= 1) && (tile.x <= self.board.width) && (tile.y >= 1) && (tile.y <= self.board.height)) {
        tile = [self.board tileAtX:tile.x andY:tile.y];
        return tile;
    } else {
        return (Tile *)[NSNull null];
    }
}

@end
