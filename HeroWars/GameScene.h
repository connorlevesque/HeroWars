//
//  GameScene.h
//  HeroWars
//

//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Gameboard.h"

@interface GameScene : SKScene

@property (strong, nonatomic) Gameboard *board;

@end
