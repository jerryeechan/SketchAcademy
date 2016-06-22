attribute vec4 position;
attribute vec2 textureUV;
uniform mat4 MVP;
varying vec2 vUV;

void main()
{
    gl_Position = MVP * position;
    vUV = textureUV.xy;
}