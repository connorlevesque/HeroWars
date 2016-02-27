//
//  UnitMenu.h
//  HeroWars
//
//  Created by Connor Levesque on 11/10/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "Menu.h"
#import "Unit.h"

@interface UnitMenu : Menu

@property (strong, nonatomic) Button *cancelButton;
@property (strong, nonatomic) Button *buyButton;

-(id)initWithType:(NSString *)type andColor:(NSString *)color andFunds:(NSInteger)funds;
-(NSInteger)costFromUnitName:(NSString *)unitName;

@end
