//
//  GameScene.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@implementation GameScene

NSInteger CELL_SIZE = 50;

-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self){
        // set up UI
        [self setAnchorPoint:CGPointMake(0,0)];
        self.touchState = 0;
        self.world = [[SKNode alloc]init];
        self.world.position = CGPointMake(0,0);
        [self addChild:self.world];
        // zoom gesture stuff
        CGFloat worldHeight = self.board.height * CELL_SIZE;
        CGFloat worldWidth = self.board.width * CELL_SIZE;
        self.minScale = MAX(self.frame.size.height / worldHeight, self.frame.size.width / worldWidth);
        self.maxScale = 1;
        self.zoomRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleZoom)];
        [self.view addGestureRecognizer:self.zoomRecognizer];
    }
    return self;
}

-(void)didMoveToView:(GameView *)view {
    /* Setup your scene here */
    // remove previous scene's UI elements
    // set up previousScene properties
    self.board = view.previousScene.board;
    self.world.position = view.previousScene.world.position;
    // update board
    [self updateBoard];
}

-(void)processTappedNode:(SKNode *)node {} // over written by subscenes

-(void)processHeldNode:(SKNode *)node {
    NSLog(@"%@ held", node.name);
}

-(void)updateBoard {
    // updates board
    //[self.world removeAllChildren];
    for (int r = 0; r < self.board.height; r++) {
        NSInteger thisY = r + 1;
        for (int c = 0; c < self.board.width; c++) {
            NSInteger thisX = c + 1;
            Tile *tile = [self.board tileAtX:thisX andY:thisY];
            [tile removeFromParent];
            [tile removeAllChildren];
            tile.position = CGPointMake(c * CELL_SIZE, r * CELL_SIZE);
            [self.world addChild:tile];
            id unitMaybe = [self.board unitAtX:thisX andY:thisY];
            if (!(unitMaybe == (id)[NSNull null])) {
                Unit *unit = self.board.unitGrid[r][c];
                [unit removeFromParent];
                if (unit.health > 0) {
                    [tile addChild:unit];
                    [self drawHealthForUnit:unit onTile:tile];
                    if (unit.level > 0) {
                        [self drawLevelForUnit:unit onTile:tile];
                    }
                } else {
                    [self.board removeUnitFromTile:tile];
                }
            }
        }
    }
    // draw scene omniscent non-board UI Elements
    [self drawFundsLabel];
}

-(void)drawHealthForUnit:(Unit *)unit onTile:(Tile *)tile {
    SKLabelNode *healthIndicator = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    healthIndicator.fontSize = 20;
    healthIndicator.position = CGPointMake(51,0);
    healthIndicator.horizontalAlignmentMode = 2; //right aligned
    healthIndicator.verticalAlignmentMode = 3; //bottom aligned
    healthIndicator.fontColor = [UIColor whiteColor];
    healthIndicator.text = [NSString stringWithFormat:@"%d", unit.health];
    [tile addChild:healthIndicator];
}

-(void)drawLevelForUnit:(Unit *)unit onTile:(Tile *)tile {
    SKLabelNode *levelIndicator = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    levelIndicator.fontSize = 20;
    levelIndicator.position = CGPointMake(0,0);
    levelIndicator.horizontalAlignmentMode = 1; //left aligned
    levelIndicator.verticalAlignmentMode = 3; //bottom aligned
    levelIndicator.fontColor = [UIColor colorWithRed:255.0 green:215.0 blue:0.0 alpha:1]; //goldColor
    NSString *levelText = @" ";
    switch (unit.level) {
        case 1:
            levelText = @"I";
            break;
        case 2:
            levelText = @"II";
            break;
        case 3:
            levelText = @"III";
            break;
        case 4:
            levelText = @"V";
            break;
        default:
            break;
    }
    levelIndicator.text = [NSString stringWithFormat:@"%@", levelText];
    [tile addChild:levelIndicator];
}

