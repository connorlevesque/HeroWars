//
//  GameScene.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

NSInteger CELL_SIZE = 51;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setAnchorPoint:CGPointMake(0, 0)];
    self.inputManager = [[InputManager alloc]init];
    NSArray *typeArray = @[@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"f",@"f",@"f",@"f",@"f",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"f",@"f",@"f",@"f",@"f",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",
                           @"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p",@"p",@"p",@"f",@"p",@"p"];
    Map *map = [[Map alloc]initWithArray:typeArray];
    _board = [[Gameboard alloc]initWithMap:map];
    self.world = [[SKNode alloc]init];
    self.world.position = CGPointMake(0,0);
    //self.world.frame.size = CGSizeMake(self.board.map.width * CELL_SIZE, self.board.map.height * CELL_SIZE);
    [self addChild:self.world];
    [self drawGrid];
    self.touchState = 0;
}

-(void)drawGrid {
    // draws the grid of tiles in the board
    for (int r = 0; r < [_board.grid count]; r++) {
        NSArray *row = _board.grid[r];
        for (int c = 0; c < [row count]; c++) {
            Tile *tile = _board.grid[r][c];
            tile.position = CGPointMake(c * CELL_SIZE, r * CELL_SIZE);
            [self.world addChild:tile];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    self.lastTouch = [touch locationInNode:self];
    self.touchedNode = [self getNodeAtTouch:self.lastTouch];
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(onTouchTimer) userInfo:nil repeats:NO];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // Drag stuff
    if ((self.touchState < 2) & [self.inputManager canDrag]){
        self.touchState = 1;
        UITouch *newTouch = [touches anyObject];
        CGPoint transformation = [self makeDragVectorWith:newTouch];
        self.lastTouch = [newTouch locationInNode:self];
        self.world.position = CGPointMake(self.world.position.x + transformation.x, self.world.position.y +transformation.y);
        [self.touchTimer invalidate];
    }
}

-(void)onTouchTimer{
    // method that is called when the touchTimer fires
    if (self.touchState == 0){
        self.touchState = 2;
        [self.inputManager receiveInputWithNode:self.touchedNode andString:@"hold"];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    if (self.touchState == 0) {
        [self.touchTimer invalidate];
        [self.inputManager receiveInputWithNode:self.touchedNode andString:@"tap"];
    }
    self.touchState = 0;
}


-(SKNode *)getNodeAtTouch:(CGPoint)touchLocation{
        SKNode *touchedNode = (SKNode *)[self nodeAtPoint:touchLocation];
        return touchedNode;
}

-(CGPoint)makeDragVectorWith:(UITouch *)movedTouch {
    //make drag point
    CGPoint new = [movedTouch locationInNode:self];
    CGPoint old = self.lastTouch;
    CGPoint dragPoint = CGPointMake(new.x - old.x, new.y - old.y);

    float minX = self.frame.size.width - self.board.map.width * CELL_SIZE;
    float minY = self.frame.size.height - self.board.map.height * CELL_SIZE;
    
    //if we dont wanna drag left anymore
    if ((self.world.position.x <= minX) & (dragPoint.x < 0)) {
        dragPoint.x = 0;
        self.world.position = CGPointMake(minX, self.world.position.y);
    }
    //if we dont wanna drag right anymore
    if ((self.world.position.x >= 0) & (dragPoint.x > 0)) {
        dragPoint.x = 0;
        self.world.position = CGPointMake(0, self.world.position.y);
    }
    //if we dont wanna drag up anymore
    if ((self.world.position.y >= 0) & (dragPoint.y > 0)) {
        dragPoint.y = 0;
        self.world.position = CGPointMake(self.world.position.x, 0);
    }
    //if we dont wanna drag down anymore
    if ((self.world.position.y <= minY) & (dragPoint.y < 0)) {
        dragPoint.y = 0;
        self.world.position = CGPointMake(self.world.position.x, minY);
    }
    
    NSLog(@"(%f,%f)", dragPoint.x, dragPoint.y);
    return dragPoint;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
