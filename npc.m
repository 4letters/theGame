//
//  npc.m
//  skellyAnimation
//
//  Created by Evan Forletta on 1/1/14.
//  Copyright (c) 2014 Evan Forletta. All rights reserved.
//

#import "npc.h"
#import "HelloWorldLayer.h"

//private properties:
@interface npc ()

//@property(nonatomic, strong)id fadeInAction;

@end

@implementation npc

-(id)init{
	if ((self = [super initWithSpriteFrameName:@"skelly01.png"])) {
		
		//declarations:
		_NPC_IS_WALKING = NO;
		_NPC_IS_IDLING = NO;
		_NPC_IS_IN_IDLE_LOOP = NO;
		
		//atributes:
		// velocity = 100 (pixels ?) per second
		_velocity = 73;
		
		//
		// sets up all the animation crap:
		//
		
		// addSpriteFramesWithFile is a class method of CCSpriteFramehche (specicaly the "sharedSpriteFrameChache") that looks at the plist and looks
		// for a png of the same name and also will manage CCSpriteFrame objects for displaying
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"skellyAnim.plist"];
		
		// this introduces the actual png into the rendering pipeline and all individual sprites will be children of the
		// "spriteSheet" batch node
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"skellyAnim.png"];
		[self addChild:spriteSheet];
		
		// itterate through the frames declared in the plist and asign them to a mutable array
		
		// the array:
		NSMutableArray *idleFrames = [NSMutableArray array];
		
		// the itterarion:
		for (int i = 1; i < 5; i++) {
			[idleFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"skelly0%d.png", i]]];
		}
		
		// creates the CCAnimation for the idling skelly with the frames in the array "idleFrames",
		// 1 second between frames, loops forever
		CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames:idleFrames delay:0.15f];
		
		// sets the CCAction stated in the @property to an infinite, action with the animation defined in the CCAnimation section
		self.idleAction = [CCRepeatForever actionWithAction:
						   [CCAnimate actionWithAnimation:idleAnimation]];

		//
		// walking:
		//
		
		//walking frames
		NSMutableArray *walkingFrames = [NSMutableArray array];
		
		for (int i = 1; i < 5; i++) {
			[walkingFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"skellyWalk0%d.png", i]]];
		}
		
		CCAnimation *walkingAnimation = [CCAnimation animationWithSpriteFrames:walkingFrames delay:0.15f];
		
		//initalizes walkingAction
		self.walkingAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkingAnimation]];
		
		//fade in:
		_fadeInAction = [CCFadeIn actionWithDuration:0.5];
		
	}
	return self;
}

-(void)fadeIn{
	CCLOG(@"faded in!");
	[self runAction:_fadeInAction];
}

-(void)idleWithStill{
	[self stopAction:_walkingAction];
	[self runAction:_idleAction];
}

/*
-(void)idleLoop:(ccTime)dt{
	_NPC_IS_IN_IDLE_LOOP = YES;
	
	while (_NPC_IS_IN_IDLE_LOOP == YES) {
		//saftey: stop actions:
		[self stopAction: _walkingAction];
		[self stopAction: _idleAction];
		
		//decide:
		int posX = RAND_RANGE(50, (int)WIN_SIZE.width - 100);
		int initialDelay = RAND_RANGE(5, 10);
		int secondDelay = RAND_RANGE(5, 10);
		
		//calculate:
		int distMoved = selfie.position.x - posX;
		float speed = distMoved / _velocity;
		CGPoint destintation = CGPointMake(distMoved, 0);
		
		//do:
		CCLOG(@"delay: %d", initialDelay);
		CCAction *firstDelayAction = [CCDelayTime actionWithDuration: initialDelay];
		CCAction *secondDelayAction = [CCDelayTime actionWithDuration: secondDelay];
		
		if (distMoved > 0) {
			selfie.flipX = YES;
		}else{
			selfie.flipX = NO;
		}
		
		//velocity equals distance / time:
		_moveByAction = [CCMoveBy actionWithDuration:speed position:destintation];
		[selfie runAction:firstDelayAction];
		[selfie runAction:_walkingAction];		
		CCAction *stopWalkingAndIdleAction = [CCCallFunc actionWithTarget:self selector:@selector(stopWalkingAndIdleMethod)];
		[selfie runAction:[CCSequence actions:_moveByAction, stopWalkingAndIdleAction, nil]];
		
	}
}
*/

