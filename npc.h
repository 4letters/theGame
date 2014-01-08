//
//  npc.h
//  skellyAnimation
//
//  Created by Evan Forletta on 1/1/14.
//  Copyright (c) 2014 Evan Forletta. All rights reserved.
//

#import "CCSprite.h"
#import "definitions.h"

@interface npc : CCSprite

//atributes:
@property(nonatomic, assign)int velocity;

// action:
@property(nonatomic, strong)id idleAction;
@property(nonatomic, strong)id walkingAction;
@property(nonatomic, strong)id fadeInAction;
@property(nonatomic, assign)id moveByAction;

// bools that keep track:
@property(nonatomic, assign)BOOL NPC_IS_IDLING;
@property(nonatomic, assign)BOOL NPC_IS_WALKING;
@property(nonatomic, assign)BOOL NPC_IS_IN_IDLE_LOOP;

//methods:
-(void)fadeIn;
-(void)idleWithStill;
-(void)idleLoopVersionThree;
-(void)walk;
-(void)movBy:(int)distance;
-(void)actionExperiment;
-(void)idleLoopOnce:(ccTime)dt;
-(void)pizza;

@end
