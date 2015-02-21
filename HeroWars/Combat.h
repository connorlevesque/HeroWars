//
//  Combat.h
//  HeroWars
//
//  Created by Connor Levesque on 2/20/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gameboard.h"

@interface Combat : NSObject

@property (strong, nonatomic) Unit *a;
@property (strong, nonatomic) Unit *b;

-(void)fightFirstUnit:(Unit *)a againstSecondUnit:(Unit *)b;

@end
