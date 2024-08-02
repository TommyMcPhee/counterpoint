#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup() {
    color1 = fillVector(color1);
    color2 = fillVector(color2);
    color3 = fillVector(color3);
    color4 = fillVector(color4);

    shader_Feedback.load("shadersGL2/shader_feedback");

    ofSetVerticalSync(true);
    frameBuffer0.allocate(ofGetWidth(), ofGetHeight());
    frameBuffer1.allocate(ofGetWidth(), ofGetHeight());

    sender.setup(sender.getHost(), SENDPORT);
    receiver.setup(RECEIVERPORT);
}

//--------------------------------------------------------------
void ofApp::update() {
    while (receiver.hasWaitingMessages()) {
        ofxOscMessage m;
        receiver.getNextMessage(&m);
        if (m.getAddress() == "/sampleRate") {
            ofBackground(0);
            frameBuffer0.begin();
            ofClear(0, 0, 0, 255);
            frameBuffer0.end();
            frameBuffer1.begin();
            ofClear(0, 0, 0, 255);
            frameBuffer1.end();
            sampleRate = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/section") {
            section = m.getArgAsInt(0);
        }
        if (m.getAddress() == "/0interval") {
            interval0 = m.getArgAsFloat(0);
            updatePower1();
            updateDeltaV1();
        }
        if (m.getAddress() == "/1interval") {
            interval1 = m.getArgAsFloat(0);
            updatePower3();
            updateDeltaV3();
        }
        if (m.getAddress() == "/2interval") {
            interval2 = m.getArgAsFloat(0);
            updatePower4();
            updateDeltaV4();
        }
        if (m.getAddress() == "/3interval") {
            interval3 = m.getArgAsFloat(0);
            updatePower2();
            updateDeltaV2();
        }
        if (m.getAddress() == "/4interval") {
            interval4 = m.getArgAsFloat(0);
            updatePower1();
            updateDeltaV1();
        }
        if (m.getAddress() == "/5interval") {
            interval5 = m.getArgAsFloat(0);
            updatePower2();
            updateDeltaV2();
        }
        if (m.getAddress() == "/6interval") {
            interval6 = m.getArgAsFloat(0);
            updatePower3();
            updateDeltaV3();
        }
        if (m.getAddress() == "/7interval") {
            interval7 = m.getArgAsFloat(0);
            updatePower4();
            updateDeltaV4();
        }
        if (m.getAddress() == "/0rhythm") {
            rhythm0 = m.getArgAsFloat(0);
            updateDeltaT1();
        }
        if (m.getAddress() == "/1rhythm") {
            rhythm1 = m.getArgAsFloat(0);
            updateDeltaT3();
        }
        if (m.getAddress() == "/2rhythm") {
            rhythm2 = m.getArgAsFloat(0);
            updateDeltaT2();
        }
        if (m.getAddress() == "/3rhythm") {
            rhythm3 = m.getArgAsFloat(0);
            updateDeltaT4();
        }
        if (m.getAddress() == "/4rhythm") {
            rhythm4 = m.getArgAsFloat(0);
            updateDeltaT1();
        }
        if (m.getAddress() == "/5rhythm") {
            rhythm5 = m.getArgAsFloat(0);
            updateDeltaT2();
        }
        if (m.getAddress() == "/6rhythm") {
            rhythm6 = m.getArgAsFloat(0);
            updateDeltaT3();
        }
        if (m.getAddress() == "/7rhythm") {
            rhythm7 = m.getArgAsFloat(0);
            updateDeltaT4();
        }
        if (m.getAddress() == "/0changeV") {
            changeV0 = m.getArgAsFloat(0);
            updateDeltaV1();
        }
        if (m.getAddress() == "/1changeV") {
            changeV1 = m.getArgAsFloat(0);
            updateDeltaV3();
        }
        if (m.getAddress() == "/2changeV") {
            changeV2 = m.getArgAsFloat(0);
            updateDeltaV4();
        }
        if (m.getAddress() == "/3changeV") {
            changeV3 = m.getArgAsFloat(0);
            updateDeltaV2();
        }
        if (m.getAddress() == "/4changeV") {
            changeV4 = m.getArgAsFloat(0);
            updateDeltaV1();
        }
        if (m.getAddress() == "/5changeV") {
            changeV5 = m.getArgAsFloat(0);
            updateDeltaV2();
        }
        if (m.getAddress() == "/6changeV") {
            changeV6 = m.getArgAsFloat(0);
            updateDeltaV3();
        }
        if (m.getAddress() == "/7changeV") {
            changeV7 = m.getArgAsFloat(0);
            updateDeltaV4();
        }
        if (m.getAddress() == "/0changeT") {
            changeT0 = m.getArgAsFloat(0);
            updateDeltaT1();
        }
        if (m.getAddress() == "/1changeT") {
            changeT1 = m.getArgAsFloat(0);
            updateDeltaT3();
        }
        if (m.getAddress() == "/2changeT") {
            changeT2 = m.getArgAsFloat(0);
            updateDeltaT4();
        }
        if (m.getAddress() == "/3changeT") {
            changeT3 = m.getArgAsFloat(0);
            updateDeltaT2();
        }
        if (m.getAddress() == "/4changeT") {
            changeT4 = m.getArgAsFloat(0);
            updateDeltaT1();
        }
        if (m.getAddress() == "/5changeT") {
            changeT5 = m.getArgAsFloat(0);
            updateDeltaT2();
        }
        if (m.getAddress() == "/6changeT") {
            changeT6 = m.getArgAsFloat(0);
            updateDeltaT3();
        }
        if (m.getAddress() == "/7changeT") {
            changeT7 = m.getArgAsFloat(0);
            updateDeltaT4();
        }
        if (m.getAddress() == "/0value") {
            value0 = m.getArgAsFloat(0);
            value0 = scaleValue(value0);
        }
        if (m.getAddress() == "/1value") {
            value1 = m.getArgAsFloat(0);
            value1 = scaleValue(value1);
        }
        if (m.getAddress() == "/2value") {
            value2 = m.getArgAsFloat(0);
            value2 = scaleValue(value2);
        }
        if (m.getAddress() == "/3value") {
            value3 = m.getArgAsFloat(0);
            value3 = scaleValue(value3);
        }
        if (m.getAddress() == "/4value") {
            value4 = m.getArgAsFloat(0);
            value4 = scaleValue(value4);
        }
        if (m.getAddress() == "/5value") {
            value5 = m.getArgAsFloat(0);
            value5 = scaleValue(value5);
        }
        if (m.getAddress() == "/6value") {
            value6 = m.getArgAsFloat(0);
            value6 = scaleValue(value6);
        }
        if (m.getAddress() == "/7value") {
            value7 = m.getArgAsFloat(0);
            value7 = scaleValue(value7);
        }
        if (m.getAddress() == "/8value") {
            value8 = m.getArgAsFloat(0);
            value8 = scaleValue(value8);
        }
        if (m.getAddress() == "/9value") {
            value9 = m.getArgAsFloat(0);
            value9 = scaleValue(value9);
        }
        if (m.getAddress() == "/0time") {
            time0 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/1time") {
            time1 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/2time") {
            time2 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/3time") {
            time3 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/4time") {
            time4 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/5time") {
            time5 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/6time") {
            time6 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/7time") {
            time7 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/8time") {
            time8 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/9time") {
            time9 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/0tone") {
            tone0 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/1tone") {
            tone1 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/2tone") {
            tone2 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/3tone") {
            tone3 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/4tone") {
            tone4 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/5tone") {
            tone5 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/6tone") {
            tone6 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/7tone") {
            tone7 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/8tone") {
            tone8 = m.getArgAsFloat(0);
        }
        if (m.getAddress() == "/9tone") {
            tone9 = m.getArgAsFloat(0);
        }
    }

    n.clear();
    n.setAddress("/frameRate");
    n.addFloatArg(ofGetLastFrameTime());
    sender.sendMessage(n);

    x1 += getIncrement(x1, value4, time4);
    y1 += getIncrement(y1, value0, time0);
    x2 += getIncrement(x2, 1 - value5, time5);
    y2 += getIncrement(y2, value3, time3);
    x3 += getIncrement(x3, value1, time1);
    y3 += getIncrement(y3, 1 - value6, time6);
    x4 += getIncrement(x4, 1 - value2, time2);
    y4 += getIncrement(y4, 1 - value7, time7);
    translateX += getIncrement(translateX, value9, time9);
    translateY += getIncrement(translateY, value9, time8);
    mod1Value += getIncrement(mod1Value, value8, time8);
    mod6Value += getIncrement(mod6Value, value9, time9);
    updateConvolution();
}

