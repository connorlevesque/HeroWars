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

NSInteger CELL_SIZE = 100;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setAnchorPoint:CGPointMake(0, 0)];
    NSArray *typeArray = @[@"p",@"f",@"p",@"p",@"p",
                          @"p",@"p",@"f",@"p",@"p",
                          @"p",@"p",@"f",@"p",@"p",
                          @"p",@"f",@"p",@"p",@"p",
                          @"p",@"p",@"p",@"p",@"p",];
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
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    Tile *touchedTile = [self getNodeAtTouch:positionInScene];
    NSLog(@"(%ld, %ld): %@", touchedTile.x, touchedTile.y, touchedTile.type);

}

-(SKSpriteNode *)getNodeAtTouch:(CGPoint)touchLocation{
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    return touchedNode;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
