//
//  InputManager.h
//  HeroWars
//
//  Created by Max Shashoua on 2/5/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Gameboard.h"
#import "GeneralMenu.h"
#import "Highlight.h"
#import "Pather.h"
#import "Combat.h"

@interface InputManager : NSObject

-(id)initWithBoard:(Gameboard *)board;
-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString: (NSString *)touchType;
-(NSDictionary *)findTileCoordsToMoveHighlight;
-(NSMutableArray *)findTileCoordsToAttackHighlight;
-(BOOL)canDrag;

@property (strong, nonatomic) NSString *stage;
@property (weak, nonatomic) Gameboard *board;
@property (strong, nonatomic) Unit *selectedUnit;
@property (strong, nonatomic) Pather *pather;
@property (strong, nonatomic) Combat *combat;

@end
