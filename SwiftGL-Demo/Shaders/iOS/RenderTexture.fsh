varying highp vec2 textureCoordinate;

uniform sampler2D imageTexture;

void main()
{
    gl_FragColor = texture2D(imageTexture, textureCoordinate);
}