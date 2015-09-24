//
//  DropScene.m
//  HeroWars
//
//  Created by Connor Levesque on 9/10/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "DropScene.h"
#import "GameView.h"
#import "ActionScene.h"
#import "CommandScene.h"

@implementation DropScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    // draw scene specific UI elements
    [self highlightDropTiles];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Highlight class]]) {
        Highlight *highlight = (Highlight *)node;
        if ([highlight.type isEqualToString:@"blue"]) {
            [self toCommandSceneWithTile:(Tile *)highlight.parent];
        }
    } else {
        [self toActionScene];
    }
}

// Transition Methods

-(void)toCommandSceneWithTile:(Tile *)tile {
    [self.board dropUnit:self.selectedUnit.cargo onTile:tile];
    [self.selectedUnit changeStateTo:@"asleep"];
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toActionScene {
    ActionScene *scene = [[ActionScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

// Edit Model Methods

// UI Element Methods

-(void)highlightDropTiles {
    // highlights tiles that can be moved to and through in blue and units that can be attacked in red
    Tile *origin = self.selectedUnit.tile;
    Tile *tileUp = [self.board tileAtX:origin.x andY:origin.y + 1];
    Tile *tileDown = [self.board tileAtX:origin.x andY:origin.y - 1];
    Tile *tileLeft = [self.board tileAtX:origin.x + 1 andY:origin.y];
    Tile *tileRight = [self.board tileAtX:origin.x - 1 andY:origin.y];
    for (Tile *tile in @[tileUp,tileDown,tileLeft,tileRight]) {
        if ([self canDropOnTile:tile]) {
            Highlight *highlight = [[Highlight alloc]initWithType:@"blue"];
            [tile addChild:highlight];
        }
    }
}

-(BOOL)canDropOnTile:(Tile *)targetTile {
    //returns true if the unit can be dropped on target Tile
    // if there is enough movepoints
    Unit *carriedUnit = self.selectedUnit.cargo;
    if (carriedUnit.move >= [(NSNumber *)targetTile.movecosts[carriedUnit.type] integerValue]) {
        // if there is a unit on the tile
        if (![self.board isUnitAtX:targetTile.x andY:targetTile.y]) {
            return YES;
        }
    }
    return NO;
}


@end
