//
//  Map.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Map : NSObject

@property (strong, nonatomic) NSMutableArray *tileArray;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;

-(id)initWithArray:(NSArray *)typeArray;

@end
