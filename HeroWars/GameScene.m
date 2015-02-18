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
    self.board = [[Gameboard alloc]initWithMapNamed:@"Campaign1"];
    self.inputManager = [[InputManager alloc]initWithBoard:self.board];
    self.world = [[SKNode alloc]init];
    self.world.position = CGPointMake(0,0);
    [self addChild:self.world];
    [self drawGrids];
    self.touchState = 0;
    
    // initialize menus
    
    self.generalMenu = [[GeneralMenu alloc]init];
    self.generalMenu.position = CGPointMake(25, 50);
    self.highlightedTiles = [[NSMutableArray alloc]init];
    
    // make scene observer of inputManager

    [self.inputManager addObserver:self forKeyPath:@"stage" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // recognizes that a key path has been called and calls methods based upon the keypath
    NSString *oldC = [change objectForKey:NSKeyValueChangeOldKey];
    NSString *newC = [change objectForKey:NSKeyValueChangeNewKey];
    // if the stage is the keyValue that changed
    if ([keyPath isEqualToString:@"stage"]){
        [self stageHasChangedFrom:oldC to:newC];
    }
}

-(void)stageHasChangedFrom:(NSString *)oldStage to:(NSString *)newStage {
    //edit visuals based on the old stage and the new stage
    NSLog(@"Stage has changed from %@ to %@", oldStage, newStage);
    // if stage is changing from battle to generalMenu
    if ([oldStage isEqualToString:@"battle"] & [newStage isEqualToString:@"generalMenu"]) {
        [self addChild:self.generalMenu];
    }
    // if stage is changing from generalMenu to battle
    else if ([oldStage isEqualToString:@"generalMenu"] & [newStage isEqualToString:@"battle"]) {
        [self.generalMenu removeFromParent];
    }
    // if stage is changing from battle to unitMove
    else if ([oldStage isEqualToString:@"battle"] & [newStage isEqualToString:@"unitMove"]) {
        [self highlightTiles];
    }
    // if stage is changing from unitMove to battle
    else if ([oldStage isEqualToString:@"unitMove"] & [newStage isEqualToString:@"battle"]) {
        [self unHighlightTiles];
    }
    // if stage is changing from unitMove to unitAction
    else if ([oldStage isEqualToString:@"unitMove"] & [newStage isEqualToString:@"unitAction"]) {
        [self unHighlightTiles];
        [self updateUnitPositions];
        [self setUpActionMenu];
    }
    // if stage is changing from unitAction to unitMove
    else if ([oldStage isEqualToString:@"unitAction"] & [newStage isEqualToString:@"unitMove"]) {
        [self.actionMenu removeFromParent];
        [self updateUnitPositions];
        [self highlightTiles];
    }
    //if stage is changing from unitAction to battle
    else if ([oldStage isEqualToString:@"unitAction"] & [newStage isEqualToString:@"battle"]) {
        [self.actionMenu removeFromParent];
    }
    //if stage is changing from turnEnded to battle
    else if ([oldStage isEqualToString:@"turnEnded"] & [newStage isEqualToString:@"battle"]){
        [self.generalMenu removeFromParent];
        [self endTurn];
    }
}

-(void)setUpActionMenu {
    self.actionMenu = [[ActionMenu alloc]init];
    self.actionMenu.position = CGPointMake(25, 50);
    [self addChild:self.actionMenu];
}

-(void)updateUnitPositions {
    // updates unit positions
    for (int r = 0; r < self.board.height; r++) {
        for (int c = 0; c < self.board.width; c++) {
            Tile *tile = self.board.tileGrid[r][c];
            [tile removeAllChildren];
            id unitMaybe = self.board.unitGrid[r][c];
            if (!(unitMaybe == (id)[NSNull null])) {
                Unit *unit = self.board.unitGrid[r][c];
                [unit removeFromParent];
                [tile addChild:unit];
            }
        }
    }
}

-(void)highlightTiles {
    NSDictionary *paths = [self.inputManager findTileCoordsToHighlight];
    for (NSString *coordString in paths.allKeys) {
        Highlight *highlight = [[Highlight alloc]initWithImageNamed:@"HeroWars_transparentBlue.png"];
        NSArray *coordArray = [coordString componentsSeparatedByString:@","];
        NSInteger x = [coordArray[0] integerValue];
        NSInteger y = [coordArray[1] integerValue];
        Tile *tile = [self.board tileAtX:x andY:y];
        [self.highlightedTiles addObject:tile];
        [tile addChild:highlight];
    }
}

-(void)unHighlightTiles {
    for (Tile *tile in self.highlightedTiles) {
        for (SKSpriteNode *child in tile.children) {
            if ([child isKindOfClass:[Highlight class]]) {
                [child removeFromParent];
            }
        }
    }
    [self.highlightedTiles removeAllObjects];
}

-(void)drawGrids {
    // draws the grids of tiles and units
    for (int r = 0; r < self.board.height; r++) {
        for (int c = 0; c < self.board.width; c++) {
            Tile *tile = self.board.tileGrid[r][c];
            tile.position = CGPointMake(c * CELL_SIZE, r * CELL_SIZE);
            [self.world addChild:tile];
            id unitMaybe = self.board.unitGrid[r][c];
            if (!(unitMaybe == (id)[NSNull null])) {
                Unit *unit = self.board.unitGrid[r][c];
                [tile addChild:unit];
            }
        }
    }
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
    if ((self.touchState < 2) & [self.inputManager canDrag]){
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
        [self.inputManager receiveInputWithNodes:self.touchedNodes andString:@"hold"];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    //if there is no drag or hold occuring
    if (self.touchState == 0) {
        //invalidate any hold timer
        [self.touchTimer invalidate];
        //notify inputManager
        [self.inputManager receiveInputWithNodes:self.touchedNodes andString:@"tap"];
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

    float minX = self.frame.size.width - self.board.width * CELL_SIZE;
    float minY = self.frame.size.height - self.board.height * CELL_SIZE;
    
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
    return dragPoint;
}

-(void)endTurn {
    // when turn is over, 1) set all the units to awake. 2) change whose turn it is.
    NSLog(@"%d", self.board.currentPlayer);
    self.board.currentPlayer = (self.board.currentPlayer) % self.board.players +1;
    NSLog(@"Turn Over; it is now player %d's turn", self.board.currentPlayer);
    for (NSMutableArray *row in self.board.unitGrid) {
        for (id unitMaybe in row){
            if ([unitMaybe isKindOfClass:[Unit class]]){
                Unit *unit = (Unit *)unitMaybe;
                [unit changeStateTo:@"awake"];
                
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
