//
//  InputManager.m
//  HeroWars
//
//  Created by Max Shashoua on 2/5/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "InputManager.h"


@implementation InputManager

-(void)receiveInputWithNode:(SKNode *) node andString: (NSString *) touchType {
    if ([touchType isEqualToString: @"drag"]) {
        NSLog(@"Touch = drag");
    }else if ([touchType isEqualToString: @"hold"]) {
        NSLog(@"Touch = hold");
    }else if ([touchType isEqualToString: @"tap"]) {
        NSLog(@"Touch = tap");
    }
}

-(BOOL)canDrag {
    return YES;
}

@end
