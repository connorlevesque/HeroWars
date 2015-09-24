//
//  Highlight.m
//  HeroWars
//
//  Created by Connor Levesque on 2/13/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Highlight.h"

@implementation Highlight

-(id)initWithType:(NSString *)type {
    self = [super init];
    if (self) {
        self.type = type;
        NSString *imageName = [NSString stringWithFormat:@"highlight_%@",type];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.anchorPoint = CGPointMake(0,0);
    }
    return self;
}

@end
