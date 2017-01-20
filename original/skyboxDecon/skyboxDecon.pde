PShape sky1; 
PShape sky2; 
PShape sky3; 

float yoff = 0; 

PVector[] sky1v;
PVector[] sky3v;
PVector[] sky2v;

boolean reset = false; 

PImage displacementMap;
PImage colorMap;
PShader displace;

float rotX;
float rotY;
float rotZ;

void setup() {
  size(displayWidth, displayHeight, P3D);
  sky1 = createIcosahedronWithTex(6, "sky1.jpg");
  sky2 = createIcosahedronWithTex(3, "sky1.jpg");
  sky3 = createIcosahedronWithTex(5, "sky1.jpg");
  sky1v = getOrigVertArray(sky1); 
  sky3v = getOrigVertArray(sky3); 
  sky2v = getOrigVertArray(sky2); 

  rotX = random(360); 
  rotY = random(360); 
  rotZ = random(360); 

  frameRate(30);

  displacementMap = loadImage("sky1.jpg");
  colorMap = displacementMap; 
  displace = loadShader("displaceFrag.glsl", "displaceVertNew.glsl"); 
  displace.set("displaceStrength", -0.3);
  //displace.set("colorMap", colorMap);
  displace.set("displacementMap", displacementMap); 
  displace.set("noiseStrength", 5.0); 
  displace.set("noiseResolution", 10.0);
} 

void draw() {
  //saveFrame();
  //resetShader();
  float noiseStr = map(mouseX, 0, width, 0.0, 50.0); 
//  float noiseRes = map(mouseX, 0, width, 1.0, 20.0); 
  displace.set("noiseStrength", noiseStr); 
//  displace.set("noiseResolution", noiseRes); 
  float disp = map(mouseX, 0, width, 0, -0.3); 
  displace.set("displaceStrength", disp);
  displace.set("time", millis()/5000.0); // feed time to the GLSL shader
  shader(displace); 
  ambientLight(152+(sin(frameCount * 0.0051) * 152), 152+(sin(frameCount * 0.0051) * 152), 152+(sin(frameCount * 0.0051) * 152)); 
  directionalLight(100, 50, 50, sin(frameCount*0.00051) * 2, cos(frameCount*0.00053) + sin(frameCount*.0051)* 2, sin(frameCount*0.01) * 2);
  directionalLight(130, 100, 50, cos(frameCount*0.0013) + sin(frameCount*.011)* 2, sin(frameCount*0.0011) * 2, sin(frameCount*0.01) * 2);
  directionalLight(40, 40, 70, sin(frameCount*0.001) * 2, sin(frameCount*0.005) * 2, cos(frameCount*0.003) + sin(frameCount*.01)* 2);
  pushMatrix(); 
  perspective(PI/3.5, (float) width/height, 0.1, 1000000); // perspective for close shapes
  translate(width/2, height/2); // translate to center of the screen


  //scale(200 + mouseX); 
  //scale(width/2+700 - frameCount*0.1); 
  scale(1200); 
  rotateX(radians(frameCount*0.005)); 
  rotateY(radians(frameCount*0.008)); 
  rotateZ(radians(frameCount*0.003)); 
  shape(sky1);
  popMatrix(); 

  pushMatrix(); 
  translate(width/2, height/2); 
  scale(1300); 
  rotateX(radians(rotX+frameCount*0.005)); 
  rotateY(radians(rotY+frameCount*0.008)); 
  rotateZ(radians(rotZ+frameCount*0.003)); 
  
  shape(sky2); 
  popMatrix(); 

  pushMatrix(); 
  translate(width/2, height/2); 
  scale(1400); 
  rotateX(radians(rotY+frameCount*0.001)); 
  rotateY(radians(rotY+frameCount*0.003)); 
  rotateZ(radians(rotX+frameCount*0.008)); 
  
  shape(sky3); 
  popMatrix(); 


  //asplode(sky1);
  //flatsplode(sky1); 
  //pulsesplode(sky1);

  if (reset == true) {
    asplode(sky1);
    //flatsplode(sky3);
    //pulsesplode(sky2); 
    //pulsesplode(sky1);
  } else {
    moveToResetVerts(sky1, sky1v);
    moveToResetVerts(sky3, sky3v); 
    moveToResetVerts(sky2, sky2v); 
    // flatsplode(sky1); 
    //asplode(sky1);
  } 
  
  if (frameCount > 2000) {
    
  } 

  if (mouseY > height/2) {
    reset = true;
  } else {
    reset = false;
  }
}


