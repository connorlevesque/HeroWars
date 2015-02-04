//
//  Tile.h
//  HeroWars
//
//  Created by Max Shashoua on 1/31/15.
//  Copyright (c) 2015 Max Shashoua. All rights reserved.
//

#ifndef HeroWars_Tile_h
#define HeroWars_Tile_h

#import "SpriteKit/SpriteKit.h"

#endif

@interface Tile : SKSpriteNode

@property (strong, nonatomic) NSString *type;
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

-(id)initWithType:(NSString*)type;


/*
 Tile Types:
 p = Plains
 r = Road
 f = Forest
 m = Mountain
 v = River
 s = Sea
 b = Building
 Production Buildings (pending)
 */






@end