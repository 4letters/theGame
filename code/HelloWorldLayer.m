/* A game by Evan

 ISSUES:

			1.) sklley's position is only noted on touch down, need to loop through some how... cant use while loop... try per frame update?
		        perhaps change the code in the move methods scheduled to constantly update its position value so that other methods can see it...

		    2.) skelly moves twice as fast when the bg moves: find way to keep speed the same for both kinds of movement

			3.) if all else fails perhaps hold skelly in the center, play its walking animation, and move only the bg

			4.) size of the map: sprites are only able to be 4098 x 4098
			
			5.) SNOW: when moving the snow with bg on move in a scheduled method the system moves independently to the particles
 
			6.) SNOW: size of emitter itself, skelly can walk right out of emitter range
 
			7.) MEMORY: figure out the despawning of off screen items also: SNOW: number of particles on one small map is ~350 



 SOLUTIONS:

			1.) use built in update method to do all updates: ran pre frame render

			2.)

			3.) yes, i think we shall stick with that for now

			4.) 

			5.) need to move as a group: set _snow.positionType to kCCPositionTypeGrouped
 
			6.) changed the variance of the emitter position to be across the whole map
 
			7.) 

 TODO:

		1.) further improve movement, use solution 1 to implement the first proposed movement

		2.) recognize double taps for run - runing animation

		3.) set map bounds

		4.) bigger maps!!!!	--	larger than 4098 x 4098

		5.) efficiently render a repeating map bg FOREVER

		6.) christmas map!!!!
			a.) snow!!! - done. see the coco box method "letItSnowLetItSnow"
			b.) paralax
			c.) new pixles 
			d.) completely set up a bunch or difrent trees, rocks, shruberies &c &c within a pallate PSD

		7.) continuious updating, recognizable to runtime code (were talking like positions, speeds, hormone levels)

		8.) make particle system move with bg on move, maybe even the landing point to slide to the other side
 
		9.) stop/start fluid motion with camera and paralax layers 
 
		10.) everything is in total shit right now: fix it and divide things into own classes
*/
#import <Foundation/Foundation.h>
#import "HelloWorldLayer.h"
#import "definitions.h"
#import "npc.h"
#import "hero.h"

@interface HelloWorldLayer ()

//private properties:
@property (nonatomic, strong) hero *hero;
@property (nonatomic, strong) CCAction *idleAction;
@property (nonatomic, strong) CCAction *walkingAction;
@property (nonatomic, strong) CCParticleSnow *snow;
@property (nonatomic, assign) int npcCount;

@end

@implementation HelloWorldLayer

//implements some methods:

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    if((self = [super init])){
		
		//some setup:
		zoomMultiplier = .8;
		_npcCount = 0;

		//winter:
		bgZoomAdjust = ((zoomMultiplier - 1) * 300) + 100;
		skellyZoomAdjust = ((zoomMultiplier - 1) * 109) - 70;
		
		bgOriginalPosition = self.bg.position.x/2;
		skellyPosition = bgOriginalPosition - self.bg.position.x;
				
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
		
		//walking frames
		NSMutableArray *walkingFrames = [NSMutableArray array];
		
		for (int i = 1; i < 5; i++) {
			[walkingFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"skellyWalk0%d.png", i]]];
		}
		
		//initial delay: 0.15f
		CCAnimation *walkingAnimation = [CCAnimation animationWithSpriteFrames:walkingFrames delay:0.15f];
		
		//initalizes walkingAction
		self.walkingAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkingAnimation]];

		self.bg = [CCSprite spriteWithFile:@"wonderChopOne.png"];
		[self addChild:self.bg z:0];
		self.bg.position = ccp(WIN_SIZE.width/2, (WIN_SIZE.height/2) + bgZoomAdjust);
		self.bg.scale = 1 * zoomMultiplier;		
		
		//touch enabled in the layer
		self.touchEnabled = YES;
		
		//let it snow:
		[self letItSnowLetItSnowLetItSnow];

		// and there was a hero...
		_hero = [[hero alloc] init];
		_hero.position = ccp(WIN_SIZE.width/2, 75);
		_hero.scale = .75;
		[_hero idle];
		[self addChild:_hero];
		
			
	}
    return self;
}

