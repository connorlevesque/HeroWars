//
//  Gameboard.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Axeman.h"
#import "Tile.h"

@interface Gameboard : NSObject

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (strong, nonatomic) NSMutableArray *tileGrid;
@property (strong, nonatomic) NSMutableArray *unitGrid;

@property (nonatomic) NSInteger players;
@property (nonatomic) NSInteger currentPlayer;
//1-n^
@property (nonatomic) NSInteger day;

@property (strong, nonatomic) NSMutableArray *lastMoveInfo;
// @[x1,y1,x2,y2]

-(id)initWithMapNamed:(NSString *)mapName;
-(Tile *)tileAtX:(NSInteger)x andY:(NSInteger)y;
-(Unit *)unitAtX:(NSInteger)x andY:(NSInteger)y;
-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile;
-(Unit *)undoMoveUnit;
-(Unit *)addUnitOnTile:(Tile *)tile withName:(NSString *)name andOwner:(NSInteger)owner;
-(void)removeUnitFromTile:(Tile *)tile;

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