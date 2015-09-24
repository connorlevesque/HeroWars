//
//  RideScene.m
//  HeroWars
//
//  Created by Connor Levesque on 9/2/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "RideScene.h"
#import "GameView.h"
#import "MoveScene.h"
#import "CommandScene.h"

@implementation RideScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    // draw scene specific UI elements
    [self drawRiderImage];
    [self drawActionMenu];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Button class]]) {
        Button *button = (Button *)node;
        if ([button.name isEqualToString:@"wait"]) {
            [self toCommandScene];
        }
    } else {
        [self toMoveScene];
    }
}

// Transition Methods

-(void)toMoveScene {
    [self.board undoCarryUnit:self.selectedUnit];
    MoveScene *scene = [[MoveScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toCommandScene {
    // set unit to asleep state
    [self.selectedUnit changeStateTo:@"asleep"];
    // go to CommandScene
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

//-(void)toAbilitySceneWithHero:(Hero *)hero AndAbility:(Ability *)ability {}

// UI Element Methods

-(void)drawRiderImage {
    NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.selectedUnit.name, self.selectedUnit.teamColor];
    SKSpriteNode *riderImage = [[SKSpriteNode alloc]initWithImageNamed:imageName];
    riderImage.anchorPoint = CGPointMake(0,0);
    Tile *tile = self.selectedUnit.carrier.tile;
    [tile addChild:riderImage];
}

-(void)drawActionMenu {
    NSMutableArray *actions = [[NSMutableArray alloc]init];
    [actions addObject:@"wait"];
    ActionMenu *actionMenu = [[ActionMenu alloc]initWithActions:actions];
    actionMenu.position = CGPointMake(25,50);
    [self addChild:actionMenu];
}

@end
