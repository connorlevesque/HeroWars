//
//  Tile.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "SpriteKit/SpriteKit.h"
#import "TileParser.h"


@interface Tile : SKSpriteNode

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

// Tile Name
@property (strong, nonatomic) NSString *name;
// Tile Gameplay Properties
@property (strong, nonatomic) NSDictionary *movecosts;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) NSInteger elevation;
@property (nonatomic) NSInteger cover;
// Building/Production only properties
@property (nonatomic) NSInteger owner;
@property (nonatomic) NSInteger control;
@property (strong, nonatomic) NSString *teamColor;

-(id)initTileNamed:(NSString *)tileName;
-(id)initBuildingNamed:(NSString *)tileName withColors:(NSArray *)playerColors withOwner:(NSInteger)owner;

@end