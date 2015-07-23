//
//  Unit.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@implementation Unit

-(id)initUnitNamed:(NSString *)unitName onTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        // set implicit properties
        self.anchorPoint = CGPointMake(0,0);
        self.x = tile.x;
        self.y = tile.y;
        self.owner = owner;
        self.teamColor = playerColors[self.owner - 1];
        self.state = @"awake";
        // parse unit statistics
        UnitStatsParser *parser = [[UnitStatsParser alloc]init];
        [parser parseStatsForUnitNamed:unitName];
        // set name specific properties
        self.name = parser.unitName;
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.name, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        // set combat properties
        self.accuracy = parser.accuracy;
        self.evasion = parser.evasion;
        self.critical = parser.critical;
        self.damage = parser.damage;
        self.defense = parser.defense;
        self.totalHealth = parser.totalHealth;
        self.bonusCondition = parser.bonusCondition;
        self.bonusDamage = parser.bonusDamage;
        // set function properties
        self.type = parser.type;
        self.zone = parser.zone;
        self.targets = parser.targets;
        self.move = parser.move;
        self.range = parser.range;
        self.vision = parser.vision;
        self.actions = parser.actions;
        self.cost = parser.cost;
        // set dynamic properties
        self.health = self.totalHealth;
        self.level = 0;
    }
    return self;
}

-(void)changeStateTo:(NSString *)state {
    self.state = state;
    if ([self.state isEqualToString:@"awake"]) {
        self.alpha = 1;
        //NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        //self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
        self.alpha = .5;
        //NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_gray", self.type];
        //self.texture = [SKTexture textureWithImageNamed:imageName];
    } else {
        NSLog(@"Error: unknown state named passed to unit %@", self);
    }
}

-(void)refreshTexture {
    if ([self.state isEqualToString:@"awake"]) {
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
            NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_gray", self.type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
    }
}

@end