-(void)spawnFuck{
	CCLOG(@"spawned fuck");
	while(_npcCount < 10) {
		// decide values:
		int directionDecision = RAND_NUM(2);
		int posX = arc4random() % (int)WIN_SIZE.width;
		
		//the npc:
		npc *FUCK = [[npc alloc] init];
		FUCK.position = ccp(posX, WIN_SIZE.height/2);
		
		// direction:
		if (directionDecision == 0) {
			FUCK.flipX = YES;
		}
		
		[FUCK idleWithStill];
		
		//opacity set to 0 before fadein is called to avoid flashing:
		FUCK.opacity = 0;
		[FUCK fadeIn];

		//make last thing done adding it as a child to avoid flashes
		[self addChild:FUCK];
		_npcCount++;				
		break;
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	// determine the touch location:
	// makes a CGPoint (x,y) called touchLocation and sets it to a coverted touch to node
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
	
	//test for right or left
	if (touchLocation.x > WIN_SIZE.width/2) {
		[_hero moveRight];
		[_hero moveRight];
		[self schedule:@selector(moveBgLeft:)];
		
	}else{
		[_hero moveLeft];
		[self schedule:@selector(moveBgRight:)];
	}
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CCLOG(@"ENDED");
	//stops the scheduling and thus stops the motion
	[self unschedule:@selector(moveBgRight:)];
	[self unschedule:@selector(moveBgLeft:)];
	
	[_hero heroMoveEnded];
}

-(void)moveBgLeft:(ccTime)dt{
	// position * dt * zoomMultiplier is to keep speed constant with zoom
	self.bg.position = ccp(self.bg.position.x - (120*dt) * zoomMultiplier, self.bg.position.y);
	
	// for the particles:
	_snow.position = ccp(_snow.position.x - (120*dt) * zoomMultiplier, _snow.position.y);
}

-(void)moveBgRight:(ccTime)dt{
	// position * dt * zoomMultiplier is to keep speed constant with zoom
	self.bg.position = ccp(self.bg.position.x + (120*dt) * zoomMultiplier, self.bg.position.y);
	
	// for the particles:
	_snow.position = ccp(_snow.position.x + 120 * dt * zoomMultiplier, _snow.position.y);
}

-(void)moveBgLeftPre{
	[self schedule:@selector(moveBgLeft:)];
}

-(void)moveBgRightPre{
	[self schedule:@selector(moveBgRight:)];
}

//particles: snow:
-(void) letItSnowLetItSnowLetItSnow{
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	//
	// snow particles: uses predefined properties of (and is a) CCParticleSystemQuad
	//
	
	_snow = [[CCParticleSnow alloc] init];
	
	//
	// properties common to SYSTEM:
	//
	
	// emissionRate (a float). How many particle are emitted per second
	_snow.emissionRate = 60;
	
	// duration (a float). How many seconds does the particle system (different than the life property) lives.
	// Use kCCParticleDurationInfinity for infity.
	
	// blendFunc (a ccBlendFunc). The OpenGL blending function used for the system
	
	// positionType (a tCCPositionType).
	// Use kCCPositionTypeFree (default one) for moving particles freely.
	// use kCCPositionTypeGrouped to move them in a group.
	_snow.positionType = kCCPositionTypeGrouped;
	
	// texture (a CCTexture2D). The texture used for the particles
	_snow.texture = [[CCTextureCache sharedTextureCache] addImage:@"snowflake.png"];
	
	//
	// properties common to PARTICLES:
	//
	
	//position (CGPoint)
	_snow.position = ccp(winSize.width/2, winSize.height);
	
	//position variance (CGPoint)
	// SOLUTION 6: this ensure that the emitter is spawing across a variance of the length of the map(divided by two becuase its in either direction)
	_snow.posVar = ccp( _bg.contentSize.width/2 , 0);
	
	// speed (float)
	// arc4random() will return a maximum value of 0x100000000 (4294967296)...
	// modulo 20 ensures a range of 0 to 20...
	// adding 20 to the whole deal makes the range 20 - 40
	_snow.speed = 21 + (arc4random() % 21);
	
	//speed variance (float)
	_snow.speedVar = 5;
	
	// point to which shit falls
	_snow.gravity = CGPointMake(0, 0);
	
	// duration of entier SYSTEM not particles
	// kCCParticleDurationInfinity for infinite
	_snow.duration = kCCParticleDurationInfinity;
	
	//start size: 5 pixels
	_snow.startSize = 7;
	
	//start size variance: 2 pixles(?)
	_snow.startSizeVar = 2;
	
	//sets start and end size equal
	_snow.endSize = kCCParticleStartSizeEqualToEndSize;
	
	//end size: 100 pixles
	//_snow.endSize = 100;
	
	//end size variation: 4 pixles(?)
	//_snow.endSizeVar = 4;
	
	/* COLORS:
	 start color (a ccColor4F)
	 _snow.startColor
	 start color variation (a ccColor4F)
	 _snow.startColorVar
	 end color (a ccColor4F)
	 can set the opacity in the end to fade the particle
	 _snow.endColor
	 end color variation (a ccColor4F)
	 _snow.endColorVar
	 */
	
	/* Spins *only in CCParticleSystemQuad
	 _snow.startSpin
	 _snow.startSpinVar
	 _snow.endSpin
	 _snow.endSpinVar
	 */
	
	//life: 12 seconds
	_snow.life = 13;
	
	//life variation in seconds(?)
	_snow.lifeVar = 0.5;
	
	/* anlges:
	 _snow.angle: (a float). Starting degrees of the particle
	 _snow.angleVar
	 */
	
	//finish up and snow as a child to the layer(?)
	//pizza:
	[self addChild:_snow z:3];
}

- (void)update:(ccTime)delta{
	
	//updates known skelly position
	//	skellyPosition = bgOriginalPosition - self.bg.position.x;
	//	CCLOG(@"Skelly X	:	%i", skellyPosition);
	
	//keep track of number of particles:
	//	CCLOG(@"Particle Number		:	%i", _snow.particleCount);
	
}

//enables touches
- (void)registerWithTouchDispatcher{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:
	 self priority:0 swallowsTouches:YES];
}
@end
