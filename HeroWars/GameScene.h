//
//  GameScene.h
//  HeroWars
//

//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Gameboard.h"
#import "InputManager.h"
#import "Map.h"

@interface GameScene : SKScene

@property (strong, nonatomic) Gameboard *board;
@property (strong, nonatomic) InputManager *inputManager;
@property (strong, nonatomic) SKNode *world;

@property (strong, nonatomic) SKNode *touchedNode;
@property (nonatomic) CGPoint lastTouch;
@property (strong, nonatomic) NSTimer *touchTimer;

@property (nonatomic) NSInteger touchState;
/*
0 = no touch detected
1 = touch dragged
2 = touch held
*/

@end
