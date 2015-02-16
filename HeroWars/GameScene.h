//
//  GameScene.h
//  HeroWars
//

//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Gameboard.h"
#import "InputManager.h"
#import "GeneralMenu.h"

@interface GameScene : SKScene

@property (strong, nonatomic) Gameboard *board;
@property (strong, nonatomic) InputManager *inputManager;
@property (strong, nonatomic) SKNode *world;

@property (strong, nonatomic) NSArray *touchedNodes;
@property (nonatomic) CGPoint lastTouch;
@property (strong, nonatomic) NSTimer *touchTimer;

@property (nonatomic) int touchState;
/*
 0 = no touch detected
 1 = touch dragged
 2 = touch held
 */

@property (strong, nonatomic) GeneralMenu *generalMenu;
@property (strong, nonatomic) NSMutableArray *highlightedTiles;

@end
