varying highp vec2 textureCoordinate;

uniform sampler2D imageTexture;
uniform lowp float alpha;
void main()
{
    lowp vec4 color = vec4(alpha,alpha,alpha,alpha);
    gl_FragColor = color * texture2D(imageTexture, textureCoordinate);
}