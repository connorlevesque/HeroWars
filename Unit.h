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
//@property (nonatomic) NSInteger x;
//@property (nonatomic) NSInteger y;
@property (weak, nonatomic) Tile *tile;
@property (nonatomic) NSInteger owner;
@property (strong, nonatomic) NSString *teamColor;
@property (strong, nonatomic) NSString *state;

// Combat Properties
@property (nonatomic) NSInteger damageL;
@property (nonatomic) NSInteger damageH;
@property (nonatomic) NSInteger armor;
@property (nonatomic) NSInteger totalHealth;

// Function Properties
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *zone;
@property (strong, nonatomic) NSArray *targets;
@property (nonatomic) NSInteger move;
@property (strong, nonatomic) NSArray *range;
@property (nonatomic) NSInteger vision;
@property (nonatomic) NSInteger cost;

// Dynamic Properties
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger level;

// Action Properties
@property (nonatomic) BOOL isCarrier;
@property (strong, nonatomic) Unit *cargo;
@property (weak, nonatomic) Unit *carrier;
@property (nonatomic) BOOL isBold;

// Methods
-(id)initUnitNamed:(NSString *)unitName onTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner;
-(BOOL)canCarry;
-(BOOL)canBeCarried;
-(BOOL)isCarrying;
-(BOOL)isCarried;
-(void)levelUp;
-(void)changeStateTo:(NSString *)state;
-(void)refreshTexture;

@end

