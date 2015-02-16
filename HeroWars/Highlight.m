//
//  Highlight.m
//  HeroWars
//
//  Created by Connor Levesque on 2/13/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Highlight.h"

@implementation Highlight

-(id)initWithImageNamed:(NSString *)name {
    self = [super init];
    if (self) {
        self.texture = [SKTexture textureWithImageNamed:name];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.anchorPoint = CGPointMake(0,0);
    }
    return self;
}

@end
