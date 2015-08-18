//
//  CommandStage.m
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "CommandStage.h"

@implementation CommandStage

-(id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
    }
    return self;
}

-(void)processInputOfType:(NSString *)type onNodes:(NSArray *)touchedNodes {
    SKNode *keyNode = [self findKeyNodeFromTouchedNodes:touchedNodes];
    if ([type isEqualToString:@"tap"]) {
        [self processTappedKeyNode:keyNode];
    } else if ([type isEqualToString:@"hold"]) {
        [self processHeldKeyNode:keyNode];
    }
}

-(void)processTappedKeyNode:(SKNode *)keyNode {
    if ([keyNode isKindOfClass:[Unit class]]) {
        Unit *unit = (Unit *)keyNode;
        if (([unit.state isEqualToString:@"awake"]) && (unit.owner == self.board.currentPlayer)) {
            self.selectedUnit = unit;
            [self toMoveActionStage];
        } else {
            self.selectedUnit = unit;
            [self toShowRangeStage];
        }
    } else if ([keyNode isKindOfClass:[Tile class]]) {
        Tile *tile = (Tile *)keyNode;
        if ([tile.type isEqualToString:@"production"]) {
            self.selectedProduction = tile;
            [self toProductionStage];
        } else {
            [self toGameMenuStage];
        }
    } else {
        [self toGameMenuStage];
    }
}

-(void)toMoveActionStage {
    [self setValue:@"MoveActionStage" forKey:@"stage"];
}

-(void)toShowRangeStage {
    //[self setValue:@"ShowRangeStage" forKey:@"stage"];
}

-(void)toProductionStage {
    //[self setValue:@"ProductionStage" forKey:@"stage"];
}

-(void)toGameMenuStage {
    [self setValue:@"GameMenuStage" forKey:@"stage"];
}

@end
