//
//  Button.h
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Button : SKSpriteNode

@property (strong, nonatomic) NSString *type;

- (id)initWithName:(NSString *)name;
- (id)initUnitButtonWithName:(NSString *)name andColor:(NSString *)color;

@end
