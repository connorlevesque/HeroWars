//
//  Map.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Map.h"

@implementation Map

//-(id)init{
//    self = [super init];
//    if (self){
//        Tile *tile = [[Tile alloc]init];
//        tile.type = @"plains";
//        self.tileArray = [[NSMutableArray alloc]init];
//        for (int i = 0; i<25; i++){
//            [_tileArray addObject:tile];
//        }
//    }
//    for (Tile *tile in self.tileArray){
//        NSLog(@"%@", tile.type);
//    }
//    return self;
//}

-(id)initWithArray: (NSMutableArray *) array Height:(int)height andWidth:(int)width {
    self = [super init];
    if (self){
        self.height = height;
        self.width = width;
        for (NSString *type in array){
            Tile *tile = [[Tile alloc]initWithType:type];
            //NSLog(@"%@", tile.type);
            [self.tileArray addObject:type];
            //so addobject wasnt working so were gonna tryo soehting else
            //NSLog(@"%lu", [self.tileArray count]);
//            for (Tile *tile in self.tileArray){
//                NSLog(@"%@", tile.type);
//            }
        }
    }
    return self;
}

+(NSMutableArray *)makePlainsArray{
    //returns an array for testing. it works.
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i<2; i++){
        [array addObject:@"plains"];
    }
    return array;
}


@end