-(void)drawFundsLabel {
    SKLabelNode *fundsLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    fundsLabel.fontSize = 40;
    fundsLabel.position = CGPointMake(self.frame.size.width,self.frame.size.height);
    fundsLabel.horizontalAlignmentMode = 2; //right aligned
    fundsLabel.verticalAlignmentMode = 2; //top aligned
    fundsLabel.fontColor = [self colorWithPlayerColor:self.board.playerColors[self.board.currentPlayer - 1]];
    fundsLabel.text = [NSString stringWithFormat:@"%@", self.board.funds[self.board.currentPlayer - 1]];
    [self addChild:fundsLabel];
}

//-(void)highlightMoveTiles {
//    NSDictionary *paths = [self.inputManager findTileCoordsToMoveHighlight];
//    for (NSString *coordString in paths.allKeys) {
//        Highlight *highlight = [[Highlight alloc]initWithImageNamed:@"highlight_blue.png"];
//        NSArray *coordArray = [coordString componentsSeparatedByString:@","];
//        NSInteger x = [coordArray[0] integerValue];
//        NSInteger y = [coordArray[1] integerValue];
//        Tile *tile = [self.board tileAtX:x andY:y];
//        [self.highlightedTiles addObject:tile];
//        [tile addChild:highlight];
//    }
//}
//
//-(void)highlightAttackTiles {
//    NSArray *tileCoords = [self.inputManager findTileCoordsToAttackHighlight];
//    for (NSArray *coordPair in tileCoords) {
//        Highlight *highlight = [[Highlight alloc]initWithImageNamed:@"HeroWars_transparentBlue.png"];
//        NSInteger x = [coordPair[0] integerValue];
//        NSInteger y = [coordPair[1] integerValue];
//        Tile *tile = [self.board tileAtX:x andY:y];
//        [self.highlightedTiles addObject:tile];
//        [tile addChild:highlight];
//    }
//}

//-(void)unHighlightTiles {
//    for (Tile *tile in self.highlightedTiles) {
//        for (SKSpriteNode *child in tile.children) {
//            if ([child isKindOfClass:[Highlight class]]) {
//                [child removeFromParent];
//            }
//        }
//    }
//    [self.highlightedTiles removeAllObjects];
//}

// Input Methods

-(SKNode *)findKeyNodeFromTouchedNodes:(NSArray *)touchedNodes {
    //select keyNode from node hierarchy
    NSArray *nodeHierarchy = @[[Button class],[Menu class],[Highlight class],[Unit class],[Tile class]];
    SKNode *keyNode = [[SKNode alloc]init];
    for (Class classType in nodeHierarchy) {
        for (SKNode *node in touchedNodes) {
            if ([node isKindOfClass:classType]) {
                keyNode = node;
                return keyNode;
            }
        }
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    self.lastTouch = [touch locationInNode:self];
    self.touchedNodes = [self getNodesAtTouch:self.lastTouch];
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(onTouchTimer) userInfo:nil repeats:NO];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // if there is no touch or dragging is already occuring, and if we canDrag
    if (self.touchState < 2) {
        //reord that a drag is occuring
        self.touchState = 1;
        // make the transformation vector and adjust the scene accordingly
        UITouch *newTouch = [touches anyObject];
        CGPoint transformation = [self makeDragVectorWith:newTouch];
        self.lastTouch = [newTouch locationInNode:self];
        self.world.position = CGPointMake(self.world.position.x + transformation.x, self.world.position.y +transformation.y);
        // invalidate any hold timer
        [self.touchTimer invalidate];
    }
}