void pulsesplode(PShape ico) {
  float xoff = 0; 
  for (int i = 0; i < ico.getVertexCount (); i++) {
    PVector v = ico.getVertex(i);
    PVector n = ico.getNormal(i); 
    //PVector pos = original.get(i);
    float a = noise(xoff, yoff, frameCount * 0.001); 
    a = a -.5; 
    //if (a < 0) {println("negative"); }
    n.mult(a * 0.01); 
    v.add(n); 
    ico.setVertex(i, v); 
    xoff+= 0.1;
  } 
  yoff += 0.01;
} 

void flatsplode(PShape ico) {
  float xoff = 0; 
  for (int i = 0; i < ico.getVertexCount (); i++) {
    PVector v = ico.getVertex(i);
    PVector n = ico.getNormal(i); 
    //   PVector pos = original.get(i);
    float a = noise(xoff, yoff) * 0.001; 
    n.mult(a); 
    v.add(n); 
    ico.setVertex(i, v); 
    xoff+= 0.01;
  } 
  yoff += 0.01;
} 


void asplode(PShape ico) {
  for (int i = 0; i < ico.getVertexCount (); i++) {
    float xoff = 0; 
    // if ( i % frameCount == 0 ) {
    //    PVector v = asploder.getVertex(i); 
    //    PVector n = asploder.getNormal(i); 
    //    float x = asploder.getVertexX(i); 
    //    float y = asploder.getVertexY(i); 
    //    
    //    n.mult(mouseX*0.00000001); 
    //    v.add(n); 
    //    asploder.setVertex(i,v); 
    PVector v = ico.getVertex(i);
    PVector n = ico.getNormal(i); 
    float noiseMag = noise(i, ico.getVertexY(i), mouseX) * 0.01; 
    //float noiseMag = noise(xoff, yoff); 
    //    v.x += random(-.01, .01);
    //    v.y += random(-.01, .01);
    n.mult(noiseMag);
    v.add(n); 
    ico.setVertex(i, v);
    xoff+=0.01;
    //  }
  }
  yoff+=0.01;
} 


void resetVerts(PShape ico, PVector[] orig) {
  for (int i = 0; i < ico.getVertexCount (); i++) {
    PVector v = ico.getVertex(i);
    if (v != orig[i]) {
      v = orig[i];
    }
    ico.setVertex(i, v);
  }
}

void moveToResetVerts(PShape ico, PVector[] orig) {
  for (int i = 0; i < ico.getVertexCount (); i++) {
    PVector v = ico.getVertex(i);
    if (v.dist(orig[i]) > .001) {
      PVector dir = PVector.sub(orig[i], v); 
      dir.normalize(); 
      dir.mult(0.001); 
      PVector move = v;
      move.add(dir); 
      ico.setVertex(i, move);
    } else {
      v = orig[i];
      ico.setVertex(i, v);
    }
  }
}

void collapseVerts(PShape ico, PVector[] orig) {
  for (int i = 0; i < ico.getVertexCount (); i++) {
    PVector v = ico.getVertex(i);
    if (v != orig[i]) {    //nice shrink to nothing effect
      PVector dir = PVector.sub(orig[i], v); 
      dir.sub(orig[i]);
      dir.normalize(); 
      dir.mult(0.001); 
      PVector move = v;
      move.add(dir); 
      ico.setVertex(i, move);
    } else {
      v = orig[i];
      ico.setVertex(i, v);
    }
  }
}