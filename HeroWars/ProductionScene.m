//
//  ProductionScene.m
//  HeroWars
//
//  Created by Connor Levesque on 8/19/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "ProductionScene.h"
#import "GameView.h"
#import "CommandScene.h"

@implementation ProductionScene

-(void)didMoveToView:(GameView *)view {
    // set up scene
    [super didMoveToView:view];
    // extract previousScene data
    self.selectedUnit = view.previousScene.selectedUnit;
    self.selectedProduction = view.previousScene.selectedProduction;
    // set up Scene specific properties make changes to Model if any
    // draw scene specific UI elements
    [self drawUnitMenu];
    [self drawFundsLabel];
    // update previous scene
    view.previousScene = self;
    // log scene name
    NSLog(@"%@", self.class);
}

// Input Processing Methods

-(void)processTappedNode:(SKNode *)node {
    if ([node isKindOfClass:[Button class]]) { // if it's a button
        Button *button = (Button *)node;
        if ([button.name isEqualToString:@"cancel"]) { // if it's the cancel button
            [self toCommandSceneWithContext:@"cancel"];
        } else if ([button.type isEqualToString:@"unit"]) { // if it's a unit button
            if ([self.board getFundsForPlayer:self.board.currentPlayer] >=
                [self.unitMenu costFromUnitName:button.name]) // if you have enough funds
            {
                [self toCommandSceneWithContext:button.name];
            }
        }
    }
}

// Transition Methods

-(void)toCommandSceneWithContext:(NSString *)context {
    if (![context isEqualToString:@"cancel"]) {
        [self.board adjustFundsForPlayer:self.board.currentPlayer
                                byAmount:-[self.unitMenu costFromUnitName:context]];
        Unit *unit = [[Unit alloc]initUnitNamed:context
                                         onTile:self.selectedProduction
                                     withColors:self.board.playerColors
                                      withOwner:self.board.currentPlayer];
        [unit changeStateTo:@"asleep"];
        [self.board setUnit:unit OnTile:self.selectedProduction];
    }
    CommandScene *scene = [[CommandScene alloc]initWithSize:self.size];
    [self.view presentScene:scene];
}

// Edit Model Methods

// UI Element Methods

-(void)drawUnitMenu {
    self.unitMenu = [[UnitMenu alloc]initWithType:@"barracks"
                                         andColor:[self.board currentPlayerColor]
                                         andFunds:[self.board getFundsForPlayer:self.board.currentPlayer]];
    [self addChild:self.unitMenu];
}

-(void)drawFundsLabel {
    SKLabelNode *fundsLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    fundsLabel.fontSize = 40;
    fundsLabel.position = CGPointMake(self.frame.size.width - 50,self.frame.size.height - 30);
    fundsLabel.horizontalAlignmentMode = 2; //right aligned
    fundsLabel.verticalAlignmentMode = 2; //top aligned
    fundsLabel.fontColor = [self colorWithPlayerColor:self.board.playerColors[self.board.currentPlayer - 1]];
    fundsLabel.text = [NSString stringWithFormat:@"%@", self.board.funds[self.board.currentPlayer - 1]];
    [self addChild:fundsLabel];
}

@end
