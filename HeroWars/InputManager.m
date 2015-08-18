//
//  InputManager.m
//  HeroWars
//
//  Created by Max Shashoua on 2/5/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "InputManager.h"


@implementation InputManager


-(id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self){
        [self setValue:@"battle" forKey:@"stage"];
        self.board = board;
        self.pather = [[Pather alloc]init];
        self.combat = [[Combat alloc]initWithBoard:self.board];
    }
    return self;
}

-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString:(NSString *)touchType {
    if ([touchType isEqualToString: @"tap"]) {
        [self handleTappedNodes:touchedNodes];
    } else if ([touchType isEqualToString: @"hold"]) {
        [self handleHeldNodes:touchedNodes];
    }
}

-(void)handleHeldNodes:(NSArray *)heldNodes {
    SKNode *keyNode = [self findKeyNodeFromTouchedNodes:heldNodes];
    NSLog(@"%@ held", [keyNode class]);
}

-(void)handleTappedNodes:(NSArray *)tappedNodes {
    //select keyNode from node hierarchy
    SKNode *keyNode = [self findKeyNodeFromTouchedNodes:tappedNodes];
    // battle stage
    if ([self.stage isEqualToString:@"battle"]) {
        // unit tapped
        if ([keyNode isKindOfClass:[Unit class]]) {
            Unit *unit = (Unit *)keyNode;
            if (([unit.state isEqualToString:@"awake"]) && (unit.owner == self.board.currentPlayer)) {
                self.selectedUnit = (Unit *)keyNode;
                [self setValue:@"unitMove" forKey:@"stage"];
            } else {
                NSLog(@"no no no, NOT YOUR TURN!");
            }
        // other tapped
        } else {
            [self setValue:@"generalMenu" forKey:@"stage"];
        }
    }
    // generalMenu stage
    else if ([self.stage isEqualToString:@"generalMenu"]) {
        // button tapped
        if ([keyNode isKindOfClass:[Button class]] || [keyNode isKindOfClass:[GeneralMenu class]]) {
            Button *button = (Button *)keyNode;
            NSLog(@"%@ button pressed", button.name);
            // end
            if ([button.name isEqualToString:@"end"]) {
                [self setValue:@"turnEnded" forKey:@"stage"];
                [self setValue:@"battle" forKey:@"stage"];
            // unknown button
            } else {
                NSLog(@"Error: unknown button name passed to generalMenu stage");
            }
        // other tapped
        } else {
            [self setValue:@"battle" forKey:@"stage"];
        }
    }
    // unitMove stage
    else if ([self.stage isEqualToString:@"unitMove"]) {
        // unit tapped
        if ([keyNode isKindOfClass:[Unit class]]) {
            Unit *thisUnit = (Unit *)keyNode;
            // clicking selected unit again (i.e. no move)
            if((thisUnit.x == self.selectedUnit.x) && (thisUnit.y == self.selectedUnit.y)) {
                [self setValue:@"unitAction" forKey:@"stage"];
            }
        }
        // highlight tapped
        else if ([keyNode isKindOfClass:[Highlight class]]) {
            Tile *highlightedTile = (Tile *)[keyNode parent];
            [self.board moveUnit:self.selectedUnit toTile:highlightedTile];
            [self setValue:@"unitAction" forKey:@"stage"];
        // other tapped
        } else {
            [self setValue:@"battle" forKey:@"stage"];
        }
    }
    // unitAction stage
    else if ([self.stage isEqualToString:@"unitAction"]) {
        // button tapped
        if ([keyNode isKindOfClass:[Button class]]) {
            Button *button = (Button *)keyNode;
            NSLog(@"%@ button pressed", button.name);
            // wait
            if ([button.name isEqualToString:@"wait"]) {
                [self.selectedUnit changeStateTo:@"asleep"];
                [self setValue:@"battle" forKey:@"stage"];
                self.selectedUnit = (Unit *)[NSNull null];
            }
            // attack
            else if ([button.name isEqualToString:@"attack"]) {
                [self setValue:@"chooseAttack" forKey:@"stage"];
                //self.selectedUnit = (Unit *)[NSNull null];
            }
            // unknown button
            else {
                NSLog(@"Error: unknown button name passed to input manager");
            }
        // other tapped
        } else {
            self.selectedUnit = [self.board undoMoveUnit];
            [self setValue:@"unitMove" forKey:@"stage"];
        }
    }
    // chooseAttack stage
    else if ([self.stage isEqualToString:@"chooseAttack"]) {
        // highlighted unit tapped
        if ([keyNode isKindOfClass:[Unit class]]) {
            Tile *tile = (Tile *)[keyNode parent];
            for (SKNode *child in tile.children) {
                if ([child isKindOfClass:[Highlight class]]) {
                    Unit *targetUnit = [self.board unitAtX:tile.x andY:tile.y];
                    [self.combat fightFirstUnit:self.selectedUnit againstSecondUnit:targetUnit];
                    [self.selectedUnit changeStateTo:@"asleep"];
                    [self setValue:@"battle" forKey:@"stage"];
                    self.selectedUnit = (Unit *)[NSNull null];
                    goto INPUT_MANAGED;
                }
            }
        }
        // other tapped
        else {
            [self setValue:@"unitAction" forKey:@"stage"];
        }
    }
    // label if you need to break out of a loop
    INPUT_MANAGED:;
}

-(NSDictionary *)findTileCoordsToMoveHighlight {
    NSDictionary *tileCoords = [self.pather findPathsForUnit:self.selectedUnit andBoard:self.board];
    return tileCoords;
}

-(NSMutableArray *)findTileCoordsToAttackHighlight {
    // returns array of coordPair arrays to highlight
    NSMutableArray *tileCoords = [[NSMutableArray alloc]init];
    for (int r = 0; r < self.board.height; r++) {
        NSInteger thisY = r + 1;
        NSInteger dy = thisY - self.selectedUnit.y;
        for (int c = 0; c < self.board.width; c++) {
            NSInteger thisX = c + 1;
            NSInteger dx = thisX - self.selectedUnit.x;
            NSInteger distance = abs(dx) + abs(dy);
            // if within range
            if ((distance >= [(NSNumber *)[self.selectedUnit.range objectAtIndex:0] integerValue]) &&
                (distance <= [(NSNumber *)[self.selectedUnit.range objectAtIndex:1] integerValue])) {
                // if it has a unit on it
                id targetUnitMaybe = [self.board unitAtX:thisX andY:thisY];
                if (targetUnitMaybe != (id)[NSNull null]) {
                    Unit *targetUnit = (Unit *)targetUnitMaybe;
                    // if it is an enemy unit
                    if (targetUnit.owner != self.board.currentPlayer) {
                        NSArray *coordPair = [[NSArray alloc]initWithObjects:[NSNumber numberWithInteger:thisX], [NSNumber numberWithInteger:thisY], nil];
                        [tileCoords addObject:coordPair];
                    }
                }
            }
        }
    }
    return tileCoords;
}

-(SKNode *)findKeyNodeFromTouchedNodes:(NSArray *)touchedNodes {
    //select keyNode from node hierarchy
    NSArray *nodeHierarchy = @[[Button class],[Menu class],[Unit class],[Highlight class],/*[Building class],*/[Tile class]];
    SKNode *keyNode = [[SKNode alloc]init];
    for (Class classType in nodeHierarchy) {
        for (SKNode *node in touchedNodes) {
            if ([node isKindOfClass:classType]) {
                keyNode = node;
                return keyNode;
            }
        }
    }
    return nil;
}

-(BOOL)canDrag {
    return YES;
}

@end
