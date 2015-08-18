//
//  TileParser.m
//  HeroWars
//
//  Created by Connor Levesque on 7/29/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "TileParser.h"

@implementation TileParser

-(void)parseStatsForTileNamed:(NSString *)tileName {
    NSArray *tileStatistics = [self getStatsForTileNamed:tileName];
    self.tileName = tileStatistics[0];
    // set tile gameplay properties
    NSArray *moveTypes = @[@"infantry",@"cavalry",@"artillery",@"ships",@"flyers"];
    self.movecosts = [[NSMutableDictionary alloc]initWithObjects:@[@100,@100,@100,@100,@100] forKeys:moveTypes];
    for (int i = 0; i < [moveTypes count]; i++) {
        if (![tileStatistics[i+1] isEqualToString:@""]) {
            [self.movecosts setObject:[NSNumber numberWithInt:[(NSString *)tileStatistics[i+1] integerValue]] forKey:moveTypes[i]];
        }
    }
    self.type = tileStatistics[6];
    self.elevation = [(NSString *)tileStatistics[7] integerValue];
    self.cover = [(NSString *)tileStatistics[8] integerValue];
    // set building properties
    if ([self.type isEqualToString:@"building"] || [self.type isEqualToString:@"production"]) {
        self.control = 40;
    }
}

-(NSArray *)getStatsForTileNamed:(NSString *)tileName {
    // retrieve TileStatistics file
    NSString *pathString = @"/TileStatistics";
    NSString *path = [[NSBundle mainBundle] pathForResource:pathString ofType:@"txt"];
    NSString *tileStatsString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // remove white space and capitalization
    tileStatsString = [tileStatsString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tileStatsString = [tileStatsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    tileStatsString = [tileStatsString lowercaseString];
    // parse into arrays and return the array with the tile's statistics
    NSMutableArray *tileComponents = (NSMutableArray *)[tileStatsString componentsSeparatedByString:@"!"];
    [tileComponents removeObjectAtIndex:0];
    for (NSString *tileRow in tileComponents) {
        NSArray *statComponents = [tileRow componentsSeparatedByString:@"|"];
        if ([tileName isEqualToString:statComponents[0]]) {
            return statComponents;
        }
    }
    NSLog(@"Error: unknown tileName passed to tileStatsParser");
    return nil;
}

@end
