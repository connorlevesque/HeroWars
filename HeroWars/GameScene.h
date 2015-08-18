//
//  GameScene.h
//  HeroWars
//

//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AllStages.h"
#import "GeneralMenu.h"
#import "ActionMenu.h"

@interface GameScene : SKScene

@property (strong, nonatomic) Stage *currentStage;
@property (strong, nonatomic) SKNode *world;
@property (strong, nonatomic) SKLabelNode *fundsLabel;

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
@property (strong, nonatomic) ActionMenu *actionMenu;
@property (strong, nonatomic) NSMutableArray *highlightedTiles;


// for zoom
@property (nonatomic) CGPoint origPoint;
@property (strong, nonatomic) UIPinchGestureRecognizer *zoomRecognizer;
@property (nonatomic) CGFloat maxScale;
@property (nonatomic) CGFloat minScale;


@end
