//
//  AttackScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "AttackScene.h"
#import "GameView.h"
#import "ActionScene.h"
#import "CommandScene.h"

#import "Combat.h"

@implementation AttackScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    self.combat = [[Combat alloc]initWithBoard:self.board];
    // draw scene specific UI elements
    [self redHighlightUnitsToAttack];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Highlight class]]) {
        Highlight *highlight = (Highlight *)node;
        if ([highlight.type isEqualToString:@"red"]) {
            Tile *tile = (Tile *)highlight.parent;
            Unit *target = [self.board unitAtX:tile.x andY:tile.y];
            [self toCommandSceneWithTarget:target];
        }
    } else {
        [self toActionScene];
    }
}

// Transition Methods

-(void)toActionScene {
    ActionScene *scene = [[ActionScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toCommandSceneWithTarget:(Unit *)target {
    // the units fight
    [self.combat fightFirstUnit:self.selectedUnit againstSecondUnit:target];
    // set unit to alseep state
    [self.selectedUnit changeStateTo:@"asleep"];
    // return to CommandScene
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

//-(void)toAbilitySceneWithHero:(Hero *)hero AndAbility:(Ability *)ability {}

// UI Element Methods

-(void)redHighlightUnitsToAttack {
    // highlight enemy units that can be attacked
    for (int y = 1; y <= self.board.height; y++) {
        for (int x = 1; x <= self.board.width; x++) {
            id targetUnitMaybe = [self.board unitAtX:x andY:y];
            if (targetUnitMaybe != (id)[NSNull null]) {
                Unit *targetUnit = (Unit *)targetUnitMaybe;
                if (targetUnit.owner != self.board.currentPlayer) {
                    NSInteger dx = self.selectedUnit.tile.x - targetUnit.tile.x;
                    NSInteger dy = self.selectedUnit.tile.y - targetUnit.tile.y;
                    NSInteger distance = abs(dx) + abs(dy);
                    // if within range
                    if ((distance >= [(NSNumber *)[self.selectedUnit.range objectAtIndex:0] integerValue]) &&
                        (distance <= [(NSNumber *)[self.selectedUnit.range objectAtIndex:1] integerValue])) {
                        Highlight *highlight = [[Highlight alloc]initWithType:@"red"];
                        [targetUnit.tile addChild:highlight];
                        [targetUnit.tile addChild:[self attackToolTipForTarget:targetUnit]];
                    }
                }
            }
        }
    }
}

-(SKLabelNode *)attackToolTipForTarget:(Unit *)target {
    SKLabelNode *toolTip = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    toolTip.fontSize = 20;
    toolTip.position = CGPointMake(51,51);
    toolTip.horizontalAlignmentMode = 2; //right aligned
    toolTip.verticalAlignmentMode = 2; //top aligned
    NSInteger attackDamage = [self.combat attackDamageFrom:self.selectedUnit toUnit:target];
    toolTip.text = [NSString stringWithFormat:@"%d", attackDamage];
    return toolTip;
}

@end
