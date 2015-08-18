//
//  TileParser.h
//  HeroWars
//
//  Created by Connor Levesque on 7/29/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TileParser : NSObject

// Tile Name
@property (strong, nonatomic) NSString *tileName;
// Tile Gameplay Properties
@property (strong, nonatomic) NSMutableDictionary *movecosts;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) NSInteger elevation;
@property (nonatomic) NSInteger cover;
// Building/Production only properties
@property (nonatomic) NSInteger owner;
@property (nonatomic) NSInteger control;

-(void)parseStatsForTileNamed:(NSString *)tileName;

@end
