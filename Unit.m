//
//  Unit.m
//  HeroWars
//
//  Created by Connor Levesque on 2/8/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Unit.h"

@implementation Unit

-(id)init {
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0,0);
    }
    return self;
}

@end
