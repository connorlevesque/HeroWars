//
//  Pather.h
//  HeroWars
//
//  Created by Max Shashoua on 2/9/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Gameboard.h"


@interface Pather : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger monies;
@property (nonatomic) NSInteger lastCount;
@property (nonatomic) NSInteger moveCount;
@property (strong, nonatomic) Gameboard *board;
@property (strong, nonatomic) NSMutableArray *currentPath;
@property (strong, nonatomic) NSMutableArray *pathsArray;
@property (strong, nonatomic) NSMutableSet *toBeHighlighted;

-(id)initWithBoard:(Gameboard *)board;


-(void)loadWithUnit:(Unit *)unit;


-(BOOL)canMoveInDirection:(NSString *)direction;


-(void)move:(NSString *)direction;


-(void)stepBack;


-(void)path;

+(NSArray *)directions;

@end
