/*
 File: calligraphy.vsh
 
 */
#define M_PI 3.141592
#define M_PI_2 1.570796
#define Altitude_Limit 1.2

attribute vec4 vertexPosition;
attribute float pencilForce;
attribute float pencilAltitude;
attribute vec2 pencilAzimuth;
attribute vec2 vertexVelocity;
uniform mat4 MVP;
uniform float brushSize;
uniform vec4 brushColor;

varying lowp vec4 color;
varying lowp float angle;

highp float rand(vec4 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}
float easeout(float start, float dis, float t)
{
    return start-dis*t*(t-2.0);
}
float easein(float start, float dis, float t)
{
    return dis*t*t*t+start;
}
vec4 speedToColor(float speed)
{
    return vec4(1.0-(5.0-speed)/5.0,(10.0-speed)/10.0,(5.0-speed)/5.0,1.0);
}
vec4 speedForceToColor(float speed,float force)
{
    return vec4(1.0-(5.0-speed)/5.0,force,(5.0-speed)/5.0,1.0);
}
vec4 speedForceTiltToColor(float speed,float force,float altitude)
{
    return vec4(1.0-(5.0-speed)/5.0,force,altitude,1.0);
}
void main()
{
    
    float speed = length(vertexVelocity);
    float mapping = (500.0-speed)/500.0;
    float speedfade = easein(0.5,1.0,mapping);
    
    float altitude;
    altitude = float(pencilAltitude < Altitude_Limit) * (pencilAltitude/Altitude_Limit * M_PI_2 - M_PI_2) + M_PI_2;
    float tiltValue = easein(0.0,1.0,-(altitude-M_PI_2));
    vec2 tiltVec = tiltValue*pencilAzimuth*5.0;
    float easeoutForce = easeout(0.0,1.0,pencilForce);
    angle = atan(pencilAzimuth.y,pencilAzimuth.x);
    //speed fade may be remove
    //color = speedToColor(speed);//*easeout(0.2,1.0,pencilForce);
    color = speedForceToColor(speed,easeoutForce);
    color = speedForceTiltToColor(speed,easeoutForce,tiltValue);
    //with force
    gl_PointSize = brushSize * 1.0 * (1.0+tiltValue*2.0)*easeoutForce*10.0;
    
    gl_Position = MVP * (vertexPosition+ gl_PointSize/2.0 * vec4(pencilAzimuth.x/4.0,-pencilAzimuth.y,0.0,0.0));
    
}
