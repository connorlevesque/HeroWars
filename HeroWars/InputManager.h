//
//  InputManager.h
//  HeroWars
//
//  Created by Max Shashoua on 2/5/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Tile.h"
#import "Unit.h"
#import "GeneralMenu.h"
#import "Pather.h"

@interface InputManager : NSObject

-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString: (NSString *)touchType;
-(BOOL)canDrag;

@property (strong, nonatomic) NSString *stage;
@property (strong, nonatomic) Pather *pather;
@end
