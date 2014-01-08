//
//  hero.m
//  skellyAnimation
//
//  Created by Evan Forletta on 1/2/14.
//  Copyright (c) 2014 Evan Forletta. All rights reserved.
//

#import "hero.h"
#import "HelloWorldLayer.h"

@implementation hero

-(id)init{
	if ((selfie = [super initWithFile:@"heroIdle01.png"])) {
		
		//atributes:
		// velocity = 100 (pixels ?) per second
		_velocity = 73;
		
		//
		// sets up all the animation crap:
		//
		
		// addSpriteFramesWithFile is a class method of CCSpriteFramehche (specicaly the "sharedSpriteFrameChache") that looks at the plist and looks
		// for a png of the same name and also will manage CCSpriteFrame objects for displaying
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"heroAnim.plist"];
		
		// this introduces the actual png into the rendering pipeline and all individual sprites will be children of the
		// "spriteSheet" batch node
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"heroAnim.png"];
		[selfie addChild:spriteSheet];
		
		// itterate through the frames declared in the plist and asign them to a mutable array
		
		// the array:
		NSMutableArray *idleFrames = [NSMutableArray array];
		
		// the itterarion:
		for (int i = 1; i < 5; i++) {
			[idleFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"heroIdle0%d.png", i]]];
		}
		
		// creates the CCAnimation for the idling skelly with the frames in the array "idleFrames",
		// 1 second between frames, loops forever
		CCAnimation *idleAnimation = [CCAnimation animationWithSpriteFrames:idleFrames delay:0.15f];
		
		// sets the CCAction stated in the @property to an infinite, action with the animation defined in the CCAnimation section
		selfie.idleAction = [CCRepeatForever actionWithAction:
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
		selfie.walkingAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkingAnimation]];
		
		//fade in:
		_fadeInAction = [CCFadeIn actionWithDuration:0.5];
	
	}
	return selfie;
}

-(void)idle{
	[selfie stopAction:_walkingAction];
	[selfie runAction:_idleAction];
}

-(void)moveRight{
	[selfie stopAction:_walkingAction];
	[selfie stopAction:_idleAction];
	[selfie runAction:_walkingAction];

	selfie.flipX = YES;
	
}

-(void)moveLeft{
	[selfie stopAction:_walkingAction];
	[selfie stopAction:selfie.idleAction];
	[selfie runAction:selfie.walkingAction];
	
	selfie.flipX = NO;
}

-(void)heroMoveEnded{
	[selfie stopAction:_walkingAction];
	[selfie runAction:_idleAction];
}

-(void)fadeIn{
	[selfie runAction:_fadeInAction];
}

@end
