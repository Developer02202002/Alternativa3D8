from decimal import Decimal as D
from mathutils import Vector
import bpy

myObject = bpy.data.objects["Cylinder"]
exportPathStr = 'D:\\FLEX\\alternativa\\blenderExport\\blender3d\\myBlenderCylider.txt';
mesh = myObject.data;
for v in mesh.vertices:
	print(str(v.co.x));

myStr = '';
#ob = bpy.context.active_object
me = mesh
me.calc_tessface()

def verticesToStr(vertice):
	outStr = ''
	outStr+='%.5f' % vertice.co.x+','
	outStr+='%.5f' % vertice.co.y+','
	outStr+='%.5f' % vertice.co.z
	return outStr

def uvToStr(uv):
	outStr = ''
	outStr+='%.5f' % uv.x+','
	outStr+='%.5f' % uv.y
	return outStr

def dellLastSim(myStr):
	return myStr[0:len(myStr)-1];

print('START\nSTART\nSTART');
meVerticesStr = ''
for v in me.vertices:
	meVerticesStr+=verticesToStr(v)+','
meVerticesStr = meVerticesStr[0:len(meVerticesStr)-1];
#print('meVertices= ['+meVerticesStr+']');

indexStr = '';
uvStr = '';

for f in me.tessfaces:
	if len(f.vertices) == 3:
		#print("f012", f.vertices[0], f.vertices[1], f.vertices[2])
		indexStr+="%i"%f.vertices[0]+",%i"%f.vertices[1]+",%i"%f.vertices[2]+',';
		
		#print(f.index)
		fIndx = f.index
		uv1 = mesh.tessface_uv_textures.active.data[f.index].uv1
		uv2 = mesh.tessface_uv_textures.active.data[f.index].uv2
		uv3 = mesh.tessface_uv_textures.active.data[f.index].uv3
		uvStr+=uvToStr(uv1)+','+uvToStr(uv2)+','+uvToStr(uv3)+',';
		#print(uv1,uv2,uv3)
	else:
		#print("f012", f.vertices[0], f.vertices[1], f.vertices[2])
		indexStr+="%i"%f.vertices[0]+",%i"%f.vertices[1]+",%i"%f.vertices[2]+',';
		
		uv1 = mesh.tessface_uv_textures.active.data[f.index].uv1
		uv2 = mesh.tessface_uv_textures.active.data[f.index].uv2
		uv3 = mesh.tessface_uv_textures.active.data[f.index].uv3
		
		uvStr+=uvToStr(uv1)+','+uvToStr(uv2)+','+uvToStr(uv3)+',';
		#print(uv1,uv2,uv3)
		#print("f023", f.vertices[0], f.vertices[2], f.vertices[3])
		indexStr+="%i"%f.vertices[0]+",%i"%f.vertices[2]+",%i"%f.vertices[3]+',';
		
		uv1 = mesh.tessface_uv_textures.active.data[f.index].uv1
		uv2 = mesh.tessface_uv_textures.active.data[f.index].uv3
		uv3 = mesh.tessface_uv_textures.active.data[f.index].uv4
		uvStr+=uvToStr(uv1)+','+uvToStr(uv2)+','+uvToStr(uv3)+',';
		#print(uv1,uv2,uv3)

indexStr = dellLastSim(indexStr);
uvStr = dellLastSim(uvStr);
#print('meIndex=['+indexStr+'];');
#print('meUvStr=['+uvStr'];');

outFile = open(exportPathStr, 'w');
outFile.write('var meVertices:Array = ['+meVerticesStr+'];\n');
outFile.write('var meIndex:Array = ['+indexStr+'];\n');
outFile.write('var meUv:Array = ['+uvStr+'];\n');
print('PROGRAM EXPORT - OK');
outFile.close();