//--------------------------------------------------------------
void ofApp::draw() {
    frameBuffer0.begin();
    shader_Feedback.begin();
    frameBuffer1.draw(0, 0);
    shader_Feedback.setUniform1f("mixxx", convolution);
    ofVec2f feedback_Displace;
    feedback_Displace.set(translateX * ofGetWidth(), translateY * ofGetHeight());
    shader_Feedback.setUniform2f("feedback_Displace", feedback_Displace);
    shader_Feedback.end();

    updateCircle(size1, color1, x1, y1, tone0, tone4, power1, deltaV1, deltaT1);
    updateCircle(size2, color2, x2, y2, tone3, tone5, power2, deltaV2, deltaT2);
    updateCircle(size3, color3, x3, y3, tone1, tone6, power3, deltaV3, deltaT3);
    updateCircle(size4, color4, x4, y4, tone2, tone7, power4, deltaV4, deltaT4);

    frameBuffer0.end();
    frameBuffer0.draw(0, 0);
    frameBuffer1.begin();
    frameBuffer0.draw(0, 0);
    frameBuffer1.end();
}

//--------------------------------------------------------------

float ofApp::getIncrement(float current, float value, float time) {
    return (value - current) * ofGetLastFrameTime() / time;
}

float ofApp::averageTwo(float a, float b) {
    return (a + b) / 2;
}

