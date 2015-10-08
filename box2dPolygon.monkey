'Set Strict Mode
'Strict

'Import Box2d Modules
Import box2d.common.math.b2vec2

'Polygon Class
Class Polygon

	'Fields
	Field vertices:b2Vec2[]
	Field count:Int
	
	'Create a new polygon
	Method New(vertices:b2Vec2[], vertexCount)
		Self.vertices = vertices
		Self.count = vertexCount
	End Method
	
	'Returns vertex count
	Method VertexCount:Int()
		Return Self.count
	End Method	
	
End Class