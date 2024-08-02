(
~channels = 2;
s.options.numOutputBusChannels = ~channels;
s.options.numWireBufs = 512;
s.options.blockSize = 64;
s.recChannels;
s.boot;
s.doWhenBooted({
(
~globals = Dictionary.newFrom([
	\frameRate, 60,
	\freq1, 256,
	\freq2, 256,
	\freq3, 256,
	\freq4, 256,
	\mFreq2, 256,
	\mFreq3, 256,
	\mFreq4, 256,
	\mFreq5, 256,
	\synthReference, [0, \freq1, \freq4, 0, \freq1, \freq4, \mFreq2, \mFreq3],
	\synthValue, [\freq1, \freq2, \freq3, \freq4, \mFreq2, \mFreq3, \mFreq4, \mFreq5],
	\synthTime, [\car1T, \car2T, \car3T, \car4T, \mod2T, \mod3T, \mod4T, \mod5T],
	\synthInterval, [\freq1Change, \freq2Change, \freq3Change, \freq4Change, \mod2Change, \mod3Change, \mod4Change, \mod5Change],
	\synthRhythm, [\car1TChange, \car2TChange, \car3TChange, \car4TChange, \mod2TChange, \mod3TChange, \mod4TChange, \mod5TChange],
	\side, [0, 0, 1, 1, 0, 1, 0, 1],
	\form, [1, 0, 2, 0, 2, 0, 1],
	\row1, Array.series(8),
	\row2, Array.series(12),
	\row0, [[0, 1, 2, 3], [1, 2, 3, 0], [2, 3, 0, 1], [3, 0, 1, 2], [0, 1, 3, 2], [1, 3, 2, 0], [3, 2, 0, 1], [2, 0, 1, 3], [0, 2, 1, 3], [2, 1, 3, 0], [1, 3, 0, 2], [3, 0, 2, 1], [0, 2, 3, 1], [2, 3, 1, 0], [3, 1, 0, 2], [1, 0, 2, 3], [0, 3, 1, 2], [3, 1, 2, 0], [1, 2, 0, 3], [2, 0, 3, 1], [0, 3, 2, 1], [3, 2, 1, 0], [2, 1, 0, 3], [1, 0, 3, 2]].scramble,
	\intervalClass, [[0, 1, 3].scramble, [2, 5].scramble, [4, 6].scramble],
	\intervals, [[1/3, 2/3, 3/2, 3], [1/4, 3/4, 4/3, 4], [1/5, 2/5, 3/5, 4/5, 5/4, 5/3, 5/2, 5], [1/6, 5/6, 6/5, 6], [1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 7/6, 7/5, 7/4, 7/3, 7/2, 7], [1/8, 3/8, 5/8, 7/8, 8/7, 8/5, 8/3, 8], [1/9, 2/9, 4/9, 5/9, 7/9, 8/9, 9/8, 9/7, 9/5, 9/4, 9/2, 9]],
	\rowForm, Array.series(8).scramble
]);

~globals.put(\row1i, (7 - ~globals[\row1]));
~globals.put(\row2i, (11 - ~globals[\row2]));

while({ ~globals[\row1] == ~globals[\row1i].reverse  },
	{ ~globals[\row1] = ~globals[\row1].scramble; }
);

while({ ~globals[\row2] == ~globals[\row2i].reverse },
	{ ~globals[\row2] = ~globals[\row2].scramble; }
);

~osc = Dictionary.newFrom([
	\net, NetAddr.new("localhost", 2),
	\sampleRate, '/sampleRate',
	\section, '/section',
	\intervalClass, ['/0interval', '/1interval', '/2interval', '/3interval', '/4interval', '/5interval', '/6interval', '/7interval'],
	\rhythmClass, ['/0rhythm', '/1rhythm', '/2rhythm', '/3rhythm', '/4rhythm', '/5rhythm', '/6rhythm', '/7rhythm'],
	\changeV, ['/0changeV', '/1changeV', '/2changeV', '/3changeV', '/4changeV', '/5changeV', '/6changeV', '/7changeV'],
	\changeT, ['/0changeT', '/1changeT', '/2changeT', '/3changeT', '/4changeT', '/5changeT', '/6changeT', '/7changeT'],
	\value, ['/0value', '/1value', '/2value', '/3value', '/4value', '/5value', '/6value', '/7value'],
	\time, ['/0time', '/1time', '/2time', '/3time', '/4time', '/5time', '/6time', '/7time'],
	\synth, ['/0tone', '/1tone', '/2tone', '/3tone', '/4tone', '/5tone', '/6tone', '/7tone', '/8tone', '/9tone', '/8value', '/9value', '/8time', '/9time'],
	\reply, ['/0reply', '/1reply', '/2reply', '/3reply', '/4reply', '/5reply', '/6reply', '/7reply', '/8reply', '/9reply', '/10reply', '/11reply', '/12reply', '/13reply'],
	\defName, ["0tone", "1tone", "2tone", "3tone", "4tone", "5tone", "6tone", "7tone", "8tone", "9tone", "8value", "9value", "8time", "9time"]
]);

	(
SynthDef("FM10", {
	arg frameRate, freq1, freq2, freq3, freq4, mFreq2, mFreq3, mFreq4, mFreq5, car1T = 1, car2T = 1, car3T = 1, car4T = 1, mod2T = 1, mod3T = 1, mod4T = 1, mod5T = 1, freq1Change = 1, freq2Change = 1, freq3Change = 1, freq4Change = 1, mFreq2Change = 1, mFreq3Change = 1, mFreq4Change = 1, mFreq5Change = 1, car1TChange = 1, car2TChange = 1, car3TChange = 1, car4TChange = 1, mod2TChange = 1, mod3TChange = 1, mod4TChange = 1, mod5TChange = 1, vol = 0.125;

	var trigger, primeT, subT, modT, mod1T, mod6T, primeChange, subChange, modChange, mFreq1Change, mFreq6Change, primeTChange, subTChange, modTChange, mod1TChange, mod6TChange, nyquist, car1, car2, car3, car4, mod1, mod2, mod3, mod4, mod5, mod6, mix, mFreq1, mFreq6, carTone1, carTone2, carTone3, carTone4, modTone1, modTone2, modTone3, modTone4, modTone5, modTone6, carVol1, carVol2, carVol3, carVol4, modVol1, modVol2, modVol3, modVol4, modVol5, modVol6, index1, index2, index3, index4, index5, index6, index7, index8, index9, index10, carAmp1, carAmp2, carAmp3, carAmp4, modAmp1, modAmp2, modAmp3, modAmp4, modAmp5, modAmp6, index1T, index2T, index3T, index4T, index5T, index6T, index7T, index8T, index9T, index10T, indexSpec1, indexSpec2, indexSpec3, indexSpec4, indexSpec5, indexSpec6, indexSpec7, indexSpec8, indexSpec9, indexSpec10, car1P, car2P, car3P, car4P, mod1P, mod2P, mod3P, mod4P, mod5P, mod6P, car1L, car2L, car3L, car4L, mod2L, mod3L, mod4L, mod5L, car1V, car2V, car3V, car4V, mod2V, mod3V, mod4V, mod5V, lFreq1, lFreq2, lFreq3, lFreq4, lMFreq2, lMFreq3, lMFreq4, lMFreq5, lIndex1, lIndex2, lIndex3, lIndex4, lIndex5, lIndex6, lIndex7, lIndex8, lIndex9, lIndex10, lCarAmp1, lCarAmp2, lCarAmp3, lCarAmp4, lModAmp1, lModAmp2, lModAmp3, lModAmp4, lModAmp5, lModAmp6;

	trigger = Impulse.kr(frameRate);

	primeT = car1T + car4T;
	subT = car2T + car3T;
	modT = mod2T + mod3T + mod4T + mod5T.abs;
	mod1T = primeT + subT;
	mod6T = mod1T + modT;

	SendReply.kr(trigger, ~osc[\reply][12], mod1T);
	SendReply.kr(trigger, ~osc[\reply][13], mod6T);

	primeChange = freq1Change + freq4Change;
	subChange = freq2Change + freq3Change;
	modChange = mFreq2Change + mFreq3Change + mFreq4Change + mFreq5Change;
	mFreq1Change = primeChange + subChange;
	mFreq6Change = mFreq1Change + modChange;

	primeTChange = car1TChange + car4TChange;
	subTChange = car2TChange + car3TChange;
	modTChange = mod2TChange + mod3TChange + mod4TChange + mod5TChange;
	mod1TChange = primeTChange + subTChange;
	mod6TChange = mod1TChange + modTChange;

	carTone1 = LFNoise1.ar(car1T * 2/car1TChange, 0.5, 0.5).sqrt;
	carTone2 = LFNoise1.ar(car2T * 2/car2TChange, 0.5, 0.5).sqrt;
	carTone3 = LFNoise1.ar(car3T * 2/car3TChange, 0.5, 0.5).sqrt;
	carTone4 = LFNoise1.ar(car4T * 2/car4TChange, 0.5, 0.5).sqrt;
	modTone1 = LFNoise1.ar(mod1T * 2/mod1TChange, 0.5, 0.5).sqrt;
	modTone2 = LFNoise1.ar(mod2T * 2/mod2TChange, 0.5, 0.5).sqrt;
	modTone3 = LFNoise1.ar(mod3T * 2/mod3TChange, 0.5,  0.5).sqrt;
	modTone4 = LFNoise1.ar(mod4T * 2/mod4TChange, 0.5, 0.5).sqrt;
	modTone5 = LFNoise1.ar(mod5T * 2/mod5TChange, 0.5, 0.5).sqrt;
	modTone6 = LFNoise1.ar(mod6T * 2/mod6TChange, 0.5, 0.5).sqrt;

	SendReply.kr(trigger, ~osc[\reply][0], carTone1);
	SendReply.kr(trigger, ~osc[\reply][1], carTone2);
	SendReply.kr(trigger, ~osc[\reply][2], carTone3);
	SendReply.kr(trigger, ~osc[\reply][3], carTone4);
	SendReply.kr(trigger, ~osc[\reply][8], modTone1);
	SendReply.kr(trigger, ~osc[\reply][4], modTone2);
	SendReply.kr(trigger, ~osc[\reply][5], modTone3);
	SendReply.kr(trigger, ~osc[\reply][6], modTone4);
	SendReply.kr(trigger, ~osc[\reply][7], modTone5);
	SendReply.kr(trigger, ~osc[\reply][9], modTone6);

	carVol1 = {LFNoise1.ar(freq1Change/car1T, 1).sqrt}!~channels;
	carVol2 = {LFNoise1.ar(freq2Change/car2T, 1).sqrt}!~channels;
	carVol3 = {LFNoise1.ar(freq3Change/car3T, 1).sqrt}!~channels;
	carVol4 = {LFNoise1.ar(freq4Change/car4T, 1).sqrt}!~channels;
	modVol1 = {LFNoise1.ar(mFreq1Change/mod1T, 1).sqrt}!~channels;
	modVol2 = {LFNoise1.ar(mFreq2Change/mod2T, 1).sqrt}!~channels;
	modVol3 = {LFNoise1.ar(mFreq3Change/mod3T, 1).sqrt}!~channels;
	modVol4 = {LFNoise1.ar(mFreq4Change/mod4T, 1).sqrt}!~channels;
	modVol5 = {LFNoise1.ar(mFreq5Change/mod5T, 1).sqrt}!~channels;
	modVol6 = {LFNoise1.ar(mFreq6Change/mod6T, 1).sqrt}!~channels;

	carAmp1 = carVol1 * (1 - carTone1);
	carAmp2 = carVol2 * (1 - carTone2);
	carAmp3 = carVol3 * (1 - carTone3);
	carAmp4 = carVol4 * (1 - carTone4);
	modAmp1 = modVol1 * (1 - modTone1);
	modAmp2 = modVol2 * (1 - modTone2);
	modAmp3 = modVol3 * (1 - modTone3);
	modAmp4 = modVol4 * (1 - modTone4);
	modAmp5 = modVol5 * (1 - modTone5);
	modAmp6 = modVol6 * (1 - modTone6);

	nyquist = s.sampleRate/2;

	mFreq1 = (freq2 - freq3).abs;
	mFreq6 = (mFreq4 - mFreq5).abs;

	SendReply.kr(trigger, ~osc[\reply][10], mFreq1);
	SendReply.kr(trigger, ~osc[\reply][11], mFreq5);

	indexSpec1 = Wrap.ar(((1 - carVol1) * (1 - modVol2)).sqrt, (1 - carVol1) * (1 - modVol2), nyquist/freq1);
	indexSpec2 = Wrap.ar(((1 - carVol2) * (1 - modVol1)).sqrt, (1 - carVol2) * (1 - modVol1), nyquist/freq2);
	indexSpec3 = Wrap.ar(((1 - carVol3) * (1 - modVol1)).sqrt, (1 - carVol3) * (1 - modVol1), nyquist/freq3);
	indexSpec4 = Wrap.ar(((1 - carVol4) * (1 - modVol3)).sqrt, (1 - carVol4) * (1 - modVol3), nyquist/freq4);
	indexSpec5 = Wrap.ar(((1 - modVol1) * (1 - modVol4)).sqrt, (1 - modVol1) * (1 - modVol4), nyquist/mFreq1);
	indexSpec6 = Wrap.ar(((1 - modVol1) * (1 - modVol5)).sqrt, (1 - modVol1) * (1 - modVol5), nyquist/mFreq1);
	indexSpec7 = Wrap.ar(((1 - modVol2) * (1 - modVol4)).sqrt, (1 - modVol2) * (1 - modVol4), nyquist/mFreq2);
	indexSpec8 = Wrap.ar(((1 - modVol3) * (1 - modVol5)).sqrt, (1 - modVol3) * (1 - modVol5), nyquist/mFreq3);
	indexSpec9 = Wrap.ar(((1 - modVol4) * (1 - modVol6)).sqrt, (1 - modVol4) * (1 - modVol6), nyquist/mFreq4);
	indexSpec10 = Wrap.ar(((1 - modVol5) * (1 - modVol6)).sqrt, (1 - modVol5) * (1 - modVol6), nyquist/mFreq5);

	index1 = (carTone1 + modTone2) * indexSpec1/2;
	index2 = (carTone2 + modTone1) * indexSpec2/2;
	index3 = (carTone3 + modTone1) * indexSpec3/2;
	index4 = (carTone4 + modTone3) * indexSpec4/2;
	index5 = (modTone1 + modTone4) * indexSpec5/2;
	index6 = (modTone1 + modTone5) * indexSpec6/2;
	index7 = (modTone2 + modTone4) * indexSpec7/2;
	index8 = (modTone3 + modTone5) * indexSpec8/2;
	index9 = (modTone4 + modTone6) * indexSpec9/2;
	index10 = (modTone5 + modTone6) * indexSpec10/2;


	car1P = Wrap.kr(Phasor.kr(Changed.kr(freq1), 1/car1T), 0, 1);
	car2P = Wrap.kr(Phasor.kr(Changed.kr(freq2), 1/car2T), 0, 1);
	car3P = Wrap.kr(Phaser.kr(Changed.kr(freq3), 1/car3T), 0, 1);
	car4P = Wrap.kr(Phaser.kr(Changed.kr(freq4), 1/car4T), 0, 1);
	mod2P = Wrap.kr(Phaser.kr(Changed.kr(mFreq2), 1/mod2T), 0, 1);
	mod3P = Wrap.kr(Phaser.kr(Changed.kr(mFreq3), 1/mod3T), 0, 1);
	mod4P = Wrap.kr(Phaser.kr(Changed.kr(mFreq4), 1/mod4T), 0, 1);
	mod5P = Wrap.kr(Phaser.kr(Changed.kr(mFreq5), 1/mod5T), 0, 1);

	car1V = 1/freq1Change - Wrap.kr(car1P, freq1Change, 1/freq1Change);
	car2V = 1/freq2Change - Wrap.kr(car2P, freq2Change, 1/freq2Change);
	car3V = 1/freq3Change - Wrap.kr(car3P, freq3Change, 1/freq3Change);
	car4V = 1/freq4Change - Wrap.kr(car4P, freq4Change, 1/freq4Change);
	mod2V = 1/mFreq2Change - Wrap.kr(mod2P, mFreq2Change, 1/mFreq2Change);
	mod3V = 1/mFreq3Change - Wrap.kr(mod3P, mFreq3Change, 1/mFreq3Change);
	mod4V = 1/mFreq4Change - Wrap.kr(mod4P, mFreq4Change, 1/mFreq4Change);
	mod5V = 1/mFreq5Change - Wrap.kr(mod5P, mFreq5Change, 1/mFreq5Change);

	car1L = (1/car1TChange - Wrap.kr(car1P, car1TChange, 1/car1TChange)) * car1T;
	car2L = (1/car2TChange - Wrap.kr(car2P, car2TChange, 1/car2TChange)) * car2T;
	car3L = (1/car3TChange - Wrap.kr(car3P, car3TChange, 1/car3TChange)) * car3T;
	car4L = (1/car4TChange - Wrap.kr(car4P, car4TChange, 1/car4TChange)) * car4T;
	mod2L = (1/mod2TChange - Wrap.kr(mod2P, mod2TChange, 1/mod2TChange)) * mod2T;
	mod3L = (1/mod3TChange - Wrap.kr(mod3P, mod3TChange, 1/mod3TChange)) * mod3T;
	mod4L = (1/mod4TChange - Wrap.kr(mod4P, mod4TChange, 1/mod4TChange)) * mod4T;
	mod5L = (1/mod5TChange - Wrap.kr(mod5P, mod5TChange, 1/mod5TChange)) * mod5T;

	index1T = (car1T + mod2T + car1L + mod2L);
	index2T = (car2T + car2L + (mod1T * 2));
	index3T = (car2T + car2L + (mod1T * 2));
	index4T = (car4T + mod3T + car4L + mod3L);
	index5T = (mod4T + mod4L + (mod1T * 2));
	index6T = (mod5T + mod5L + (mod1T * 2));
	index7T = (mod2T + mod4T + mod2L + mod4L);
	index8T = (mod3T + mod5T + mod3L + mod5L);
	index9T = (mod4T + mod4L + (mod6T * 2));
	index10T = (mod5T + mod5L + (mod6T * 2));

	lFreq1 = Lag.kr(freq1, car1V);
	lFreq2 = Lag.kr(freq2, car2V);
	lFreq3 = Lag.kr(freq3, car3V);
	lFreq4 = Lag.kr(freq4, car4V);
	lMFreq2 = Lag.kr(mFreq2, mod2V);
	lMFreq3 = Lag.kr(mFreq3, mod3V);
	lMFreq4 = Lag.kr(mFreq4, mod4V);
	lMFreq5 = Lag.kr(mFreq5, mod5V);

	lIndex1 = Lag.ar(index1, index1T);
	lIndex2 = Lag.ar(index2, index2T);
	lIndex3 = Lag.ar(index3, index3T);
	lIndex4 = Lag.ar(index4, index4T);
	lIndex5 = Lag.ar(index5, index5T);
	lIndex6 = Lag.ar(index6, index6T);
	lIndex7 = Lag.ar(index7, index7T);
	lIndex8 = Lag.ar(index8, index8T);
	lIndex9 = Lag.ar(index9, index9T);
	lIndex10 = Lag.ar(index10, index10T);

	lCarAmp1 = Lag.ar(carAmp1, car1L);
	lCarAmp2 = Lag.ar(carAmp2, car2L);
	lCarAmp3 = Lag.ar(carAmp3, car3L);
	lCarAmp4 = Lag.ar(carAmp4, car4L);

	lModAmp2 = Lag.ar(modAmp2, mod2L);
	lModAmp3 = Lag.ar(modAmp3, mod3L);
	lModAmp4 = Lag.ar(modAmp4, mod4L);
	lModAmp5 = Lag.ar(modAmp5, mod5L);

	mod6 = SinOsc.ar(mFreq6, modAmp6);
	mod4 = SinOsc.ar(lMFreq4 + (mod6 * lMFreq4 * lIndex9), lModAmp4);
	mod5 = SinOsc.ar(lMFreq5 + (mod6 * lMFreq5 * lIndex10), lModAmp5);
	mod2 = SinOsc.ar(lMFreq2 + (mod4 * lMFreq2 * lIndex7), lModAmp2);
	mod3 = SinOsc.ar(lMFreq3 + (mod5 * lMFreq3 * lIndex8), lModAmp3);
	mod1 = SinOsc.ar(mFreq1 + (mod4 * mFreq1 * lIndex5) + (mod5 * mFreq1 * lIndex6), modAmp1);
	car1 = SinOsc.ar(lFreq1 + (mod2 * lFreq1 * lIndex1), mul: lCarAmp1);
	car2 = SinOsc.ar(lFreq2 + (mod1 * lFreq2 * lIndex2), mul: lCarAmp2);
	car3 = SinOsc.ar(lFreq3 + (mod1 * lFreq3 * lIndex3), mul: lCarAmp3);
	car4 = SinOsc.ar(lFreq4 + (mod3 * lFreq4 * lIndex4), mul: lCarAmp4);

	mix = (car1 + car2 + car3 + car4) * 0.25 * vol;
	Out.ar(0, mix);

}).add;
);

~oscdefFunction = {arg number;
	OSCdef.new(~osc[\defName][number], {
		arg msg;
		~osc[\net].sendMsg(~osc[\synth][number], msg.at(3));
	}, ~osc[\reply][number]);
};

14.do({arg count;
	~oscdefFunction.value(count);
});

OSCdef.new("test", {arg msg;
	~globals[\trigger] = 1 / msg;
}, '/frameRate');

~routineFunction = {arg number;
	var synthReference, synthValue, synthTime, synthInterval, synthRhythm, side, rowForm, i0, i1 = 0, i2 = 0, r0 = -1, r1 = -1, r2 = -1, rep = -1, value, timeUnit;

	synthReference = ~globals[~globals[\synthReference][number]];
	synthValue = ~globals[\synthValue][number];
	synthTime = ~globals[\synthTime][number];
	synthInterval = ~globals[\synthInterval][number];
	synthRhythm = ~globals[\synthRhythm][number];
	side = ~globals[\side][number];
	rowForm = ~globals[\rowForm][number];
	i0 = side;
	value = ~globals[synthValue];
	timeUnit = (3.33 * 13440)/s.sampleRate;

	Routine({
		~globals[\form].do({arg section;
			var row, iIndex, rIndex, rowIteration, intervalClass, rhythmClass, intervalRow, rhythmRow, time, currentV, currentT, interval, rhythm, changeV, changeT;

			~osc[\net].sendMsg(~osc[\section], section);

			switch(section,
				0, { row = ~globals[\row0]; rep = rep + 8; i0 = (i0 + 1) % 3; r0 = r0 + 1; iIndex = i0; rIndex = r0; },
				1, { row = ~globals[\row1]; i1 = (i1 + 1) % 2; r1 = r1 + 1; iIndex = i1; rIndex = r1; },
				2, { row = ~globals[\row2]; i2 = (i2 + 1) % 2; r2 = r2 + 1; iIndex = i2; rIndex = r2; }
			);

			intervalClass = ~globals[\intervalClass][section][iIndex];
			rhythmClass = ~globals[\intervalClass][section][rIndex];

			~osc[\net].sendMsg(~osc[\intervalClass], intervalClass);
			~osc[\net].sendMsg(~osc[\rhythmClass], rhythmClass);

			intervalRow = ~globals[\intervals][intervalClass];
			rhythmRow = ~globals[\intervals][rhythmClass];

			if(section == 0,
				{ rowIteration = ~globals[\row0][number + rep]; },
				{
					switch(rowForm,
						0, { rowIteration = row; },
						1, { rowIteration = row.reverse; },
						2, { rowIteration = row.size - 1 - row; },
						3, { rowIteration = (row.size - 1 - row).reverse; },
						4, { rowIteration = row * ((row.size/2) + 1) % row.size; },
						5, { rowIteration = (row * ((row.size/2) + 1) % row.size).reverse; },
						6, { rowIteration = row * ((row.size/2) - 1) % row.size; },
						7, { rowIteration = (row * ((row.size/2) - 1) % row.size).reverse; }
					);
			});

			rowIteration.do({arg position;

				currentV = value;
				currentT = time;
				interval = intervalRow[position];
				rhythm = rhythmRow[position];
				changeV = intervalRow.normalize[position];
				changeT = rhythmRow.normalize[position];

				~osc[\net].sendMsg(~osc[\changeV][number], changeV);
				~osc[\net].sendMsg(~osc[\changeT][number], changeT);

				if(synthReference == nil,
					{ value = currentV * interval; },
					{ value = currentV * interval; }
				);

				time = timeUnit * rhythm;

				~osc[\net].sendMsg(~osc[\value][number], value);
				~osc[\net].sendMsg(~osc[\time][number], time);

				~synth.set(synthValue, value);
				~synth.set(synthTime, time);
				~synth.set(synthInterval, changeV);
				~synth.set(synthRhythm, changeT);

				(time).wait;
			});
		});
		~synth.set(synthValue, 0);
		~synth.set(synthTime, 0);
		~synth.set(synthInterval, 0);
		~synth.set(synthRhythm, 0);
		(number + " done").postln;
	});
};

Routine({
	10.wait;

~osc[\net].sendMsg(~osc[\sampleRate], s.sampleRate);

~synth = Synth("FM10", [\frameRate, ~globals[\frameRate], \freq1, ~globals[\freq1], \freq2, ~globals[\freq2], \freq3, ~globals[\freq3], \freq4, ~globals[\freq4], \mFreq2, ~globals[\mFreq2], \mFreq3, ~globals[\mFreq3], \mFreq4, ~globals[\mFreq4], \mFreq5, ~globals[\mFreq5]]);

~car1 = ~routineFunction.value(0);
~car2 = ~routineFunction.value(1);
~car3 = ~routineFunction.value(2);
~car4 = ~routineFunction.value(3);
~mod2 = ~routineFunction.value(4);
~mod3 = ~routineFunction.value(5);
~mod4 = ~routineFunction.value(6);
~mod5 = ~routineFunction.value(7);
~car1.play;
~car2.play;
~car3.play;
~car4.play;
~mod2.play;
~mod3.play;
~mod4.play;
~mod5.play;
}).play;
)
});
)

s.recHeaderFormat = "wav";
s.prepareForRecord(numChannels: 2);
s.record(bus: 0);
s.stopRecording;