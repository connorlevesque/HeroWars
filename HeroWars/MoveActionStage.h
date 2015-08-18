//
//  MoveActionStage.h
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Stage.h"

@interface MoveActionStage : Stage

-(id)initWithBoard:(Gameboard *)board andUnit:(Unit *)unit;
-(void)processInputOfType:(NSString *)type onNodes:(NSArray *)touchedNodes;

@end
