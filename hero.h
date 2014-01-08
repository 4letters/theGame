//
//  hero.h
//  skellyAnimation
//
//  Created by Evan Forletta on 1/2/14.
//  Copyright (c) 2014 Evan Forletta. All rights reserved.
//

#import "CCSprite.h"

@interface hero : CCSprite

//atributes:
@property(nonatomic, assign)CCSprite *dude;
@property(nonatomic, assign)int velocity;
@property(nonatomic, assign)int health;

// action:
@property(nonatomic, strong)id idleAction;
@property(nonatomic, strong)id walkingAction;
@property(nonatomic, strong)id fadeInAction;

-(void)idle;
-(void)moveRight;
-(void)moveLeft;
-(void)heroMoveEnded;
-(void)fadeIn;


@end
