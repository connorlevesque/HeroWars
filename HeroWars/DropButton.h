//
//  DropButton.h
//  HeroWars
//
//  Created by Connor Levesque on 8/22/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Button.h"
@class Unit;

@interface DropButton : Button

@property (weak, nonatomic) Unit *unit;

@end