float ofApp::scaleValue(float value) {
    value /= (sampleRate / 2);
    value = glm::pow(value, 0.25);
    return value;
}

float ofApp::getDelta(float changeA, float changeB, float classA, float classB) {
    float numerator = averageTwo(changeA, changeB);
    float denominator = averageTwo(classA, classB);
    if (numerator < denominator) {
        return numerator / denominator;
    }
    else {
        return denominator / numerator;
    }
}

float ofApp::getSize(float size, float deltaV, float toneA, float power) {
    float small;
    if (ofGetHeight() <= ofGetWidth()) {
        small = (float)ofGetHeight();
    }
    else {
        small = (float)ofGetWidth();
    }
    float newSize = small * glm::pow(toneA, power);
    size = (size * (1 - deltaV)) + (newSize * deltaV);
    return size;
}

vector<float> ofApp::fillVector(vector<float> color) {
    for (int i = 0; i < 3; i++) {
        color.push_back(0);
    }
    return color;
}

vector<float> ofApp::getColor(vector<float> color, float toneA, float toneB, float deltaT, float power) {
    float newColor[3] = { 0, 0, 0 };
    newColor[section] = 1 - glm::pow(toneA, 2);
    if (toneB < 0.75) {
        newColor[(section + 1) % 3] = 1 - glm::pow(toneB, 2);
    }
    else {
        newColor[(section + 2) % 3] = glm::pow(toneB, 2);
    }
    for (int i = 0; i < 3; i++) {
        float old = color.at(i) / 256;
        color.at(i) = 256 * glm::pow(((old + (newColor[i] * deltaT)) / (1 + deltaT)), glm::pow((1 / power), glm::pow((1 - deltaT), 0.75)));
    }
    return color;
}

void ofApp::updateCircle(float size, vector<float> color, float x, float y, float toneA, float toneB, float power, float deltaV, float deltaT) {
    size = getSize(size, deltaV, toneA, power);
    color = getColor(color, toneA, toneB, deltaT, power);
    ofSetColor((int)color.at(0), (int)color.at(1), (int)color.at(2));
    ofFill();
    ofDrawCircle((((float)ofGetWidth() - size) * x) + (size / 2), (((float)ofGetHeight() - size) * y) + (size / 2), size / (10 - power));
}

void ofApp::updatePower1() {
    power1 = 10 - averageTwo(interval0, interval4);
}

void ofApp::updatePower2() {
    power2 = 10 - averageTwo(interval3, interval5);
}

void ofApp::updatePower3() {
    power3 = 10 - averageTwo(interval1, interval6);
}

void ofApp::updatePower4() {
    power4 = 10 - averageTwo(interval2, interval7);
}

void ofApp::updateDeltaV1() {
    deltaV1 = getDelta(changeV0, changeV4, interval0, interval4);
}

void ofApp::updateDeltaV2() {
    deltaV2 = getDelta(changeV3, changeV5, interval3, interval5);
}

void ofApp::updateDeltaV3() {
    deltaV3 = getDelta(changeV1, changeV6, interval1, interval6);
}

void ofApp::updateDeltaV4() {
    deltaV4 = getDelta(changeV2, changeV7, interval2, interval7);
}

void ofApp::updateDeltaT1() {
    deltaT1 = getDelta(changeT0, changeT4, rhythm0, rhythm4);
}

void ofApp::updateDeltaT2() {
    deltaT2 = getDelta(changeT3, changeT5, rhythm3, rhythm5);
}

void ofApp::updateDeltaT3() {
    deltaT3 = getDelta(changeT1, changeT6, rhythm1, rhythm6);
}

void ofApp::updateDeltaT4() {
    deltaT4 = getDelta(changeT2, changeT7, rhythm2, rhythm7);
}

void ofApp::updateConvolution() {
    convolution = glm::pow(mod1Value * mod6Value, glm::pow(2 - section, 2) + 1);
}