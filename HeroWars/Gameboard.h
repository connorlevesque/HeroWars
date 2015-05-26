//
//  Gameboard.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "AllUnits.h"
#import "Building.h"
#import "LevelParser.h"

@interface Gameboard : NSObject

@property (strong, nonatomic) LevelParser *levelParser;

@property (strong, nonatomic) NSString *levelName;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (strong, nonatomic) NSMutableArray *tileGrid;
@property (strong, nonatomic) NSMutableArray *unitGrid;
@property (nonatomic) NSInteger players;
@property (strong, nonatomic) NSArray *playerColors;

@property (nonatomic) NSInteger currentPlayer;
@property (nonatomic) NSInteger day;
@property (strong, nonatomic) NSMutableArray *lastMoveInfo;
// @[x1,y1,x2,y2]

-(id)initWithLevelNamed:(NSString *)mapName;
-(Tile *)tileAtX:(NSInteger)x andY:(NSInteger)y;
-(Unit *)unitAtX:(NSInteger)x andY:(NSInteger)y;
-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile;
-(Unit *)undoMoveUnit;
-(void)removeUnitFromTile:(Tile *)tile;
-(BOOL)isUnit:(Unit *)a withinRangeOfUnit:(Unit *)b;

@end