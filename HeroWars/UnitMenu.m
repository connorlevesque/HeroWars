//
//  UnitMenu.m
//  HeroWars
//
//  Created by Connor Levesque on 11/10/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import "UnitMenu.h"

@implementation UnitMenu

-(id)initWithType:(NSString *)type andColor:(NSString *)color andFunds:(NSInteger)funds {
    self = [super init];
    if (self) {
        //set image
        self.texture = [SKTexture textureWithImageNamed:@"menu_production.png"];
        self.size = self.texture.size;
        self.color = [UIColor whiteColor];
        self.anchorPoint = CGPointZero;
        //create buttons
        [self drawCancelButton];
        [self drawUnitButtonsWithType:type andColor:color andFunds:funds];
    }
    return self;
}

-(void)drawCancelButton {
    self.cancelButton = [[Button alloc]initWithName:@"cancel"];
    self.cancelButton.position = CGPointMake(100,280);
    [self addChild:self.cancelButton];
}

-(void)drawUnitButtonsWithType:(NSString *)type andColor:(NSString *)color andFunds:(NSInteger)funds {
    self.buttons = [self unitsProducedAtBuilding:type];
    for (int i = 0; i < [self.buttons count]; i++) {
        NSString *unitName = self.buttons[i];
        Button *unitButton = [[Button alloc]initUnitButtonWithName:unitName andColor:color];
        SKLabelNode *costLabel = [self createUnitCostLabelFromUnitName:unitName];
        if (funds < [self costFromUnitName:unitName]) {
            unitButton.alpha = .6;
            costLabel.alpha = .4;
        }
        int x = 130 + (i % 4) * 100;
        int y = 200 - (i / 4) * 100;
        unitButton.position = CGPointMake(x,y);
        costLabel.position = CGPointMake(x + 25 ,y - 35);
        [self addChild:unitButton];
        [self addChild:costLabel];
    }
}

// returns list of units made at production building
-(NSArray *)unitsProducedAtBuilding:(NSString *)building {
    NSArray *units = [[NSArray alloc]init];
    if ([building isEqualToString:@"barracks"]) {
        units = @[@"footman",@"archer",@"barbarian",@"paladin",@"skirmisher",@"knight",@"catapult",@"bombard"];
    } else {
        self.buttons = @[];
        NSLog(@"Error: No type passed to UnitMenu");
    }
    return units;
}

-(SKLabelNode *)createUnitCostLabelFromUnitName:(NSString *)unitName {
    SKLabelNode *unitCostLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    unitCostLabel.fontSize = 20;
    unitCostLabel.position = CGPointMake(self.frame.size.width,self.frame.size.height);
    unitCostLabel.horizontalAlignmentMode = 2; //left aligned
    unitCostLabel.verticalAlignmentMode = 2; //top aligned
    unitCostLabel.fontColor = [UIColor blackColor];
    NSInteger cost = [self costFromUnitName:unitName];
    unitCostLabel.text = [NSString stringWithFormat:@"%d", cost];
    return unitCostLabel;
}


// returns unit cost from name
-(NSInteger)costFromUnitName:(NSString *)unitName {
    // create placeholder variables to pass to unit init
    Tile *tile = [[Tile alloc]initTileNamed:@"empty"];
    NSArray *colors = @[@"red",@"blue"];
    Unit *unit = [[Unit alloc]initUnitNamed:unitName onTile:tile withColors:colors withOwner:1];
    return unit.cost;
}


@end
