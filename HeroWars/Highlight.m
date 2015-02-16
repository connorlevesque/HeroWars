//
//  Highlight.m
//  HeroWars
//
//  Created by Max Shashoua on 2/13/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Highlight.h"

@implementation Highlight

-(id) init {
    self = [super init];
    if (self) {
        self.texture = [SKTexture textureWithImageNamed:@"HeroWars_transparentBlue.png"];
        self.color = [UIColor whiteColor];
        self.size = self.texture.size;
        self.anchorPoint = CGPointZero;
    }
    return self;
}

@end
