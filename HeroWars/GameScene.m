//
//  GameScene.m
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//




// do the thing you did in the zooming that makes the stopping points smooth with the drag ie: if the resulting position will be too big, set the current position to max. that way it doesnt lag and accidentally drag too far.


#import "GameScene.h"

@implementation GameScene

NSInteger CELL_SIZE = 51;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setAnchorPoint:CGPointMake(0, 0)];
    self.board = [[Gameboard alloc]initWithMapNamed:@"MaxLevel1"];
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
    
    
    // zoom gesture stuff
    self.zoomRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleZoom)];
    [self.view addGestureRecognizer:self.zoomRecognizer];
    
    CGFloat worldHeight = self.board.height * CELL_SIZE;
    CGFloat worldWidth = self.board.width * CELL_SIZE;
    
    
    self.minScale = MAX(self.frame.size.height / worldHeight, self.frame.size.width / worldWidth);
    self.maxScale = 1;
    
    
    
    NSLog(@"self.frame.size.height = %f", self.frame.size.height);
    NSLog(@"self.frame.size.width = %f", self.frame.size.width);
    NSLog(@"world.size.height = %f", self.world.frame.size.height);
    NSLog(@"world.size.width = %f", self.world.frame.size.width);
    NSLog(@"maxScale = %f", self.maxScale);
    NSLog(@"minScale = %f", self.minScale);
    NSLog(@"scale = %f", self.world.yScale);
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
    if ([oldStage isEqualToString:@"battle"] && [newStage isEqualToString:@"generalMenu"]) {
        [self addChild:self.generalMenu];
    }
    // if stage is changing from generalMenu to battle
    else if ([oldStage isEqualToString:@"generalMenu"] && [newStage isEqualToString:@"battle"]) {
        [self.generalMenu removeFromParent];
    }
    //if stage is changing from turnEnded to battle
    else if ([oldStage isEqualToString:@"turnEnded"] & [newStage isEqualToString:@"battle"]){
        [self.generalMenu removeFromParent];
        [self endTurn];
    }
    // if stage is changing from battle to unitMove
    else if ([oldStage isEqualToString:@"battle"] && [newStage isEqualToString:@"unitMove"]) {
        [self highlightMoveTiles];
    }
    // if stage is changing from unitMove to battle
    else if ([oldStage isEqualToString:@"unitMove"] && [newStage isEqualToString:@"battle"]) {
        [self unHighlightTiles];
    }
    // if stage is changing from unitMove to unitAction
    else if ([oldStage isEqualToString:@"unitMove"] && [newStage isEqualToString:@"unitAction"]) {
        [self unHighlightTiles];
        [self updateUnits];
        [self setUpActionMenu];
    }
    // if stage is changing from unitAction to unitMove
    else if ([oldStage isEqualToString:@"unitAction"] && [newStage isEqualToString:@"unitMove"]) {
        [self.actionMenu removeFromParent];
        [self updateUnits];
        [self highlightMoveTiles];
    }
    // if stage is changing from unitAction to Battle
    else if ([oldStage isEqualToString:@"unitAction"] && [newStage isEqualToString:@"battle"]) {
        [self.actionMenu removeFromParent];
    }
    //if stage is changing from unitAction to chooseAttack
    else if ([oldStage isEqualToString:@"unitAction"] && [newStage isEqualToString:@"chooseAttack"]) {
        [self.actionMenu removeFromParent];
        [self highlightAttackTiles];
    }
    //if stage is changing from chooseAttack to unitAction
    else if ([oldStage isEqualToString:@"chooseAttack"] && [newStage isEqualToString:@"unitAction"]) {
        [self unHighlightTiles];
        [self setUpActionMenu];
    }
    //if stage is changing from chooseAttack to battle
    else if ([oldStage isEqualToString:@"chooseAttack"] && [newStage isEqualToString:@"battle"]) {
        [self unHighlightTiles];
        [self updateUnits];
    }
}

-(void)setUpActionMenu {
    self.actionMenu = [[ActionMenu alloc]init];
    self.actionMenu.position = CGPointMake(25, 50);
    [self addChild:self.actionMenu];
}

-(void)updateUnits {
    // updates unit positions
    for (int r = 0; r < self.board.height; r++) {
        NSInteger thisY = r + 1;
        for (int c = 0; c < self.board.width; c++) {
            NSInteger thisX = c + 1;
            Tile *tile = [self.board tileAtX:thisX andY:thisY];
            [tile removeAllChildren];
            id unitMaybe = [self.board unitAtX:thisX andY:thisY];
            if (!(unitMaybe == (id)[NSNull null])) {
                Unit *unit = self.board.unitGrid[r][c];
                [unit removeFromParent];
                if (unit.health > 0) {
                    [tile addChild:unit];
                    NSInteger healthInteger = ceil(unit.health / 10);
                    if ((healthInteger <= 9) && (healthInteger > 0)) {
                        NSString *imageName = [NSString stringWithFormat:@"HeroWars_health_%d.png", healthInteger];
                        SKSpriteNode *healthIndicator = [[SKSpriteNode alloc]initWithImageNamed:imageName];
                        healthIndicator.anchorPoint = CGPointZero;
                        [tile addChild:healthIndicator];
                    }
                } else {
                    [self.board removeUnitFromTile:tile];
                }
            }
        }
    }
}

-(void)highlightMoveTiles {
    NSDictionary *paths = [self.inputManager findTileCoordsToMoveHighlight];
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

-(void)highlightAttackTiles {
    NSArray *tileCoords = [self.inputManager findTileCoordsToAttackHighlight];
    for (NSArray *coordPair in tileCoords) {
        Highlight *highlight = [[Highlight alloc]initWithImageNamed:@"HeroWars_transparentBlue.png"];
        NSInteger x = [coordPair[0] integerValue];
        NSInteger y = [coordPair[1] integerValue];
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
    if ((self.touchState < 2) && [self.inputManager canDrag]){
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

-(void)endTurn {
    // when turn is over, 1) set all the units to awake. 2) change whose turn it is.
    self.board.currentPlayer = (self.board.currentPlayer) % self.board.players + 1;
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
