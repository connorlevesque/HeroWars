//
//  MoveScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/30/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "MoveScene.h"
#import "GameView.h"
#import "CommandScene.h"
#import "ActionScene.h"
#import "RideScene.h"

#import "Pather.h"

@implementation MoveScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    self.pather = [[Pather alloc]init];
    // draw scene specific UI elements
    [self highlightMoveTiles];
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
            Tile *tile = (Tile *)highlight.parent;
            if ([self.board isUnitAtX:tile.x andY:tile.y]) {
                Unit *target = [self.board unitAtX:tile.x andY:tile.y];
                if (self.selectedUnit == target) {
                    [self toActionSceneWithTile:tile andDidMove:NO];
                } else {
                    if ([target canCarry] && [self.selectedUnit canBeCarried]) {
                        [self toRideSceneWithUnit:target];
                    }
                }
            } else {
                [self toActionSceneWithTile:tile andDidMove:YES];
            }
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

-(void)toRideSceneWithUnit:(Unit *)carrier {
    [self.board carryUnit:self.selectedUnit withUnit:carrier];
    RideScene *scene = [[RideScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

-(void)toActionSceneWithTile:(Tile *)tile andDidMove:(BOOL)didMove {
    [self.board moveUnit:self.selectedUnit toTile:tile];
    self.didUnitMove = didMove;
    ActionScene *scene = [[ActionScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

//-(void)toAbilitySceneWithHero:(Hero *)hero AndAbility:(Ability *)ability {}

// Edit Model Methods

// UI Element Methods

-(void)highlightMoveTiles {
    // highlights tiles that can be moved to and through in blue and units that can be attacked in red
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

-(BOOL)isHighlightOnTile:(Tile *)tile {
    for (id child in [tile children]) {
        if ([child isKindOfClass:[Highlight class]]) {
            return YES;
        }
    }
    return NO;
}

@end

