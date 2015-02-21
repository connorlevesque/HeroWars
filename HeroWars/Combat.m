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
    NSLog(@"%@ %@ attacks %@ %@", self.a.teamColor, self.a.type, self.b.teamColor, self.b.type);
    [self attack];
    if ((self.b.health > 0) && ([self.board isUnit:a withinRangeOfUnit:b])) {
        NSLog(@"%@ %@ counter attacks %@ %@", self.b.teamColor, self.b.type, self.a.teamColor, self.a.type);
        [self counterAttack];
    }
    NSLog(@"");
}

-(void)attack {
    if ((arc4random() % 100) < self.a.accuracy) {
        double equipmentModifier = self.b.armor - self.a.weapon + 1;
        if (equipmentModifier < 1) {
            equipmentModifier = 1;
        } else {
            equipmentModifier = pow(0.5,equipmentModifier);
        }
        NSInteger damage = (self.a.power + (arc4random() % 10)) * equipmentModifier;
        NSLog(@"Hit! %d damage dealt", damage);
        self.b.health -= damage;
        NSLog(@"%@ %@ health is %d", self.b.teamColor, self.b.type, self.b.health);
    } else {
        NSLog(@"Miss!");
    }
}

-(void)counterAttack {
    if ((arc4random() % 100) < self.b.accuracy) {
        double equipmentModifier = self.a.armor - self.b.weapon + 1;
        if (equipmentModifier < 1) {
            equipmentModifier = 1;
        } else {
            equipmentModifier = pow(0.5,equipmentModifier);
        }
        NSInteger damage = (self.b.power + (arc4random() % 10)) * equipmentModifier;
        NSLog(@"Hit! %d damage dealt", damage);
        self.a.health -= damage;
        NSLog(@"%@ %@ health is %d", self.a.teamColor, self.a.type, self.a.health);
    } else {
        NSLog(@"Miss!");
    }
}

@end
