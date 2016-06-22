/*
 File: color.vsh
 Abstract: A vertex shader that draws points with assigned color.
 Version: 1.13
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
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
    
    float altitude;
    altitude = float(pencilAltitude < Altitude_Limit) * (pencilAltitude/Altitude_Limit * M_PI_2 - M_PI_2) + M_PI_2;
    
    //if (pencilAltitude > Altitude_Limit)
    //    altitude = M_PI_2;
    //else
    //    altitude = pencilAltitude/Altitude_Limit * M_PI_2;
    
    float tiltValue = easein(0.0,1.0,-(altitude-M_PI_2));
    vec2 tiltVec = tiltValue*pencilAzimuth*5.0;
    
    //
	gl_Position = MVP * vertexPosition;
    gl_PointSize = brushSize * 2.0 * (1.0+tiltValue)*(1.0+float(tiltValue < Altitude_Limit) * easeout(0.2,1.0,pencilForce));
    //angle = floor(randNum3*4.0)/4.0 * M_PI;
    //angle = 0.0;
    //angle = randNum*M_PI;
    
    //speed fade may be remove
    
    color = brushColor*easeout(0.2,1.0,pencilForce);//*(0.5-centerx*centerx+centery*centery);;//speedfade;
    
}

