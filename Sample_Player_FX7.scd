
(
s.options.memSize = 81920;
s.waitForBoot{
	fork{
		var proc = NetAddr("127.0.0.1", 12321);
		var g0 = Group.new(s);
		var g1 = Group.after(g0);
		var g2 = Group.after(g1);
		var sampbus = {Bus.audio(s, 1)}!20;
		var ixabus = {Bus.audio(s, 1)}!20;
		var ixkbus = {Bus.control(s, 1)}!20;
		var kbus = {Bus.control(s, 33)}!20;
		var bufnames = Array.newClear(0);
		var bufdurs = Array.newClear(0);
		var samps = SoundFile.collectIntoBuffers( "/Users/jyang/GitHub/OSCgui/samples/*");
		var wff = {
			arg buf, numpx, pl;
			buf.loadToFloatArray(action:{
				arg array;
				var bufarray = array.copyRange(0, array.size-1);
				var newsampsize = numpx;
				var newsamplerate = (bufarray.size/newsampsize).round;
				var resampedArray = Array.newClear(newsampsize+3);
				var ct = 0;
				bufarray.do{ arg it, ix;
					if( ix%newsamplerate == 0, {
						resampedArray[ct] = it.asFloat;
						ct = ct+1;
					}); //end if statement: if( ix%newsamplerate == 0
				}; //end for loop bufarray.do{
				resampedArray = resampedArray.insert(0, pl.asInteger);
				resampedArray = resampedArray.insert(0, numpx.asInteger);
				resampedArray = resampedArray.insert(0, "/wavfrm");
				proc.sendBundle(0.0, resampedArray);
			}); //end b.loadToFloatArray(action:{
		}; //end wff function
		samps.do{ |it ix| var nm = it.path.split($/); bufnames = bufnames.add(nm[nm.size-1].asString) }; //get buf names
		samps.do{|it ix| bufdurs = bufdurs.add((it.numFrames/it.sampleRate).asFloat)}; //get buf durs
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
			env = EnvGen.ar(Env.asr(releaseTime:0.01, curve:0),gate);
			index = In.ar(idxbus);
			samp = BufRd.ar(1, buf, index);
			Out.ar(obs, samp*env);
		}).add;
		//// FXs ////////////////////////////////
		SynthDef(\amplify, {
			arg ibs, obs=0, gate=1;
			var src, sig, env, amp;
			amp = \amp.kr(0.85, 0.03);
			env = EnvGen.ar(Env.asr(releaseTime:0.1),gate,doneAction:2);
			src = In.ar(ibs);
			sig = src;
			Out.ar(obs, sig*env*amp);
		}).add;
		//// OSC DEFS ////////////////////////////////

		OSCdef(\getix, {|msg|
			var pl = msg[1].asInteger;
			ixkbus[pl].get({ |val| proc.sendMsg("/ix", pl, val.asFloat) });
		}, "/getix");

		OSCdef(\setix, {|msg|
			var pl = msg[1].asInteger;
			var sampnum = msg[2].asInteger;
			var start = msg[3].asFloat;
			var end = msg[4].asFloat;
			s.sendMsg( \n_set, 3000+pl, \start, start, \end, end );
		}, "/setix");
		OSCdef(\getwf, { |msg|
			var pl = msg[1].asInteger;
			var bufnum = msg[2].asInteger;
			var numpx = msg[3].asInteger;
			//change buffer of index/play synths if currently playing
			s.sendMsg( \n_set, 3000+pl, \buf, samps[bufnum].bufnum );
			s.sendMsg( \n_set, 4000+pl, \buf, samps[bufnum].bufnum );
			wff.value(samps[bufnum], numpx, pl);
		}, "/getwf");
		OSCdef(\getsampnames, { |msg|
			var pl = msg[1].asInteger;
			var sn = bufnames.copyRange(0, bufnames.size-1);
			var numbufs = sn.size.asInteger;
			sn = sn.insert(0, pl);
			sn = sn.insert(0, numbufs);
			sn = sn.insert(0, "/sampnames");
			proc.sendBundle(0.0, sn);
		}, "/getsampnames");
		OSCdef(\playsamp, { |msg|
			var pl = msg[1].asInteger;
			var sampnum = msg[2].asInteger;
			var mode = msg[3].asInteger;
			fork{
				switch( mode,
					0, {
						s.sendMsg( \n_set, 3000+pl, \spd, 0);
						s.sendMsg( \n_set, 4000+pl, \gate, 0);
					},
					1, {
						s.sendMsg( \s_new, \indexer, 3000+pl, 0, g0.nodeID, \buf, samps[sampnum].bufnum, \abus, ixabus[pl].index, \kbus, ixkbus[pl].index);
						s.sendMsg( \s_new, \sampplay, 4000+pl, 0, g1.nodeID, \obs, sampbus[pl], \buf, samps[sampnum].bufnum, \idxbus, ixabus[pl].index);
						s.sendMsg( \n_set, 3000+pl, \spd, 1);
						s.sendMsg( \n_set, 4000+pl, \gate, 1);

					}
				);
			}
		}, "/playsamp");
		OSCdef(\sl, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asSymbol;
			var val = msg[4].asFloat;
			kbus[gr].setAt(pl, val);
		}, "/sl");
		OSCdef(\amplify, {|msg|
			var gr = msg[1].asInteger;
			var pl = msg[2].asInteger;
			var lbl = msg[3].asSymbol;
			var mode = msg[4].asInteger;
			fork{
				switch( mode,
					0, {},
					1, {
						s.sendMsg( \s_new, lbl, 5000+pl, 0, g2.nodeID, \ibs, sampbus[gr].index); //start amplify synth
						proc.sendMsg("/slclear");
						proc.sendMsg("/mksl2", 0, 50, 350, "amp", 0.0, 1.0, 34);
						s.sendMsg(\n_map, 5000+gr, \amp, kbus[gr].index+0);
						//Presets
						proc.sendMsg("/slchg", 0, 0.95);
					}
				)//end switch
			}//end fork
		}, "/amplify"); //end OSCdef

	}//end fork
}//end s.waitForBoot
)
p = NetAddr("127.0.0.1", 12321);
p.sendMsg("/slclear");
p.sendMsg("/mksl2", 0, 50, 350, "amp", 0.0, 1.0, 34);
p.sendMsg("/slchg", 0, 0.333);

b = Bus.control(s, 99);
b.getnSynchronous[3]
b.setAt(3, 4000);

Send sample out private bus
Set up amplify
map slider to amp

amplify - 46 273 95 50
sliders
50 350 +70

OSCdef(\fdsa, {|msg| msg.postln;}, "/amplify");

Slider(ix, x, y, lbl, vlo, vhi, clrnum)

g = Bus.control(s, 30);
h = Bus.control(s, 30);
s.sendMsg(\c_get, 