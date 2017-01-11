/*
 File: calligraphy.fsh
 */

#extension GL_EXT_shader_framebuffer_fetch : require
#define BlendOverlay(a, b) ( (b<0.5) ? (2.0*b*a) : (1.0-2.0*(1.0-a)*(1.0-b)) )

precision lowp float;
uniform sampler2D texture;

varying lowp float angle;
//uniform float vRotation;
varying lowp vec4 color;

void main()
{
    
    lowp vec4 destColor = gl_LastFragData[0];
    
    float vRotation = angle;
    float mid = 0.5;
    
    vec2 rotated = vec2(cos(vRotation) * (gl_PointCoord.x - mid) + sin(vRotation) * (gl_PointCoord.y - mid) + mid,cos(vRotation) * (gl_PointCoord.y - mid) - sin(vRotation) * (gl_PointCoord.x - mid) + mid);
    //gl_FragColor = ?(vec4(0.0,0.0,0.0,1.0)):(-destColor);
    //gl_FragColor = color * texture2D(texture, rotated);// - destColor;
    
    //gl_FragColor = vec4(0.0,0.0,0.0,1.0) * texture2D(texture, rotated);
   
   
    gl_FragColor = color * texture2D(texture, rotated);
    
    
    //gl_FragColor = color * texture2D(texture, gl_PointCoord);// - destColor;
    
    
    //gl_FragColor.r = BlendOverlay(color.r, destColor.r);
    //gl_FragColor.g = BlendOverlay(color.g, destColor.g);
    //gl_FragColor.b = BlendOverlay(color.b, destColor.b);
    //gl_FragColor.a = color.a;
    
    //gl_FragColor = vec4(0.5,0,0,0.5);// - destColor;
    //gl_FragColor = color *texture2D(texture, rotated);
}
