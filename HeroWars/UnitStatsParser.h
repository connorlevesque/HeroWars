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
@property (nonatomic) NSInteger damageL;
@property (nonatomic) NSInteger damageH;
@property (nonatomic) NSInteger armor;
@property (nonatomic) NSInteger totalHealth;
// Unit Function Properties
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *zone;
@property (strong, nonatomic) NSArray *targets;
@property (nonatomic) NSInteger move;
@property (strong, nonatomic) NSArray *range;
@property (nonatomic) NSInteger vision;
@property (nonatomic) NSInteger cost;
// Unit Ability Properties
@property (nonatomic) BOOL isCarrier;
@property (nonatomic) BOOL isBold;

-(void)parseStatsForUnitNamed:(NSString *)unitName;

@end
