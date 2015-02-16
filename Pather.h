//
//  Pather.h
//  HeroWars
//
//  Created by Connor Levesque on 2/11/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gameboard.h"


@interface Pather : NSObject

@property (weak, nonatomic) Gameboard *board;
//@property (strong, nonatomic) Unit *unit;
@property (strong, nonatomic) Tile *originTile;
@property (strong, nonatomic) Tile *currentTile;
@property (nonatomic) NSInteger movePoints;

@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSMutableDictionary *paths;
@property (strong, nonatomic) NSMutableArray *moveRecords;

@property (nonatomic) BOOL pathsFound;

@property (nonatomic) NSInteger direction;
/*
    North = 0
    East = 1
    South = 2
    West = 3
 */

//-(NSMutableArray *)tileCoordsForUnit:(Unit *)unit andBoard:(Gameboard *)board;
-(NSMutableDictionary *)findPathsForUnit:(Unit *)unit andBoard:(Gameboard *)board;

@end
