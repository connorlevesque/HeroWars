//
//  GameScene.h
//  HeroWars
//

//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Gameboard.h"
#import "AllUIElements.h"
@class GameView;

@interface GameScene : SKScene

// Model References
@property(strong, nonatomic) Gameboard *board;
@property(strong, nonatomic) Unit *selectedUnit;
@property(strong, nonatomic) Tile *selectedProduction;

// UI Elements
@property (strong, nonatomic) SKNode *world;
@property(strong, nonatomic) GeneralMenu *gameMenu;

// Touch
@property (strong, nonatomic) NSArray *touchedNodes;
@property (nonatomic) CGPoint lastTouch;
@property (strong, nonatomic) NSTimer *touchTimer;
@property (nonatomic) int touchState;
    // 0 = no touch detected, 1 = touch dragged, 2 = touch held

// Zoom
@property (nonatomic) CGPoint origPoint;
@property (strong, nonatomic) UIPinchGestureRecognizer *zoomRecognizer;
@property (nonatomic) CGFloat maxScale;
@property (nonatomic) CGFloat minScale;

-(id)initWithSize:(CGSize)size;
-(void)didMoveToView:(SKView *)view;
-(void)processTappedNode:(SKNode *)node;
-(void)processHeldNode:(SKNode *)node;
-(void)drawFundsLabel;
-(UIColor *)colorWithPlayerColor:(NSString *)playerColor;

@end
