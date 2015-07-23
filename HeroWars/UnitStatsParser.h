//
//  UnitStatsParser.h
//  HeroWars
//
//  Created by Connor Levesque on 7/23/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitStatsParser : NSObject

// Unit Name
@property (strong, nonatomic) NSString *unitName;
// Unit Combat Properties
@property (nonatomic) NSInteger accuracy;
@property (nonatomic) NSInteger evasion;
@property (nonatomic) NSInteger critical;
@property (nonatomic) NSInteger damage;
@property (nonatomic) NSInteger defense;
@property (nonatomic) NSInteger totalHealth;
@property (strong, nonatomic) NSString *bonusCondition;
@property (nonatomic) NSInteger bonusDamage;
// Unit Function Properties
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *zone;
@property (strong, nonatomic) NSArray *targets;
@property (nonatomic) NSInteger move;
@property (strong, nonatomic) NSArray *range;
@property (nonatomic) NSInteger vision;
@property (strong, nonatomic) NSArray *actions;
@property (nonatomic) NSInteger cost;

-(void)parseStatsForUnitNamed:(NSString *)unitName;

@end
