//
//  LevelParser.h
//  HeroWars
//
//  Created by Connor Levesque on 5/25/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"
#import "AllUnits.h"
#import "AllBuildings.h"

@interface LevelParser : NSObject

@property (strong, nonatomic) NSArray *levelComponents;

// properties used by Gameboard
@property (strong, nonatomic) NSString *levelName;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;
@property (strong, nonatomic) NSMutableArray *tileGrid;
@property (strong, nonatomic) NSMutableArray *unitGrid;
@property (strong, nonatomic) NSArray *playerColors;
@property (nonatomic) NSInteger players;

-(void)makeGridsFromLevelFile:(NSString *)levelFile;

@end

