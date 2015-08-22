//
//  GameView.h
//  HeroWars
//
//  Created by Connor Levesque on 8/21/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameScene;

@interface GameView : SKView

@property(strong, nonatomic) GameScene *previousScene;

@end
