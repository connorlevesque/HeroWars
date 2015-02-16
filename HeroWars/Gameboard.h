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


-(id)initWithMapNamed:(NSString *)mapName;
-(Tile *)tileAtX:(NSInteger)x andY:(NSInteger)y;
-(Unit *)unitAtX:(NSInteger)x andY:(NSInteger)y;
-(void)moveUnit:(Unit *)unit toTile:(Tile *)tile;

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