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

@interface InputManager : NSObject

-(id)initWithBoard:(Gameboard *)board;
-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString: (NSString *)touchType;
-(NSDictionary *)findTileCoordsToHighlight;
-(BOOL)canDrag;

@property (strong, nonatomic) NSString *stage;
@property (weak, nonatomic) Gameboard *board;
@property (strong, nonatomic) Unit *selectedUnit;
@property (strong, nonatomic) Pather *pather;

@end
