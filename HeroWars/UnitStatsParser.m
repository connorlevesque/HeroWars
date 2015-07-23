//
//  UnitStatsParser.m
//  HeroWars
//
//  Created by Connor Levesque on 7/23/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "UnitStatsParser.h"

@implementation UnitStatsParser

-(void)parseStatsForUnitNamed:(NSString *)unitName {
    NSArray *unitStatistics = [self getStatsForUnitNamed:unitName];
    self.unitName = unitStatistics[0];
    // set unit combat properties
    self.accuracy = [(NSString *)unitStatistics[1] integerValue];
    self.evasion = [(NSString *)unitStatistics[2] integerValue];
    self.critical = [(NSString *)unitStatistics[3] integerValue];
    self.damage = [(NSString *)unitStatistics[4] integerValue];
    self.defense = [(NSString *)unitStatistics[5] integerValue];
    self.totalHealth = [(NSString *)unitStatistics[6] integerValue];
    self.bonusCondition = unitStatistics[7];
    self.bonusDamage = [(NSString *)unitStatistics[8] integerValue];
    // set unit function properties
    self.type = unitStatistics[9];
    self.zone = unitStatistics[10];
    self.targets = [self targetsArrayFromString:unitStatistics[11]];
    self.move = [(NSString *)unitStatistics[12] integerValue];
    self.range = [self rangeArrayFromString:unitStatistics[13]];
    self.vision = [(NSString *)unitStatistics[14] integerValue];
    self.actions = [(NSString *)unitStatistics[15] componentsSeparatedByString:@","];
    self.cost = [(NSString *)unitStatistics[16] integerValue];
}

-(NSArray *)getStatsForUnitNamed:(NSString *)unitName {
    // retrieve UnitStatistics file
    NSString *pathString = @"/UnitStatistics";
    NSString *path = [[NSBundle mainBundle] pathForResource:pathString ofType:@"txt"];
    NSString *unitStatsString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // remove white space and capitalization
    unitStatsString = [unitStatsString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    unitStatsString = [unitStatsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    unitStatsString = [unitStatsString lowercaseString];
    // parse into arrays and return the array with the unit's statistics
    NSMutableArray *unitComponents = (NSMutableArray *)[unitStatsString componentsSeparatedByString:@"!"];
    [unitComponents removeObjectAtIndex:0];
    for (NSString *unitRow in unitComponents) {
        NSArray *statComponents = [unitRow componentsSeparatedByString:@"|"];
        if ([unitName isEqualToString:statComponents[0]]) {
            return statComponents;
        }
    }
    NSLog(@"Error: unknown unitName passed to UnitStatsParser");
    return nil;
}


// helper methods to handle the messier conversions from string components to arrays

-(NSArray *)targetsArrayFromString:(NSString *)targetsString {
    if ([targetsString isEqualToString:@"all"]) {
        return @[@"ground",@"sea",@"air"];
    } else {
        return [targetsString componentsSeparatedByString:@","];
    }
}

-(NSArray *)rangeArrayFromString:(NSString *)rangeString {
    NSMutableArray *rangeArray = [[NSMutableArray alloc]init];
    for (NSString *numberString in [rangeString componentsSeparatedByString:@"-"]) {
        [rangeArray addObject:[NSNumber numberWithInteger:[numberString integerValue]]];
    }
    if ([rangeArray count] == 1) {
        [rangeArray addObject:rangeArray[0]];
    }
    return rangeArray;
}

@end
