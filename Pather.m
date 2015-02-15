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
    self.unit = unit;
    self.board = board;
    self.originTile = [self.board tileAtX:self.unit.x andY:self.unit.y];
    self.currentTile = self.originTile;
    self.pathsFound = NO;
    [self.path removeAllObjects];
    [self.paths removeAllObjects];
    [self resetMoveRecords];
    [self walkInDirection:0];
    return self.paths;
}

-(void)resetMoveRecords {
    if (!self.moveRecords) {
        self.moveRecords = [[NSMutableArray alloc]init];
        for (int r = 1; r <= self.board.height; r++) {
            NSMutableArray *row = [[NSMutableArray alloc]init];
            for (int c = 1; c <= self.board.width; c++) {
                [row addObject:@0];
            }
            [self.moveRecords addObject:row];
        }
    } else {
        for (int r = 1; r <= self.board.height; r++) {
            for (int c = 1; c <= self.board.width; c++) {
                self.moveRecords[r][c] = @0;
            }
        }
    }
    self.moveRecords[self.originTile.y][self.originTile.x] = [NSNumber numberWithInteger:self.unit.move];
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
        NSLog(@"turn %d", turn);
        NSInteger newDirection = [self findNewDirectionFromTurn:turn withOldDirection:oldDirection];
        Tile *targetTile = [self findTileInDirection:newDirection];
        //if the tile exists
        if (targetTile) {
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
    self.unit.move = self.unit.move - targetTile.moveCost;
    NSNumber *moveNum = [NSNumber numberWithInteger:self.unit.move];
    self.moveRecords[targetTile.y][targetTile.x] = moveNum;
    self.currentTile = targetTile;
    NSLog(@"walk to %d,%d", targetTile.x, targetTile.y);
}

-(void)moveBackToTile:(Tile *)targetTile {
    if (self.currentTile != self.originTile) {
//        NSNumber *tileXNumb = [NSNumber numberWithInteger:self.currentTile.x];
//        NSNumber *tileYNumb = [NSNumber numberWithInteger:self.currentTile.y];
//        NSArray *tileCoordPair = @[tileXNumb,tileYNumb];
//        NSLog(@"add path %@ for tile at %@", self.path, tileCoordPair);
//        [self.paths setObject:self.path forKey:tileCoordPair];
        [self addCoordPairToDictionary];
        [self.path removeLastObject];
        self.unit.move = self.unit.move + targetTile.moveCost;
        self.currentTile = targetTile;
        NSLog(@"walk back to %d,%d", targetTile.x, targetTile.y);
    }
}

-(void)addCoordPairToDictionary {
    NSNumber *tileXNumb = [NSNumber numberWithInteger:self.currentTile.x];
    NSNumber *tileYNumb = [NSNumber numberWithInteger:self.currentTile.y];
    NSArray *thisCoordPair = @[tileXNumb,tileYNumb];
    for (NSArray *coordPair in self.paths) {
        if (thisCoordPair == coordPair) {
            self.paths[coordPair] = self.path;
            NSLog(@"new path %@ for tile at %@", self.path, thisCoordPair);
        } else {
            [self.paths setObject:self.path forKey:thisCoordPair];
            NSLog(@"add path %@ for tile at %@", self.path, thisCoordPair);
        }
    }
}

-(BOOL)canMoveToTile:(Tile *)tile {
    //returns true if the unit has more movepoints than the tile's moveCost and more movepoints than it had last time the tile was visited, else returns false
    if ((self.unit.move >= tile.moveCost) & (self.unit.move > [self.moveRecords[tile.y][tile.x] integerValue])) {
        return YES;
    }
    return NO;
}

-(NSInteger)findNewDirectionFromTurn:(NSInteger)turn withOldDirection:(NSInteger)oldDirection {
    //returns the new cardinal direction given the old cardinal direction and what relative direction you are turning in
    NSInteger newDirection = (oldDirection + turn + 3) % 4;
    return newDirection;
}

-(Tile *)findTileInDirection:(NSInteger)direction {
    //returns the tile in the given cardinal direction
    Tile *tile = self.currentTile;
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
    tile = [self.board tileAtX:tile.x andY:tile.y];
    return tile;
}

@end
