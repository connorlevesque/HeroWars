//
//  ActionScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/23/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "ActionScene.h"
#import "GameView.h"
#import "MoveScene.h"
#import "CommandScene.h"
#import "AttackScene.h"
#import "DropScene.h"

@implementation ActionScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    self.didUnitMove = view.previousScene.unitMoved;
    // set up Scene specific properties make changes to Model if any
    // draw scene specific UI elements
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
        if ([button.name isEqualToString:@"ride"]) {
            [self toCommandSceneWithContext:button.name];
        } else if ([button.name isEqualToString:@"attack"]) {
            [self toAttackScene];
        } else if ([button.name isEqualToString:@"drop"]) {
            [self toDropScene];
        } else if ([button.name isEqualToString:@"capture"]) {
            [self toCommandSceneWithContext:button.name];
        } else if ([button.name isEqualToString:@"wait"]) {
            [self toCommandSceneWithContext:button.name];
        }
    } else {
        [self toMoveScene];
    }
}

// Transition Methods

-(void)toMoveScene {
    [self.board undoMoveUnit:self.selectedUnit];
    MoveScene *scene = [[MoveScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toAttackScene {
    AttackScene *scene = [[AttackScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toDropScene {
    DropScene *scene = [[DropScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toCommandSceneWithContext:(NSString *)context {
    if ([context isEqualToString:@"capture"]) {
        Tile *building = self.selectedUnit.tile;
        building.control -= (self.selectedUnit.health - 1) / 10 + 1;
        if (building.control <= 0) {
            [building captureWithOwner:self.selectedUnit.owner];
        }
    }
    // set unit to asleep state
    [self.selectedUnit changeStateTo:@"asleep"];
    // go to CommandScene
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

//-(void)toAbilitySceneWithHero:(Hero *)hero AndAbility:(Ability *)ability {}

// UI Element Methods

-(void)drawActionMenu {
    NSMutableArray *actions = [[NSMutableArray alloc]init];
    if ([self canAttack]) {
        [actions addObject:@"attack"];
    }
    if ([self canDrop]) {
        [actions addObject:@"drop"];
    }
    if ([self canCapture]) {
        [actions addObject:@"capture"];
    }
    [actions addObject:@"wait"];
    ActionMenu *actionMenu = [[ActionMenu alloc]initWithActions:actions];
    actionMenu.position = CGPointMake(25,50);
    [self addChild:actionMenu];
}

// canPerformAction methods

-(BOOL)canAttack {
    if (!([self.selectedUnit.type isEqualToString:@"artillery"] && (self.unitMoved == YES))) {
        for (int y = 1; y <= self.board.height; y++) {
            for (int x = 1; x <= self.board.width; x++) {
                if ([self.board isUnitAtX:x andY:y]) {
                    Unit *targetUnit = [self.board unitAtX:x andY:y];
                    if (targetUnit.owner != self.board.currentPlayer) {
                        NSInteger dx = self.selectedUnit.tile.x - targetUnit.tile.x;
                        NSInteger dy = self.selectedUnit.tile.y - targetUnit.tile.y;
                        NSInteger distance = abs(dx) + abs(dy);
                        // if within range
                        if ((distance >= [(NSNumber *)[self.selectedUnit.range objectAtIndex:0] integerValue]) &&
                            (distance <= [(NSNumber *)[self.selectedUnit.range objectAtIndex:1] integerValue])) {
                            return YES;
                        }
                
                    }
                }
            }
        }
    }
    return NO;
}

-(BOOL)canDrop {
    if ([self.selectedUnit isCarrying]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)canCapture {
    Tile *tile = self.selectedUnit.tile;
    if ([tile.type isEqualToString:@"building"] ||
        [tile.type isEqualToString:@"production"]) {
        if ((tile.owner != self.selectedUnit.owner) && ([self.selectedUnit.type isEqualToString:@"infantry"])) {
            return YES;
        }
    }
    return NO;
}


@end
