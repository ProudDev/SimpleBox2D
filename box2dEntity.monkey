'Set Strict Mode
Strict

'Import Box2d Modules
Import box2d.common
Import box2d.collision
Import box2d.dynamics
Import box2dPolygon

'Box2d Entity Class
Class Entity

	'Fields
	Field world:b2World
	Field body:b2Body
	Field bodyDef:b2BodyDef
	Field bodyShape:b2PolygonShape
	Field bodyShapeCircle:b2CircleShape
	Field fixtureDef:b2FixtureDef
	Field scale:Float
	Field img:Image
	Field frame:Int
	Field imgOffsetX:Float
	Field imgOffsetY:Float
	Field colliding:Bool
	
	'Creates a box shape for the entity
	Method CreateBox:Void(world:b2World, x:Float, y:Float, width:Float, height:Float, scale:Float = 64.0, restitution:Float=0.3, density:Float = 1.0, friction:Float = 0.3, static:Bool = False, sleep:Bool = True)
	
		'Set up box body
		Self.fixtureDef	= New b2FixtureDef()
		Self.bodyShape	= New b2PolygonShape()
		Self.bodyDef	= New b2BodyDef()
		
		'Determine if box is static or not
		If static = True
			Self.bodyDef.type = b2Body.b2_staticBody
		Else
			Self.bodyDef.type = b2Body.b2_Body
		endif		
		
		'Set box properties
		Self.fixtureDef.density	= density
		Self.fixtureDef.friction = friction
		Self.fixtureDef.restitution	= restitution
		Self.fixtureDef.shape = Self.bodyShape
		
		'Set box position
		Self.bodyDef.position.Set(x, y)
		
		'Set box scale
		Self.scale = scale
		
		'Set box state
		Self.bodyDef.allowSleep = sleep
		Self.bodyDef.awake = True
		
		'Set box world
		Self.world = world
		
		'Set shape as box
		Self.bodyShape.SetAsBox(width, height)
		
		'Create box
		Self.body = Self.world.CreateBody(Self.bodyDef)
		Self.body.CreateFixture(Self.fixtureDef)
		
	End
	
	'Creates a circle shape for the entity
	Method CreateCircle:Void(world:b2World, x:Float, y:Float, radius:Float, scale:Float = 64.0, restitution:Float=0.2, density:Float = 1.0, friction:Float = 0.3, static:Bool = False, sleep:Bool = True)
	
		'Set up the circle body
		Self.fixtureDef	= New b2FixtureDef()
		Self.bodyShapeCircle = New b2CircleShape(radius)
		Self.bodyDef	= New b2BodyDef()
		
		'Determine if circle is static or not
		If static = True
			Self.bodyDef.type = b2Body.b2_staticBody
		Else
			Self.bodyDef.type = b2Body.b2_Body
		endif		
		
		'Set circle properties
		Self.fixtureDef.density		= density 
		Self.fixtureDef.friction	= friction
		Self.fixtureDef.restitution	= restitution
		Self.fixtureDef.shape		= Self.bodyShapeCircle
		
		'Set cirlce position
		Self.bodyDef.position.Set(x, y)
		
		'Set circle scale
		Self.scale = scale
		
		'Set circle state
		Self.bodyDef.allowSleep = sleep
		Self.bodyDef.awake = True
		
		'Set circle world
		Self.world = world
		
		'Create circle
		Self.body = world.CreateBody(Self.bodyDef)
		Self.body.CreateFixture(Self.fixtureDef)
		
	End Method
	
	'Creates a multi-polygon shape for the entity
	Method CreateMultiPolygon:Void(world:b2World, x:Float, y:Float, polygonList:List<Polygon>, scale:Float = 64.0, restitution:Float=0.3, density:Float = 1.0, friction:Float = 0.3, static:Bool = False, sleep:Bool = True)
	
		'Set up polygon body
		Self.bodyDef	= New b2BodyDef()
		
		'Determine if box is static or not
		If static = True
			Self.bodyDef.type = b2Body.b2_staticBody
		Else
			Self.bodyDef.type = b2Body.b2_Body
		Endif	
		
		'Set position of body
		Self.bodyDef.position.Set(x, y)
		
		'Create initial body
		Self.body = world.CreateBody(Self.bodyDef)	
		
		
		'Create a fixture for each polygon shape
		For Local p:Polygon = Eachin polygonList
		
			'Scale Vertices
			For Local v:Int = 0 To (p.count - 1)
				p.vertices[v].x = (p.vertices[v].x/scale)
				p.vertices[v].y = (p.vertices[v].y/scale)
			Next
		
			Self.bodyShape	= New b2PolygonShape()
			Self.bodyShape.SetAsArray(p.vertices, p.count)
			
			Self.fixtureDef	= New b2FixtureDef()
			Self.fixtureDef.shape		= Self.bodyShape
			Self.fixtureDef.density		= density
			Self.fixtureDef.friction	= friction
			Self.fixtureDef.restitution	= restitution
			
			Self.bodyDef.position.Set(x, y)
			Self.body.CreateFixture(Self.fixtureDef)
		
		Next
		
		'Set polygon body properties
		Self.bodyDef.position.Set(x, y)
		Self.world = world
		Self.bodyDef.allowSleep		= sleep
		Self.bodyDef.awake			= True
		Self.scale = scale
		
	End
	
	'Draw the entity
	Method Draw:Void(offsetX:Float = 0.0, offsetY:Float=0.0)
	
		'If entity has an image attached then draw it
		If Self.img <> Null
		
			'Determine Image Location
			Local x:Float = Self.GetPositionX()
			Local y:Float = Self.GetPositionY()
			Local r:Float = RadToDeg(Self.body.GetAngle()) * -1
			
			'Draw Image
			DrawImage(Self.img, x, y, r, 1.0, 1.0, Self.frame)
			
		Endif
		
	End
	
	'Converts Radians to Degrees
	Method RadToDeg:Int(rad:Float)
		If rad <> 0.0 Then Return (rad * 180.0) / PI Else Return 0
	End Method
	
	'Converts Degrees to Radians
	Method DegToRad:Int(deg:Float)
		If deg <> 0.0 Then Return (deg * PI) / 180.0 Else Return 0
	End Method
	
	'Applies Impluse to body
	Method ApplyImpulse:Void(impulse:b2Vec2, point:b2Vec2)
		Self.body.ApplyImpulse(impulse, point)
	End Method
	
	'Returns the position of body (Position is scaled to physics!!)
	Method GetPosition:b2Vec2()
		Return Self.body.GetPosition()
	End Method
	
	'Returns scaled X position (Position is scaled up)
	Method GetPositionX:Float()
		Return (Self.GetPosition().x * Self.scale)
	End Method
	
	'Returns scaled Y position (Position is scaled up)
	Method GetPositionY:Float()
		Return (Self.GetPosition().y * Self.scale)
	End Method
	
	'Sets the position of body
	Method SetPosition:Void(x:Float, y:Float)
		Self.body.SetPosition(New b2Vec2((x/Self.scale), (y/Self.scale)))
	End Method
	
	'Sets an image for the entity
	Method SetImage:Void(img:Image)
		Self.img = img
	End
	
	'Clears forces from body
	Method ClearForces:Void()
		Self.body.SetLinearVelocity(New b2Vec2(0.0, 0.0))
		Self.body.SetAngularVelocity(0.0)
	End Method
	
End Class