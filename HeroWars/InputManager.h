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

@interface InputManager : NSObject

-(void)receiveInputWithNode:(SKNode *) node andString: (NSString *) touchType;
-(BOOL)canDrag;

@property (strong, nonatomic) NSString *stage;

@end
