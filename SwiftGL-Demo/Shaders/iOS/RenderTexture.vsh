attribute vec4 position;
attribute vec4 inputTextureCoordinate;
uniform mat4 MVP;
varying vec2 textureCoordinate;

void main()
{
    gl_Position = MVP *position;
    textureCoordinate = inputTextureCoordinate.xy;
}