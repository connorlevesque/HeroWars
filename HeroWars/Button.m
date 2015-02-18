//
//  Button.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Button.h"

@implementation Button

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        NSString *imageName = [NSString stringWithFormat:@"HeroWars_button_%@",name];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
    }
    return self;
}


@end
