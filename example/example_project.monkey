'Set Strict Mode
Strict

'Import Modules
Import mojo
Import mjc.simplebox2d

'Main Function
Function Main:Int()
	New Game()
	Return(0)
End Function

'Game Class
Class Game Extends App

	'Fields
	Field world:Box2D_World
	Field entityList:List<Entity>
	Field img_car:Image

	'OnCreate Method
	Method OnCreate:Int()
	
		'Create New Box2d World
		world = New Box2D_World(True)'True, True)
		
		'Create Ground
		world.CreateBox(-5, 470, 645, 5, True, 0.0) 

		'Create Entity List
		entityList = New List<Entity>
		
		'Set Update Rate
		SetUpdateRate(60)
		
		'Return 0
		Return(0)
		
	End Method
	
	'OnUpdate Method
	Method OnUpdate:Int()
	
		'Spawn a box where touched
		If MouseHit(0)
			entityList.AddLast(world.CreateBox(TouchX(), TouchY(), 10, 10, False, 0.8, 1.0, 0.2))
		EndIf
		
		'Spawn Circle on right click
		If MouseHit(1)
			world.CreateCircle(TouchX(), TouchY(), 15)
		Endif
		
		If KeyHit(KEY_SPACE)
			For Local e:Entity = Eachin entityList
				e.ApplyImpulse(New b2Vec2(0.0, -1.0), New b2Vec2(e.GetPosition().x, e.GetPosition().y))
				e.SetPosition(e.GetPositionX(), e.GetPositionY() -50)
				e.ClearForces()
			Next
		Endif
		
		If KeyHit(KEY_1)
			If world.debug = True
				world.SetDebugMode(False, False)
			Else
				world.SetDebugMode(True, True)
			EndIf
		Endif
		
		'Update Physics World
		world.Update()
		
		'Return 0
		Return(0)
		
	End Method
	
	'OnRender Method
	Method OnRender:Int()
	
		'Clear Screen
		Cls(0, 0, 255)
		
		'Draw Physics Entities
		world.Render()
		
		'Return 0
		Return(0)
		
	End Method
	
End Class