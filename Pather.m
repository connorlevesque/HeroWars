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
    self.originTile = [self.board tileAtX:unit.x andY:unit.y];
    self.currentTile = self.originTile;
    self.pathsFound = NO;
    [self.path removeAllObjects];
    [self.paths removeAllObjects];
    [self resetMoveRecords];
    NSLog(@"COMMENCE THE WALKING!!!");
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
        NSLog(@"on %d,%d turn %d", self.currentTile.x, self.currentTile.y, turn);
        NSInteger newDirection = [self findNewDirectionFromTurn:turn withOldDirection:oldDirection];
        //if the tile exists
        id targetTileMaybe = [self findTileInDirection:newDirection];
        if (targetTileMaybe != (id)[NSNull null]) {
            Tile *targetTile = (Tile *)targetTileMaybe;
            //if you aren't moving back
            NSLog(@"1");
            if (turn < 3) {
                if ([self canMoveToTile:targetTile]) {
                    NSLog(@"10");
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
    NSLog(@"walk to %d,%d", targetTile.x, targetTile.y);
}

-(void)moveBackToTile:(Tile *)targetTile {
    if (self.currentTile != self.originTile) {
        [self addCoordPairToDictionary];
        [self.path removeLastObject];
        self.movePoints = self.movePoints + self.currentTile.moveCost;
        self.currentTile = targetTile;
        NSLog(@"walk back to %d,%d", targetTile.x, targetTile.y);
    }
}

-(void)addCoordPairToDictionary {
    NSString *coordString = [NSString stringWithFormat:@"%d,%d", self.currentTile.x, self.currentTile.y];
//    NSString *relevantKey = coordString;
//    for (NSString *key in self.paths) {
//        if ([key isEqualToString:coordString]) {
//            relevantKey = key;
//        }
//    }
    [self.paths setObject:self.path forKey:coordString];
    NSLog(@"add path %@ for tile at %@", self.path, coordString);
}

-(BOOL)canMoveToTile:(Tile *)targetTile {
    //returns true if the unit has more movepoints than the tile's moveCost and more movepoints than it had last time the tile was visited, else returns false
    if (self.movePoints >= targetTile.moveCost) {
        NSLog(@"2");
        if (self.moveRecords[targetTile.y - 1][targetTile.x - 1] != (id)[NSNull null]) {
            NSLog(@"3");
            NSInteger targetMoveRecord = [self.moveRecords[targetTile.y - 1][targetTile.x - 1] integerValue];
            NSLog(@"4");
            if ((self.movePoints - targetTile.moveCost) > targetMoveRecord) {
                return YES;
            } else {
                return NO;
            }
        } else {
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
    if ((tile.x >= 1) & (tile.x <= self.board.width) & (tile.y >= 1) & (tile.y <= self.board.height)) {
        tile = [self.board tileAtX:tile.x andY:tile.y];
        NSLog(@"5");
        return tile;
    } else {
        return (Tile *)[NSNull null];
    }
}

@end
