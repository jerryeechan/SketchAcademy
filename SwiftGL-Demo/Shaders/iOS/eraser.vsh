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

varying lowp float angle;
varying vec4 color;

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
void main()
{
    
    float speed = length(vertexVelocity);
    float mapping = (500.0-speed)/500.0;
    float speedfade = easein(0.5,1.0,mapping);
    float randNum = rand(vertexPosition);
    float randNum2 = rand(vertexPosition+vec4(1,1,0,0));
    float altitude;
    if (pencilAltitude > Altitude_Limit)
        altitude = M_PI_2;
    else
        altitude = pencilAltitude/Altitude_Limit * M_PI_2;
    
    float tiltValue = easein(0.0,1.0,-(altitude-M_PI_2));
    vec2 tiltVec = tiltValue*pencilAzimuth*5.0;
    float disx = randNum-0.5+tiltVec.x*easeout(1.0,-1.0,randNum2);
    float disy = randNum2-0.5-tiltVec.y*easeout(1.0,-1.0,randNum);
    //
    gl_Position = MVP * (vertexPosition+vec4(disx,disy,0,0)*2.0);
    gl_PointSize = brushSize*float(4)*(1.0+tiltValue/2.0);
    //angle = floor(randNum*4.0)/4.0 * M_PI;
    angle = randNum*M_PI;
    
    //speed fade may be remove
    
    color = brushColor*easeout(0.0,1.0,pencilForce)*speedfade;
    
}

