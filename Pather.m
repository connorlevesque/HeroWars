//
//  Pather.m
//  HeroWars
//
//  Created by Max Shashoua on 2/9/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Pather.h"

@implementation Pather

-(id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
    }
    return self;
}

-(void)loadWithUnit:(Unit *)unit {
    self.x = unit.x;
    self.y = unit.y;
    self.monies = unit.move;
    self.moveCount = 0;
    self.lastCount = -1;
    self.pathsArray = [[NSMutableArray alloc]init];
    self.currentPath = [[NSMutableArray alloc]initWithObjects:self.board.tileGrid[self.y][self.x], nil];
    //self.toBeHighlighted = [[NSMutableSet alloc]initWithObjects:self.board.tileGrid[self.y - 1][self.x - 1], nil];
    [self path];
    //NSLog(@"%@", self.pathsArray);
}

-(BOOL)canMoveInDirection:(NSString *)direction {
    if (self.currentPath.count == 1) {
        if ([direction isEqualToString:@"N"]) {
            if (self.y == self.board.height){

                return NO;
                
            }else if ((self.monies == 0)||(![self.board.unitGrid[self.y + 1][self.x] isKindOfClass:[NSNull class]])) {
                return NO;
                
            }
            
        }else if ([direction isEqualToString:@"S"]) {
            if (self.y == 1){
                return NO;
            }else if ((self.monies == 0)||(![self.board.unitGrid[self.y - 1][self.x] isKindOfClass:[NSNull class]])) {
                return NO;
            }
            
        }else if ([direction isEqualToString:@"E"]){
            if (self.x == self.board.height){
                return NO;
            }else if ((self.monies == 0)||(![self.board.unitGrid[self.x + 1][self.x] isKindOfClass:[NSNull class]])) {
                return NO;
            }
            
        }else if ([direction isEqualToString:@"W"]){
            if (self.x == 1){
                return NO;
            }else if ((self.monies == 0)||(![self.board.unitGrid[self.x - 1][self.x] isKindOfClass:[NSNull class]])) {
                return NO;
            }
        }

    }
    else if ([direction isEqualToString:@"N"]) {
        if (self.y == self.board.height){
            return NO;
        }else if ((self.monies == 0)||(self.board.tileGrid[self.y + 1][self.x] == self.currentPath[self.moveCount - 1])||(![self.board.unitGrid[self.y + 1][self.x] isKindOfClass:[NSNull class]])) {
            return NO;
        }
    
    }else if ([direction isEqualToString:@"S"]) {
        if (self.y == 1){
            return NO;
        }else if ((self.monies == 0)||(self.board.tileGrid[self.y - 1][self.x] == self.currentPath[self.moveCount - 1])||(![self.board.unitGrid[self.y - 1][self.x] isKindOfClass:[NSNull class]])) {
            return NO;
        }
    
    }else if ([direction isEqualToString:@"E"]){
        if (self.x == self.board.height){
            return NO;
        }else if ((self.monies == 0)||(self.board.tileGrid[self.x + 1][self.x] == self.currentPath[self.moveCount - 1])||(![self.board.unitGrid[self.x + 1][self.x] isKindOfClass:[NSNull class]])) {
            return NO;
        }

    }else if ([direction isEqualToString:@"W"]){
        if (self.x == 1){
            return NO;
        }else if ((self.monies == 0)||(self.board.tileGrid[self.x - 1][self.x] == self.currentPath[self.moveCount - 1])||(![self.board.unitGrid[self.x - 1][self.x] isKindOfClass:[NSNull class]])) {
            return NO;
        }
    }
    return YES;
    
    
}

-(void)move:(NSString *)direction {
    if ([direction isEqualToString:@"N"]){
        self.y ++;
    } else if ([direction isEqualToString:@"S"]){
        self.y --;
    } else if ([direction isEqualToString:@"E"]){
        self.x ++;
    } else if ([direction isEqualToString:@"W"]){
        self.x --;
    }
    [self.currentPath addObject:self.board.tileGrid[self.y][self.x]];
    [self.toBeHighlighted addObject:self.board.tileGrid[self.y][self.x]];
    self.lastCount = self.moveCount;
    self.moveCount ++;
    self.monies --;
    NSLog(@"pather moved to (%d, %d)", self.x, self.y);
}

-(void)stepBack {
    self.lastCount = self.moveCount;
    self.moveCount --;
    
    [self.currentPath removeLastObject];
    Tile *oldTile = [self.currentPath lastObject];
    self.x = oldTile.x - 1;
    self.y = oldTile.y - 1;
    self.monies ++;
    NSLog(@"stepBack to (%d, %d)", self.x, self.y);
}

+(NSArray *)directions {
    return @[@"N", @"S", @"E", @"W"];
}


-(void)path {
    for (NSString *direction in [Pather directions]) {
        if ([self canMoveInDirection:direction]) {
            //NSLog(@"can Move!!");
            [self move:direction];
            [self path];
        }
    }
    if (self.lastCount < self.moveCount) {
        [self.pathsArray addObject:self.currentPath];
    }
    //NSLog(@"///%d", self.currentPath.count);
        [self stepBack];
}



@end
