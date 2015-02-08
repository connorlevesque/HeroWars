//
//  InputManager.m
//  HeroWars
//
//  Created by Max Shashoua on 2/5/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "InputManager.h"


@implementation InputManager

-(id)init {
    self = [super init];
    if (self){
        [self setValue:@"battle" forKey:@"stage"];
    }
    return self;
}

-(void)receiveInputWithNode:(SKNode *)touchedNode andString: (NSString *)touchType {
    // if battle stage
    if ([self.stage isEqualToString:@"battle"]) {
        // if hold
        if ([touchType isEqualToString: @"hold"]) {
            NSLog(@"Tile held");
            
        // if tap
        }else if ([touchType isEqualToString: @"tap"]) {
            // if tile
            if ([touchedNode isKindOfClass:[Tile class]]) {
                //NSLog(@"Tile tapped");
                [self setValue:@"generalMenu" forKey:@"stage"];
            }
        }
    }
}



-(BOOL)canDrag {
    return YES;
}

@end
