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
    [self attack:self.a with:self.b];
    if ((self.b.health > 0) && ([self.board isUnit:a withinRangeOfUnit:b])) {
        NSLog(@"%@ %@ counter attacks %@ %@", self.b.teamColor, self.b.type, self.a.teamColor, self.a.type);
        [self attack:self.b with:self.a];
    }
    NSLog(@"");
}

-(void)attack:(Unit *)a with:(Unit *)b {
    NSInteger hitRN = (arc4random() % 100);
    if (hitRN < a.accuracy) {
        float equipmentModifier = (float)(100 + a.weapon - b.armor) / 100;
//        if (equipmentModifier > 1) {
//            equipmentModifier = 1;
//        } else if (equipmentModifier < 0) {
//            equipmentModifier = 0;
//        } 
        float healthModifier = (float)a.health / 100;
        NSInteger damageRN = (arc4random() % 11) - 5;
        NSInteger damage = a.power * equipmentModifier * healthModifier + damageRN;
        if (damage < 0) {
            damage = 0;
        }
        NSLog(@"    Damage = %d * %f * %f + %d = %d", a.power, equipmentModifier, healthModifier, damageRN, damage);
        b.health -= damage;
        NSLog(@"    %@ %@ health is %d", b.teamColor, b.type, b.health);
        ;
    } else {
        NSLog(@"    Miss!");
    }
}

@end
