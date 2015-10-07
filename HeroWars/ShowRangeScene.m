//
//  ShowRangeScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/19/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "ShowRangeScene.h"
#import "GameView.h"
#import "CommandScene.h"

#import "Pather.h"

@implementation ShowRangeScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    // set up Scene specific properties make changes to Model if any
    self.pather = [[Pather alloc]init];
    // draw scene specific UI elements
    [self highlightAttackTiles];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    [self toCommandScene];
}

// Transition Methods

-(void)toCommandScene {
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

// Edit Model Methods

// UI Element Methods

-(void)highlightAttackTiles {
    // highlights units that can be attacked in red
    NSMutableArray *tilesToAttackFrom = [[NSMutableArray alloc]init];
    // find where the unit can move if unit is not artillery
    if (![self.selectedUnit.type isEqualToString:@"artillery"]) {
        NSDictionary *paths = [self.pather findPathsForUnit:self.selectedUnit andBoard:self.board];
        for (NSString *coordString in paths.allKeys) {
            NSArray *coordArray = [coordString componentsSeparatedByString:@","];
            NSInteger x = [coordArray[0] integerValue];
            NSInteger y = [coordArray[1] integerValue];
            Tile *tile = [self.board tileAtX:x andY:y];
            [tilesToAttackFrom addObject:tile];
        }
    } else {
    // if unit is artillery just add the current tile
        [tilesToAttackFrom addObject:self.selectedUnit.tile];
    }
    //
    for (int y = 1; y <= self.board.height; y++) {
        for (int x = 1; x <= self.board.width; x++) {
            Tile *targetTile = [self.board tileAtX:x andY:y];
            if ([self.board isUnitAtX:x andY:y]) {
                Unit *unit = [self.board unitAtX:x andY:y];
                if (self.selectedUnit.owner != unit.owner) {
                    for (NSString *target in self.selectedUnit.targets) {
                        if ([target isEqualToString:unit.zone]) {
                            for (Tile *positionTile in tilesToAttackFrom) {
                                if ([self canUnit:self.selectedUnit attackTile:targetTile fromTile:positionTile]) {
                                    [self redHighlightTile:targetTile];
                                }
                            }
                        }
                    }
                }
            } else {
                for (Tile *positionTile in tilesToAttackFrom) {
                    if ([self canUnit:self.selectedUnit attackTile:targetTile fromTile:positionTile]) {
                        [self redHighlightTile:targetTile];
                    }
                }
            }
        }
    }
}

-(void)redHighlightTile:(Tile *)tile {
    if (![self isHighlightOnTile:tile]) {
        Highlight *highlight = [[Highlight alloc]initWithType:@"red"];
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

-(BOOL)canUnit:(Unit *)unit attackTile:(Tile *)a fromTile:(Tile *)b {
    NSInteger dx = a.x - b.x;
    NSInteger dy = a.y - b.y;
    NSInteger distance = abs(dx) + abs(dy);
    if ((distance >= [(NSNumber *)[unit.range objectAtIndex:0] integerValue]) &&
        (distance <= [(NSNumber *)[unit.range objectAtIndex:1] integerValue])) {
        return YES;
    } else {
        return NO;
    }
}

@end
