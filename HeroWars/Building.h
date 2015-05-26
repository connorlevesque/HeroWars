//
//  Building.h
//  HeroWars
//
//  Created by Connor Levesque on 4/29/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Tile.h"

@interface Building : Tile

@property (nonatomic) NSInteger control;
@property (nonatomic) NSInteger owner;
@property (strong, nonatomic) NSString *teamColor;
@property (strong, nonatomic) NSArray *playerColors;

-(id)initTownWithColors:(NSArray *)playerColors andOwner:(NSInteger)owner;

@end
