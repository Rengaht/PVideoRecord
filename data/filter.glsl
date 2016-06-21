uniform sampler2D destSampler;
uniform sampler2D srcSampler;

varying vec4 vertTexCoord;

void main() {
  vec2 st = vertTexCoord.st;   
  
  
  vec3 destColor = texture2D(destSampler, vec2(st.x,1.0-st.y)).rgb;
  vec4 srcColor = texture2D(srcSampler,st);
  
 /* float luminance = dot(vec3(0.2126, 0.7152, 0.0722), destColor);

  if (luminance < 0.5) {
    gl_FragColor = vec4(2.0 * destColor * srcColor, 1.0);
  } else {
    gl_FragColor = vec4(1.0 - 2.0 * (1.0 - destColor) * (1.0 - srcColor), 1);
  }
  */
  gl_FragColor=vec4(destColor+srcColor.rgb,srcColor.a);
}