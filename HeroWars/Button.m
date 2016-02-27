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
        NSString *imageName;
        imageName = [NSString stringWithFormat:@"button_%@",name];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.type = @"none";
    }
    return self;
}

- (id)initUnitButtonWithName:(NSString *)name andColor:(NSString *)color {
    self = [super init];
    if (self) {
        self.name = name;
        NSString *imageName;
        imageName = [NSString stringWithFormat:@"%@_%@", name, color];
        self.texture = [SKTexture textureWithImageNamed:imageName];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.type = @"unit";
    }
    return self;
}

@end
