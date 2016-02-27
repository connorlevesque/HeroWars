//
//  Unit.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@implementation Unit

int MAX_UNIT_LEVEL = 4;

-(id)initUnitNamed:(NSString *)unitName onTile:(Tile *)tile withColors:(NSArray *)playerColors withOwner:(NSInteger)owner {
    self = [super init];
    if (self) {
        // set implicit properties
        self.anchorPoint = CGPointMake(0,0);
        self.tile = tile;
        self.owner = owner;
        self.teamColor = playerColors[self.owner - 1];
        self.state = @"awake";
        self.cargo = (Unit *)[NSNull null];
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
        self.damageL = parser.damageL;
        self.damageH = parser.damageH;
        self.armor = parser.armor;
        self.totalHealth = parser.totalHealth;
        // set function properties
        self.type = parser.type;
        self.zone = parser.zone;
        self.targets = parser.targets;
        self.move = parser.move;
        self.range = parser.range;
        self.vision = parser.vision;
        self.cost = parser.cost;
        // set dynamic properties
        self.health = self.totalHealth;
        self.level = 0;
        // set action properties
        self.isCarrier = parser.isCarrier;
        self.isBold = parser.isBold;
    }
    return self;
}

-(BOOL)canCarry {
    if ((self.isCarrier == YES) && (![self isCarrying])) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)canBeCarried {
    if ([self.type isEqualToString:@"infantry"]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isCarrying {
    if (self.cargo == (Unit *)[NSNull null]) {
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)isCarried {
    if (self.carrier == (Unit *)[NSNull null]) {
        return NO;
    } else {
        return YES;
    }
}

-(void)levelUp {
    if (self.level < MAX_UNIT_LEVEL) {
        self.level++;
        // STAT BONUSES GO HERE
    }
}

-(void)changeStateTo:(NSString *)state {
    self.state = state;
    if ([self.state isEqualToString:@"awake"]) {
        self.alpha = 1;
        //NSString *imageName = [NSString stringWithFormat:@"HeroWars_%@_%@", self.type, self.teamColor];
        //self.texture = [SKTexture textureWithImageNamed:imageName];
    } else if ([self.state isEqualToString:@"asleep"]) {
        self.alpha = .6;
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
