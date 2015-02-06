//
//  GameScene.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

NSInteger CELL_SIZE = 100;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setAnchorPoint:CGPointMake(0, 0)];
    self.inputManager = [[InputManager alloc]init];
    NSArray *typeArray = @[@"p",@"p",@"f",@"p",@"p",
                          @"p",@"p",@"f",@"p",@"p",
                          @"f",@"f",@"f",@"f",@"f",
                          @"p",@"p",@"f",@"p",@"p",
                          @"p",@"p",@"f",@"p",@"p",];
    Map *map = [[Map alloc]initWithArray:typeArray];
    _board = [[Gameboard alloc]initWithMap:map];
    [self drawGrid];
    
}

-(void)drawGrid {
    // draws the grid of tiles in the board
    for (int r = 0; r < [_board.grid count]; r++) {
        NSArray *row = _board.grid[r];
        for (int c = 0; c < [row count]; c++) {
            Tile *tile = _board.grid[r][c];
            tile.position = CGPointMake(c * CELL_SIZE, r * CELL_SIZE);
            [self addChild:tile];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    self.hasTouchSent = NO;
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    self.touchedNode = [self getNodeAtTouch:positionInScene];
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(onTouchTimer) userInfo:nil repeats:NO];
    
}


-(void)onTouchTimer{
    // method that is called when the touchTimer fires
    if (!self.hasTouchSent){
        [self.inputManager receiveInputWithNode:self.touchedNode andString:@"hold"];
        self.hasTouchSent = YES;
    }
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.hasTouchSent){
        UITouch *touch = [touches anyObject];
        if (![self.touchedNode containsPoint: [touch locationInNode:self]]){
            [self.inputManager receiveInputWithNode:self.touchedNode andString:@"drag"];
            self.hasTouchSent = YES;
        }
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    if (!self.hasTouchSent){
        [self.inputManager receiveInputWithNode:self.touchedNode andString:@"tap"];
        self.hasTouchSent = YES;
    }

}


-(SKNode *)getNodeAtTouch:(CGPoint)touchLocation{
        SKNode *touchedNode = (SKNode *)[self nodeAtPoint:touchLocation];
        return touchedNode;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
