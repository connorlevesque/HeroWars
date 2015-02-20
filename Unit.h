//
//  Unit.h
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Tile.h"

@interface Unit : SKSpriteNode

//General Unit Properties
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger owner;
@property (strong, nonatomic) NSString *state;

//Methods
-(void)changeStateTo:(NSString *)state;
-(void)refreshTexture;

//Static Gameplay Properties
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *group;

@property (nonatomic) NSInteger move;
@property (nonatomic) NSArray *range;

@property (nonatomic) NSInteger power;
@property (nonatomic) NSInteger weapon;
@property (nonatomic) NSInteger accuracy;
@property (nonatomic) NSInteger armor;

//Dynamic Gameplay Properties
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger experience;

@end

