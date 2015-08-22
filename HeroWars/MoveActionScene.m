//
//  MoveActionScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/19/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "MoveActionScene.h"
#import "GameView.h"
#import "CommandScene.h"
#import "Pather.h"

@implementation MoveActionScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    self.pather = [[Pather alloc]init];
    // draw scene specific UI elements
    [self drawDropButtons];
    [self blueHighlightForMove];
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
            if ([highlight.parent isKindOfClass:[Tile class]]) {
                Tile *tile = (Tile *)highlight.parent;
                [self toActionSceneWithTile:tile];
            } else if ([highlight.parent isKindOfClass:[Unit class]]) {
                Unit *unit = (Unit *)highlight.parent;
                if ([unit isEqual:self.selectedUnit]) {
                    [self toWaitCaptureScene];
                } else if ((unit.isCarrier) && ([unit.type isEqualToString:self.selectedUnit.type] ||
                                                [unit.type isEqualToString:self.selectedUnit.zone])) {
                    [self toRideSceneWithUnit:unit];
                }
            }
        } else if ([highlight.type isEqualToString:@"red"]) {
            [self toAttackSceneWithUnit:(Unit *)highlight.parent];
        }
    } else if ([node isKindOfClass:[Button class]]) {
        Button *button = (Button *)node;
        if ([button isKindOfClass:[DropButton class]]) {
            DropButton *dropButton = (DropButton *)button;
            [self toDropSceneWithUnit:dropButton.unit];
        }
    } else {
        [self toCommandScene];
    }
}

// Transition Methods

-(void)toCommandScene {
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toActionSceneWithTile:(Tile *)tile {
    //    self.selectedUnit = unit;
    //    MoveActionScene *moveActionScene = [[MoveActionScene alloc]initWithSize:self.size];
    //    [self.view presentScene:moveActionScene];
}

-(void)toAttackSceneWithUnit:(Unit *)unit {
    //    self.selectedUnit = unit;
    //
}

-(void)toWaitCaptureScene {

}

-(void)toRideSceneWithUnit:(Unit *)unit {

}

-(void)toDropSceneWithUnit:(Unit *)unit {

}

//-(void)toAbilitySceneWithHero:(Hero *)hero AndAbility:(Ability *)ability {}

// Edit Model Methods

// UI Element Methods

-(void)drawDropButtons {
    
}

-(void)blueHighlightForMove {
    NSDictionary *paths = [self.pather findPathsForUnit:self.selectedUnit andBoard:self.board];
    for (NSString *coordString in paths.allKeys) {
        Highlight *highlight = [[Highlight alloc]initWithType:@"blue"];
        NSArray *coordArray = [coordString componentsSeparatedByString:@","];
        NSInteger x = [coordArray[0] integerValue];
        NSInteger y = [coordArray[1] integerValue];
        Tile *tile = [self.board tileAtX:x andY:y];
        [tile addChild:highlight];
    }
}

-(void)redHighlightForAttack {
    
}

@end
