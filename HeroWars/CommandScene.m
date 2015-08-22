//
//  CommandScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/19/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "CommandScene.h"
#import "GameView.h"
#import "GameMenuScene.h"
#import "MoveActionScene.h"

@implementation CommandScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    // make changes to Model if any
    // draw scene specific UI elements
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Unit class]]) {
        Unit *unit = (Unit *)node;
        if (([unit.state isEqualToString:@"awake"]) && (unit.owner == self.board.currentPlayer)) {
            [self toMoveActionSceneWithUnit:unit];
        } else {
            [self toShowRangeSceneWithUnit:unit];
        }
    } else if ([node isKindOfClass:[Tile class]]) {
        Tile *tile = (Tile *)node;
        if ([tile.type isEqualToString:@"production"]) {
            [self toProductionSceneWithProduction:tile];
        } else {
            [self toGameMenuScene];
        }
    } else {
        [self toGameMenuScene];
    }
}

// Transition Methods

-(void)toGameMenuScene {
    GameMenuScene *scene = [[GameMenuScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toMoveActionSceneWithUnit:(Unit *)unit {
    self.selectedUnit = unit;
    MoveActionScene *moveActionScene = [[MoveActionScene alloc]initWithSize:self.size];
    [self.view presentScene:moveActionScene];
}

-(void)toShowRangeSceneWithUnit:(Unit *)unit {
//    self.selectedUnit = unit;
//    
}

-(void)toProductionSceneWithProduction:(Tile *)production {
//    self.selectedProduction = production;
//    
}

// Edit Model Methods

// UI Element Methods

@end
