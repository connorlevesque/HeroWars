//
//  Gameboard.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Gameboard.h"
#import "Tile.h"
#import "Map.h"

CELLSIZE = 25;

@interface Gameboard ()

@end

@implementation Gameboard


-(id)initWithMap:(Map *)map{
    self = [super init];
    if (self){
        self.grid = [[NSMutableArray alloc]init];
        self.map = map;
        for (int i = 0;i<map.height;i++) {
            //NSLog(@"1");
            NSMutableArray *row = [[NSMutableArray alloc]init];
            for (int j = 0;i<map.width;i++){
                //NSLog(@"2");
                if ([map.tileArray objectAtIndex:(i*map.width + j)] == nil){
                    NSLog(@"nilExceptionCaught motherfucker");
                    break;
                }
                [row addObject:[map.tileArray objectAtIndex:(i*map.width + j)]];
            }
            [self.grid addObject:row];
        }
    
    }
//    for (NSMutableArray *y in self.grid){
//        NSLog(@"");
//        for (Tile *tile in y){
//            NSLog(@"%@", tile.type);
//        }
//    }
    return self;
}

-(void)drawInScene:(SKScene *) scene{
    for (NSMutableArray *row in self.grid){
        int x = 200;
        for (Tile *tile in row){
            

        }
        x = x + CELLSIZE;
    }
}



//-(Tile *)getTileAtGridCoordinate:(NSInteger *)x and:(NSInteger *)y{
//    
//    return tile;
//}


@end