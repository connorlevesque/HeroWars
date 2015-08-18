//
//  EndStage.m
//  HeroWars
//
//  Created by Connor Levesque on 8/17/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "EndStage.h"

@implementation EndStage

-(id)initWithBoard:(Gameboard *)board {
    self = [super init];
    if (self) {
        self.board = board;
        [self awakenUnits];
    }
    return self;
}

-(void)autoToStartStage {
    [self setValue:@"StartStage" forKey:@"stage"];
}

-(void)awakenUnits {
    for (NSMutableArray *row in self.board.unitGrid) {
        for (id unitMaybe in row){
            if ([unitMaybe isKindOfClass:[Unit class]]){
                Unit *unit = (Unit *)unitMaybe;
                [unit changeStateTo:@"awake"];
            }
        }
    }
}

@end
