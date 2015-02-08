//
//  GeneralMenu.m
//  HeroWars
//
//  Created by Connor Levesque on 2/7/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "GeneralMenu.h"

@implementation GeneralMenu

-(id)init {
    self = [super init];
    if (self) {
        //set image
        self.texture = [SKTexture textureWithImageNamed:@"heroWars_tile_100_white.png"];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        //create buttons
        SKSpriteNode *end = [[SKSpriteNode alloc]initWithColor:[UIColor redColor] size:CGSizeMake(80, 20)];
        self.buttons = @[end];
        for (SKSpriteNode *button in self.buttons) {
            button.position = CGPointZero;
            [self addChild:button];
        }
    }
    return self;
}

@end
