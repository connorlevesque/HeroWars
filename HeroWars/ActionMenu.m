//
//  ActionMenu.m
//  HeroWars
//
//  Created by Connor Levesque on 2/16/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "ActionMenu.h"

@implementation ActionMenu

-(id)init {
    self = [super init];
    if (self) {
        //set image
        self.texture = [SKTexture textureWithImageNamed:@"HeroWars_generalMenu1.png"];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.anchorPoint = CGPointZero;
        //create buttons
        self.buttons = @[@"attack",@"wait"];
        for (int i = 0; i < [self.buttons count]; i++) {
            NSString *buttonName = self.buttons[i];
            Button *button = [[Button alloc]initWithName:buttonName];
            button.position = CGPointMake(76,170 - i * (button.size.height + 10));
            [self addChild:button];
        }
    }
    return self;
}

@end
