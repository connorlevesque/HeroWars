//
//  Gameboard.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#ifndef HeroWars_Gameboard_h
#define HeroWars_Gameboard_h

#endif
#import "Map.h"


@interface Gameboard : NSObject

@property (strong, nonatomic) NSArray *tiles;
@property (strong, nonatomic) Map *map;
@property (strong, nonatomic) NSMutableArray *grid;


-(id)initWithMap:(Map *)map;
-(NSMutableArray)makeArrayForDrawing;
//-(Tile *)getTileAtGridCoordinate:(NSInteger *)x and:(NSInteger *)y;



/*
 Tile Types:
 Plains
 Road
 Forest
 Mountain
 River
 Sea
 Town
 Production Buildings (pending)
 */


@end