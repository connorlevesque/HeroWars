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
    }
    return self;
}

-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString: (NSString *)touchType {
    //select keyNode from node hierarchy
    SKNode *keyNode = [self findKeyNodeFromTouchedNodes:touchedNodes];
    // if battle stage
    if ([self.stage isEqualToString:@"battle"]) {
        // if hold
        if ([touchType isEqualToString: @"hold"]) {
            NSLog(@"Tile held");
        // if tap
        }else if ([touchType isEqualToString: @"tap"]) {
            // if unit
            if ([keyNode isKindOfClass:[Unit class]]) {
                Unit *unit = (Unit *)keyNode;
                if ([unit.state isEqualToString:@"awake"]) {
                    self.selectedUnit = (Unit *)keyNode;
                    //NSLog(@"Unit tapped at %d,%d", self.selectedUnit.x, self.selectedUnit.y);
                    if (unit.owner == self.board.currentPlayer) {
                    [self setValue:@"unitMove" forKey:@"stage"];
                    } else {
                        NSLog(@"no no no, NOT YOUR TURN!");
                    }
                }
            }
            //if tile
            else if ([keyNode isKindOfClass:[Tile class]]) {
                [self setValue:@"generalMenu" forKey:@"stage"];
            } else {
                NSLog(@"Error: no task for keyNode");
            }
        }
    }
    // if generalMenu stage
    else if ([self.stage isEqualToString:@"generalMenu"]) {
        if ([keyNode isKindOfClass:[Button class]] || [keyNode isKindOfClass:[GeneralMenu class]]){
            Button *button = (Button *)keyNode;
            NSLog(@"%@ button pressed", button.name);
            if ([button.name isEqualToString:@"end"]) {
                [self setValue:@"turnEnded" forKey:@"stage"];
                [self setValue:@"battle" forKey:@"stage"];
            }
        } else {
            [self setValue:@"battle" forKey:@"stage"];
        }
    }
    // if unitMove stage
    else if ([self.stage isEqualToString:@"unitMove"]) {
        // if unit
        if ([keyNode isKindOfClass:[Unit class]]) {
            Unit *thisUnit = (Unit *)keyNode;
            //if clicking selected unit again (i.e. no move)
            if((thisUnit.x == self.selectedUnit.x) & (thisUnit.y == self.selectedUnit.y)) {
                [self setValue:@"unitAction" forKey:@"stage"];
                [self setValue:@"battle" forKey:@"stage"];
            }
        }
        // if highlight
        else if ([keyNode isKindOfClass:[Highlight class]]) {
            Tile *highlightedTile = (Tile *)[keyNode parent];
            [self.board moveUnit:self.selectedUnit toTile:highlightedTile];
            [self setValue:@"unitAction" forKey:@"stage"];
            NSLog(@"unit moved to point (%d,%d)", self.selectedUnit.x, self.selectedUnit.y);
        // otherwise
        } else {
            [self setValue:@"battle" forKey:@"stage"];
        }
    }
    // if unitAction stage
    else if ([self.stage isEqualToString:@"unitAction"]) {
        // if button
        if ([keyNode isKindOfClass:[Button class]]) {
            Button *button = (Button *)keyNode;
            NSLog(@"%@ button pressed", button.name);
            // if wait
            if ([button.name isEqualToString:@"wait"]) {
                [self.selectedUnit changeStateTo:@"asleep"];
                [self setValue:@"battle" forKey:@"stage"];
            } else {
                NSLog(@"Error: unknown button name passed to input manager");
            }
        // otherwise
        } else {
            self.selectedUnit = [self.board undoMoveUnit];
            NSLog(@"unit moved back to point (%d,%d)", self.selectedUnit.x, self.selectedUnit.y);
            [self setValue:@"unitMove" forKey:@"stage"];
        }
    }
}

-(NSDictionary *)findTileCoordsToHighlight {
    NSDictionary *tileCoords = [self.pather findPathsForUnit:self.selectedUnit andBoard:self.board];
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
