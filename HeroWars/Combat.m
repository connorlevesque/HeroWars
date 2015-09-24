//
//  Combat.m
//  HeroWars
//
//  Created by Connor Levesque on 2/20/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Combat.h"

@implementation Combat

- (id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
    }
    return self;
}

-(void)fightFirstUnit:(Unit *)a againstSecondUnit:(Unit *)b {
    NSLog(@" ");
    NSLog(@"%@ %@ attacks %@ %@", a.teamColor, a.name, b.teamColor, b.name);
    [self attack:b with:a];
    if ((b.health > 0) && ([self.board isUnit:a withinRangeOfUnit:b]) && (![b.type isEqualToString:@"artillery"])) {
        NSLog(@"%@ %@ counter attacks %@ %@", b.teamColor, b.name, a.teamColor, a.name);
        [self attack:a with:b];
    }
    NSLog(@" ");
}

-(void)attack:(Unit *)b with:(Unit *)a {
    // calculate rng, hitChance, and damage
    NSInteger rng = arc4random_uniform(100) + 1;
    NSInteger hitChance = [self hitChanceFrom:a toUnit:b];
    NSLog(@"%d (hitChance) = %d (accuracy) - %d (evasion) + %d (elevation) - %d (cover)", hitChance, a.accuracy, b.evasion, a.tile.elevation, b.tile.cover);
    NSInteger damage = [self attackDamageFrom:a toUnit:b];
    NSLog(@"%d chance of %d damage", hitChance, damage);
    // determine outcome
    if (rng > hitChance) {
        if (rng > a.accuracy) {
            NSLog(@"Miss!");
        } else {
            NSLog(@"Dodge!");
        }
    } else if (rng > a.critical) {
        b.health -= damage;
        NSLog(@"Hit! %d damage dealt", damage);
    } else {
        damage = 2 * damage;
        b.health -= damage;
        NSLog(@"Critical Hit! %d damage dealt", damage);
    }
    // levelUp unit A if unit B is killed
    if (b.health <= 0) {
        [a levelUp];
    }
}

-(NSInteger)hitChanceFrom:(Unit *)a toUnit:(Unit *)b {
    NSInteger hitChance = a.accuracy - b.evasion + a.tile.elevation - b.tile.cover;
    return hitChance;
}

-(NSInteger)attackDamageFrom:(Unit *)a toUnit:(Unit *)b {
    NSInteger damage = a.attack - b.defense;
    if ([b.type isEqualToString:a.bonusCondition] || [b.name isEqualToString:a.bonusCondition]) {
        damage += a.bonusDamage;
    }
    if (damage < 0) {
        damage = 0;
    }
    return damage;
}

@end
