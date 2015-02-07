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
#import "InputManager.h"

@interface GameScene : SKScene

@property (strong, nonatomic) Gameboard *board;
@property (strong, nonatomic) InputManager *inputManager;
@property (strong, nonatomic) SKNode *world;

@property (strong, nonatomic) SKNode *touchedNode;
@property (strong, nonatomic) NSTimer *touchTimer;
@property (nonatomic) BOOL hasTouchSent;

@end
