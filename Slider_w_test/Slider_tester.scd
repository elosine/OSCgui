(
~proc = NetAddr("127.0.0.1", 12321);
//For Receiving Slider Data
~kb = {Bus.control(s,1)}!99;
OSCdef(\slider, {|msg|
	var id = msg[1].asInteger;
	var val = msg[2].asFloat;
	~kb[id].set(val);
}, "/slider");

SynthDef(\stest, {
	arg gate=1;
	var amp, pitch, rate, pw;
	var lfo, sig, env, freq;
	amp = \amp.kr(0.85, 0.03);
	pitch = \pitch.kr(60, 0.03);
	rate = \rate.kr(1, 0.03);
	pw = \pw.kr(0.5, 0.03);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.1), gate);
	lfo = SinOsc.kr(rate);
	freq = (pitch + lfo).midicps;
	sig = Pulse.ar(freq, pw);
	Out.ar(0, sig*env*amp);
}).add;

)

//Make Synth
a = Synth(\stest);

(
//Make Sliders
//int ix, String lbl, float x, float y, float w, float h, float slo, float shi
//amp
~proc.sendMsg("/mksl", 0, "Amp", 20.0, 150.0, 60.0, 180.0, 0.0, 1.0);
//pitch
~proc.sendMsg("/mksl", 1, "Pitch", 100.0, 150.0, 60.0, 180.0, 36.0, 84.0);
//rate
~proc.sendMsg("/mksl", 2, "Rate", 180.0, 150.0, 60.0, 180.0, 0.25, 30.0);
//Pulse Width
~proc.sendMsg("/mksl", 3, "PW", 260.0, 150.0, 60.0, 180.0, 0.0, 1.0);
)

//move sliders around first

(
//Map synth args to control busses controled by sliders
a.map(\amp, ~kb[0]);
a.map(\pitch, ~kb[1]);
a.map(\rate, ~kb[2]);
a.map(\pw, ~kb[3]);
)

//remove sliders
~proc.sendMsg("/rmsl", 0);
~proc.sendMsg("/rmsl", 1);
~proc.sendMsg("/rmsl", 2);
~proc.sendMsg("/rmsl", 3);



