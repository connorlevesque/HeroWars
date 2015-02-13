//
//  Pather.m
//  HeroWars
//
//  Created by Connor Levesque on 2/11/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Pather.h"

@implementation Pather

/*
-(id)init {
    self = [super init];
    if (self) {
        self.path = [[NSMutableArray alloc]init];
        self.paths = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(NSMutableDictionary *)findPathsForUnit:(Unit *)unit andBoard:(Gameboard *)board {
    self.unit = unit;
    self.board = board;
    [self.path removeAllObjects];
    [self.paths removeAllObjects];
    [self walkInDirection:0];
    return self.paths;
}

-(void)walkInDirection:(NSInteger)oldDirection {
    //walks recursively through a path to every possible tile and adds paths to paths array
    //try to move in each face
        //Left = 0
        //Forwards = 1
        //Right = 2
        //Back = 3
 
    for (int face = 0; face < 4; face++) {
        //set function variables
        NSInteger newDirection = [self findNewDirectionFromFace:face withOldDirection:oldDirection];
        Tile *tile = [self findTileInDirection:newDirection];
        //if the tile exists
        if (tile) {
            //if you aren't moving back
            if (face < 3) {
                if ([self canMoveToTile:tile]) {
                    self.unit.move = self.unit.move - tile.moveCost;
                    tile.moveRecord = self.unit.move;
                    self.unit.tile = tile;
                    [self.path addObject:[NSNumber numberWithInteger:newDirection]];
                    [self walkInDirection:newDirection];
                }
            } else { //if you are moving back
                [self.paths setObject:self.path forKey:tile];
                self.unit.move = self.unit.move + tile.moveCost;
                self.unit.tile = tile;
                [self.path removeLastObject];
                [self walkInDirection:newDirection];
            }
        }
    }
}

-(BOOL)canMoveToTile:(Tile *)tile {
    if ((self.unit.move >= tile.moveCost) & (self.unit.move > tile.moveRecord)) {
        return YES;
    }
    return NO;
}

-(NSInteger)findNewDirectionFromFace:(NSInteger)face withOldDirection:(NSInteger)oldDirection {
    return (oldDirection + face - 1) % 4;
}

-(Tile *)findTileInDirection:(NSInteger)direction {
    Tile *tile = self.unit.tile;
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
    if ((tile.x < 1) || (tile.x > self.board.width) || (tile.y < 1) || (tile.y > self.board.height)) {
        tile = nil;
    }
    return tile;
}
*/

@end
