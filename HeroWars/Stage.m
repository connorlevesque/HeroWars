//
//  Stage.m
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Stage.h"

@implementation Stage

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)processInputOfType:(NSString *)type onNodes:(NSArray *)touchedNodes {
    
}

-(SKNode *)findKeyNodeFromTouchedNodes:(NSArray *)touchedNodes {
    //select keyNode from node hierarchy
    NSArray *nodeHierarchy = @[[Button class],[Menu class],[Unit class],[Highlight class],[Tile class]];
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

-(void)processHeldKeyNode:(SKNode *)keyNode {
    NSLog(@"%@ held", keyNode);
}

@end
