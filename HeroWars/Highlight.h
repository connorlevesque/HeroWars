//
//  Highlight.h
//  HeroWars
//
//  Created by Connor Levesque on 2/13/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Highlight : SKSpriteNode

@property(strong, nonatomic) NSString *type;

-(id)initWithType:(NSString *)type;

@end
