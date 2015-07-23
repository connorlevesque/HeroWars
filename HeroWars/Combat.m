//
//  Combat.m
//  HeroWars
//
//  Created by Connor Levesque on 2/20/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Combat.h"

@implementation Combat

- (instancetype)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
    }
    return self;
}

-(void)fightFirstUnit:(Unit *)a againstSecondUnit:(Unit *)b {
    self.a = a;
    self.b = b;
    NSLog(@"");
    NSLog(@"%@ %@ attacks %@ %@", self.a.teamColor, self.a.name, self.b.teamColor, self.b.name);
    [self attack:self.b with:self.a];
    if ((self.b.health > 0) && ([self.board isUnit:a withinRangeOfUnit:b]) && (![self.b.type isEqualToString:@"artillery"])) {
        NSLog(@"%@ %@ counter attacks %@ %@", self.b.teamColor, self.b.name, self.a.teamColor, self.a.name);
        [self attack:self.a with:self.b];
    }
    NSLog(@"");
}

-(void)attack:(Unit *)b with:(Unit *)a {
    NSInteger rng = (arc4random() % 100) + 1;
    NSInteger damage = 0;
    // set bonus damage
    NSInteger bonusDamage = 0;
    NSInteger percentDamage = 0;
    if ([b.type isEqualToString:a.bonusCondition]) {
        bonusDamage = a.bonusDamage;
    }
    // determine outcome and damage and log
    if (rng > a.accuracy) {
        NSLog(@"Miss!");
    } else if (rng > a.accuracy - b.evasion) {
        NSLog(@"Dodge!");
    } else if (rng > a.critical) {
        damage = a.damage + bonusDamage - b.defense;
        percentDamage = 100 * damage / b.totalHealth;
        NSLog(@"Hit! %d damage dealt", percentDamage);
    } else {
        damage = 2 * (a.damage + bonusDamage - b.defense);
        NSLog(@"Critical Hit! %d damage dealt", percentDamage);
    }
    // adjust health
    b.health -= damage;
}

@end
