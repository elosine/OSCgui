
(
s.waitForBoot{
	fork{
		var proc = NetAddr("127.0.0.1", 12321);
		var g0 = Group.new(s);
		var g1 = Group.after(~g0);
		var ixabus = Bus.audio(s, 1);
		var ixkbus = Bus.control(s, 1);
		var bufnames = Array.newClear(0);
		var bufdurs = Array.newClear(0);
		var samps = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/DSP_Framework/monosamples/*");
		var wff = {
			arg buf, numpx;
			buf.loadToFloatArray(action:{
				arg array;
				var bufarray = array.copyRange(0, array.size-1);
				var newsampsize = numpx;
				var newsamplerate = (bufarray.size/newsampsize).round;
				var resampedArray = Array.newClear(newsampsize+2);
				var ct = 0;
				bufarray.do{ arg it, ix;
					if( ix%newsamplerate == 0, {
						resampedArray[ct] = it.asFloat;
						ct = ct+1;
					}); //end if statement: if( ix%newsamplerate == 0
				}; //end for loop bufarray.do{
				resampedArray = resampedArray.insert(0, numpx.asInteger);
				resampedArray = resampedArray.insert(0, "/wavfrm");
				proc.sendBundle(0.0, resampedArray);
			}); //end b.loadToFloatArray(action:{
		}; //end wff function
		samps.do{ |it ix| var nm = it.path.split($/); bufnames = bufnames.add(nm[nm.size-1].asString) };
		samps.do{|it ix| bufdurs = bufdurs.add((it.numFrames/it.sampleRate).asFloat)};
		//SYNTH DEFS
		SynthDef(\indexer, {
			arg buf, spd=1, start=0, end=1, abus, kbus;
			var index, indexnorm;
			index = Phasor.ar(0, BufRateScale.kr(buf)*spd, start*BufFrames.kr(buf), end*BufFrames.kr(buf));
			indexnorm = index.linlin(0.0, BufFrames.kr(buf), 0.0, 1.0);
			Out.ar(abus, index);
			Out.kr(kbus, indexnorm);
		}).add;
		SynthDef(\sampplay, {
			arg idxbus, obs=0, buf, gate=1;
			var index, samp, env;
			env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate, doneAction:2);
			index = In.ar(idxbus);
			samp = BufRd.ar(1, buf, index);
			Out.ar(obs, samp*env);
		}).add;
		OSCdef(\getix, {
			ixkbus.get({ |val|
				proc.sendMsg("/ix", val.asFloat);
			});
		}, "/getix");
		OSCdef(\getwf, { |msg|
			var bufnum = msg[1].asInteger;
			var numpx = msg[2].asInteger;
			msg.postln;
			wff.value(samps[bufnum], numpx);
		}, "/getwf");
		OSCdef(\getsampnames, { |msg|
			var sn = bufnames.copyRange(0, bufnames.size-1);
			sn = sn.insert(0, sn.size.asInteger);
			sn = sn.insert(0, "/sampnames");
			proc.sendBundle(0.0, sn);
		}, "/getsampnames");

		0.1.wait;
		//~ixsynth = Synth(\indexer, [\buf, ~sbuf, \abus, ~ixabus, \kbus, ~ixkbus], ~g0);
		//~playsynth = Synth(\sampplay2, [\buf, ~sbuf, \idxbus, ~ixabus], ~g1);
	}//end fork
}//end s.waitForBoot
)






