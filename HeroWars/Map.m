//
//  Map.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Map.h"

@implementation Map

-(id)initWithArray:(NSArray *)typeArray {
    self = [super init];
    if (self){
        //set height and width
        self.height = 10;
        self.width = 20;
        //make map array
        self.tileArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [typeArray count]; i++){
            NSString *type = typeArray[i];
            Tile *tile = [[Tile alloc]initWithType:type];
            [_tileArray addObject:tile];
        }
    }
    return self;
}

@end
