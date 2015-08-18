//
//  StartStage.m
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "StartStage.h"

@implementation StartStage

-(id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
        self.board.turn++;
        self.board.currentPlayer = (self.board.currentPlayer % self.board.players) + 1;
        [self.board adjustFundsForPlayer:self.board.currentPlayer byAmount:[self.board getIncomeForPlayer:self.board.currentPlayer]];
    }
    return self;
}

-(void)autoToCommandStage {
    [self setValue:@"CommandStage" forKey:@"stage"];
}

@end
