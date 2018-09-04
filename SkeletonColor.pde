/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/

Code modified by Tousar Mohammed to find waist size and height


 KinectPV2, Kinect for Windows v2 library for processing

 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
boolean handclose= false;
float totalheight=0;
float waist_size;
float up=0;
float bottom =0;


int top_head;

void setup() {
  size(1920, 1080, P3D);
//fullScreen();
  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);



  ////////////////////////////////////////////

////////////////////////////////////////////

  kinect.init();
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);


  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++)
  {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked())
    {
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);

      if(handclose == true)
  {
    println("===================",handclose);
    //save height here

    //String s = Float.toString(totalheight);
String[] lines = new String[2];
   lines[0] =  Float.toString(totalheight);
   lines[1] = Float.toString(waist_size);

    //
  saveStrings("TotalHeight.txt", lines);
  exit(); // Stop the program
 break;

  }

    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);

    //Get the distance by finding the difference on the y cordinate and subtract point to point for the most accurate measurement
    calculate_height(joints, KinectPV2.JointType_Head, KinectPV2.JointType_SpineBase); ///
    calculate_height(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_AnkleRight);//
    calculate_waist_size(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight,KinectPV2.JointType_HipLeft);


  //saves the totalheight on a txt if it detects either hand closed and closes the application

}

//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {

  //Draw head in 3d
  /*
  if(jointType1 == KinectPV2.JointType_Head || jointType2 == KinectPV2.JointType_Head  ){
   strokeWeight(2.0f + joints[jointType1].getZ()*8);
  point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  println("Head Z: ",joints[jointType2].getZ());
}

*/
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState)
{
  switch(handState)
  {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    handclose = false;
    break;
  case KinectPV2.HandState_Closed:
    handclose = true;
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    handclose = false;
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    handclose = false;
    break;
  }
}


//finds the height by getting pixels cordinate from "head" of skeleton and compare color to pixels above to get more accurate height
void calculate_height(KJoint[] joints, int jointType1, int jointType2)
{
if(jointType1==KinectPV2.JointType_Head)
{
  println();println();println();println();println();
  println("               skelton head ==== ",(joints[jointType1].getY()));
  println("               window height",height);
float a =joints[jointType1].getY();
color H = get((int)(joints[jointType1].getX()),(int)(joints[jointType1].getY()));
for(int i=(int)a; i<height;i++)
{
 // pixels[i]=color(255,102,204);
 color Y = get((int)(joints[jointType1].getX()),i);
  if(H-Y>=Math.abs(2000))
  {
    println("               top of head ------",i);
  top_head = i;
  break;
  }

}

}

  if(jointType1==KinectPV2.JointType_HipRight && jointType2==KinectPV2.JointType_AnkleRight)
 {
bottom = joints[jointType2].getY()-joints[jointType1].getY();

 }

  if(jointType1==KinectPV2.JointType_Head && jointType2==KinectPV2.JointType_SpineBase)
 {
up = joints[jointType2].getY()-top_head;
 }

 //8.17 is only a constant that converts pixel value to inches and needs to be changed depending on angle and distance of the camera 
 totalheight = ((up+bottom)/8.17);
  println("               Height = " ,totalheight);
}

//finds the waist size by getting pixels cordinate from left and right hip of skeleton and compare color to pixels left and right to get more accurate waist size
void calculate_waist_size(KJoint[] joints, int jointType1, int jointType2,int jointType3){

println("               spine base",joints[jointType1].getY());
//right hip cordinate of skeleton
int right = (int)joints[jointType2].getX();
//left hip cordinate of skeleton
int left = (int)joints[jointType3].getX();
//skeleton right hip color
color R = get((int)(joints[jointType2].getX()),(int)(joints[jointType2].getY()));
//skeleton left hip color
color L = get((int)(joints[jointType3].getX()),(int)(joints[jointType3].getY()));
println("               right ",right);println("               left",left);
int one=0;int two=0;

for(int i=right; i<width;i++)
{
 // pixels[i]=color(255,102,204);
 color r = get(i,(int)(joints[jointType2].getY()));
 //println("             here-----------right hip----------------------------- ",i);
  if(R-r>=Math.abs(2000))
  {
   // println("skeleton right hip",(joints[jointType2].getX()));
   println("               right hip",i);
   println("               window width ",width);
   two = i;
  break;
  }
}


for(int j = left;j>0;j--)
{
   color l = get(j,(int)(joints[jointType3].getY()));
  if(L-l>=Math.abs(2000))
  {
   // println("skeleton left hip",(joints[jointType3].getX()));
   println("               left hip",j);
   one = j;
  break;

}

}
//13.4 is only a constant that needs to be changed depending on angle and distance of the camera

float temp = ((two-one) /13.4);
waist_size=2*3.14*temp;

println("                 waist size:",waist_size);

}
