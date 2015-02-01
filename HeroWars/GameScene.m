//
//  GameScene.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//
#import "Map.h"
#import "GameScene.h"
#import "Gameboard.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    Map *map = [[Map alloc]initWithArray:[Map makePlainsArray] Height:5 andWidth:5];
    Gameboard *board = [[Gameboard alloc]initWithMap:map];
    NSLog(@"grid count is %lu", board.grid.count);
    
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
