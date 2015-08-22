//
//  GameMenuScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/19/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GameMenuScene.h"
#import "GameView.h"
#import "CommandScene.h"

@implementation GameMenuScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    // make changes to Model if any
    // draw scene specific UI elements
    [self drawGameMenu];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Button class]]) {
        Button *button = (Button *)node;
        if ([button.name isEqualToString:@"end"]) {
            [self toCommandSceneWithContext:@"endTurn"];
        }
    } else if ([node isKindOfClass:[Menu class]]) {
        // do nothing
    } else {
        [self toCommandSceneWithContext:@"goBack"];
    }
}

// Transition Methods

-(void)toCommandSceneWithContext:(NSString *)context {
    if ([context isEqualToString:@"endTurn"]) {
        [self endTurn];
    } else if ([context isEqualToString:@"goBack"]) {}
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

// Edit Model Methods

-(void)endTurn {
    // awakens units and adjusts end turn board properties
    for (NSMutableArray *row in self.board.unitGrid) {
        for (id unitMaybe in row){
            if ([unitMaybe isKindOfClass:[Unit class]]){
                Unit *unit = (Unit *)unitMaybe;
                [unit changeStateTo:@"awake"];
            }
        }
    }
    self.board.currentPlayer = (self.board.currentPlayer) % self.board.players + 1;
    if (self.board.currentPlayer == 1) {
        self.board.turn++;
    }
    [self.board adjustFundsForPlayer:self.board.currentPlayer byAmount:[self.board getIncomeForPlayer:self.board.currentPlayer]];
    NSLog(@"Player %d Turn %d Funds %d", self.board.currentPlayer, self.board.turn, [self.board getFundsForPlayer:self.board.currentPlayer]);
}

// UI Element Methods

-(void)drawGameMenu {
    self.gameMenu = [[GeneralMenu alloc]init];
    self.gameMenu.position = CGPointMake(25,50);
    [self addChild:self.gameMenu];
}

@end
