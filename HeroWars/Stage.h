//
//  Stage.h
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gameboard.h"
#import "AllUIElements.h"


@interface Stage : NSObject

@property(strong, nonatomic) Gameboard *board;
@property(strong, nonatomic) NSString *stage;

@property(strong, nonatomic) Unit *selectedUnit;
@property(strong, nonatomic) Tile *selectedProduction;

-(void)processInputOfType:(NSString *)type onNodes:(NSArray *)touchedNodes;

-(SKNode *)findKeyNodeFromTouchedNodes:(NSArray *)touchedNodes;
-(void)processHeldKeyNode:(SKNode *)keyNode;

@end
