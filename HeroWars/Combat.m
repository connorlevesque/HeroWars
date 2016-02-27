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
    int damage = [self attackDamageFrom:a toUnit:b];
    int r = arc4random_uniform(5) - 2;
    damage = damage + r;
    b.health -= damage;
    // levelUp unit A if unit B is killed
    if (b.health <= 0) {
        [a levelUp];
    }
}

-(NSInteger)attackDamageFrom:(Unit *)a toUnit:(Unit *)b {
    float h = (float)a.health / (float)a.totalHealth;
    if (a.isBold) {
        h = (h + 1) / 2;
    }
    int hD = a.damageH;
    int lD = a.damageL;
    int arm = b.armor;
    int damage = h * (hD + lD / pow(2,arm));
    return damage;
}

@end
