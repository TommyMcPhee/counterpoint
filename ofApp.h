#pragma once

#include "ofMain.h"
#include "ofxOsc.h"

#define SENDPORT 57120
#define RECEIVERPORT 2

class ofApp : public ofBaseApp {

public:
    void setup();
    void update();
    void draw();

    ofxOscSender sender;
    ofxOscMessage n;
    ofxOscReceiver    receiver;
    ofShader shader_Feedback;
    ofFbo frameBuffer0;
    ofFbo frameBuffer1;
    vector<float> color1;
    vector<float> color2;
    vector<float> color3;
    vector<float> color4;
    float power1 = 9;
    float power2 = 9;
    float power3 = 9;
    float power4 = 9;
    float size1 = 1;
    float size2 = 1;
    float size3 = 1;
    float size4 = 1;
    float x1 = 0.5;
    float y1 = 0.5;
    float x2 = 0.5;
    float y2 = 0.5;
    float x3 = 0.5;
    float y3 = 0.5;
    float x4 = 0.5;
    float y4 = 0.5;
    float translateX = 0;
    float translateY = 0;
    float mod1Value = 1;
    float mod6Value = 1;
    float convolution = 0.5;
    float deltaV1 = 1;
    float deltaT1 = 1;
    float deltaV2 = 1;
    float deltaT2 = 1;
    float deltaV3 = 1;
    float deltaT3 = 1;
    float deltaT4 = 1;
    float deltaV4 = 1;

    float sampleRate = 48000;
    int section = 0;
    float interval0 = 9;
    float interval1 = 9;
    float interval2 = 9;
    float interval3 = 9;
    float interval4 = 9;
    float interval5 = 9;
    float interval6 = 9;
    float interval7 = 9;
    float rhythm0 = 9;
    float rhythm1 = 9;
    float rhythm2 = 9;
    float rhythm3 = 9;
    float rhythm4 = 9;
    float rhythm5 = 9;
    float rhythm6 = 9;
    float rhythm7 = 9;
    float changeV0 = 1;
    float changeV1 = 1;
    float changeV2 = 1;
    float changeV3 = 1;
    float changeV4 = 1;
    float changeV5 = 1;
    float changeV6 = 1;
    float changeV7 = 1;
    float changeT0 = 1;
    float changeT1 = 1;
    float changeT2 = 1;
    float changeT3 = 1;
    float changeT4 = 1;
    float changeT5 = 1;
    float changeT6 = 1;
    float changeT7 = 1;
    float value0 = 1;
    float value1 = 1;
    float value2 = 1;
    float value3 = 1;
    float value4 = 1;
    float value5 = 1;
    float value6 = 1;
    float value7 = 1;
    float value8 = 1;
    float value9 = 1;
    float time0 = 1;
    float time1 = 1;
    float time2 = 1;
    float time3 = 1;
    float time4 = 1;
    float time5 = 1;
    float time6 = 1;
    float time7 = 1;
    float time8 = 1;
    float time9 = 1;
    float tone0 = 0.5;
    float tone1 = 0.5;
    float tone2 = 0.5;
    float tone3 = 0.5;
    float tone4 = 0.5;
    float tone5 = 0.5;
    float tone6 = 0.5;
    float tone7 = 0.5;
    float tone8 = 0.5;
    float tone9 = 0.5;

    float getIncrement(float current, float value, float time);
    float averageTwo(float a, float b);
    float scaleValue(float value);
    float getDelta(float changeA, float changeB, float classA, float classB);
    float getSize(float size, float deltaV, float toneA, float power);
    vector<float> getColor(vector<float> color, float toneA, float toneB, float deltaT, float power);
    vector<float> fillVector(vector<float> color);
    void updateCircle(float size, vector<float> color, float x, float y, float toneA, float toneB, float power, float deltaV, float deltaT);
    void updatePower1();
    void updatePower2();
    void updatePower3();
    void updatePower4();
    void updateDeltaV1();
    void updateDeltaV2();
    void updateDeltaV3();
    void updateDeltaV4();
    void updateDeltaT1();
    void updateDeltaT2();
    void updateDeltaT3();
    void updateDeltaT4();
    void updateConvolution();
};