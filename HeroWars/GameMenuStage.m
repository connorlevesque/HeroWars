//
//  GameMenuStage.m
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GameMenuStage.h"

@implementation GameMenuStage

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
    if ([keyNode isKindOfClass:[Button class]]) {
        Button *button = (Button *)keyNode;
        if ([button.name isEqualToString:@"end"]) {
            [self toEndStage];
        }
    } else {
        [self toCommandStage];
    }
}

-(void)toEndStage {
    [self setValue:@"EndStage" forKey:@"stage"];
}

-(void)toCommandStage {
    [self setValue:@"CommandStage" forKey:@"stage"];
}

@end