-(void)onTouchTimer {
    // if the touch is not a drag or a tap
    if (self.touchState == 0){
        //record that a hold is occuring
        self.touchState = 2;
        //notify input manager
        [self processHeldNode:[self findKeyNodeFromTouchedNodes:self.touchedNodes]];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    //if there is no drag or hold occuring
    if (self.touchState == 0) {
        //invalidate any hold timer
        [self.touchTimer invalidate];
        //notify stage
        [self processTappedNode:[self findKeyNodeFromTouchedNodes:self.touchedNodes]];
    }
    //record that the touch is over
    self.touchState = 0;
}


-(NSArray *)getNodesAtTouch:(CGPoint)touchLocation{
        NSArray *touchedArray = [[NSArray alloc]initWithArray:[self nodesAtPoint:touchLocation]];
        return touchedArray;
}

-(CGPoint)makeDragVectorWith:(UITouch *)movedTouch {
    //make drag point
    CGPoint new = [movedTouch locationInNode:self];
    CGPoint old = self.lastTouch;
    CGPoint dragPoint = CGPointMake(new.x - old.x, new.y - old.y);

    
    float minX = self.frame.size.width - self.board.width * CELL_SIZE * self.world.xScale;
    float minY = self.frame.size.height - self.board.height * CELL_SIZE * self.world.yScale;
    
    //if new drag left will be too far, set x transform to zero
    if (self.world.position.x + dragPoint.x <= minX) {
        dragPoint.x = 0;
        self.world.position = CGPointMake(minX, self.world.position.y);
    }
    //if new drag right will be too far, set x transform to zero
    if (self.world.position.x + dragPoint.x >= 0) {
        dragPoint.x = 0;
        self.world.position = CGPointMake(0, self.world.position.y);
    }
    //if new drag up will be too far, set y transform to zero
    if (self.world.position.y + dragPoint.y >= 0) {
        dragPoint.y = 0;
        self.world.position = CGPointMake(self.world.position.x, 0);
    }
    //if new drag down will be too far, set y transform to zero
    if (self.world.position.y + dragPoint.y <= minY) {
        dragPoint.y = 0;
        self.world.position = CGPointMake(self.world.position.x, minY);
    }
    return dragPoint;
}

-(void)handleZoom {
    //NSLog(@"scaleFactor = %f", self.zoomRecognizer.scale);
    
    // if new scale will be too big, set current scale to max
    if ((self.world.xScale *= self.zoomRecognizer.scale) > self.maxScale || (self.world.yScale *= self.zoomRecognizer.scale) > self.maxScale){
        NSLog(@"too much zoom in");
        self.world.xScale = self.maxScale;
        self.world.yScale = self.maxScale;
        
    // if new scale will be too small, set current scale to min
    } else if ((self.world.xScale *= self.zoomRecognizer.scale) < self.minScale || (self.world.xScale *= self.zoomRecognizer.scale) < self.minScale) {
        NSLog(@"too much zoom out");
        self.world.xScale = self.minScale;
        self.world.yScale = self.minScale;
    } else {
    self.world.xScale *= self.zoomRecognizer.scale;
    self.world.yScale *= self.zoomRecognizer.scale;
    self.zoomRecognizer.scale = 1;
    }
    
    // if world is getting off the screen, nudge it back
    float minX = self.frame.size.width - self.board.width * CELL_SIZE * self.world.xScale;
    float minY = self.frame.size.height - self.board.height * CELL_SIZE * self.world.yScale;
    
    CGFloat posX = self.world.position.x;
    CGFloat posY = self.world.position.y;
    
    if (self.world.position.x <= minX) {
        posX = 0;
        self.world.position = CGPointMake(minX, self.world.position.y);
    }
    //if new drag right will be too far, set x transform to zero
    if (self.world.position.x >= 0) {
        posX = 0;
        self.world.position = CGPointMake(0, self.world.position.y);
    }
    //if new drag up will be too far, set y transform to zero
    if (self.world.position.y >= 0) {
        posY = 0;
        self.world.position = CGPointMake(self.world.position.x, 0);
    }
    //if new drag down will be too far, set y transform to zero
    if (self.world.position.y <= minY) {
        posY = 0;
        self.world.position = CGPointMake(self.world.position.x, minY);
    }
}

-(UIColor *)colorWithPlayerColor:(NSString *)playerColor {
    if ([playerColor isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([playerColor isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([playerColor isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    } else if ([playerColor isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else {
        return [UIColor whiteColor];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
