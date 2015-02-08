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

-(void)receiveInputWithNodes:(NSArray *)touchedNodes andString: (NSString *)touchType {
    //select keyNode from node hierarchy
    SKNode *keyNode = [self findKeyNodeFromTouchedNodes:touchedNodes];
    // if battle stage
    if ([self.stage isEqualToString:@"battle"]) {
        
        
        // if hold
        if ([touchType isEqualToString: @"hold"]) {
            NSLog(@"Tile held");
            
        // if tap
        }else if ([touchType isEqualToString: @"tap"]) {
            // if tile
            if ([keyNode isKindOfClass:[Tile class]]) {
                //NSLog(@"Tile tapped");
                [self setValue:@"generalMenu" forKey:@"stage"];
            }
        }
    }
    // if generalMenu stage
    else if ([self.stage isEqualToString:@"generalMenu"]){
        if ([keyNode isKindOfClass:[Button class]] || [keyNode isKindOfClass:[GeneralMenu class]]){
            NSLog(@"menu stuff");
        } else {
            [self setValue:@"battle" forKey:@"stage"];
        }
    }
    
}

-(SKNode *)findKeyNodeFromTouchedNodes:(NSArray *)touchedNodes {
    //select keyNode from node hierarchy
    NSArray *nodeHierarchy = @[[Button class],[Menu class],/*[Unit class],[Building class],*/[Tile class]];
    SKNode *keyNode = [[SKNode alloc]init];
    for (Class classType in nodeHierarchy) {
        for (SKNode *node in touchedNodes) {
            if ([node isKindOfClass:classType]) {
                keyNode = node;
                return keyNode;
            }
        }
    }
    return nil;
}

-(BOOL)canDrag {
    
    return YES;
}

@end
