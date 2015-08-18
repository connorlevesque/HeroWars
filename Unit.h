//
//  Unit.h
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Tile.h"
#import "UnitStatsParser.h"

@interface Unit : SKSpriteNode

// General Properties
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (weak, nonatomic) Tile *tile;
@property (nonatomic) NSInteger owner;
@property (strong, nonatomic) NSString *teamColor;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *unitName;

// Combat Properties
@property (nonatomic) NSInteger accuracy;
@property (nonatomic) NSInteger evasion;
@property (nonatomic) NSInteger critical;
@property (nonatomic) NSInteger attack;
@property (nonatomic) NSInteger defense;
@property (nonatomic) NSInteger totalHealth;
@property (strong, nonatomic) NSString *bonusCondition;
@property (nonatomic) NSInteger bonusDamage;

// Function Properties
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *zone;
@property (strong, nonatomic) NSArray *targets;
@property (nonatomic) NSInteger move;
@property (strong, nonatomic) NSArray *range;
@property (nonatomic) NSInteger vision;
@property (strong, nonatomic) NSArray *actions;
@property (nonatomic) NSInteger cost;

// Dynamic Properties
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger level;

// Methods
-(id)initUnitNamed:(NSString *)unitName onTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner;
-(void)levelUp;
-(void)changeStateTo:(NSString *)state;
-(void)refreshTexture;

@end