-(void)idleLoopVersionTwo{
	_NPC_IS_IN_IDLE_LOOP = YES;
	while (_NPC_IS_IN_IDLE_LOOP == YES) {
		//saftey: stop/start actions:
		[self stopAction:_idleAction];
		[self stopAction: _walkingAction];
		[self runAction:_idleAction];
		
		//decide:
		int posX = RAND_RANGE(50, (int)WIN_SIZE.width - 100);
		int initialDelay = RAND_RANGE(5, 10);
		
		//calculate:
		int distMoved = selfie.position.x - posX;
		float time = distMoved / _velocity;
		CGPoint destintation = CGPointMake(distMoved, 0);
		
		if (distMoved > 0) {
			selfie.flipX = YES;
		}else{
			selfie.flipX = NO;
		}
	
		CCLOG(@"delay: %d", initialDelay);
		
		//define actions
		CCFiniteTimeAction *firstDelayAction = [CCDelayTime actionWithDuration: initialDelay];
		CCCallFunc *stopIdleAction = [CCCallFunc actionWithTarget:self selector:@selector(stopIdle)];
		CCCallFunc *stopWalkingAction = [CCCallFunc actionWithTarget:self selector:@selector(stopWalking)];
		CCFiniteTimeAction *moveByAction = [CCMoveBy actionWithDuration:time position:destintation];
		
		//do actions:
		[self runAction:[CCSequence actions: firstDelayAction, stopIdleAction, nil]];
		[self runAction:_walkingAction];
		[self runAction: [CCSequence actions: moveByAction, stopWalkingAction, nil]];
		[self runAction:_idleAction];
	}
}

-(void)actionExperiment{
	//
	// experiment room:
	//
	
	CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:10];
	CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:5 position:ccp(0, 0)];
	
	CCLOG(@"go!");
	[selfie idleWithStill];
	[selfie runAction:[CCSequence actions: delay,
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_idleAction]; [self runAction:_walkingAction]; }],
					   move,
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_walkingAction]; [self runAction:_idleAction];}],
					   nil]];
	
}

-(void)idleLoopVersionThree{
	_NPC_IS_IN_IDLE_LOOP = YES;
	while (_NPC_IS_IN_IDLE_LOOP == YES) {
		//saftey: stop actions:
		[self stopAllActions];
	
		//decide:
		int posX = RAND_RANGE(50, (int)WIN_SIZE.width - 100);
		int initialDelay = RAND_RANGE(5, 10);
		
		//calculate:
		int distMoved = selfie.position.x - posX;
		float time = distMoved / _velocity;
		CGPoint destintation = CGPointMake(distMoved, 0);
		
		if (distMoved > 0) {
			selfie.flipX = YES;
		}else{
			selfie.flipX = NO;
		}
		
		//do actions:
		[self idleWithStill];
		[selfie runAction:[CCSequence actions:
						   [CCDelayTime actionWithDuration: initialDelay],
						   [CCCallBlock actionWithBlock:^{ [self stopAction:_idleAction]; [self runAction:_walkingAction]; }],
						   [CCMoveBy actionWithDuration:time position:destintation],
						   [CCCallBlock actionWithBlock:^{ [self stopAction:_walkingAction]; [selfie idleWithStill];}],
						   nil]];
		
		
		//saftey monitor:
		static int i = 0;
		i++;
		printf("%d\n", i);
	}
}

-(void)idleLoopOnce:(ccTime)dt{
	//saftey: stop actions:
	
	[self stopAllActions];
	
	//decide:
	int posX = RAND_RANGE(50, (int)WIN_SIZE.width - 50);
	int initialDelay = RAND_RANGE(1, 4);
	
	//calculate:
	int distMoved = selfie.position.x - posX;
	float time = distMoved / _velocity;
	CGPoint destintation = CGPointMake(posX, WIN_SIZE.height/2);
	
	if (distMoved > 0) {
		selfie.flipX = NO;
	}else{
		selfie.flipX = YES;
	}
	
	//do actions:
	[self idleWithStill];
	[selfie runAction:[CCSequence actions:
					   [CCDelayTime actionWithDuration: initialDelay],
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_idleAction]; [self runAction:_walkingAction]; }],
					   [CCMoveTo actionWithDuration:time position:destintation],
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_walkingAction]; [selfie idleWithStill];}],
					   nil]];
}

-(void)walk{
	[self stopAction:_idleAction];
	[self runAction:_walkingAction];	
}

-(void)stopIdle{
	CCLOG(@"stop idle");
	[self stopAction:_idleAction];
}

-(void)stopWalking{
	CCLOG(@"stoped walking");
	[self stopAction:_walkingAction];
}

-(void)pizza{
	//saftey: stop actions:
	[self stopAction:_idleAction];
	
	//decide:
	int posX = RAND_RANGE(50, 500);
	int initialDelay = 4;
	
	//calculate:
	int distMoved = selfie.position.x - posX;
	float time = distMoved / _velocity;
	CGPoint destintation = CGPointMake(posX, WIN_SIZE.height/2);
	
	if (distMoved > 0) {
		selfie.flipX = NO;
	}else{
		selfie.flipX = YES;
	}
	
	//do actions:
	[self idleWithStill];
	[selfie runAction:[CCSequence actions:
					   [CCDelayTime actionWithDuration: initialDelay],
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_idleAction]; [self runAction:_walkingAction]; }],
					   [CCMoveTo actionWithDuration:time position:destintation],
					   [CCCallBlock actionWithBlock:^{ [self stopAction:_walkingAction]; [selfie idleWithStill];}],
					   nil]];
}

@end
