(function (console, $hx_exports, $global) { "use strict";
var $hxClasses = {},$estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
};
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
};
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
};
Lambda.fold = function(it,f,first) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
};
Lambda.find = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v = $it0.next();
		if(f(v)) return v;
	}
	return null;
};
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
$hxClasses["_List.ListIterator"] = _$List_ListIterator;
_$List_ListIterator.__name__ = ["_List","ListIterator"];
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
Math.__name__ = ["Math"];
var Perf = $hx_exports.Perf = function(pos,offset) {
	if(offset == null) offset = 0;
	if(pos == null) pos = "TR";
	this._perfObj = window.performance;
	if(Reflect.field(this._perfObj,"memory") != null) this._memoryObj = Reflect.field(this._perfObj,"memory");
	this._memCheck = this._perfObj != null && this._memoryObj != null && this._memoryObj.totalJSHeapSize > 0;
	this._pos = pos;
	this._offset = offset;
	this.currentFps = 60;
	this.currentMs = 0;
	this.currentMem = "0";
	this.lowFps = 60;
	this.avgFps = 60;
	this._measureCount = 0;
	this._totalFps = 0;
	this._time = 0;
	this._ticks = 0;
	this._fpsMin = 60;
	this._fpsMax = 60;
	if(this._perfObj != null && ($_=this._perfObj,$bind($_,$_.now)) != null) this._startTime = this._perfObj.now(); else this._startTime = new Date().getTime();
	this._prevTime = -Perf.MEASUREMENT_INTERVAL;
	this._createFpsDom();
	this._createMsDom();
	if(this._memCheck) this._createMemoryDom();
	if(($_=window,$bind($_,$_.requestAnimationFrame)) != null) this.RAF = ($_=window,$bind($_,$_.requestAnimationFrame)); else if(window.mozRequestAnimationFrame != null) this.RAF = window.mozRequestAnimationFrame; else if(window.webkitRequestAnimationFrame != null) this.RAF = window.webkitRequestAnimationFrame; else if(window.msRequestAnimationFrame != null) this.RAF = window.msRequestAnimationFrame;
	if(($_=window,$bind($_,$_.cancelAnimationFrame)) != null) this.CAF = ($_=window,$bind($_,$_.cancelAnimationFrame)); else if(window.mozCancelAnimationFrame != null) this.CAF = window.mozCancelAnimationFrame; else if(window.webkitCancelAnimationFrame != null) this.CAF = window.webkitCancelAnimationFrame; else if(window.msCancelAnimationFrame != null) this.CAF = window.msCancelAnimationFrame;
	if(this.RAF != null) this._raf = Reflect.callMethod(window,this.RAF,[$bind(this,this._tick)]);
};
$hxClasses["Perf"] = Perf;
Perf.__name__ = ["Perf"];
Perf.prototype = {
	_init: function() {
		this.currentFps = 60;
		this.currentMs = 0;
		this.currentMem = "0";
		this.lowFps = 60;
		this.avgFps = 60;
		this._measureCount = 0;
		this._totalFps = 0;
		this._time = 0;
		this._ticks = 0;
		this._fpsMin = 60;
		this._fpsMax = 60;
		if(this._perfObj != null && ($_=this._perfObj,$bind($_,$_.now)) != null) this._startTime = this._perfObj.now(); else this._startTime = new Date().getTime();
		this._prevTime = -Perf.MEASUREMENT_INTERVAL;
	}
	,_now: function() {
		if(this._perfObj != null && ($_=this._perfObj,$bind($_,$_.now)) != null) return this._perfObj.now(); else return new Date().getTime();
	}
	,_tick: function(val) {
		var time;
		if(this._perfObj != null && ($_=this._perfObj,$bind($_,$_.now)) != null) time = this._perfObj.now(); else time = new Date().getTime();
		this._ticks++;
		if(this._raf != null && time > this._prevTime + Perf.MEASUREMENT_INTERVAL) {
			this.currentMs = Math.round(time - this._startTime);
			this.ms.innerHTML = "MS: " + this.currentMs;
			this.currentFps = Math.round(this._ticks * 1000 / (time - this._prevTime));
			if(this.currentFps > 0 && val > Perf.DELAY_TIME) {
				this._measureCount++;
				this._totalFps += this.currentFps;
				this.lowFps = this._fpsMin = Math.min(this._fpsMin,this.currentFps);
				this._fpsMax = Math.max(this._fpsMax,this.currentFps);
				this.avgFps = Math.round(this._totalFps / this._measureCount);
			}
			this.fps.innerHTML = "FPS: " + this.currentFps + " (" + this._fpsMin + "-" + this._fpsMax + ")";
			if(this.currentFps >= 30) this.fps.style.backgroundColor = Perf.FPS_BG_CLR; else if(this.currentFps >= 15) this.fps.style.backgroundColor = Perf.FPS_WARN_BG_CLR; else this.fps.style.backgroundColor = Perf.FPS_PROB_BG_CLR;
			this._prevTime = time;
			this._ticks = 0;
			if(this._memCheck) {
				this.currentMem = this._getFormattedSize(this._memoryObj.usedJSHeapSize,2);
				this.memory.innerHTML = "MEM: " + this.currentMem;
			}
		}
		this._startTime = time;
		if(this._raf != null) this._raf = Reflect.callMethod(window,this.RAF,[$bind(this,this._tick)]);
	}
	,_createDiv: function(id,top) {
		if(top == null) top = 0;
		var div;
		var _this = window.document;
		div = _this.createElement("div");
		div.id = id;
		div.className = id;
		div.style.position = "absolute";
		var _g = this._pos;
		switch(_g) {
		case "TL":
			div.style.left = this._offset + "px";
			div.style.top = top + "px";
			break;
		case "TR":
			div.style.right = this._offset + "px";
			div.style.top = top + "px";
			break;
		case "BL":
			div.style.left = this._offset + "px";
			div.style.bottom = (this._memCheck?48:32) - top + "px";
			break;
		case "BR":
			div.style.right = this._offset + "px";
			div.style.bottom = (this._memCheck?48:32) - top + "px";
			break;
		}
		div.style.width = "80px";
		div.style.height = "12px";
		div.style.lineHeight = "12px";
		div.style.padding = "2px";
		div.style.fontFamily = Perf.FONT_FAMILY;
		div.style.fontSize = "9px";
		div.style.fontWeight = "bold";
		div.style.textAlign = "center";
		window.document.body.appendChild(div);
		return div;
	}
	,_createFpsDom: function() {
		this.fps = this._createDiv("fps");
		this.fps.style.backgroundColor = Perf.FPS_BG_CLR;
		this.fps.style.zIndex = "995";
		this.fps.style.color = Perf.FPS_TXT_CLR;
		this.fps.innerHTML = "FPS: 0";
	}
	,_createMsDom: function() {
		this.ms = this._createDiv("ms",16);
		this.ms.style.backgroundColor = Perf.MS_BG_CLR;
		this.ms.style.zIndex = "996";
		this.ms.style.color = Perf.MS_TXT_CLR;
		this.ms.innerHTML = "MS: 0";
	}
	,_createMemoryDom: function() {
		this.memory = this._createDiv("memory",32);
		this.memory.style.backgroundColor = Perf.MEM_BG_CLR;
		this.memory.style.color = Perf.MEM_TXT_CLR;
		this.memory.style.zIndex = "997";
		this.memory.innerHTML = "MEM: 0";
	}
	,_getFormattedSize: function(bytes,frac) {
		if(frac == null) frac = 0;
		var sizes = ["Bytes","KB","MB","GB","TB"];
		if(bytes == 0) return "0";
		var precision = Math.pow(10,frac);
		var i = Math.floor(Math.log(bytes) / Math.log(1024));
		return Math.round(bytes * precision / Math.pow(1024,i)) / precision + " " + sizes[i];
	}
	,addInfo: function(val) {
		this.info = this._createDiv("info",this._memCheck?48:32);
		this.info.style.backgroundColor = Perf.INFO_BG_CLR;
		this.info.style.color = Perf.INFO_TXT_CLR;
		this.info.style.zIndex = "998";
		this.info.innerHTML = val;
	}
	,clearInfo: function() {
		if(this.info != null) {
			window.document.body.removeChild(this.info);
			this.info = null;
		}
	}
	,destroy: function() {
		Reflect.callMethod(window,this.CAF,[this._raf]);
		this._raf = null;
		this._perfObj = null;
		this._memoryObj = null;
		if(this.fps != null) {
			window.document.body.removeChild(this.fps);
			this.fps = null;
		}
		if(this.ms != null) {
			window.document.body.removeChild(this.ms);
			this.ms = null;
		}
		if(this.memory != null) {
			window.document.body.removeChild(this.memory);
			this.memory = null;
		}
		this.clearInfo();
		this.currentFps = 60;
		this.currentMs = 0;
		this.currentMem = "0";
		this.lowFps = 60;
		this.avgFps = 60;
		this._measureCount = 0;
		this._totalFps = 0;
		this._time = 0;
		this._ticks = 0;
		this._fpsMin = 60;
		this._fpsMax = 60;
		if(this._perfObj != null && ($_=this._perfObj,$bind($_,$_.now)) != null) this._startTime = this._perfObj.now(); else this._startTime = new Date().getTime();
		this._prevTime = -Perf.MEASUREMENT_INTERVAL;
	}
	,_cancelRAF: function() {
		Reflect.callMethod(window,this.CAF,[this._raf]);
		this._raf = null;
	}
	,__class__: Perf
};
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.compare = function(a,b) {
	if(a == b) return 0; else if(a > b) return 1; else return -1;
};
Reflect.isEnumValue = function(v) {
	return v != null && v.__enum__ != null;
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js_Boot.__instanceof(v,t);
};
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b += Std.string(x);
	}
	,addSub: function(s,pos,len) {
		if(len == null) this.b += HxOverrides.substr(s,pos,null); else this.b += HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
};
var ValueType = { __ename__ : true, __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
};
Type.createInstance = function(cl,args) {
	var _g = args.length;
	switch(_g) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw new js__$Boot_HaxeError("Too many arguments");
	}
	return null;
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = js_Boot.getClass(v);
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var _$UInt_UInt_$Impl_$ = {};
$hxClasses["_UInt.UInt_Impl_"] = _$UInt_UInt_$Impl_$;
_$UInt_UInt_$Impl_$.__name__ = ["_UInt","UInt_Impl_"];
_$UInt_UInt_$Impl_$.gt = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) return aNeg; else return a > b;
};
_$UInt_UInt_$Impl_$.gte = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	if(aNeg != bNeg) return aNeg; else return a >= b;
};
_$UInt_UInt_$Impl_$.toFloat = function(this1) {
	var $int = this1;
	if($int < 0) return 4294967296.0 + $int; else return $int + 0.0;
};
var Xml = function(nodeType) {
	this.nodeType = nodeType;
	this.children = [];
	this.attributeMap = new haxe_ds_StringMap();
};
$hxClasses["Xml"] = Xml;
Xml.__name__ = ["Xml"];
Xml.parse = function(str) {
	return haxe_xml_Parser.parse(str);
};
Xml.createElement = function(name) {
	var xml = new Xml(Xml.Element);
	if(xml.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + xml.nodeType);
	xml.nodeName = name;
	return xml;
};
Xml.createPCData = function(data) {
	var xml = new Xml(Xml.PCData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createCData = function(data) {
	var xml = new Xml(Xml.CData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createComment = function(data) {
	var xml = new Xml(Xml.Comment);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocType = function(data) {
	var xml = new Xml(Xml.DocType);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createProcessingInstruction = function(data) {
	var xml = new Xml(Xml.ProcessingInstruction);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) throw new js__$Boot_HaxeError("Bad node type, unexpected " + xml.nodeType);
	xml.nodeValue = data;
	return xml;
};
Xml.createDocument = function() {
	return new Xml(Xml.Document);
};
Xml.prototype = {
	set: function(att,value) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		this.attributeMap.set(att,value);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + this.nodeType);
		return this.attributeMap.exists(att);
	}
	,addChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(x.parent != null) x.parent.removeChild(x);
		this.children.push(x);
		x.parent = this;
	}
	,removeChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element or Document but found " + this.nodeType);
		if(HxOverrides.remove(this.children,x)) {
			x.parent = null;
			return true;
		}
		return false;
	}
	,__class__: Xml
};
var com_isartdigital_perle_Main = function() {
	this.classNameNoPathToWireFramMC = new haxe_ds_StringMap();
	this.wireFrameMCToClassName = new haxe_ds_StringMap();
	this.pathClass = new haxe_ds_StringMap();
	this.frames = 0;
	EventEmitter.call(this);
	this.forceImport();
	this.doUIBuilderHack();
	var lOptions = { };
	lOptions.antialias = true;
	lOptions.backgroundColor = 10066329;
	com_isartdigital_utils_system_DeviceCapabilities.init();
	com_isartdigital_utils_system_DeviceCapabilities.scaleViewport();
	this.renderer = PIXI.autoDetectRenderer(_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_width()),_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_height()),lOptions);
	window.document.body.appendChild(this.renderer.view);
	this.stage = new PIXI.Container();
	var lConfig = new PIXI.loaders.Loader();
	com_isartdigital_perle_Main.configPath += "?" + new Date().getTime();
	lConfig.add(com_isartdigital_perle_Main.configPath);
	lConfig.once("complete",$bind(this,this.preloadAssets));
	lConfig.load();
	com_isartdigital_services_facebook_Facebook.onLogin = $bind(this,this.onLogin);
	com_isartdigital_services_facebook_Facebook.load("1764871347166484");
};
$hxClasses["com.isartdigital.perle.Main"] = com_isartdigital_perle_Main;
com_isartdigital_perle_Main.__name__ = ["com","isartdigital","perle","Main"];
com_isartdigital_perle_Main.main = function() {
	com_isartdigital_perle_Main.getInstance();
};
com_isartdigital_perle_Main.getInstance = function() {
	if(com_isartdigital_perle_Main.instance == null) com_isartdigital_perle_Main.instance = new com_isartdigital_perle_Main();
	return com_isartdigital_perle_Main.instance;
};
com_isartdigital_perle_Main.__super__ = EventEmitter;
com_isartdigital_perle_Main.prototype = $extend(EventEmitter.prototype,{
	onLogin: function() {
		console.log("connexion facebook OwO");
	}
	,preloadAssets: function(pLoader) {
		com_isartdigital_utils_Config.init(Reflect.field(pLoader.resources,com_isartdigital_perle_Main.configPath).data);
		if(com_isartdigital_utils_Config.get_debug()) com_isartdigital_utils_Debug.getInstance().init();
		if(com_isartdigital_utils_Config.get_debug() && com_isartdigital_utils_Config.get_data().boxAlpha != null) com_isartdigital_utils_game_StateGraphic.boxAlpha = com_isartdigital_utils_Config.get_data().boxAlpha;
		if(com_isartdigital_utils_Config.get_debug() && com_isartdigital_utils_Config.get_data().animAlpha != null) com_isartdigital_utils_game_StateGraphic.animAlpha = com_isartdigital_utils_Config.get_data().animAlpha;
		if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") {
			com_isartdigital_utils_game_GameStage.getInstance().set_scaleMode(com_isartdigital_utils_game_GameStageScale.NO_SCALE);
			com_isartdigital_utils_system_DeviceCapabilities.textureRatio = 0.5;
			com_isartdigital_utils_system_DeviceCapabilities.textureType = "ld";
		} else {
			com_isartdigital_utils_game_GameStage.getInstance().set_scaleMode(com_isartdigital_utils_game_GameStageScale.SHOW_ALL);
			com_isartdigital_utils_system_DeviceCapabilities.init(1,0.75,0.5);
		}
		com_isartdigital_utils_game_GameStage.getInstance().init($bind(this,this.render),2048,1366,true,true,true,true);
		com_isartdigital_utils_system_DeviceCapabilities.displayFullScreenButton();
		this.stage.addChild(com_isartdigital_utils_game_GameStage.getInstance());
		window.addEventListener("resize",$bind(this,this.resize));
		this.resize();
		this.loadAssets();
	}
	,loadAssets: function() {
		var lLoader = new com_isartdigital_utils_loader_GameLoader();
		lLoader.addTxtFile("boxes.json");
		lLoader.addSoundFile("sounds.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Region_Hell/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Region_Heaven/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Background_Heaven/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Background_Hell/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Styx01/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Styx02/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Elt_Enfer_Decors/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Elt_Paradis_Decors/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Bat_Tribunal/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/HeavenBuildingPlaceholders/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/HeavenLumberMillPlaceholders/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/HellBuildingPlaceholders/library.json");
		lLoader.addAssetFile("InGame/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/placeholder_flump_sprite/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Compilation/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Purgatoire/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_ListInterns/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_InternInQuest/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_InternOutQuest/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Interns/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Fenetre_PNJ/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_BuildingDecoTab/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_BuyableIntern/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_BuyablePack/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_CurrenciesTab/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_ResourcesTab/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_InternsTabAvailable/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_InternsTabSearching/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_ItemLocked/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Shop_ItemUnlocked/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Wireframe_Shop_Bundle/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/Share_Atlas/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Popin_ConfirmationAchatMaison/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Popin_DestroyBuilding/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Popin_ConfirmationAchatEuros/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Popin_LevelUp/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Fenetre_InfoMaison/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Intern_Event/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_BuyRegion/library.json");
		lLoader.addAssetFile("UI/" + com_isartdigital_utils_system_DeviceCapabilities.textureType + "/WireFrame_Intern_MaxStress/library.json");
		lLoader.addFontFile("fonts.css");
		lLoader.on("progress",$bind(this,this.onLoadProgress));
		lLoader.once("complete",$bind(this,this.onLoadComplete));
		lLoader.addTxtFile("json/" + "dialogue_ftue" + ".json");
		lLoader.addTxtFile("json/" + "FTUE" + ".json");
		lLoader.addTxtFile("json/" + "experience" + ".json");
		lLoader.addTxtFile("json/" + "item_to_unlock" + ".json");
		lLoader.addTxtFile("json/" + "game_config" + ".json");
		lLoader.addTxtFile("json/" + "buy_price" + ".json");
		haxe_Timer.delay($bind(this,this.gameLoop),16);
		lLoader.load();
	}
	,onLoadProgress: function(pLoader) {
	}
	,onLoadComplete: function(pLoader) {
		pLoader.off("progress",$bind(this,this.onLoadProgress));
		com_isartdigital_perle_game_managers_DialogueManager.init(com_isartdigital_utils_loader_GameLoader.getContent("json/" + "FTUE" + ".json"));
		com_isartdigital_perle_game_GameManager.getInstance().start();
	}
	,gameLoop: function() {
		haxe_Timer.delay($bind(this,this.gameLoop),16);
		this.render();
		this.emit("gameLoop");
	}
	,resize: function(pEvent) {
		this.renderer.resize(_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_width()),_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_height()));
		com_isartdigital_utils_game_GameStage.getInstance().resize();
	}
	,getPath: function(pClassName) {
		if(this.pathClass.get(pClassName) != null) return this.pathClass.get(pClassName); else {
			com_isartdigital_utils_Debug.error("NoPath Found for Class: " + pClassName);
			return null;
		}
	}
	,getClassName: function(pMovieClipName) {
		return this.wireFrameMCToClassName.get(pMovieClipName);
	}
	,getWireFrameName: function(pClassNameNoPath) {
		return this.classNameNoPathToWireFramMC.get(pClassNameNoPath);
	}
	,forceImport: function() {
		var arrayClass = [com_isartdigital_perle_game_sprites_Ground,com_isartdigital_perle_game_sprites_Building,com_isartdigital_perle_game_sprites_FootPrintAsset,com_isartdigital_perle_ui_popin_listIntern_InternElement,com_isartdigital_perle_game_sprites_Tribunal,com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven,com_isartdigital_perle_game_sprites_building_hell_DecoHell,com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven,com_isartdigital_perle_game_sprites_building_heaven_Lumbermill,com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven,com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell,com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven,com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding,com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell,com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse,com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill,com_isartdigital_perle_game_sprites_building_hell_HouseHell,com_isartdigital_perle_game_sprites_building_hell_Quarry,com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry];
		var lClassName;
		var lClassNameNoPath;
		var _g = 0;
		while(_g < arrayClass.length) {
			var pClass = arrayClass[_g];
			++_g;
			lClassName = Type.getClassName(pClass);
			lClassNameNoPath = lClassName.substring(lClassName.lastIndexOf(".") + 1);
			if(this.pathClass.get(lClassNameNoPath) != null) throw new js__$Boot_HaxeError("Conflict in pathClass whit " + lClassName);
			{
				this.pathClass.set(lClassNameNoPath,lClassName);
				lClassName;
			}
		}
	}
	,doUIBuilderHack: function() {
		var mapMovieClipToClass;
		var _g = new haxe_ds_StringMap();
		_g.set("Shop_" + "BuildingDeco_List",com_isartdigital_perle_ui_popin_shop_ShopCaroussel);
		mapMovieClipToClass = _g;
		var lClassName;
		var lClassNameNoPath;
		var $it0 = mapMovieClipToClass.keys();
		while( $it0.hasNext() ) {
			var lMovieClipName = $it0.next();
			lClassName = Type.getClassName(__map_reserved[lMovieClipName] != null?mapMovieClipToClass.getReserved(lMovieClipName):mapMovieClipToClass.h[lMovieClipName]);
			lClassNameNoPath = lClassName.substring(lClassName.lastIndexOf(".") + 1);
			{
				this.wireFrameMCToClassName.set(lMovieClipName,lClassName);
				lClassName;
			}
			{
				this.classNameNoPathToWireFramMC.set(lClassNameNoPath,lMovieClipName);
				lMovieClipName;
			}
		}
	}
	,render: function() {
		if(this.frames++ % 2 == 0) this.renderer.render(this.stage); else com_isartdigital_utils_game_GameStage.getInstance().updateTransform();
	}
	,destroy: function() {
		window.removeEventListener("resize",$bind(this,this.resize));
		com_isartdigital_perle_Main.instance = null;
	}
	,__class__: com_isartdigital_perle_Main
});
var com_isartdigital_perle_game_AssetName = function() { };
$hxClasses["com.isartdigital.perle.game.AssetName"] = com_isartdigital_perle_game_AssetName;
com_isartdigital_perle_game_AssetName.__name__ = ["com","isartdigital","perle","game","AssetName"];
var com_isartdigital_perle_game_BuildingName = function() { };
$hxClasses["com.isartdigital.perle.game.BuildingName"] = com_isartdigital_perle_game_BuildingName;
com_isartdigital_perle_game_BuildingName.__name__ = ["com","isartdigital","perle","game","BuildingName"];
com_isartdigital_perle_game_BuildingName.getAssetName = function(pBuildingName,pLevel) {
	if(pLevel == null) pLevel = 0;
	if(com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES.get(pBuildingName) == null || com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES.get(pBuildingName)[pLevel] == null) com_isartdigital_utils_Debug.error("AssetName for BuildingName : '" + pBuildingName + "' not found, for level : " + pLevel);
	return com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES.get(pBuildingName)[pLevel];
};
var com_isartdigital_perle_game_GameConfig = function() {
};
$hxClasses["com.isartdigital.perle.game.GameConfig"] = com_isartdigital_perle_game_GameConfig;
com_isartdigital_perle_game_GameConfig.__name__ = ["com","isartdigital","perle","game","GameConfig"];
com_isartdigital_perle_game_GameConfig.awake = function() {
	com_isartdigital_perle_game_GameConfig.config = new haxe_ds_StringMap();
	com_isartdigital_perle_game_GameConfig.parseJson(com_isartdigital_perle_game_GameConfig.config,com_isartdigital_utils_loader_GameLoader.getContent("json/" + "game_config" + ".json"));
};
com_isartdigital_perle_game_GameConfig.getConfig = function() {
	return com_isartdigital_perle_game_GameConfig.config.get("Config")[0];
};
com_isartdigital_perle_game_GameConfig.getBuilding = function() {
	return com_isartdigital_perle_game_GameConfig.config.get("TypeBuilding");
};
com_isartdigital_perle_game_GameConfig.getBuildingByName = function(pName) {
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_GameConfig.config.get("TypeBuilding").length;
	while(_g1 < _g) {
		var i = _g1++;
		if(com_isartdigital_perle_game_GameConfig.config.get("TypeBuilding")[i].Name == pName) return com_isartdigital_perle_game_GameConfig.config.get("TypeBuilding")[i];
	}
	return null;
};
com_isartdigital_perle_game_GameConfig.tableExist = function(pTable) {
	if(com_isartdigital_perle_game_GameConfig.config.get(pTable) == null) {
		com_isartdigital_utils_Debug.error("table named : " + pTable + " does not exist in database.");
		return false;
	}
	return true;
};
com_isartdigital_perle_game_GameConfig.parseJson = function(pConfig,pContent) {
	var fields = Reflect.fields(pContent);
	var _g1 = 0;
	var _g = fields.length;
	while(_g1 < _g) {
		var i = _g1++;
		var v = [];
		pConfig.set(fields[i],v);
		v;
		var anotherFields = Reflect.fields(Reflect.field(pContent,fields[i]));
		var _g3 = 0;
		var _g2 = anotherFields.length;
		while(_g3 < _g2) {
			var j = _g3++;
			pConfig.get(fields[i])[j] = Reflect.field(Reflect.field(pContent,fields[i]),anotherFields[j]);
		}
	}
};
com_isartdigital_perle_game_GameConfig.prototype = {
	__class__: com_isartdigital_perle_game_GameConfig
};
var com_isartdigital_perle_game_GameManager = function() {
};
$hxClasses["com.isartdigital.perle.game.GameManager"] = com_isartdigital_perle_game_GameManager;
com_isartdigital_perle_game_GameManager.__name__ = ["com","isartdigital","perle","game","GameManager"];
com_isartdigital_perle_game_GameManager.getInstance = function() {
	if(com_isartdigital_perle_game_GameManager.instance == null) com_isartdigital_perle_game_GameManager.instance = new com_isartdigital_perle_game_GameManager();
	return com_isartdigital_perle_game_GameManager.instance;
};
com_isartdigital_perle_game_GameManager.prototype = {
	start: function() {
		com_isartdigital_perle_game_managers_BoostManager.awake();
		com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.init();
		com_isartdigital_perle_game_sprites_Tile.initClass();
		com_isartdigital_perle_game_managers_ServerManager.playerConnexion();
		com_isartdigital_perle_game_GameConfig.awake();
		com_isartdigital_perle_game_managers_ResourcesManager.awake();
		com_isartdigital_perle_game_managers_BuyManager.initClass();
		com_isartdigital_perle_game_managers_ExperienceManager.setExpToLevelUp();
		com_isartdigital_perle_ui_UIManager.getInstance().startGame();
		com_isartdigital_perle_game_managers_PoolingManager.init();
		com_isartdigital_perle_ui_contextual_HudContextual.initClass();
		com_isartdigital_perle_game_managers_CameraManager.setTarget(com_isartdigital_utils_game_GameStage.getInstance().getGameContainer());
		com_isartdigital_perle_game_managers_TimeManager.initClass();
		com_isartdigital_perle_game_virtual_VTile.initClass();
		com_isartdigital_perle_ui_contextual_HudContextual.addContainer();
		com_isartdigital_perle_game_sprites_Phantom.initClass();
		com_isartdigital_perle_game_managers_RegionManager.init();
		com_isartdigital_perle_game_managers_SaveManager.createFromSave();
		com_isartdigital_perle_game_managers_UnlockManager.setUnlockItem();
		com_isartdigital_perle_game_managers_ClippingManager.update();
		com_isartdigital_perle_game_sprites_FootPrint.startClass();
		com_isartdigital_perle_game_managers_DialogueManager.createFtue();
		com_isartdigital_perle_ui_CheatPanel.getInstance().ingame();
		com_isartdigital_perle_Main.getInstance().on("gameLoop",$bind(this,this.gameLoop));
	}
	,gameLoop: function(pEvent) {
		com_isartdigital_perle_game_managers_MouseManager.getInstance().gameLoop();
		com_isartdigital_perle_game_sprites_Phantom.gameLoop();
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_MouseManager.getInstance().destroy();
		com_isartdigital_perle_Main.getInstance().off("gameLoop",$bind(this,this.gameLoop));
		com_isartdigital_perle_game_GameManager.instance = null;
	}
	,__class__: com_isartdigital_perle_game_GameManager
};
var com_isartdigital_perle_game_TextGenerator = function() {
};
$hxClasses["com.isartdigital.perle.game.TextGenerator"] = com_isartdigital_perle_game_TextGenerator;
com_isartdigital_perle_game_TextGenerator.__name__ = ["com","isartdigital","perle","game","TextGenerator"];
com_isartdigital_perle_game_TextGenerator.getInstance = function() {
	if(com_isartdigital_perle_game_TextGenerator.instance == null) com_isartdigital_perle_game_TextGenerator.instance = new com_isartdigital_perle_game_TextGenerator();
	return com_isartdigital_perle_game_TextGenerator.instance;
};
com_isartdigital_perle_game_TextGenerator.GetNewSituation = function() {
	var sentence = "";
	sentence += com_isartdigital_perle_game_QuestDictionnary.intro[Std.random(com_isartdigital_perle_game_QuestDictionnary.intro.length - 1)];
	sentence += com_isartdigital_perle_game_QuestDictionnary.localisation[Std.random(com_isartdigital_perle_game_QuestDictionnary.localisation.length - 1)];
	sentence += com_isartdigital_perle_game_QuestDictionnary.intern;
	sentence += com_isartdigital_perle_game_QuestDictionnary.internVerbs[Std.random(com_isartdigital_perle_game_QuestDictionnary.internVerbs.length - 1)];
	sentence += com_isartdigital_perle_game_QuestDictionnary.number[Std.random(com_isartdigital_perle_game_QuestDictionnary.number.length - 1)];
	var subject = com_isartdigital_perle_game_QuestDictionnary.subjects[Std.random(com_isartdigital_perle_game_QuestDictionnary.subjects.length - 1)];
	var index = 0;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_QuestDictionnary.vowel;
	while(_g < _g1.length) {
		var letter = _g1[_g];
		++_g;
		if(letter == subject.charAt(0)) {
			sentence += com_isartdigital_perle_game_QuestDictionnary.preSubject.get(com_isartdigital_perle_game_LetterType.VOYELLE);
			break;
		} else if(index >= com_isartdigital_perle_game_QuestDictionnary.vowel.length - 1) sentence += com_isartdigital_perle_game_QuestDictionnary.preSubject.get(com_isartdigital_perle_game_LetterType.CONSONNE);
		index++;
	}
	sentence += subject;
	var random = Math.round(Math.random() * 10);
	var actionType;
	if(random > 6) actionType = com_isartdigital_perle_game_ActionType.GOOD; else actionType = com_isartdigital_perle_game_ActionType.BAD;
	sentence += com_isartdigital_perle_game_QuestDictionnary.actions.get(actionType)[Std.random(com_isartdigital_perle_game_QuestDictionnary.actions.get(actionType).length - 1)];
	var secondSubject = com_isartdigital_perle_game_QuestDictionnary.secondarySubjects[Std.random(com_isartdigital_perle_game_QuestDictionnary.secondarySubjects.length - 1)];
	sentence += secondSubject;
	var hellAnswer;
	if(actionType == com_isartdigital_perle_game_ActionType.GOOD) hellAnswer = "Tuer les " + subject; else hellAnswer = "Aider les " + subject;
	var edenAnswer;
	if(actionType == com_isartdigital_perle_game_ActionType.GOOD) edenAnswer = "Aider les " + subject; else edenAnswer = "Tuer les " + subject;
	var txtArray = [sentence,hellAnswer,edenAnswer];
	return txtArray;
};
com_isartdigital_perle_game_TextGenerator.prototype = {
	TraceTest: function() {
		var situation = com_isartdigital_perle_game_TextGenerator.GetNewSituation();
		console.log(situation[0]);
		console.log("bad -> " + situation[1]);
		console.log("good -> " + situation[2]);
	}
	,destroy: function() {
		com_isartdigital_perle_game_TextGenerator.instance = null;
	}
	,__class__: com_isartdigital_perle_game_TextGenerator
};
var com_isartdigital_perle_game_LetterType = { __ename__ : true, __constructs__ : ["VOYELLE","CONSONNE"] };
com_isartdigital_perle_game_LetterType.VOYELLE = ["VOYELLE",0];
com_isartdigital_perle_game_LetterType.VOYELLE.toString = $estr;
com_isartdigital_perle_game_LetterType.VOYELLE.__enum__ = com_isartdigital_perle_game_LetterType;
com_isartdigital_perle_game_LetterType.CONSONNE = ["CONSONNE",1];
com_isartdigital_perle_game_LetterType.CONSONNE.toString = $estr;
com_isartdigital_perle_game_LetterType.CONSONNE.__enum__ = com_isartdigital_perle_game_LetterType;
var com_isartdigital_perle_game_ActionType = { __ename__ : true, __constructs__ : ["BAD","GOOD"] };
com_isartdigital_perle_game_ActionType.BAD = ["BAD",0];
com_isartdigital_perle_game_ActionType.BAD.toString = $estr;
com_isartdigital_perle_game_ActionType.BAD.__enum__ = com_isartdigital_perle_game_ActionType;
com_isartdigital_perle_game_ActionType.GOOD = ["GOOD",1];
com_isartdigital_perle_game_ActionType.GOOD.toString = $estr;
com_isartdigital_perle_game_ActionType.GOOD.__enum__ = com_isartdigital_perle_game_ActionType;
var com_isartdigital_perle_game_QuestDictionnary = function() { };
$hxClasses["com.isartdigital.perle.game.QuestDictionnary"] = com_isartdigital_perle_game_QuestDictionnary;
com_isartdigital_perle_game_QuestDictionnary.__name__ = ["com","isartdigital","perle","game","QuestDictionnary"];
var com_isartdigital_perle_game_TimesInfo = function() { };
$hxClasses["com.isartdigital.perle.game.TimesInfo"] = com_isartdigital_perle_game_TimesInfo;
com_isartdigital_perle_game_TimesInfo.__name__ = ["com","isartdigital","perle","game","TimesInfo"];
com_isartdigital_perle_game_TimesInfo.getClock = function(pTime) {
	var currentHou = Math.floor(pTime / 3600000);
	var currentMin = Math.floor((pTime - currentHou * 3600000) / 60000);
	var currentSec = Math.floor((pTime - currentMin * 60000) / 1000);
	return { houre : currentHou < 10?"0" + currentHou:"" + currentHou, minute : currentMin < 10?"0" + currentMin:"" + currentMin, seconde : currentSec < 10?"0" + currentSec:"" + currentSec};
};
var com_isartdigital_perle_game_iso_IZSortable = function() { };
$hxClasses["com.isartdigital.perle.game.iso.IZSortable"] = com_isartdigital_perle_game_iso_IZSortable;
com_isartdigital_perle_game_iso_IZSortable.__name__ = ["com","isartdigital","perle","game","iso","IZSortable"];
com_isartdigital_perle_game_iso_IZSortable.prototype = {
	__class__: com_isartdigital_perle_game_iso_IZSortable
};
var com_isartdigital_perle_game_iso_IsoManager = function() { };
$hxClasses["com.isartdigital.perle.game.iso.IsoManager"] = com_isartdigital_perle_game_iso_IsoManager;
com_isartdigital_perle_game_iso_IsoManager.__name__ = ["com","isartdigital","perle","game","iso","IsoManager"];
com_isartdigital_perle_game_iso_IsoManager.init = function(pTileWidth,pTileHeight) {
	com_isartdigital_perle_game_iso_IsoManager.halfWidth = _$UInt_UInt_$Impl_$.toFloat(pTileWidth) / _$UInt_UInt_$Impl_$.toFloat(2);
	com_isartdigital_perle_game_iso_IsoManager.halfHeight = _$UInt_UInt_$Impl_$.toFloat(pTileHeight) / _$UInt_UInt_$Impl_$.toFloat(2);
};
com_isartdigital_perle_game_iso_IsoManager.modelToIsoView = function(pPoint) {
	return new PIXI.Point((pPoint.x - pPoint.y) * com_isartdigital_perle_game_iso_IsoManager.halfWidth,(pPoint.x + pPoint.y) * com_isartdigital_perle_game_iso_IsoManager.halfHeight);
};
com_isartdigital_perle_game_iso_IsoManager.isoViewToModel = function(pPoint) {
	return new PIXI.Point((pPoint.y / com_isartdigital_perle_game_iso_IsoManager.halfHeight + pPoint.x / com_isartdigital_perle_game_iso_IsoManager.halfWidth) / 2,(pPoint.y / com_isartdigital_perle_game_iso_IsoManager.halfHeight - pPoint.x / com_isartdigital_perle_game_iso_IsoManager.halfWidth) / 2);
};
com_isartdigital_perle_game_iso_IsoManager.isInFrontOf = function(pA,pB) {
	if(js_Boot.__instanceof(pA,com_isartdigital_utils_game_StateGraphic) && pA.boxType == com_isartdigital_utils_game_BoxType.NONE || js_Boot.__instanceof(pB,com_isartdigital_utils_game_StateGraphic) && pB.boxType == com_isartdigital_utils_game_BoxType.NONE) {
		throw new js__$Boot_HaxeError("IsoManager.isFrontOf :: la propriété boxType des StateGraphic ne doit pas être définie à NONE");
		return null;
	}
	if(!com_isartdigital_utils_game_CollisionManager.hitTestObject(pA,pB)) return null;
	if(!js_Boot.__instanceof(pA,com_isartdigital_perle_game_iso_IZSortable) || !js_Boot.__instanceof(pB,com_isartdigital_perle_game_iso_IZSortable)) throw new js__$Boot_HaxeError("Les objets passés en paramètre doivent implémenter IZSortable");
	var lA;
	lA = js_Boot.__cast(pA , com_isartdigital_perle_game_iso_IZSortable);
	var lB;
	lB = js_Boot.__cast(pB , com_isartdigital_perle_game_iso_IZSortable);
	if(lA.rowMax <= lB.rowMin) return pB; else if(lB.rowMax <= lA.rowMin) return pA;
	if(lA.colMax <= lB.colMin) return pB; else if(lB.colMax <= lA.colMin) return pA;
	return null;
};
com_isartdigital_perle_game_iso_IsoManager.sortTiles = function(pTiles) {
	var lNumTiles = pTiles.length;
	var lTile;
	var _g = 0;
	while(_g < lNumTiles) {
		var i = _g++;
		lTile = js_Boot.__cast(pTiles[i] , com_isartdigital_perle_game_iso_IZSortable);
		lTile.behind = [];
		lTile.inFront = [];
	}
	var lA;
	var lB;
	var lFrontTile;
	var _g1 = 0;
	while(_g1 < lNumTiles) {
		var i1 = _g1++;
		lA = js_Boot.__cast(pTiles[i1] , com_isartdigital_perle_game_iso_IZSortable);
		var _g11 = i1 + 1;
		while(_g11 < lNumTiles) {
			var j = _g11++;
			lB = js_Boot.__cast(pTiles[j] , com_isartdigital_perle_game_iso_IZSortable);
			lFrontTile = com_isartdigital_perle_game_iso_IsoManager.isInFrontOf(pTiles[i1],pTiles[j]);
			if(lFrontTile != null) {
				if(lA == js_Boot.__cast(lFrontTile , com_isartdigital_perle_game_iso_IZSortable)) {
					lA.behind.push(lB);
					lB.inFront.push(lA);
				} else {
					lB.behind.push(lA);
					lA.inFront.push(lB);
				}
			}
		}
	}
	var lToDraw = [];
	var _g2 = 0;
	while(_g2 < lNumTiles) {
		var i2 = _g2++;
		lTile = js_Boot.__cast(pTiles[i2] , com_isartdigital_perle_game_iso_IZSortable);
		if(lTile.behind.length == 0) lToDraw.push(lTile);
	}
	var lTilesDrawn = [];
	var lFrontTile1;
	while(lToDraw.length > 0) {
		lTile = lToDraw.pop();
		lTilesDrawn.push(js_Boot.__cast(lTile , PIXI.DisplayObject));
		var _g12 = 0;
		var _g3 = lTile.inFront.length;
		while(_g12 < _g3) {
			var j1 = _g12++;
			lFrontTile1 = lTile.inFront[j1];
			HxOverrides.remove(lFrontTile1.behind,lTile);
			if(lFrontTile1.behind.length == 0) lToDraw.push(lFrontTile1);
		}
	}
	if(pTiles.length != lTilesDrawn.length) com_isartdigital_utils_Debug.error("Probable error whit colMax/colMin/rowMax/rowMin assignment ! " + "entering container length : " + pTiles.length + " . returning container length : " + lTilesDrawn.length);
	return lTilesDrawn;
};
var com_isartdigital_perle_game_managers_BoostManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.BoostManager"] = com_isartdigital_perle_game_managers_BoostManager;
com_isartdigital_perle_game_managers_BoostManager.__name__ = ["com","isartdigital","perle","game","managers","BoostManager"];
com_isartdigital_perle_game_managers_BoostManager.awake = function() {
<<<<<<< HEAD:bin/ui.js
	com_isartdigital_perle_game_managers_BoostManager.boostAltarEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_BoostManager.boostBuildingEvent = new EventEmitter();
=======
	com_isartdigital_perle_game_managers_BoostManager.boostEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_BoostManager.quantityBoost = new haxe_ds_EnumValueMap();
	{
		com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(com_isartdigital_perle_game_managers_Alignment.heaven,0);
		0;
	}
	{
		com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(com_isartdigital_perle_game_managers_Alignment.hell,0);
		0;
	}
	{
		com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(com_isartdigital_perle_game_managers_Alignment.neutral,0);
		0;
	}
};
com_isartdigital_perle_game_managers_BoostManager.callEvent = function(pType) {
	var _g = pType;
	var v = com_isartdigital_perle_game_managers_BoostManager.quantityBoost.get(_g) + 4;
	com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(_g,v);
	v;
	if(pType == com_isartdigital_perle_game_managers_Alignment.heaven) {
		var v1 = Math.max(com_isartdigital_perle_game_managers_BoostManager.quantityBoost.get(com_isartdigital_perle_game_managers_Alignment.hell) - 1,0);
		com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(com_isartdigital_perle_game_managers_Alignment.hell,v1);
		v1;
	}
	if(pType == com_isartdigital_perle_game_managers_Alignment.hell) {
		var v2 = Math.max(com_isartdigital_perle_game_managers_BoostManager.quantityBoost.get(com_isartdigital_perle_game_managers_Alignment.heaven) - 1,0);
		com_isartdigital_perle_game_managers_BoostManager.quantityBoost.set(com_isartdigital_perle_game_managers_Alignment.heaven,v2);
		v2;
	}
	com_isartdigital_perle_game_managers_BoostManager.boostEvent.emit("BOOST");
>>>>>>> btn accelerate working:bin/Builder.js
};
com_isartdigital_perle_game_managers_BoostManager.altarCheckIfHasBuilding = function(regionPos,casePos) {
	com_isartdigital_perle_game_managers_BoostManager.boostAltarEvent.emit("ALTAR_CALL",{ casePos : casePos, regionPos : regionPos});
};
com_isartdigital_perle_game_managers_BoostManager.buildingIsInAltarZone = function(regionPos,casePos,pRef,pType) {
	com_isartdigital_perle_game_managers_BoostManager.boostBuildingEvent.emit("BUILDING_CALL",{ casePos : casePos, regionPos : regionPos, buildingRef : pRef, type : pType});
};
var com_isartdigital_perle_game_managers_BuyManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.BuyManager"] = com_isartdigital_perle_game_managers_BuyManager;
com_isartdigital_perle_game_managers_BuyManager.__name__ = ["com","isartdigital","perle","game","managers","BuyManager"];
com_isartdigital_perle_game_managers_BuyManager.initClass = function() {
	com_isartdigital_perle_game_managers_BuyManager.parseJson();
};
com_isartdigital_perle_game_managers_BuyManager.buy = function(pBuildingName) {
	if(!com_isartdigital_perle_game_managers_BuyManager.checkBuildingName(pBuildingName)) return true;
	if(com_isartdigital_perle_game_managers_BuyManager.canBuy(pBuildingName)) {
		com_isartdigital_perle_game_managers_ResourcesManager.spendTotal(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).type,com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).price);
		return true;
	}
	return false;
};
com_isartdigital_perle_game_managers_BuyManager.sell = function(pBuildingName) {
	com_isartdigital_perle_game_managers_ResourcesManager.spendTotal(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).type,-Math.ceil(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).price * com_isartdigital_perle_game_managers_BuyManager.buyPrice.refundRatioBuilded));
};
com_isartdigital_perle_game_managers_BuyManager.getSellPrice = function(pBuildingName) {
	return Math.ceil(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).price * com_isartdigital_perle_game_managers_BuyManager.buyPrice.refundRatioBuilded);
};
com_isartdigital_perle_game_managers_BuyManager.canBuy = function(pBuildingName) {
	if(!com_isartdigital_perle_game_managers_BuyManager.checkBuildingName(pBuildingName)) return true;
	return com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).type) >= com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pBuildingName).price;
};
com_isartdigital_perle_game_managers_BuyManager.checkPrice = function(pAssetName) {
	if(!com_isartdigital_perle_game_managers_BuyManager.checkBuildingName(pAssetName)) return 0;
	return com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pAssetName).price;
};
com_isartdigital_perle_game_managers_BuyManager.checkBuildingName = function(pAssetName) {
	if(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(pAssetName) == null) {
		com_isartdigital_utils_Debug.error("Assetname : '" + pAssetName + "' doesn't exist in buyprice json !");
		return false;
	}
	return true;
};
com_isartdigital_perle_game_managers_BuyManager.parseJson = function() {
	var lJson = com_isartdigital_utils_loader_GameLoader.getContent("json/" + "buy_price" + ".json");
	com_isartdigital_perle_game_managers_BuyManager.buyPrice = JSON.parse(JSON.stringify(lJson));
	com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets = new haxe_ds_StringMap();
	var fields = Reflect.fields(lJson.assets);
	var _g1 = 0;
	var _g = fields.length;
	while(_g1 < _g) {
		var i = _g1++;
		var v = Reflect.field(lJson.assets,fields[i]);
		com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.set(fields[i],v);
		v;
		com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(fields[i]).type = com_isartdigital_perle_game_managers_SaveManager.stringToEnum(js_Boot.__cast(com_isartdigital_perle_game_managers_BuyManager.buyPrice.assets.get(fields[i]).type , String));
	}
};
var com_isartdigital_perle_game_managers_CameraManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.CameraManager"] = com_isartdigital_perle_game_managers_CameraManager;
com_isartdigital_perle_game_managers_CameraManager.__name__ = ["com","isartdigital","perle","game","managers","CameraManager"];
com_isartdigital_perle_game_managers_CameraManager.placeCamera = function(pPos) {
	com_isartdigital_perle_game_managers_CameraManager.target.x -= com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(pPos).x;
	com_isartdigital_perle_game_managers_CameraManager.target.y -= com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(pPos).y;
};
com_isartdigital_perle_game_managers_CameraManager.move = function(pSpeedX,pSpeedY) {
	if(com_isartdigital_perle_ui_hud_Hud.isHide) return;
	var lRegionCenters = com_isartdigital_perle_game_managers_CameraManager.getRegionCenters();
	var lIndexRef = 0;
	if(lRegionCenters.length > 1) {
		var lPointRef = com_isartdigital_perle_game_managers_CameraManager.distancePToP(com_isartdigital_perle_game_managers_CameraManager.getCameraCenter(),lRegionCenters[0]);
		var _g1 = 0;
		var _g = lRegionCenters.length;
		while(_g1 < _g) {
			var i = _g1++;
			var lPoint = com_isartdigital_perle_game_managers_CameraManager.distancePToP(com_isartdigital_perle_game_managers_CameraManager.getCameraCenter(),lRegionCenters[i]);
			if(lPoint < lPointRef) {
				lPointRef = lPoint;
				lIndexRef = i;
			}
		}
	}
	com_isartdigital_perle_game_managers_CameraManager.defaultPos = lRegionCenters[lIndexRef];
	com_isartdigital_perle_game_managers_CameraManager.target.x += pSpeedX;
	com_isartdigital_perle_game_managers_CameraManager.target.y += pSpeedY;
	var lCurrentPosCamera = com_isartdigital_perle_game_managers_CameraManager.getCameraCenter();
	if(lCurrentPosCamera.x > com_isartdigital_perle_game_managers_CameraManager.defaultPos.x + 2400. / 2 + 400.) com_isartdigital_perle_game_managers_CameraManager.target.x -= pSpeedX;
	if(lCurrentPosCamera.x < com_isartdigital_perle_game_managers_CameraManager.defaultPos.x - 2400. / 2 - 400.) com_isartdigital_perle_game_managers_CameraManager.target.x -= pSpeedX;
	if(lCurrentPosCamera.y > com_isartdigital_perle_game_managers_CameraManager.defaultPos.y + 1200. / 2 + 200.) com_isartdigital_perle_game_managers_CameraManager.target.y -= pSpeedY;
	if(lCurrentPosCamera.y < com_isartdigital_perle_game_managers_CameraManager.defaultPos.y - 1200. / 2 - 200.) com_isartdigital_perle_game_managers_CameraManager.target.y -= pSpeedY;
	var lSpeed = new PIXI.Point(pSpeedX,pSpeedY);
	com_isartdigital_perle_game_managers_CameraManager.checkClippingNeed(lSpeed);
};
com_isartdigital_perle_game_managers_CameraManager.distancePToP = function(pP1,pP2) {
	return Math.sqrt((pP2.x - pP1.x) * (pP2.x - pP1.x) + (pP2.y - pP1.y) * (pP2.y - pP1.y));
};
com_isartdigital_perle_game_managers_CameraManager.getCameraCenter = function() {
	return com_isartdigital_perle_game_managers_CameraManager.target.toLocal(new PIXI.Point(com_isartdigital_perle_Main.getInstance().renderer.width / 2,com_isartdigital_perle_Main.getInstance().renderer.height / 2));
};
com_isartdigital_perle_game_managers_CameraManager.getCameraRect = function() {
	return { topLeft : com_isartdigital_perle_game_managers_CameraManager.target.toLocal(new PIXI.Point(0,0)), bottomRight : com_isartdigital_perle_game_managers_CameraManager.target.toLocal(new PIXI.Point(com_isartdigital_perle_Main.getInstance().renderer.width,com_isartdigital_perle_Main.getInstance().renderer.height))};
};
com_isartdigital_perle_game_managers_CameraManager.setTarget = function(pContainer) {
	com_isartdigital_perle_game_managers_CameraManager.target = pContainer;
	com_isartdigital_perle_game_managers_CameraManager.reset();
};
com_isartdigital_perle_game_managers_CameraManager.reset = function() {
	com_isartdigital_perle_game_managers_CameraManager.xDistMoved = 0;
	com_isartdigital_perle_game_managers_CameraManager.yDistMoved = 0;
};
com_isartdigital_perle_game_managers_CameraManager.getRegionCenters = function() {
	var lMap = com_isartdigital_perle_game_managers_RegionManager.worldMap;
	var lRegionCenters = [];
	var $it0 = lMap.keys();
	while( $it0.hasNext() ) {
		var row = $it0.next();
		var $it1 = (function($this) {
			var $r;
			var this1 = lMap.h[row];
			$r = this1.keys();
			return $r;
		}(this));
		while( $it1.hasNext() ) {
			var region = $it1.next();
			var lPoint = com_isartdigital_perle_game_managers_CameraManager.getCameraCenter();
			if(com_isartdigital_perle_game_managers_CameraManager.hitTestRegion(lPoint,(function($this) {
				var $r;
				var this2 = lMap.h[row];
				$r = this2.get(region);
				return $r;
			}(this)))) {
				var lPos = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(((function($this) {
					var $r;
					var this3 = lMap.h[row];
					$r = this3.get(region);
					return $r;
				}(this))).desc.firstTilePos.x,((function($this) {
					var $r;
					var this4 = lMap.h[row];
					$r = this4.get(region);
					return $r;
				}(this))).desc.firstTilePos.y));
				if(((function($this) {
					var $r;
					var this5 = lMap.h[row];
					$r = this5.get(region);
					return $r;
				}(this))).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lRegionCenters.push(new PIXI.Point(lPos.x + 200 * (1.5 - -1000. / 2),lPos.y + -1000. / 2)); else lRegionCenters.push(new PIXI.Point(lPos.x,lPos.y + 1200. / 2));
			}
		}
	}
	return lRegionCenters;
};
com_isartdigital_perle_game_managers_CameraManager.extendLimits = function(pRegion,pPoint) {
	return true;
};
com_isartdigital_perle_game_managers_CameraManager.hitTestRegion = function(pPoint,pRegion) {
	var lPX = pPoint.x;
	var lPY = pPoint.y;
	var lWidth = 2400. + 400.;
	var lHeight = 1200. + 200.;
	var lWidthStyx = -1000. + 400.;
	var lHeightStyx = -1000. + 200.;
	var lWidthTest;
	var lHeightTest;
	var lPosRegion = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(pRegion.desc.firstTilePos.x,pRegion.desc.firstTilePos.y));
	var lX;
	var lY;
	if(pRegion.desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lX = lPosRegion.x + 200 * (1.5 - -1000. / 2); else {
		lWidthTest = lWidth;
		lHeightTest = lHeight;
		lX = lPosRegion.x;
	}
	lWidthTest = lWidth;
	lHeightTest = lHeight;
	if(lPX >= lX - lWidthTest / 2 - 400. && lPX <= lX + lWidthTest / 2 + 400.) {
		lY = lPosRegion.y - 200.;
		if(lPY >= lY && lPY <= lY + lHeightTest + 400.) return true;
	}
	return false;
};
com_isartdigital_perle_game_managers_CameraManager.checkClippingNeed = function(pSpeed) {
	if(com_isartdigital_perle_game_managers_CameraManager.cheat_no_clipping) return;
	var doUpdate = false;
	com_isartdigital_perle_game_managers_CameraManager.xDistMoved += pSpeed.x;
	com_isartdigital_perle_game_managers_CameraManager.yDistMoved += pSpeed.y;
	if(Math.abs(com_isartdigital_perle_game_managers_CameraManager.xDistMoved) > 200) {
		com_isartdigital_perle_game_managers_CameraManager.xDistMoved = 0;
		doUpdate = true;
	}
	if(Math.abs(com_isartdigital_perle_game_managers_CameraManager.yDistMoved) > 100) {
		com_isartdigital_perle_game_managers_CameraManager.yDistMoved = 0;
		doUpdate = true;
	}
	if(doUpdate) com_isartdigital_perle_game_managers_ClippingManager.update();
};
com_isartdigital_perle_game_managers_CameraManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_CameraManager
};
var com_isartdigital_perle_game_managers_ClippingManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.ClippingManager"] = com_isartdigital_perle_game_managers_ClippingManager;
com_isartdigital_perle_game_managers_ClippingManager.__name__ = ["com","isartdigital","perle","game","managers","ClippingManager"];
com_isartdigital_perle_game_managers_ClippingManager.update = function(pFullScreen) {
	if(pFullScreen == null) pFullScreen = false;
	com_isartdigital_perle_game_managers_ClippingManager.setCameraMapClipRect();
	com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect = { left : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.cameraMapRect.topLeft.x - 18 , Int), right : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.cameraMapRect.bottomRight.x + 18 , Int), top : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.cameraMapRect.topLeft.y - 12 , Int), bottom : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.cameraMapRect.bottomRight.y + 12 , Int)};
	if(com_isartdigital_perle_game_managers_ClippingManager.precedentCameraClipRect == null) com_isartdigital_perle_game_managers_ClippingManager.activateCells(com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect); else {
		com_isartdigital_perle_game_managers_ClippingManager.commonCameraClipRect = com_isartdigital_perle_game_managers_ClippingManager.getCommonArea(com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect,com_isartdigital_perle_game_managers_ClippingManager.precedentCameraClipRect);
		if(!com_isartdigital_perle_game_managers_ClippingManager.cheat_do_clipping_start_only) {
			if(!pFullScreen) {
				com_isartdigital_perle_game_managers_ClippingManager.optimizedClipping(com_isartdigital_perle_game_managers_ClippingManager.desactivateCells,com_isartdigital_perle_game_managers_ClippingManager.precedentCameraClipRect,com_isartdigital_perle_game_managers_ClippingManager.commonCameraClipRect);
				com_isartdigital_perle_game_managers_ClippingManager.optimizedClipping(com_isartdigital_perle_game_managers_ClippingManager.activateCells,com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect,com_isartdigital_perle_game_managers_ClippingManager.commonCameraClipRect);
			} else {
				com_isartdigital_perle_game_managers_ClippingManager.desactivateCells(com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect);
				com_isartdigital_perle_game_managers_ClippingManager.activateCells(com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect);
			}
		}
	}
	com_isartdigital_perle_game_sprites_Building.sortBuildings();
	com_isartdigital_perle_game_managers_ClippingManager.precedentCameraClipRect = com_isartdigital_perle_game_managers_ClippingManager.currentCameraClipRect;
};
com_isartdigital_perle_game_managers_ClippingManager.activateCells = function(pClippingRect) {
	com_isartdigital_perle_game_managers_ClippingManager.loopCells(pClippingRect,com_isartdigital_perle_game_virtual_VTile.clippingMap,true);
};
com_isartdigital_perle_game_managers_ClippingManager.desactivateCells = function(pClippingRect) {
	com_isartdigital_perle_game_managers_ClippingManager.loopCells(pClippingRect,com_isartdigital_perle_game_virtual_VTile.clippingMap,false);
};
com_isartdigital_perle_game_managers_ClippingManager.loopCells = function(pClippingRect,pClippingMap,pActivate) {
	var _g1 = pClippingRect.left;
	var _g = pClippingRect.right;
	while(_g1 < _g) {
		var x = _g1++;
		var _g3 = pClippingRect.top;
		var _g2 = pClippingRect.bottom;
		while(_g3 < _g2) {
			var y = _g3++;
			if(pClippingMap.h[x] != null && (function($this) {
				var $r;
				var this1 = pClippingMap.h[x];
				$r = this1.get(y);
				return $r;
			}(this)) != null) {
				var lLength;
				lLength = ((function($this) {
					var $r;
					var this2 = pClippingMap.h[x];
					$r = this2.get(y);
					return $r;
				}(this))).length;
				var _g4 = 0;
				while(_g4 < lLength) {
					var i = _g4++;
					if(((function($this) {
						var $r;
						var this3 = pClippingMap.h[x];
						$r = this3.get(y);
						return $r;
					}(this)))[i].active != pActivate && !((function($this) {
						var $r;
						var this4 = pClippingMap.h[x];
						$r = this4.get(y);
						return $r;
					}(this)))[i].ignore) {
						if(pActivate) ((function($this) {
							var $r;
							var this5 = pClippingMap.h[x];
							$r = this5.get(y);
							return $r;
						}(this)))[i].activate(); else ((function($this) {
							var $r;
							var this6 = pClippingMap.h[x];
							$r = this6.get(y);
							return $r;
						}(this)))[i].desactivate();
					}
				}
			}
		}
	}
};
com_isartdigital_perle_game_managers_ClippingManager.optimizedClipping = function(pFunction,pClipRect,pClipRectIgnore) {
	var commonSides = com_isartdigital_perle_game_managers_ClippingManager.getCommonSides(pClipRect,pClipRectIgnore);
	if(commonSides.top && !commonSides.bottom) pFunction({ left : pClipRect.left, right : pClipRect.right, top : pClipRectIgnore.bottom, bottom : pClipRect.bottom});
	if(commonSides.bottom && !commonSides.top) pFunction({ left : pClipRect.left, right : pClipRect.right, top : pClipRect.top, bottom : pClipRectIgnore.top});
	if(commonSides.left && !commonSides.right) pFunction({ left : pClipRectIgnore.right, right : pClipRect.right, top : pClipRect.top, bottom : pClipRect.bottom});
	if(commonSides.right && !commonSides.left) pFunction({ left : pClipRect.left, right : pClipRectIgnore.left, top : pClipRect.top, bottom : pClipRect.bottom});
};
com_isartdigital_perle_game_managers_ClippingManager.getCommonSides = function(pClipRect,pClipRectIgnore) {
	return { top : pClipRect.top == pClipRectIgnore.top, bottom : pClipRect.bottom == pClipRectIgnore.bottom, left : pClipRect.left == pClipRectIgnore.left, right : pClipRect.right == pClipRectIgnore.right};
};
com_isartdigital_perle_game_managers_ClippingManager.getCommonArea = function(p1ClipRect,p2ClipRect) {
	return { left : p1ClipRect.left > p2ClipRect.left?p1ClipRect.left:p2ClipRect.left, right : p1ClipRect.right < p2ClipRect.right?p1ClipRect.right:p2ClipRect.right, top : p1ClipRect.top > p2ClipRect.top?p1ClipRect.top:p2ClipRect.top, bottom : p1ClipRect.bottom < p2ClipRect.bottom?p1ClipRect.bottom:p2ClipRect.bottom};
};
com_isartdigital_perle_game_managers_ClippingManager.posToClippingMap = function(pPoint) {
	if(Math.round(pPoint.x) != pPoint.x || Math.round(pPoint.y) != pPoint.y) throw new js__$Boot_HaxeError("Position x,y est un chiffre à virgule, n'est pas une Tile ? pas supporté pr l'instant !");
	return new PIXI.Point(js_Boot.__cast(pPoint.x / 25. , Int),js_Boot.__cast(pPoint.y / 50. , Int));
};
com_isartdigital_perle_game_managers_ClippingManager.setCameraMapClipRect = function() {
	var lCameraRect = com_isartdigital_perle_game_managers_CameraManager.getCameraRect();
	lCameraRect.topLeft.x = com_isartdigital_perle_game_managers_ClippingManager.customFloor(lCameraRect.topLeft.x,200);
	lCameraRect.topLeft.y = com_isartdigital_perle_game_managers_ClippingManager.customFloor(lCameraRect.topLeft.y,100);
	lCameraRect.bottomRight.x = com_isartdigital_perle_game_managers_ClippingManager.customCeil(lCameraRect.bottomRight.x,200);
	lCameraRect.bottomRight.y = com_isartdigital_perle_game_managers_ClippingManager.customCeil(lCameraRect.bottomRight.y,100);
	com_isartdigital_perle_game_managers_ClippingManager.cameraMapRect = { topLeft : com_isartdigital_perle_game_managers_ClippingManager.posToClippingMap(lCameraRect.topLeft), bottomRight : com_isartdigital_perle_game_managers_ClippingManager.posToClippingMap(lCameraRect.bottomRight)};
};
com_isartdigital_perle_game_managers_ClippingManager.customFloor = function(pNumber,pFloorFactor) {
	if(pFloorFactor == null) pFloorFactor = 1;
	return pFloorFactor * Math.floor(pNumber / pFloorFactor);
};
com_isartdigital_perle_game_managers_ClippingManager.customCeil = function(pNumber,pCeilFactor) {
	if(pCeilFactor == null) pCeilFactor = 1;
	return pCeilFactor * Math.ceil(pNumber / pCeilFactor);
};
com_isartdigital_perle_game_managers_ClippingManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_ClippingManager
};
var com_isartdigital_perle_game_managers_DialogueManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.DialogueManager"] = com_isartdigital_perle_game_managers_DialogueManager;
com_isartdigital_perle_game_managers_DialogueManager.__name__ = ["com","isartdigital","perle","game","managers","DialogueManager"];
com_isartdigital_perle_game_managers_DialogueManager.init = function(pFTUE) {
	com_isartdigital_perle_game_managers_DialogueManager.steps = pFTUE.steps;
	com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue = [];
	com_isartdigital_perle_game_managers_DialogueManager.parseJsonFtue("json/" + "dialogue_ftue");
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.numberOfDialogue = com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue.length;
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.firstToSpeak = com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[0][0][0];
};
com_isartdigital_perle_game_managers_DialogueManager.createFtue = function() {
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress > com_isartdigital_perle_game_managers_DialogueManager.steps.length - 1) {
		return;
	}
<<<<<<< HEAD
	com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved = 0;
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress != null) {
		com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved = com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress;
	} else {
		com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved = 0;
	}
	com_isartdigital_perle_game_managers_DialogueManager.nextStep();
};
com_isartdigital_perle_game_managers_DialogueManager.createTextDialogue = function(pNumber,pNpc) {
	if(!com_isartdigital_perle_game_managers_DialogueManager.closeDialoguePoppin) {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance());
		com_isartdigital_perle_ui_hud_Hud.getInstance().hide();
		com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance().open();
	}
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance().createText(pNumber,pNpc);
};
com_isartdigital_perle_game_managers_DialogueManager.register = function(pTarget) {
	if(com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved >= com_isartdigital_perle_game_managers_DialogueManager.steps.length || pTarget.parent == null) {
		return;
	}
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_DialogueManager.steps.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(pTarget.name == com_isartdigital_perle_game_managers_DialogueManager.steps[i].name && pTarget.parent.name == com_isartdigital_perle_game_managers_DialogueManager.steps[i].parentName) {
			com_isartdigital_perle_game_managers_DialogueManager.steps[i].item = pTarget;
			if(js_Boot.__instanceof(pTarget,com_isartdigital_utils_ui_smart_SmartButton)) {
				(js_Boot.__cast(pTarget , com_isartdigital_utils_ui_smart_SmartButton)).on("click",com_isartdigital_perle_game_managers_DialogueManager.endOfStep);
			}
		}
	}
};
com_isartdigital_perle_game_managers_DialogueManager.nextStep = function(pTarget) {
	if(com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved >= com_isartdigital_perle_game_managers_DialogueManager.steps.length) {
		return;
	}
	com_isartdigital_perle_ui_UIManager.getInstance().openFTUE();
	if(com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved == 0 || com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].npcWhoTalk != null) {
		if(pTarget != null) {
			return;
		}
		com_isartdigital_perle_game_managers_DialogueManager.createTextDialogue(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].dialogueNumber,com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].npcWhoTalk);
	} else if(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].arrowRotation != null) {
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance().setFocus(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].item,com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].arrowRotation);
	} else {
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance().setFocus(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].item,90);
	}
};
com_isartdigital_perle_game_managers_DialogueManager.endOfaDialogue = function() {
	if(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved + 1].npcWhoTalk != null) {
		com_isartdigital_perle_game_managers_DialogueManager.closeDialoguePoppin = false;
	} else {
		com_isartdigital_perle_game_managers_DialogueManager.closeDialoguePoppin = true;
		com_isartdigital_perle_game_managers_DialogueManager.removeDialogue();
	}
	com_isartdigital_perle_game_managers_DialogueManager.endOfStep();
};
com_isartdigital_perle_game_managers_DialogueManager.endOfStep = function() {
	if(js_Boot.__instanceof(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].item,com_isartdigital_utils_ui_smart_SmartButton)) {
		(js_Boot.__cast(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].item , com_isartdigital_utils_ui_smart_SmartButton)).off("click",com_isartdigital_perle_game_managers_DialogueManager.endOfStep);
		com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved].item = null;
	}
	if(com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved == com_isartdigital_perle_game_managers_DialogueManager.steps.length - 1) {
		js_Browser.alert("fin de la FTUE");
	} else {
		console.log("fin d'etape " + com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved);
	}
	com_isartdigital_perle_ui_UIManager.getInstance().closeFTUE();
	com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved++;
	if(com_isartdigital_perle_game_managers_DialogueManager.steps[com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved - 1].checkpoint) {
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	com_isartdigital_perle_game_managers_DialogueManager.nextStep();
=======
	com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance());
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress != null) com_isartdigital_perle_ui_hud_dialogue_DialogueUI.actualDialogue = com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress; else com_isartdigital_perle_ui_hud_dialogue_DialogueUI.actualDialogue = 0;
	com_isartdigital_perle_ui_hud_Hud.getInstance().hide();
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.firstToSpeak = com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[0][0][0];
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance().open();
	com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance().createText();
>>>>>>> btn accelerate working
};
com_isartdigital_perle_game_managers_DialogueManager.parseJsonFtue = function(pJsonName) {
	var jsonFtue = com_isartdigital_utils_loader_GameLoader.getContent(pJsonName + ".json");
	var i = 0;
	var _g = 0;
	var _g1 = Reflect.fields(jsonFtue);
	while(_g < _g1.length) {
		var dialogue = _g1[_g];
		++_g;
		com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[i] = [];
		var ldialogue = Reflect.field(jsonFtue,dialogue);
		var lArray = ldialogue;
		com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[i].push(lArray);
		i++;
	}
};
com_isartdigital_perle_game_managers_DialogueManager.removeDialogue = function() {
	com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().removeChild(com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance());
};
var com_isartdigital_perle_game_managers_ExperienceManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.ExperienceManager"] = com_isartdigital_perle_game_managers_ExperienceManager;
com_isartdigital_perle_game_managers_ExperienceManager.__name__ = ["com","isartdigital","perle","game","managers","ExperienceManager"];
com_isartdigital_perle_game_managers_ExperienceManager.setExpToLevelUp = function() {
	com_isartdigital_perle_game_managers_ExperienceManager.experienceToLevelUpArray = [];
	com_isartdigital_perle_game_managers_ExperienceManager.parseJsonLevel("json/" + "experience");
};
com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp = function(pLevel) {
	return com_isartdigital_perle_game_managers_ExperienceManager.experienceToLevelUpArray[pLevel - 1];
};
com_isartdigital_perle_game_managers_ExperienceManager.parseJsonLevel = function(pJsonName) {
	var jsonExp = com_isartdigital_utils_loader_GameLoader.getContent(pJsonName + ".json");
	var _g = 0;
	var _g1 = Reflect.fields(jsonExp);
	while(_g < _g1.length) {
		var level = _g1[_g];
		++_g;
		com_isartdigital_perle_game_managers_ExperienceManager.experienceToLevelUpArray.push(Reflect.field(jsonExp,level));
	}
};
var com_isartdigital_perle_game_managers_FakeTraduction = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.FakeTraduction"] = com_isartdigital_perle_game_managers_FakeTraduction;
com_isartdigital_perle_game_managers_FakeTraduction.__name__ = ["com","isartdigital","perle","game","managers","FakeTraduction"];
com_isartdigital_perle_game_managers_FakeTraduction.assetNameNameToTrad = function(pBuildingName) {
	return pBuildingName;
};
com_isartdigital_perle_game_managers_FakeTraduction.prototype = {
	__class__: com_isartdigital_perle_game_managers_FakeTraduction
};
var com_isartdigital_perle_game_managers_IdManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.IdManager"] = com_isartdigital_perle_game_managers_IdManager;
com_isartdigital_perle_game_managers_IdManager.__name__ = ["com","isartdigital","perle","game","managers","IdManager"];
com_isartdigital_perle_game_managers_IdManager.buildWhitoutSave = function() {
	com_isartdigital_perle_game_managers_IdManager.idHightest = 0;
};
com_isartdigital_perle_game_managers_IdManager.buildFromSave = function(pSave) {
	com_isartdigital_perle_game_managers_IdManager.idHightest = pSave.idHightest;
};
com_isartdigital_perle_game_managers_IdManager.newId = function() {
	return ++com_isartdigital_perle_game_managers_IdManager.idHightest;
};
com_isartdigital_perle_game_managers_IdManager.searchById = function(pId,pSave) {
	var result = null;
	var lLength = pSave.building.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		if(pSave.building[i].id == pId && result == null) result = pSave.building[i]; else throw new js__$Boot_HaxeError("duplicated id : " + pId);
	}
	lLength = pSave.ground.length;
	var _g1 = 0;
	while(_g1 < lLength) {
		var i1 = _g1++;
		if(pSave.ground[i1].id == pId && result == null) result = pSave.ground[i1]; else throw new js__$Boot_HaxeError("duplicated id : " + pId);
	}
	return result;
};
com_isartdigital_perle_game_managers_IdManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_IdManager
};
var com_isartdigital_perle_game_managers_MouseManager = function() {
	this.oneFrameHack = false;
	this.precedentFrame = false;
	this.precedentMousePos = new PIXI.Point();
	this.mouseTouchDown = false;
	this.touchGlobalPos = new PIXI.Point(0,0);
	this.desktop = false;
	this.positionInGame = new PIXI.Point(0,0);
	this.position = new PIXI.Point(0,0);
	this.init();
};
$hxClasses["com.isartdigital.perle.game.managers.MouseManager"] = com_isartdigital_perle_game_managers_MouseManager;
com_isartdigital_perle_game_managers_MouseManager.__name__ = ["com","isartdigital","perle","game","managers","MouseManager"];
com_isartdigital_perle_game_managers_MouseManager.getInstance = function() {
	if(com_isartdigital_perle_game_managers_MouseManager.instance == null) com_isartdigital_perle_game_managers_MouseManager.instance = new com_isartdigital_perle_game_managers_MouseManager();
	return com_isartdigital_perle_game_managers_MouseManager.instance;
};
com_isartdigital_perle_game_managers_MouseManager.prototype = {
	getLocalMouseMapPos: function() {
		return com_isartdigital_perle_game_iso_IsoManager.isoViewToModel(this.getLocalPos(com_isartdigital_perle_game_sprites_Ground.container));
	}
	,getLocalPos: function(pContainer) {
		return pContainer.toLocal(this.position);
	}
	,init: function() {
		this.desktop = com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop";
		if(this.desktop) {
			window.addEventListener("mouseup",$bind(this,this.onMouseTouchUp));
			window.addEventListener("mousedown",$bind(this,this.onMouseDown));
		} else {
			window.addEventListener("touchend",$bind(this,this.onMouseTouchUp));
			window.addEventListener("touchstart",$bind(this,this.onTouchDown));
			window.addEventListener("touchmove",$bind(this,this.onTouchMove));
		}
	}
	,gameLoop: function() {
		if(this.desktop) this.position = this.getMouseGlobalPos(); else this.position = this.touchGlobalPos;
		this.positionInGame = this.getLocalPos(com_isartdigital_utils_game_GameStage.getInstance().getGameContainer());
		if(this.mouseTouchDown) this.moveGameContainer(this.positionInGame); else this.scrollOnLimitsScreen(this.positionInGame);
	}
	,moveGameContainer: function(pMouseLocalPos) {
		if(this.oneFrameHack) this.oneFrameHack = false; else {
			var lSoustract = this.soustractPoint(pMouseLocalPos,this.precedentMousePos);
			if(lSoustract.x != 0 || lSoustract.y != 0) com_isartdigital_perle_game_managers_CameraManager.move(lSoustract.x,lSoustract.y);
		}
		this.precedentMousePos.copy(this.getLocalPos(com_isartdigital_utils_game_GameStage.getInstance().getGameContainer()));
	}
	,scrollOnLimitsScreen: function(pMouseLocalPos) {
		var cameraCenter = com_isartdigital_perle_game_managers_CameraManager.getCameraCenter();
		var lLimitLeftR = cameraCenter.x - com_isartdigital_perle_Main.getInstance().renderer.width + 100;
		var lLimitLeftL = cameraCenter.x - com_isartdigital_perle_Main.getInstance().renderer.width;
		var lLimitRightL = cameraCenter.x + com_isartdigital_perle_Main.getInstance().renderer.width - 100;
		var lLimitRightR = cameraCenter.x + com_isartdigital_perle_Main.getInstance().renderer.width;
		var lLimitTopB = cameraCenter.y - com_isartdigital_perle_Main.getInstance().renderer.height + 100;
		var lLimitTopT = cameraCenter.y - com_isartdigital_perle_Main.getInstance().renderer.height;
		var lLimitBottomT = cameraCenter.y + com_isartdigital_perle_Main.getInstance().renderer.height - 100;
		var lLimitBottomB = cameraCenter.y + com_isartdigital_perle_Main.getInstance().renderer.height;
		if(pMouseLocalPos.x < lLimitLeftR && pMouseLocalPos.x > lLimitLeftL) com_isartdigital_perle_game_managers_CameraManager.move(12,0);
		if(pMouseLocalPos.x > lLimitRightL && pMouseLocalPos.x < lLimitRightR) com_isartdigital_perle_game_managers_CameraManager.move(-12.,0);
		if(pMouseLocalPos.y < lLimitTopB && pMouseLocalPos.y > lLimitTopT) com_isartdigital_perle_game_managers_CameraManager.move(0,12);
		if(pMouseLocalPos.y > lLimitBottomT && pMouseLocalPos.y < lLimitBottomB) com_isartdigital_perle_game_managers_CameraManager.move(0,-12.);
		this.precedentMousePos.copy(this.getLocalPos(com_isartdigital_utils_game_GameStage.getInstance().getGameContainer()));
	}
	,onMouseDown: function(pEvent) {
		if(!com_isartdigital_perle_game_sprites_Phantom.isMoving()) {
			this.mouseTouchDown = true;
			this.precedentMousePos.copy(this.positionInGame);
		}
	}
	,onTouchDown: function(pEvent) {
		if(!com_isartdigital_perle_game_sprites_Phantom.isMoving()) {
			this.touchGlobalPos.set(pEvent.touches[0].pageX,pEvent.touches[0].pageY);
			this.mouseTouchDown = true;
			this.precedentMousePos.copy(this.positionInGame);
			this.oneFrameHack = true;
		}
	}
	,onMouseTouchUp: function() {
		this.mouseTouchDown = false;
	}
	,soustractPoint: function(pPoint1,pPoint2) {
		return new PIXI.Point(pPoint1.x - pPoint2.x,pPoint1.y - pPoint2.y);
	}
	,getMouseGlobalPos: function() {
		return (js_Boot.__cast(com_isartdigital_perle_Main.getInstance().renderer.plugins.interaction , PIXI.interaction.InteractionManager)).mouse.global;
	}
	,onTouchMove: function(pEvent) {
		this.touchGlobalPos.set(pEvent.touches[0].pageX,pEvent.touches[0].pageY);
	}
	,destroy: function() {
		window.removeEventListener("mouseup",$bind(this,this.onMouseTouchUp));
		window.removeEventListener("mousedown",$bind(this,this.onMouseDown));
		window.removeEventListener("touchend",$bind(this,this.onMouseTouchUp));
		window.removeEventListener("touchstart",$bind(this,this.onTouchDown));
		window.removeEventListener("touchmove",$bind(this,this.onTouchMove));
		com_isartdigital_perle_game_managers_MouseManager.instance = null;
	}
	,__class__: com_isartdigital_perle_game_managers_MouseManager
};
var com_isartdigital_perle_game_managers_PoolingManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.PoolingManager"] = com_isartdigital_perle_game_managers_PoolingManager;
com_isartdigital_perle_game_managers_PoolingManager.__name__ = ["com","isartdigital","perle","game","managers","PoolingManager"];
com_isartdigital_perle_game_managers_PoolingManager.init = function() {
	var $it0 = com_isartdigital_perle_game_managers_PoolingManager.INSTANCE_TO_SPAWN.keys();
	while( $it0.hasNext() ) {
		var lAssetName = $it0.next();
		var _g1 = 0;
		var _g = com_isartdigital_perle_game_managers_PoolingManager.INSTANCE_TO_SPAWN.get(lAssetName);
		while(_g1 < _g) {
			var i = _g1++;
			com_isartdigital_perle_game_managers_PoolingManager.createToPool(lAssetName);
		}
	}
};
com_isartdigital_perle_game_managers_PoolingManager.getFromPool = function(lAssetName) {
	if(com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName) == null) {
		console.log("missing " + lAssetName + " in poolArray");
		var v = [];
		com_isartdigital_perle_game_managers_PoolingManager.poolList.set(lAssetName,v);
		v;
	}
	if(com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName).length == 0) return com_isartdigital_perle_game_managers_PoolingManager.createInstance(lAssetName); else return com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName).shift();
};
com_isartdigital_perle_game_managers_PoolingManager.addToPool = function(pInstance,lAssetName) {
	if(com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName) == null) throw new js__$Boot_HaxeError(lAssetName + " doesn't exist in pool !");
	com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName).push(pInstance);
};
com_isartdigital_perle_game_managers_PoolingManager.createToPool = function(lAssetName) {
	if(com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName) == null) {
		var v = [];
		com_isartdigital_perle_game_managers_PoolingManager.poolList.set(lAssetName,v);
		v;
	}
	com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName).push(com_isartdigital_perle_game_managers_PoolingManager.createInstance(lAssetName));
};
com_isartdigital_perle_game_managers_PoolingManager.createInstance = function(lAssetName) {
	var lClassName = com_isartdigital_perle_game_managers_PoolingManager.ASSETNAME_TO_CLASS.get(lAssetName);
	if(lClassName == null) com_isartdigital_utils_Debug.error("Class for assetName : -- " + lAssetName + " -- wasn't found ! Check ASSETNAME_TO_CLASS");
	return Type.createInstance(Type.resolveClass(com_isartdigital_perle_Main.getInstance().getPath(lClassName)),[lAssetName]);
};
com_isartdigital_perle_game_managers_PoolingManager.destroy = function() {
	var $it0 = com_isartdigital_perle_game_managers_PoolingManager.poolList.keys();
	while( $it0.hasNext() ) {
		var lAssetName = $it0.next();
		var _g1 = 0;
		var _g = com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName).length;
		while(_g1 < _g) {
			var i = _g1++;
			com_isartdigital_perle_game_managers_PoolingManager.poolList.get(lAssetName)[i].destroy();
		}
	}
	com_isartdigital_perle_game_managers_PoolingManager.poolList = null;
};
com_isartdigital_perle_game_managers_PoolingManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_PoolingManager
};
var com_isartdigital_perle_game_managers_PoolingObject = function() { };
$hxClasses["com.isartdigital.perle.game.managers.PoolingObject"] = com_isartdigital_perle_game_managers_PoolingObject;
com_isartdigital_perle_game_managers_PoolingObject.__name__ = ["com","isartdigital","perle","game","managers","PoolingObject"];
com_isartdigital_perle_game_managers_PoolingObject.prototype = {
	__class__: com_isartdigital_perle_game_managers_PoolingObject
};
var com_isartdigital_perle_game_managers_QuestsManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.QuestsManager"] = com_isartdigital_perle_game_managers_QuestsManager;
com_isartdigital_perle_game_managers_QuestsManager.__name__ = ["com","isartdigital","perle","game","managers","QuestsManager"];
com_isartdigital_perle_game_managers_QuestsManager.initWithoutSave = function() {
	com_isartdigital_perle_game_managers_QuestsManager.questsList = [];
	com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.on("TimeManager_Quest_Step_Reached",com_isartdigital_perle_game_managers_QuestsManager.choice);
	com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.on("TimeManager_Resource_End_Reached",com_isartdigital_perle_game_managers_QuestsManager.endQuest);
};
com_isartdigital_perle_game_managers_QuestsManager.initWithSave = function(pDatasSaved) {
	com_isartdigital_perle_game_managers_QuestsManager.initWithoutSave();
	var lLength = pDatasSaved.timesQuest.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		com_isartdigital_perle_game_managers_QuestsManager.questsList.push(pDatasSaved.timesQuest[i]);
	}
};
com_isartdigital_perle_game_managers_QuestsManager.createQuest = function(pIdIntern) {
	var lIdTimer = pIdIntern;
	var lStepsArray = com_isartdigital_perle_game_managers_QuestsManager.createRandomGapArray();
	var lTimeQuestDescription = { refIntern : lIdTimer, progress : 0, steps : lStepsArray, stepIndex : 0, end : com_isartdigital_perle_game_managers_QuestsManager.createEnd(lStepsArray)};
	com_isartdigital_perle_game_managers_QuestsManager.questsList.push(lTimeQuestDescription);
	com_isartdigital_perle_game_managers_SaveManager.save();
	return lTimeQuestDescription;
};
com_isartdigital_perle_game_managers_QuestsManager.createRandomGapArray = function() {
	var lListEvents = [];
	var lGap = 0;
	var _g = 0;
	while(_g < 3) {
		var i = _g++;
		lGap = Math.floor(Math.random() * (com_isartdigital_perle_game_managers_QuestsManager.MAX_TIMELINE - com_isartdigital_perle_game_managers_QuestsManager.MIN_TIMELINE + 1)) + com_isartdigital_perle_game_managers_QuestsManager.MIN_TIMELINE + lGap;
		lListEvents.push(lGap);
	}
	return lListEvents;
};
com_isartdigital_perle_game_managers_QuestsManager.createEnd = function(pListEvents) {
	var lEnd = 0;
	var lLength = pListEvents.length - 1;
	lEnd = pListEvents[lLength];
	return lEnd;
};
com_isartdigital_perle_game_managers_QuestsManager.choice = function(pQuest) {
	com_isartdigital_perle_game_managers_QuestsManager.questInProgress = pQuest;
	com_isartdigital_perle_ui_hud_Hud.getInstance().hide();
	($_=com_isartdigital_perle_ui_UIManager.getInstance(),$bind($_,$_.closeCurrentPopin));
	com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_choice_Choice.getInstance());
};
com_isartdigital_perle_game_managers_QuestsManager.goToNextStep = function() {
	com_isartdigital_perle_ui_popin_choice_Choice.getInstance().hide();
	com_isartdigital_perle_game_managers_TimeManager.nextStepQuest(com_isartdigital_perle_game_managers_QuestsManager.questInProgress);
	com_isartdigital_perle_game_sprites_Intern.internsList.h[com_isartdigital_perle_game_managers_QuestsManager.questInProgress.refIntern].stress += 4;
};
com_isartdigital_perle_game_managers_QuestsManager.endQuest = function(pQuest) {
	console.log("end");
	com_isartdigital_perle_game_managers_QuestsManager.choice(pQuest);
	console.log(pQuest.refIntern);
	console.log(com_isartdigital_perle_game_sprites_Intern.internsList.toString());
	console.log(com_isartdigital_perle_game_sprites_Intern.internsList.h[pQuest.refIntern]);
	var lIntern = com_isartdigital_perle_game_sprites_Intern.internsList.h[pQuest.refIntern];
	if(lIntern.stress < lIntern.stressLimit) lIntern.quest = null; else {
		console.log("dismiss");
		lIntern.quest = null;
	}
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_sprites_Intern.internsListArray.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(pQuest.refIntern == com_isartdigital_perle_game_sprites_Intern.internsListArray[i].id) {
			if(com_isartdigital_perle_game_sprites_Intern.internsListArray[i].stress < com_isartdigital_perle_game_sprites_Intern.internsListArray[i].stressLimit) com_isartdigital_perle_game_sprites_Intern.internsListArray[i].quest = null; else {
				console.log("dismiss");
				($_=com_isartdigital_perle_ui_UIManager.getInstance(),$bind($_,$_.closeCurrentPopin));
				com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_listIntern_MaxStress.getInstance());
				lIntern.quest = null;
			}
		}
	}
	com_isartdigital_perle_game_managers_QuestsManager.destroyQuest(pQuest.refIntern);
	com_isartdigital_perle_game_managers_TimeManager.destroyTimeElement(pQuest.refIntern);
};
com_isartdigital_perle_game_managers_QuestsManager.getQuest = function(pId) {
	var lQuest = null;
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_QuestsManager.questsList.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(pId == com_isartdigital_perle_game_managers_QuestsManager.questsList[i].refIntern) lQuest = com_isartdigital_perle_game_managers_QuestsManager.questsList[i];
	}
	return lQuest;
};
com_isartdigital_perle_game_managers_QuestsManager.destroyQuest = function(pQuestId) {
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_QuestsManager.questsList.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(com_isartdigital_perle_game_managers_QuestsManager.questsList[i].refIntern == pQuestId) {
			console.log("destroy done");
			com_isartdigital_perle_game_managers_QuestsManager.questsList.splice(i,1);
		}
	}
};
com_isartdigital_perle_game_managers_QuestsManager.destroyAllQuests = function() {
	var lLength = com_isartdigital_perle_game_managers_QuestsManager.questsList.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		com_isartdigital_perle_game_managers_QuestsManager.questsList.splice(i,1);
	}
};
com_isartdigital_perle_game_managers_QuestsManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_QuestsManager
};
var com_isartdigital_perle_game_managers_RegionManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.RegionManager"] = com_isartdigital_perle_game_managers_RegionManager;
com_isartdigital_perle_game_managers_RegionManager.__name__ = ["com","isartdigital","perle","game","managers","RegionManager"];
com_isartdigital_perle_game_managers_RegionManager.init = function() {
	com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer = new PIXI.Container();
	com_isartdigital_perle_game_managers_RegionManager.bgContainer = new PIXI.Container();
	com_isartdigital_perle_game_managers_RegionManager.bgUnderContainer = new PIXI.Container();
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer);
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChildAt(com_isartdigital_perle_game_managers_RegionManager.bgContainer,0);
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChildAt(com_isartdigital_perle_game_managers_RegionManager.bgUnderContainer,0);
	com_isartdigital_perle_game_managers_RegionManager.worldMap = new haxe_ds_IntMap();
	com_isartdigital_perle_game_managers_RegionManager.buttonMap = new haxe_ds_IntMap();
	com_isartdigital_perle_game_managers_RegionManager.underMap = new haxe_ds_IntMap();
	com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion = new haxe_ds_EnumValueMap();
	com_isartdigital_perle_game_managers_RegionManager.baseXpGains = new haxe_ds_StringMap();
	com_isartdigital_perle_game_managers_RegionManager.xpFactors = [1.5,1.2];
	{
		com_isartdigital_perle_game_managers_RegionManager.baseXpGains.set("current",1500);
		1500;
	}
	{
		com_isartdigital_perle_game_managers_RegionManager.baseXpGains.set("other",500);
		500;
	}
	com_isartdigital_perle_game_managers_RegionManager.basePriceNearWater = 15000;
	com_isartdigital_perle_game_managers_RegionManager.basePriceFarWater = 10000;
	com_isartdigital_perle_game_managers_RegionManager.priceFactor = 1.2;
	{
		com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.set(com_isartdigital_perle_game_managers_Alignment.heaven,-1);
		-1;
	}
	{
		com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.set(com_isartdigital_perle_game_managers_Alignment.hell,-1);
		-1;
	}
	{
		com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.set(com_isartdigital_perle_game_managers_Alignment.neutral,0);
		0;
	}
};
com_isartdigital_perle_game_managers_RegionManager.addButton = function(pPos,pWorldPos,indice) {
<<<<<<< HEAD:bin/ui.js
	pPos = new PIXI.Point(pPos.x | 0,pPos.y | 0);
	pWorldPos = new PIXI.Point(pWorldPos.x | 0,pWorldPos.y | 0);
	if(indice >= com_isartdigital_perle_game_managers_RegionManager.factors.length) {
		return;
	}
=======
	if(indice >= com_isartdigital_perle_game_managers_RegionManager.factors.length) return;
>>>>>>> btn accelerate working:bin/Builder.js
	var factor = com_isartdigital_perle_game_managers_RegionManager.factors[indice];
	var worldPositionX = (pWorldPos.x | 0) + (factor.x | 0);
	var worldPositionY = (pWorldPos.y | 0) - (factor.y | 0);
	if(pWorldPos.x < 0 && factor.x == 1 || pWorldPos.x > 0 && factor.x == -1 || Math.abs(worldPositionX) > 2) {
		com_isartdigital_perle_game_managers_RegionManager.addButton(pPos,pWorldPos,indice + 1);
		return;
	}
	if(com_isartdigital_perle_game_managers_RegionManager.worldMap.h.hasOwnProperty(worldPositionX)) {
		if((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[worldPositionX];
			$r = this1.exists(worldPositionY);
			return $r;
		}(this))) {
			com_isartdigital_perle_game_managers_RegionManager.addButton(pPos,pWorldPos,indice + 1);
			return;
		}
	}
	var lCentre = new PIXI.Point(pPos.x + 6.,pPos.y + 6.);
	var myBtn = new com_isartdigital_perle_ui_hud_ButtonRegion(new PIXI.Point(lCentre.x + factor.x - 6. + 12 * factor.x,lCentre.y - 6. - 12 * factor.y - factor.y),new PIXI.Point(worldPositionX,worldPositionY));
	var lPos = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(lCentre.x + 12 * factor.x,lCentre.y - 12 * factor.y));
	myBtn.position = lPos;
	if(com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[worldPositionX] == null) {
		var v = new haxe_ds_IntMap();
		com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[worldPositionX] = v;
		v;
	}
	if((function($this) {
		var $r;
		var this2 = com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[worldPositionX];
		$r = this2.get(worldPositionY);
		return $r;
	}(this)) == null) {
		var this3 = com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[worldPositionX];
		this3.set(worldPositionY,myBtn);
		myBtn;
		com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer.addChild(myBtn);
		com_isartdigital_perle_game_managers_RegionManager.addBgUnder(com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(lCentre.x + factor.x - 6. + 12 * factor.x,lCentre.y - 6. - 12 * factor.y - factor.y)),{ x : worldPositionX, y : worldPositionY});
	}
	com_isartdigital_perle_game_managers_RegionManager.addButton(pPos,pWorldPos,indice + 1);
};
com_isartdigital_perle_game_managers_RegionManager.addToWorldMap = function(pNewRegion) {
	var _g = pNewRegion.desc.type;
	var v = com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.get(_g) + 1;
	com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.set(_g,v);
	v;
	if(com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pNewRegion.desc.x] == null) {
		var v1 = new haxe_ds_IntMap();
		com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pNewRegion.desc.x] = v1;
		v1;
	}
	if((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pNewRegion.desc.x];
		$r = this1.get(pNewRegion.desc.y);
		return $r;
	}(this)) != null) throw new js__$Boot_HaxeError("region allready exist in worldMap !");
	var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pNewRegion.desc.x];
	this2.set(pNewRegion.desc.y,pNewRegion);
	pNewRegion;
	if(com_isartdigital_perle_game_managers_RegionManager.background != null) {
		com_isartdigital_perle_game_managers_RegionManager.bgContainer.addChild(com_isartdigital_perle_game_managers_RegionManager.background);
		com_isartdigital_perle_game_managers_RegionManager.sortBackground();
		com_isartdigital_perle_game_managers_RegionManager.addBgUnder(com_isartdigital_perle_game_managers_RegionManager.background.position,{ x : pNewRegion.desc.x, y : pNewRegion.desc.y});
	}
};
com_isartdigital_perle_game_managers_RegionManager.addBgUnder = function(pPos,pWorlPos) {
	if(!com_isartdigital_perle_game_managers_RegionManager.underMap.h.hasOwnProperty(pWorlPos.x)) {
		var v = new haxe_ds_IntMap();
		com_isartdigital_perle_game_managers_RegionManager.underMap.h[pWorlPos.x] = v;
		v;
	} else if((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.underMap.h[pWorlPos.x];
		$r = this1.exists(pWorlPos.y);
		return $r;
	}(this))) return;
	var bgUnder = new com_isartdigital_perle_game_sprites_FlumpStateGraphic("hell_bg_free");
	bgUnder.init();
	bgUnder.start();
	bgUnder.position = pPos;
	com_isartdigital_perle_game_managers_RegionManager.bgUnderContainer.addChild(bgUnder);
	var this2 = com_isartdigital_perle_game_managers_RegionManager.underMap.h[pWorlPos.x];
	this2.set(pWorlPos.y,bgUnder);
	bgUnder;
};
com_isartdigital_perle_game_managers_RegionManager.getButtonContainer = function() {
	return com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer;
};
com_isartdigital_perle_game_managers_RegionManager.buildWhitoutSave = function() {
	var v = new haxe_ds_IntMap();
	com_isartdigital_perle_game_managers_RegionManager.worldMap.h[0] = v;
	v;
	var origin = { x : 0, y : 0};
<<<<<<< HEAD:bin/ui.js
	com_isartdigital_perle_game_managers_RegionManager.worldMap.h[origin.x].set(origin.y,com_isartdigital_perle_game_managers_RegionManager.createRegionFromDesc({ x : origin.x, y : origin.y, type : com_isartdigital_perle_game_managers_Alignment.neutral, firstTilePos : origin}));
	com_isartdigital_perle_game_managers_RegionManager.createNextBg({ x : origin.x, y : origin.y, type : com_isartdigital_perle_game_managers_Alignment.neutral, firstTilePos : origin});
=======
	var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[origin.x];
	var v1 = com_isartdigital_perle_game_managers_RegionManager.createRegionFromDesc({ x : origin.x, y : origin.y, type : com_isartdigital_perle_game_managers_Alignment.neutral, firstTilePos : { x : origin.x, y : origin.y}});
	this1.set(origin.y,v1);
	v1;
	com_isartdigital_perle_game_managers_RegionManager.createNextBg({ x : origin.x, y : origin.y, type : com_isartdigital_perle_game_managers_Alignment.neutral, firstTilePos : { x : origin.x, y : origin.y}});
	com_isartdigital_perle_game_managers_ServerManager.addRegionToDataBase(com_isartdigital_perle_game_managers_Alignment.neutral[0],origin,origin);
>>>>>>> btn accelerate working:bin/Builder.js
	com_isartdigital_perle_game_managers_RegionManager.bgContainer.addChild(com_isartdigital_perle_game_managers_RegionManager.background);
	com_isartdigital_perle_game_managers_RegionManager.createRegion(com_isartdigital_perle_game_managers_Alignment.hell,new PIXI.Point(3,0),{ x : 1, y : 0});
	com_isartdigital_perle_game_managers_RegionManager.createRegion(com_isartdigital_perle_game_managers_Alignment.heaven,new PIXI.Point(-12,0),{ x : -1, y : 0});
	com_isartdigital_perle_game_virtual_vBuilding_VTribunal.getInstance();
};
com_isartdigital_perle_game_managers_RegionManager.buildFromSave = function(pSave) {
	var lLength = pSave.region.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		pSave.region[i].type = com_isartdigital_perle_game_managers_SaveManager.translateArrayToEnum(pSave.region[i].type);
		com_isartdigital_perle_game_managers_RegionManager.addToWorldMap(com_isartdigital_perle_game_managers_RegionManager.createRegionFromDesc(pSave.region[i]));
	}
	var _g1 = 0;
	while(_g1 < lLength) {
		var i1 = _g1++;
		if(pSave.region[i1].type != com_isartdigital_perle_game_managers_Alignment.neutral) com_isartdigital_perle_game_managers_RegionManager.addButton(new PIXI.Point(pSave.region[i1].firstTilePos.x,pSave.region[i1].firstTilePos.y),new PIXI.Point(pSave.region[i1].x,pSave.region[i1].y),0);
	}
};
com_isartdigital_perle_game_managers_RegionManager.createRegion = function(pType,pFirstTilePos,pWorldPos) {
	com_isartdigital_perle_game_managers_RegionManager.createNextBg({ x : pWorldPos.x, y : pWorldPos.y, type : pType, firstTilePos : { x : pFirstTilePos.x | 0, y : pFirstTilePos.y | 0}});
	com_isartdigital_perle_game_managers_RegionManager.addToWorldMap({ desc : { x : pWorldPos.x, y : pWorldPos.y, type : pType, firstTilePos : { x : pFirstTilePos.x | 0, y : pFirstTilePos.y | 0}}, building : new haxe_ds_IntMap(), ground : new haxe_ds_IntMap(), background : com_isartdigital_perle_game_managers_RegionManager.getBgAssetname(pType)});
	com_isartdigital_perle_game_managers_SaveManager.save();
	if(Math.abs(pWorldPos.x) == 1) com_isartdigital_perle_game_managers_RegionManager.createStyxRegionIfDontExist(pWorldPos,pFirstTilePos.y | 0);
	if(pType != com_isartdigital_perle_game_managers_Alignment.neutral) com_isartdigital_perle_game_managers_RegionManager.addButton(pFirstTilePos,new PIXI.Point(pWorldPos.x,pWorldPos.y),0);
};
com_isartdigital_perle_game_managers_RegionManager.haveMoneyForBuy = function(pWorldPos,pType) {
	var basePrice;
	if(Math.abs(pWorldPos.x) > 1) basePrice = com_isartdigital_perle_game_managers_RegionManager.basePriceFarWater; else basePrice = com_isartdigital_perle_game_managers_RegionManager.basePriceNearWater;
	if(com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.get(pType) > 0) basePrice *= com_isartdigital_perle_game_managers_RegionManager.priceFactor * com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.get(pType);
	if(basePrice <= com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.soft)) {
		com_isartdigital_perle_game_managers_ResourcesManager.spendTotal(com_isartdigital_perle_game_managers_GeneratorType.soft,basePrice | 0);
		com_isartdigital_perle_game_managers_RegionManager.addExp(pType,Std["int"](Math.abs(pWorldPos.x) - 1),com_isartdigital_perle_game_managers_RegionManager.mapNumbersRegion.get(pType));
		return true;
	}
	var errorMessage = "not enought money you must have " + (basePrice - com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.soft)) + " in more";
	com_isartdigital_utils_Debug.error(errorMessage);
	js_Browser.alert(errorMessage);
	return false;
};
com_isartdigital_perle_game_managers_RegionManager.addExp = function(pType,pFactorIndice,numberRegion) {
	var lFactor;
	if(numberRegion > 0) lFactor = com_isartdigital_perle_game_managers_RegionManager.xpFactors[pFactorIndice] * numberRegion; else lFactor = 1;
	if(pType == com_isartdigital_perle_game_managers_Alignment.heaven) {
		com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.goodXp,com_isartdigital_perle_game_managers_RegionManager.baseXpGains.get("current") * lFactor);
		com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.badXp,com_isartdigital_perle_game_managers_RegionManager.baseXpGains.get("other") * lFactor);
	} else {
		com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.badXp,com_isartdigital_perle_game_managers_RegionManager.baseXpGains.get("current") * lFactor);
		com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.goodXp,com_isartdigital_perle_game_managers_RegionManager.baseXpGains.get("other") * lFactor);
	}
};
com_isartdigital_perle_game_managers_RegionManager.createStyxRegionIfDontExist = function(pWorldPos,pPosY) {
	if((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[0];
		$r = this1.get(pWorldPos.y);
		return $r;
	}(this)) != null) return;
	var posWorld = { x : 0, y : pWorldPos.y};
	com_isartdigital_perle_game_managers_ServerManager.addRegionToDataBase(com_isartdigital_perle_game_managers_Alignment.neutral[0],posWorld,{ x : 0, y : pPosY});
	com_isartdigital_perle_game_managers_RegionManager.addRegionButtonByStyx(posWorld,pPosY);
};
com_isartdigital_perle_game_managers_RegionManager.addRegionButtonByStyx = function(pWorldPos,pPosY) {
	var myBtn;
	var btnWorldPos;
	if(!(function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[-1];
		$r = this1.exists(pWorldPos.y);
		return $r;
	}(this))) {
		if(!(function($this) {
			var $r;
			var this2 = com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[-1];
			$r = this2.exists(pWorldPos.y);
			return $r;
		}(this))) {
			btnWorldPos = { x : -1, y : pWorldPos.y};
			myBtn = com_isartdigital_perle_game_managers_RegionManager.createButtonRegion(btnWorldPos,pPosY,-12,0);
			com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer.addChild(myBtn);
		}
	}
	if(!(function($this) {
		var $r;
		var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[1];
		$r = this3.exists(pWorldPos.y);
		return $r;
	}(this))) {
		if(!(function($this) {
			var $r;
			var this4 = com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[1];
			$r = this4.exists(pWorldPos.y);
			return $r;
		}(this))) {
			btnWorldPos = { x : 1, y : pWorldPos.y};
			myBtn = com_isartdigital_perle_game_managers_RegionManager.createButtonRegion(btnWorldPos,pPosY,3,7.5);
			com_isartdigital_perle_game_managers_RegionManager.buttonRegionContainer.addChild(myBtn);
		}
	}
};
com_isartdigital_perle_game_managers_RegionManager.createButtonRegion = function(pWorldPos,pPosY,pPosX,buttonDecal) {
	var myBtn = new com_isartdigital_perle_ui_hud_ButtonRegion(new PIXI.Point(pPosX,pPosY),com_isartdigital_perle_game_virtual_VTile.indexToPoint(pWorldPos));
	myBtn.position = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(pPosX / 2.0 + buttonDecal,pPosY + 6.));
	var this1 = com_isartdigital_perle_game_managers_RegionManager.buttonMap.h[pWorldPos.x];
	this1.set(pWorldPos.y,myBtn);
	myBtn;
	return myBtn;
};
com_isartdigital_perle_game_managers_RegionManager.getBgAssetname = function(pRegionType) {
	switch(pRegionType[1]) {
	case 1:
		return "BG_Hell";
	case 2:
		return "BG_Heaven";
	case 0:
		return "Styx01";
	}
};
com_isartdigital_perle_game_managers_RegionManager.createNextBg = function(pDesc) {
	var bgSize;
	if(pDesc.type == com_isartdigital_perle_game_managers_Alignment.neutral) bgSize = { x : 3, y : 13}; else bgSize = { x : 12, y : 12};
	com_isartdigital_perle_game_managers_RegionManager.background = new com_isartdigital_perle_game_sprites_RegionBackground(com_isartdigital_perle_game_managers_RegionManager.getBgAssetname(pDesc.type),pDesc.firstTilePos,bgSize);
	com_isartdigital_perle_game_managers_RegionManager.background.init();
	com_isartdigital_perle_game_managers_RegionManager.background.start();
	com_isartdigital_perle_game_managers_RegionManager.background.position = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(com_isartdigital_perle_game_virtual_VTile.indexToPoint(pDesc.firstTilePos));
};
com_isartdigital_perle_game_managers_RegionManager.tilePosToRegion = function(pTilePos) {
	var lRegionSize_width = 0;
	var lRegionSize_height = 0;
	var lRegionSize_footprint = 0;
	var lRegionRect;
	var $it0 = com_isartdigital_perle_game_managers_RegionManager.worldMap.keys();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		var $it1 = (function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[x];
			$r = this1.keys();
			return $r;
		}(this));
		while( $it1.hasNext() ) {
			var y = $it1.next();
			if(((function($this) {
				var $r;
				var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[x];
				$r = this2.get(y);
				return $r;
			}(this))).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lRegionSize_width = 3; else lRegionSize_width = 12;
			if(((function($this) {
				var $r;
				var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[x];
				$r = this3.get(y);
				return $r;
			}(this))).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lRegionSize_height = 13; else lRegionSize_height = 12;
			lRegionRect = new PIXI.Rectangle(((function($this) {
				var $r;
				var this4 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[x];
				$r = this4.get(y);
				return $r;
			}(this))).desc.firstTilePos.x,((function($this) {
				var $r;
				var this5 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[x];
				$r = this5.get(y);
				return $r;
			}(this))).desc.firstTilePos.y,lRegionSize_width,lRegionSize_height);
			if(com_isartdigital_perle_game_managers_RegionManager.isInsideRegion(lRegionRect,pTilePos)) return { x : x, y : y};
		}
	}
	return null;
};
com_isartdigital_perle_game_managers_RegionManager.isInsideRegion = function(pRegionRect,pIndex) {
	return pIndex.x >= pRegionRect.x && pIndex.x < pRegionRect.x + pRegionRect.width && pIndex.y >= pRegionRect.y && pIndex.y < pRegionRect.y + pRegionRect.height;
};
com_isartdigital_perle_game_managers_RegionManager.createRegionFromDesc = function(pRegionDesc) {
	var newRegion = { desc : pRegionDesc, building : new haxe_ds_IntMap(), ground : new haxe_ds_IntMap(), background : com_isartdigital_perle_game_managers_RegionManager.getBgAssetname(pRegionDesc.type)};
	com_isartdigital_perle_game_managers_RegionManager.createNextBg(newRegion.desc);
	return newRegion;
};
com_isartdigital_perle_game_managers_RegionManager.addToRegionGround = function(pElement) {
	var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
	var v = com_isartdigital_perle_game_managers_RegionManager.addToRegionTile((function($this) {
		var $r;
		var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this2.get(pElement.tileDesc.regionY);
		return $r;
	}(this)),pElement,((function($this) {
		var $r;
		var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this3.get(pElement.tileDesc.regionY);
		return $r;
	}(this))).ground);
	this1.set(pElement.tileDesc.regionY,v);
	v;
};
com_isartdigital_perle_game_managers_RegionManager.addToRegionBuilding = function(pElement) {
	var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
	var v = com_isartdigital_perle_game_managers_RegionManager.addToRegionTile((function($this) {
		var $r;
		var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this2.get(pElement.tileDesc.regionY);
		return $r;
	}(this)),pElement,null,((function($this) {
		var $r;
		var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this3.get(pElement.tileDesc.regionY);
		return $r;
	}(this))).building);
	this1.set(pElement.tileDesc.regionY,v);
	v;
};
com_isartdigital_perle_game_managers_RegionManager.addToRegionTile = function(pRegion,pElement,arrayGround,arrayBuilding) {
	var isGround = js_Boot.__instanceof(pElement,com_isartdigital_perle_game_virtual_VGround);
	if(isGround) {
		if(arrayGround == null) arrayGround = new haxe_ds_IntMap();
		if(arrayGround.h[pElement.tileDesc.mapX] == null) {
			var v = new haxe_ds_IntMap();
			arrayGround.h[pElement.tileDesc.mapX] = v;
			v;
		}
		var this1 = arrayGround.h[pElement.tileDesc.mapX];
		var v1;
		v1 = js_Boot.__cast(pElement , com_isartdigital_perle_game_virtual_VGround);
		this1.set(pElement.tileDesc.mapY,v1);
		v1;
		pRegion.ground = arrayGround;
	} else {
		if(arrayBuilding == null) arrayBuilding = new haxe_ds_IntMap();
		if(arrayBuilding.h[pElement.tileDesc.mapX] == null) {
			var v2 = new haxe_ds_IntMap();
			arrayBuilding.h[pElement.tileDesc.mapX] = v2;
			v2;
		}
		if((function($this) {
			var $r;
			var this2 = arrayBuilding.h[pElement.tileDesc.mapX];
			$r = this2.get(pElement.tileDesc.mapY);
			return $r;
		}(this)) != null) throw new js__$Boot_HaxeError("there is already a building on this tile !");
		var this3 = arrayBuilding.h[pElement.tileDesc.mapX];
		var v3;
		v3 = js_Boot.__cast(pElement , com_isartdigital_perle_game_virtual_VBuilding);
		this3.set(pElement.tileDesc.mapY,v3);
		v3;
		pRegion.building = arrayBuilding;
	}
	return pRegion;
};
com_isartdigital_perle_game_managers_RegionManager.sortBackground = function() {
	com_isartdigital_perle_game_managers_RegionManager.bgContainer.children = com_isartdigital_perle_game_iso_IsoManager.sortTiles(com_isartdigital_perle_game_managers_RegionManager.bgContainer.children);
};
com_isartdigital_perle_game_managers_RegionManager.removeToRegionBuilding = function(pElement) {
	var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
	var v = com_isartdigital_perle_game_managers_RegionManager.removeToRegionTile((function($this) {
		var $r;
		var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this2.get(pElement.tileDesc.regionY);
		return $r;
	}(this)),pElement,null,((function($this) {
		var $r;
		var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pElement.tileDesc.regionX];
		$r = this3.get(pElement.tileDesc.regionY);
		return $r;
	}(this))).building);
	this1.set(pElement.tileDesc.regionY,v);
	v;
};
com_isartdigital_perle_game_managers_RegionManager.removeToRegionTile = function(pRegion,pElement,arrayGround,arrayBuilding) {
	var this1 = arrayBuilding.h[pElement.tileDesc.mapX];
	this1.remove(pElement.tileDesc.mapY);
	pRegion.building = arrayBuilding;
	return pRegion;
};
var com_isartdigital_perle_game_managers_ResourcesManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.ResourcesManager"] = com_isartdigital_perle_game_managers_ResourcesManager;
com_isartdigital_perle_game_managers_ResourcesManager.__name__ = ["com","isartdigital","perle","game","managers","ResourcesManager"];
com_isartdigital_perle_game_managers_ResourcesManager.awake = function() {
	com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_ResourcesManager.populationChangementEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_ResourcesManager.soulArrivedEvent = new EventEmitter();
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray = [{ value : 1, isLevel : true},{ value : 20000, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.soft},{ value : 100, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.hard},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.goodXp},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.badXp},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.soulGood},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.soulBad},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell},{ value : 0, isLevel : false, type : com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise}];
	com_isartdigital_perle_game_managers_ResourcesManager.allPopulations = new haxe_ds_EnumValueMap();
	var v = [];
	com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.set(com_isartdigital_perle_game_managers_Alignment.heaven,v);
	v;
	var v1 = [];
	com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.set(com_isartdigital_perle_game_managers_Alignment.hell,v1);
	v1;
};
com_isartdigital_perle_game_managers_ResourcesManager.initWithoutSave = function() {
	var pMapG = new haxe_ds_EnumValueMap();
	var pMapT = new haxe_ds_EnumValueMap();
	var i;
	var v = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.soul,v);
	v;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.soulGood,0);
		0;
	}
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.soulBad,0);
		0;
	}
	var v1 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.soft,v1);
	v1;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.soft,20000);
		20000;
	}
	var v2 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.hard,v2);
	v2;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.hard,100);
		100;
	}
	var v3 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.badXp,v3);
	v3;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.badXp,0);
		0;
	}
	var v4 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.goodXp,v4);
	v4;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.goodXp,0);
		0;
	}
	var v5 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.intern,v5);
	v5;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.intern,0);
		0;
	}
	var v6 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell,v6);
	v6;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell,0);
		0;
	}
	var v7 = [];
	pMapG.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise,v7);
	v7;
	{
		pMapT.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise,0);
		0;
	}
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData = { generatorsMap : pMapG, totalsMap : pMapT, level : 1};
	com_isartdigital_perle_game_managers_ResourcesManager.maxExp = com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(1);
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[3].max = com_isartdigital_perle_game_managers_ResourcesManager.maxExp;
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[4].max = com_isartdigital_perle_game_managers_ResourcesManager.maxExp;
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesEvent.emit("TOTAL RESOURCES",com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray);
	com_isartdigital_perle_game_managers_TimeManager.eTimeGenerator.on("TimeManager_Resource_Tick",com_isartdigital_perle_game_managers_ResourcesManager.increaseResourcesWithTime);
};
com_isartdigital_perle_game_managers_ResourcesManager.initWithLoad = function(resourcesDescriptionLoad) {
	com_isartdigital_perle_game_managers_ResourcesManager.initWithoutSave();
	var myDesc;
	var myGenerator;
	var _g = 0;
	var _g1 = resourcesDescriptionLoad.arrayGenerator;
	while(_g < _g1.length) {
		var myDesc1 = _g1[_g];
		++_g;
		myDesc1.type = com_isartdigital_perle_game_managers_SaveManager.translateArrayToEnum(myDesc1.type);
		myDesc1.alignment = com_isartdigital_perle_game_managers_SaveManager.translateArrayToEnum(myDesc1.alignment);
		myGenerator = { desc : myDesc1};
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(myDesc1.type).push(myGenerator);
		com_isartdigital_perle_game_managers_TimeManager.addGenerator(myGenerator);
	}
	var totals = resourcesDescriptionLoad.totals;
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.level = resourcesDescriptionLoad.level;
	var v = totals[0];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.soft,v);
	v;
	var v1 = totals[1];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.hard,v1);
	v1;
	var v2 = totals[2];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.goodXp,v2);
	v2;
	var v3 = totals[3];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.badXp,v3);
	v3;
	var v4 = totals[4];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.soulGood,v4);
	v4;
	var v5 = totals[5];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.soulBad,v5);
	v5;
	var v6 = totals[6];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.intern,v6);
	v6;
	var v7 = totals[7];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell,v7);
	v7;
	var v8 = totals[8];
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise,v8);
	v8;
	com_isartdigital_perle_game_managers_ResourcesManager.maxExp = com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(resourcesDescriptionLoad.level);
	var i;
	var _g11 = 0;
	var _g2 = com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		if(i1 == 0) com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[i1].value = resourcesDescriptionLoad.level; else if(i1 < 7) com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[i1].value = totals[i1 - 1]; else com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[i1].value = totals[i1];
		if(i1 == 3 || i1 == 4) com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray[i1].max = com_isartdigital_perle_game_managers_ResourcesManager.maxExp;
	}
	com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesEvent.emit("TOTAL RESOURCES",com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesInfoArray);
};
com_isartdigital_perle_game_managers_ResourcesManager.GeneratorIsNotEmpty = function(pDesc) {
	return pDesc.quantity > 0;
};
com_isartdigital_perle_game_managers_ResourcesManager.getResourcesData = function() {
	return com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData;
};
com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType = function(pType) {
	return com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType);
};
com_isartdigital_perle_game_managers_ResourcesManager.getLevel = function() {
	return com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.level;
};
com_isartdigital_perle_game_managers_ResourcesManager.addPopulation = function(pQuantity,pMax,pType,pRef) {
	var newPopulation = { quantity : pQuantity, max : pMax, buildingRef : pRef};
	com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType).push(newPopulation);
	return newPopulation;
};
com_isartdigital_perle_game_managers_ResourcesManager.updatePopulation = function(pPopulation,pType) {
	com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType)[(function($this) {
		var $r;
		var _this = com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType);
		$r = HxOverrides.indexOf(_this,pPopulation,0);
		return $r;
	}(this))] = pPopulation;
};
com_isartdigital_perle_game_managers_ResourcesManager.getTotalAllPopulations = function() {
	var myTotalAllPopulation = { heaven : { quantity : 0, max : 0}, hell : { quantity : 0, max : 0}};
	myTotalAllPopulation.heaven = com_isartdigital_perle_game_managers_ResourcesManager.getTotalPopuLation(com_isartdigital_perle_game_managers_Alignment.heaven);
	myTotalAllPopulation.hell = com_isartdigital_perle_game_managers_ResourcesManager.getTotalPopuLation(com_isartdigital_perle_game_managers_Alignment.hell);
	return myTotalAllPopulation;
};
com_isartdigital_perle_game_managers_ResourcesManager.getTotalPopuLation = function(pType) {
	var myTotal = { quantity : 0, max : 0};
	var myPop;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType);
	while(_g < _g1.length) {
		var myPop1 = _g1[_g];
		++_g;
		myTotal.max += myPop1.max;
		myTotal.quantity += myPop1.quantity;
	}
	return myTotal;
};
com_isartdigital_perle_game_managers_ResourcesManager.getTotalNeutralPopulation = function() {
	var myGenerator;
	var myTotal = { quantity : 0, max : 0};
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(com_isartdigital_perle_game_managers_GeneratorType.soul);
	while(_g < _g1.length) {
		var myGenerator1 = _g1[_g];
		++_g;
		myTotal.quantity += myGenerator1.desc.quantity | 0;
		myTotal.max = myGenerator1.desc.max | 0;
	}
	return myTotal;
};
com_isartdigital_perle_game_managers_ResourcesManager.judgePopulation = function(pType) {
	var lPopulation;
	var lGenerator;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(com_isartdigital_perle_game_managers_GeneratorType.soul);
	while(_g < _g1.length) {
		var lGenerator1 = _g1[_g];
		++_g;
		if(lGenerator1.desc.quantity > 0) {
			var _g2 = 0;
			var _g3 = com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType);
			while(_g2 < _g3.length) {
				var lPopulation1 = _g3[_g2];
				++_g2;
				if(lPopulation1.max > lPopulation1.quantity) {
					lPopulation1.quantity++;
					lGenerator1.desc.quantity--;
					com_isartdigital_perle_game_managers_ResourcesManager.populationChangementEvent.emit("POPULATION",lPopulation1);
					com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.emit("GENERATOR",{ id : lGenerator1.desc.id});
					return;
				}
			}
		}
	}
};
com_isartdigital_perle_game_managers_ResourcesManager.save = function(pGenerator) {
	var myArray = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pGenerator.desc.type);
	myArray[HxOverrides.indexOf(myArray,pGenerator,0)] = pGenerator;
	{
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.set(pGenerator.desc.type,myArray);
		myArray;
	}
	com_isartdigital_perle_game_managers_SaveManager.save();
};
com_isartdigital_perle_game_managers_ResourcesManager.addResourcesGenerator = function(pId,pType,pMax,pTime,pAlignment,isTribunal) {
	var myDesc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(pId,pType);
	var myGenerator;
	if(myDesc != null) return { desc : myDesc};
	myDesc = { quantity : 0, max : pMax, id : pId, type : pType};
	if(isTribunal) myDesc.quantity = myDesc.max;
	if(pAlignment != null) myDesc.alignment = pAlignment;
	myGenerator = { desc : myDesc};
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pType).push(myGenerator);
	com_isartdigital_perle_game_managers_SaveManager.save();
	com_isartdigital_perle_game_managers_TimeManager.createTimeResource(pTime,myGenerator);
	return myGenerator;
};
com_isartdigital_perle_game_managers_ResourcesManager.UpdateResourcesGenerator = function(pGenerator,pMax,pEnd) {
	pGenerator.desc.max = pMax;
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pGenerator.desc.type)[(function($this) {
		var $r;
		var _this = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pGenerator.desc.type);
		$r = HxOverrides.indexOf(_this,pGenerator,0);
		return $r;
	}(this))] = pGenerator;
	com_isartdigital_perle_game_managers_TimeManager.updateTimeResource(pEnd,pGenerator);
	return pGenerator;
};
com_isartdigital_perle_game_managers_ResourcesManager.getGenerator = function(pId,pType) {
	var resourcesArray = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pType);
	var lLength = resourcesArray.length;
	var i;
	var _g = 0;
	while(_g < lLength) {
		var i1 = _g++;
		if(resourcesArray[i1].desc.id == pId) return resourcesArray[i1].desc;
	}
	return null;
};
com_isartdigital_perle_game_managers_ResourcesManager.changeAlignment = function(pGenerator,pAlignment) {
	pGenerator.desc.alignment = pAlignment;
	com_isartdigital_perle_game_managers_ResourcesManager.save(pGenerator);
};
com_isartdigital_perle_game_managers_ResourcesManager.increaseResourcesWithTime = function(data) {
	if(data != null) {
		if(com_isartdigital_perle_game_managers_ResourcesManager.increaseResourcesWithPolation(com_isartdigital_perle_game_managers_Alignment.heaven,data)) return;
		if(com_isartdigital_perle_game_managers_ResourcesManager.increaseResourcesWithPolation(com_isartdigital_perle_game_managers_Alignment.hell,data)) return;
		com_isartdigital_perle_game_managers_ResourcesManager.increaseResources(data.generator,data.tickNumber);
	}
};
com_isartdigital_perle_game_managers_ResourcesManager.increaseResourcesWithPolation = function(pType,data) {
<<<<<<< HEAD:bin/ui.js
	if(data.generator == null) {
		return false;
	}
=======
	var myPopulation;
>>>>>>> btn accelerate working:bin/Builder.js
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_ResourcesManager.allPopulations.get(pType);
	while(_g < _g1.length) {
		var myPopulation1 = _g1[_g];
		++_g;
		if(myPopulation1.buildingRef == data.generator.desc.id) {
			com_isartdigital_perle_game_managers_ResourcesManager.increaseResources(data.generator,data.tickNumber * myPopulation1.quantity);
			return true;
		}
	}
	return false;
};
com_isartdigital_perle_game_managers_ResourcesManager.increaseResources = function(pGenerator,quantity) {
	if(pGenerator == null) {
		return;
	}
	pGenerator.desc.quantity = Math.min(pGenerator.desc.quantity + quantity,pGenerator.desc.max);
	com_isartdigital_perle_game_managers_ResourcesManager.save(pGenerator);
	if(pGenerator.desc.quantity >= pGenerator.desc.max / 10) com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.emit("GENERATOR",{ id : pGenerator.desc.id, forButton : true, active : true}); else com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.emit("GENERATOR",{ id : pGenerator.desc.id});
	if(pGenerator.desc.type == com_isartdigital_perle_game_managers_GeneratorType.soul) com_isartdigital_perle_game_managers_ResourcesManager.soulArrivedEvent.emit("SOUL_ARRIVED");
};
com_isartdigital_perle_game_managers_ResourcesManager.removeGenerator = function(pGenerator) {
	com_isartdigital_perle_game_managers_TimeManager.removeTimeResource(pGenerator.desc.id);
	var myArray = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.get(pGenerator.desc.type);
	myArray.splice(HxOverrides.indexOf(myArray,pGenerator,0),1);
	{
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.generatorsMap.set(pGenerator.desc.type,myArray);
		myArray;
	}
	com_isartdigital_perle_game_managers_SaveManager.save();
};
com_isartdigital_perle_game_managers_ResourcesManager.takeResources = function(pDesc,pMax) {
	if(pDesc.type == com_isartdigital_perle_game_managers_GeneratorType.goodXp || pDesc.type == com_isartdigital_perle_game_managers_GeneratorType.badXp) com_isartdigital_perle_game_managers_ResourcesManager.takeXp(pDesc.quantity,pDesc.type); else {
		var v;
		if(pMax != null) v = Math.min(pMax,com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pDesc.type) + pDesc.quantity); else v = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pDesc.type) + pDesc.quantity;
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(pDesc.type,v);
		v;
		com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pDesc.type),false,pDesc.type);
	}
	pDesc.quantity = 0;
	com_isartdigital_perle_game_managers_SaveManager.save();
	com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.emit("GENERATOR",{ id : pDesc.id, active : false, forButton : true});
	return pDesc;
};
com_isartdigital_perle_game_managers_ResourcesManager.takeXp = function(quantity,pType) {
	var v = Math.min(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType) + quantity,com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(pType,v);
	v;
	com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType),false,pType,com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
	com_isartdigital_perle_ui_hud_Hud.getInstance().setXpGauge(pType,quantity);
	com_isartdigital_perle_game_managers_ResourcesManager.testLevelUp();
	com_isartdigital_perle_game_managers_SaveManager.save();
};
com_isartdigital_perle_game_managers_ResourcesManager.gainResources = function(pType,quantity) {
	var _g = pType;
	var v = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(_g) + quantity;
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(_g,v);
	v;
	if(pType == com_isartdigital_perle_game_managers_GeneratorType.goodXp || pType == com_isartdigital_perle_game_managers_GeneratorType.badXp) {
		var v1 = Math.min(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType),com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(pType,v1);
		v1;
		com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType),false,pType,com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
		com_isartdigital_perle_game_managers_ResourcesManager.testLevelUp();
	} else com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType),false,pType);
	com_isartdigital_perle_game_managers_SaveManager.save();
};
com_isartdigital_perle_game_managers_ResourcesManager.testLevelUp = function() {
	if(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.badXp) == com_isartdigital_perle_game_managers_ResourcesManager.maxExp && com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.goodXp) == com_isartdigital_perle_game_managers_ResourcesManager.maxExp) {
		com_isartdigital_perle_ui_hud_Hud.getInstance().initGauges();
		com_isartdigital_perle_game_managers_ResourcesManager.levelUp();
	}
};
com_isartdigital_perle_game_managers_ResourcesManager.spendTotal = function(pType,spendValue) {
	var _g = pType;
	var v = com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(_g) - spendValue;
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(_g,v);
	v;
	com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.get(pType),false,pType);
	com_isartdigital_perle_game_managers_SaveManager.save();
};
com_isartdigital_perle_game_managers_ResourcesManager.levelUp = function() {
	{
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.badXp,0);
		0;
	}
	{
		com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.totalsMap.set(com_isartdigital_perle_game_managers_GeneratorType.goodXp,0);
		0;
	}
	com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.level++;
	com_isartdigital_perle_game_managers_ResourcesManager.maxExp = com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.level);
	com_isartdigital_perle_game_managers_UnlockManager.unlockItem();
	com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(0,false,com_isartdigital_perle_game_managers_GeneratorType.badXp,com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
	com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(0,false,com_isartdigital_perle_game_managers_GeneratorType.goodXp,com_isartdigital_perle_game_managers_ResourcesManager.maxExp);
	com_isartdigital_perle_ui_hud_Hud.getInstance().setAllTextValues(com_isartdigital_perle_game_managers_ResourcesManager.myResourcesData.level,true);
	com_isartdigital_perle_game_managers_SaveManager.save();
};
var com_isartdigital_perle_game_managers_GeneratorType = { __ename__ : true, __constructs__ : ["soft","hard","goodXp","badXp","soul","soulGood","soulBad","intern","buildResourceFromHell","buildResourceFromParadise"] };
com_isartdigital_perle_game_managers_GeneratorType.soft = ["soft",0];
com_isartdigital_perle_game_managers_GeneratorType.soft.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.soft.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.hard = ["hard",1];
com_isartdigital_perle_game_managers_GeneratorType.hard.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.hard.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.goodXp = ["goodXp",2];
com_isartdigital_perle_game_managers_GeneratorType.goodXp.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.goodXp.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.badXp = ["badXp",3];
com_isartdigital_perle_game_managers_GeneratorType.badXp.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.badXp.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.soul = ["soul",4];
com_isartdigital_perle_game_managers_GeneratorType.soul.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.soul.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.soulGood = ["soulGood",5];
com_isartdigital_perle_game_managers_GeneratorType.soulGood.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.soulGood.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.soulBad = ["soulBad",6];
com_isartdigital_perle_game_managers_GeneratorType.soulBad.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.soulBad.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.intern = ["intern",7];
com_isartdigital_perle_game_managers_GeneratorType.intern.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.intern.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell = ["buildResourceFromHell",8];
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise = ["buildResourceFromParadise",9];
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise.toString = $estr;
com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise.__enum__ = com_isartdigital_perle_game_managers_GeneratorType;
var com_isartdigital_perle_game_managers_Alignment = { __ename__ : true, __constructs__ : ["neutral","hell","heaven"] };
com_isartdigital_perle_game_managers_Alignment.neutral = ["neutral",0];
com_isartdigital_perle_game_managers_Alignment.neutral.toString = $estr;
com_isartdigital_perle_game_managers_Alignment.neutral.__enum__ = com_isartdigital_perle_game_managers_Alignment;
com_isartdigital_perle_game_managers_Alignment.hell = ["hell",1];
com_isartdigital_perle_game_managers_Alignment.hell.toString = $estr;
com_isartdigital_perle_game_managers_Alignment.hell.__enum__ = com_isartdigital_perle_game_managers_Alignment;
com_isartdigital_perle_game_managers_Alignment.heaven = ["heaven",2];
com_isartdigital_perle_game_managers_Alignment.heaven.toString = $estr;
com_isartdigital_perle_game_managers_Alignment.heaven.__enum__ = com_isartdigital_perle_game_managers_Alignment;
var com_isartdigital_perle_game_managers_SaveManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.SaveManager"] = com_isartdigital_perle_game_managers_SaveManager;
com_isartdigital_perle_game_managers_SaveManager.__name__ = ["com","isartdigital","perle","game","managers","SaveManager"];
com_isartdigital_perle_game_managers_SaveManager.save = function() {
	var buildingSave = [];
	var groundSave = [];
	var regionSave = [];
	var itemUnlock = [];
	itemUnlock = com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked;
	var $it0 = com_isartdigital_perle_game_managers_RegionManager.worldMap.keys();
	while( $it0.hasNext() ) {
		var regionX = $it0.next();
		var $it1 = (function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
			$r = this1.keys();
			return $r;
		}(this));
		while( $it1.hasNext() ) {
			var regionY = $it1.next();
			regionSave.push(((function($this) {
				var $r;
				var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
				$r = this2.get(regionY);
				return $r;
			}(this))).desc);
			var $it2 = (function($this) {
				var $r;
				var this3;
				this3 = ((function($this) {
					var $r;
					var this4 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
					$r = this4.get(regionY);
					return $r;
				}($this))).building;
				$r = this3.keys();
				return $r;
			}(this));
			while( $it2.hasNext() ) {
				var x = $it2.next();
				var $it3 = (function($this) {
					var $r;
					var this5;
					{
						var this6;
						this6 = ((function($this) {
							var $r;
							var this7 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
							$r = this7.get(regionY);
							return $r;
						}($this))).building;
						this5 = this6.get(x);
					}
					$r = this5.keys();
					return $r;
				}(this));
				while( $it3.hasNext() ) {
					var y = $it3.next();
					buildingSave.push(((function($this) {
						var $r;
						var this8;
						{
							var this9;
							this9 = ((function($this) {
								var $r;
								var this10 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
								$r = this10.get(regionY);
								return $r;
							}($this))).building;
							this8 = this9.get(x);
						}
						$r = this8.get(y);
						return $r;
					}(this))).tileDesc);
				}
			}
			var $it4 = (function($this) {
				var $r;
				var this11;
				this11 = ((function($this) {
					var $r;
					var this12 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
					$r = this12.get(regionY);
					return $r;
				}($this))).ground;
				$r = this11.keys();
				return $r;
			}(this));
			while( $it4.hasNext() ) {
				var x1 = $it4.next();
				var $it5 = (function($this) {
					var $r;
					var this13;
					{
						var this14;
						this14 = ((function($this) {
							var $r;
							var this15 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
							$r = this15.get(regionY);
							return $r;
						}($this))).ground;
						this13 = this14.get(x1);
					}
					$r = this13.keys();
					return $r;
				}(this));
				while( $it5.hasNext() ) {
					var y1 = $it5.next();
					groundSave.push(((function($this) {
						var $r;
						var this16;
						{
							var this17;
							this17 = ((function($this) {
								var $r;
								var this18 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[regionX];
								$r = this18.get(regionY);
								return $r;
							}($this))).ground;
							this16 = this17.get(x1);
						}
						$r = this16.get(y1);
						return $r;
					}(this))).tileDesc);
				}
			}
		}
	}
	com_isartdigital_perle_game_managers_SaveManager.currentSave = { timesResource : com_isartdigital_perle_game_managers_SaveManager.getTimesResource(), timesQuest : com_isartdigital_perle_game_managers_SaveManager.getTimesQuest(), timesConstruction : com_isartdigital_perle_game_managers_SaveManager.getTimesConstruction(), lastKnowTime : com_isartdigital_perle_game_managers_TimeManager.lastKnowTime, stats : com_isartdigital_perle_game_managers_SaveManager.getStats(), idHightest : com_isartdigital_perle_game_managers_IdManager.idHightest, region : regionSave, ground : groundSave, building : buildingSave, resourcesData : com_isartdigital_perle_game_managers_SaveManager.saveResources(), COL_X_LENGTH : 12, ROW_Y_LENGTH : 12, version : "1.0.8", ftueProgress : com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved, itemUnlocked : itemUnlock};
	com_isartdigital_perle_game_managers_SaveManager.setLocalStorage(com_isartdigital_perle_game_managers_SaveManager.currentSave);
};
com_isartdigital_perle_game_managers_SaveManager.saveResources = function() {
	var data = com_isartdigital_perle_game_managers_ResourcesManager.getResourcesData();
	var desc = { arrayGenerator : [], totals : [], level : data.level};
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.soft);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.hard);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.goodXp);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.badXp);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.soul);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.intern);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell);
	desc.arrayGenerator = com_isartdigital_perle_game_managers_SaveManager.addGenerator(desc.arrayGenerator,data,com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise);
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.soft));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.hard));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.goodXp));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.badXp));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.soulGood));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.soulBad));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.intern));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell));
	desc.totals.push(data.totalsMap.get(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise));
	return desc;
};
com_isartdigital_perle_game_managers_SaveManager.addGenerator = function(pArray,pData,pType) {
	var i;
	var _g1 = 0;
	var _g = pData.generatorsMap.get(pType).length;
	while(_g1 < _g) {
		var i1 = _g1++;
		pArray.push(pData.generatorsMap.get(pType)[i1].desc);
	}
	return pArray;
};
com_isartdigital_perle_game_managers_SaveManager.saveLastKnowTime = function(pTime) {
	com_isartdigital_perle_game_managers_SaveManager.currentSave.lastKnowTime = pTime;
	com_isartdigital_perle_game_managers_SaveManager.setLocalStorage(com_isartdigital_perle_game_managers_SaveManager.currentSave);
};
com_isartdigital_perle_game_managers_SaveManager.setLocalStorage = function(pCurrentSave) {
	js_Browser.getLocalStorage().setItem("com_isartdigital_perle",JSON.stringify(com_isartdigital_perle_game_managers_SaveManager.currentSave));
};
com_isartdigital_perle_game_managers_SaveManager.reinit = function() {
	js_Browser.getLocalStorage().clear();
	window.location.reload();
};
com_isartdigital_perle_game_managers_SaveManager.getTimesResource = function() {
	return com_isartdigital_perle_game_managers_TimeManager.listResource.map(function(pElement) {
		return pElement.desc;
	});
};
com_isartdigital_perle_game_managers_SaveManager.getTimesQuest = function() {
	return com_isartdigital_perle_game_managers_TimeManager.listQuest.map(function(pElement) {
		return pElement;
	});
};
com_isartdigital_perle_game_managers_SaveManager.getTimesConstruction = function() {
	return com_isartdigital_perle_game_managers_TimeManager.listConstruction.map(function(pElement) {
		return pElement;
	});
};
com_isartdigital_perle_game_managers_SaveManager.getStats = function() {
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave == null || com_isartdigital_perle_game_managers_SaveManager.currentSave.stats == null) return { gameStartTime : com_isartdigital_perle_game_managers_TimeManager.gameStartTime}; else return { gameStartTime : com_isartdigital_perle_game_managers_SaveManager.currentSave.stats.gameStartTime};
	return null;
};
com_isartdigital_perle_game_managers_SaveManager.destroy = function() {
	js_Browser.getLocalStorage().setItem("com_isartdigital_perle",JSON.stringify(null));
};
com_isartdigital_perle_game_managers_SaveManager.load = function() {
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave == null) {
		com_isartdigital_perle_game_managers_SaveManager.currentSave = JSON.parse(js_Browser.getLocalStorage().getItem("com_isartdigital_perle"));
		if(com_isartdigital_perle_game_managers_SaveManager.currentSave != null) {
			if(com_isartdigital_perle_game_managers_SaveManager.currentSave.version != "1.0.8") {
				com_isartdigital_perle_game_managers_SaveManager.destroy();
				com_isartdigital_perle_game_managers_SaveManager.currentSave = null;
			} else if(com_isartdigital_perle_game_managers_SaveManager.currentSave.COL_X_LENGTH != 12 || com_isartdigital_perle_game_managers_SaveManager.currentSave.ROW_Y_LENGTH != 12) throw new js__$Boot_HaxeError("DIFFERENT VALUE Ground.COL_X_LENGTH or Ground.ROW_Y_LENGTH !! (use destroy() in this function)");
		}
	}
	return com_isartdigital_perle_game_managers_SaveManager.currentSave;
};
com_isartdigital_perle_game_managers_SaveManager.createFromSave = function() {
	com_isartdigital_perle_game_managers_SaveManager.load();
	if(com_isartdigital_perle_game_managers_SaveManager.currentSave != null) {
		com_isartdigital_perle_game_managers_TimeManager.buildFromSave(com_isartdigital_perle_game_managers_SaveManager.currentSave);
		com_isartdigital_perle_game_managers_IdManager.buildFromSave(com_isartdigital_perle_game_managers_SaveManager.currentSave);
		com_isartdigital_perle_game_managers_ResourcesManager.initWithLoad(com_isartdigital_perle_game_managers_SaveManager.currentSave.resourcesData);
		com_isartdigital_perle_game_managers_QuestsManager.initWithoutSave();
		com_isartdigital_perle_game_managers_RegionManager.buildFromSave(com_isartdigital_perle_game_managers_SaveManager.currentSave);
		com_isartdigital_perle_game_virtual_VTile.buildFromSave(com_isartdigital_perle_game_managers_SaveManager.currentSave);
		com_isartdigital_perle_game_sprites_Intern.init();
		com_isartdigital_perle_game_managers_TimeManager.startTimeLoop();
		com_isartdigital_perle_ui_hud_Hud.getInstance().initGaugesWithSave();
		com_isartdigital_perle_game_managers_DialogueManager.dialogueSaved = com_isartdigital_perle_game_managers_SaveManager.currentSave.ftueProgress;
		com_isartdigital_perle_game_managers_UnlockManager.isAlreadySaved = true;
	} else com_isartdigital_perle_game_managers_SaveManager.createWhitoutSave();
};
com_isartdigital_perle_game_managers_SaveManager.createWhitoutSave = function() {
	com_isartdigital_perle_game_managers_TimeManager.buildWhitoutSave();
	com_isartdigital_perle_game_managers_IdManager.buildWhitoutSave();
	com_isartdigital_perle_game_managers_ResourcesManager.initWithoutSave();
	com_isartdigital_perle_game_managers_RegionManager.buildWhitoutSave();
	com_isartdigital_perle_game_virtual_VTile.buildWhitoutSave();
	com_isartdigital_perle_game_sprites_Intern.init();
	com_isartdigital_perle_game_managers_TimeManager.startTimeLoop();
	com_isartdigital_perle_game_managers_SaveManager.save();
	com_isartdigital_perle_game_managers_QuestsManager.initWithoutSave();
	com_isartdigital_perle_ui_hud_Hud.getInstance().initGauges();
};
com_isartdigital_perle_game_managers_SaveManager.translateArrayToEnum = function(pArray) {
	if(pArray == null) return null;
	return com_isartdigital_perle_game_managers_SaveManager.stringToEnum(js_Boot.__cast(pArray[0] , String));
};
com_isartdigital_perle_game_managers_SaveManager.stringToEnum = function(pString) {
	switch(pString) {
	case "soft":
		return com_isartdigital_perle_game_managers_GeneratorType.soft;
	case "hard":
		return com_isartdigital_perle_game_managers_GeneratorType.hard;
	case "badXp":
		return com_isartdigital_perle_game_managers_GeneratorType.badXp;
	case "goodXp":
		return com_isartdigital_perle_game_managers_GeneratorType.goodXp;
	case "soul":
		return com_isartdigital_perle_game_managers_GeneratorType.soul;
	case "soulGodd":
		return com_isartdigital_perle_game_managers_GeneratorType.soulGood;
	case "soulBad":
		return com_isartdigital_perle_game_managers_GeneratorType.soulBad;
	case "intern":
		return com_isartdigital_perle_game_managers_GeneratorType.intern;
	case "buildResourceFromHell":
		return com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell;
	case "buildResourceFromParadise":
		return com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise;
	case "hell":
		return com_isartdigital_perle_game_managers_Alignment.hell;
	case "heaven":
		return com_isartdigital_perle_game_managers_Alignment.heaven;
	case "neutral":
		return com_isartdigital_perle_game_managers_Alignment.neutral;
	default:
		return null;
	}
};
var com_isartdigital_perle_game_managers_ServerManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.ServerManager"] = com_isartdigital_perle_game_managers_ServerManager;
com_isartdigital_perle_game_managers_ServerManager.__name__ = ["com","isartdigital","perle","game","managers","ServerManager"];
com_isartdigital_perle_game_managers_ServerManager.playerConnexion = function() {
	com_isartdigital_perle_game_managers_ServerManager.callPhpFile(com_isartdigital_perle_game_managers_ServerManager.onDataCallback,com_isartdigital_perle_game_managers_ServerManager.onErrorCallback,"actions.php",(function($this) {
		var $r;
		var _g = new haxe_ds_StringMap();
		if(__map_reserved.module != null) _g.setReserved("module","Login"); else _g.h["module"] = "Login";
		$r = _g;
		return $r;
	}(this)));
};
com_isartdigital_perle_game_managers_ServerManager.refreshConfig = function() {
	com_isartdigital_perle_game_managers_ServerManager.callPhpFile(com_isartdigital_perle_game_managers_ServerManager.onDataCallback,com_isartdigital_perle_game_managers_ServerManager.onErrorCallback,"actions.php",(function($this) {
		var $r;
		var _g = new haxe_ds_StringMap();
		if(__map_reserved.module != null) _g.setReserved("module","JsonCreator"); else _g.h["module"] = "JsonCreator";
		$r = _g;
		return $r;
	}(this)));
};
<<<<<<< HEAD:bin/ui.js
com_isartdigital_perle_game_managers_ServerManager.addRegionToDataBase = function(typeName,mapPos,firstTileMapPos,btnRegion) {
	com_isartdigital_perle_game_managers_ServerManager.currentButtonRegion = btnRegion;
	var _g = new haxe_ds_StringMap();
	if(__map_reserved.module != null) {
		_g.setReserved("module","BuyRegions");
	} else {
		_g.h["module"] = "BuyRegions";
	}
	var value = com_isartdigital_services_facebook_Facebook.uid;
	if(__map_reserved.playerId != null) {
		_g.setReserved("playerId",value);
	} else {
		_g.h["playerId"] = value;
	}
	if(__map_reserved.type != null) {
		_g.setReserved("type",typeName);
	} else {
		_g.h["type"] = typeName;
	}
	var value1 = mapPos.x;
	if(__map_reserved.x != null) {
		_g.setReserved("x",value1);
	} else {
		_g.h["x"] = value1;
	}
	var value2 = mapPos.y;
	if(__map_reserved.y != null) {
		_g.setReserved("y",value2);
	} else {
		_g.h["y"] = value2;
	}
	var value3 = firstTileMapPos.x;
	if(__map_reserved.firstTileX != null) {
		_g.setReserved("firstTileX",value3);
	} else {
		_g.h["firstTileX"] = value3;
	}
	var value4 = firstTileMapPos.y;
	if(__map_reserved.firstTileY != null) {
		_g.setReserved("firstTileY",value4);
	} else {
		_g.h["firstTileY"] = value4;
	}
	com_isartdigital_perle_game_managers_ServerManager.callPhpFile(com_isartdigital_perle_game_managers_ServerManager.onDataRegionCallback,com_isartdigital_perle_game_managers_ServerManager.onErrorCallback,"actions.php",_g);
=======
com_isartdigital_perle_game_managers_ServerManager.addRegionToDataBase = function(typeName,mapPos,firstTileMapPos) {
	com_isartdigital_perle_game_managers_ServerManager.callPhpFile(com_isartdigital_perle_game_managers_ServerManager.onDataCallback,com_isartdigital_perle_game_managers_ServerManager.onErrorCallback,"actions.php",(function($this) {
		var $r;
		var _g = new haxe_ds_StringMap();
		if(__map_reserved.module != null) _g.setReserved("module","regions"); else _g.h["module"] = "regions";
		_g.set("playerId",com_isartdigital_services_facebook_Facebook.uid);
		if(__map_reserved.type != null) _g.setReserved("type",typeName); else _g.h["type"] = typeName;
		_g.set("x",mapPos.x);
		_g.set("y",mapPos.y);
		_g.set("firstTileX",firstTileMapPos.x);
		_g.set("firstTileY",firstTileMapPos.y);
		$r = _g;
		return $r;
	}(this)));
>>>>>>> btn accelerate working:bin/Builder.js
};
com_isartdigital_perle_game_managers_ServerManager.callPhpFile = function(onData,onError,pFileName,pParams) {
	var lCall = new haxe_Http(pFileName);
	lCall.onData = onData;
	lCall.onError = onError;
	if(pParams != null) {
		var $it0 = pParams.keys();
		while( $it0.hasNext() ) {
			var lKey = $it0.next();
			lCall.setParameter(lKey,__map_reserved[lKey] != null?pParams.getReserved(lKey):pParams.h[lKey]);
		}
	}
	lCall.request(true);
};
com_isartdigital_perle_game_managers_ServerManager.onDataCallback = function(object) {
};
com_isartdigital_perle_game_managers_ServerManager.onDataRegionCallback = function(object) {
	var data = JSON.parse(object);
	if(data.flag) {
		if(com_isartdigital_perle_game_managers_ServerManager.currentButtonRegion != null) {
			com_isartdigital_perle_game_managers_ServerManager.currentButtonRegion.destroy();
		}
		var tmp = com_isartdigital_perle_game_managers_ServerManager.stringToEnum(data.type);
		var tmp1 = data.x | 0;
		var tmp2 = data.y | 0;
		com_isartdigital_perle_game_managers_RegionManager.createRegion(tmp,new PIXI.Point(data.ftx,data.fty),{ x : tmp1, y : tmp2});
		com_isartdigital_perle_game_managers_ResourcesManager.spendTotal(com_isartdigital_perle_game_managers_GeneratorType.soft,data.price | 0);
		com_isartdigital_perle_game_managers_ServerManager.currentButtonRegion = null;
		return;
	}
	com_isartdigital_utils_Debug.error(data.message);
};
com_isartdigital_perle_game_managers_ServerManager.onErrorCallback = function(object) {
	com_isartdigital_utils_Debug.error("Error php : " + Std.string(object));
};
com_isartdigital_perle_game_managers_ServerManager.stringToEnum = function(pString) {
	switch(pString) {
	case "heaven":
		return com_isartdigital_perle_game_managers_Alignment.heaven;
	case "hell":
		return com_isartdigital_perle_game_managers_Alignment.hell;
	case "neutral":
		return com_isartdigital_perle_game_managers_Alignment.neutral;
	default:
		return com_isartdigital_perle_game_managers_Alignment.neutral;
	}
};
com_isartdigital_perle_game_managers_ServerManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_ServerManager
};
var com_isartdigital_perle_game_managers_ServerFile = function() { };
$hxClasses["com.isartdigital.perle.game.managers.ServerFile"] = com_isartdigital_perle_game_managers_ServerFile;
com_isartdigital_perle_game_managers_ServerFile.__name__ = ["com","isartdigital","perle","game","managers","ServerFile"];
var com_isartdigital_perle_game_managers_TimeManager = function() {
};
$hxClasses["com.isartdigital.perle.game.managers.TimeManager"] = com_isartdigital_perle_game_managers_TimeManager;
com_isartdigital_perle_game_managers_TimeManager.__name__ = ["com","isartdigital","perle","game","managers","TimeManager"];
com_isartdigital_perle_game_managers_TimeManager.initClass = function() {
	com_isartdigital_perle_game_managers_TimeManager.eTimeGenerator = new EventEmitter();
	com_isartdigital_perle_game_managers_TimeManager.eTimeQuest = new EventEmitter();
	com_isartdigital_perle_game_managers_TimeManager.eConstruct = new EventEmitter();
	com_isartdigital_perle_game_managers_TimeManager.eProduction = new EventEmitter();
	com_isartdigital_perle_game_managers_TimeManager.listResource = [];
	com_isartdigital_perle_game_managers_TimeManager.listQuest = [];
	com_isartdigital_perle_game_managers_TimeManager.listConstruction = [];
	com_isartdigital_perle_game_managers_TimeManager.listProduction = [];
};
com_isartdigital_perle_game_managers_TimeManager.buildWhitoutSave = function() {
	com_isartdigital_perle_game_managers_TimeManager.gameStartTime = new Date().getTime();
	com_isartdigital_perle_game_managers_TimeManager.lastKnowTime = com_isartdigital_perle_game_managers_TimeManager.gameStartTime;
};
com_isartdigital_perle_game_managers_TimeManager.buildFromSave = function(pSave) {
	var lLength = pSave.timesResource.length;
	var lQuestArraySaved = pSave.timesQuest;
	var lConstructionArraySaved = pSave.timesConstruction;
	var lLengthConstruction = pSave.timesConstruction.length;
	var lLengthQuest = pSave.timesQuest.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		com_isartdigital_perle_game_managers_TimeManager.listResource.push({ desc : pSave.timesResource[i]});
	}
	var _g1 = 0;
	while(_g1 < lLengthQuest) {
		var i1 = _g1++;
		var lQuestDatas = { refIntern : lQuestArraySaved[i1].refIntern, progress : lQuestArraySaved[i1].progress, steps : lQuestArraySaved[i1].steps, stepIndex : lQuestArraySaved[i1].stepIndex, end : lQuestArraySaved[i1].end};
		com_isartdigital_perle_game_managers_TimeManager.listQuest.push(lQuestDatas);
	}
	com_isartdigital_perle_game_managers_TimeManager.lastKnowTime = pSave.lastKnowTime;
};
com_isartdigital_perle_game_managers_TimeManager.createTimeResource = function(pEnd,pGenerator) {
	var lTimeElement = { desc : { refTile : pGenerator.desc.id, progress : 0, end : pEnd}, generator : pGenerator};
	com_isartdigital_perle_game_managers_TimeManager.listResource.push(lTimeElement);
	return lTimeElement;
};
com_isartdigital_perle_game_managers_TimeManager.updateTimeResource = function(pEnd,pGenerator) {
	var lTimeElement;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_TimeManager.listResource;
	while(_g < _g1.length) {
		var lTimeElement1 = _g1[_g];
		++_g;
		if(lTimeElement1.generator == pGenerator) lTimeElement1.desc.end = pEnd;
	}
};
com_isartdigital_perle_game_managers_TimeManager.addGenerator = function(pGenerator) {
	var lTimeElement;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_TimeManager.listResource;
	while(_g < _g1.length) {
		var lTimeElement1 = _g1[_g];
		++_g;
		if(lTimeElement1.desc.refTile == pGenerator.desc.id) {
			lTimeElement1.generator = pGenerator;
			return;
		}
	}
};
com_isartdigital_perle_game_managers_TimeManager.createProductionTime = function(pack,ref) {
	var myTime = { buildingRef : ref, gain : pack.quantity, progress : pack.time};
	com_isartdigital_perle_game_managers_TimeManager.listProduction.push(myTime);
	return myTime;
};
com_isartdigital_perle_game_managers_TimeManager.addConstructionTimer = function(pBuildingTimer) {
	var dateNow = new Date().getTime();
	if(dateNow >= pBuildingTimer.end) return;
	pBuildingTimer.progress = dateNow - pBuildingTimer.creationDate;
	com_isartdigital_perle_game_managers_TimeManager.listConstruction.push(pBuildingTimer);
};
com_isartdigital_perle_game_managers_TimeManager.removeTimeResource = function(pId) {
	var lTimeElement;
	var _g = 0;
	var _g1 = com_isartdigital_perle_game_managers_TimeManager.listResource;
	while(_g < _g1.length) {
		var lTimeElement1 = _g1[_g];
		++_g;
		if(lTimeElement1.desc.refTile == pId) {
			com_isartdigital_perle_game_managers_TimeManager.listResource.splice(HxOverrides.indexOf(com_isartdigital_perle_game_managers_TimeManager.listResource,lTimeElement1,0),1);
			return;
		}
	}
};
com_isartdigital_perle_game_managers_TimeManager.createTimeQuest = function(pDatasQuest) {
	var lTimeElement = pDatasQuest;
	com_isartdigital_perle_game_managers_TimeManager.listQuest.push(lTimeElement);
	return lTimeElement;
};
com_isartdigital_perle_game_managers_TimeManager.getTimeElement = function(pId) {
	var lLength = com_isartdigital_perle_game_managers_TimeManager.listResource.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		if(pId == com_isartdigital_perle_game_managers_TimeManager.listResource[i].desc.refTile) return com_isartdigital_perle_game_managers_TimeManager.listResource[i];
	}
	return null;
};
com_isartdigital_perle_game_managers_TimeManager.getTimeDescription = function(pid) {
	var llength = com_isartdigital_perle_game_managers_TimeManager.listConstruction.length;
	var _g = 0;
	while(_g < llength) {
		var i = _g++;
		if(pid == com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].refTile) return com_isartdigital_perle_game_managers_TimeManager.listConstruction[i];
	}
	return null;
};
com_isartdigital_perle_game_managers_TimeManager.startTimeLoop = function() {
	var lTime = haxe_Timer.delay(com_isartdigital_perle_game_managers_TimeManager.timeLoop,50);
	lTime.run = com_isartdigital_perle_game_managers_TimeManager.timeLoop;
};
com_isartdigital_perle_game_managers_TimeManager.nextStepQuest = function(pElement) {
	if(pElement.progress == pElement.steps[pElement.stepIndex]) {
		if(pElement.stepIndex == pElement.steps.length - 1) com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.emit("TimeManager_Resource_End_Reached",pElement);
		pElement.stepIndex++;
	} else console.log("nextStepQuest not ready yet !");
};
com_isartdigital_perle_game_managers_TimeManager.getElapsedTime = function(pLastKnowTime,pTimeNow) {
	return pTimeNow - pLastKnowTime;
};
com_isartdigital_perle_game_managers_TimeManager.timeLoop = function() {
	var lTimeNow = new Date().getTime();
	var lElapsedTime = com_isartdigital_perle_game_managers_TimeManager.getElapsedTime(com_isartdigital_perle_game_managers_TimeManager.lastKnowTime,lTimeNow);
	var lLength = com_isartdigital_perle_game_managers_TimeManager.listResource.length;
	var lLengthQuest = com_isartdigital_perle_game_managers_TimeManager.listQuest.length;
	var lLengthConstruct = com_isartdigital_perle_game_managers_TimeManager.listConstruction.length;
	var lLenghtProd = com_isartdigital_perle_game_managers_TimeManager.listProduction.length;
	var constructionEnded = [];
	com_isartdigital_perle_game_managers_TimeManager.lastKnowTime = lTimeNow;
	com_isartdigital_perle_game_managers_SaveManager.saveLastKnowTime(com_isartdigital_perle_game_managers_TimeManager.lastKnowTime);
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		com_isartdigital_perle_game_managers_TimeManager.updateResource(com_isartdigital_perle_game_managers_TimeManager.listResource[i],lElapsedTime);
	}
	var _g1 = 0;
<<<<<<< HEAD:bin/ui.js
	var _g = lLength;
	while(_g1 < _g) com_isartdigital_perle_game_managers_TimeManager.updateResource(com_isartdigital_perle_game_managers_TimeManager.listResource[_g1++],lElapsedTime);
	var _g11 = 0;
	var _g2 = lLengthQuest;
	while(_g11 < _g2) com_isartdigital_perle_game_managers_TimeManager.updateQuest(com_isartdigital_perle_game_managers_TimeManager.listQuest[_g11++],lElapsedTime);
	var _g12 = 0;
	var _g3 = lLenghtProd;
	while(_g12 < _g3) com_isartdigital_perle_game_managers_TimeManager.updateProductionTime(com_isartdigital_perle_game_managers_TimeManager.listProduction[_g12++],lElapsedTime);
	var _g13 = 0;
	var _g4 = lLengthConstruct;
	while(_g13 < _g4) com_isartdigital_perle_game_managers_TimeManager.updateConstruction(com_isartdigital_perle_game_managers_TimeManager.listConstruction[_g13++],lElapsedTime,constructionEnded);
=======
	while(_g1 < lLengthQuest) {
		var j = _g1++;
		com_isartdigital_perle_game_managers_TimeManager.updateQuest(com_isartdigital_perle_game_managers_TimeManager.listQuest[j],lElapsedTime);
	}
	var _g2 = 0;
	while(_g2 < lLengthConstruct) {
		var i1 = _g2++;
		com_isartdigital_perle_game_managers_TimeManager.updateConstruction(com_isartdigital_perle_game_managers_TimeManager.listConstruction[i1],lElapsedTime,constructionEnded);
	}
>>>>>>> btn accelerate working:bin/Builder.js
	com_isartdigital_perle_game_managers_TimeManager.deleteEndedConstruction(constructionEnded);
};
com_isartdigital_perle_game_managers_TimeManager.deleteEndedConstruction = function(pEndedList) {
	var lLength = pEndedList.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		com_isartdigital_perle_game_managers_TimeManager.listConstruction.splice(pEndedList[i],1);
	}
};
com_isartdigital_perle_game_managers_TimeManager.updateResource = function(pElement,pElapsedTime) {
	var lNumberTick = 0;
	var lFullTime = pElapsedTime + pElement.desc.progress;
	lNumberTick = js_Boot.__cast((lFullTime - lFullTime % pElement.desc.end) / pElement.desc.end , Int);
	pElement.desc.progress = lFullTime % pElement.desc.end;
	if(lNumberTick > 0) com_isartdigital_perle_game_managers_TimeManager.eTimeGenerator.emit("TimeManager_Resource_Tick",{ generator : pElement.generator, tickNumber : lNumberTick});
};
com_isartdigital_perle_game_managers_TimeManager.updateQuest = function(pElement,pElapsedTime) {
	var lPreviousProgress = pElement.progress;
	pElement.progress = Math.min(pElement.progress + pElapsedTime * com_isartdigital_perle_game_sprites_Intern.internsList.h[pElement.refIntern].speed,pElement.steps[pElement.stepIndex]);
	if(pElement.progress == pElement.steps[pElement.stepIndex] && pElement.progress != lPreviousProgress) com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.emit("TimeManager_Quest_Step_Reached",pElement);
};
com_isartdigital_perle_game_managers_TimeManager.updateConstruction = function(pElement,pElapsedTime,pEndedList) {
	pElement.progress += pElapsedTime;
	var diff = pElement.end - pElement.creationDate;
	console.log("update : id => " + pElement.refTile);
	if(pElement.progress >= diff) {
		console.log("construction : id => " + pElement.refTile + " terminée");
		var index = HxOverrides.indexOf(com_isartdigital_perle_game_managers_TimeManager.listConstruction,pElement,0);
		com_isartdigital_perle_game_managers_TimeManager.eConstruct.emit("TimeManager_Construction_End",pElement);
		pEndedList.push(index);
	}
};
com_isartdigital_perle_game_managers_TimeManager.updateProductionTime = function(pElement,pEllapsedTime) {
	pElement.progress -= pEllapsedTime;
	if(pElement.progress < 0) {
		pElement.progress = 0;
		com_isartdigital_perle_game_managers_TimeManager.eProduction.emit("Production_Fine");
	}
	com_isartdigital_perle_game_managers_TimeManager.eProduction.emit("Production_Time",pElement);
};
com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime = function(pTileDesc) {
	if(Object.prototype.hasOwnProperty.call(pTileDesc,"timeDesc")) {
		var diff = pTileDesc.timeDesc.end - pTileDesc.timeDesc.creationDate;
		if(pTileDesc.timeDesc.progress >= diff) return com_isartdigital_perle_game_virtual_VBuildingState.isBuilt; else return com_isartdigital_perle_game_virtual_VBuildingState.isBuilding;
	}
	return com_isartdigital_perle_game_virtual_VBuildingState.isBuilt;
};
com_isartdigital_perle_game_managers_TimeManager.getTextTime = function(pTileDesc) {
	var lLengthConstruct = com_isartdigital_perle_game_managers_TimeManager.listConstruction.length;
	var _g = 0;
	while(_g < lLengthConstruct) {
		var i = _g++;
		if(com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].refTile == pTileDesc.id) {
			var txtLength;
			txtLength = ((function($this) {
				var $r;
				var _this;
				{
					var d = new Date();
					d.setTime(com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].progress);
					_this = d;
				}
				$r = HxOverrides.dateStr(_this);
				return $r;
			}(this))).length;
			var totalTimer = com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].end - com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].creationDate;
			var diff = totalTimer - com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].progress;
			var _this1;
			var _this2;
			var d1 = new Date();
			d1.setTime(diff);
			_this2 = d1;
			_this1 = HxOverrides.dateStr(_this2);
			return HxOverrides.substr(_this1,txtLength - 5,5);
		}
	}
	return "Finish";
};
com_isartdigital_perle_game_managers_TimeManager.getTextTimeQuest = function(pTime) {
	var txtLength;
	txtLength = ((function($this) {
		var $r;
		var _this;
		{
			var d = new Date();
			d.setTime(pTime);
			_this = d;
		}
		$r = HxOverrides.dateStr(_this);
		return $r;
	}(this))).length;
	var _this1;
	var _this2;
	var d1 = new Date();
	d1.setTime(pTime);
	_this2 = d1;
	_this1 = HxOverrides.dateStr(_this2);
	return HxOverrides.substr(_this1,txtLength - 5,5);
};
com_isartdigital_perle_game_managers_TimeManager.increaseProgress = function(pVBuilding,pBoostValue) {
	var lLengthConstruct = com_isartdigital_perle_game_managers_TimeManager.listConstruction.length;
	var _g = 0;
	while(_g < lLengthConstruct) {
		var i = _g++;
		if(com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].refTile == pVBuilding.tileDesc.id) {
			com_isartdigital_perle_game_managers_TimeManager.listConstruction[i].progress += pBoostValue;
			break;
		}
	}
	var state = com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime(pVBuilding.tileDesc);
	if(state == com_isartdigital_perle_game_virtual_VBuildingState.isBuilt) return true;
	return false;
};
com_isartdigital_perle_game_managers_TimeManager.increaseQuestProgress = function(pQuest) {
	if(pQuest.stepIndex < 3) {
		pQuest.progress = pQuest.steps[pQuest.stepIndex];
		com_isartdigital_perle_game_managers_QuestsManager.choice(pQuest);
		return true;
	} else return false;
};
com_isartdigital_perle_game_managers_TimeManager.getPourcentage = function(pTimeDesc) {
	var total = pTimeDesc.end - pTimeDesc.creationDate;
	return pTimeDesc.progress / total;
};
com_isartdigital_perle_game_managers_TimeManager.destroyTimeElement = function(pId) {
	var lLength = com_isartdigital_perle_game_managers_TimeManager.listResource.length;
	var lLengthQuest = com_isartdigital_perle_game_managers_TimeManager.listQuest.length;
	var lLengthConstruction = com_isartdigital_perle_game_managers_TimeManager.listConstruction.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		if(pId == com_isartdigital_perle_game_managers_TimeManager.listResource[i].desc.refTile) {
			com_isartdigital_perle_game_managers_TimeManager.listResource.splice(i,1);
			break;
		}
	}
	var _g1 = 0;
	while(_g1 < lLengthQuest) {
		var i1 = _g1++;
		if(pId == com_isartdigital_perle_game_managers_TimeManager.listQuest[i1].refIntern) {
			com_isartdigital_perle_game_managers_TimeManager.listQuest.splice(i1,1);
			break;
		}
	}
	var _g2 = 0;
	while(_g2 < lLengthConstruction) {
		var i2 = _g2++;
		if(pId == com_isartdigital_perle_game_managers_TimeManager.listConstruction[i2].refTile) {
			com_isartdigital_perle_game_managers_TimeManager.listConstruction.splice(i2,1);
			break;
		}
	}
};
com_isartdigital_perle_game_managers_TimeManager.prototype = {
	__class__: com_isartdigital_perle_game_managers_TimeManager
};
var com_isartdigital_perle_game_managers_UnlockManager = function() { };
$hxClasses["com.isartdigital.perle.game.managers.UnlockManager"] = com_isartdigital_perle_game_managers_UnlockManager;
com_isartdigital_perle_game_managers_UnlockManager.__name__ = ["com","isartdigital","perle","game","managers","UnlockManager"];
com_isartdigital_perle_game_managers_UnlockManager.setUnlockItem = function() {
	com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray = [];
	com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked = [];
	com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin = [];
	com_isartdigital_perle_game_managers_UnlockManager.parseJsonUnlock("json/" + "item_to_unlock");
	com_isartdigital_perle_game_managers_UnlockManager.checkIfFirstTime();
};
com_isartdigital_perle_game_managers_UnlockManager.checkIfUnlocked = function(pName) {
	return true;
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(pName == com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked[i][0][1]) return true;
	}
	return false;
};
com_isartdigital_perle_game_managers_UnlockManager.checkLevelNeeded = function(pName) {
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(pName == com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i][0][1]) return Std.parseInt(com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i][0][0]);
	}
	return null;
};
com_isartdigital_perle_game_managers_UnlockManager.checkIfFirstTime = function() {
	if(!com_isartdigital_perle_game_managers_UnlockManager.isAlreadySaved) {
		com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked = [];
		com_isartdigital_perle_game_managers_UnlockManager.unlockItem();
	} else com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked = com_isartdigital_perle_game_managers_SaveManager.currentSave.itemUnlocked;
};
com_isartdigital_perle_game_managers_UnlockManager.parseJsonUnlock = function(pJsonName) {
	var i = 0;
	var jsonItem = com_isartdigital_utils_loader_GameLoader.getContent(pJsonName + ".json");
	var _g = 0;
	var _g1 = Reflect.fields(jsonItem);
	while(_g < _g1.length) {
		var item = _g1[_g];
		++_g;
		com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i] = [];
		var lItem = Reflect.field(jsonItem,item);
		var lArray = lItem;
		com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i].push(lArray);
		i++;
	}
};
com_isartdigital_perle_game_managers_UnlockManager.unlockItem = function() {
	if(com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[Std["int"](com_isartdigital_perle_game_managers_ResourcesManager.getLevel()) - 1] == null) return;
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray.length - 1;
	while(_g1 < _g) {
		var i = _g1++;
		if(parseFloat(com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i][0][0]) == Std["int"](com_isartdigital_perle_game_managers_ResourcesManager.getLevel())) {
			com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked[i] = [];
			var lItem = com_isartdigital_perle_game_managers_UnlockManager.itemToUnlockArray[i][0];
			if(lItem == null) return;
			com_isartdigital_perle_game_managers_UnlockManager.itemUnlocked[i].push(lItem);
			if(com_isartdigital_perle_game_managers_ResourcesManager.getLevel() != 1) {
				com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin.length] = [];
				com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin.length - 1].push(lItem);
			}
			com_isartdigital_perle_game_managers_SaveManager.save();
		}
	}
	if(com_isartdigital_perle_game_managers_ResourcesManager.getLevel() != 1) com_isartdigital_perle_game_managers_UnlockManager.oppenLevelUpPopin();
};
com_isartdigital_perle_game_managers_UnlockManager.oppenLevelUpPopin = function() {
	com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.getInstance());
	com_isartdigital_perle_ui_hud_Hud.getInstance().hide();
};
var com_isartdigital_utils_game_GameObject = function() {
	PIXI.Container.call(this);
	this.on("added",$bind(this,this.updateTransform));
};
$hxClasses["com.isartdigital.utils.game.GameObject"] = com_isartdigital_utils_game_GameObject;
com_isartdigital_utils_game_GameObject.__name__ = ["com","isartdigital","utils","game","GameObject"];
com_isartdigital_utils_game_GameObject.__super__ = PIXI.Container;
com_isartdigital_utils_game_GameObject.prototype = $extend(PIXI.Container.prototype,{
	destroy: function() {
		this.off("added",$bind(this,this.updateTransform));
		PIXI.Container.prototype.destroy.call(this,true);
	}
	,__class__: com_isartdigital_utils_game_GameObject
});
var com_isartdigital_utils_game_IStateMachine = function() { };
$hxClasses["com.isartdigital.utils.game.IStateMachine"] = com_isartdigital_utils_game_IStateMachine;
com_isartdigital_utils_game_IStateMachine.__name__ = ["com","isartdigital","utils","game","IStateMachine"];
com_isartdigital_utils_game_IStateMachine.prototype = {
	__class__: com_isartdigital_utils_game_IStateMachine
};
var com_isartdigital_utils_game_StateMachine = function() {
	com_isartdigital_utils_game_GameObject.call(this);
	this.setModeVoid();
};
$hxClasses["com.isartdigital.utils.game.StateMachine"] = com_isartdigital_utils_game_StateMachine;
com_isartdigital_utils_game_StateMachine.__name__ = ["com","isartdigital","utils","game","StateMachine"];
com_isartdigital_utils_game_StateMachine.__interfaces__ = [com_isartdigital_utils_game_IStateMachine];
com_isartdigital_utils_game_StateMachine.__super__ = com_isartdigital_utils_game_GameObject;
com_isartdigital_utils_game_StateMachine.prototype = $extend(com_isartdigital_utils_game_GameObject.prototype,{
	setModeVoid: function() {
		this.doAction = $bind(this,this.doActionVoid);
	}
	,doActionVoid: function() {
	}
	,setModeNormal: function() {
		this.doAction = $bind(this,this.doActionNormal);
	}
	,doActionNormal: function() {
	}
	,start: function() {
		this.setModeNormal();
	}
	,destroy: function() {
		this.setModeVoid();
		com_isartdigital_utils_game_GameObject.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_utils_game_StateMachine
});
var com_isartdigital_utils_game_StateGraphic = function() {
	this.boxType = com_isartdigital_utils_game_BoxType.NONE;
	this.DEFAULT_STATE = "";
	this.BOX_SUFFIX = "box";
	this.ANIM_SUFFIX = "";
	com_isartdigital_utils_game_StateMachine.call(this);
};
$hxClasses["com.isartdigital.utils.game.StateGraphic"] = com_isartdigital_utils_game_StateGraphic;
com_isartdigital_utils_game_StateGraphic.__name__ = ["com","isartdigital","utils","game","StateGraphic"];
com_isartdigital_utils_game_StateGraphic.addBoxes = function(pJson) {
	if(com_isartdigital_utils_game_StateGraphic.boxesCache == null) com_isartdigital_utils_game_StateGraphic.boxesCache = new haxe_ds_StringMap();
	var lItem;
	var lObj;
	var _g = 0;
	var _g1 = Reflect.fields(pJson);
	while(_g < _g1.length) {
		var lName = _g1[_g];
		++_g;
		lItem = Reflect.field(pJson,lName);
		var v = new haxe_ds_StringMap();
		com_isartdigital_utils_game_StateGraphic.boxesCache.set(lName,v);
		v;
		var _g2 = 0;
		var _g3 = Reflect.fields(lItem);
		while(_g2 < _g3.length) {
			var lObjName = _g3[_g2];
			++_g2;
			lObj = Reflect.field(lItem,lObjName);
			if(lObj.type == "Rectangle") {
				var this1 = com_isartdigital_utils_game_StateGraphic.boxesCache.get(lName);
				var v1 = new PIXI.Rectangle(lObj.x,lObj.y,lObj.width,lObj.height);
				this1.set(lObjName,v1);
				v1;
			} else if(lObj.type == "Ellipse") {
				var this2 = com_isartdigital_utils_game_StateGraphic.boxesCache.get(lName);
				var v2 = new PIXI.Ellipse(lObj.x,lObj.y,lObj.width / 2,lObj.height / 2);
				this2.set(lObjName,v2);
				v2;
			} else if(lObj.type == "Circle") {
				var this3 = com_isartdigital_utils_game_StateGraphic.boxesCache.get(lName);
				var v3 = new PIXI.Circle(lObj.x,lObj.y,lObj.radius);
				this3.set(lObjName,v3);
				v3;
			} else if(lObj.type == "Point") {
				var this4 = com_isartdigital_utils_game_StateGraphic.boxesCache.get(lName);
				var v4 = new PIXI.Point(lObj.x,lObj.y);
				this4.set(lObjName,v4);
				v4;
			}
		}
	}
};
com_isartdigital_utils_game_StateGraphic.__super__ = com_isartdigital_utils_game_StateMachine;
com_isartdigital_utils_game_StateGraphic.prototype = $extend(com_isartdigital_utils_game_StateMachine.prototype,{
	setAnimEnd: function() {
		this.isAnimEnd = true;
	}
	,setState: function(pState,pLoop,pAutoPlay,pStart) {
		if(pStart == null) pStart = 0;
		if(pAutoPlay == null) pAutoPlay = true;
		if(pLoop == null) pLoop = false;
		var lClassName = Type.getClassName(js_Boot.getClass(this));
		if(this.factory == null) throw new js__$Boot_HaxeError(lClassName + " :: propriété factory non définie");
		if(this.state == pState) {
			if(this.anim != null) this.setBehavior(pLoop,pAutoPlay,pStart);
			return;
		}
		if(this.assetName == null) this.assetName = lClassName.split(".").pop();
		this.state = pState;
		this.anim = this.factory.getAnim();
		if(this.anim == null) {
			if(this.boxType == com_isartdigital_utils_game_BoxType.SELF) {
				if(this.box != null) this.removeChild(this.box);
				this.box = null;
			}
			this.anim = this.factory.create(this.getID(this.state));
			this.anim.scale.set(1 / com_isartdigital_utils_system_DeviceCapabilities.textureRatio,1 / com_isartdigital_utils_system_DeviceCapabilities.textureRatio);
			if(com_isartdigital_utils_game_StateGraphic.animAlpha < 1) this.anim.alpha = com_isartdigital_utils_game_StateGraphic.animAlpha;
			this.addChild(this.anim);
		} else this.factory.update(this.getID(this.state));
		this.isAnimEnd = false;
		this.setBehavior(pLoop,pAutoPlay,pStart);
		if(this.box == null) {
			if(this.boxType == com_isartdigital_utils_game_BoxType.SELF) {
				this.box = this.anim;
				return;
			} else {
				this.box = new PIXI.Container();
				if(this.boxType != com_isartdigital_utils_game_BoxType.NONE) this.createBox();
			}
			this.addChild(this.box);
		} else if(this.boxType == com_isartdigital_utils_game_BoxType.MULTIPLE) {
			this.removeChild(this.box);
			this.box = new PIXI.Container();
			this.createBox();
			this.addChild(this.box);
		}
	}
	,setBehavior: function(pLoop,pAutoPlay,pStart) {
		if(pStart == null) pStart = 0;
		if(pAutoPlay == null) pAutoPlay = true;
		if(pLoop == null) pLoop = false;
		this.anim.loop = pLoop;
		this.factory.setFrame(pAutoPlay,pStart);
	}
	,getID: function(pState) {
		if(pState == this.DEFAULT_STATE) return this.assetName + this.ANIM_SUFFIX;
		return this.assetName + "_" + pState + this.ANIM_SUFFIX;
	}
	,createBox: function() {
		var lBoxes = this.getBox((this.boxType == com_isartdigital_utils_game_BoxType.MULTIPLE?this.state + "_":"") + this.BOX_SUFFIX);
		var lChild;
		var $it0 = lBoxes.keys();
		while( $it0.hasNext() ) {
			var lBox = $it0.next();
			lChild = new PIXI.Graphics();
			lChild.beginFill(16720418);
			if(Std["is"](__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox],PIXI.Rectangle)) lChild.drawRect((__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).x,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).y,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).width,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).height); else if(Std["is"](__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox],PIXI.Ellipse)) lChild.drawEllipse((__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).x,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).y,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).width,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).height); else if(Std["is"](__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox],PIXI.Circle)) lChild.drawCircle((__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).x,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).y,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).radius); else if(Std["is"](__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox],PIXI.Point)) lChild.drawCircle(0,0,10);
			lChild.endFill();
			lChild.name = lBox;
			if(Std["is"](__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox],PIXI.Point)) lChild.position.set((__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).x,(__map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox]).y); else lChild.hitArea = __map_reserved[lBox] != null?lBoxes.getReserved(lBox):lBoxes.h[lBox];
			this.box.addChild(lChild);
		}
		if(com_isartdigital_utils_game_StateGraphic.boxAlpha == 0) this.box.renderable = false; else this.box.alpha = com_isartdigital_utils_game_StateGraphic.boxAlpha;
	}
	,getBox: function(pState) {
		return com_isartdigital_utils_game_StateGraphic.boxesCache.get(this.assetName + "_" + pState);
	}
	,pause: function() {
		if(this.anim != null) this.anim.stop();
	}
	,resume: function() {
		if(this.anim != null) this.anim.play();
	}
	,get_hitBox: function() {
		return this.box;
	}
	,get_hitPoints: function() {
		return null;
	}
	,destroy: function() {
		if(this.anim.stop != null) this.anim.stop();
		this.removeChild(this.anim);
		this.anim.destroy();
		if(this.box != this.anim) {
			this.removeChild(this.box);
			this.box.destroy();
			this.box = null;
		}
		this.anim = null;
		com_isartdigital_utils_game_StateMachine.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_utils_game_StateGraphic
});
var com_isartdigital_perle_game_sprites_FlumpStateGraphic = function(pAssetName) {
	com_isartdigital_utils_game_StateGraphic.call(this);
	if(pAssetName != null) this.assetName = pAssetName;
};
$hxClasses["com.isartdigital.perle.game.sprites.FlumpStateGraphic"] = com_isartdigital_perle_game_sprites_FlumpStateGraphic;
com_isartdigital_perle_game_sprites_FlumpStateGraphic.__name__ = ["com","isartdigital","perle","game","sprites","FlumpStateGraphic"];
com_isartdigital_perle_game_sprites_FlumpStateGraphic.__super__ = com_isartdigital_utils_game_StateGraphic;
com_isartdigital_perle_game_sprites_FlumpStateGraphic.prototype = $extend(com_isartdigital_utils_game_StateGraphic.prototype,{
	init: function() {
		if(this.factory == null) this.factory = new com_isartdigital_utils_game_factory_FlumpMovieAnimFactory();
		this.boxType = com_isartdigital_utils_game_BoxType.SELF;
		this.setState(this.DEFAULT_STATE);
	}
	,__class__: com_isartdigital_perle_game_sprites_FlumpStateGraphic
});
var com_isartdigital_perle_game_virtual_HasVirtual = function() { };
$hxClasses["com.isartdigital.perle.game.virtual.HasVirtual"] = com_isartdigital_perle_game_virtual_HasVirtual;
com_isartdigital_perle_game_virtual_HasVirtual.__name__ = ["com","isartdigital","perle","game","virtual","HasVirtual"];
com_isartdigital_perle_game_virtual_HasVirtual.prototype = {
	__class__: com_isartdigital_perle_game_virtual_HasVirtual
};
var com_isartdigital_perle_game_sprites_Tile = function(pAssetName) {
	com_isartdigital_perle_game_sprites_FlumpStateGraphic.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.Tile"] = com_isartdigital_perle_game_sprites_Tile;
com_isartdigital_perle_game_sprites_Tile.__name__ = ["com","isartdigital","perle","game","sprites","Tile"];
com_isartdigital_perle_game_sprites_Tile.__interfaces__ = [com_isartdigital_perle_game_managers_PoolingObject,com_isartdigital_perle_game_virtual_HasVirtual];
com_isartdigital_perle_game_sprites_Tile.initClass = function() {
	com_isartdigital_perle_game_iso_IsoManager.init(200,100);
	com_isartdigital_perle_game_sprites_FootPrint.initClass();
	com_isartdigital_perle_game_sprites_Ground.initClass();
	com_isartdigital_perle_game_sprites_Building.initClass();
};
com_isartdigital_perle_game_sprites_Tile.__super__ = com_isartdigital_perle_game_sprites_FlumpStateGraphic;
com_isartdigital_perle_game_sprites_Tile.prototype = $extend(com_isartdigital_perle_game_sprites_FlumpStateGraphic.prototype,{
	positionTile: function(pTileX,pTileY) {
		this.position = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(pTileX,pTileY));
	}
	,linkVirtual: function(pVirtual) {
		this.linkedVirtualCell = js_Boot.__cast(pVirtual , com_isartdigital_perle_game_virtual_VTile);
	}
	,getAssetName: function() {
		return this.assetName;
	}
	,recycle: function() {
		this.linkedVirtualCell = null;
		this.setModeVoid();
		if(this.parent != null) this.parent.removeChild(this);
		com_isartdigital_perle_game_managers_PoolingManager.addToPool(this,this.assetName);
	}
	,destroy: function() {
		if(this.linkedVirtualCell != null) this.linkedVirtualCell.removeLink();
		this.linkedVirtualCell = null;
		this.setModeVoid();
		this.parent.removeChild(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_Tile
});
var com_isartdigital_perle_game_sprites_Building = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Tile.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.Building"] = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_Building.__name__ = ["com","isartdigital","perle","game","sprites","Building"];
com_isartdigital_perle_game_sprites_Building.__interfaces__ = [com_isartdigital_perle_game_iso_IZSortable];
com_isartdigital_perle_game_sprites_Building.initClass = function() {
	com_isartdigital_perle_game_sprites_Building.container = new PIXI.Container();
	com_isartdigital_perle_game_sprites_Building.uiContainer = new PIXI.Container();
	com_isartdigital_perle_game_sprites_Building.container.position = com_isartdigital_perle_game_sprites_Ground.container.position;
	com_isartdigital_perle_game_sprites_Building.uiContainer.position = com_isartdigital_perle_game_sprites_Building.container.position;
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_game_sprites_Building.container);
	com_isartdigital_utils_game_GameStage.getInstance().getGameContainer().addChild(com_isartdigital_perle_game_sprites_Building.uiContainer);
	com_isartdigital_perle_game_sprites_Building.list = [];
};
com_isartdigital_perle_game_sprites_Building.sortBuildings = function() {
	com_isartdigital_perle_game_sprites_Building.container.children = com_isartdigital_perle_game_iso_IsoManager.sortTiles(com_isartdigital_perle_game_sprites_Building.container.children);
};
com_isartdigital_perle_game_sprites_Building.getBuildingHudContainer = function() {
	return com_isartdigital_perle_game_sprites_Building.uiContainer;
};
com_isartdigital_perle_game_sprites_Building.getBuildingContainer = function() {
	return com_isartdigital_perle_game_sprites_Building.container;
};
com_isartdigital_perle_game_sprites_Building.createBuilding = function(pTileDesc) {
	var lBuilding = com_isartdigital_perle_game_managers_PoolingManager.getFromPool(com_isartdigital_perle_game_BuildingName.getAssetName(pTileDesc.buildingName,pTileDesc.level));
	var regionFirstTilePos;
	regionFirstTilePos = ((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pTileDesc.regionX];
		$r = this1.get(pTileDesc.regionY);
		return $r;
	}(this))).desc.firstTilePos;
	lBuilding.positionTile(pTileDesc.mapX + regionFirstTilePos.x,pTileDesc.mapY + regionFirstTilePos.y);
	lBuilding.setMapColRow({ x : pTileDesc.mapX + regionFirstTilePos.x, y : pTileDesc.mapY + regionFirstTilePos.y},com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pTileDesc.buildingName));
	com_isartdigital_perle_game_sprites_Building.list.push(lBuilding);
	lBuilding.init();
	com_isartdigital_perle_game_sprites_Building.container.addChild(lBuilding);
	lBuilding.start();
	return lBuilding;
};
com_isartdigital_perle_game_sprites_Building.destroyStatic = function() {
	com_isartdigital_perle_game_sprites_Building.container.parent.removeChild(com_isartdigital_perle_game_sprites_Building.container);
	com_isartdigital_perle_game_sprites_Building.container = null;
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_sprites_Building.list.length;
	while(_g1 < _g) {
		var i = _g1++;
		com_isartdigital_perle_game_sprites_Building.list[i].destroy();
	}
	com_isartdigital_perle_game_sprites_Building.list = null;
};
com_isartdigital_perle_game_sprites_Building.__super__ = com_isartdigital_perle_game_sprites_Tile;
com_isartdigital_perle_game_sprites_Building.prototype = $extend(com_isartdigital_perle_game_sprites_Tile.prototype,{
	start: function() {
		com_isartdigital_perle_game_sprites_Tile.prototype.start.call(this);
		this.interactive = true;
		this.buttonMode = true;
		this.addListenerOnClick();
	}
	,setMapColRow: function(pTilePos,pMapSize) {
		this.colMax = pTilePos.x + pMapSize.width - 1;
		this.colMin = pTilePos.x;
		this.rowMax = pTilePos.y + pMapSize.height - 1;
		this.rowMin = pTilePos.y;
	}
	,recycle: function() {
		if(HxOverrides.indexOf(com_isartdigital_perle_game_sprites_Building.list,this,0) != -1) com_isartdigital_perle_game_sprites_Building.list.splice(HxOverrides.indexOf(com_isartdigital_perle_game_sprites_Building.list,this,0),1);
		com_isartdigital_perle_game_sprites_Tile.prototype.recycle.call(this);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this,$bind(this,this.onClick));
		this.off("mouseover",$bind(this,this.changeCursor));
		if(HxOverrides.indexOf(com_isartdigital_perle_game_sprites_Building.list,this,0) != -1) com_isartdigital_perle_game_sprites_Building.list.splice(HxOverrides.indexOf(com_isartdigital_perle_game_sprites_Building.list,this,0),1);
		com_isartdigital_perle_game_sprites_Tile.prototype.destroy.call(this);
	}
	,addListenerOnClick: function() {
		com_isartdigital_perle_utils_Interactive.addListenerClick(this,$bind(this,this.onClick));
		this.on("mouseover",$bind(this,this.changeCursor));
	}
	,onClick: function() {
		if(com_isartdigital_perle_game_sprites_Building.isClickable) (js_Boot.__cast(this.linkedVirtualCell , com_isartdigital_perle_game_virtual_VBuilding)).onClick(this.position);
	}
	,changeCursor: function() {
		if(com_isartdigital_perle_game_sprites_Building.isClickable) this.defaultCursor = "pointer"; else this.defaultCursor = "default";
	}
	,__class__: com_isartdigital_perle_game_sprites_Building
});
var com_isartdigital_perle_game_sprites_FootPrint = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Tile.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.FootPrint"] = com_isartdigital_perle_game_sprites_FootPrint;
com_isartdigital_perle_game_sprites_FootPrint.__name__ = ["com","isartdigital","perle","game","sprites","FootPrint"];
com_isartdigital_perle_game_sprites_FootPrint.startClass = function() {
	com_isartdigital_perle_game_sprites_Phantom.eExceedingTiles.addListener("Phantom_Cant_Build",com_isartdigital_perle_game_sprites_FootPrint.onCantBeBuid);
};
com_isartdigital_perle_game_sprites_FootPrint.initClass = function() {
	com_isartdigital_perle_game_sprites_FootPrint.container = new PIXI.Container();
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_game_sprites_FootPrint.container);
};
com_isartdigital_perle_game_sprites_FootPrint.createShadow = function(pInstance) {
	com_isartdigital_perle_game_sprites_FootPrint.lInstance = pInstance;
<<<<<<< HEAD:bin/ui.js
	var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
	var key = com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName;
	if((__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).footprint == 0) {
		com_isartdigital_perle_game_sprites_FootPrint.deplacementFootprint = 0;
	} else {
		com_isartdigital_perle_game_sprites_FootPrint.deplacementFootprint = 100;
	}
	var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
	var key1 = com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName;
	var tmp = (__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).width;
	var _this2 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
	var key2 = com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName;
	var lX = js_Boot.__cast(tmp + (__map_reserved[key2] != null?_this2.getReserved(key2):_this2.h[key2]).footprint * 2 , Int);
	var _this3 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
	var key3 = com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName;
	var tmp1 = (__map_reserved[key3] != null?_this3.getReserved(key3):_this3.h[key3]).height;
	var _this4 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
	var key4 = com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName;
	var lY = js_Boot.__cast(tmp1 + (__map_reserved[key4] != null?_this4.getReserved(key4):_this4.h[key4]).footprint * 2 , Int);
	com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray = [];
	com_isartdigital_perle_game_sprites_FootPrintAsset.arrayContainerFootPrint = [];
	var _g1 = 0;
	while(_g1 < lY) {
		var j = _g1++;
		com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[j] = [];
		com_isartdigital_perle_game_sprites_FootPrintAsset.arrayContainerFootPrint[j] = [];
		var _g3 = 0;
		while(_g3 < lX) {
			var i = _g3++;
			com_isartdigital_perle_game_sprites_FootPrintAsset.createFootPrint(j,i);
			com_isartdigital_perle_game_sprites_FootPrint.container.addChild(com_isartdigital_perle_game_sprites_FootPrintAsset.arrayContainerFootPrint[j][i]);
		}
	}
	com_isartdigital_perle_game_sprites_FootPrint.eventArray = [];
<<<<<<< HEAD
	com_isartdigital_perle_game_sprites_FootPrint.setPositionFootPrintAssets(pInstance.position);
=======
	com_isartdigital_perle_game_sprites_FootPrint.setPositionFootPrintAssets(pInstance);
=======
	com_isartdigital_perle_game_sprites_FootPrint.footPrint = com_isartdigital_perle_game_managers_PoolingManager.getFromPool("FootPrint");
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.init();
	com_isartdigital_perle_game_sprites_FootPrint.container.addChild(com_isartdigital_perle_game_sprites_FootPrint.footPrint);
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.start();
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.rotation = 0.785398;
	com_isartdigital_perle_game_sprites_FootPrint.container.scale.y = 0.5;
	if(com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName).footprint == 0) com_isartdigital_perle_game_sprites_FootPrint.deplacementFootprint = 0; else com_isartdigital_perle_game_sprites_FootPrint.deplacementFootprint = 100;
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.position = new PIXI.Point(com_isartdigital_perle_game_sprites_FootPrint.lInstance.x,(com_isartdigital_perle_game_sprites_FootPrint.lInstance.y - com_isartdigital_perle_game_sprites_FootPrint.deplacementFootprint) * 2);
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.width = com_isartdigital_perle_game_sprites_FootPrint.footPrint.width * (com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName).width + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName).footprint * 2);
	com_isartdigital_perle_game_sprites_FootPrint.footPrint.height = com_isartdigital_perle_game_sprites_FootPrint.footPrint.height * (com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName).height + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(com_isartdigital_perle_game_sprites_FootPrint.lInstance.buildingName).footprint * 2);
>>>>>>> btn accelerate working:bin/Builder.js
>>>>>>> btn accelerate working
};
com_isartdigital_perle_game_sprites_FootPrint.onCantBeBuid = function(pEvent) {
	com_isartdigital_perle_game_sprites_FootPrint.eventArray = pEvent.exceedingTile;
	com_isartdigital_perle_game_sprites_FootPrint.setPositionFootPrintAssets(pEvent.phantomPosition);
	var _g1 = 0;
	var _g = pEvent.exceedingTile.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].x + 1] != null && com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].x + 1][pEvent.exceedingTile[i].y + 1] != null) {
			com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[pEvent.exceedingTile[i].y + 1][pEvent.exceedingTile[i].x + 1].setStateCantBePut();
		}
	}
};
com_isartdigital_perle_game_sprites_FootPrint.setPositionFootPrintAssets = function(pInstancePosition) {
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray.length;
	while(_g1 < _g) {
		var k = _g1++;
		var _g3 = 0;
		var _g2 = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k].length;
		while(_g3 < _g2) {
			var l = _g3++;
			var lPoint = new PIXI.Point(l - 1,k - 1);
			lPoint = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(lPoint);
			lPoint = new PIXI.Point(lPoint.x + pInstancePosition.x,lPoint.y + pInstancePosition.y);
			var tmp = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k];
			tmp[l].position = new PIXI.Point(lPoint.x,lPoint.y);
			com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k][l].setStateCanBePut();
		}
	}
};
com_isartdigital_perle_game_sprites_FootPrint.removeShadow = function() {
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray.length;
	while(_g1 < _g) {
		var k = _g1++;
		var _g3 = 0;
		var _g2 = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k].length;
		while(_g3 < _g2) {
			var l = _g3++;
			var tmp = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k];
			tmp[l].scale = new PIXI.Point(1,1);
			com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[k][l].recycle();
		}
	}
};
com_isartdigital_perle_game_sprites_FootPrint.__super__ = com_isartdigital_perle_game_sprites_Tile;
com_isartdigital_perle_game_sprites_FootPrint.prototype = $extend(com_isartdigital_perle_game_sprites_Tile.prototype,{
	init: function() {
		com_isartdigital_perle_game_sprites_Tile.prototype.init.call(this);
	}
	,recycle: function() {
		com_isartdigital_perle_game_sprites_Tile.prototype.recycle.call(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_FootPrint
});
var com_isartdigital_perle_game_sprites_FootPrintAsset = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Tile.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.FootPrintAsset"] = com_isartdigital_perle_game_sprites_FootPrintAsset;
com_isartdigital_perle_game_sprites_FootPrintAsset.__name__ = ["com","isartdigital","perle","game","sprites","FootPrintAsset"];
com_isartdigital_perle_game_sprites_FootPrintAsset.createFootPrint = function(pJ,pI) {
	com_isartdigital_perle_game_sprites_FootPrintAsset.footPrint = com_isartdigital_perle_game_managers_PoolingManager.getFromPool("FootPrint");
	com_isartdigital_perle_game_sprites_FootPrintAsset.footPrint.init();
	var lContainer = new PIXI.Container();
	lContainer.addChild(com_isartdigital_perle_game_sprites_FootPrintAsset.footPrint);
	com_isartdigital_perle_game_sprites_FootPrintAsset.footPrint.start();
	com_isartdigital_perle_game_sprites_FootPrintAsset.footPrintArray[pJ][pI] = com_isartdigital_perle_game_sprites_FootPrintAsset.footPrint;
	com_isartdigital_perle_game_sprites_FootPrintAsset.arrayContainerFootPrint[pJ][pI] = lContainer;
};
com_isartdigital_perle_game_sprites_FootPrintAsset.__super__ = com_isartdigital_perle_game_sprites_Tile;
com_isartdigital_perle_game_sprites_FootPrintAsset.prototype = $extend(com_isartdigital_perle_game_sprites_Tile.prototype,{
	setStateCantBePut: function() {
		this.setState(this.DEFAULT_STATE);
		this.setState("red");
	}
	,setStateCanBePut: function() {
		this.setState(this.DEFAULT_STATE);
		this.setState("green");
	}
	,setStateAreaEffect: function() {
		this.setState("yellow");
	}
	,init: function() {
		com_isartdigital_perle_game_sprites_Tile.prototype.init.call(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_FootPrintAsset
});
var com_isartdigital_perle_game_sprites_Ground = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Tile.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.Ground"] = com_isartdigital_perle_game_sprites_Ground;
com_isartdigital_perle_game_sprites_Ground.__name__ = ["com","isartdigital","perle","game","sprites","Ground"];
com_isartdigital_perle_game_sprites_Ground.initClass = function() {
	com_isartdigital_perle_game_sprites_Ground.mapArray = new haxe_ds_IntMap();
	com_isartdigital_perle_game_sprites_Ground.container = new PIXI.Container();
	com_isartdigital_perle_game_sprites_Ground.colorMatrix = new PIXI.filters.ColorMatrixFilter();
	com_isartdigital_perle_game_sprites_Ground.colorMatrix.brightness(1.3,false);
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_game_sprites_Ground.container);
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") window.addEventListener("mousemove",com_isartdigital_perle_game_sprites_Ground.hoverGround);
};
com_isartdigital_perle_game_sprites_Ground.hoverGround = function(pEvent) {
	com_isartdigital_perle_game_sprites_Ground.lightCell(com_isartdigital_perle_game_managers_MouseManager.getInstance().getLocalMouseMapPos());
};
com_isartdigital_perle_game_sprites_Ground.createGround = function(pTileDesc) {
	var lGround = com_isartdigital_perle_game_managers_PoolingManager.getFromPool(pTileDesc.buildingName);
	var regionFirstTilePos;
	regionFirstTilePos = ((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[pTileDesc.regionX];
		$r = this1.get(pTileDesc.regionY);
		return $r;
	}(this))).desc.firstTilePos;
	com_isartdigital_perle_game_sprites_Ground.addToGroundMap(pTileDesc.mapX + regionFirstTilePos.x,pTileDesc.mapY + regionFirstTilePos.y,lGround);
	lGround.positionTile(pTileDesc.mapX + regionFirstTilePos.x,pTileDesc.mapY + regionFirstTilePos.y);
	lGround.init();
	com_isartdigital_perle_game_sprites_Ground.container.addChild(lGround);
	lGround.start();
	lGround.alpha = 0.2;
	return lGround;
};
com_isartdigital_perle_game_sprites_Ground.addToGroundMap = function(pX,pY,pGround) {
	if(com_isartdigital_perle_game_sprites_Ground.mapArray.h[pX] == null) {
		var v = new haxe_ds_IntMap();
		com_isartdigital_perle_game_sprites_Ground.mapArray.h[pX] = v;
		v;
	}
	var this1 = com_isartdigital_perle_game_sprites_Ground.mapArray.h[pX];
	this1.set(pY,pGround);
	pGround;
};
com_isartdigital_perle_game_sprites_Ground.lightCell = function(pPoint) {
	var lGround = null;
	if((function($this) {
		var $r;
		var key = Math.floor(pPoint.x);
		$r = com_isartdigital_perle_game_sprites_Ground.mapArray.h[key];
		return $r;
	}(this)) != null && (function($this) {
		var $r;
		var this1;
		{
			var key2 = Math.floor(pPoint.x);
			this1 = com_isartdigital_perle_game_sprites_Ground.mapArray.h[key2];
		}
		var key1 = Math.floor(pPoint.y);
		$r = this1.get(key1);
		return $r;
	}(this)) != null) {
		var this2;
		var key4 = Math.floor(pPoint.x);
		this2 = com_isartdigital_perle_game_sprites_Ground.mapArray.h[key4];
		var key3 = Math.floor(pPoint.y);
		lGround = this2.get(key3);
	}
	if(lGround != null) {
		if(com_isartdigital_perle_game_sprites_Ground.previousCell == null || (lGround.x != com_isartdigital_perle_game_sprites_Ground.previousCell.x || lGround.y != com_isartdigital_perle_game_sprites_Ground.previousCell.y)) {
			lGround.addFilterCell();
			if(com_isartdigital_perle_game_sprites_Ground.previousCell != null) com_isartdigital_perle_game_sprites_Ground.previousCell.removeFilterCell();
			com_isartdigital_perle_game_sprites_Ground.previousCell = lGround;
		}
	} else {
		if(com_isartdigital_perle_game_sprites_Ground.previousCell != null) com_isartdigital_perle_game_sprites_Ground.previousCell.removeFilterCell();
		com_isartdigital_perle_game_sprites_Ground.previousCell = null;
	}
};
com_isartdigital_perle_game_sprites_Ground.destroyStatic = function() {
	window.removeEventListener("mousemove",com_isartdigital_perle_game_sprites_Ground.hoverGround);
	com_isartdigital_perle_game_sprites_Ground.previousCell = null;
	com_isartdigital_perle_game_sprites_Ground.mapArray = null;
	com_isartdigital_perle_game_sprites_Ground.colorMatrix = null;
};
com_isartdigital_perle_game_sprites_Ground.__super__ = com_isartdigital_perle_game_sprites_Tile;
com_isartdigital_perle_game_sprites_Ground.prototype = $extend(com_isartdigital_perle_game_sprites_Tile.prototype,{
	addFilterCell: function() {
		if(this.filters == null) this.filters = [com_isartdigital_perle_game_sprites_Ground.colorMatrix];
	}
	,removeFilterCell: function() {
		this.filters = null;
	}
	,positionTile: function(pGridX,pGridY) {
		com_isartdigital_perle_game_sprites_Tile.prototype.positionTile.call(this,pGridX,pGridY);
		this.mapX = pGridX;
		this.mapY = pGridY;
	}
	,givePositionIso: function(pX,pY) {
		this.positionTile(pX | 0,pY | 0);
	}
	,recycle: function() {
		var this1 = com_isartdigital_perle_game_sprites_Ground.mapArray.h[this.mapX];
		this1.set(this.mapY,null);
		null;
		com_isartdigital_perle_game_sprites_Tile.prototype.recycle.call(this);
	}
	,destroy: function() {
		var this1 = com_isartdigital_perle_game_sprites_Ground.mapArray.h[this.mapX];
		this1.set(this.mapY,null);
		null;
		com_isartdigital_perle_game_sprites_Tile.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_Ground
});
var com_isartdigital_perle_game_sprites_Intern = function(pInternDatas) {
	{
		com_isartdigital_perle_game_sprites_Intern.internsList.h[pInternDatas.id] = pInternDatas;
		pInternDatas;
	}
	com_isartdigital_perle_game_sprites_Intern.internsListArray.push(pInternDatas);
};
$hxClasses["com.isartdigital.perle.game.sprites.Intern"] = com_isartdigital_perle_game_sprites_Intern;
com_isartdigital_perle_game_sprites_Intern.__name__ = ["com","isartdigital","perle","game","sprites","Intern"];
com_isartdigital_perle_game_sprites_Intern.init = function() {
	com_isartdigital_perle_game_sprites_Intern.internsListArray = [];
	com_isartdigital_perle_game_sprites_Intern.internsList = new haxe_ds_IntMap();
	var lId = com_isartdigital_perle_game_managers_IdManager.newId();
	var lTestInternDatas = { id : lId, name : "Angel A. Merkhell", aligment : "angel", quest : null, price : 2000, stress : 0, stressLimit : 10, speed : 1.5, efficiency : 0.1};
	var lTestNewIntern = new com_isartdigital_perle_game_sprites_Intern(lTestInternDatas);
	var lTestInternDatas2 = { id : com_isartdigital_perle_game_managers_IdManager.newId(), name : "Archanglina Jolie", aligment : "demon", quest : null, price : 2000, stress : 0, stressLimit : 10, speed : 1, efficiency : 0.1};
	var lTestNewIntern2 = new com_isartdigital_perle_game_sprites_Intern(lTestInternDatas2);
};
com_isartdigital_perle_game_sprites_Intern.prototype = {
	__class__: com_isartdigital_perle_game_sprites_Intern
};
var com_isartdigital_perle_game_sprites_Phantom = function(pAssetName) {
	this.precedentBesMapPos = new PIXI.Point(0,0);
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.Phantom"] = com_isartdigital_perle_game_sprites_Phantom;
com_isartdigital_perle_game_sprites_Phantom.__name__ = ["com","isartdigital","perle","game","sprites","Phantom"];
com_isartdigital_perle_game_sprites_Phantom.initClass = function() {
	com_isartdigital_perle_game_sprites_Phantom.container = new PIXI.Container();
	com_isartdigital_perle_game_sprites_Phantom.colorMatrix = new PIXI.filters.ColorMatrixFilter();
	com_isartdigital_perle_game_sprites_Phantom.colorMatrix.desaturate(false);
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_game_sprites_Phantom.container);
	com_isartdigital_perle_game_sprites_Phantom.eExceedingTiles = new EventEmitter();
	com_isartdigital_perle_game_sprites_Phantom.exceedingTile = [];
<<<<<<< HEAD
=======
	com_isartdigital_perle_game_sprites_Phantom.eExceedingTiles.addListener("Phantom_Cant_Build",com_isartdigital_perle_game_sprites_Phantom.test);
};
com_isartdigital_perle_game_sprites_Phantom.test = function(pEvent) {
<<<<<<< HEAD:bin/ui.js
=======
	console.log(pEvent);
>>>>>>> btn accelerate working:bin/Builder.js
>>>>>>> btn accelerate working
};
com_isartdigital_perle_game_sprites_Phantom.gameLoop = function() {
	if(com_isartdigital_perle_game_sprites_Phantom.instance != null) com_isartdigital_perle_game_sprites_Phantom.instance.doAction();
};
com_isartdigital_perle_game_sprites_Phantom.onClickShop = function(pBuildingName) {
	com_isartdigital_perle_game_sprites_Phantom.alignementBuilding = com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_ALIGNEMENT.get(pBuildingName);
	com_isartdigital_perle_game_sprites_Phantom.createPhantom(pBuildingName);
};
com_isartdigital_perle_game_sprites_Phantom.onClickMove = function(pBuildingName,pVBuilding) {
<<<<<<< HEAD:bin/ui.js
	var _this = com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_ALIGNEMENT;
	com_isartdigital_perle_game_sprites_Phantom.alignementBuilding = __map_reserved[pBuildingName] != null?_this.getReserved(pBuildingName):_this.h[pBuildingName];
=======
	com_isartdigital_perle_game_sprites_Phantom.alignementBuilding = com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_ALIGNEMENT.get(pBuildingName);
>>>>>>> btn accelerate working:bin/Builder.js
	com_isartdigital_perle_game_sprites_Phantom.createPhantom(pBuildingName);
	com_isartdigital_perle_game_sprites_Phantom.instance.vBuilding = pVBuilding;
	com_isartdigital_perle_game_sprites_Phantom.instance.position = pVBuilding.graphic.position;
};
com_isartdigital_perle_game_sprites_Phantom.onClickCancelBuild = function() {
	com_isartdigital_perle_game_sprites_Phantom.instance.destroy();
};
com_isartdigital_perle_game_sprites_Phantom.onClickCancelMove = function() {
	com_isartdigital_perle_game_sprites_Phantom.instance.destroy();
};
com_isartdigital_perle_game_sprites_Phantom.onClickConfirmBuild = function() {
	com_isartdigital_perle_game_sprites_Phantom.instance.confirmBuild();
};
com_isartdigital_perle_game_sprites_Phantom.onClickConfirmMove = function() {
	com_isartdigital_perle_game_sprites_Phantom.instance.confirmMove();
};
com_isartdigital_perle_game_sprites_Phantom.createPhantom = function(pBuildingName) {
	if(com_isartdigital_perle_game_sprites_Phantom.instance != null && com_isartdigital_perle_game_sprites_Phantom.instance.assetName == com_isartdigital_perle_game_BuildingName.getAssetName(pBuildingName)) return; else if(com_isartdigital_perle_game_sprites_Phantom.instance != null && com_isartdigital_perle_game_sprites_Phantom.instance.assetName != com_isartdigital_perle_game_BuildingName.getAssetName(pBuildingName)) com_isartdigital_utils_Debug.error("instance must be destroyed before creating another phantom");
	com_isartdigital_perle_game_sprites_Building.isClickable = false;
	console.log("createPhantom " + Std.string(com_isartdigital_perle_game_sprites_Building.isClickable));
	com_isartdigital_perle_game_sprites_Phantom.instance = new com_isartdigital_perle_game_sprites_Phantom(com_isartdigital_perle_game_BuildingName.getAssetName(pBuildingName));
	com_isartdigital_perle_game_sprites_Phantom.instance.setBuildingName(pBuildingName);
	com_isartdigital_perle_game_sprites_Phantom.instance.init();
	com_isartdigital_perle_game_sprites_Phantom.container.addChild(com_isartdigital_perle_game_sprites_Phantom.instance);
	com_isartdigital_perle_game_sprites_FootPrint.createShadow(com_isartdigital_perle_game_sprites_Phantom.instance);
	com_isartdigital_perle_game_sprites_Phantom.instance.start();
};
com_isartdigital_perle_game_sprites_Phantom.isMoving = function() {
	return com_isartdigital_perle_game_sprites_Phantom.instance != null && com_isartdigital_perle_game_sprites_Phantom.instance.mouseDown;
};
com_isartdigital_perle_game_sprites_Phantom.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_Phantom.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	onClickConfirm: function() {
		if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding == null) com_isartdigital_perle_game_sprites_Phantom.onClickConfirmBuild(); else com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.onClickConfirm();
	}
	,setBuildingName: function(pBuildingName) {
		this.buildingName = pBuildingName;
	}
	,init: function() {
		com_isartdigital_perle_game_sprites_Building.prototype.init.call(this);
		this.initPosition();
	}
	,initPosition: function() {
		if(this.position.x == 0 && this.position.y == 0) this.position = com_isartdigital_perle_game_managers_CameraManager.getCameraCenter();
	}
	,start: function() {
		this.setModePhantom();
		this.interactive = true;
		this.addBuildListeners();
	}
	,addBuildListeners: function() {
		if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") {
			this.on("mousedown",$bind(this,this.onMouseDown2));
			this.on("mouseup",$bind(this,this.onMouseUp2));
		} else {
			this.on("touchstart",$bind(this,this.onMouseDown2));
			this.on("touchend",$bind(this,this.onMouseUp2));
		}
		this.on("mousemove",$bind(this,this.movePhantomOnMouse));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this,$bind(this,this.onClickConfirm));
	}
	,removeBuildListeners: function() {
		this.removeListener("mousedown",this.onMouseDown);
		this.removeListener("mouseup",this.onMouseUp);
		this.removeListener("touchstart",this.onMouseDown);
		this.removeListener("touchend",this.onMouseUp);
		this.removeListener("mousemove",$bind(this,this.movePhantomOnMouse));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this,$bind(this,this.onClickConfirm));
	}
	,setModePhantom: function() {
		this.addPhantomFilter();
		this.doAction = $bind(this,this.doActionPhantom);
		this.addBuildListeners();
		this.setState(this.DEFAULT_STATE);
	}
	,doActionPhantom: function() {
	}
	,movePhantomOnMouse: function() {
		var buildingGroundCenter = this.getBuildingGroundCenter();
		var perfectMouseFollow = new PIXI.Point(com_isartdigital_perle_game_managers_MouseManager.getInstance().positionInGame.x + this.x - buildingGroundCenter.x,com_isartdigital_perle_game_managers_MouseManager.getInstance().positionInGame.y + this.y - buildingGroundCenter.y);
		var bestMapPos = this.getRoundMapPos(perfectMouseFollow);
		this.position = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(bestMapPos.x,bestMapPos.y));
		com_isartdigital_perle_ui_hud_building_BHMoving.getInstance().position = new PIXI.Point(this.position.x / 2,this.position.y / 2);
		if(this.precedentBesMapPos.x != bestMapPos.x || this.precedentBesMapPos.y != bestMapPos.y) {
<<<<<<< HEAD:bin/ui.js
			if(this.canBuildHere()) {
				this.removeDesaturateFilter();
			} else {
				this.addDesaturateFilter();
			}
=======
			if(this.canBuildHere()) this.removeDesaturateFilter(); else this.addDesaturateFilter();
>>>>>>> btn accelerate working:bin/Builder.js
			this.emitExceeding();
		}
		this.precedentBesMapPos.copy(new PIXI.Point(bestMapPos.x,bestMapPos.y));
	}
	,getBuildingGroundCenter: function() {
		var mapPos = this.getRoundMapPos(this.position);
		return com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(mapPos.x + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width / 2,mapPos.y + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height / 2));
	}
	,confirmBuild: function() {
		if(this.canBuildHere()) {
			this.newBuild();
			com_isartdigital_perle_game_sprites_Building.isClickable = true;
		} else this.displayCantBuild();
	}
	,confirmMove: function() {
		if(this.canBuildHere()) {
			this.vBuilding.move(this.regionMap);
			com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST,this.vBuilding);
			console.log("movePhantom " + Std.string(com_isartdigital_perle_game_sprites_Building.isClickable));
			com_isartdigital_perle_game_sprites_Building.isClickable = true;
			this.destroy();
			this.applyChange();
		} else this.displayCantBuild();
	}
	,newBuild: function() {
		if(com_isartdigital_perle_game_managers_BuyManager.buy(this.buildingName)) {
			var newId = com_isartdigital_perle_game_managers_IdManager.newId();
			var tTime = new Date().getTime();
			var tileDesc = { buildingName : this.buildingName, id : newId, regionX : this.regionMap.region.x, regionY : this.regionMap.region.y, mapX : this.regionMap.map.x, mapY : this.regionMap.map.y, level : 0, timeDesc : { refTile : newId, end : tTime + 20000, progress : 0, creationDate : tTime}};
			this.vBuilding = Type.createInstance(Type.resolveClass(com_isartdigital_perle_Main.getInstance().getPath(com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_VCLASS.get(this.buildingName))),[tileDesc]);
			this.vBuilding.activate();
			com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION,this.vBuilding);
			this.vBuilding.addExp();
			this.destroy();
			this.applyChange();
		} else this.displayCantBuy();
	}
	,applyChange: function() {
		com_isartdigital_perle_game_managers_SaveManager.save();
		com_isartdigital_perle_game_sprites_Building.sortBuildings();
	}
	,canBuildHere: function() {
		this.setMapColRow(this.getRoundMapPos(this.position),com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName));
		this.regionMap = this.getRegionMap();
		if(com_isartdigital_perle_game_sprites_Phantom.alignementBuilding == null) {
			com_isartdigital_utils_Debug.error("should not be null in my opinion, i am right ? (this line should never happen, contact Ambroise)");
<<<<<<< HEAD:bin/ui.js
			if(this.buildingOnGround()) {
				return this.buildingCollideOther();
			} else {
				return false;
			}
		}
		if(this.regionMap == null || com_isartdigital_perle_game_managers_RegionManager.worldMap.h[this.regionMap.region.x].get(this.regionMap.region.y).desc.type != com_isartdigital_perle_game_sprites_Phantom.alignementBuilding) {
			this.setExceedingToAll();
			return false;
		}
		if(this.buildingOnGround()) {
			return this.buildingCollideOther();
		} else {
=======
			return this.buildingOnGround() && this.buildingCollideOther();
		}
		if(this.regionMap == null || ((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
			$r = this1.get($this.regionMap.region.y);
			return $r;
		}(this))).desc.type != com_isartdigital_perle_game_sprites_Phantom.alignementBuilding) {
			this.setExceedingToAll();
>>>>>>> btn accelerate working:bin/Builder.js
			return false;
		}
		return this.buildingOnGround() && this.buildingCollideOther();
	}
	,getRegionMap: function() {
		var lRegion = com_isartdigital_perle_game_managers_RegionManager.tilePosToRegion({ x : this.colMin, y : this.rowMin});
		var lRegionFirstTile;
		if(lRegion == null) return null;
		lRegionFirstTile = ((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[lRegion.x];
			$r = this1.get(lRegion.y);
			return $r;
		}(this))).desc.firstTilePos;
		return { regionFirstTile : lRegionFirstTile, region : lRegion, map : { x : this.colMin - lRegionFirstTile.x, y : this.rowMin - lRegionFirstTile.y}};
	}
	,buildingOnGround: function() {
		var lRegionSize = { width : 0, height : 0, footprint : 0};
<<<<<<< HEAD:bin/ui.js
		lRegionSize.width = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[this.regionMap.region.x].get(this.regionMap.region.y).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral?3:12;
		lRegionSize.height = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[this.regionMap.region.x].get(this.regionMap.region.y).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral?13:12;
		this.setExceedBuildingOnGround(lRegionSize);
		var tmp = this.regionMap.map.x;
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = this.buildingName;
		if(tmp + (__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).width <= lRegionSize.width) {
			var tmp1 = this.regionMap.map.y;
			var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key1 = this.buildingName;
			return tmp1 + (__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).height <= lRegionSize.height;
		} else {
			return false;
		}
=======
		if(((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
			$r = this1.get($this.regionMap.region.y);
			return $r;
		}(this))).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lRegionSize.width = 3; else lRegionSize.width = 12;
		if(((function($this) {
			var $r;
			var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
			$r = this2.get($this.regionMap.region.y);
			return $r;
		}(this))).desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) lRegionSize.height = 13; else lRegionSize.height = 12;
		this.setExceedBuildingOnGround(lRegionSize);
		return this.regionMap.map.x + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width <= lRegionSize.width && this.regionMap.map.y + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height <= lRegionSize.height;
>>>>>>> btn accelerate working:bin/Builder.js
	}
	,buildingCollideOther: function() {
		var $it0 = (function($this) {
			var $r;
			var this1;
			this1 = ((function($this) {
				var $r;
				var this2 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
				$r = this2.get($this.regionMap.region.y);
				return $r;
			}($this))).building;
			$r = this1.keys();
			return $r;
		}(this));
		while( $it0.hasNext() ) {
			var x = $it0.next();
			var $it1 = (function($this) {
				var $r;
				var this3;
				{
					var this4;
					this4 = ((function($this) {
						var $r;
						var this5 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
						$r = this5.get($this.regionMap.region.y);
						return $r;
					}($this))).building;
					this3 = this4.get(x);
				}
				$r = this3.keys();
				return $r;
			}(this));
			while( $it1.hasNext() ) {
				var y = $it1.next();
				if(((function($this) {
					var $r;
					var this6;
					{
						var this7;
						this7 = ((function($this) {
							var $r;
							var this8 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
							$r = this8.get($this.regionMap.region.y);
							return $r;
						}($this))).building;
						this6 = this7.get(x);
					}
					$r = this6.get(y);
					return $r;
				}(this))).currentState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) continue;
				if(this.collisionRectDesc(((function($this) {
					var $r;
					var this9;
					{
						var this10;
						this10 = ((function($this) {
							var $r;
							var this11 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.regionMap.region.x];
							$r = this11.get($this.regionMap.region.y);
							return $r;
						}($this))).building;
						this9 = this10.get(x);
					}
					$r = this9.get(y);
					return $r;
				}(this))).tileDesc)) return false;
			}
		}
		return true;
	}
	,collisionRectDesc: function(pVirtual) {
		var lCombinedFootprint;
<<<<<<< HEAD:bin/ui.js
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = pVirtual.buildingName;
		var tmp = (__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).footprint;
		var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key1 = this.buildingName;
		lCombinedFootprint = js_Boot.__cast(Math.min(tmp,(__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).footprint) , Int);
		this.setExceedCollisionRectDesc(lCombinedFootprint,pVirtual);
		var tmp1;
		var tmp2;
		var tmp3 = this.regionMap.map.x;
		var tmp4 = pVirtual.mapX;
		var _this2 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key2 = pVirtual.buildingName;
		if(tmp3 < tmp4 + (__map_reserved[key2] != null?_this2.getReserved(key2):_this2.h[key2]).width + lCombinedFootprint) {
			var tmp5 = this.regionMap.map.x;
			var _this3 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key3 = this.buildingName;
			tmp2 = tmp5 + (__map_reserved[key3] != null?_this3.getReserved(key3):_this3.h[key3]).width > pVirtual.mapX - lCombinedFootprint;
		} else {
			tmp2 = false;
		}
		if(tmp2) {
			var tmp6 = this.regionMap.map.y;
			var tmp7 = pVirtual.mapY;
			var _this4 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key4 = pVirtual.buildingName;
			tmp1 = tmp6 < tmp7 + (__map_reserved[key4] != null?_this4.getReserved(key4):_this4.h[key4]).height + lCombinedFootprint;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			var tmp8 = this.regionMap.map.y;
			var _this5 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key5 = this.buildingName;
			return tmp8 + (__map_reserved[key5] != null?_this5.getReserved(key5):_this5.h[key5]).height > pVirtual.mapY - lCombinedFootprint;
		} else {
			return false;
=======
		lCombinedFootprint = js_Boot.__cast(Math.min(com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pVirtual.buildingName).footprint,com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint) , Int);
		this.setExceedCollisionRectDesc(lCombinedFootprint,pVirtual);
		return this.regionMap.map.x < pVirtual.mapX + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pVirtual.buildingName).width + lCombinedFootprint && this.regionMap.map.x + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width > pVirtual.mapX - lCombinedFootprint && this.regionMap.map.y < pVirtual.mapY + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pVirtual.buildingName).height + lCombinedFootprint && this.regionMap.map.y + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height > pVirtual.mapY - lCombinedFootprint;
	}
	,setExceedCollisionRectDesc: function(pCombinedFootprint,pVirtual) {
		var lExceeding = [];
		var lStartBuilding_x = -com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint;
		var lStartBuilding_y = -com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint;
		var lEndBuilding_x = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width;
		var lEndBuilding_y = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint + com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height;
		var _g1 = lStartBuilding_x;
		var _g = lEndBuilding_x;
		while(_g1 < _g) {
			var lX = _g1++;
			var _g3 = lStartBuilding_y;
			var _g2 = lEndBuilding_y;
			while(_g3 < _g2) {
				var lY = _g3++;
				var collide = this.collisionPointRect({ x : lX + this.regionMap.map.x, y : lY + this.regionMap.map.y},new PIXI.Rectangle(pVirtual.mapX - pCombinedFootprint,pVirtual.mapY - pCombinedFootprint,com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pVirtual.buildingName).width + pCombinedFootprint,com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(pVirtual.buildingName).height + pCombinedFootprint));
				if(collide) lExceeding.push({ x : lX, y : lY});
			}
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lExceeding);
		return lExceeding;
	}
	,setExceedBuildingOnGround: function(plRegionSize) {
		var lExceeding = [];
		var lStartBuilding_x = 0;
		var lStartBuilding_y = 0;
		var lEndBuilding_x = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width;
		var lEndBuilding_y = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height;
		var _g1 = lStartBuilding_x;
		var _g = lEndBuilding_x;
		while(_g1 < _g) {
			var lX = _g1++;
			var _g3 = lStartBuilding_y;
			var _g2 = lEndBuilding_y;
			while(_g3 < _g2) {
				var lY = _g3++;
				if(lX + this.regionMap.map.x >= plRegionSize.width || lY + this.regionMap.map.y >= plRegionSize.height) lExceeding.push({ x : lX, y : lY});
			}
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lExceeding);
		return lExceeding;
	}
	,setExceedingToAll: function() {
		var lAllExceeding = [];
		var _g1 = -com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint;
		var _g = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).width;
		while(_g1 < _g) {
			var lX = _g1++;
			var _g3 = -com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).footprint;
			var _g2 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE.get(this.buildingName).height;
			while(_g3 < _g2) {
				var lY = _g3++;
				lAllExceeding.push({ x : lX, y : lY});
			}
>>>>>>> btn accelerate working:bin/Builder.js
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lAllExceeding);
	}
	,emitExceeding: function() {
		com_isartdigital_perle_game_sprites_Phantom.eExceedingTiles.emit("Phantom_Cant_Build",com_isartdigital_perle_game_sprites_Phantom.exceedingTile);
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = [];
	}
	,collisionPointRect: function(pPoint,pRect) {
		if(pPoint.x > pRect.x && pPoint.x < pRect.x + pRect.width && pPoint.y > pRect.y && pPoint.y < pRect.y + pRect.height) return true;
		return false;
	}
	,setExceedCollisionRectDesc: function(pCombinedFootprint,pVirtual) {
		var lExceeding = [];
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = this.buildingName;
		var lStartBuilding_x = -(__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).footprint;
		var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key1 = this.buildingName;
		var lStartBuilding_y = -(__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).footprint;
		var _this2 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key2 = this.buildingName;
		var tmp = (__map_reserved[key2] != null?_this2.getReserved(key2):_this2.h[key2]).footprint;
		var _this3 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key3 = this.buildingName;
		var lEndBuilding_x = tmp + (__map_reserved[key3] != null?_this3.getReserved(key3):_this3.h[key3]).width;
		var _this4 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key4 = this.buildingName;
		var tmp1 = (__map_reserved[key4] != null?_this4.getReserved(key4):_this4.h[key4]).footprint;
		var _this5 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key5 = this.buildingName;
		var lEndBuilding_y = tmp1 + (__map_reserved[key5] != null?_this5.getReserved(key5):_this5.h[key5]).height;
		var _g1 = lStartBuilding_x;
		while(_g1 < lEndBuilding_x) {
			var lX = _g1++;
			var _g3 = lStartBuilding_y;
			while(_g3 < lEndBuilding_y) {
				var lY = _g3++;
				var tmp2 = { x : lX + this.regionMap.map.x, y : lY + this.regionMap.map.y};
				var tmp3 = pVirtual.mapX - pCombinedFootprint;
				var tmp4 = pVirtual.mapY - pCombinedFootprint;
				var _this6 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
				var key6 = pVirtual.buildingName;
				var tmp5 = (__map_reserved[key6] != null?_this6.getReserved(key6):_this6.h[key6]).width + pCombinedFootprint;
				var _this7 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
				var key7 = pVirtual.buildingName;
				if(this.collisionPointRect(tmp2,new PIXI.Rectangle(tmp3,tmp4,tmp5,(__map_reserved[key7] != null?_this7.getReserved(key7):_this7.h[key7]).height + pCombinedFootprint))) {
					lExceeding.push({ x : lX, y : lY});
				}
			}
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lExceeding);
		return lExceeding;
	}
	,setExceedBuildingOnGround: function(plRegionSize) {
		var lExceeding = [];
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = this.buildingName;
		var lEndBuilding_x = (__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).width;
		var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key1 = this.buildingName;
		var lEndBuilding_y = (__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).height;
		var _g1 = 0;
		while(_g1 < lEndBuilding_x) {
			var lX = _g1++;
			var _g3 = 0;
			while(_g3 < lEndBuilding_y) {
				var lY = _g3++;
				if(lX + this.regionMap.map.x >= plRegionSize.width || lY + this.regionMap.map.y >= plRegionSize.height) {
					lExceeding.push({ x : lX, y : lY});
				}
			}
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lExceeding);
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lExceeding);
		return lExceeding;
	}
	,setExceedingToAll: function() {
		var lAllExceeding = [];
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = this.buildingName;
		var _g1 = -(__map_reserved[key] != null?_this.getReserved(key):_this.h[key]).footprint;
		var _this1 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key1 = this.buildingName;
		var _g = (__map_reserved[key1] != null?_this1.getReserved(key1):_this1.h[key1]).width + 1;
		while(_g1 < _g) {
			var lX = _g1++;
			var _this2 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key2 = this.buildingName;
			var _g3 = -(__map_reserved[key2] != null?_this2.getReserved(key2):_this2.h[key2]).footprint;
			var _this3 = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
			var key3 = this.buildingName;
			var _g2 = (__map_reserved[key3] != null?_this3.getReserved(key3):_this3.h[key3]).height + 1;
			while(_g3 < _g2) lAllExceeding.push({ x : lX, y : _g3++});
		}
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = com_isartdigital_perle_game_sprites_Phantom.exceedingTile.concat(lAllExceeding);
	}
	,emitExceeding: function() {
		com_isartdigital_perle_game_sprites_Phantom.eExceedingTiles.emit("Phantom_Cant_Build",{ phantomPosition : com_isartdigital_perle_game_sprites_Phantom.instance.position, exceedingTile : com_isartdigital_perle_game_sprites_Phantom.exceedingTile});
		com_isartdigital_perle_game_sprites_Phantom.exceedingTile = [];
	}
	,collisionPointRect: function(pPoint,pRect) {
		if(pPoint.x > pRect.x && pPoint.x < pRect.x + pRect.width && pPoint.y > pRect.y && pPoint.y < pRect.y + pRect.height) {
			return true;
		}
		return false;
	}
	,getRoundMapPos: function(pPos) {
		var lPoint = com_isartdigital_perle_game_iso_IsoManager.isoViewToModel(pPos);
		return { x : js_Boot.__cast(Math.round(lPoint.x) , Int), y : js_Boot.__cast(Math.round(lPoint.y) , Int)};
	}
	,onMouseDown2: function() {
		this.mouseDown = true;
	}
	,onMouseUp2: function() {
		this.mouseDown = false;
	}
	,displayCantBuild: function() {
		com_isartdigital_perle_ui_hud_building_BHMoving.getInstance().cantBuildHere();
	}
	,displayCantBuy: function() {
		com_isartdigital_utils_Debug.error("tentative de pose de bâtiment, mais currencie insuffisante");
		console.log("comment ce-ci peut-il arriver ?");
	}
	,addPhantomFilter: function() {
		this.alpha = 0.5;
	}
	,removePhantomFilter: function() {
		this.alpha = 1.0;
	}
	,addDesaturateFilter: function() {
		if(this.filters == null) this.filters = [com_isartdigital_perle_game_sprites_Phantom.colorMatrix];
	}
	,removeDesaturateFilter: function() {
		this.filters = null;
	}
	,destroy: function() {
		com_isartdigital_perle_game_sprites_FootPrint.removeShadow();
		this.vBuilding = null;
		com_isartdigital_perle_game_sprites_Phantom.instance = null;
		this.removePhantomFilter();
		this.removeDesaturateFilter();
		this.removeBuildListeners();
		com_isartdigital_perle_game_sprites_Building.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_Phantom
});
var com_isartdigital_perle_game_sprites_RegionBackground = function(pAssetName,pTilePos,pMapSize) {
	com_isartdigital_perle_game_sprites_FlumpStateGraphic.call(this,pAssetName);
	this.setMapColRow(pTilePos,pMapSize);
};
$hxClasses["com.isartdigital.perle.game.sprites.RegionBackground"] = com_isartdigital_perle_game_sprites_RegionBackground;
com_isartdigital_perle_game_sprites_RegionBackground.__name__ = ["com","isartdigital","perle","game","sprites","RegionBackground"];
com_isartdigital_perle_game_sprites_RegionBackground.__interfaces__ = [com_isartdigital_perle_game_iso_IZSortable];
com_isartdigital_perle_game_sprites_RegionBackground.__super__ = com_isartdigital_perle_game_sprites_FlumpStateGraphic;
com_isartdigital_perle_game_sprites_RegionBackground.prototype = $extend(com_isartdigital_perle_game_sprites_FlumpStateGraphic.prototype,{
	setMapColRow: function(pTilePos,pMapSize) {
		this.colMax = pTilePos.x + pMapSize.x - 1;
		this.colMin = pTilePos.x;
		this.rowMax = pTilePos.y + pMapSize.y - 1;
		this.rowMin = pTilePos.y;
	}
	,__class__: com_isartdigital_perle_game_sprites_RegionBackground
});
var com_isartdigital_perle_game_sprites_Tribunal = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.Tribunal"] = com_isartdigital_perle_game_sprites_Tribunal;
com_isartdigital_perle_game_sprites_Tribunal.__name__ = ["com","isartdigital","perle","game","sprites","Tribunal"];
com_isartdigital_perle_game_sprites_Tribunal.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_Tribunal.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	init: function() {
		com_isartdigital_perle_game_sprites_Building.prototype.init.call(this);
		com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance().position = this.position.clone();
		com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance().position.y += this.height / 2 + 50;
		com_isartdigital_perle_game_sprites_Building.uiContainer.addChild(com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance());
	}
	,destroy: function() {
		com_isartdigital_perle_game_sprites_Building.uiContainer.removeChild(com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance());
		com_isartdigital_perle_game_sprites_Building.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_sprites_Tribunal
});
var com_isartdigital_perle_game_sprites_building_House = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.House"] = com_isartdigital_perle_game_sprites_building_House;
com_isartdigital_perle_game_sprites_building_House.__name__ = ["com","isartdigital","perle","game","sprites","building","House"];
com_isartdigital_perle_game_sprites_building_House.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_House.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_House
});
var com_isartdigital_perle_game_sprites_building_VirtuesBuilding = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.VirtuesBuilding"] = com_isartdigital_perle_game_sprites_building_VirtuesBuilding;
com_isartdigital_perle_game_sprites_building_VirtuesBuilding.__name__ = ["com","isartdigital","perle","game","sprites","building","VirtuesBuilding"];
com_isartdigital_perle_game_sprites_building_VirtuesBuilding.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_VirtuesBuilding.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_VirtuesBuilding
});
var com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.heaven.DecoHeaven"] = com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven;
com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven.__name__ = ["com","isartdigital","perle","game","sprites","building","heaven","DecoHeaven"];
com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_heaven_DecoHeaven
});
var com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven = function(pAssetName) {
	com_isartdigital_perle_game_sprites_building_House.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.heaven.HouseHeaven"] = com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven;
com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven.__name__ = ["com","isartdigital","perle","game","sprites","building","heaven","HouseHeaven"];
com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven.__super__ = com_isartdigital_perle_game_sprites_building_House;
com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven.prototype = $extend(com_isartdigital_perle_game_sprites_building_House.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_heaven_HouseHeaven
});
var com_isartdigital_perle_game_sprites_building_heaven_Lumbermill = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.heaven.Lumbermill"] = com_isartdigital_perle_game_sprites_building_heaven_Lumbermill;
com_isartdigital_perle_game_sprites_building_heaven_Lumbermill.__name__ = ["com","isartdigital","perle","game","sprites","building","heaven","Lumbermill"];
com_isartdigital_perle_game_sprites_building_heaven_Lumbermill.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_heaven_Lumbermill.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_heaven_Lumbermill
});
var com_isartdigital_perle_game_sprites_building_hell_DecoHell = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.hell.DecoHell"] = com_isartdigital_perle_game_sprites_building_hell_DecoHell;
com_isartdigital_perle_game_sprites_building_hell_DecoHell.__name__ = ["com","isartdigital","perle","game","sprites","building","hell","DecoHell"];
com_isartdigital_perle_game_sprites_building_hell_DecoHell.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_hell_DecoHell.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_hell_DecoHell
});
var com_isartdigital_perle_game_sprites_building_hell_HouseHell = function(pAssetName) {
	com_isartdigital_perle_game_sprites_building_House.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.hell.HouseHell"] = com_isartdigital_perle_game_sprites_building_hell_HouseHell;
com_isartdigital_perle_game_sprites_building_hell_HouseHell.__name__ = ["com","isartdigital","perle","game","sprites","building","hell","HouseHell"];
com_isartdigital_perle_game_sprites_building_hell_HouseHell.__super__ = com_isartdigital_perle_game_sprites_building_House;
com_isartdigital_perle_game_sprites_building_hell_HouseHell.prototype = $extend(com_isartdigital_perle_game_sprites_building_House.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_hell_HouseHell
});
var com_isartdigital_perle_game_sprites_building_hell_Quarry = function(pAssetName) {
	com_isartdigital_perle_game_sprites_Building.call(this,pAssetName);
};
$hxClasses["com.isartdigital.perle.game.sprites.building.hell.Quarry"] = com_isartdigital_perle_game_sprites_building_hell_Quarry;
com_isartdigital_perle_game_sprites_building_hell_Quarry.__name__ = ["com","isartdigital","perle","game","sprites","building","hell","Quarry"];
com_isartdigital_perle_game_sprites_building_hell_Quarry.__super__ = com_isartdigital_perle_game_sprites_Building;
com_isartdigital_perle_game_sprites_building_hell_Quarry.prototype = $extend(com_isartdigital_perle_game_sprites_Building.prototype,{
	__class__: com_isartdigital_perle_game_sprites_building_hell_Quarry
});
var com_isartdigital_perle_game_virtual_VBuildingState = { __ename__ : true, __constructs__ : ["isBuilt","isBuilding","isMoving"] };
com_isartdigital_perle_game_virtual_VBuildingState.isBuilt = ["isBuilt",0];
com_isartdigital_perle_game_virtual_VBuildingState.isBuilt.toString = $estr;
com_isartdigital_perle_game_virtual_VBuildingState.isBuilt.__enum__ = com_isartdigital_perle_game_virtual_VBuildingState;
com_isartdigital_perle_game_virtual_VBuildingState.isBuilding = ["isBuilding",1];
com_isartdigital_perle_game_virtual_VBuildingState.isBuilding.toString = $estr;
com_isartdigital_perle_game_virtual_VBuildingState.isBuilding.__enum__ = com_isartdigital_perle_game_virtual_VBuildingState;
com_isartdigital_perle_game_virtual_VBuildingState.isMoving = ["isMoving",2];
com_isartdigital_perle_game_virtual_VBuildingState.isMoving.toString = $estr;
com_isartdigital_perle_game_virtual_VBuildingState.isMoving.__enum__ = com_isartdigital_perle_game_virtual_VBuildingState;
var com_isartdigital_perle_game_virtual_Virtual = function() {
	this.ignore = false;
	this.active = false;
};
$hxClasses["com.isartdigital.perle.game.virtual.Virtual"] = com_isartdigital_perle_game_virtual_Virtual;
com_isartdigital_perle_game_virtual_Virtual.__name__ = ["com","isartdigital","perle","game","virtual","Virtual"];
com_isartdigital_perle_game_virtual_Virtual.prototype = {
	removeLink: function() {
		console.log("function that should not be used !");
		this.graphic = null;
	}
	,activate: function() {
		if(this.active) com_isartdigital_utils_Debug.error("Virtual is already active !");
		this.active = true;
	}
	,desactivate: function() {
		if(!this.active) com_isartdigital_utils_Debug.error("Virtual is already desactived !");
		this.active = false;
		this.removeGraphic();
	}
	,removeGraphic: function() {
		if(this.graphic != null) {
			if(js_Boot.__instanceof(this.graphic,com_isartdigital_perle_game_managers_PoolingObject)) (js_Boot.__cast(this.graphic , com_isartdigital_perle_game_managers_PoolingObject)).recycle(); else this.graphic.destroy();
		}
		this.graphic = null;
	}
	,destroy: function() {
		if(this.active) this.desactivate();
	}
	,__class__: com_isartdigital_perle_game_virtual_Virtual
};
var com_isartdigital_perle_game_virtual_VTile = function(pDescription) {
	com_isartdigital_perle_game_virtual_Virtual.call(this);
	this.tileDesc = pDescription;
	var regionPos;
	regionPos = ((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.tileDesc.regionX];
		$r = this1.get($this.tileDesc.regionY);
		return $r;
	}(this))).desc.firstTilePos;
	this.position = com_isartdigital_perle_game_iso_IsoManager.modelToIsoView(new PIXI.Point(this.tileDesc.mapX + regionPos.x,this.tileDesc.mapY + regionPos.y));
	this.positionClippingMap = { x : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.posToClippingMap(this.position).x , Int), y : js_Boot.__cast(com_isartdigital_perle_game_managers_ClippingManager.posToClippingMap(this.position).y , Int)};
	this.addToClippingList(this.positionClippingMap);
};
$hxClasses["com.isartdigital.perle.game.virtual.VTile"] = com_isartdigital_perle_game_virtual_VTile;
com_isartdigital_perle_game_virtual_VTile.__name__ = ["com","isartdigital","perle","game","virtual","VTile"];
com_isartdigital_perle_game_virtual_VTile.indexToPoint = function(pIndex) {
	return new PIXI.Point(pIndex.x,pIndex.y);
};
com_isartdigital_perle_game_virtual_VTile.pointToIndex = function(pPoint) {
	return { x : pPoint.x | 0, y : pPoint.y | 0};
};
com_isartdigital_perle_game_virtual_VTile.initClass = function() {
	com_isartdigital_perle_game_virtual_VTile.clippingMap = new haxe_ds_IntMap();
};
com_isartdigital_perle_game_virtual_VTile.buildInsideRegion = function(pRegion,pImmediateVisible) {
	if(pImmediateVisible == null) pImmediateVisible = false;
	var col;
	if(pRegion.desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) col = 3; else col = 12;
	var row;
	if(pRegion.desc.type == com_isartdigital_perle_game_managers_Alignment.neutral) row = 13; else row = 12;
	var _g = 0;
	while(_g < col) {
		var x = _g++;
		var _g1 = 0;
		while(_g1 < row) {
			var y = _g1++;
			var tempRoadAssetName;
			if(com_isartdigital_perle_game_virtual_VTile.ROAD_MAP[x] != null && com_isartdigital_perle_game_virtual_VTile.ROAD_MAP[x][y] != null && com_isartdigital_perle_game_virtual_VTile.ROAD_MAP[x][y] != "") tempRoadAssetName = com_isartdigital_perle_game_virtual_VTile.ROAD_MAP[x][y]; else tempRoadAssetName = "Ground";
			var tileDesc = { buildingName : "Ground", id : com_isartdigital_perle_game_managers_IdManager.newId(), regionX : pRegion.desc.x, regionY : pRegion.desc.y, mapX : x, mapY : y, level : 0};
			var lGround = new com_isartdigital_perle_game_virtual_VGround(tileDesc);
			if(pImmediateVisible) lGround.activate();
		}
	}
};
com_isartdigital_perle_game_virtual_VTile.buildWhitoutSave = function() {
<<<<<<< HEAD:bin/ui.js
=======
	if((function($this) {
		var $r;
		var this1 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[0];
		$r = this1.get(0);
		return $r;
	}(this)) == null) throw new js__$Boot_HaxeError("first Region not created");
>>>>>>> btn accelerate working:bin/Builder.js
};
com_isartdigital_perle_game_virtual_VTile.buildFromSave = function(pSave) {
	var lLength = pSave.ground.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		new com_isartdigital_perle_game_virtual_VGround(pSave.ground[i]);
	}
	lLength = pSave.building.length;
	var _g1 = 0;
	while(_g1 < lLength) {
		var i1 = _g1++;
		if(pSave.building[i1].isTribunal) com_isartdigital_perle_game_virtual_vBuilding_VTribunal.getInstance(pSave.building[i1]); else {
			if(com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_VCLASS.get(pSave.building[i1].buildingName) == null) com_isartdigital_utils_Debug.error("VClass for buildingName '" + pSave.building[i1].buildingName + "' not found in Virtual.BUILDING_NAME_TO_VCLASS .");
			Type.createInstance(Type.resolveClass(com_isartdigital_perle_Main.getInstance().getPath(com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_VCLASS.get(pSave.building[i1].buildingName))),[pSave.building[i1]]);
		}
	}
};
com_isartdigital_perle_game_virtual_VTile.__super__ = com_isartdigital_perle_game_virtual_Virtual;
com_isartdigital_perle_game_virtual_VTile.prototype = $extend(com_isartdigital_perle_game_virtual_Virtual.prototype,{
	addToClippingList: function(pPos) {
		if(com_isartdigital_perle_game_virtual_VTile.clippingMap.h[pPos.x] == null) {
			var v = new haxe_ds_IntMap();
			com_isartdigital_perle_game_virtual_VTile.clippingMap.h[pPos.x] = v;
			v;
		}
		if((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_virtual_VTile.clippingMap.h[pPos.x];
			$r = this1.get(pPos.y);
			return $r;
		}(this)) == null) {
			var this2 = com_isartdigital_perle_game_virtual_VTile.clippingMap.h[pPos.x];
			var v1 = [];
			this2.set(pPos.y,v1);
			v1;
		}
		((function($this) {
			var $r;
			var this3 = com_isartdigital_perle_game_virtual_VTile.clippingMap.h[pPos.x];
			$r = this3.get(pPos.y);
			return $r;
		}(this))).push(this);
	}
	,removeFromClippingList: function() {
		((function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_virtual_VTile.clippingMap.h[$this.positionClippingMap.x];
			$r = this1.get($this.positionClippingMap.y);
			return $r;
		}(this))).splice((function($this) {
			var $r;
			var _this;
			{
				var this2 = com_isartdigital_perle_game_virtual_VTile.clippingMap.h[$this.positionClippingMap.x];
				_this = this2.get($this.positionClippingMap.y);
			}
			$r = HxOverrides.indexOf(_this,$this,0);
			return $r;
		}(this)),1);
	}
	,destroy: function() {
		this.removeFromClippingList();
		com_isartdigital_perle_game_virtual_Virtual.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_VTile
});
var com_isartdigital_perle_game_virtual_VBuilding = function(pDescription) {
	this.myTime = 60000;
	this.myMaxContains = 10;
	this.myGeneratorType = com_isartdigital_perle_game_managers_GeneratorType.soft;
	com_isartdigital_perle_game_virtual_VTile.call(this,pDescription);
	this.setHaveRecolter();
	com_isartdigital_perle_game_managers_RegionManager.addToRegionBuilding(this);
	this.addGenerator();
	this.addHudContextual();
	com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.on("GENERATOR",$bind(this,this.updateGeneratorInfo));
	this.currentState = com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime(pDescription);
	if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) {
		com_isartdigital_perle_game_managers_TimeManager.addConstructionTimer(pDescription.timeDesc);
		com_isartdigital_perle_game_managers_TimeManager.eConstruct.on("TimeManager_Construction_End",$bind(this,this.endOfConstruction));
	}
	this.callBoostManager();
	com_isartdigital_perle_game_managers_BoostManager.boostAltarEvent.on("ALTAR_CALL",$bind(this,this.onAltarCheck));
};
$hxClasses["com.isartdigital.perle.game.virtual.VBuilding"] = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_VBuilding.__name__ = ["com","isartdigital","perle","game","virtual","VBuilding"];
com_isartdigital_perle_game_virtual_VBuilding.__super__ = com_isartdigital_perle_game_virtual_VTile;
com_isartdigital_perle_game_virtual_VBuilding.prototype = $extend(com_isartdigital_perle_game_virtual_VTile.prototype,{
	callBoostManager: function() {
		com_isartdigital_perle_game_managers_BoostManager.buildingIsInAltarZone({ x : this.tileDesc.regionX, y : this.tileDesc.regionY},{ x : this.tileDesc.mapX, y : this.tileDesc.mapY},this.tileDesc.id,this.alignementBuilding);
	}
	,setHaveRecolter: function() {
		this.haveRecolter = true;
	}
	,activate: function() {
		com_isartdigital_perle_game_virtual_VTile.prototype.activate.call(this);
		this.graphic = js_Boot.__cast(com_isartdigital_perle_game_sprites_Building.createBuilding(this.tileDesc) , PIXI.Container);
		(js_Boot.__cast(this.graphic , com_isartdigital_perle_game_virtual_HasVirtual)).linkVirtual(js_Boot.__cast(this , com_isartdigital_perle_game_virtual_Virtual));
		this.myVContextualHud.activate();
	}
	,onAltarCheck: function(pData) {
		if(pData.regionPos.x != this.tileDesc.regionX || pData.regionPos.y != this.tileDesc.regionY) {
			return;
		}
		var _this = com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE;
		var key = this.tileDesc.buildingName;
		var mapSize = __map_reserved[key] != null?_this.getReserved(key):_this.h[key];
		var _g1 = this.tileDesc.mapX;
		var _g = this.tileDesc.mapX + mapSize.width;
		while(_g1 < _g) {
			var i = _g1++;
			var _g3 = this.tileDesc.mapX;
			var _g2 = this.tileDesc.mapY + mapSize.height;
			while(_g3 < _g2) {
				var j = _g3++;
				if(i == pData.casePos.x && j == pData.casePos.y) {
					this.callBoostManager();
				}
			}
		}
	}
	,getVirtualContextualHud: function() {
		return this.myVContextualHud;
	}
	,updateGeneratorInfo: function(data) {
		if(this.myGenerator != null && data.id == this.tileDesc.id) this.myGenerator.desc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(this.tileDesc.id,this.myGeneratorType);
	}
	,desactivate: function() {
		com_isartdigital_perle_game_virtual_VTile.prototype.desactivate.call(this);
		if(this.myVContextualHud != null) this.myVContextualHud.desactivate();
	}
	,unlinkContextualHud: function() {
		this.myVContextualHud = null;
	}
	,getGenerator: function() {
		return this.myGenerator;
	}
	,onClick: function(pPos) {
		com_isartdigital_perle_ui_hud_Hud.getInstance().onClickBuilding(this.currentState,this,pPos);
	}
	,onClickMove: function() {
		com_isartdigital_perle_game_sprites_Phantom.onClickMove(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.tileDesc.buildingName,this);
		this.desactivate();
		this.ignore = true;
		this.setState(com_isartdigital_perle_game_virtual_VBuildingState.isMoving);
	}
	,getAsset: function() {
		var lVBuilding;
		if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding != null) lVBuilding = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding; else lVBuilding = com_isartdigital_perle_ui_popin_InfoBuilding.getVirtualBuilding();
		return (js_Boot.__cast(lVBuilding.graphic , com_isartdigital_perle_game_sprites_Building)).getAssetName();
	}
	,onClickCancel: function() {
		com_isartdigital_perle_game_sprites_Phantom.onClickCancelMove();
		this.ignore = false;
		this.activate();
		this.setState(com_isartdigital_perle_game_virtual_VBuildingState.isBuilt);
	}
	,onClickConfirm: function() {
		com_isartdigital_perle_game_sprites_Phantom.onClickConfirmMove();
	}
	,move: function(pRegionMap) {
		this.updateWorldMapPosition(pRegionMap);
		this.activate();
		this.setState(com_isartdigital_perle_game_virtual_VBuildingState.isBuilt);
	}
	,setState: function(pState) {
		if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilt) {
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) console.log("upgrading building ! (todo)");
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) this.setModeMove();
		} else if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) {
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) throw new js__$Boot_HaxeError("can't move while building !");
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilt) this.setModeBuilt();
		} else if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) {
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilt) this.setModeBuilt();
			if(pState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) throw new js__$Boot_HaxeError("can't construct building while moving !");
		} else throw new js__$Boot_HaxeError("setState failed");
	}
	,addExp: function() {
		if(this.alignementBuilding == null || this.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.neutral) {
			com_isartdigital_perle_game_managers_ResourcesManager.takeXp(100,com_isartdigital_perle_game_managers_GeneratorType.badXp);
			com_isartdigital_perle_game_managers_ResourcesManager.takeXp(100,com_isartdigital_perle_game_managers_GeneratorType.goodXp);
		} else if(this.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.hell) com_isartdigital_perle_game_managers_ResourcesManager.takeXp(100,com_isartdigital_perle_game_managers_GeneratorType.badXp); else if(this.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.heaven) com_isartdigital_perle_game_managers_ResourcesManager.takeXp(100,com_isartdigital_perle_game_managers_GeneratorType.goodXp);
	}
	,setModeMove: function() {
		this.currentState = com_isartdigital_perle_game_virtual_VBuildingState.isMoving;
	}
	,setModeBuilt: function() {
		this.currentState = com_isartdigital_perle_game_virtual_VBuildingState.isBuilt;
	}
	,updateWorldMapPosition: function(pRegionMap) {
		var this1;
		var this2;
		this2 = ((function($this) {
			var $r;
			var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.tileDesc.regionX];
			$r = this3.get($this.tileDesc.regionY);
			return $r;
		}(this))).building;
		this1 = this2.get(this.tileDesc.mapX);
		this1.remove(this.tileDesc.mapY);
		this.tileDesc.regionX = pRegionMap.region.x;
		this.tileDesc.regionY = pRegionMap.region.y;
		this.tileDesc.mapX = pRegionMap.map.x;
		this.tileDesc.mapY = pRegionMap.map.y;
		com_isartdigital_perle_game_managers_RegionManager.addToRegionBuilding(this);
	}
	,addGenerator: function() {
<<<<<<< HEAD:bin/ui.js
=======
		if(this.alignementBuilding != null) com_isartdigital_perle_game_managers_BoostManager.callEvent(this.alignementBuilding);
>>>>>>> btn accelerate working:bin/Builder.js
		this.myGenerator = com_isartdigital_perle_game_managers_ResourcesManager.addResourcesGenerator(this.tileDesc.id,this.myGeneratorType,this.myMaxContains,this.myTime);
	}
	,addHudContextual: function() {
		this.myVContextualHud = new com_isartdigital_perle_ui_contextual_VHudContextual();
		this.myVContextualHud.init(this);
	}
	,endOfConstruction: function(pElement) {
		this.setState(com_isartdigital_perle_game_virtual_VBuildingState.isBuilt);
		com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST,this);
		com_isartdigital_perle_game_managers_TimeManager.eConstruct.off("TimeManager_Construction_End",$bind(this,this.endOfConstruction));
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	,destroy: function() {
<<<<<<< HEAD:bin/ui.js
		com_isartdigital_perle_game_managers_BoostManager.boostAltarEvent.off("ALTAR_CALL",$bind(this,this.onAltarCheck));
		if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) {
			throw new js__$Boot_HaxeError("Sure about destroying a moving VBuilding ?? not an error ? ask Ambroise");
		}
=======
		if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) throw new js__$Boot_HaxeError("Sure about destroying a moving VBuilding ?? not an error ? ask Ambroise");
>>>>>>> btn accelerate working:bin/Builder.js
		this.myVContextualHud.destroy();
		this.myVContextualHud = null;
		var lVBuilding;
		lVBuilding = this;
		com_isartdigital_perle_ui_hud_building_BuildingHud.unlinkVirtualBuilding(lVBuilding);
		var this1;
		var this2;
		this2 = ((function($this) {
			var $r;
			var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.tileDesc.regionX];
			$r = this3.get($this.tileDesc.regionY);
			return $r;
		}(this))).building;
		this1 = this2.get(this.tileDesc.mapX);
		this1.remove(this.tileDesc.mapY);
		com_isartdigital_perle_game_managers_TimeManager.destroyTimeElement(this.tileDesc.id);
		if(js_Boot.__instanceof(this,com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)) {
			com_isartdigital_perle_game_managers_ResourcesManager.removeGenerator(this.myGenerator);
			this.myGenerator = null;
			com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.off("GENERATOR",$bind(this,this.updateGeneratorInfo));
		}
		com_isartdigital_perle_game_virtual_VTile.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_VBuilding
});
var com_isartdigital_perle_game_virtual_VGround = function(pDescription) {
	com_isartdigital_perle_game_virtual_VTile.call(this,pDescription);
	com_isartdigital_perle_game_managers_RegionManager.addToRegionGround(this);
};
$hxClasses["com.isartdigital.perle.game.virtual.VGround"] = com_isartdigital_perle_game_virtual_VGround;
com_isartdigital_perle_game_virtual_VGround.__name__ = ["com","isartdigital","perle","game","virtual","VGround"];
com_isartdigital_perle_game_virtual_VGround.__super__ = com_isartdigital_perle_game_virtual_VTile;
com_isartdigital_perle_game_virtual_VGround.prototype = $extend(com_isartdigital_perle_game_virtual_VTile.prototype,{
	activate: function() {
		com_isartdigital_perle_game_virtual_VTile.prototype.activate.call(this);
		this.graphic = js_Boot.__cast(com_isartdigital_perle_game_sprites_Ground.createGround(this.tileDesc) , com_isartdigital_perle_game_sprites_FlumpStateGraphic);
		(js_Boot.__cast(this.graphic , com_isartdigital_perle_game_sprites_Ground)).linkedVirtualCell = this;
	}
	,destroy: function() {
		this.desactivate();
		var this1;
		var this2;
		this2 = ((function($this) {
			var $r;
			var this3 = com_isartdigital_perle_game_managers_RegionManager.worldMap.h[$this.tileDesc.regionX];
			$r = this3.get($this.tileDesc.regionY);
			return $r;
		}(this))).ground;
		this1 = this2.get(this.tileDesc.mapX);
		this1.remove(this.tileDesc.mapY);
		com_isartdigital_perle_game_virtual_VTile.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_VGround
});
var com_isartdigital_perle_game_virtual_vBuilding_VAltar = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.neutral;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
	this.elementHeaven = [];
	this.elementHell = [];
	this.elementHeaven = [];
	this.elementHell = [];
	com_isartdigital_perle_game_managers_BoostManager.boostBuildingEvent.on("BUILDING_CALL",$bind(this,this.onBuildingToAdd));
	this.checkInZone();
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VAltar"] = com_isartdigital_perle_game_virtual_vBuilding_VAltar;
com_isartdigital_perle_game_virtual_vBuilding_VAltar.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VAltar"];
com_isartdigital_perle_game_virtual_vBuilding_VAltar.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VAltar.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	checkInZone: function() {
		this.checkInZoneByAlignment(com_isartdigital_perle_game_managers_Alignment.heaven);
		this.checkInZoneByAlignment(com_isartdigital_perle_game_managers_Alignment.hell);
	}
	,checkInZoneByAlignment: function(pType) {
		var regionPos = pType == com_isartdigital_perle_game_managers_Alignment.heaven?{ x : this.tileDesc.regionX - 1, y : this.tileDesc.regionY}:{ x : this.tileDesc.regionX + 1, y : this.tileDesc.regionY};
		var posX;
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			var _g2 = 0;
			var _g1 = 4 - i;
			while(_g2 < _g1) {
				var j = _g2++;
				if(pType == com_isartdigital_perle_game_managers_Alignment.heaven) {
					posX = 11 - i;
				} else {
					posX = i;
				}
				if(this.tileDesc.mapY - j < 0) {
					com_isartdigital_perle_game_managers_BoostManager.altarCheckIfHasBuilding({ x : regionPos.x, y : regionPos.y - 1},{ x : posX, y : 12 + this.tileDesc.mapY + 1 - j});
				} else {
					com_isartdigital_perle_game_managers_BoostManager.altarCheckIfHasBuilding(regionPos,{ x : posX, y : this.tileDesc.mapY - j});
				}
				if(this.tileDesc.mapY + j + 1 > 12) {
					com_isartdigital_perle_game_managers_BoostManager.altarCheckIfHasBuilding({ x : regionPos.x, y : regionPos.y + 1},{ x : posX, y : this.tileDesc.mapY + j - 12});
				} else {
					com_isartdigital_perle_game_managers_BoostManager.altarCheckIfHasBuilding(regionPos,{ x : posX, y : this.tileDesc.mapY + 1 + j});
				}
			}
		}
	}
	,onBuildingToAdd: function(pData) {
		if(pData.regionPos.y > this.tileDesc.regionY + 1 || pData.regionPos.y < this.tileDesc.regionY - 1) {
			return;
		}
		var posX;
		var _g = 0;
		while(_g < 4) {
			var i = _g++;
			var _g2 = 0;
			var _g1 = 4 - i;
			while(_g2 < _g1) {
				var j = _g2++;
				if(pData.type == com_isartdigital_perle_game_managers_Alignment.heaven) {
					posX = 11 - i;
				} else {
					posX = i;
				}
				if(pData.casePos.x == posX && (pData.casePos.y == 12 + this.tileDesc.mapY + 1 - j || pData.casePos.y == this.tileDesc.mapY - j)) {
					this.addToCorrectArray(pData.buildingRef,pData.type);
					return;
				}
				if(pData.casePos.x == posX && (pData.casePos.y == this.tileDesc.mapY + j - 12 || pData.casePos.y == this.tileDesc.mapY + 1 + j)) {
					this.addToCorrectArray(pData.buildingRef,pData.type);
					return;
				}
			}
		}
	}
	,addToCorrectArray: function(pRef,pType) {
		var myArray = pType == com_isartdigital_perle_game_managers_Alignment.heaven?this.elementHeaven:this.elementHell;
		var _g = 0;
		while(_g < myArray.length) {
			var currentRef = myArray[_g];
			++_g;
			if(currentRef == pRef) {
				return;
			}
		}
		myArray.push(pRef);
		if(pType == com_isartdigital_perle_game_managers_Alignment.heaven) {
			this.elementHeaven = myArray;
		} else {
			this.elementHell = myArray;
		}
	}
	,addGenerator: function() {
		this.myMaxContains = 10000;
		this.myTime = 600000000000;
		com_isartdigital_perle_game_virtual_VBuilding.prototype.addGenerator.call(this);
	}
	,haveMoreBoost: function(data) {
		this.myTime = 60000.;
		com_isartdigital_perle_game_managers_ResourcesManager.UpdateResourcesGenerator(this.myGenerator,this.myMaxContains,this.myTime);
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_BoostManager.boostBuildingEvent.off("BUILDING_CALL",$bind(this,this.onBuildingToAdd));
		com_isartdigital_perle_game_virtual_VBuilding.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VAltar
});
var com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade = function(pDescription) {
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
	this.indexLevel = 0;
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade"] = com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade;
com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VBuildingUpgrade"];
com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	onClickUpgrade: function() {
		this.desactivate();
		if(this.tileDesc.level < com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES.get(this.tileDesc.buildingName).length - 1) this.tileDesc.level++;
		var tTime = new Date().getTime();
		this.tileDesc.timeDesc = { refTile : this.tileDesc.id, end : tTime + 20000, progress : 0, creationDate : tTime};
		this.currentState = com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime(this.tileDesc);
		com_isartdigital_perle_game_managers_TimeManager.addConstructionTimer(this.tileDesc.timeDesc);
		if(this.currentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) com_isartdigital_perle_game_managers_TimeManager.eConstruct.on("TimeManager_Construction_End",$bind(this,this.endOfConstruction));
		this.activate();
		this.addExp();
		this.myGenerator = com_isartdigital_perle_game_managers_ResourcesManager.UpdateResourcesGenerator(this.myGenerator,20,8000);
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	,canUpgrade: function() {
		return this.tileDesc.level < com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES.get(this.tileDesc.buildingName).length - 1;
	}
	,getLevel: function() {
		return this.tileDesc.level;
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade
});
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
=======
var com_isartdigital_perle_game_virtual_vBuilding_VCollector = function(pDescription) {
	this.product = false;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
	com_isartdigital_perle_game_managers_TimeManager.eProduction.on("Production_Time",$bind(this,this.updateMyTime));
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VCollector"] = com_isartdigital_perle_game_virtual_vBuilding_VCollector;
com_isartdigital_perle_game_virtual_vBuilding_VCollector.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VCollector"];
com_isartdigital_perle_game_virtual_vBuilding_VCollector.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VCollector.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	setHaveRecolter: function() {
		this.haveRecolter = false;
	}
	,addGenerator: function() {
	}
	,updateMyTime: function(pTime) {
		if(pTime.buildingRef == this.tileDesc.id) {
			this.timeProd = pTime;
		}
	}
	,startProduction: function(pack) {
		this.timeProd = com_isartdigital_perle_game_managers_TimeManager.createProductionTime(pack,this.tileDesc.id);
		this.product = true;
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_TimeManager.eProduction.off("Production_Time",$bind(this,this.updateMyTime));
		com_isartdigital_perle_game_virtual_VBuilding.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VCollector
});
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
var com_isartdigital_perle_game_virtual_vBuilding_VDeco = function(pDescription) {
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VDeco"] = com_isartdigital_perle_game_virtual_vBuilding_VDeco;
com_isartdigital_perle_game_virtual_vBuilding_VDeco.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VDeco"];
com_isartdigital_perle_game_virtual_vBuilding_VDeco.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VDeco.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	setHaveRecolter: function() {
		this.haveRecolter = false;
	}
	,addGenerator: function() {
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VDeco
});
var com_isartdigital_perle_game_virtual_vBuilding_VHouse = function(pDescription) {
	com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.call(this,pDescription);
	this.mapMaxPopulation = new haxe_ds_StringMap();
	com_isartdigital_perle_game_managers_ResourcesManager.populationChangementEvent.on("POPULATION",$bind(this,this.onPopulationChanged));
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VHouse"] = com_isartdigital_perle_game_virtual_vBuilding_VHouse;
com_isartdigital_perle_game_virtual_vBuilding_VHouse.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VHouse"];
com_isartdigital_perle_game_virtual_vBuilding_VHouse.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade;
com_isartdigital_perle_game_virtual_vBuilding_VHouse.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.prototype,{
	addPopulation: function(pMax) {
		if(this.tileDesc.maxPopulation == null) {
			this.tileDesc.currentPopulation = 0;
			this.tileDesc.maxPopulation = pMax;
		}
		this.myPopulation = com_isartdigital_perle_game_managers_ResourcesManager.addPopulation(this.tileDesc.currentPopulation,this.tileDesc.maxPopulation,this.alignementBuilding,this.tileDesc.id);
	}
	,addGenerator: function() {
		this.maxResources = [50,225,1200];
		this.myMaxContains = this.maxResources[0];
		this.myTime = 60000 / this.valuesWin[0];
		com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.prototype.addGenerator.call(this);
	}
	,updatePopulation: function(pQuantity,pMax) {
		if(pQuantity != null) {
			this.tileDesc.currentPopulation = pQuantity;
			this.myPopulation.quantity = pQuantity;
		}
		if(pMax != null) {
			this.tileDesc.maxPopulation = pMax;
			this.myPopulation.max = pMax;
		}
		com_isartdigital_perle_game_managers_ResourcesManager.updatePopulation(this.myPopulation,this.alignementBuilding);
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	,getPopulation: function() {
		return this.myPopulation;
	}
	,onPopulationChanged: function(pPopulation) {
		if(pPopulation.buildingRef != this.tileDesc.id) return;
		this.myPopulation = pPopulation;
		this.tileDesc.maxPopulation = pPopulation.max;
		this.tileDesc.currentPopulation = pPopulation.quantity;
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	,onClickUpgrade: function() {
		com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.prototype.onClickUpgrade.call(this);
		this.updatePopulation(null,this.mapMaxPopulation.get(this.tileDesc.buildingName));
		this.myTime = 60000 / this.valuesWin[this.indexLevel];
		this.myGenerator = com_isartdigital_perle_game_managers_ResourcesManager.UpdateResourcesGenerator(this.myGenerator,this.maxResources[this.indexLevel],this.myTime);
		com_isartdigital_perle_game_managers_SaveManager.save();
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.populationChangementEvent.off("POPULATION",$bind(this,this.onPopulationChanged));
		com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VHouse
});
var com_isartdigital_perle_game_virtual_vBuilding_VTribunal = function(pDesc) {
	var lDesc;
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.neutral;
	if(pDesc == null) lDesc = { buildingName : "Purgatory", id : com_isartdigital_perle_game_managers_IdManager.newId(), regionX : 0, regionY : 0, mapX : 0, mapY : Math.floor(3.5), level : 0, isTribunal : true}; else lDesc = pDesc;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,lDesc);
	this.setCameraPos();
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VTribunal"] = com_isartdigital_perle_game_virtual_vBuilding_VTribunal;
com_isartdigital_perle_game_virtual_vBuilding_VTribunal.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VTribunal"];
com_isartdigital_perle_game_virtual_vBuilding_VTribunal.getInstance = function(pDesc) {
	if(com_isartdigital_perle_game_virtual_vBuilding_VTribunal.instance == null) com_isartdigital_perle_game_virtual_vBuilding_VTribunal.instance = new com_isartdigital_perle_game_virtual_vBuilding_VTribunal(pDesc);
	return com_isartdigital_perle_game_virtual_vBuilding_VTribunal.instance;
};
com_isartdigital_perle_game_virtual_vBuilding_VTribunal.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VTribunal.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	updateGeneratorInfo: function(data) {
		this.myGenerator.desc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(this.tileDesc.id,this.myGeneratorType);
		com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance().setText({ current : this.myGenerator.desc.quantity, max : this.myGenerator.desc.max});
	}
	,activate: function() {
		com_isartdigital_perle_game_virtual_VBuilding.prototype.activate.call(this);
		com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance().setText({ current : this.myGenerator.desc.quantity, max : this.myGenerator.desc.max});
	}
	,setHaveRecolter: function() {
		this.haveRecolter = false;
	}
	,addGenerator: function() {
		this.myTime = 2400000;
		this.myGeneratorType = com_isartdigital_perle_game_managers_GeneratorType.soul;
		this.myGenerator = com_isartdigital_perle_game_managers_ResourcesManager.addResourcesGenerator(this.tileDesc.id,this.myGeneratorType,this.myMaxContains,this.myTime,com_isartdigital_perle_game_managers_Alignment.neutral,true);
	}
	,getByBoat: function(quantity) {
		com_isartdigital_perle_game_managers_ResourcesManager.increaseResources(this.myGenerator,quantity);
	}
	,setCameraPos: function() {
		com_isartdigital_perle_game_managers_CameraManager.placeCamera(new PIXI.Point(1,this.tileDesc.mapY + 1));
	}
	,destroy: function() {
		com_isartdigital_perle_game_virtual_vBuilding_VTribunal.instance = null;
		com_isartdigital_perle_game_virtual_VBuilding.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_VTribunal
});
var com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse = function(pDescription) {
	this.alignementBuilding = null;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VUrbanHouse"] = com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse;
com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VUrbanHouse"];
com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	__class__: com_isartdigital_perle_game_virtual_vBuilding_VUrbanHouse
});
var com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding = function(pDescription) {
	this.alignmentEffect = com_isartdigital_perle_game_managers_Alignment.heaven;
	com_isartdigital_perle_game_virtual_vBuilding_VAltar.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.VVirtuesBuilding"] = com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding;
com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","VVirtuesBuilding"];
com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VAltar;
com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VAltar.prototype,{
	__class__: com_isartdigital_perle_game_virtual_vBuilding_VVirtuesBuilding
});
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
=======
var com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.heaven;
	com_isartdigital_perle_game_virtual_vBuilding_VCollector.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VCollectorHeaven"] = com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHeaven","VCollectorHeaven"];
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VCollector;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VCollector.prototype,{
	addGenerator: function() {
		this.myGeneratorType = com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise;
		com_isartdigital_perle_game_virtual_vBuilding_VCollector.prototype.addGenerator.call(this);
		this.myPacks = [{ cost : 1, time : 30000, quantity : 3},{ cost : 2, time : 35000, quantity : 10},{ cost : 3, time : 40000, quantity : 100},{ cost : 1, time : 30000, quantity : 3},{ cost : 2, time : 35000, quantity : 10},{ cost : 3, time : 40000, quantity : 100}];
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven
});
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
var com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.heaven;
	com_isartdigital_perle_game_virtual_vBuilding_VDeco.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VDecoHeaven"] = com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHeaven","VDecoHeaven"];
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VDeco;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VDeco.prototype,{
	__class__: com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VDecoHeaven
});
var com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.heaven;
	com_isartdigital_perle_game_virtual_vBuilding_VHouse.call(this,pDescription);
	this.UpgradeAssetsList = ["HeavenBuild0","HeavenBuild1","HeavenBuild2"];
	this.UpgradeGoldValuesList = ["1000","30 000"];
	this.UpgradeMaterialsValuesList = ["340","5340"];
	this.addPopulation(2);
	{
		this.mapMaxPopulation.set("HeavenBuild0",2);
		2;
	}
	{
		this.mapMaxPopulation.set("HeavenBuild1",6);
		6;
	}
	{
		this.mapMaxPopulation.set("HeavenBuild2",16);
		16;
	}
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VHouseHeaven"] = com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHeaven","VHouseHeaven"];
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VHouse;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VHouse.prototype,{
	addGenerator: function() {
		this.valuesWin = [2.5,3.75,7.5];
		com_isartdigital_perle_game_virtual_vBuilding_VHouse.prototype.addGenerator.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VHouseHeaven
});
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
var com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.heaven;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
=======
var com_isartdigital_perle_game_virtual_vBuilding_vHell_VCollectorHell = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.hell;
	com_isartdigital_perle_game_virtual_vBuilding_VCollector.call(this,pDescription);
	this.myPacks = [{ cost : 5, time : 50000, quantity : 5},{ cost : 7, time : 40000, quantity : 20},{ cost : 400, time : 300000, quantity : 300},{ cost : 450, time : 400000, quantity : 500},{ cost : 5, time : 50000, quantity : 5},{ cost : 7, time : 40000, quantity : 20},{ cost : 400, time : 300000, quantity : 300},{ cost : 450, time : 400000, quantity : 500}];
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VLumbermill"] = com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHeaven","VLumbermill"];
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	addGenerator: function() {
		this.myGeneratorType = com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise;
		com_isartdigital_perle_game_virtual_VBuilding.prototype.addGenerator.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VLumbermill
});
var com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.hell;
	com_isartdigital_perle_game_virtual_vBuilding_VDeco.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHell.VDecoHell"] = com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHell","VDecoHell"];
com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VDeco;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VDeco.prototype,{
	__class__: com_isartdigital_perle_game_virtual_vBuilding_vHell_VDecoHell
});
var com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.hell;
	com_isartdigital_perle_game_virtual_vBuilding_VHouse.call(this,pDescription);
	this.UpgradeAssetsList = ["hellBuilding","hellBuilding2","hellBuilding3"];
	this.UpgradeGoldValuesList = ["600","20 000"];
	this.UpgradeMaterialsValuesList = ["200","4000"];
	this.addPopulation(5);
	{
		this.mapMaxPopulation.set("hellBuilding",5);
		5;
	}
	{
		this.mapMaxPopulation.set("hellBuilding2",15);
		15;
	}
	{
		this.mapMaxPopulation.set("hellBuilding3",40);
		40;
	}
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHell.VHouseHell"] = com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHell","VHouseHell"];
com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell.__super__ = com_isartdigital_perle_game_virtual_vBuilding_VHouse;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell.prototype = $extend(com_isartdigital_perle_game_virtual_vBuilding_VHouse.prototype,{
	addGenerator: function() {
		this.valuesWin = [1,1.5,3];
		com_isartdigital_perle_game_virtual_vBuilding_VHouse.prototype.addGenerator.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_vHell_VHouseHell
});
var com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry = function(pDescription) {
	this.alignementBuilding = com_isartdigital_perle_game_managers_Alignment.hell;
	com_isartdigital_perle_game_virtual_VBuilding.call(this,pDescription);
};
$hxClasses["com.isartdigital.perle.game.virtual.vBuilding.vHell.VQuarry"] = com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry.__name__ = ["com","isartdigital","perle","game","virtual","vBuilding","vHell","VQuarry"];
com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry.__super__ = com_isartdigital_perle_game_virtual_VBuilding;
com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry.prototype = $extend(com_isartdigital_perle_game_virtual_VBuilding.prototype,{
	addGenerator: function() {
		this.myGeneratorType = com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell;
		com_isartdigital_perle_game_virtual_VBuilding.prototype.addGenerator.call(this);
	}
	,__class__: com_isartdigital_perle_game_virtual_vBuilding_vHell_VQuarry
});
var com_isartdigital_perle_ui_CheatPanel = function() {
	this.init();
};
$hxClasses["com.isartdigital.perle.ui.CheatPanel"] = com_isartdigital_perle_ui_CheatPanel;
com_isartdigital_perle_ui_CheatPanel.__name__ = ["com","isartdigital","perle","ui","CheatPanel"];
com_isartdigital_perle_ui_CheatPanel.getInstance = function() {
	if(com_isartdigital_perle_ui_CheatPanel.instance == null) com_isartdigital_perle_ui_CheatPanel.instance = new com_isartdigital_perle_ui_CheatPanel();
	return com_isartdigital_perle_ui_CheatPanel.instance;
};
com_isartdigital_perle_ui_CheatPanel.prototype = {
	init: function() {
		if(com_isartdigital_utils_Config.get_debug() && com_isartdigital_utils_Config.get_data().cheat && !com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) this.gui = new dat.gui.GUI();
	}
	,ingame: function() {
		if(this.gui == null) return;
	}
	,clear: function() {
		if(this.gui == null) return;
		this.gui.destroy();
		this.init();
	}
	,destroy: function() {
		com_isartdigital_perle_ui_CheatPanel.instance = null;
	}
	,__class__: com_isartdigital_perle_ui_CheatPanel
};
var com_isartdigital_perle_ui_SmartCheck = function() {
};
$hxClasses["com.isartdigital.perle.ui.SmartCheck"] = com_isartdigital_perle_ui_SmartCheck;
com_isartdigital_perle_ui_SmartCheck.__name__ = ["com","isartdigital","perle","ui","SmartCheck"];
com_isartdigital_perle_ui_SmartCheck.getChildByName = function(pContainer,pAssetName) {
	var lContainer;
	lContainer = js_Boot.__cast(pContainer , PIXI.Container);
	var lChild = lContainer.getChildByName(pAssetName);
	if(lChild == null) com_isartdigital_utils_Debug.error("[" + com_isartdigital_perle_ui_SmartCheck.getClassName(pContainer) + "].getChildByName(\"" + pAssetName + "\") == null");
	return lChild;
};
com_isartdigital_perle_ui_SmartCheck.traceChildrens = function(pContainer) {
	var lContainer;
	lContainer = js_Boot.__cast(pContainer , PIXI.Container);
	var _g1 = 0;
	var _g = lContainer.children.length;
	while(_g1 < _g) {
		var i = _g1++;
		console.log("[" + com_isartdigital_perle_ui_SmartCheck.getClassName(pContainer) + "] >=> " + lContainer.children[i].name);
	}
};
com_isartdigital_perle_ui_SmartCheck.getClassName = function(pContainer) {
	return ((function($this) {
		var $r;
		var e = Type["typeof"](pContainer);
		$r = e.slice(2);
		return $r;
	}(this)))[0].__name__;
};
com_isartdigital_perle_ui_SmartCheck.prototype = {
	__class__: com_isartdigital_perle_ui_SmartCheck
};
var com_isartdigital_perle_ui_UIManager = function() {
	this.popins = [];
};
$hxClasses["com.isartdigital.perle.ui.UIManager"] = com_isartdigital_perle_ui_UIManager;
com_isartdigital_perle_ui_UIManager.__name__ = ["com","isartdigital","perle","ui","UIManager"];
com_isartdigital_perle_ui_UIManager.getInstance = function() {
	if(com_isartdigital_perle_ui_UIManager.instance == null) com_isartdigital_perle_ui_UIManager.instance = new com_isartdigital_perle_ui_UIManager();
	return com_isartdigital_perle_ui_UIManager.instance;
};
com_isartdigital_perle_ui_UIManager.prototype = {
	openScreen: function(pScreen) {
		this.closeScreens();
		com_isartdigital_utils_game_GameStage.getInstance().getScreensContainer().addChild(pScreen);
		pScreen.open();
	}
	,closeScreens: function() {
		var lContainer = com_isartdigital_utils_game_GameStage.getInstance().getScreensContainer();
		while(lContainer.children.length > 0) {
			var lCurrent;
			lCurrent = js_Boot.__cast(lContainer.getChildAt(lContainer.children.length - 1) , com_isartdigital_utils_ui_Screen);
			lCurrent.interactive = false;
			lContainer.removeChild(lCurrent);
			lCurrent.close();
		}
	}
	,openPopin: function(pPopin) {
		this.popins.push(pPopin);
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(pPopin);
		pPopin.open();
	}
	,closeCurrentPopin: function() {
		if(this.popins.length == 0) return;
		var lCurrent = this.popins.pop();
		lCurrent.interactive = false;
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().removeChild(lCurrent);
		lCurrent.close();
	}
	,openHud: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(com_isartdigital_perle_ui_hud_Hud.getInstance());
		com_isartdigital_perle_ui_hud_Hud.getInstance().open();
	}
	,closeHud: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().removeChild(com_isartdigital_perle_ui_hud_Hud.getInstance());
		com_isartdigital_perle_ui_hud_Hud.getInstance().close();
	}
	,openFTUE: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance());
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance().open();
	}
	,closeFTUE: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().removeChild(com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance());
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance().close();
	}
	,startGame: function() {
		this.closeScreens();
		this.openHud();
	}
	,destroy: function() {
		com_isartdigital_perle_ui_UIManager.instance = null;
	}
	,__class__: com_isartdigital_perle_ui_UIManager
};
var com_isartdigital_perle_ui_contextual_HudContextual = function() {
	PIXI.Container.call(this);
};
$hxClasses["com.isartdigital.perle.ui.contextual.HudContextual"] = com_isartdigital_perle_ui_contextual_HudContextual;
com_isartdigital_perle_ui_contextual_HudContextual.__name__ = ["com","isartdigital","perle","ui","contextual","HudContextual"];
com_isartdigital_perle_ui_contextual_HudContextual.__interfaces__ = [com_isartdigital_perle_game_virtual_HasVirtual];
com_isartdigital_perle_ui_contextual_HudContextual.initClass = function() {
	com_isartdigital_perle_ui_contextual_HudContextual.container = new PIXI.Container();
};
com_isartdigital_perle_ui_contextual_HudContextual.addContainer = function() {
	com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().addChild(com_isartdigital_perle_ui_contextual_HudContextual.container);
};
com_isartdigital_perle_ui_contextual_HudContextual.__super__ = PIXI.Container;
com_isartdigital_perle_ui_contextual_HudContextual.prototype = $extend(PIXI.Container.prototype,{
	linkVirtual: function(pVirtual) {
		this.myVHudContextual = js_Boot.__cast(pVirtual , com_isartdigital_perle_ui_contextual_VHudContextual);
	}
	,init: function() {
		this.alignTopLeft();
		com_isartdigital_perle_ui_contextual_HudContextual.container.addChild(this);
	}
	,addComponentBtnProd: function(pComponent) {
		com_isartdigital_utils_ui_UIPosition.setPositionContextualUI(this.myVHudContextual.myVBuilding.graphic,pComponent,"topCenter",0,-pComponent.height / 2);
		this.addChild(pComponent);
	}
	,alignTopLeft: function() {
		var lLocalBounds = this.myVHudContextual.myVBuilding.graphic.getLocalBounds();
		var lAnchor = new PIXI.Point(lLocalBounds.x,lLocalBounds.y);
		var lRect = this.myVHudContextual.myVBuilding.graphic.position;
		this.x = lRect.x + lAnchor.x;
		this.y = lRect.y + lAnchor.y;
	}
	,destroy: function() {
		this.myVHudContextual = null;
		if(this.parent != null) this.parent.removeChild(this);
		PIXI.Container.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_contextual_HudContextual
});
var com_isartdigital_perle_ui_contextual_VHudContextual = function() {
	com_isartdigital_perle_game_virtual_Virtual.call(this);
};
$hxClasses["com.isartdigital.perle.ui.contextual.VHudContextual"] = com_isartdigital_perle_ui_contextual_VHudContextual;
com_isartdigital_perle_ui_contextual_VHudContextual.__name__ = ["com","isartdigital","perle","ui","contextual","VHudContextual"];
com_isartdigital_perle_ui_contextual_VHudContextual.__super__ = com_isartdigital_perle_game_virtual_Virtual;
com_isartdigital_perle_ui_contextual_VHudContextual.prototype = $extend(com_isartdigital_perle_game_virtual_Virtual.prototype,{
	init: function(pVBuilding) {
		this.myVBuilding = pVBuilding;
		if(this.myVBuilding.haveRecolter) {
			this.virtualGoldBtn = new com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator();
			this.virtualGoldBtn.init(this);
		}
	}
	,activate: function() {
		com_isartdigital_perle_game_virtual_Virtual.prototype.activate.call(this);
		var lHudContextual = new com_isartdigital_perle_ui_contextual_HudContextual();
		this.graphic = js_Boot.__cast(lHudContextual , PIXI.Container);
		(js_Boot.__cast(this.graphic , com_isartdigital_perle_game_virtual_HasVirtual)).linkVirtual(js_Boot.__cast(this , com_isartdigital_perle_game_virtual_Virtual));
		lHudContextual.init();
		if(this.myVBuilding.haveRecolter) this.virtualGoldBtn.activate();
	}
	,desactivate: function() {
		com_isartdigital_perle_game_virtual_Virtual.prototype.desactivate.call(this);
		if(this.virtualGoldBtn != null) this.virtualGoldBtn.desactivate();
	}
	,destroy: function() {
		if(this.myVBuilding.haveRecolter) this.virtualGoldBtn.destroy();
		this.virtualGoldBtn = null;
		this.myVBuilding.unlinkContextualHud();
		this.myVBuilding = null;
		com_isartdigital_perle_game_virtual_Virtual.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_contextual_VHudContextual
});
var com_isartdigital_utils_ui_UIComponent = function(pID) {
	this.modal = true;
	this.modalImage = "assets/alpha_bg.png";
	this.positionables = [];
	com_isartdigital_utils_game_GameObject.call(this);
	if(pID == null) {
		this.componentName = Type.getClassName(js_Boot.getClass(this));
		this.componentName = this.componentName.substring(this.componentName.lastIndexOf(".") + 1);
	} else this.componentName = pID;
};
$hxClasses["com.isartdigital.utils.ui.UIComponent"] = com_isartdigital_utils_ui_UIComponent;
com_isartdigital_utils_ui_UIComponent.__name__ = ["com","isartdigital","utils","ui","UIComponent"];
com_isartdigital_utils_ui_UIComponent.__super__ = com_isartdigital_utils_game_GameObject;
com_isartdigital_utils_ui_UIComponent.prototype = $extend(com_isartdigital_utils_game_GameObject.prototype,{
	set_modalImage: function(pImage) {
		this.modalImage = pImage;
		if(this.modalZone != null) this.modalZone.texture = PIXI.Texture.fromImage(this.modalImage);
		return this.modalImage;
	}
	,build: function(pFrame) {
		if(pFrame == null) pFrame = 0;
		var lWireFrameName = com_isartdigital_perle_Main.getInstance().getWireFrameName(this.componentName);
		var lItems = com_isartdigital_utils_ui_smart_UIBuilder.build(lWireFrameName != null?lWireFrameName:this.componentName,pFrame);
		var _g = 0;
		while(_g < lItems.length) {
			var lItem = lItems[_g];
			++_g;
			this.addChild(lItem.item);
			if(lItem.align != "") this.positionables.push(lItem);
		}
	}
	,open: function() {
		if(this.isOpened) return;
		this.isOpened = true;
		this.set_modal(this.modal);
		com_isartdigital_utils_game_GameStage.getInstance().on("resize",$bind(this,this.onResize));
		this.onResize();
	}
	,set_modal: function(pModal) {
		this.modal = pModal;
		if(this.modal) {
			if(this.modalZone == null) {
				this.modalZone = new PIXI.Sprite(PIXI.Texture.fromImage(com_isartdigital_utils_Config.url(this.modalImage)));
				this.modalZone.interactive = true;
				this.modalZone.on("click",$bind(this,this.stopPropagation));
				this.modalZone.on("tap",$bind(this,this.stopPropagation));
				this.positionables.unshift({ item : this.modalZone, align : "fitScreen", offsetX : 0, offsetY : 0});
			}
			if(this.parent != null) this.parent.addChildAt(this.modalZone,this.parent.getChildIndex(this));
		} else if(this.modalZone != null) {
			if(this.modalZone.parent != null) this.modalZone.parent.removeChild(this.modalZone);
			this.modalZone.off("click",$bind(this,this.stopPropagation));
			this.modalZone.off("tap",$bind(this,this.stopPropagation));
			this.modalZone = null;
			if(this.positionables[0].item == this.modalZone) this.positionables.shift();
		}
		return this.modal;
	}
	,stopPropagation: function(pEvent) {
	}
	,close: function() {
		if(!this.isOpened) return;
		this.isOpened = false;
		this.set_modal(false);
		this.destroy();
	}
	,onResize: function(pEvent) {
		var _g = 0;
		var _g1 = this.positionables;
		while(_g < _g1.length) {
			var lObj = _g1[_g];
			++_g;
			if(lObj.update) {
				if(lObj.align == "top" || lObj.align == "topLeft" || lObj.align == "topRight") lObj.offsetY = this.parent.y + lObj.item.y; else if(lObj.align == "bottom" || lObj.align == "bottomLeft" || lObj.align == "bottomRight") lObj.offsetY = com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().height - this.parent.y - lObj.item.y;
				if(lObj.align == "left" || lObj.align == "topLeft" || lObj.align == "bottomLeft") lObj.offsetX = this.parent.x + lObj.item.x; else if(lObj.align == "right" || lObj.align == "topRight" || lObj.align == "bottomRight") lObj.offsetX = com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().width - this.parent.x - lObj.item.x;
				lObj.update = false;
			}
			com_isartdigital_utils_ui_UIPosition.setPosition(lObj.item,lObj.align,lObj.offsetX,lObj.offsetY);
		}
	}
	,destroy: function() {
		this.close();
		com_isartdigital_utils_game_GameStage.getInstance().off("resize",$bind(this,this.onResize));
		com_isartdigital_utils_game_GameObject.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_utils_ui_UIComponent
});
var com_isartdigital_utils_ui_smart_SmartComponent = function(pID) {
	com_isartdigital_utils_ui_UIComponent.call(this,pID);
	this.build();
};
$hxClasses["com.isartdigital.utils.ui.smart.SmartComponent"] = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_utils_ui_smart_SmartComponent.__name__ = ["com","isartdigital","utils","ui","smart","SmartComponent"];
com_isartdigital_utils_ui_smart_SmartComponent.__super__ = com_isartdigital_utils_ui_UIComponent;
com_isartdigital_utils_ui_smart_SmartComponent.prototype = $extend(com_isartdigital_utils_ui_UIComponent.prototype,{
	__class__: com_isartdigital_utils_ui_smart_SmartComponent
});
var com_isartdigital_perle_ui_contextual_sprites_ButtonProduction = function(pType) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,"ProdDone");
	var graphic = new com_isartdigital_utils_ui_smart_UISprite(com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName.get(pType));
	var spawner;
	spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_currency") , com_isartdigital_utils_ui_smart_UISprite);
	graphic.position = spawner.position;
	this.removeChild(spawner);
	this.addChild(graphic);
	this.interactive = true;
	com_isartdigital_perle_utils_Interactive.addListenerClick(this,$bind(this,this.onClick));
};
$hxClasses["com.isartdigital.perle.ui.contextual.sprites.ButtonProduction"] = com_isartdigital_perle_ui_contextual_sprites_ButtonProduction;
com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.__name__ = ["com","isartdigital","perle","ui","contextual","sprites","ButtonProduction"];
com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.init = function() {
	com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName = new haxe_ds_EnumValueMap();
	{
		com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName.set(com_isartdigital_perle_game_managers_GeneratorType.soft,"_goldIcon__Large_Prod");
		"_goldIcon__Large_Prod";
	}
	{
		com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName.set(com_isartdigital_perle_game_managers_GeneratorType.hard,"_hardCurrencyIcon_Large");
		"_hardCurrencyIcon_Large";
	}
	{
		com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise,"_woodIcon_Large");
		"_woodIcon_Large";
	}
	{
		com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.assetsName.set(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell,"_stoneIcon_Large");
		"_stoneIcon_Large";
	}
};
com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_contextual_sprites_ButtonProduction.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	setScale: function() {
		this.myGeneratorDesc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(this.myGeneratorDesc.id,this.myGeneratorDesc.type);
		var ratio = this.myGeneratorDesc.quantity / (this.myGeneratorDesc.max / 1.5);
		this.scale = new PIXI.Point(ratio,ratio);
	}
	,setMyGeneratorDescription: function(pDesc) {
		this.myGeneratorDesc = pDesc;
	}
	,onClick: function() {
		this.myGeneratorDesc = com_isartdigital_perle_game_managers_ResourcesManager.takeResources(this.myGeneratorDesc);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this,$bind(this,this.onClick));
		this.removeAllListeners();
		this.myGeneratorDesc = null;
		if(this.parent != null) this.parent.removeChild(this);
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_contextual_sprites_ButtonProduction
});
var com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter = function() {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,"SoulsCounter_purgatory");
	this.txt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_infos_purgatory_txt") , com_isartdigital_utils_ui_smart_TextSprite);
};
$hxClasses["com.isartdigital.perle.ui.contextual.sprites.PurgatorySoulCounter"] = com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter;
com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.__name__ = ["com","isartdigital","perle","ui","contextual","sprites","PurgatorySoulCounter"];
com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.getInstance = function() {
	if(com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.instance == null) com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.instance = new com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter();
	return com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.instance;
};
com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	setText: function(txtInfo) {
		this.txt.set_text(txtInfo.current + "/" + txtInfo.max);
	}
	,destroy: function() {
		com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter.instance = null;
		this.parent.removeChild(this);
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_contextual_sprites_PurgatorySoulCounter
});
var com_isartdigital_perle_ui_contextual_virtual_VSmartComponent = function() {
	com_isartdigital_perle_game_virtual_Virtual.call(this);
};
$hxClasses["com.isartdigital.perle.ui.contextual.virtual.VSmartComponent"] = com_isartdigital_perle_ui_contextual_virtual_VSmartComponent;
com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.__name__ = ["com","isartdigital","perle","ui","contextual","virtual","VSmartComponent"];
com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.__super__ = com_isartdigital_perle_game_virtual_Virtual;
com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.prototype = $extend(com_isartdigital_perle_game_virtual_Virtual.prototype,{
	init: function(pVHud) {
		this.myVHudContextual = pVHud;
	}
	,__class__: com_isartdigital_perle_ui_contextual_virtual_VSmartComponent
});
var com_isartdigital_perle_ui_contextual_virtual_VButtonProduction = function() {
	this.generatorIsNotEmpty = false;
	com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.call(this);
};
$hxClasses["com.isartdigital.perle.ui.contextual.virtual.VButtonProduction"] = com_isartdigital_perle_ui_contextual_virtual_VButtonProduction;
com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.__name__ = ["com","isartdigital","perle","ui","contextual","virtual","VButtonProduction"];
com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.__super__ = com_isartdigital_perle_ui_contextual_virtual_VSmartComponent;
com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype = $extend(com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.prototype,{
	init: function(pVHud) {
		com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.prototype.init.call(this,pVHud);
		this.refBuilding = pVHud.myVBuilding.tileDesc.id;
<<<<<<< HEAD:bin/ui.js
=======
		this.myGeneratorDesc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(this.refBuilding,pVHud.myVBuilding.myGeneratorType);
		this.generatorIsNotEmpty = com_isartdigital_perle_game_managers_ResourcesManager.GeneratorIsNotEmpty(this.myGeneratorDesc);
	}
	,onGeneratorEvent: function(data) {
		if(data.forButton && data.id == this.refBuilding && this.myBtn == null) {
			this.generatorIsNotEmpty = data.active;
			if(this.shoulBeVisible() && this.graphic == null) this.addGraphic(); else if(this.active && !this.generatorIsNotEmpty) this.removeGraphic();
		}
		if(this.myBtn != null) this.myBtn.setScale();
>>>>>>> btn accelerate working:bin/Builder.js
	}
	,shoulBeVisible: function() {
		return this.active && this.generatorIsNotEmpty;
	}
	,shouldBeHidden: function() {
		return this.active && !this.generatorIsNotEmpty || !this.active;
	}
	,addGraphic: function() {
		this.graphic = js_Boot.__cast(this.myBtn , PIXI.Container);
		(js_Boot.__cast(this.myVHudContextual.graphic , com_isartdigital_perle_ui_contextual_HudContextual)).addComponentBtnProd(js_Boot.__cast(this.myBtn , com_isartdigital_utils_ui_smart_SmartComponent));
	}
	,activate: function() {
		com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.prototype.activate.call(this);
<<<<<<< HEAD:bin/ui.js
		if(this.shoulBeVisible()) {
			this.addGraphic();
		}
=======
		if(this.shoulBeVisible()) this.addGraphic();
		if(this.myBtn != null) this.myBtn.setScale();
>>>>>>> btn accelerate working:bin/Builder.js
	}
	,desactivate: function() {
		com_isartdigital_perle_ui_contextual_virtual_VSmartComponent.prototype.desactivate.call(this);
		this.myBtn = null;
	}
	,__class__: com_isartdigital_perle_ui_contextual_virtual_VButtonProduction
});
var com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator = function() {
	com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.call(this);
	com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.on("GENERATOR",$bind(this,this.onGeneratorEvent));
};
$hxClasses["com.isartdigital.perle.ui.contextual.virtual.VButtonProductionGenerator"] = com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator;
com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator.__name__ = ["com","isartdigital","perle","ui","contextual","virtual","VButtonProductionGenerator"];
com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator.__super__ = com_isartdigital_perle_ui_contextual_virtual_VButtonProduction;
com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator.prototype = $extend(com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype,{
	init: function(pVHud) {
		com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype.init.call(this,pVHud);
		this.myGeneratorDesc = com_isartdigital_perle_game_managers_ResourcesManager.getGenerator(this.refBuilding,pVHud.myVBuilding.myGeneratorType);
		this.generatorIsNotEmpty = com_isartdigital_perle_game_managers_ResourcesManager.GeneratorIsNotEmpty(this.myGeneratorDesc);
	}
	,onGeneratorEvent: function(data) {
		if(data.forButton && data.id == this.refBuilding && this.myBtn == null) {
			this.generatorIsNotEmpty = data.active;
			if(this.shoulBeVisible() && this.graphic == null) {
				this.addGraphic();
			} else if(this.active && !this.generatorIsNotEmpty) {
				this.removeGraphic();
			}
		}
		if(this.myBtn != null) {
			this.myBtn.setScale();
		}
	}
	,addGraphic: function() {
		this.myBtn = new com_isartdigital_perle_ui_contextual_sprites_ButtonProduction(this.myGeneratorDesc.type);
		this.myBtn.setMyGeneratorDescription(this.myGeneratorDesc);
		com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype.addGraphic.call(this);
	}
	,activate: function() {
		com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype.activate.call(this);
		if(this.myBtn != null) {
			this.myBtn.setScale();
		}
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.generatorEvent.off("GENERATOR",$bind(this,this.onGeneratorEvent));
		com_isartdigital_perle_ui_contextual_virtual_VButtonProduction.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_contextual_virtual_VButtonProductionGenerator
});
var com_isartdigital_utils_ui_Button = function() {
	com_isartdigital_utils_game_StateGraphic.call(this);
	this.boxType = com_isartdigital_utils_game_BoxType.SELF;
	this.interactive = true;
	this.buttonMode = true;
	this.on("mouseover",$bind(this,this._mouseOver));
	this.on("mousedown",$bind(this,this._mouseDown));
	this.on("click",$bind(this,this._click));
	this.on("mouseout",$bind(this,this._mouseOut));
	this.on("mouseupoutside",$bind(this,this._mouseOut));
	this.on("touchstart",$bind(this,this._mouseDown));
	this.on("tap",$bind(this,this._click));
	this.on("touchend",$bind(this,this._mouseOut));
	this.on("touchendoutside",$bind(this,this._mouseOut));
	this.createText();
	this.start();
};
$hxClasses["com.isartdigital.utils.ui.Button"] = com_isartdigital_utils_ui_Button;
com_isartdigital_utils_ui_Button.__name__ = ["com","isartdigital","utils","ui","Button"];
com_isartdigital_utils_ui_Button.__super__ = com_isartdigital_utils_game_StateGraphic;
com_isartdigital_utils_ui_Button.prototype = $extend(com_isartdigital_utils_game_StateGraphic.prototype,{
	createText: function() {
		this.upStyle = { font : "80px Arial", fill : "#000000", align : "center"};
		this.overStyle = { font : "80px Arial", fill : "#AAAAAA", align : "center"};
		this.downStyle = { font : "80px Arial", fill : "#FFFFFF", align : "center"};
		this.txt = new PIXI.Text("",this.upStyle);
		this.txt.anchor.set(0.5,0.5);
	}
	,setText: function(pText) {
		this.txt.text = pText;
	}
	,setModeNormal: function() {
		this.setState(this.DEFAULT_STATE);
		this.anim.gotoAndStop(0);
		this.addChild(this.txt);
		com_isartdigital_utils_game_StateGraphic.prototype.setModeNormal.call(this);
	}
	,_mouseVoid: function() {
	}
	,_click: function(pEvent) {
		this.anim.gotoAndStop(0);
		this.txt.style = this.upStyle;
	}
	,_mouseDown: function(pEvent) {
		this.anim.gotoAndStop(2);
		this.txt.style = this.downStyle;
	}
	,_mouseOver: function(pEvent) {
		this.anim.gotoAndStop(1);
		this.txt.style = this.overStyle;
	}
	,_mouseOut: function(pEvent) {
		this.anim.gotoAndStop(0);
		this.txt.style = this.upStyle;
	}
	,destroy: function() {
		this.off("mouseover",$bind(this,this._mouseOver));
		this.off("mousedown",$bind(this,this._mouseDown));
		this.off("click",$bind(this,this._click));
		this.off("mouseout",$bind(this,this._mouseOut));
		this.off("mouseupoutside",$bind(this,this._mouseOut));
		this.off("touchstart",$bind(this,this._mouseDown));
		this.off("tap",$bind(this,this._click));
		this.off("touchend",$bind(this,this._mouseOut));
		this.off("touchendoutside",$bind(this,this._mouseOut));
		com_isartdigital_utils_game_StateGraphic.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_utils_ui_Button
});
var com_isartdigital_perle_ui_hud_ButtonRegion = function(pPos,pWorldPos) {
	this.factory = new com_isartdigital_utils_game_factory_FlumpMovieAnimFactory();
	this.assetName = "RegionButton";
	com_isartdigital_utils_ui_Button.call(this);
	this.firstCasePos = pPos;
	this.worldMapPos = pWorldPos;
	if(pPos.x < 0) this.regionType = com_isartdigital_perle_game_managers_Alignment.heaven; else this.regionType = com_isartdigital_perle_game_managers_Alignment.hell;
};
$hxClasses["com.isartdigital.perle.ui.hud.ButtonRegion"] = com_isartdigital_perle_ui_hud_ButtonRegion;
com_isartdigital_perle_ui_hud_ButtonRegion.__name__ = ["com","isartdigital","perle","ui","hud","ButtonRegion"];
com_isartdigital_perle_ui_hud_ButtonRegion.__super__ = com_isartdigital_utils_ui_Button;
com_isartdigital_perle_ui_hud_ButtonRegion.prototype = $extend(com_isartdigital_utils_ui_Button.prototype,{
	_mouseDown: function(pEvent) {
		com_isartdigital_utils_ui_Button.prototype._mouseDown.call(this,pEvent);
		com_isartdigital_perle_game_managers_ServerManager.addRegionToDataBase(this.regionType[0],com_isartdigital_perle_game_virtual_VTile.pointToIndex(this.worldMapPos),com_isartdigital_perle_game_virtual_VTile.pointToIndex(this.firstCasePos),this);
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_RegionManager.getButtonContainer().removeChild(this);
		com_isartdigital_utils_ui_Button.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_ButtonRegion
});
var com_isartdigital_perle_ui_hud_BuildingHudType = { __ename__ : true, __constructs__ : ["CONSTRUCTION","HARVEST","MOVING","NONE"] };
com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION = ["CONSTRUCTION",0];
com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION.toString = $estr;
com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION.__enum__ = com_isartdigital_perle_ui_hud_BuildingHudType;
com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST = ["HARVEST",1];
com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST.toString = $estr;
com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST.__enum__ = com_isartdigital_perle_ui_hud_BuildingHudType;
com_isartdigital_perle_ui_hud_BuildingHudType.MOVING = ["MOVING",2];
com_isartdigital_perle_ui_hud_BuildingHudType.MOVING.toString = $estr;
com_isartdigital_perle_ui_hud_BuildingHudType.MOVING.__enum__ = com_isartdigital_perle_ui_hud_BuildingHudType;
com_isartdigital_perle_ui_hud_BuildingHudType.NONE = ["NONE",3];
com_isartdigital_perle_ui_hud_BuildingHudType.NONE.toString = $estr;
com_isartdigital_perle_ui_hud_BuildingHudType.NONE.__enum__ = com_isartdigital_perle_ui_hud_BuildingHudType;
var com_isartdigital_utils_ui_Screen = function(pID) {
	com_isartdigital_utils_ui_UIComponent.call(this,pID);
	this.set_modalImage("assets/black_bg.png");
};
$hxClasses["com.isartdigital.utils.ui.Screen"] = com_isartdigital_utils_ui_Screen;
com_isartdigital_utils_ui_Screen.__name__ = ["com","isartdigital","utils","ui","Screen"];
com_isartdigital_utils_ui_Screen.__super__ = com_isartdigital_utils_ui_UIComponent;
com_isartdigital_utils_ui_Screen.prototype = $extend(com_isartdigital_utils_ui_UIComponent.prototype,{
	__class__: com_isartdigital_utils_ui_Screen
});
var com_isartdigital_utils_ui_smart_SmartScreen = function(pID) {
	com_isartdigital_utils_ui_Screen.call(this,pID);
	this.build();
};
$hxClasses["com.isartdigital.utils.ui.smart.SmartScreen"] = com_isartdigital_utils_ui_smart_SmartScreen;
com_isartdigital_utils_ui_smart_SmartScreen.__name__ = ["com","isartdigital","utils","ui","smart","SmartScreen"];
com_isartdigital_utils_ui_smart_SmartScreen.__super__ = com_isartdigital_utils_ui_Screen;
com_isartdigital_utils_ui_smart_SmartScreen.prototype = $extend(com_isartdigital_utils_ui_Screen.prototype,{
	__class__: com_isartdigital_utils_ui_smart_SmartScreen
});
var com_isartdigital_perle_ui_hud_Hud = function() {
	com_isartdigital_utils_ui_smart_SmartScreen.call(this,"HUD_Desktop");
	this.set_modal(null);
	this.containerBuildingHud = new PIXI.Container();
	com_isartdigital_perle_ui_hud_building_BHHarvestHouse.getInstance().init();
	com_isartdigital_perle_ui_hud_building_BHHarvest.getInstance().init();
	com_isartdigital_perle_ui_hud_building_BHConstruction.getInstance().init();
	com_isartdigital_perle_ui_hud_building_BHMoving.getInstance().init();
	com_isartdigital_perle_game_sprites_Building.getBuildingHudContainer().addChild(this.containerBuildingHud);
	this.buildingPosition = new PIXI.Point(this.containerBuildingHud.x / 2,this.containerBuildingHud.y / 2);
	this.name = this.componentName;
	this.addListeners();
};
$hxClasses["com.isartdigital.perle.ui.hud.Hud"] = com_isartdigital_perle_ui_hud_Hud;
com_isartdigital_perle_ui_hud_Hud.__name__ = ["com","isartdigital","perle","ui","hud","Hud"];
com_isartdigital_perle_ui_hud_Hud.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_Hud.instance == null) com_isartdigital_perle_ui_hud_Hud.instance = new com_isartdigital_perle_ui_hud_Hud();
	return com_isartdigital_perle_ui_hud_Hud.instance;
};
com_isartdigital_perle_ui_hud_Hud.__super__ = com_isartdigital_utils_ui_smart_SmartScreen;
com_isartdigital_perle_ui_hud_Hud.prototype = $extend(com_isartdigital_utils_ui_smart_SmartScreen.prototype,{
	changeBuildingHud: function(pNewBuildingHud,pVBuilding) {
		com_isartdigital_perle_ui_hud_building_BuildingHud.linkVirtualBuilding(pVBuilding);
		if(pVBuilding != null) console.log("VBuildindg ID is : " + pVBuilding.tileDesc.id);
		if(this.currentBuildingHud != pNewBuildingHud) {
			this.currentBuildingHud = pNewBuildingHud;
			this.containerBuildingHud.removeChildren();
			switch(pNewBuildingHud[1]) {
			case 1:
				if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VHouse)) this.openHarvest(com_isartdigital_perle_ui_hud_building_BHHarvestHouse.getInstance()); else this.openHarvest(com_isartdigital_perle_ui_hud_building_BHHarvest.getInstance());
				break;
			case 0:
				this.openConstruction(com_isartdigital_perle_ui_hud_building_BHConstruction.getInstance());
				break;
			case 2:
				com_isartdigital_perle_ui_hud_building_BHHarvest.getInstance().removeListenerGameContainer();
				com_isartdigital_perle_ui_hud_building_BHHarvestHouse.getInstance().removeListenerGameContainer();
				this.containerBuildingHud.addChild(com_isartdigital_perle_ui_hud_building_BHMoving.getInstance());
				break;
			case 3:
				break;
			}
		}
	}
	,addComponent: function(pComponent) {
		var lLocalBounds = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.graphic.getLocalBounds();
		var lAnchor = new PIXI.Point(lLocalBounds.x,lLocalBounds.y);
		var lRect = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.graphic.position;
		this.containerBuildingHud.position.x = lRect.x + lAnchor.x;
		this.containerBuildingHud.position.y = lRect.y + lAnchor.y;
		com_isartdigital_utils_ui_UIPosition.setPositionContextualUI(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.graphic,pComponent,"bottomCenter",0,0);
		this.containerBuildingHud.addChild(pComponent);
	}
	,openHarvest: function(pHarvest) {
		this.addComponent(pHarvest);
		pHarvest.setOnSpawn();
	}
	,openConstruction: function(pConstruct) {
		this.addComponent(pConstruct);
		pConstruct.setOnSpawn();
	}
	,showInternEvent: function(pEvent) {
		if(pEvent.key != "i") return;
		this.hide();
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_choice_Choice.getInstance());
	}
	,hideBuildingHud: function() {
		this.changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.NONE);
	}
	,addListeners: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesEvent.on("TOTAL RESOURCES",$bind(this,this.refreshTextValue));
		this.btnResetData = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ALPHA_ResetData") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnShop = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonShop_HUD") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnPurgatory = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "PurgatoryButton") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnInterns = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "InternsButton") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnMissions = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonMissions_HUD") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnResetData,$bind(this,this.onClickResetData));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnShop,$bind(this,this.onClickShop));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnPurgatory,$bind(this,this.onClickTribunal));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnInterns,$bind(this,this.onClickListIntern));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnMissions,$bind(this,this.onClickMission));
		this.hellXPBar = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_HellXP") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.heavenXPBar = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_HeavenXP") , com_isartdigital_utils_ui_smart_SmartComponent);
		window.addEventListener("keydown",$bind(this,this.showInternEvent));
		var woodMc = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "Iron");
		this.btnIron = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(woodMc,"ButtonPlusIRON") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnIron,$bind(this,this.onClickShopResource));
		var ironMc = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "Wood");
		this.btnWood = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(ironMc,"ButtonPlusWOOD") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnWood,$bind(this,this.onClickShopResource));
		var softMc = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "SoftCurrency");
		this.btnSoft = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(softMc,"ButtonPlusSC") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnSoft,$bind(this,this.onClickShopCurrencies));
		var hardMc = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"HUD_" + "HardCurrency");
		this.btnHard = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(hardMc,"ButtonPlusHC") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnHard,$bind(this,this.onClickShopCurrencies));
		this.on("added",$bind(this,this.registerForFTUE));
	}
	,registerForFTUE: function(pEvent) {
		var _g1 = 0;
		var _g = this.children.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(js_Boot.__instanceof(this.children[i],com_isartdigital_utils_ui_smart_SmartButton)) {
				com_isartdigital_perle_game_managers_DialogueManager.register(this.children[i]);
			}
		}
		this.off("added",$bind(this,this.registerForFTUE));
	}
	,initGauges: function() {
		this.hellXPBar.getChildByName("movingGauge").scale.x = 0;
		this.heavenXPBar.getChildByName("movingGauge").scale.x = 0;
	}
	,initGaugesWithSave: function() {
		this.hellXPBar.getChildByName("movingGauge").scale.x = (function($this) {
			var $r;
			var this1 = com_isartdigital_perle_game_managers_ResourcesManager.getResourcesData().totalsMap;
			$r = this1.get(com_isartdigital_perle_game_managers_GeneratorType.badXp);
			return $r;
		}(this)) / com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(js_Boot.__cast(com_isartdigital_perle_game_managers_ResourcesManager.getLevel() , Int));
		this.heavenXPBar.getChildByName("movingGauge").scale.x = (function($this) {
			var $r;
			var this2 = com_isartdigital_perle_game_managers_ResourcesManager.getResourcesData().totalsMap;
			$r = this2.get(com_isartdigital_perle_game_managers_GeneratorType.goodXp);
			return $r;
		}(this)) / com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(js_Boot.__cast(com_isartdigital_perle_game_managers_ResourcesManager.getLevel() , Int));
	}
	,setXpGauge: function(pType,pQuantity) {
		var lNumberToPercent = pQuantity / com_isartdigital_perle_game_managers_ExperienceManager.getMaxExp(js_Boot.__cast(com_isartdigital_perle_game_managers_ResourcesManager.getLevel() , Int));
		var lScaleHellXp = this.hellXPBar.getChildByName("movingGauge").scale.x;
		var lScaleHeavenXp = this.heavenXPBar.getChildByName("movingGauge").scale.x;
		if(lScaleHellXp != 1 && lScaleHeavenXp != 1) {
			if(pType[0] == "badXp") {
				lScaleHellXp += lNumberToPercent;
				if(lScaleHellXp > 1) lScaleHellXp = 1;
				this.hellXPBar.getChildByName("movingGauge").scale.x = lScaleHellXp;
			}
			if(pType[0] == "goodXp") {
				lScaleHeavenXp += lNumberToPercent;
				if(lScaleHeavenXp > 1) lScaleHeavenXp = 1;
				this.heavenXPBar.getChildByName("movingGauge").scale.x = lScaleHeavenXp;
			}
		}
	}
	,onClickResetData: function() {
		com_isartdigital_perle_game_managers_SaveManager.reinit();
	}
	,onClickBuilding: function(pCurrentState,pVBuilding,pPos) {
		var lBuidldingHudType = null;
		if(pCurrentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilt) lBuidldingHudType = com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST; else if(pCurrentState == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) lBuidldingHudType = com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION; else if(pCurrentState == com_isartdigital_perle_game_virtual_VBuildingState.isMoving) lBuidldingHudType = com_isartdigital_perle_ui_hud_BuildingHudType.MOVING;
		this.changeBuildingHud(lBuidldingHudType,pVBuilding);
	}
	,onClickShop: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance());
		com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance().init(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
		this.hide();
	}
	,onClickShopCurrencies: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance());
		com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance().init(com_isartdigital_perle_ui_popin_shop_ShopTab.Currencies);
		this.hide();
	}
	,onClickShopResource: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance());
		com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance().init(com_isartdigital_perle_ui_popin_shop_ShopTab.Resources);
		this.hide();
	}
	,onClickTribunal: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_TribunalPopin.getInstance());
		this.hide();
	}
	,onClickListIntern: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
		this.hide();
	}
	,onClickMission: function() {
		js_Browser.alert("Work in progress : Special Feature");
	}
	,refreshTextValue: function(pArray) {
		var param;
		var _g = 0;
		while(_g < pArray.length) {
			var param1 = pArray[_g];
			++_g;
			this.setAllTextValues(param1.value,param1.isLevel,param1.type,param1.max);
		}
	}
	,setAllTextValues: function(value,isLevel,type,pMax) {
		if(isLevel) this.setTextValues("HUD_" + "Level","_level_txt",value); else if(type == com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise) this.setTextValues("HUD_" + "Wood","bar_txt",value); else if(type == com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell) this.setTextValues("HUD_" + "Iron","bar_txt",value); else if(type == com_isartdigital_perle_game_managers_GeneratorType.soft) this.setTextValues("HUD_" + "SoftCurrency","bar_txt",value,pMax); else if(type == com_isartdigital_perle_game_managers_GeneratorType.hard) this.setTextValues("HUD_" + "HardCurrency","bar_txt",value,pMax);
	}
	,setTextValues: function(pContainerName,pTextName,pValue,pMax) {
		var textContainer = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,pContainerName);
		var text;
		text = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(textContainer,pTextName) , com_isartdigital_utils_ui_smart_TextSprite);
		text.set_text(pMax != null?pValue + " / " + pMax:pValue + "");
	}
	,hide: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().removeChild(this);
		com_isartdigital_perle_ui_hud_Hud.isHide = true;
	}
	,show: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(this);
		com_isartdigital_perle_ui_hud_Hud.isHide = false;
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnResetData,$bind(this,this.onClickResetData));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnShop,$bind(this,this.onClickShop));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnPurgatory,$bind(this,this.onClickTribunal));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnInterns,$bind(this,this.onClickListIntern));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnMissions,$bind(this,this.onClickMission));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnIron,$bind(this,this.onClickShopResource));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnWood,$bind(this,this.onClickShopResource));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSoft,$bind(this,this.onClickShopCurrencies));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnHard,$bind(this,this.onClickShopCurrencies));
		com_isartdigital_perle_game_managers_ResourcesManager.totalResourcesEvent.off("TOTAL RESOURCES",$bind(this,this.refreshTextValue));
		com_isartdigital_perle_ui_hud_Hud.instance = null;
		com_isartdigital_utils_ui_smart_SmartScreen.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_Hud
});
var com_isartdigital_perle_ui_hud_building_BuildingHud = function(pID) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,pID);
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BuildingHud"] = com_isartdigital_perle_ui_hud_building_BuildingHud;
com_isartdigital_perle_ui_hud_building_BuildingHud.__name__ = ["com","isartdigital","perle","ui","hud","building","BuildingHud"];
com_isartdigital_perle_ui_hud_building_BuildingHud.linkVirtualBuilding = function(pVBuilding) {
	com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding = pVBuilding;
};
com_isartdigital_perle_ui_hud_building_BuildingHud.unlinkVirtualBuilding = function(pVBuilding) {
	if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.tileDesc.id == pVBuilding.tileDesc.id) com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding = null;
};
com_isartdigital_perle_ui_hud_building_BuildingHud.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_hud_building_BuildingHud.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	init: function() {
		this.addListeners();
	}
	,addListeners: function() {
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BuildingHud
});
var com_isartdigital_perle_ui_hud_building_BHBuilt = function(pID) {
	com_isartdigital_perle_ui_hud_building_BuildingHud.call(this,pID);
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BHBuilt"] = com_isartdigital_perle_ui_hud_building_BHBuilt;
com_isartdigital_perle_ui_hud_building_BHBuilt.__name__ = ["com","isartdigital","perle","ui","hud","building","BHBuilt"];
com_isartdigital_perle_ui_hud_building_BHBuilt.__super__ = com_isartdigital_perle_ui_hud_building_BuildingHud;
com_isartdigital_perle_ui_hud_building_BHBuilt.prototype = $extend(com_isartdigital_perle_ui_hud_building_BuildingHud.prototype,{
	setOnSpawn: function() {
		com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding;
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().interactive = true;
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().on("mousedown",$bind(this,this.onClickExit));
		this.setUpgradeButton();
		this.setMoveAndDestroy();
		this.setDescriptionButton();
	}
	,setMoveAndDestroy: function() {
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnMove,$bind(this,this.onClickMove));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnDestroy,$bind(this,this.onClickDestroy));
	}
	,setDescriptionButton: function() {
		if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade) || js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VTribunal)) {
			this.btnDescription.alpha = 1;
			com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnDescription,$bind(this,this.onClickDescription));
		} else {
			this.btnDescription.alpha = 0.5;
			com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnDescription,$bind(this,this.onClickDescription));
		}
	}
	,setUpgradeButton: function() {
		if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)) {
			var myVBuilding;
			myVBuilding = js_Boot.__cast(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade);
			if(myVBuilding.canUpgrade()) com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnUpgrade,$bind(this,this.onClickUpgrade)); else this.btnUpgrade.alpha = 0.5;
		} else this.btnUpgrade.alpha = 0.5;
	}
	,removeButtonsChange: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnMove,$bind(this,this.onClickMove));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnDestroy,$bind(this,this.onClickDestroy));
		this.btnUpgrade.removeAllListeners();
		this.btnUpgrade.alpha = 1;
		this.btnMove.alpha = 1;
		this.btnDestroy.alpha = 1;
	}
	,addListeners: function() {
		this.btnMove = js_Boot.__cast(this.getChildByName("MoveButton") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnDescription = js_Boot.__cast(this.getChildByName("EnterButton") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnUpgrade = js_Boot.__cast(this.getChildByName("ButtonUpgradeBuilding") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnDestroy = js_Boot.__cast(this.getChildByName("ButtonDestroyBuilding") , com_isartdigital_utils_ui_smart_SmartButton);
	}
	,removeListenerGameContainer: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().interactive = false;
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().off("mousedown",$bind(this,this.onClickExit));
	}
	,onClickMove: function() {
		this.removeButtonsChange();
		this.removeListenerGameContainer();
		com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.onClickMove();
		com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.MOVING,com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding);
	}
	,onClickDescription: function() {
		this.removeButtonsChange();
		this.removeListenerGameContainer();
		com_isartdigital_perle_ui_hud_Hud.getInstance().hide();
		if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VTribunal)) com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_TribunalPopin.getInstance()); else {
			com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding;
			com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_InfoBuilding.getInstance());
		}
		this.onClickExit();
	}
	,onClickDestroy: function() {
		this.removeButtonsChange();
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.getInstance());
		this.removeListenerGameContainer();
	}
	,onClickUpgrade: function() {
		this.removeButtonsChange();
		this.removeListenerGameContainer();
		com_isartdigital_perle_ui_popin_InfoBuilding.getInstance().onClickUpgrade();
		com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
	}
	,onClickExit: function() {
		this.removeButtonsChange();
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().interactive = false;
		com_isartdigital_utils_game_GameStage.getInstance().getBuildContainer().off("mousedown",$bind(this,this.onClickExit));
		com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnMove,$bind(this,this.onClickMove));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnDestroy,$bind(this,this.onClickDestroy));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnDescription,$bind(this,this.onClickDescription));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnUpgrade,$bind(this,this.onClickUpgrade));
		this.removeListenerGameContainer();
		com_isartdigital_perle_ui_hud_building_BuildingHud.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BHBuilt
});
var com_isartdigital_perle_ui_hud_building_BHConstruction = function() {
	com_isartdigital_perle_ui_hud_building_BuildingHud.call(this,"BuildingContext");
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BHConstruction"] = com_isartdigital_perle_ui_hud_building_BHConstruction;
com_isartdigital_perle_ui_hud_building_BHConstruction.__name__ = ["com","isartdigital","perle","ui","hud","building","BHConstruction"];
com_isartdigital_perle_ui_hud_building_BHConstruction.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_building_BHConstruction.instance == null) com_isartdigital_perle_ui_hud_building_BHConstruction.instance = new com_isartdigital_perle_ui_hud_building_BHConstruction();
	return com_isartdigital_perle_ui_hud_building_BHConstruction.instance;
};
com_isartdigital_perle_ui_hud_building_BHConstruction.__super__ = com_isartdigital_perle_ui_hud_building_BuildingHud;
com_isartdigital_perle_ui_hud_building_BHConstruction.prototype = $extend(com_isartdigital_perle_ui_hud_building_BuildingHud.prototype,{
	setOnSpawn: function() {
		this.setGameListener();
		this.buildingTimer = new com_isartdigital_perle_ui_hud_building_BuildingTimer();
		this.buildingTimer.spawn();
		this.addChild(this.buildingTimer);
	}
	,setGameListener: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getGameContainer().interactive = true;
		com_isartdigital_utils_game_GameStage.getInstance().getGameContainer().on("mouseup",$bind(this,this.onClickExit));
	}
	,addListeners: function() {
		this.btnMove = js_Boot.__cast(this.getChildByName("ButtonMoveBuilding") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnDestroy = js_Boot.__cast(this.getChildByName("ButtonCancelConstruction") , com_isartdigital_utils_ui_smart_SmartButton);
	}
	,onClickExit: function(pEvent) {
		this.buildingTimer.destroy();
		this.removeGameListener();
		com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
	}
	,onClickDestroy: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.getInstance());
		this.removeGameListener();
	}
	,removeGameListener: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getGameContainer().off("mouseup",$bind(this,this.onClickExit));
		com_isartdigital_utils_game_GameStage.getInstance().getGameContainer().interactive = false;
	}
	,destroy: function() {
		com_isartdigital_perle_ui_hud_building_BuildingHud.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BHConstruction
});
var com_isartdigital_perle_ui_hud_building_BHHarvest = function() {
	com_isartdigital_perle_ui_hud_building_BHBuilt.call(this,"BuiltContext");
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BHHarvest"] = com_isartdigital_perle_ui_hud_building_BHHarvest;
com_isartdigital_perle_ui_hud_building_BHHarvest.__name__ = ["com","isartdigital","perle","ui","hud","building","BHHarvest"];
com_isartdigital_perle_ui_hud_building_BHHarvest.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_building_BHHarvest.instance == null) com_isartdigital_perle_ui_hud_building_BHHarvest.instance = new com_isartdigital_perle_ui_hud_building_BHHarvest();
	return com_isartdigital_perle_ui_hud_building_BHHarvest.instance;
};
com_isartdigital_perle_ui_hud_building_BHHarvest.__super__ = com_isartdigital_perle_ui_hud_building_BHBuilt;
com_isartdigital_perle_ui_hud_building_BHHarvest.prototype = $extend(com_isartdigital_perle_ui_hud_building_BHBuilt.prototype,{
	setMoveAndDestroy: function() {
		if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VTribunal)) {
			this.btnMove.alpha = 0.5;
			this.btnDestroy.alpha = 0.5;
		} else com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.setMoveAndDestroy.call(this);
	}
	,destroy: function() {
		com_isartdigital_perle_ui_hud_building_BHHarvest.instance = null;
		com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BHHarvest
});
var com_isartdigital_perle_ui_hud_building_BHHarvestHouse = function() {
	com_isartdigital_perle_ui_hud_building_BHBuilt.call(this,"BuiltContext_house");
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BHHarvestHouse"] = com_isartdigital_perle_ui_hud_building_BHHarvestHouse;
com_isartdigital_perle_ui_hud_building_BHHarvestHouse.__name__ = ["com","isartdigital","perle","ui","hud","building","BHHarvestHouse"];
com_isartdigital_perle_ui_hud_building_BHHarvestHouse.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_building_BHHarvestHouse.instance == null) com_isartdigital_perle_ui_hud_building_BHHarvestHouse.instance = new com_isartdigital_perle_ui_hud_building_BHHarvestHouse();
	return com_isartdigital_perle_ui_hud_building_BHHarvestHouse.instance;
};
com_isartdigital_perle_ui_hud_building_BHHarvestHouse.__super__ = com_isartdigital_perle_ui_hud_building_BHBuilt;
com_isartdigital_perle_ui_hud_building_BHHarvestHouse.prototype = $extend(com_isartdigital_perle_ui_hud_building_BHBuilt.prototype,{
	addListeners: function() {
		this.soulConters = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"SoulsCounter_House"),"_infos_house_txt") , com_isartdigital_utils_ui_smart_TextSprite);
		com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.addListeners.call(this);
	}
	,setOnSpawn: function() {
		com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.setOnSpawn.call(this);
		var pPop = (js_Boot.__cast(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VHouse)).getPopulation();
		this.soulConters.set_text(pPop.quantity + "/" + pPop.max);
		if(this.spawner == null) this.spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"SoulsCounter_House"),"_infos_house_icon") , com_isartdigital_utils_ui_smart_UISprite);
		var aName = "";
		if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.heaven) aName = "_heavenSoulIcon_Small"; else aName = "_hellSoulIcon_Small";
		this.soulGraphic = new com_isartdigital_utils_ui_smart_UISprite(aName);
		this.soulGraphic.position = this.spawner.position;
		this.addChild(this.soulGraphic);
	}
	,removeButtonsChange: function() {
		this.addChild(this.spawner);
		this.removeChild(this.soulGraphic);
		com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.removeButtonsChange.call(this);
	}
	,destroy: function() {
		com_isartdigital_perle_ui_hud_building_BHHarvestHouse.instance = null;
		com_isartdigital_perle_ui_hud_building_BHBuilt.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BHHarvestHouse
});
var com_isartdigital_perle_ui_hud_building_BHMoving = function() {
	com_isartdigital_perle_ui_hud_building_BuildingHud.call(this,"MovingBuilding");
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BHMoving"] = com_isartdigital_perle_ui_hud_building_BHMoving;
com_isartdigital_perle_ui_hud_building_BHMoving.__name__ = ["com","isartdigital","perle","ui","hud","building","BHMoving"];
com_isartdigital_perle_ui_hud_building_BHMoving.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_building_BHMoving.instance == null) com_isartdigital_perle_ui_hud_building_BHMoving.instance = new com_isartdigital_perle_ui_hud_building_BHMoving();
	return com_isartdigital_perle_ui_hud_building_BHMoving.instance;
};
com_isartdigital_perle_ui_hud_building_BHMoving.__super__ = com_isartdigital_perle_ui_hud_building_BuildingHud;
com_isartdigital_perle_ui_hud_building_BHMoving.prototype = $extend(com_isartdigital_perle_ui_hud_building_BuildingHud.prototype,{
	cantBuildHere: function() {
		console.log("Can't Build Here !");
	}
	,addListeners: function() {
		this.btnCancel = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Button_CancelMovement") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnConfirm = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Button_ConfirmMovement") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnCancel,$bind(this,this.onClickCancel));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnConfirm,$bind(this,this.onClickConfirm));
	}
	,onClickCancel: function() {
		if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding == null) {
			com_isartdigital_perle_game_sprites_Phantom.onClickCancelBuild();
			com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
		} else {
			com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.onClickCancel();
			com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST,com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding);
		}
		com_isartdigital_perle_game_sprites_Building.isClickable = true;
	}
	,onClickConfirm: function() {
		if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding == null) com_isartdigital_perle_game_sprites_Phantom.onClickConfirmBuild(); else com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.onClickConfirm();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnCancel,$bind(this,this.onClickCancel));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnConfirm,$bind(this,this.onClickConfirm));
		com_isartdigital_perle_ui_hud_building_BHMoving.instance = null;
		com_isartdigital_perle_ui_hud_building_BuildingHud.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BHMoving
});
var com_isartdigital_utils_ui_Popin = function(pID) {
	com_isartdigital_utils_ui_UIComponent.call(this,pID);
};
$hxClasses["com.isartdigital.utils.ui.Popin"] = com_isartdigital_utils_ui_Popin;
com_isartdigital_utils_ui_Popin.__name__ = ["com","isartdigital","utils","ui","Popin"];
com_isartdigital_utils_ui_Popin.__super__ = com_isartdigital_utils_ui_UIComponent;
com_isartdigital_utils_ui_Popin.prototype = $extend(com_isartdigital_utils_ui_UIComponent.prototype,{
	__class__: com_isartdigital_utils_ui_Popin
});
var com_isartdigital_utils_ui_smart_SmartPopin = function(pID) {
	com_isartdigital_utils_ui_Popin.call(this,pID);
	this.build();
};
$hxClasses["com.isartdigital.utils.ui.smart.SmartPopin"] = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_utils_ui_smart_SmartPopin.__name__ = ["com","isartdigital","utils","ui","smart","SmartPopin"];
com_isartdigital_utils_ui_smart_SmartPopin.__super__ = com_isartdigital_utils_ui_Popin;
com_isartdigital_utils_ui_smart_SmartPopin.prototype = $extend(com_isartdigital_utils_ui_Popin.prototype,{
	__class__: com_isartdigital_utils_ui_smart_SmartPopin
});
var com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Popin_DestroyBuilding");
	this.addListeners();
	var lVBuilding;
	if(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding != null) lVBuilding = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding; else lVBuilding = com_isartdigital_perle_ui_popin_InfoBuilding.getVirtualBuilding();
	console.log(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding);
	console.log(com_isartdigital_perle_ui_popin_InfoBuilding.getVirtualBuilding());
	this.nameBuilding.set_text(com_isartdigital_perle_game_managers_FakeTraduction.assetNameNameToTrad(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.tileDesc.buildingName));
	if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)) this.levelBuilding.set_text("Level : " + Std.string((js_Boot.__cast(lVBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).indexLevel + 1)); else this.levelBuilding.set_text("");
	this.setImage(lVBuilding.getAsset());
	this.price.set_text("" + com_isartdigital_perle_game_managers_BuyManager.getSellPrice(lVBuilding.getAsset()));
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BuildingDestroyPoppin"] = com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin;
com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.__name__ = ["com","isartdigital","perle","ui","hud","building","BuildingDestroyPoppin"];
com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.instance == null) com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.instance = new com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin();
	return com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.instance;
};
com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	setImage: function(pAssetName) {
		var lImage = new com_isartdigital_perle_game_sprites_FlumpStateGraphic(pAssetName);
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		this.image.addChild(lImage);
		lImage.start();
	}
	,addListeners: function() {
		this.image = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Image_SelectedBuilding") , com_isartdigital_utils_ui_smart_UISprite);
		this.nameBuilding = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_text_selectedBuildingName") , com_isartdigital_utils_ui_smart_TextSprite);
		this.levelBuilding = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_text_selectedBuildingLevel") , com_isartdigital_utils_ui_smart_TextSprite);
		this.price = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_text_destroyBuildPayment") , com_isartdigital_utils_ui_smart_TextSprite);
		this.btnClose = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonClose") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnSell = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Button_DestroyBuildingConfirm") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.closePoppin));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnSell,$bind(this,this.sellBuilding));
	}
	,closePoppin: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
	}
	,sellBuilding: function() {
		com_isartdigital_perle_ui_popin_InfoBuilding.getInstance().sell();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.closePoppin));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSell,$bind(this,this.sellBuilding));
		com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BuildingDestroyPoppin
});
var com_isartdigital_perle_ui_hud_building_BuildingTimer = function() {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,"BuildingTimer");
};
$hxClasses["com.isartdigital.perle.ui.hud.building.BuildingTimer"] = com_isartdigital_perle_ui_hud_building_BuildingTimer;
com_isartdigital_perle_ui_hud_building_BuildingTimer.__name__ = ["com","isartdigital","perle","ui","hud","building","BuildingTimer"];
com_isartdigital_perle_ui_hud_building_BuildingTimer.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_hud_building_BuildingTimer.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	spawn: function() {
		this.loop = haxe_Timer.delay($bind(this,this.progressTimeLoop),1000);
		this.loop.run = $bind(this,this.progressTimeLoop);
		this.building = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding;
		this.getComponents();
		this.showTime();
	}
	,progressTimeLoop: function() {
		if(com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime(this.building.tileDesc) == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) {
			this.timeText.set_text(com_isartdigital_perle_game_managers_TimeManager.getTextTime(this.building.tileDesc));
			this.updateProgressBar();
		} else {
			this.progressBar.scale.x = 1;
			this.timeText.set_text("Finish");
			($_=this.loop,$bind($_,$_.stop));
		}
	}
	,updateProgressBar: function() {
		this.progressBar.scale.x = com_isartdigital_perle_game_managers_TimeManager.getPourcentage(this.building.tileDesc.timeDesc);
	}
	,showTime: function() {
		this.timeText.set_text(com_isartdigital_perle_game_managers_TimeManager.getTextTime(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.tileDesc));
		if(com_isartdigital_perle_game_managers_TimeManager.getBuildingStateFromTime(this.building.tileDesc) == com_isartdigital_perle_game_virtual_VBuildingState.isBuilding) com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnSpeedup,$bind(this,this.onClickSpeedup));
		this.updateProgressBar();
	}
	,onClickSpeedup: function() {
		console.log("decrease time contruction: -5s");
		var isFinish = com_isartdigital_perle_game_managers_TimeManager.increaseProgress(this.building,5000);
		if(isFinish) {
			this.timeText.set_text("Finish");
			com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSpeedup,$bind(this,this.onClickSpeedup));
		} else this.timeText.set_text(com_isartdigital_perle_game_managers_TimeManager.getTextTime(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding.tileDesc));
		this.updateProgressBar();
	}
	,getComponents: function() {
		this.progress = js_Boot.__cast(this.getChildByName("Gauge") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.timeText = js_Boot.__cast(this.progress.getChildByName("_time") , com_isartdigital_utils_ui_smart_TextSprite);
		this.progressBar = js_Boot.__cast(this.progress.getChildByName("_gauge") , com_isartdigital_utils_ui_smart_UISprite);
		this.btnSpeedup = js_Boot.__cast(this.getChildByName("Button") , com_isartdigital_utils_ui_smart_SmartButton);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSpeedup,$bind(this,this.onClickSpeedup));
		this.loop.stop();
		this.parent.removeChild(this);
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_building_BuildingTimer
});
var com_isartdigital_perle_ui_hud_dialogue_Arrow = function(pAsset) {
	com_isartdigital_perle_game_sprites_FlumpStateGraphic.call(this,"FTUE_arrow");
};
$hxClasses["com.isartdigital.perle.ui.hud.dialogue.Arrow"] = com_isartdigital_perle_ui_hud_dialogue_Arrow;
com_isartdigital_perle_ui_hud_dialogue_Arrow.__name__ = ["com","isartdigital","perle","ui","hud","dialogue","Arrow"];
com_isartdigital_perle_ui_hud_dialogue_Arrow.__super__ = com_isartdigital_perle_game_sprites_FlumpStateGraphic;
com_isartdigital_perle_ui_hud_dialogue_Arrow.prototype = $extend(com_isartdigital_perle_game_sprites_FlumpStateGraphic.prototype,{
	start: function() {
		com_isartdigital_perle_game_sprites_FlumpStateGraphic.prototype.start.call(this);
		if(this.factory == null) {
			this.factory = new com_isartdigital_utils_game_factory_FlumpMovieAnimFactory();
		}
		this.boxType = com_isartdigital_utils_game_BoxType.SELF;
		this.setState(this.DEFAULT_STATE,true);
	}
	,__class__: com_isartdigital_perle_ui_hud_dialogue_Arrow
});
var com_isartdigital_perle_ui_hud_dialogue_DialogueUI = function(pID) {
	com_isartdigital_utils_ui_smart_SmartScreen.call(this,"Window_NPC");
	this.set_modal(null);
	this.setWireframe();
};
$hxClasses["com.isartdigital.perle.ui.hud.dialogue.DialogueUI"] = com_isartdigital_perle_ui_hud_dialogue_DialogueUI;
com_isartdigital_perle_ui_hud_dialogue_DialogueUI.__name__ = ["com","isartdigital","perle","ui","hud","dialogue","DialogueUI"];
com_isartdigital_perle_ui_hud_dialogue_DialogueUI.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_dialogue_DialogueUI.instance == null) com_isartdigital_perle_ui_hud_dialogue_DialogueUI.instance = new com_isartdigital_perle_ui_hud_dialogue_DialogueUI();
	return com_isartdigital_perle_ui_hud_dialogue_DialogueUI.instance;
};
com_isartdigital_perle_ui_hud_dialogue_DialogueUI.__super__ = com_isartdigital_utils_ui_smart_SmartScreen;
com_isartdigital_perle_ui_hud_dialogue_DialogueUI.prototype = $extend(com_isartdigital_utils_ui_smart_SmartScreen.prototype,{
	closeFtue: function() {
		this.btnNext.removeAllListeners();
		com_isartdigital_perle_game_managers_DialogueManager.removeDialogue();
	}
	,setWireframe: function() {
		this.npc_name = js_Boot.__cast(this.getChildByName("Window_NPC" + "_Name_TXT") , com_isartdigital_utils_ui_smart_TextSprite);
		this.npc_speach = js_Boot.__cast(this.getChildByName("Window_NPC" + "_Speech_TXT") , com_isartdigital_utils_ui_smart_TextSprite);
		this.btnNext = js_Boot.__cast(this.getChildByName("Window_NPC" + "_ButtonNext") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnNext,$bind(this,this.onClickNext));
	}
	,onClickNext: function() {
		com_isartdigital_perle_game_managers_DialogueManager.endOfaDialogue();
	}
	,createText: function(pNumber,pNpc) {
		this.npc_name.set_text(pNpc);
		this.npc_speach.set_text(com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[pNumber - 1][0][1]);
		this.changeAlpha(com_isartdigital_perle_game_managers_DialogueManager.npc_dialogue_ftue[pNumber - 1][0][0],pNpc);
	}
	,changeAlpha: function(pNpc,pNpcCheck) {
		if(pNpc == pNpcCheck) {
			this.getChildByName("Window_NPC" + "_Heaven").alpha = 0.5;
			this.getChildByName("Window_NPC" + "_Hell").alpha = 1;
		} else {
			this.getChildByName("Window_NPC" + "_Heaven").alpha = 1;
			this.getChildByName("Window_NPC" + "_Hell").alpha = 0.5;
		}
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnNext,$bind(this,this.onClickNext));
		com_isartdigital_perle_ui_hud_dialogue_DialogueUI.instance = null;
		com_isartdigital_utils_ui_smart_SmartScreen.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_dialogue_DialogueUI
});
var com_isartdigital_perle_ui_hud_dialogue_FocusManager = function(pID) {
	com_isartdigital_utils_ui_Screen.call(this,pID);
	this.set_modalImage("assets/ftue_bg.png");
	this.shadow = new PIXI.Container();
};
$hxClasses["com.isartdigital.perle.ui.hud.dialogue.FocusManager"] = com_isartdigital_perle_ui_hud_dialogue_FocusManager;
com_isartdigital_perle_ui_hud_dialogue_FocusManager.__name__ = ["com","isartdigital","perle","ui","hud","dialogue","FocusManager"];
com_isartdigital_perle_ui_hud_dialogue_FocusManager.getInstance = function() {
	if(com_isartdigital_perle_ui_hud_dialogue_FocusManager.instance == null) {
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.instance = new com_isartdigital_perle_ui_hud_dialogue_FocusManager();
	}
	return com_isartdigital_perle_ui_hud_dialogue_FocusManager.instance;
};
com_isartdigital_perle_ui_hud_dialogue_FocusManager.__super__ = com_isartdigital_utils_ui_Screen;
com_isartdigital_perle_ui_hud_dialogue_FocusManager.prototype = $extend(com_isartdigital_utils_ui_Screen.prototype,{
	setFocus: function(pTarget,pRotation) {
		if(pRotation == null) {
			pRotation = 0;
		}
		if(this.target != null && this.target.parent == this) {
			this.swap(this.shadow,this.target);
		}
		this.target = pTarget;
		this.swap(this.target,this.shadow);
		this.arrowRotation = pRotation;
		this.onResize();
	}
	,close: function() {
		if(this.target != null && this.target.parent == this) {
			this.swap(this.shadow,this.target);
		}
		com_isartdigital_utils_ui_Screen.prototype.close.call(this);
	}
	,swap: function(pTarget,pFTUE) {
		var lParent = pTarget.parent;
		lParent.addChildAt(pFTUE,lParent.getChildIndex(pTarget));
		pFTUE.position = pTarget.position;
		this.addChildAt(pTarget,0);
		if(js_Boot.__instanceof(lParent,com_isartdigital_utils_ui_UIComponent)) {
			var lPositionnables = lParent.positionables;
			var _g1 = 0;
			var _g = lPositionnables.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(lPositionnables[i].item == pTarget) {
					lPositionnables[i].item = js_Boot.__cast(pFTUE , PIXI.Container);
					break;
				}
			}
		}
	}
	,onResize: function(pEvent) {
		if(this.target == null) {
			return;
		}
		if(this.arrow == null) {
			this.arrow = new com_isartdigital_perle_ui_hud_dialogue_Arrow();
			this.addChild(this.arrow);
			this.arrow.start();
		}
		this.target.position = this.toLocal(this.shadow.position,this.shadow.parent);
		this.arrow.rotation = this.arrowRotation * PIXI.DEG_TO_RAD;
		this.arrow.position = this.target.position;
		com_isartdigital_utils_ui_Screen.prototype.onResize.call(this,pEvent);
	}
	,destroy: function() {
		com_isartdigital_perle_ui_hud_dialogue_FocusManager.instance = null;
		com_isartdigital_utils_ui_Screen.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_hud_dialogue_FocusManager
});
var com_isartdigital_perle_ui_popin_InfoBuilding = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Fenetre_InfoMaison");
	console.log(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding);
	this.setGlobalInfos();
	this.setGoldZone();
	this.setPopulationInfos();
	this.setUpgradeInfos();
	this.setUpgradeButton();
	if(js_Boot.__instanceof(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)) this.fileInfosText();
	this.setImage(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.getAsset());
	this.setButtonsAndAddListeners();
};
$hxClasses["com.isartdigital.perle.ui.popin.InfoBuilding"] = com_isartdigital_perle_ui_popin_InfoBuilding;
com_isartdigital_perle_ui_popin_InfoBuilding.__name__ = ["com","isartdigital","perle","ui","popin","InfoBuilding"];
com_isartdigital_perle_ui_popin_InfoBuilding.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_InfoBuilding.instance == null) com_isartdigital_perle_ui_popin_InfoBuilding.instance = new com_isartdigital_perle_ui_popin_InfoBuilding();
	return com_isartdigital_perle_ui_popin_InfoBuilding.instance;
};
com_isartdigital_perle_ui_popin_InfoBuilding.getVirtualBuilding = function() {
	return com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding;
};
com_isartdigital_perle_ui_popin_InfoBuilding.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_InfoBuilding.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	linkVirtualBuilding: function(pVBuilding) {
		com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding = pVBuilding;
	}
	,fileInfosText: function() {
		this.levelTxt.set_text("Level : " + Std.string((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).getLevel() + 1));
		this.upgradeInfosTxt.set_text(this.getGoldValuesUpgradeText((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).indexLevel));
		this.upgradeInfosMaterialsTxt.set_text(this.getMaterialsValuesUpgradeText((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).indexLevel));
		this.btnUpgradeGoldTxt.set_text(this.getGoldValuesUpgradeText((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).indexLevel));
		this.btnUpgradeMaterialsTxt.set_text(this.getMaterialsValuesUpgradeText((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).indexLevel));
		this.populationTxt.set_text(this.getPopulationText());
		this.goldZoneTxt.set_text(this.getGoldText());
		if((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).getLevel() >= 2) {
			this.btnUpgrade.parent.removeChild(this.btnUpgrade);
			this.btnUpgrade.destroy();
			this.upgradeInfos.parent.removeChild(this.upgradeInfos);
			this.upgradeInfos.destroy();
		}
	}
	,setGlobalInfos: function() {
		this.levelTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Building_Level_txt") , com_isartdigital_utils_ui_smart_TextSprite);
		this.nameTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Name") , com_isartdigital_utils_ui_smart_TextSprite);
		this.image = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Image") , com_isartdigital_utils_ui_smart_UISprite);
		this.nameTxt.set_text(com_isartdigital_perle_game_managers_FakeTraduction.assetNameNameToTrad(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.getAsset()));
	}
	,setPopulationInfos: function() {
		this.population = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Population") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.populationTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.population,"Window_Infos_txtPopulation") , com_isartdigital_utils_ui_smart_TextSprite);
	}
	,setImage: function(pAssetName) {
		var lImage = new com_isartdigital_perle_game_sprites_FlumpStateGraphic(pAssetName);
		lImage.init();
		lImage.width = 250;
		lImage.height = 250;
		this.image.addChild(lImage);
		lImage.start();
	}
	,setUpgradeButton: function() {
		this.btnUpgrade = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonUpgrade") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnUpgradeGoldTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.btnUpgrade,"_Upgrade_goldValue") , com_isartdigital_utils_ui_smart_TextSprite);
		this.btnUpgradeMaterialsTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.btnUpgrade,"_Upgrade_ressValue") , com_isartdigital_utils_ui_smart_TextSprite);
		this.btnUpgradeMaterialsImage = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.btnUpgrade,"_soulIcon_Small") , com_isartdigital_utils_ui_smart_UISprite);
		if(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.heaven) {
			this.btnUpgradeMaterialsImage.addChild(new com_isartdigital_utils_ui_smart_UISprite("_woodIcon_Large"));
			this.upgradeInfosMaterialsIcon.addChild(new com_isartdigital_utils_ui_smart_UISprite("_woodIcon_Large"));
		}
		if(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.alignementBuilding == com_isartdigital_perle_game_managers_Alignment.hell) {
			this.btnUpgradeMaterialsImage.addChild(new com_isartdigital_utils_ui_smart_UISprite("_stoneIcon_Large"));
			this.upgradeInfosMaterialsIcon.addChild(new com_isartdigital_utils_ui_smart_UISprite("_stoneIcon_Large"));
		}
	}
	,setUpgradeInfos: function() {
		this.upgradeInfos = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"UpgradeInfo") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.upgradeInfosTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.upgradeInfos,"ButtonUpgrade_Cost_txt") , com_isartdigital_utils_ui_smart_TextSprite);
		this.upgradeInfosMaterialsTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.upgradeInfos,"BuildRes1_Text") , com_isartdigital_utils_ui_smart_TextSprite);
		this.upgradeInfosGoldIcon = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.upgradeInfos,"GoldIcon") , com_isartdigital_utils_ui_smart_UISprite);
		this.upgradeInfosGoldIcon.addChild(new com_isartdigital_utils_ui_smart_UISprite("_goldIcon__Large_Prod"));
		this.upgradeInfosMaterialsIcon = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.upgradeInfos,"BuildRes1_Icon") , com_isartdigital_utils_ui_smart_UISprite);
	}
	,setGoldZone: function() {
		this.goldZone = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"LimitGold") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.goldZoneTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.goldZone,"Window_Infos_txtGoldLimit") , com_isartdigital_utils_ui_smart_TextSprite);
		this.goldZoneImage = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.goldZone,"_soft_icon") , com_isartdigital_utils_ui_smart_UISprite);
		this.goldZoneImage.addChild(new com_isartdigital_utils_ui_smart_UISprite("_goldIcon__Large_Prod"));
	}
	,setGoldSeconds: function() {
		this.goldSeconds = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ProductionGold") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.goldSecondesTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.goldSeconds,"Window_Infos_txtProductionGold") , com_isartdigital_utils_ui_smart_TextSprite);
		this.goldSecondesImage = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.goldSeconds,"GoldIcon") , com_isartdigital_utils_ui_smart_UISprite);
		this.goldSecondesImage.addChild(new com_isartdigital_utils_ui_smart_UISprite("_goldIcon__Large_Prod"));
		this.goldSecondesTxt.set_text("xxx");
	}
	,setButtonsAndAddListeners: function() {
		this.btnExit = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonClose") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnSell = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonDestroy") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnExit,$bind(this,this.onClickExit));
	}
	,getPopulationText: function() {
		var lPopulationTxt;
		var lPop = (js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VHouse)).getPopulation();
		lPopulationTxt = lPop.quantity + "/" + lPop.max;
		return lPopulationTxt;
	}
	,getGoldText: function() {
		var lGeneratorDesc = com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.myGenerator.desc;
		var lGoldText = lGeneratorDesc.quantity + "/" + lGeneratorDesc.max;
		return lGoldText;
	}
	,getGoldValuesUpgradeText: function(pLevel) {
		var lGoldValuesText = (js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).UpgradeGoldValuesList[pLevel];
		return lGoldValuesText;
	}
	,getMaterialsValuesUpgradeText: function(pLevel) {
		var lMaterialsValuesText = (js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade)).UpgradeMaterialsValuesList[pLevel];
		return lMaterialsValuesText;
	}
	,onClickExit: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	}
	,onClickSell: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		if(js_Boot.__instanceof(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding,com_isartdigital_perle_game_virtual_vBuilding_VHouse)) com_isartdigital_perle_ui_hud_building_BHHarvestHouse.getInstance().onClickDestroy(); else com_isartdigital_perle_ui_hud_building_BHHarvest.getInstance().onClickDestroy();
	}
	,sell: function() {
		com_isartdigital_perle_ui_hud_building_BuildingHud.linkVirtualBuilding(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding);
		com_isartdigital_perle_game_managers_BuyManager.sell((js_Boot.__cast(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.graphic , com_isartdigital_perle_game_sprites_Building)).getAssetName());
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding.destroy();
		com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
		com_isartdigital_perle_game_managers_SaveManager.save();
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	}
	,onClickUpgrade: function() {
		var lVBuilding;
		if(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding != null) lVBuilding = com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding; else lVBuilding = com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding;
		console.log(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding);
		console.log(com_isartdigital_perle_ui_popin_InfoBuilding.virtualBuilding);
		var lAssetName = lVBuilding.tileDesc.buildingName;
		var lBuildingUpgrade;
		lBuildingUpgrade = js_Boot.__cast(lVBuilding , com_isartdigital_perle_game_virtual_vBuilding_VBuildingUpgrade);
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		lBuildingUpgrade.onClickUpgrade();
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnUpgrade,$bind(this,this.onClickUpgrade));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnExit,$bind(this,this.onClickExit));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSell,$bind(this,this.onClickSell));
		com_isartdigital_perle_ui_popin_InfoBuilding.instance = null;
	}
	,__class__: com_isartdigital_perle_ui_popin_InfoBuilding
});
var com_isartdigital_perle_ui_popin_InternPopin = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Interns");
	this.side = js_Boot.__cast(this.getChildByName("_intern_side") , com_isartdigital_utils_ui_smart_TextSprite);
	this.internName = js_Boot.__cast(this.getChildByName("_intern_name") , com_isartdigital_utils_ui_smart_TextSprite);
	this.side.set_text("GDP");
	this.internName.set_text("Alexis");
	var interMc;
	interMc = js_Boot.__cast(this.getChildByName("Bouton_AllInterns_Clip") , com_isartdigital_utils_ui_smart_SmartComponent);
	this.btnSeeAll = js_Boot.__cast(interMc.getChildByName("Button") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnClose = js_Boot.__cast(this.getChildByName("ButtonCancel") , com_isartdigital_utils_ui_smart_SmartButton);
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.onClose));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnSeeAll,$bind(this,this.onSeeAll));
};
$hxClasses["com.isartdigital.perle.ui.popin.InternPopin"] = com_isartdigital_perle_ui_popin_InternPopin;
com_isartdigital_perle_ui_popin_InternPopin.__name__ = ["com","isartdigital","perle","ui","popin","InternPopin"];
com_isartdigital_perle_ui_popin_InternPopin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_InternPopin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	onClose: function() {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
	}
	,onSeeAll: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.onClose));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSeeAll,$bind(this,this.onSeeAll));
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_InternPopin
});
var com_isartdigital_perle_ui_popin_TribunalPopin = function(pID) {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"PurgatoryPop");
	var interMovieClip;
	this.btnClose = js_Boot.__cast(this.getChildByName("CloseButton") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnShop = js_Boot.__cast(this.getChildByName("ShopButton") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnIntern = js_Boot.__cast(this.getChildByName("InternsButton") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnHeaven = js_Boot.__cast(this.getChildByName("HeavenButton") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnHell = js_Boot.__cast(this.getChildByName("HellButton") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnUpgrade = js_Boot.__cast(this.getChildByName("ButtonUpgrade") , com_isartdigital_utils_ui_smart_SmartButton);
	this.tribunalLevel = js_Boot.__cast(this.getChildByName("BuildingLevel") , com_isartdigital_utils_ui_smart_TextSprite);
	this.tribunalLevel.set_text("LEVEL " + 1);
	interMovieClip = this.getChildByName("UpgradeTimer");
	this.timer = js_Boot.__cast(interMovieClip.getChildByName("TimeInfo") , com_isartdigital_utils_ui_smart_TextSprite);
	this.timer.set_text("0" + 0 + "h" + "0" + 0 + "m" + "0" + 0 + "s");
	interMovieClip = this.getChildByName("FateTitle");
	this.fateName = js_Boot.__cast(interMovieClip.getChildByName("Name") , com_isartdigital_utils_ui_smart_TextSprite);
	this.fateName.set_text("Children");
	this.fateAdjective = js_Boot.__cast(interMovieClip.getChildByName("Adjective") , com_isartdigital_utils_ui_smart_TextSprite);
	this.fateAdjective.set_text("not guilty");
	interMovieClip = this.getChildByName("HeavenINfo");
	this.infoHeaven = js_Boot.__cast(interMovieClip.getChildByName("bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	interMovieClip = this.getChildByName("HellInfo");
	this.infoHell = js_Boot.__cast(interMovieClip.getChildByName("bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	interMovieClip = this.getChildByName("SoulCounter");
	this.infoSoul = js_Boot.__cast(interMovieClip.getChildByName("Value") , com_isartdigital_utils_ui_smart_TextSprite);
	this.changeSoulTextInfo();
	this.btnUpgrade.on("mouseover",$bind(this,this.rewriteUpgradeTxt));
	this.btnUpgrade.on("mouseout",$bind(this,this.rewriteUpgradeTxt));
	this.btnUpgrade.on("mousedown",$bind(this,this.rewriteUpgradeTxt));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.onClose));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnHeaven,$bind(this,this.onHeaven));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnHell,$bind(this,this.onHell));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnShop,$bind(this,this.onShop));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnIntern,$bind(this,this.onIntern));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnUpgrade,$bind(this,this.onUpgrade));
	com_isartdigital_perle_game_managers_ResourcesManager.soulArrivedEvent.on("SOUL_ARRIVED",$bind(this,this.onSoulArrivedEvent));
};
$hxClasses["com.isartdigital.perle.ui.popin.TribunalPopin"] = com_isartdigital_perle_ui_popin_TribunalPopin;
com_isartdigital_perle_ui_popin_TribunalPopin.__name__ = ["com","isartdigital","perle","ui","popin","TribunalPopin"];
com_isartdigital_perle_ui_popin_TribunalPopin.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_TribunalPopin.instance == null) com_isartdigital_perle_ui_popin_TribunalPopin.instance = new com_isartdigital_perle_ui_popin_TribunalPopin();
	return com_isartdigital_perle_ui_popin_TribunalPopin.instance;
};
com_isartdigital_perle_ui_popin_TribunalPopin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_TribunalPopin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	onClose: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	}
	,onShop: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance());
		com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance().init(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
	}
	,onIntern: function() {
		js_Browser.alert("Work in progress : Special Feature");
	}
	,onHeaven: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.judgePopulation(com_isartdigital_perle_game_managers_Alignment.heaven);
		this.changeSoulTextInfo();
	}
	,onHell: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.judgePopulation(com_isartdigital_perle_game_managers_Alignment.hell);
		this.changeSoulTextInfo();
	}
	,changeSoulTextInfo: function() {
		var myTotalPopulation = com_isartdigital_perle_game_managers_ResourcesManager.getTotalAllPopulations();
		var myNeutralPopulation = com_isartdigital_perle_game_managers_ResourcesManager.getTotalNeutralPopulation();
		this.infoHeaven.set_text(myTotalPopulation.heaven.quantity + "/" + myTotalPopulation.heaven.max);
		this.infoHell.set_text(myTotalPopulation.hell.quantity + "/" + myTotalPopulation.hell.max);
		this.infoSoul.set_text(myNeutralPopulation.quantity + "/" + myNeutralPopulation.max);
	}
	,onSoulArrivedEvent: function(pParam) {
		this.changeSoulTextInfo();
	}
	,onUpgrade: function() {
		this.rewriteUpgradeTxt();
	}
	,rewriteUpgradeTxt: function() {
		this.upgradePrice = js_Boot.__cast(this.btnUpgrade.getChildByName("Cost") , com_isartdigital_utils_ui_smart_TextSprite);
		this.upgradePrice.set_text(2000 + "$");
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.onClose));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnHeaven,$bind(this,this.onHeaven));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnHell,$bind(this,this.onHell));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnShop,$bind(this,this.onShop));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnIntern,$bind(this,this.onIntern));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnUpgrade,$bind(this,this.onUpgrade));
		com_isartdigital_perle_ui_popin_TribunalPopin.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_TribunalPopin
});
var com_isartdigital_perle_ui_popin_choice_ChoiceType = { __ename__ : true, __constructs__ : ["HEAVEN","HELL","NONE"] };
com_isartdigital_perle_ui_popin_choice_ChoiceType.HEAVEN = ["HEAVEN",0];
com_isartdigital_perle_ui_popin_choice_ChoiceType.HEAVEN.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceType.HEAVEN.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceType;
com_isartdigital_perle_ui_popin_choice_ChoiceType.HELL = ["HELL",1];
com_isartdigital_perle_ui_popin_choice_ChoiceType.HELL.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceType.HELL.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceType;
com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE = ["NONE",2];
com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceType;
var com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText = { __ename__ : true, __constructs__ : ["DESC","HELL","HEAVEN"] };
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.DESC = ["DESC",0];
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.DESC.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.DESC.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText;
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL = ["HELL",1];
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText;
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN = ["HEAVEN",2];
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN.toString = $estr;
com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN.__enum__ = com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText;
var com_isartdigital_perle_ui_popin_choice_Choice = function(pID) {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Intern_Event");
	this.getComponents();
	this.createChoiceText();
	this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE;
	this.imgPos = new flump_library_Point(this.choiceCard.position.x,this.choiceCard.position.y);
	com_isartdigital_perle_ui_popin_choice_Choice.isOpen = true;
	this.testIntern = { id : 2, name : "Angel A. Merkhell", aligment : "angel", quest : null, price : 2000, stress : 0, stressLimit : 10, speed : 5, efficiency : 0.1};
	this.addListeners();
};
$hxClasses["com.isartdigital.perle.ui.popin.choice.Choice"] = com_isartdigital_perle_ui_popin_choice_Choice;
com_isartdigital_perle_ui_popin_choice_Choice.__name__ = ["com","isartdigital","perle","ui","popin","choice","Choice"];
com_isartdigital_perle_ui_popin_choice_Choice.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_choice_Choice.instance == null) com_isartdigital_perle_ui_popin_choice_Choice.instance = new com_isartdigital_perle_ui_popin_choice_Choice();
	return com_isartdigital_perle_ui_popin_choice_Choice.instance;
};
com_isartdigital_perle_ui_popin_choice_Choice.isVisible = function() {
	return com_isartdigital_perle_ui_popin_choice_Choice.isOpen;
};
com_isartdigital_perle_ui_popin_choice_Choice.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_choice_Choice.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	getComponents: function() {
		this.presentationChoice = js_Boot.__cast(this.getChildByName("_event_description") , com_isartdigital_utils_ui_smart_TextSprite);
		this.heavenChoice = js_Boot.__cast(this.getChildByName("_heavenChoice_text") , com_isartdigital_utils_ui_smart_TextSprite);
		this.evilChoice = js_Boot.__cast(this.getChildByName("_hellChoice_text") , com_isartdigital_utils_ui_smart_TextSprite);
		this.internName = js_Boot.__cast(this.getChildByName("_event_internName") , com_isartdigital_utils_ui_smart_TextSprite);
		this.internSide = js_Boot.__cast(this.getChildByName("_event_internSide") , com_isartdigital_utils_ui_smart_TextSprite);
		this.btnInterns = js_Boot.__cast(this.getChildByName("ButtonInterns") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnDismiss = js_Boot.__cast(this.getChildByName("BoutonDismissIntern") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnClose = js_Boot.__cast(this.getChildByName("CloseButton") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnShare = js_Boot.__cast(this.getChildByName("Button_Friends") , com_isartdigital_utils_ui_smart_SmartButton);
		this.choiceCard = js_Boot.__cast(this.getChildByName("_event_FateCard") , com_isartdigital_utils_ui_smart_UISprite);
		this.internStats = js_Boot.__cast(this.getChildByName("_event_interStats") , com_isartdigital_utils_ui_smart_SmartComponent);
	}
	,createChoiceText: function() {
		var txtChoice = com_isartdigital_perle_game_TextGenerator.GetNewSituation();
		var _g = new haxe_ds_EnumValueMap();
		_g.set(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.DESC,txtChoice[0]);
		_g.set(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL,txtChoice[2]);
		_g.set(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN,txtChoice[1]);
		this.textDescAnswer = _g;
		this.presentationChoice.set_text(this.textDescAnswer.get(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.DESC));
		this.heavenChoice.set_text(this.textDescAnswer.get(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN));
		this.evilChoice.set_text(this.textDescAnswer.get(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL));
	}
	,addListeners: function() {
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnDismiss,$bind(this,this.onDismiss));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnInterns,$bind(this,this.onSeeAll));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnShare,$bind(this,this.shareEvent));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.onClose));
		this.choiceCard.interactive = true;
		this.choiceCard.on("mousedown",$bind(this,this.startFollow));
	}
	,showInternStats: function(internDesc) {
	}
	,shareEvent: function() {
		console.log("share");
	}
	,onDismiss: function() {
		console.log("dismiss");
	}
	,onSeeAll: function() {
		this.hide();
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
	}
	,startFollow: function(mEvent) {
		this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE;
		this.mousePos = new flump_library_Point(mEvent.data.global.x,mEvent.data.global.y);
		this.choiceCard.on("mousemove",$bind(this,this.followMouse));
		this.choiceCard.on("mouseupoutside",$bind(this,this.replaceCard));
		this.choiceCard.on("mouseup",$bind(this,this.replaceCard));
	}
	,followMouse: function(mEvent) {
		var diff = mEvent.data.global.x - this.mousePos.x;
		if(diff > 0 && Math.abs(diff) < 200) {
			this.choiceCard.position.set(this.imgPos.x + 80 * (diff / 200),this.imgPos.y);
			if(Math.abs(diff) > 80) this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.HELL; else this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE;
		} else if(diff < 0 && Math.abs(diff) < 200) {
			this.choiceCard.position.set(this.imgPos.x + 80 * (diff / 200),this.imgPos.y);
			if(Math.abs(diff) > 80) this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.HEAVEN; else this.choiceType = com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE;
		}
	}
	,replaceCard: function() {
		this.choiceCard.position.set(this.imgPos.x,this.imgPos.y);
		this.choiceCard.off("mousemove",$bind(this,this.followMouse));
		if(this.choiceType != com_isartdigital_perle_ui_popin_choice_ChoiceType.NONE) {
			if(this.choiceType == com_isartdigital_perle_ui_popin_choice_ChoiceType.HEAVEN) this.chooseHeavenCHoice(); else this.chooseHellChoice();
			this.onClose();
		}
	}
	,chooseHellChoice: function() {
		console.log(this.textDescAnswer.get(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HELL));
		com_isartdigital_perle_game_managers_QuestsManager.goToNextStep();
	}
	,chooseHeavenCHoice: function() {
		console.log(this.textDescAnswer.get(com_isartdigital_perle_ui_popin_choice_ChoiceGeneratedText.HEAVEN));
		com_isartdigital_perle_game_managers_QuestsManager.goToNextStep();
	}
	,onClose: function() {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		this.destroy();
	}
	,hide: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().removeChild(this);
	}
	,show: function() {
		com_isartdigital_utils_game_GameStage.getInstance().getHudContainer().addChild(this);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnDismiss,$bind(this,this.onDismiss));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnInterns,$bind(this,this.onSeeAll));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnShare,$bind(this,this.shareEvent));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.onClose));
		com_isartdigital_perle_ui_popin_choice_Choice.isOpen = false;
		this.parent.removeChild(this);
		com_isartdigital_perle_ui_popin_choice_Choice.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_choice_Choice
});
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
=======
var com_isartdigital_perle_ui_popin_collector_CollectorPopin = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"InfoCollector");
	var myCollector = js_Boot.__cast(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VCollector);
	this.btnClose = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonClose") , com_isartdigital_utils_ui_smart_SmartButton);
	var spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_productionSpawner") , com_isartdigital_utils_ui_smart_UISprite);
	if(myCollector.product) {
		this.addTimer(spawner,myCollector);
	} else {
		this.addPanel(spawner);
	}
	spawner.parent.removeChild(spawner);
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.onClose));
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.CollectorPopin"] = com_isartdigital_perle_ui_popin_collector_CollectorPopin;
com_isartdigital_perle_ui_popin_collector_CollectorPopin.__name__ = ["com","isartdigital","perle","ui","popin","collector","CollectorPopin"];
com_isartdigital_perle_ui_popin_collector_CollectorPopin.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_collector_CollectorPopin.instance == null) {
		com_isartdigital_perle_ui_popin_collector_CollectorPopin.instance = new com_isartdigital_perle_ui_popin_collector_CollectorPopin();
	}
	return com_isartdigital_perle_ui_popin_collector_CollectorPopin.instance;
};
com_isartdigital_perle_ui_popin_collector_CollectorPopin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_collector_CollectorPopin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	addPanel: function(spawner) {
		this.prodPanel = new com_isartdigital_perle_ui_popin_collector_ProductionPanel();
		this.prodPanel.position = spawner.position;
		this.addChild(this.prodPanel);
	}
	,addTimer: function(spawner,pCollector) {
		this.timer = new com_isartdigital_perle_ui_popin_collector_TimerInProd(pCollector);
		this.timer.position = spawner.position;
		this.addChild(this.timer);
	}
	,onClose: function() {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
	}
	,destroy: function() {
		com_isartdigital_perle_ui_popin_collector_CollectorPopin.instance = null;
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.onClose));
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_collector_CollectorPopin
});
var com_isartdigital_perle_ui_popin_collector_PackPanel = function(pID,i) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,pID);
	this.vBuildingLink = js_Boot.__cast(com_isartdigital_perle_ui_hud_building_BuildingHud.virtualBuilding , com_isartdigital_perle_game_virtual_vBuilding_VCollector);
	var spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_buildRessourceIcon_Large") , com_isartdigital_utils_ui_smart_UISprite);
	var icon = new com_isartdigital_utils_ui_smart_UISprite(js_Boot.__instanceof(this.vBuildingLink,com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven)?"_woodIcon_Large":"_stoneIcon_Large");
	icon.position = spawner.position;
	spawner.parent.removeChild(spawner);
	this.addChild(icon);
	this.timeText = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_time_value") , com_isartdigital_utils_ui_smart_TextSprite);
	this.gainText = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"_ressourceGain_text") , com_isartdigital_utils_ui_smart_TextSprite);
	this.pack = this.vBuildingLink.myPacks[i];
	var lClock = com_isartdigital_perle_game_TimesInfo.getClock(this.pack.time);
	this.timeText.set_text(lClock.minute + ":" + lClock.seconde);
	this.gainText.set_text("" + this.pack.quantity);
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.PackPanel"] = com_isartdigital_perle_ui_popin_collector_PackPanel;
com_isartdigital_perle_ui_popin_collector_PackPanel.__name__ = ["com","isartdigital","perle","ui","popin","collector","PackPanel"];
com_isartdigital_perle_ui_popin_collector_PackPanel.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_popin_collector_PackPanel.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	__class__: com_isartdigital_perle_ui_popin_collector_PackPanel
});
var com_isartdigital_perle_ui_popin_collector_PackPanelLock = function(i) {
	com_isartdigital_perle_ui_popin_collector_PackPanel.call(this,"ProductionPanel_Locked",i);
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.PackPanelLock"] = com_isartdigital_perle_ui_popin_collector_PackPanelLock;
com_isartdigital_perle_ui_popin_collector_PackPanelLock.__name__ = ["com","isartdigital","perle","ui","popin","collector","PackPanelLock"];
com_isartdigital_perle_ui_popin_collector_PackPanelLock.__super__ = com_isartdigital_perle_ui_popin_collector_PackPanel;
com_isartdigital_perle_ui_popin_collector_PackPanelLock.prototype = $extend(com_isartdigital_perle_ui_popin_collector_PackPanel.prototype,{
	__class__: com_isartdigital_perle_ui_popin_collector_PackPanelLock
});
var com_isartdigital_perle_ui_popin_collector_PackPanelUnlock = function(i) {
	com_isartdigital_perle_ui_popin_collector_PackPanel.call(this,"ProductionPanel",i);
	this.btnLunch = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ButtonProduce") , com_isartdigital_utils_ui_smart_SmartButton);
	this.rewrite();
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnLunch,$bind(this,this.onClick),null,$bind(this,this.rewrite));
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.PackPanelUnlock"] = com_isartdigital_perle_ui_popin_collector_PackPanelUnlock;
com_isartdigital_perle_ui_popin_collector_PackPanelUnlock.__name__ = ["com","isartdigital","perle","ui","popin","collector","PackPanelUnlock"];
com_isartdigital_perle_ui_popin_collector_PackPanelUnlock.__super__ = com_isartdigital_perle_ui_popin_collector_PackPanel;
com_isartdigital_perle_ui_popin_collector_PackPanelUnlock.prototype = $extend(com_isartdigital_perle_ui_popin_collector_PackPanel.prototype,{
	onClick: function() {
		this.rewrite();
		this.vBuildingLink.startProduction(this.pack);
		com_isartdigital_perle_ui_popin_collector_CollectorPopin.getInstance().onClose();
	}
	,rewrite: function() {
		(js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.btnLunch,"_buttonProduce_GoldValue") , com_isartdigital_utils_ui_smart_TextSprite)).set_text("" + this.pack.cost);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnLunch,$bind(this,this.onClick),null,$bind(this,this.rewrite));
		com_isartdigital_perle_ui_popin_collector_PackPanel.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_collector_PackPanelUnlock
});
var com_isartdigital_perle_ui_popin_collector_ProductionPanel = function() {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,"ProductionPanelsContainer");
	this.panels = [];
	var _g = 0;
	while(_g < 6) {
		var i = _g++;
		if(i < 3) {
			this.spawnPackPanel("_productionPanelSpawner" + (i + 1),false,i);
		} else {
			this.spawnPackPanel("_productionPanelSpawner" + (i + 1),true,i);
		}
	}
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.ProductionPanel"] = com_isartdigital_perle_ui_popin_collector_ProductionPanel;
com_isartdigital_perle_ui_popin_collector_ProductionPanel.__name__ = ["com","isartdigital","perle","ui","popin","collector","ProductionPanel"];
com_isartdigital_perle_ui_popin_collector_ProductionPanel.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_popin_collector_ProductionPanel.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	spawnPackPanel: function(spawnerName,isLocked,i) {
		var panel = isLocked?new com_isartdigital_perle_ui_popin_collector_PackPanelLock(i):new com_isartdigital_perle_ui_popin_collector_PackPanelUnlock(i);
		var spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,spawnerName) , com_isartdigital_utils_ui_smart_UISprite);
		panel.position = spawner.position;
		spawner.parent.removeChild(spawner);
		this.addChild(panel);
		this.panels.push(panel);
	}
	,__class__: com_isartdigital_perle_ui_popin_collector_ProductionPanel
});
var com_isartdigital_perle_ui_popin_collector_TimerInProd = function(collector) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,"CollectorInProduction");
	com_isartdigital_perle_ui_SmartCheck.traceChildrens(this);
	this.progressBarTxt = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"TimeGauge") , com_isartdigital_utils_ui_smart_SmartComponent),"_Text_TimeSkipGaugeTime") , com_isartdigital_utils_ui_smart_TextSprite);
	this.rewrite(collector.timeProd);
	this.gain = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ProducingValue");
	this.gain.set_text(collector.timeProd.gain + "");
	var spawner = com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"ProducingIcon");
	var icone = new com_isartdigital_utils_ui_smart_UISprite(js_Boot.__instanceof(collector,com_isartdigital_perle_game_virtual_vBuilding_vHeaven_VCollectorHeaven)?"_woodIcon_Large":"_stoneIcon_Large");
	icone.position = spawner.position;
	this.addChild(icone);
	spawner.parent.removeChild(spawner);
	com_isartdigital_perle_game_managers_TimeManager.eProduction.on("Production_Time",$bind(this,this.rewrite));
};
$hxClasses["com.isartdigital.perle.ui.popin.collector.TimerInProd"] = com_isartdigital_perle_ui_popin_collector_TimerInProd;
com_isartdigital_perle_ui_popin_collector_TimerInProd.__name__ = ["com","isartdigital","perle","ui","popin","collector","TimerInProd"];
com_isartdigital_perle_ui_popin_collector_TimerInProd.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_popin_collector_TimerInProd.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	rewrite: function(pTime) {
		var clock = com_isartdigital_perle_game_TimesInfo.getClock(pTime.progress);
		this.progressBarTxt.set_text(clock.minute + ":" + clock.seconde);
	}
	,destroy: function() {
		com_isartdigital_perle_game_managers_TimeManager.eProduction.off("Production_Time",$bind(this,this.rewrite));
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_collector_TimerInProd
});
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
var com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Popin_LevelUp");
	this.setWireframe();
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.setPopin();
};
$hxClasses["com.isartdigital.perle.ui.popin.levelUp.LevelUpPoppin"] = com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin;
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.__name__ = ["com","isartdigital","perle","ui","popin","levelUp","LevelUpPoppin"];
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.instance == null) com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.instance = new com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin();
	return com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.instance;
};
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.setPopin = function() {
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.level.set_text("" + com_isartdigital_perle_game_managers_ResourcesManager.getLevel());
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.setImage(com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[0][0][1]);
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.nameUnlock.set_text(com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[0][0][2]);
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.typeUnlock.set_text(com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[0][0][3]);
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.description.set_text(com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin[0][0][4]);
	com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin.splice(0,1);
};
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.closeAll = function() {
	com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin = [];
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.onClickNext();
};
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.setImage = function(pAssetName) {
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage = new com_isartdigital_perle_game_sprites_FlumpStateGraphic(pAssetName);
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage.init();
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage.width = 250;
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage.height = 250;
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.img.addChild(com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage);
	com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage.start();
};
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.onClickNext = function() {
	if(com_isartdigital_perle_game_managers_UnlockManager.itemUnlockedForPoppin.length != 0) {
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.img.removeChild(com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.imgImage);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.setPopin();
	} else {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
	}
};
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	setWireframe: function() {
		this.bgLvl = js_Boot.__cast(this.getChildByName("_bg_level") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.unlock = js_Boot.__cast(this.getChildByName("_unlock") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.level = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.bgLvl,"level") , com_isartdigital_utils_ui_smart_TextSprite);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.nameUnlock = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.unlock,"_txt_name") , com_isartdigital_utils_ui_smart_TextSprite);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.description = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.unlock,"Description") , com_isartdigital_utils_ui_smart_TextSprite);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.typeUnlock = js_Boot.__cast(this.getChildByName("_txt_type") , com_isartdigital_utils_ui_smart_TextSprite);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.img = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.unlock,"Image") , com_isartdigital_utils_ui_smart_UISprite);
		this.btnNext = js_Boot.__cast(this.getChildByName("Button_NextReward") , com_isartdigital_utils_ui_smart_SmartButton);
		this.btnCloseAll = js_Boot.__cast(this.getChildByName("ButtonShowAll") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnNext,com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.onClickNext);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnCloseAll,com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.closeAll);
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnNext,com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.onClickNext);
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnCloseAll,com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.closeAll);
		com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin.instance = null;
	}
	,__class__: com_isartdigital_perle_ui_popin_levelUp_LevelUpPoppin
});
var com_isartdigital_perle_ui_popin_listIntern_InternElement = function(pID,pPos) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,pID);
	this.position = pPos;
};
$hxClasses["com.isartdigital.perle.ui.popin.listIntern.InternElement"] = com_isartdigital_perle_ui_popin_listIntern_InternElement;
com_isartdigital_perle_ui_popin_listIntern_InternElement.__name__ = ["com","isartdigital","perle","ui","popin","listIntern","InternElement"];
com_isartdigital_perle_ui_popin_listIntern_InternElement.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_popin_listIntern_InternElement.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	onPicture: function() {
		console.log("picture");
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.picture,$bind(this,this.onPicture));
		this.parent.removeChild(this);
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_listIntern_InternElement
});
var com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest = function(pPos,pDesc) {
	this.progressIndex = 0;
	com_isartdigital_perle_ui_popin_listIntern_InternElement.call(this,"ListInQuest",pPos);
	this.getComponents();
	com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray = [this.eventCursor1,this.eventCursor2,this.eventCursor3];
	this.setOnSpawn(pDesc);
	this.addListeners();
};
$hxClasses["com.isartdigital.perle.ui.popin.listIntern.InternElementInQuest"] = com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest;
com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.__name__ = ["com","isartdigital","perle","ui","popin","listIntern","InternElementInQuest"];
com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.__super__ = com_isartdigital_perle_ui_popin_listIntern_InternElement;
com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.prototype = $extend(com_isartdigital_perle_ui_popin_listIntern_InternElement.prototype,{
	getComponents: function() {
		this.btnAccelerate = js_Boot.__cast(this.getChildByName("Bouton_InternSend_Clip") , com_isartdigital_utils_ui_smart_SmartButton);
		this.accelerateValue = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.btnAccelerate,"_accelerate_cost") , com_isartdigital_utils_ui_smart_TextSprite);
		this.internName = js_Boot.__cast(this.getChildByName("InQuest_name") , com_isartdigital_utils_ui_smart_TextSprite);
		this.questTime = js_Boot.__cast(this.getChildByName("InQuest_ProgressionBar") , com_isartdigital_utils_ui_smart_SmartComponent);
		this.heroCursor = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_hero") , com_isartdigital_utils_ui_smart_UISprite);
		this.heroCursorStartPosition = (js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_hero") , com_isartdigital_utils_ui_smart_UISprite)).position.clone();
		this.eventCursor1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_nextEvent01") , com_isartdigital_utils_ui_smart_UISprite);
		this.eventCursor2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_nextEvent02") , com_isartdigital_utils_ui_smart_UISprite);
		this.eventCursor3 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_nextEvent03") , com_isartdigital_utils_ui_smart_UISprite);
		this.timeEvent = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this.questTime,"_listInQuest_eventTime") , com_isartdigital_utils_ui_smart_TextSprite);
		this.picture = js_Boot.__cast(this.getChildByName("InQuest_Portrait") , com_isartdigital_utils_ui_smart_SmartButton);
		this.questGauge = js_Boot.__cast(this.getChildByName("InQuest_ProgressionBar") , com_isartdigital_utils_ui_smart_SmartComponent);
	}
	,setOnSpawn: function(pDesc) {
		this.loop = haxe_Timer.delay($bind(this,this.progressLoop),10);
		this.loop.run = $bind(this,this.progressLoop);
		this.internName.set_text(pDesc.name);
		this.accelerateValue.set_text("2");
		this.quest = pDesc.quest;
		this.questGaugeLenght = this.questGauge.position.x / 1.75 - this.heroCursorStartPosition.x;
		var _g1 = 0;
		var _g = com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray.length;
		while(_g1 < _g) {
			var i = _g1++;
			com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray[i].position.x = this.questGaugeLenght * this.quest.steps[i] / this.quest.end + this.heroCursorStartPosition.x;
		}
		com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.addListener("TimeManager_Construction_End",$bind(this,this.endQuest));
		this.timeEvent.set_text(com_isartdigital_perle_game_managers_TimeManager.getTextTimeQuest(pDesc.quest.end) + "s");
	}
	,addListeners: function() {
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnAccelerate,$bind(this,this.onAccelerate));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.picture,$bind(this,this.onPicture));
	}
	,onAccelerate: function() {
		com_isartdigital_perle_game_managers_ResourcesManager.spendTotal(com_isartdigital_perle_game_managers_GeneratorType.hard,2);
		if(!com_isartdigital_perle_game_managers_TimeManager.increaseQuestProgress(this.quest)) console.log("quest end!");
	}
	,progressLoop: function() {
		if(this.heroCursor.position != null) {
			this.updateEventCursors();
			this.timeEvent.set_text(com_isartdigital_perle_game_managers_TimeManager.getTextTimeQuest(this.quest.steps[this.quest.stepIndex] - this.quest.progress) + "s");
			this.updateCursorPosition();
		} else this.loop.stop();
	}
	,updateEventCursors: function() {
		var _g1 = 0;
		var _g = com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(i != this.quest.stepIndex) com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray[i].alpha = 0.5; else com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.eventCursorsArray[i].alpha = 1;
		}
	}
	,updateCursorPosition: function() {
		if(this.quest.stepIndex != 3) this.heroCursor.position.x = Math.min(this.questGaugeLenght * this.quest.progress / this.quest.end + this.heroCursorStartPosition.x,this.questGaugeLenght * this.quest.steps[this.quest.stepIndex] / this.quest.end + this.heroCursorStartPosition.x); else {
			this.eventCursor3.alpha = 1;
			this.heroCursor.position.x = this.questGaugeLenght * this.quest.steps[2] / this.quest.end + this.heroCursorStartPosition.x;
			this.timeEvent.set_text("00:00 s");
		}
	}
	,endQuest: function(pQuest) {
		this.loop.stop();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnAccelerate,$bind(this,this.onAccelerate));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.picture,$bind(this,this.onPicture));
		com_isartdigital_perle_ui_popin_listIntern_InternElement.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest
});
var com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest = function(pPos,pDesc) {
	com_isartdigital_perle_ui_popin_listIntern_InternElement.call(this,"ListOutQuest",pPos);
	com_isartdigital_perle_game_managers_TimeManager.eTimeQuest.on("TimeManager_Resource_End_Reached",$bind(this,this.updateQuestHud));
	this.picture = js_Boot.__cast(this.getChildByName("OutQuest_Portrait") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnSend = js_Boot.__cast(this.getChildByName("Bouton_SendIntern_List") , com_isartdigital_utils_ui_smart_SmartButton);
	this.internName = js_Boot.__cast(this.getChildByName("_intern03_name05") , com_isartdigital_utils_ui_smart_TextSprite);
	this.internName.set_text(pDesc.name);
	this.internDatas = pDesc;
	this.idIntern = pDesc.id;
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.picture,$bind(this,this.onPicture));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnSend,$bind(this,this.onSend));
};
$hxClasses["com.isartdigital.perle.ui.popin.listIntern.InternElementOutQuest"] = com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest;
com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest.__name__ = ["com","isartdigital","perle","ui","popin","listIntern","InternElementOutQuest"];
com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest.__super__ = com_isartdigital_perle_ui_popin_listIntern_InternElement;
com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest.prototype = $extend(com_isartdigital_perle_ui_popin_listIntern_InternElement.prototype,{
	onSend: function() {
		console.log("send");
		var lLength = com_isartdigital_perle_game_managers_QuestsManager.questsList.length;
		var lQuest = com_isartdigital_perle_game_managers_QuestsManager.createQuest(this.idIntern);
		this.internDatas.quest = lQuest;
		com_isartdigital_perle_game_managers_TimeManager.createTimeQuest(lQuest);
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.canPushNewScreen = true;
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
	}
	,updateQuestHud: function(pQuest) {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
		com_isartdigital_utils_game_GameStage.getInstance().getPopinsContainer().addChild(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance());
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.picture,$bind(this,this.onPicture));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnSend,$bind(this,this.onSend));
		com_isartdigital_perle_ui_popin_listIntern_InternElement.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest
});
var com_isartdigital_perle_ui_popin_listIntern_ListInternPopin = function() {
	this.internDescriptionArray = [];
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"ListInterns");
	this.btnClose = js_Boot.__cast(this.getChildByName("ButtonClose") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnLeft = js_Boot.__cast(this.getChildByName("_arrow_left") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnRight = js_Boot.__cast(this.getChildByName("_arrow_right") , com_isartdigital_utils_ui_smart_SmartButton);
	var _g1 = 0;
	var _g = com_isartdigital_perle_game_AssetName.internListSpawners.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(i < com_isartdigital_perle_game_sprites_Intern.internsListArray.length) this.spawnInternDescription(com_isartdigital_perle_game_AssetName.internListSpawners[i],com_isartdigital_perle_game_sprites_Intern.internsListArray[i]); else this.destroySpawner(js_Boot.__cast(this.getChildByName(com_isartdigital_perle_game_AssetName.internListSpawners[i]) , com_isartdigital_utils_ui_smart_UISprite));
	}
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnLeft,$bind(this,this.onLeft));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnRight,$bind(this,this.onRight));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnClose,$bind(this,this.onClose));
};
$hxClasses["com.isartdigital.perle.ui.popin.listIntern.ListInternPopin"] = com_isartdigital_perle_ui_popin_listIntern_ListInternPopin;
com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.__name__ = ["com","isartdigital","perle","ui","popin","listIntern","ListInternPopin"];
com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.instance == null) com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.instance = new com_isartdigital_perle_ui_popin_listIntern_ListInternPopin();
	return com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.instance;
};
com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	spawnInternDescription: function(spawnerName,pDesc) {
		var spawner;
		spawner = js_Boot.__cast(this.getChildByName(spawnerName) , com_isartdigital_utils_ui_smart_UISprite);
		var blocDescription;
		if(pDesc.quest != null) blocDescription = new com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest(spawner.position,pDesc); else blocDescription = new com_isartdigital_perle_ui_popin_listIntern_InternElementOutQuest(spawner.position,pDesc);
		this.addChild(blocDescription);
		this.internDescriptionArray.push(blocDescription);
		this.destroySpawner(spawner);
	}
	,destroySpawner: function(spawner) {
		spawner.parent.removeChild(spawner);
		spawner.destroy();
	}
	,onLeft: function() {
		console.log("left");
	}
	,onRight: function() {
		console.log("right");
	}
	,onClose: function() {
		if(com_isartdigital_perle_ui_popin_choice_Choice.isVisible()) return;
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnLeft,$bind(this,this.onLeft));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnRight,$bind(this,this.onRight));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnClose,$bind(this,this.onClose));
		var myInternDesc;
		var _g = 0;
		var _g1 = this.internDescriptionArray;
		while(_g < _g1.length) {
			var myInternDesc1 = _g1[_g];
			++_g;
			myInternDesc1.destroy();
			this.internDescriptionArray.shift();
		}
		com_isartdigital_perle_ui_popin_listIntern_ListInternPopin.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_listIntern_ListInternPopin
});
var com_isartdigital_perle_ui_popin_listIntern_MaxStress = function(pID) {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Popin_MaxStress");
};
$hxClasses["com.isartdigital.perle.ui.popin.listIntern.MaxStress"] = com_isartdigital_perle_ui_popin_listIntern_MaxStress;
com_isartdigital_perle_ui_popin_listIntern_MaxStress.__name__ = ["com","isartdigital","perle","ui","popin","listIntern","MaxStress"];
com_isartdigital_perle_ui_popin_listIntern_MaxStress.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_listIntern_MaxStress.instance == null) com_isartdigital_perle_ui_popin_listIntern_MaxStress.instance = new com_isartdigital_perle_ui_popin_listIntern_MaxStress();
	return com_isartdigital_perle_ui_popin_listIntern_MaxStress.instance;
};
com_isartdigital_perle_ui_popin_listIntern_MaxStress.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_listIntern_MaxStress.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	destroy: function() {
		com_isartdigital_perle_ui_popin_listIntern_MaxStress.instance = null;
	}
	,__class__: com_isartdigital_perle_ui_popin_listIntern_MaxStress
});
var com_isartdigital_utils_ui_smart_SmartButton = function(pID) {
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,pID);
	this.set_modal(false);
	this.interactive = true;
	this.buttonMode = true;
	this.on("mouseover",$bind(this,this._mouseOver));
	this.on("mousedown",$bind(this,this._mouseDown));
	this.on("click",$bind(this,this._click));
	this.on("mouseout",$bind(this,this._mouseOut));
	this.on("mouseupoutside",$bind(this,this._mouseOut));
	this.on("touchstart",$bind(this,this._mouseDown));
	this.on("tap",$bind(this,this._click));
	this.on("touchend",$bind(this,this._mouseOut));
	this.on("touchendoutside",$bind(this,this._mouseOut));
};
$hxClasses["com.isartdigital.utils.ui.smart.SmartButton"] = com_isartdigital_utils_ui_smart_SmartButton;
com_isartdigital_utils_ui_smart_SmartButton.__name__ = ["com","isartdigital","utils","ui","smart","SmartButton"];
com_isartdigital_utils_ui_smart_SmartButton.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_utils_ui_smart_SmartButton.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	build: function(pFrame) {
		if(pFrame == null) pFrame = 0;
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.build.call(this,3);
		this.hitArea = this.getBounds().clone();
		this._mouseOut();
	}
	,clear: function() {
		while(this.children.length > 0) this.removeChildAt(0);
	}
	,_click: function(pEvent) {
		this._mouseOut();
	}
	,_mouseDown: function(pEvent) {
		this.clear();
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.build.call(this,2);
	}
	,_mouseOver: function(pEvent) {
		this.clear();
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.build.call(this,1);
	}
	,_mouseOut: function(pEvent) {
		this.clear();
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.build.call(this);
	}
	,destroy: function() {
		this.off("mouseover",$bind(this,this._mouseOver));
		this.off("mousedown",$bind(this,this._mouseDown));
		this.off("click",$bind(this,this._click));
		this.off("mouseout",$bind(this,this._mouseOut));
		this.off("mouseupoutside",$bind(this,this._mouseOut));
		this.off("touchstart",$bind(this,this._mouseDown));
		this.off("tap",$bind(this,this._click));
		this.off("touchend",$bind(this,this._mouseOut));
		this.off("touchendoutside",$bind(this,this._mouseOut));
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_utils_ui_smart_SmartButton
});
var com_isartdigital_perle_ui_popin_shop_CarouselCard = function(pAsset) {
	com_isartdigital_utils_ui_smart_SmartButton.call(this,pAsset);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CarouselCard"] = com_isartdigital_perle_ui_popin_shop_CarouselCard;
com_isartdigital_perle_ui_popin_shop_CarouselCard.__name__ = ["com","isartdigital","perle","ui","popin","shop","CarouselCard"];
com_isartdigital_perle_ui_popin_shop_CarouselCard.__super__ = com_isartdigital_utils_ui_smart_SmartButton;
com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype = $extend(com_isartdigital_utils_ui_smart_SmartButton.prototype,{
	init: function(pBuildingName) {
		this.buildingName = pBuildingName;
		this.isInit = true;
		this.buildCard();
	}
	,_mouseDown: function(pEvent) {
		com_isartdigital_utils_ui_smart_SmartButton.prototype._mouseDown.call(this,pEvent);
		if(this.isInit) {
			this.buildCard();
		}
	}
	,_mouseOver: function(pEvent) {
		com_isartdigital_utils_ui_smart_SmartButton.prototype._mouseOver.call(this,pEvent);
		if(this.isInit) {
			this.buildCard();
		}
	}
	,_mouseOut: function(pEvent) {
		com_isartdigital_utils_ui_smart_SmartButton.prototype._mouseOut.call(this,pEvent);
		if(this.isInit) {
			this.buildCard();
		}
	}
	,buildCard: function() {
	}
	,start: function() {
	}
	,setImage: function(pAssetName) {
		var lImage = new com_isartdigital_perle_game_sprites_FlumpStateGraphic(pAssetName);
		lImage.init();
		lImage.width = this.image.width;
		lImage.height = this.image.height;
		this.image.addChild(lImage);
		lImage.x = 0;
		lImage.y = 0;
		lImage.start();
	}
	,destroy: function() {
		com_isartdigital_utils_ui_smart_SmartButton.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CarouselCard
});
var com_isartdigital_perle_ui_popin_shop_CarousselCardLock = function() {
	com_isartdigital_perle_ui_popin_shop_CarouselCard.call(this,"Shop_" + "BuildingDeco_LockedItem");
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CarousselCardLock"] = com_isartdigital_perle_ui_popin_shop_CarousselCardLock;
com_isartdigital_perle_ui_popin_shop_CarousselCardLock.__name__ = ["com","isartdigital","perle","ui","popin","shop","CarousselCardLock"];
com_isartdigital_perle_ui_popin_shop_CarousselCardLock.__super__ = com_isartdigital_perle_ui_popin_shop_CarouselCard;
com_isartdigital_perle_ui_popin_shop_CarousselCardLock.prototype = $extend(com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype,{
	buildCard: function() {
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.buildCard.call(this);
		this.image = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_Picture") , com_isartdigital_utils_ui_smart_UISprite);
		this.text_lock = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Reason_locked") , com_isartdigital_utils_ui_smart_TextSprite);
		this.setText();
	}
	,setText: function() {
		this.text_lock.set_text("Level : " + com_isartdigital_perle_game_managers_UnlockManager.checkLevelNeeded(this.buildingName));
	}
	,destroy: function() {
		if(this.parent != null) this.parent.removeChild(this);
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CarousselCardLock
});
var com_isartdigital_perle_ui_popin_shop_CCLBuilding = function() {
	com_isartdigital_perle_ui_popin_shop_CarousselCardLock.call(this);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CCLBuilding"] = com_isartdigital_perle_ui_popin_shop_CCLBuilding;
com_isartdigital_perle_ui_popin_shop_CCLBuilding.__name__ = ["com","isartdigital","perle","ui","popin","shop","CCLBuilding"];
com_isartdigital_perle_ui_popin_shop_CCLBuilding.__super__ = com_isartdigital_perle_ui_popin_shop_CarousselCardLock;
com_isartdigital_perle_ui_popin_shop_CCLBuilding.prototype = $extend(com_isartdigital_perle_ui_popin_shop_CarousselCardLock.prototype,{
	buildCard: function() {
		com_isartdigital_perle_ui_popin_shop_CarousselCardLock.prototype.buildCard.call(this);
		this.setImage(com_isartdigital_perle_game_BuildingName.getAssetName(this.buildingName));
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CCLBuilding
});
var com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock = function(pID) {
	com_isartdigital_perle_ui_popin_shop_CarouselCard.call(this,pID);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CarousselCardUnlock"] = com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock;
com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.__name__ = ["com","isartdigital","perle","ui","popin","shop","CarousselCardUnlock"];
com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.__super__ = com_isartdigital_perle_ui_popin_shop_CarouselCard;
com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype = $extend(com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype,{
	init: function(pBuildingName) {
		this.lAssetName = com_isartdigital_perle_game_BuildingName.getAssetName(pBuildingName);
<<<<<<< HEAD:bin/ui.js
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.init.call(this,pBuildingName);
	}
	,buildCard: function() {
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.buildCard.call(this);
		if(!com_isartdigital_perle_game_managers_BuyManager.canBuy(this.buildingName)) {
			this.alpha = 0.5;
		}
=======
		if(!com_isartdigital_perle_game_managers_BuyManager.canBuy(pBuildingName)) this.alpha = 0.5;
		this.setPrice(com_isartdigital_perle_game_managers_BuyManager.checkPrice(pBuildingName));
	}
	,start: function() {
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.start.call(this);
>>>>>>> btn accelerate working:bin/Builder.js
	}
	,setName: function(pAssetName) {
	}
	,setPrice: function(pInt) {
		this.text_price.set_text(pInt == null?"null":"" + pInt);
	}
	,_click: function(pEvent) {
		if(this.alpha == 0.5) return;
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype._click.call(this,pEvent);
		this.closeShop();
	}
	,closeShop: function() {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
	}
	,numberToGive: function() {
		var _g = this.lAssetName;
		switch(_g) {
		case "Wood pack":
			return 1000;
		case "Iron pack":
			return 1000;
		case "Gold pack":
			return 10000;
		case "Karma pack":
			return 100;
		}
		return 0;
	}
	,destroy: function() {
		if(this.parent != null) this.parent.removeChild(this);
		com_isartdigital_perle_ui_popin_shop_CarouselCard.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock
});
var com_isartdigital_perle_ui_popin_shop_CCUBuilding = function() {
	com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.call(this,"ButtonBuyBuildingDeco");
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CCUBuilding"] = com_isartdigital_perle_ui_popin_shop_CCUBuilding;
com_isartdigital_perle_ui_popin_shop_CCUBuilding.__name__ = ["com","isartdigital","perle","ui","popin","shop","CCUBuilding"];
com_isartdigital_perle_ui_popin_shop_CCUBuilding.__super__ = com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock;
com_isartdigital_perle_ui_popin_shop_CCUBuilding.prototype = $extend(com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype,{
	setRessourcesPrice: function() {
		var item_price;
		item_price = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_ResourcePrice") , com_isartdigital_utils_ui_smart_TextSprite);
		var item_price2;
		item_price2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_ResourcePrice2") , com_isartdigital_utils_ui_smart_TextSprite);
		var item_icon;
		item_icon = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Resource_icon") , com_isartdigital_utils_ui_smart_UISprite);
		var item_icon2;
		item_icon2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Resource_icon2") , com_isartdigital_utils_ui_smart_UISprite);
		this.removeChild(item_price);
		this.removeChild(item_price2);
		this.removeChild(item_icon);
		this.removeChild(item_icon2);
	}
	,buildCard: function() {
		com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype.buildCard.call(this);
		this.image = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_picture") , com_isartdigital_utils_ui_smart_UISprite);
		this.text_name = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_Name") , com_isartdigital_utils_ui_smart_TextSprite);
		this.text_price = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Item_SCPrice") , com_isartdigital_utils_ui_smart_TextSprite);
		this.setRessourcesPrice();
		this.setImage(com_isartdigital_perle_game_BuildingName.getAssetName(this.buildingName));
		this.setName(com_isartdigital_perle_game_managers_FakeTraduction.assetNameNameToTrad(this.buildingName));
		this.setPrice(com_isartdigital_perle_game_managers_BuyManager.checkPrice(this.buildingName));
	}
	,setName: function(pString) {
		this.text_name.set_text(pString);
	}
	,_click: function(pEvent) {
		com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype._click.call(this,pEvent);
		if(com_isartdigital_perle_game_managers_BuyManager.canBuy(this.buildingName)) {
			com_isartdigital_perle_game_sprites_Phantom.onClickShop(this.buildingName);
			com_isartdigital_perle_ui_hud_Hud.getInstance().hideBuildingHud();
			com_isartdigital_perle_ui_hud_Hud.getInstance().changeBuildingHud(com_isartdigital_perle_ui_hud_BuildingHudType.MOVING);
		}
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CCUBuilding
});
var com_isartdigital_perle_ui_popin_shop_CCUResource = function() {
	com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.call(this,"ButtonBuyPack");
	this.text_number_resource = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Pack_Content_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	this.text_price = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Pack_Price") , com_isartdigital_utils_ui_smart_TextSprite);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.CCUResource"] = com_isartdigital_perle_ui_popin_shop_CCUResource;
com_isartdigital_perle_ui_popin_shop_CCUResource.__name__ = ["com","isartdigital","perle","ui","popin","shop","CCUResource"];
com_isartdigital_perle_ui_popin_shop_CCUResource.__super__ = com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock;
com_isartdigital_perle_ui_popin_shop_CCUResource.prototype = $extend(com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype,{
	setName: function(pAssetName) {
		this.text_number_resource.set_text("" + this.numberToGive());
	}
	,init: function(pBuildingName) {
		com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype.init.call(this,pBuildingName);
		this.addGraphic();
	}
	,addGraphic: function() {
		var lAsset = "_goldIcon_Small";
		var _g = this.lAssetName;
		switch(_g) {
		case "Wood pack":
			lAsset = "_woodIcon_Small";
			break;
		case "Iron pack":
			lAsset = "_stoneIcon_Small";
			break;
		case "Gold pack":
			lAsset = "_goldIcon_Small";
			break;
		case "Karma pack":
			lAsset = "_hardCurrencyIcon_Small";
			break;
		}
		var icon = new com_isartdigital_utils_ui_smart_UISprite(lAsset);
		var spawner;
		spawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Pack_Content_Icon") , com_isartdigital_utils_ui_smart_UISprite);
		icon.position = spawner.position;
		this.removeChild(spawner);
		this.addChild(icon);
	}
	,_click: function(pEvent) {
		com_isartdigital_perle_ui_popin_shop_CarousselCardUnlock.prototype._click.call(this,pEvent);
		var _g = this.lAssetName;
		switch(_g) {
		case "Wood pack":
			com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise,1000);
			break;
		case "Iron pack":
			com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell,1000);
			break;
		case "Gold pack":
			com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.soft,10000);
			break;
		case "Karma pack":
			com_isartdigital_perle_game_managers_ResourcesManager.gainResources(com_isartdigital_perle_game_managers_GeneratorType.hard,100);
			break;
		}
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_CCUResource
});
var com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie = function() {
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Popin_ConfirmBuyEuro");
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.ConfirmBuyCurrencie"] = com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie;
com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.__name__ = ["com","isartdigital","perle","ui","popin","shop","ConfirmBuyCurrencie"];
com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.instance == null) com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.instance = new com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie();
	return com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.instance;
};
com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	destroy: function() {
		com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie
});
var com_isartdigital_perle_ui_popin_shop_ShopCaroussel = function(pID) {
	this.buildingListIndex = 0;
	com_isartdigital_utils_ui_smart_SmartComponent.call(this,pID);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.ShopCaroussel"] = com_isartdigital_perle_ui_popin_shop_ShopCaroussel;
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.__name__ = ["com","isartdigital","perle","ui","popin","shop","ShopCaroussel"];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.__super__ = com_isartdigital_utils_ui_smart_SmartComponent;
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.prototype = $extend(com_isartdigital_utils_ui_smart_SmartComponent.prototype,{
	init: function(pPos) {
		this.cards = [];
		com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow = com_isartdigital_perle_ui_popin_shop_ShopCaroussel.buildingNameList;
		this.cardsPositions = [];
		this.position = pPos;
		this.createCard(this.getSpawnersPosition(this.getSpawners(this.getSpawnersAssetNames())));
	}
	,start: function() {
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.arrowLeft,$bind(this,this.onClickArrowLeft));
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.arrowRight,$bind(this,this.onClickArrowRight));
	}
	,changeCardsToShow: function(pNameList) {
		com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow = pNameList;
		this.buildingListIndex = 0;
		this.createCard(this.cardsPositions);
	}
	,scrollNext: function() {
		if(this.buildingListIndex + this.maxCardsVisible >= com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow.length) this.buildingListIndex = 0; else this.buildingListIndex += this.maxCardsVisible;
		this.createCard(this.cardsPositions);
	}
	,scrollPrecedent: function() {
		if(this.buildingListIndex - this.maxCardsVisible < 0) this.buildingListIndex = com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow.length - com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow.length % this.maxCardsVisible; else this.buildingListIndex -= this.maxCardsVisible;
		this.createCard(this.cardsPositions);
	}
	,onClickArrowLeft: function() {
		this.scrollPrecedent();
	}
	,onClickArrowRight: function() {
		this.scrollNext();
	}
	,getSpawnersAssetNames: function() {
		return [];
	}
	,getSpawners: function(pAssetNames) {
		var lSpawners = [];
		this.setMaxCard(pAssetNames.length);
		var _g1 = 0;
		var _g = pAssetNames.length;
		while(_g1 < _g) {
			var i = _g1++;
			lSpawners.push(js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,pAssetNames[i]) , com_isartdigital_utils_ui_smart_UISprite));
		}
		return lSpawners;
	}
	,setMaxCard: function(pMax) {
		this.maxCardsVisible = pMax;
	}
	,setCardsPosition: function(pPositions) {
		this.cardsPositions = pPositions;
	}
	,getSpawnersPosition: function(pSpawners) {
		var lPositions = [];
		var _g1 = 0;
		var _g = pSpawners.length;
		while(_g1 < _g) {
			var i = _g1++;
			var lPoint = new PIXI.Point();
			lPoint.copy(pSpawners[i].position);
			lPositions.push(lPoint);
		}
		this.setCardsPosition(lPositions);
		this.destroySpawners(pSpawners);
		return lPositions;
	}
	,destroySpawners: function(pSpawners) {
		var lLength = pSpawners.length;
		var j;
		var _g1 = 1;
		var _g = lLength + 1;
		while(_g1 < _g) {
			var i = _g1++;
			j = lLength - i;
			this.removeChild(pSpawners[j]);
			pSpawners[j].destroy();
		}
	}
	,createCard: function(pPositions) {
		if(this.cards.length != 0) this.destroyCards();
		var _g1 = 0;
		var _g = pPositions.length;
		while(_g1 < _g) {
			var i = _g1++;
			var j = i + this.buildingListIndex;
			if(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow[j] == null) break;
			this.cards[i] = this.getNewCard(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow[j]);
			this.cards[i].position = pPositions[i];
			this.cards[i].init(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.cardsToShow[j]);
			this.addChild(this.cards[i]);
			this.cards[i].start();
		}
	}
	,getNewCard: function(pCardToShow) {
		return null;
	}
	,destroyCards: function() {
		var lLength = this.cards.length;
		var j;
		var _g1 = 1;
		var _g = lLength + 1;
		while(_g1 < _g) {
			var i = _g1++;
			j = lLength - i;
			this.cards[j].destroy();
			this.cards.splice(j,1);
		}
	}
	,destroy: function() {
		this.parent.removeChild(this);
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.arrowLeft,$bind(this,this.onClickArrowLeft));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.arrowRight,$bind(this,this.onClickArrowRight));
		this.destroyCards();
		this.cards = null;
		com_isartdigital_utils_ui_smart_SmartComponent.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_ShopCaroussel
});
var com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding = function() {
	com_isartdigital_perle_ui_popin_shop_ShopCaroussel.call(this,"Shop_" + "BuildingDeco_List");
	this.arrowLeft = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Button_ArrowLeft") , com_isartdigital_utils_ui_smart_SmartButton);
	this.arrowRight = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Button_ArrowRight") , com_isartdigital_utils_ui_smart_SmartButton);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.ShopCarousselBuilding"] = com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding;
com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding.__name__ = ["com","isartdigital","perle","ui","popin","shop","ShopCarousselBuilding"];
com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding.__super__ = com_isartdigital_perle_ui_popin_shop_ShopCaroussel;
com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding.prototype = $extend(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.prototype,{
	getSpawnersAssetNames: function() {
		return ["Shop_Item_Unlocked_1","Shop_Item_Unlocked_2","Shop_Item_Locked_1"];
	}
	,getNewCard: function(pCardToShow) {
		if(com_isartdigital_perle_game_managers_UnlockManager.checkIfUnlocked(pCardToShow)) return new com_isartdigital_perle_ui_popin_shop_CCUBuilding(); else return new com_isartdigital_perle_ui_popin_shop_CCLBuilding();
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding
});
var com_isartdigital_perle_ui_popin_shop_ShopCarousselResource = function() {
	com_isartdigital_perle_ui_popin_shop_ShopCaroussel.call(this,"Shop_" + "ResourcesTab_List");
	this.arrowLeft = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Arrow_Left_Wood") , com_isartdigital_utils_ui_smart_SmartButton);
	this.arrowRight = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Arrow_Right_Stone") , com_isartdigital_utils_ui_smart_SmartButton);
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.ShopCarousselResource"] = com_isartdigital_perle_ui_popin_shop_ShopCarousselResource;
com_isartdigital_perle_ui_popin_shop_ShopCarousselResource.__name__ = ["com","isartdigital","perle","ui","popin","shop","ShopCarousselResource"];
com_isartdigital_perle_ui_popin_shop_ShopCarousselResource.__super__ = com_isartdigital_perle_ui_popin_shop_ShopCaroussel;
com_isartdigital_perle_ui_popin_shop_ShopCarousselResource.prototype = $extend(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.prototype,{
	getSpawnersAssetNames: function() {
		return ["Shop_Pack_1","Shop_Pack_2","Shop_Pack_3","Shop_Pack_4","Shop_Pack_5","Shop_Pack_6"];
	}
	,getNewCard: function(pCardToShow) {
		return new com_isartdigital_perle_ui_popin_shop_CCUResource();
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_ShopCarousselResource
});
var com_isartdigital_perle_ui_popin_shop_ShopTab = { __ename__ : true, __constructs__ : ["Building","Interns","Deco","Resources","Currencies","Bundle"] };
com_isartdigital_perle_ui_popin_shop_ShopTab.Building = ["Building",0];
com_isartdigital_perle_ui_popin_shop_ShopTab.Building.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Building.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
com_isartdigital_perle_ui_popin_shop_ShopTab.Interns = ["Interns",1];
com_isartdigital_perle_ui_popin_shop_ShopTab.Interns.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Interns.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
com_isartdigital_perle_ui_popin_shop_ShopTab.Deco = ["Deco",2];
com_isartdigital_perle_ui_popin_shop_ShopTab.Deco.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Deco.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
com_isartdigital_perle_ui_popin_shop_ShopTab.Resources = ["Resources",3];
com_isartdigital_perle_ui_popin_shop_ShopTab.Resources.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Resources.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
com_isartdigital_perle_ui_popin_shop_ShopTab.Currencies = ["Currencies",4];
com_isartdigital_perle_ui_popin_shop_ShopTab.Currencies.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Currencies.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
com_isartdigital_perle_ui_popin_shop_ShopTab.Bundle = ["Bundle",5];
com_isartdigital_perle_ui_popin_shop_ShopTab.Bundle.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopTab.Bundle.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopTab;
var com_isartdigital_perle_ui_popin_shop_ShopBar = { __ename__ : true, __constructs__ : ["Soft","Hard","Marble","Wood"] };
com_isartdigital_perle_ui_popin_shop_ShopBar.Soft = ["Soft",0];
com_isartdigital_perle_ui_popin_shop_ShopBar.Soft.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopBar.Soft.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopBar;
com_isartdigital_perle_ui_popin_shop_ShopBar.Hard = ["Hard",1];
com_isartdigital_perle_ui_popin_shop_ShopBar.Hard.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopBar.Hard.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopBar;
com_isartdigital_perle_ui_popin_shop_ShopBar.Marble = ["Marble",2];
com_isartdigital_perle_ui_popin_shop_ShopBar.Marble.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopBar.Marble.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopBar;
com_isartdigital_perle_ui_popin_shop_ShopBar.Wood = ["Wood",3];
com_isartdigital_perle_ui_popin_shop_ShopBar.Wood.toString = $estr;
com_isartdigital_perle_ui_popin_shop_ShopBar.Wood.__enum__ = com_isartdigital_perle_ui_popin_shop_ShopBar;
var com_isartdigital_perle_ui_popin_shop_ShopPopin = function() {
	this.set_modal(false);
	com_isartdigital_utils_ui_smart_SmartPopin.call(this,"Shop_" + "Building");
	this.tabs = new haxe_ds_EnumValueMap();
	this.bars = new haxe_ds_EnumValueMap();
	this.initCarousselPos("Item_List_Spawner");
	var lSC;
	lSC = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Player_SC") , com_isartdigital_utils_ui_smart_SmartComponent);
	var lSCtext;
	lSCtext = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(lSC,"bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	lSCtext.set_text("" + com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.soft));
	var lHC;
	lHC = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Player_HC") , com_isartdigital_utils_ui_smart_SmartComponent);
	var lHCtext;
	lHCtext = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(lHC,"bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	lHCtext.set_text("" + com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.hard));
	var lmarbre;
	lmarbre = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Player_Marbre") , com_isartdigital_utils_ui_smart_SmartComponent);
	var lmarbretext;
	lmarbretext = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(lmarbre,"bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	lmarbretext.set_text("" + com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromHell));
	var lwood;
	lwood = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Player_Bois") , com_isartdigital_utils_ui_smart_SmartComponent);
	var lwoodtext;
	lwoodtext = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(lwood,"bar_txt") , com_isartdigital_utils_ui_smart_TextSprite);
	lwoodtext.set_text("" + com_isartdigital_perle_game_managers_ResourcesManager.getTotalForType(com_isartdigital_perle_game_managers_GeneratorType.buildResourceFromParadise));
	this.btnExit = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Shop_" + "Close_Button") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnPurgatory = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Purgatory_Button") , com_isartdigital_utils_ui_smart_SmartButton);
	this.btnInterns = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Interns_Button") , com_isartdigital_utils_ui_smart_SmartButton);
	this.addButton();
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnExit,$bind(this,this.onClickExit));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnPurgatory,$bind(this,this.onClickPurgatory));
	com_isartdigital_perle_utils_Interactive.addListenerClick(this.btnInterns,$bind(this,this.onClickInterns));
};
$hxClasses["com.isartdigital.perle.ui.popin.shop.ShopPopin"] = com_isartdigital_perle_ui_popin_shop_ShopPopin;
com_isartdigital_perle_ui_popin_shop_ShopPopin.__name__ = ["com","isartdigital","perle","ui","popin","shop","ShopPopin"];
com_isartdigital_perle_ui_popin_shop_ShopPopin.getInstance = function() {
	if(com_isartdigital_perle_ui_popin_shop_ShopPopin.instance == null) com_isartdigital_perle_ui_popin_shop_ShopPopin.instance = new com_isartdigital_perle_ui_popin_shop_ShopPopin();
	return com_isartdigital_perle_ui_popin_shop_ShopPopin.instance;
};
com_isartdigital_perle_ui_popin_shop_ShopPopin.__super__ = com_isartdigital_utils_ui_smart_SmartPopin;
com_isartdigital_perle_ui_popin_shop_ShopPopin.prototype = $extend(com_isartdigital_utils_ui_smart_SmartPopin.prototype,{
	addButton: function() {
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab = [];
		var tabBuilding;
		tabBuilding = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Onglet_Building") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[0] = [];
		var tabDeco;
		tabDeco = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Onglet_Deco") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[1] = [];
		var tabInterns;
		tabInterns = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Onglet_Interns") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[2] = [];
		var tabCurrencies;
		tabCurrencies = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Onglet_Currencies") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[3] = [];
		var tabRessources;
		tabRessources = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Onglet_Ressources") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[4] = [];
		this.buttonOpenBundle = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,"Bundles_Button") , com_isartdigital_utils_ui_smart_SmartComponent);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonOpenBundle,$bind(this,this.onClickOpenBundle));
		this.buttonBuilding1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabBuilding,"Current") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonBuilding1,$bind(this,this.onClickOpenBuldings));
		this.buttonBuilding2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabBuilding,"Layer 1") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonBuilding2,$bind(this,this.onClickOpenBuldings));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[0].push(this.buttonBuilding1);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[0].push(this.buttonBuilding2);
		this.buttonDeco1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabDeco,"Current") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonDeco1,$bind(this,this.onClickOpenDecorations));
		this.buttonDeco2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabDeco,"Layer 1") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonDeco2,$bind(this,this.onClickOpenDecorations));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[1].push(this.buttonDeco1);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[1].push(this.buttonDeco2);
		this.buttonIntern1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabInterns,"Current") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonIntern1,$bind(this,this.onClickOpenIntern));
		this.buttonIntern2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabInterns,"Layer 1") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonIntern2,$bind(this,this.onClickOpenIntern));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[2].push(this.buttonIntern1);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[2].push(this.buttonIntern2);
		this.buttonCurrencies1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabCurrencies,"Current") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonCurrencies1,$bind(this,this.onClickOpenCurencies));
		this.buttonCurrencies2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabCurrencies,"Layer 1") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonCurrencies2,$bind(this,this.onClickOpenCurencies));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[3].push(this.buttonCurrencies1);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[3].push(this.buttonCurrencies2);
		this.buttonRessources1 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabRessources,"Current") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonRessources1,$bind(this,this.onClickOpenResource));
		this.buttonRessources2 = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(tabRessources,"Layer 1") , com_isartdigital_utils_ui_smart_SmartButton);
		com_isartdigital_perle_utils_Interactive.addListenerClick(this.buttonRessources2,$bind(this,this.onClickOpenResource));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[4].push(this.buttonRessources1);
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[4].push(this.buttonRessources2);
	}
	,switchButtons: function() {
		var _g1 = 0;
		var _g = com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab.length;
		while(_g1 < _g) {
			var i = _g1++;
			com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[i][0].visible = false;
		}
	}
	,setButtons: function(pNumber,pBundleOn) {
		this.switchButtons();
		if(pBundleOn) return;
		com_isartdigital_perle_ui_popin_shop_ShopPopin.buttonTab[pNumber][0].visible = true;
	}
	,init: function(pTab) {
		this.checkOfOngletToOpen(pTab);
	}
	,checkOfOngletToOpen: function(pTab) {
		switch(pTab[1]) {
		case 0:
			this.onClickOpenBuldings();
			break;
		case 2:
			this.onClickOpenDecorations();
			break;
		case 1:
			this.onClickOpenIntern();
			break;
		case 3:
			this.onClickOpenResource();
			break;
		case 4:
			this.onClickOpenCurencies();
			break;
		case 5:
			this.onClickOpenBundle();
			break;
		}
	}
	,addCaroussel: function(pTab) {
		if(this.caroussel != null) this.caroussel.destroy();
		if(pTab == com_isartdigital_perle_ui_popin_shop_ShopTab.Building) this.caroussel = new com_isartdigital_perle_ui_popin_shop_ShopCarousselBuilding(); else if(pTab == com_isartdigital_perle_ui_popin_shop_ShopTab.Resources) this.caroussel = new com_isartdigital_perle_ui_popin_shop_ShopCarousselResource();
		this.caroussel.init(this.carousselPos);
		this.addChild(this.caroussel);
		this.caroussel.start();
	}
	,removeCaroussel: function() {
		this.removeChild(this.caroussel);
	}
	,initCarousselPos: function(pAssetName) {
		this.carousselSpawner = js_Boot.__cast(com_isartdigital_perle_ui_SmartCheck.getChildByName(this,pAssetName) , com_isartdigital_utils_ui_smart_UISprite);
		this.carousselPos = new PIXI.Point();
		this.carousselPos.copy(this.carousselSpawner.position);
		this.removeChild(this.carousselSpawner);
		this.carousselSpawner.destroy();
	}
	,onClickOpenBuldings: function() {
		this.setButtons(0);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.buildingNameList);
	}
	,onClickOpenDecorations: function() {
		this.setButtons(1);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.decoNameList);
	}
	,onClickOpenIntern: function() {
		this.setButtons(2);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.internsNameList);
	}
	,onClickOpenCurencies: function() {
		this.setButtons(3);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Resources);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.currencieNameList);
	}
	,onClickOpenResource: function() {
		this.setButtons(4);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Resources);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.resourcesNameList);
	}
	,onClickOpenBundle: function() {
		this.setButtons(0,true);
		this.addCaroussel(com_isartdigital_perle_ui_popin_shop_ShopTab.Building);
		this.caroussel.changeCardsToShow(com_isartdigital_perle_ui_popin_shop_ShopCaroussel.bundleNameList);
	}
	,onClickExit: function() {
		com_isartdigital_perle_ui_hud_Hud.getInstance().show();
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
	}
	,onClickPurgatory: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().closeCurrentPopin();
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_TribunalPopin.getInstance());
	}
	,onClickInterns: function() {
		js_Browser.alert("Work in progress : Special Feature");
	}
	,onClickFakeBuySoft: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.getInstance());
	}
	,onClickFakeBuyHard: function() {
		com_isartdigital_perle_ui_UIManager.getInstance().openPopin(com_isartdigital_perle_ui_popin_shop_ConfirmBuyCurrencie.getInstance());
	}
	,destroy: function() {
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnExit,$bind(this,this.onClickExit));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnPurgatory,$bind(this,this.onClickPurgatory));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.btnInterns,$bind(this,this.onClickInterns));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonOpenBundle,$bind(this,this.onClickOpenBundle));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonBuilding1,$bind(this,this.onClickOpenBuldings));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonBuilding2,$bind(this,this.onClickOpenBuldings));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonDeco1,$bind(this,this.onClickOpenDecorations));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonDeco2,$bind(this,this.onClickOpenDecorations));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonIntern1,$bind(this,this.onClickOpenIntern));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonIntern2,$bind(this,this.onClickOpenIntern));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonCurrencies1,$bind(this,this.onClickOpenCurencies));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonCurrencies2,$bind(this,this.onClickOpenCurencies));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonRessources1,$bind(this,this.onClickOpenResource));
		com_isartdigital_perle_utils_Interactive.removeListenerClick(this.buttonRessources2,$bind(this,this.onClickOpenResource));
		com_isartdigital_perle_ui_popin_shop_ShopPopin.instance = null;
		com_isartdigital_utils_ui_smart_SmartPopin.prototype.destroy.call(this);
	}
	,__class__: com_isartdigital_perle_ui_popin_shop_ShopPopin
});
var com_isartdigital_perle_utils_Interactive = function() {
};
$hxClasses["com.isartdigital.perle.utils.Interactive"] = com_isartdigital_perle_utils_Interactive;
com_isartdigital_perle_utils_Interactive.__name__ = ["com","isartdigital","perle","utils","Interactive"];
<<<<<<< HEAD:bin/ui.js
com_isartdigital_perle_utils_Interactive.addListenerClick = function(pElement,pCallBack,pContext,pCallback2) {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") {
		pElement.addListener("click",pCallBack,pContext);
		if(pCallback2 != null) {
			pElement.addListener("mousedown",pCallback2);
			pElement.addListener("mouseout",pCallback2);
			pElement.addListener("mouseover",pCallback2);
			pElement.addListener("mouseup",pCallback2);
			pElement.addListener("mouseupoutside",pCallback2);
		}
	} else {
		pElement.addListener("tap",pCallBack,pContext);
	}
};
com_isartdigital_perle_utils_Interactive.removeListenerClick = function(pElement,pCallBack,pOnce,pCallback2) {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") {
		pElement.removeListener("click",pCallBack,pOnce);
		if(pCallback2 != null) {
			pElement.removeListener("mousedown",pCallback2);
			pElement.removeListener("mouseout",pCallback2);
			pElement.removeListener("mouseover",pCallback2);
			pElement.removeListener("mouseup",pCallback2);
			pElement.removeListener("mouseupoutside",pCallback2);
		}
	} else {
		pElement.removeListener("tap",pCallBack,pOnce);
	}
=======
com_isartdigital_perle_utils_Interactive.addListenerClick = function(pElement,pCallBack,pContext) {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") pElement.addListener("click",pCallBack,pContext); else pElement.addListener("tap",pCallBack,pContext);
};
com_isartdigital_perle_utils_Interactive.removeListenerClick = function(pElement,pCallBack,pOnce) {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") pElement.removeListener("click",pCallBack,pOnce); else pElement.removeListener("tap",pCallBack,pOnce);
>>>>>>> btn accelerate working:bin/Builder.js
};
com_isartdigital_perle_utils_Interactive.prototype = {
	__class__: com_isartdigital_perle_utils_Interactive
};
var com_isartdigital_services_facebook_Facebook = function() { };
$hxClasses["com.isartdigital.services.facebook.Facebook"] = com_isartdigital_services_facebook_Facebook;
com_isartdigital_services_facebook_Facebook.__name__ = ["com","isartdigital","services","facebook","Facebook"];
com_isartdigital_services_facebook_Facebook.init = function() {
	FB.init({ appId : com_isartdigital_services_facebook_Facebook.appId, xfbml : true, version : "v2.8", cookie : true});
	FB.getLoginStatus(com_isartdigital_services_facebook_Facebook.getLoginStatus);
};
com_isartdigital_services_facebook_Facebook.load = function(pAppId,pPermissions) {
	com_isartdigital_services_facebook_Facebook.appId = pAppId;
	window.fbAsyncInit = com_isartdigital_services_facebook_Facebook.init;
	var lDoc = window.document;
	var lScript = "script";
	var lID = "facebook-jssdk";
	var lJs;
	var lFjs = lDoc.getElementsByTagName(lScript)[0];
	if(lDoc.getElementById(com_isartdigital_services_facebook_Facebook.appId) != null) return;
	if(pPermissions != null) com_isartdigital_services_facebook_Facebook.permissions = pPermissions;
	lJs = js_Boot.__cast(lDoc.createElement(lScript) , HTMLScriptElement);
	lJs.id = lID;
	lJs.src = "//connect.facebook.net/en_US/sdk.js";
	lFjs.parentNode.insertBefore(lJs,lFjs);
};
com_isartdigital_services_facebook_Facebook.getLoginStatus = function(pResponse) {
	if(pResponse.status == "connected") {
		com_isartdigital_services_facebook_Facebook.authResponse = pResponse.authResponse;
		com_isartdigital_services_facebook_Facebook.token = com_isartdigital_services_facebook_Facebook.authResponse.accessToken;
		com_isartdigital_services_facebook_Facebook.uid = com_isartdigital_services_facebook_Facebook.authResponse.userID;
		com_isartdigital_services_facebook_Facebook.onLogin();
	} else if(com_isartdigital_services_facebook_Facebook.isFirstAttempt || com_isartdigital_services_facebook_Facebook.onCancelLogin == null) {
		com_isartdigital_services_facebook_Facebook.isFirstAttempt = false;
		FB.login(com_isartdigital_services_facebook_Facebook.getLoginStatus,com_isartdigital_services_facebook_Facebook.permissions);
	} else com_isartdigital_services_facebook_Facebook.onCancelLogin(pResponse);
};
com_isartdigital_services_facebook_Facebook.api = function(pPath,pMethod,pParams,pCallBack) {
	FB.api(pPath,pMethod,pParams,pCallBack);
};
com_isartdigital_services_facebook_Facebook.ui = function(pParams,pCallBack) {
	FB.ui(pParams,pCallBack);
};
var com_isartdigital_utils_events_EventType = function() { };
$hxClasses["com.isartdigital.utils.events.EventType"] = com_isartdigital_utils_events_EventType;
com_isartdigital_utils_events_EventType.__name__ = ["com","isartdigital","utils","events","EventType"];
var com_isartdigital_services_facebook_events_FacebookEventType = function() { };
$hxClasses["com.isartdigital.services.facebook.events.FacebookEventType"] = com_isartdigital_services_facebook_events_FacebookEventType;
com_isartdigital_services_facebook_events_FacebookEventType.__name__ = ["com","isartdigital","services","facebook","events","FacebookEventType"];
com_isartdigital_services_facebook_events_FacebookEventType.__super__ = com_isartdigital_utils_events_EventType;
com_isartdigital_services_facebook_events_FacebookEventType.prototype = $extend(com_isartdigital_utils_events_EventType.prototype,{
	__class__: com_isartdigital_services_facebook_events_FacebookEventType
});
var com_isartdigital_utils_Config = function() { };
$hxClasses["com.isartdigital.utils.Config"] = com_isartdigital_utils_Config;
com_isartdigital_utils_Config.__name__ = ["com","isartdigital","utils","Config"];
com_isartdigital_utils_Config.init = function(pConfig) {
	var _g = 0;
	var _g1 = Reflect.fields(pConfig);
	while(_g < _g1.length) {
		var i = _g1[_g];
		++_g;
		Reflect.setField(com_isartdigital_utils_Config._data,i,Reflect.field(pConfig,i));
	}
	if(com_isartdigital_utils_Config._data.version == null || com_isartdigital_utils_Config._data.version == "") com_isartdigital_utils_Config._data.version = "0.0.0";
	if(com_isartdigital_utils_Config._data.gameName == null) com_isartdigital_utils_Config._data.gameName = "";
	var lStorage = js_Browser.getLocalStorage();
	var lVersion;
	if(lStorage.getItem(com_isartdigital_utils_Config.get_gameName()) == null) lVersion = null; else lVersion = JSON.parse(lStorage.getItem(com_isartdigital_utils_Config.get_gameName())).version;
	if(lVersion != null) com_isartdigital_utils_Config.cache = com_isartdigital_utils_Config.get_version() == lVersion;
	lStorage.setItem(com_isartdigital_utils_Config.get_gameName(),JSON.stringify({ version : com_isartdigital_utils_Config.get_version()}));
	if(com_isartdigital_utils_Config._data.language == null || com_isartdigital_utils_Config._data.language == "") {
		var _this = window.navigator.language;
		com_isartdigital_utils_Config._data.language = HxOverrides.substr(_this,0,2);
	}
	if(com_isartdigital_utils_Config._data.languages == "" || com_isartdigital_utils_Config._data.languages == []) com_isartdigital_utils_Config._data.languages.push(com_isartdigital_utils_Config._data.language);
	if(com_isartdigital_utils_Config._data.debug == null || com_isartdigital_utils_Config._data.debug == "") com_isartdigital_utils_Config._data.debug = false;
	if(com_isartdigital_utils_Config._data.fps == null || com_isartdigital_utils_Config._data.fps == "") com_isartdigital_utils_Config._data.fps = false;
	if(com_isartdigital_utils_Config._data.qrcode == null || com_isartdigital_utils_Config._data.qrcode == "") com_isartdigital_utils_Config._data.qrcode = false;
	if(com_isartdigital_utils_Config._data.langPath == null) com_isartdigital_utils_Config._data.langPath = "";
	if(com_isartdigital_utils_Config._data.txtsPath == null) com_isartdigital_utils_Config._data.txtsPath = "";
	if(com_isartdigital_utils_Config._data.assetsPath == null) com_isartdigital_utils_Config._data.assetsPath = "";
	if(com_isartdigital_utils_Config._data.fontsPath == null) com_isartdigital_utils_Config._data.fontsPath = "";
	if(com_isartdigital_utils_Config._data.soundsPath == null) com_isartdigital_utils_Config._data.soundsPath = "";
};
com_isartdigital_utils_Config.url = function(pPath) {
	return pPath + "?" + com_isartdigital_utils_Config.get_version();
};
com_isartdigital_utils_Config.get_data = function() {
	return com_isartdigital_utils_Config._data;
};
com_isartdigital_utils_Config.get_gameName = function() {
	return com_isartdigital_utils_Config._data.gameName;
};
com_isartdigital_utils_Config.get_version = function() {
	return com_isartdigital_utils_Config._data.version;
};
com_isartdigital_utils_Config.get_language = function() {
	return com_isartdigital_utils_Config.get_data().language;
};
com_isartdigital_utils_Config.get_languages = function() {
	return com_isartdigital_utils_Config.get_data().languages;
};
com_isartdigital_utils_Config.get_debug = function() {
	return com_isartdigital_utils_Config.get_data().debug;
};
com_isartdigital_utils_Config.get_fps = function() {
	return com_isartdigital_utils_Config.get_data().fps;
};
com_isartdigital_utils_Config.get_qrcode = function() {
	return com_isartdigital_utils_Config.get_data().qrcode;
};
com_isartdigital_utils_Config.get_langPath = function() {
	return com_isartdigital_utils_Config._data.langPath;
};
com_isartdigital_utils_Config.get_txtsPath = function() {
	return com_isartdigital_utils_Config._data.txtsPath;
};
com_isartdigital_utils_Config.get_assetsPath = function() {
	return com_isartdigital_utils_Config._data.assetsPath;
};
com_isartdigital_utils_Config.get_fontsPath = function() {
	return com_isartdigital_utils_Config._data.fontsPath;
};
com_isartdigital_utils_Config.get_soundsPath = function() {
	return com_isartdigital_utils_Config._data.soundsPath;
};
var com_isartdigital_utils_Debug = function() {
};
$hxClasses["com.isartdigital.utils.Debug"] = com_isartdigital_utils_Debug;
com_isartdigital_utils_Debug.__name__ = ["com","isartdigital","utils","Debug"];
com_isartdigital_utils_Debug.getInstance = function() {
	if(com_isartdigital_utils_Debug.instance == null) com_isartdigital_utils_Debug.instance = new com_isartdigital_utils_Debug();
	return com_isartdigital_utils_Debug.instance;
};
com_isartdigital_utils_Debug.error = function(pArg) {
	window.console.error(pArg);
};
com_isartdigital_utils_Debug.warn = function(pArg) {
	window.console.warn(pArg);
};
com_isartdigital_utils_Debug.table = function(pArg) {
	window.console.table(pArg);
};
com_isartdigital_utils_Debug.info = function(pArg) {
	window.console.info(pArg);
};
com_isartdigital_utils_Debug.prototype = {
	init: function() {
		if(com_isartdigital_utils_Config.get_fps()) this.fps = new Perf("TL");
		if(com_isartdigital_utils_Config.get_qrcode() && !com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) {
			var lQr = new Image();
			lQr.style.position = "absolute";
			lQr.style.right = "0px";
			lQr.style.bottom = "0px";
			var lSize = Std["int"](0.35 * com_isartdigital_utils_system_DeviceCapabilities.getSizeFactor());
			lQr.src = "https://chart.googleapis.com/chart?chs=" + lSize + "x" + lSize + "&cht=qr&chl=" + window.location.href + "&choe=UTF-8";
			window.document.body.appendChild(lQr);
		}
	}
	,destroy: function() {
	}
	,__class__: com_isartdigital_utils_Debug
};
var com_isartdigital_utils_events_KeyboardEventType = function() { };
$hxClasses["com.isartdigital.utils.events.KeyboardEventType"] = com_isartdigital_utils_events_KeyboardEventType;
com_isartdigital_utils_events_KeyboardEventType.__name__ = ["com","isartdigital","utils","events","KeyboardEventType"];
com_isartdigital_utils_events_KeyboardEventType.__super__ = com_isartdigital_utils_events_EventType;
com_isartdigital_utils_events_KeyboardEventType.prototype = $extend(com_isartdigital_utils_events_EventType.prototype,{
	__class__: com_isartdigital_utils_events_KeyboardEventType
});
var com_isartdigital_utils_events_LoadEventType = function() { };
$hxClasses["com.isartdigital.utils.events.LoadEventType"] = com_isartdigital_utils_events_LoadEventType;
com_isartdigital_utils_events_LoadEventType.__name__ = ["com","isartdigital","utils","events","LoadEventType"];
com_isartdigital_utils_events_LoadEventType.__super__ = com_isartdigital_utils_events_EventType;
com_isartdigital_utils_events_LoadEventType.prototype = $extend(com_isartdigital_utils_events_EventType.prototype,{
	__class__: com_isartdigital_utils_events_LoadEventType
});
var com_isartdigital_utils_events_MouseEventType = function() { };
$hxClasses["com.isartdigital.utils.events.MouseEventType"] = com_isartdigital_utils_events_MouseEventType;
com_isartdigital_utils_events_MouseEventType.__name__ = ["com","isartdigital","utils","events","MouseEventType"];
com_isartdigital_utils_events_MouseEventType.__super__ = com_isartdigital_utils_events_EventType;
com_isartdigital_utils_events_MouseEventType.prototype = $extend(com_isartdigital_utils_events_EventType.prototype,{
	__class__: com_isartdigital_utils_events_MouseEventType
});
var com_isartdigital_utils_events_TouchEventType = function() { };
$hxClasses["com.isartdigital.utils.events.TouchEventType"] = com_isartdigital_utils_events_TouchEventType;
com_isartdigital_utils_events_TouchEventType.__name__ = ["com","isartdigital","utils","events","TouchEventType"];
com_isartdigital_utils_events_TouchEventType.__super__ = com_isartdigital_utils_events_EventType;
com_isartdigital_utils_events_TouchEventType.prototype = $extend(com_isartdigital_utils_events_EventType.prototype,{
	__class__: com_isartdigital_utils_events_TouchEventType
});
var com_isartdigital_utils_game_BoxType = { __ename__ : true, __constructs__ : ["NONE","SIMPLE","MULTIPLE","SELF"] };
com_isartdigital_utils_game_BoxType.NONE = ["NONE",0];
com_isartdigital_utils_game_BoxType.NONE.toString = $estr;
com_isartdigital_utils_game_BoxType.NONE.__enum__ = com_isartdigital_utils_game_BoxType;
com_isartdigital_utils_game_BoxType.SIMPLE = ["SIMPLE",1];
com_isartdigital_utils_game_BoxType.SIMPLE.toString = $estr;
com_isartdigital_utils_game_BoxType.SIMPLE.__enum__ = com_isartdigital_utils_game_BoxType;
com_isartdigital_utils_game_BoxType.MULTIPLE = ["MULTIPLE",2];
com_isartdigital_utils_game_BoxType.MULTIPLE.toString = $estr;
com_isartdigital_utils_game_BoxType.MULTIPLE.__enum__ = com_isartdigital_utils_game_BoxType;
com_isartdigital_utils_game_BoxType.SELF = ["SELF",3];
com_isartdigital_utils_game_BoxType.SELF.toString = $estr;
com_isartdigital_utils_game_BoxType.SELF.__enum__ = com_isartdigital_utils_game_BoxType;
var com_isartdigital_utils_game_CollisionManager = function() {
};
$hxClasses["com.isartdigital.utils.game.CollisionManager"] = com_isartdigital_utils_game_CollisionManager;
com_isartdigital_utils_game_CollisionManager.__name__ = ["com","isartdigital","utils","game","CollisionManager"];
com_isartdigital_utils_game_CollisionManager.hitTestObject = function(pObjectA,pObjectB) {
	return com_isartdigital_utils_game_CollisionManager.getIntersection(pObjectA.getBounds(),pObjectB.getBounds());
};
com_isartdigital_utils_game_CollisionManager.hitTestPoint = function(pItem,pGlobalPoint) {
	var lPoint = pItem.toLocal(pGlobalPoint);
	var x = lPoint.x;
	var y = lPoint.y;
	if(pItem.hitArea != null && pItem.hitArea.contains != null) return pItem.hitArea.contains(x,y); else if(js_Boot.__instanceof(pItem,PIXI.Sprite)) {
		var lSprite;
		lSprite = js_Boot.__cast(pItem , PIXI.Sprite);
		var lWidth = lSprite.texture.frame.width;
		var lHeight = lSprite.texture.frame.height;
		var lX1 = -lWidth * lSprite.anchor.x;
		var lY1;
		if(x > lX1 && x < lX1 + lWidth) {
			lY1 = -lHeight * lSprite.anchor.y;
			if(y > lY1 && y < lY1 + lHeight) return true;
		}
	} else if(js_Boot.__instanceof(pItem,PIXI.Graphics)) {
		var lGraphicsData = pItem.graphicsData;
		var _g1 = 0;
		var _g = lGraphicsData.length;
		while(_g1 < _g) {
			var i = _g1++;
			var lData = lGraphicsData[i];
			if(!lData.fill) continue;
			if(lData.shape != null && lData.shape.contains(x,y)) return true;
		}
	} else if(js_Boot.__instanceof(pItem,PIXI.Container)) {
		var lContainer;
		lContainer = js_Boot.__cast(pItem , PIXI.Container);
		var lLength = lContainer.children.length;
		var _g2 = 0;
		while(_g2 < lLength) {
			var i1 = _g2++;
			if(com_isartdigital_utils_game_CollisionManager.hitTestPoint(lContainer.children[i1],pGlobalPoint)) return true;
		}
	}
	return false;
};
com_isartdigital_utils_game_CollisionManager.hasCollision = function(pHitBoxA,pHitBoxB,pPointsA,pPointsB) {
	if(pHitBoxA == null || pHitBoxB == null) return false;
	if(!com_isartdigital_utils_game_CollisionManager.hitTestObject(pHitBoxA,pHitBoxB)) return false;
	if(pPointsA == null && pPointsB == null) return true;
	if(pPointsA != null) return com_isartdigital_utils_game_CollisionManager.testPoints(pPointsA,pHitBoxB);
	if(pPointsB != null) return com_isartdigital_utils_game_CollisionManager.testPoints(pPointsB,pHitBoxA);
	return false;
};
com_isartdigital_utils_game_CollisionManager.getIntersection = function(pRectA,pRectB) {
	return !(pRectB.x > pRectA.x + pRectA.width || pRectB.x + pRectB.width < pRectA.x || pRectB.y > pRectA.y + pRectA.height || pRectB.y + pRectB.height < pRectA.y);
};
com_isartdigital_utils_game_CollisionManager.testPoints = function(pHitPoints,pHitBox) {
	var lLength = pHitPoints.length;
	var _g = 0;
	while(_g < lLength) {
		var i = _g++;
		if(com_isartdigital_utils_game_CollisionManager.hitTestPoint(pHitBox,pHitPoints[i])) return true;
	}
	return false;
};
com_isartdigital_utils_game_CollisionManager.prototype = {
	__class__: com_isartdigital_utils_game_CollisionManager
};
var com_isartdigital_utils_game_GameStage = function() {
	this._safeZone = new PIXI.Rectangle(0,0,2048,1366);
	this._scaleMode = com_isartdigital_utils_game_GameStageScale.SHOW_ALL;
	this._alignMode = com_isartdigital_utils_game_GameStageAlign.CENTER;
	PIXI.Container.call(this);
	this.gameContainer = new PIXI.Container();
	this.addChild(this.gameContainer);
	this.buildContainer = new PIXI.Container();
	this.gameContainer.addChild(this.buildContainer);
	this.screensContainer = new PIXI.Container();
	this.addChild(this.screensContainer);
	this.hudContainer = new PIXI.Container();
	this.addChild(this.hudContainer);
	this.popinsContainer = new PIXI.Container();
	this.addChild(this.popinsContainer);
};
$hxClasses["com.isartdigital.utils.game.GameStage"] = com_isartdigital_utils_game_GameStage;
com_isartdigital_utils_game_GameStage.__name__ = ["com","isartdigital","utils","game","GameStage"];
com_isartdigital_utils_game_GameStage.getInstance = function() {
	if(com_isartdigital_utils_game_GameStage.instance == null) com_isartdigital_utils_game_GameStage.instance = new com_isartdigital_utils_game_GameStage();
	return com_isartdigital_utils_game_GameStage.instance;
};
com_isartdigital_utils_game_GameStage.__super__ = PIXI.Container;
com_isartdigital_utils_game_GameStage.prototype = $extend(PIXI.Container.prototype,{
	init: function(pRender,pSafeZoneWidth,pSafeZoneHeight,pCenterGameContainer,pCenterScreensContainer,pCenterPopinContainer,pCenterHudContainer) {
		if(pCenterHudContainer == null) pCenterHudContainer = false;
		if(pCenterPopinContainer == null) pCenterPopinContainer = true;
		if(pCenterScreensContainer == null) pCenterScreensContainer = true;
		if(pCenterGameContainer == null) pCenterGameContainer = false;
		if(pSafeZoneHeight == null) pSafeZoneHeight = 2048;
		if(pSafeZoneWidth == null) pSafeZoneWidth = 2048;
		this._safeZone = new PIXI.Rectangle(0,0,_$UInt_UInt_$Impl_$.toFloat(pSafeZoneWidth),_$UInt_UInt_$Impl_$.toFloat(pSafeZoneHeight));
		if(pCenterGameContainer) {
			this.gameContainer.x = this.get_safeZone().width / 2;
			this.gameContainer.y = this.get_safeZone().height / 2;
		}
		if(pCenterScreensContainer) {
			this.screensContainer.x = this.get_safeZone().width / 2;
			this.screensContainer.y = this.get_safeZone().height / 2;
		}
		if(pCenterPopinContainer) {
			this.popinsContainer.x = this.get_safeZone().width / 2;
			this.popinsContainer.y = this.get_safeZone().height / 2;
		}
		if(pCenterHudContainer) {
			this.hudContainer.x = this.get_safeZone().width / 2;
			this.hudContainer.y = this.get_safeZone().height / 2;
		}
		this._render = pRender;
	}
	,resize: function() {
		var lWidth = com_isartdigital_utils_system_DeviceCapabilities.get_width();
		var lHeight = com_isartdigital_utils_system_DeviceCapabilities.get_height();
		var lRatio = Math.round(10000 * Math.min((function($this) {
			var $r;
			var b = $this.get_safeZone().width;
			$r = _$UInt_UInt_$Impl_$.toFloat(lWidth) / b;
			return $r;
		}(this)),(function($this) {
			var $r;
			var b1 = $this.get_safeZone().height;
			$r = _$UInt_UInt_$Impl_$.toFloat(lHeight) / b1;
			return $r;
		}(this)))) / 10000;
		if(this.get_scaleMode() == com_isartdigital_utils_game_GameStageScale.SHOW_ALL) this.scale.set(lRatio,lRatio); else this.scale.set(com_isartdigital_utils_system_DeviceCapabilities.textureRatio,com_isartdigital_utils_system_DeviceCapabilities.textureRatio);
		if(this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.LEFT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.TOP_LEFT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.BOTTOM_LEFT) this.x = 0; else if(this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.RIGHT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.TOP_RIGHT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.BOTTOM_RIGHT) {
			var b2 = this.get_safeZone().width * this.scale.x;
			this.x = _$UInt_UInt_$Impl_$.toFloat(lWidth) - b2;
		} else this.x = (function($this) {
			var $r;
			var b3 = $this.get_safeZone().width * $this.scale.x;
			$r = _$UInt_UInt_$Impl_$.toFloat(lWidth) - b3;
			return $r;
		}(this)) / 2;
		if(this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.TOP || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.TOP_LEFT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.TOP_RIGHT) this.y = 0; else if(this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.BOTTOM || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.BOTTOM_LEFT || this.get_alignMode() == com_isartdigital_utils_game_GameStageAlign.BOTTOM_RIGHT) {
			var b4 = this.get_safeZone().height * this.scale.y;
			this.y = _$UInt_UInt_$Impl_$.toFloat(lHeight) - b4;
		} else this.y = (function($this) {
			var $r;
			var b5 = $this.get_safeZone().height * $this.scale.y;
			$r = _$UInt_UInt_$Impl_$.toFloat(lHeight) - b5;
			return $r;
		}(this)) / 2;
		this.render();
		this.emit("resize",{ width : lWidth, height : lHeight});
	}
	,render: function() {
		if(this._render != null) this._render();
	}
	,get_alignMode: function() {
		return this._alignMode;
	}
	,set_alignMode: function(pAlign) {
		this._alignMode = pAlign;
		this.resize();
		return this._alignMode;
	}
	,get_scaleMode: function() {
		return this._scaleMode;
	}
	,set_scaleMode: function(pScale) {
		this._scaleMode = pScale;
		this.resize();
		return this._scaleMode;
	}
	,get_safeZone: function() {
		return this._safeZone;
	}
	,getGameContainer: function() {
		return this.gameContainer;
	}
	,getBuildContainer: function() {
		return this.buildContainer;
	}
	,getScreensContainer: function() {
		return this.screensContainer;
	}
	,getHudContainer: function() {
		return this.hudContainer;
	}
	,getPopinsContainer: function() {
		return this.popinsContainer;
	}
	,destroy: function() {
		com_isartdigital_utils_game_GameStage.instance = null;
		PIXI.Container.prototype.destroy.call(this,true);
	}
	,__class__: com_isartdigital_utils_game_GameStage
});
var com_isartdigital_utils_game_GameStageAlign = { __ename__ : true, __constructs__ : ["TOP","TOP_LEFT","TOP_RIGHT","CENTER","LEFT","RIGHT","BOTTOM","BOTTOM_LEFT","BOTTOM_RIGHT"] };
com_isartdigital_utils_game_GameStageAlign.TOP = ["TOP",0];
com_isartdigital_utils_game_GameStageAlign.TOP.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.TOP.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.TOP_LEFT = ["TOP_LEFT",1];
com_isartdigital_utils_game_GameStageAlign.TOP_LEFT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.TOP_LEFT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.TOP_RIGHT = ["TOP_RIGHT",2];
com_isartdigital_utils_game_GameStageAlign.TOP_RIGHT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.TOP_RIGHT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.CENTER = ["CENTER",3];
com_isartdigital_utils_game_GameStageAlign.CENTER.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.CENTER.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.LEFT = ["LEFT",4];
com_isartdigital_utils_game_GameStageAlign.LEFT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.LEFT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.RIGHT = ["RIGHT",5];
com_isartdigital_utils_game_GameStageAlign.RIGHT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.RIGHT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.BOTTOM = ["BOTTOM",6];
com_isartdigital_utils_game_GameStageAlign.BOTTOM.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.BOTTOM.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.BOTTOM_LEFT = ["BOTTOM_LEFT",7];
com_isartdigital_utils_game_GameStageAlign.BOTTOM_LEFT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.BOTTOM_LEFT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
com_isartdigital_utils_game_GameStageAlign.BOTTOM_RIGHT = ["BOTTOM_RIGHT",8];
com_isartdigital_utils_game_GameStageAlign.BOTTOM_RIGHT.toString = $estr;
com_isartdigital_utils_game_GameStageAlign.BOTTOM_RIGHT.__enum__ = com_isartdigital_utils_game_GameStageAlign;
var com_isartdigital_utils_game_GameStageScale = { __ename__ : true, __constructs__ : ["NO_SCALE","SHOW_ALL"] };
com_isartdigital_utils_game_GameStageScale.NO_SCALE = ["NO_SCALE",0];
com_isartdigital_utils_game_GameStageScale.NO_SCALE.toString = $estr;
com_isartdigital_utils_game_GameStageScale.NO_SCALE.__enum__ = com_isartdigital_utils_game_GameStageScale;
com_isartdigital_utils_game_GameStageScale.SHOW_ALL = ["SHOW_ALL",1];
com_isartdigital_utils_game_GameStageScale.SHOW_ALL.toString = $estr;
com_isartdigital_utils_game_GameStageScale.SHOW_ALL.__enum__ = com_isartdigital_utils_game_GameStageScale;
var com_isartdigital_utils_game_factory_AnimFactory = function() {
};
$hxClasses["com.isartdigital.utils.game.factory.AnimFactory"] = com_isartdigital_utils_game_factory_AnimFactory;
com_isartdigital_utils_game_factory_AnimFactory.__name__ = ["com","isartdigital","utils","game","factory","AnimFactory"];
com_isartdigital_utils_game_factory_AnimFactory.prototype = {
	getAnim: function() {
		return this.anim;
	}
	,create: function(pID) {
		return null;
	}
	,update: function(pId) {
	}
	,setFrame: function(pAutoPlay,pStart) {
		if(pStart == null) pStart = 0;
		if(pAutoPlay == null) pAutoPlay = true;
	}
	,__class__: com_isartdigital_utils_game_factory_AnimFactory
};
var com_isartdigital_utils_game_factory_FlumpMovieAnimFactory = function() {
	com_isartdigital_utils_game_factory_AnimFactory.call(this);
};
$hxClasses["com.isartdigital.utils.game.factory.FlumpMovieAnimFactory"] = com_isartdigital_utils_game_factory_FlumpMovieAnimFactory;
com_isartdigital_utils_game_factory_FlumpMovieAnimFactory.__name__ = ["com","isartdigital","utils","game","factory","FlumpMovieAnimFactory"];
com_isartdigital_utils_game_factory_FlumpMovieAnimFactory.__super__ = com_isartdigital_utils_game_factory_AnimFactory;
com_isartdigital_utils_game_factory_FlumpMovieAnimFactory.prototype = $extend(com_isartdigital_utils_game_factory_AnimFactory.prototype,{
	getAnim: function() {
		if(this.anim != null) {
			this.anim.parent.removeChild(this.anim);
			this.anim.destroy();
			this.anim = null;
		}
		return com_isartdigital_utils_game_factory_AnimFactory.prototype.getAnim.call(this);
	}
	,create: function(pID) {
		this.anim = new pixi_flump_Movie(pID);
		return this.anim;
	}
	,setFrame: function(pAutoPlay,pStart) {
		if(pStart == null) pStart = 0;
		if(pAutoPlay == null) pAutoPlay = true;
		var lAnim;
		lAnim = js_Boot.__cast(this.anim , pixi_flump_Movie);
		if(lAnim.get_totalFrames() > 1) {
			if(pAutoPlay) lAnim.gotoAndPlay(pStart); else lAnim.gotoAndStop(pStart);
		} else if(!pAutoPlay) lAnim.stop();
	}
	,__class__: com_isartdigital_utils_game_factory_FlumpMovieAnimFactory
});
var com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory = function() {
	com_isartdigital_utils_game_factory_AnimFactory.call(this);
};
$hxClasses["com.isartdigital.utils.game.factory.FlumpSpriteAnimFactory"] = com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory;
com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory.__name__ = ["com","isartdigital","utils","game","factory","FlumpSpriteAnimFactory"];
com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory.__super__ = com_isartdigital_utils_game_factory_AnimFactory;
com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory.prototype = $extend(com_isartdigital_utils_game_factory_AnimFactory.prototype,{
	getAnim: function() {
		if(this.anim != null) {
			this.anim.parent.removeChild(this.anim);
			this.anim.destroy();
			this.anim = null;
		}
		return com_isartdigital_utils_game_factory_AnimFactory.prototype.getAnim.call(this);
	}
	,create: function(pID) {
		this.anim = new pixi_flump_Sprite(pID);
		return this.anim;
	}
	,setFrame: function(pAutoPlay,pStart) {
		if(pStart == null) pStart = 0;
		if(pAutoPlay == null) pAutoPlay = true;
	}
	,__class__: com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory
});
var com_isartdigital_utils_loader_GameLoader = function() {
	this.soundsList = [];
	this.soundsSpecs = new haxe_ds_StringMap();
	PIXI.loaders.Loader.call(this);
	this.once("complete",$bind(this,this.onComplete));
};
$hxClasses["com.isartdigital.utils.loader.GameLoader"] = com_isartdigital_utils_loader_GameLoader;
com_isartdigital_utils_loader_GameLoader.__name__ = ["com","isartdigital","utils","loader","GameLoader"];
com_isartdigital_utils_loader_GameLoader.getContent = function(pFile) {
	var key = com_isartdigital_utils_Config.get_txtsPath() + pFile;
	return com_isartdigital_utils_loader_GameLoader.txtLoaded.get(key);
};
com_isartdigital_utils_loader_GameLoader.__super__ = PIXI.loaders.Loader;
com_isartdigital_utils_loader_GameLoader.prototype = $extend(PIXI.loaders.Loader.prototype,{
	addTxtFile: function(pUrl) {
		var lUrl = com_isartdigital_utils_Config.get_txtsPath() + pUrl;
		this.add(com_isartdigital_utils_Config.url(lUrl));
	}
	,addAssetFile: function(pUrl) {
		var lUrl = com_isartdigital_utils_Config.get_assetsPath() + pUrl;
		this.add(com_isartdigital_utils_Config.url(lUrl));
	}
	,addSoundFile: function(pUrl) {
		var lUrl = com_isartdigital_utils_Config.get_soundsPath() + pUrl;
		this.soundsList.push(lUrl);
		this.add(com_isartdigital_utils_Config.url(lUrl));
	}
	,addFontFile: function(pUrl) {
		if(com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) return;
		var lUrl = com_isartdigital_utils_Config.get_fontsPath() + pUrl;
		this.add(com_isartdigital_utils_Config.url(lUrl));
	}
	,parseData: function(pResource,pNext) {
		console.log(pResource.url + " loaded");
		var lUrl = pResource.url.split("?")[0];
		if(lUrl.indexOf(".css") > 0) {
			var lData = pResource.data.split(";");
			var lFamilies = [];
			var lReg = new EReg("font-family:\\s?(.*)","");
			var _g1 = 0;
			var _g = lData.length;
			while(_g1 < _g) {
				var i = _g1++;
				if(lReg.match(lData[i])) lFamilies.push(lReg.matched(1));
			}
			var lWebFontConfig = { custom : { families : lFamilies, urls : [com_isartdigital_utils_Config.get_fontsPath() + "fonts.css"]}, active : pNext};
			WebFont.load(lWebFontConfig);
			return;
		}
		if(pResource.isJson) {
			var v = pResource.data;
			com_isartdigital_utils_loader_GameLoader.txtLoaded.set(lUrl,v);
			v;
			if(HxOverrides.substr(lUrl,-12,12) == "library.json" && Object.prototype.hasOwnProperty.call(pResource.data,"md5") && Object.prototype.hasOwnProperty.call(pResource.data,"movies") && Object.prototype.hasOwnProperty.call(pResource.data,"textureGroups") && Object.prototype.hasOwnProperty.call(pResource.data,"frameRate")) {
				(pixi_flump_Parser.parse(1,com_isartdigital_utils_Config.cache))(pResource,pNext);
				return;
			} else if(this.soundsList.length > 0) {
				var lData1;
				var _g11 = 0;
				var _g2 = this.soundsList.length;
				while(_g11 < _g2) {
					var i1 = _g11++;
					if(lUrl == this.soundsList[i1]) {
						this.soundsList.splice(i1,1);
						lData1 = pResource.data;
						if(com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) {
							if(HxOverrides.indexOf(lData1.extensions,"ogg",0) == -1) throw new js__$Boot_HaxeError("CocoonJs needs ogg sounds. No sound will be played in the application."); else lData1.extensions = ["ogg"];
						}
						var _g3 = 0;
						var _g21 = lData1.extensions.length;
						while(_g3 < _g21) {
							var j = _g3++;
							if(Howler.codecs(lData1.extensions[j])) {
								this.addSounds(lData1.fxs,false,lData1.extensions,lData1.extensions[i1]);
								this.addSounds(lData1.musics,true,lData1.extensions,lData1.extensions[i1]);
								break;
							}
						}
						break;
					}
				}
			}
		} else if(pResource.isXml) {
			var v1 = Xml.parse(new XMLSerializer().serializeToString(pResource.data));
			com_isartdigital_utils_loader_GameLoader.txtLoaded.set(lUrl,v1);
			v1;
		}
		pNext();
	}
	,manageCache: function(pResource,pNext) {
		if(pResource.name != pResource.url) pResource.url = com_isartdigital_utils_Config.url(pResource.url);
		pNext();
	}
	,addSounds: function(pList,pLoop,pExtensions,pCodec) {
		var lUrl;
		var _g = 0;
		var _g1 = Reflect.fields(pList);
		while(_g < _g1.length) {
			var lID = _g1[_g];
			++_g;
			lUrl = com_isartdigital_utils_Config.url(com_isartdigital_utils_Config.get_soundsPath() + lID + "." + pCodec);
			var value = { src : [lUrl], volume : Reflect.field(pList,lID) / 100, loop : pLoop};
			this.soundsSpecs.set(lID,value);
			this.add(lUrl);
		}
	}
	,load: function(cb) {
		this.before($bind(this,this.manageCache));
		this.after($bind(this,this.parseData));
		return PIXI.loaders.Loader.prototype.load.call(this);
	}
	,onComplete: function() {
		var $it0 = this.soundsSpecs.keys();
		while( $it0.hasNext() ) {
			var lID = $it0.next();
			com_isartdigital_utils_sounds_SoundManager.addSound(lID,new Howl(this.soundsSpecs.get(lID)));
		}
	}
	,__class__: com_isartdigital_utils_loader_GameLoader
});
var com_isartdigital_utils_sounds_SoundManager = function() {
};
$hxClasses["com.isartdigital.utils.sounds.SoundManager"] = com_isartdigital_utils_sounds_SoundManager;
com_isartdigital_utils_sounds_SoundManager.__name__ = ["com","isartdigital","utils","sounds","SoundManager"];
com_isartdigital_utils_sounds_SoundManager.addSound = function(pName,pSound) {
	if(com_isartdigital_utils_sounds_SoundManager.list == null) com_isartdigital_utils_sounds_SoundManager.list = new haxe_ds_StringMap();
	{
		com_isartdigital_utils_sounds_SoundManager.list.set(pName,pSound);
		pSound;
	}
};
com_isartdigital_utils_sounds_SoundManager.getSound = function(pName) {
	return com_isartdigital_utils_sounds_SoundManager.list.get(pName);
};
com_isartdigital_utils_sounds_SoundManager.prototype = {
	__class__: com_isartdigital_utils_sounds_SoundManager
};
var com_isartdigital_utils_system_DeviceCapabilities = function() { };
$hxClasses["com.isartdigital.utils.system.DeviceCapabilities"] = com_isartdigital_utils_system_DeviceCapabilities;
com_isartdigital_utils_system_DeviceCapabilities.__name__ = ["com","isartdigital","utils","system","DeviceCapabilities"];
com_isartdigital_utils_system_DeviceCapabilities.get_height = function() {
	return window.innerHeight;
};
com_isartdigital_utils_system_DeviceCapabilities.get_width = function() {
	return window.innerWidth;
};
com_isartdigital_utils_system_DeviceCapabilities.get_system = function() {
	if(new EReg("IEMobile","i").match(window.navigator.userAgent)) return "IEMobile"; else if(new EReg("iPhone|iPad|iPod","i").match(window.navigator.userAgent)) return "iOS"; else if(new EReg("BlackBerry","i").match(window.navigator.userAgent)) return "BlackBerry"; else if(new EReg("PlayBook","i").match(window.navigator.userAgent)) return "BlackBerry PlayBook"; else if(new EReg("Android","i").match(window.navigator.userAgent)) return "Android"; else return "Desktop";
};
com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS = function() {
	return window.navigator.isCocoonJS;
};
com_isartdigital_utils_system_DeviceCapabilities.displayFullScreenButton = function() {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) return;
	if(!new EReg("(iPad|iPhone|iPod)","g").match(window.navigator.userAgent) && !new EReg("MSIE","i").match(window.navigator.userAgent)) {
		window.document.onfullscreenchange = com_isartdigital_utils_system_DeviceCapabilities.onChangeFullScreen;
		window.document.onwebkitfullscreenchange = com_isartdigital_utils_system_DeviceCapabilities.onChangeFullScreen;
		window.document.onmozfullscreenchange = com_isartdigital_utils_system_DeviceCapabilities.onChangeFullScreen;
		window.document.onmsfullscreenchange = com_isartdigital_utils_system_DeviceCapabilities.onChangeFullScreen;
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton = new Image();
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.position = "absolute";
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.right = "0px";
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.top = "0px";
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.cursor = "pointer";
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.width = Std["int"](com_isartdigital_utils_system_DeviceCapabilities.getSizeFactor() * 0.11);
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.height = Std["int"](com_isartdigital_utils_system_DeviceCapabilities.getSizeFactor() * 0.11);
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.onclick = com_isartdigital_utils_system_DeviceCapabilities.enterFullscreen;
		com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.src = com_isartdigital_utils_Config.get_assetsPath() + "fullscreen.png";
		window.document.body.appendChild(com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton);
	}
};
com_isartdigital_utils_system_DeviceCapabilities.enterFullscreen = function(pEvent) {
	var lDocElm = window.document.documentElement;
	if($bind(lDocElm,lDocElm.requestFullscreen) != null) lDocElm.requestFullscreen(); else if(lDocElm.mozRequestFullScreen != null) lDocElm.mozRequestFullScreen(); else if(lDocElm.webkitRequestFullScreen != null) lDocElm.webkitRequestFullScreen(); else if(lDocElm.msRequestFullscreen != null) lDocElm.msRequestFullscreen();
};
com_isartdigital_utils_system_DeviceCapabilities.exitFullscreen = function() {
	if(($_=window.document,$bind($_,$_.exitFullscreen)) != null) window.document.exitFullscreen(); else if(window.document.mozCancelFullScreen != null) window.document.mozCancelFullScreen(); else if(window.document.webkitCancelFullScreen != null) window.document.webkitCancelFullScreen(); else if(window.document.msExitFullscreen) window.document.msExitFullscreen();
};
com_isartdigital_utils_system_DeviceCapabilities.onChangeFullScreen = function(pEvent) {
	if(window.document.fullScreen || (window.document.mozFullScreen || (window.document.webkitIsFullScreen || window.document.msFullscreenElement))) com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.display = "none"; else com_isartdigital_utils_system_DeviceCapabilities.fullScreenButton.style.display = "block";
	pEvent.preventDefault();
};
com_isartdigital_utils_system_DeviceCapabilities.getSizeFactor = function() {
	var lSize = Math.floor(Math.min(_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_width()),_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_height())));
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "Desktop") lSize /= 3;
	return lSize;
};
com_isartdigital_utils_system_DeviceCapabilities.getScreenRect = function(pTarget) {
	var lTopLeft = new PIXI.Point(0,0);
	var lBottomRight = new PIXI.Point(_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_width()),_$UInt_UInt_$Impl_$.toFloat(com_isartdigital_utils_system_DeviceCapabilities.get_height()));
	lTopLeft = pTarget.toLocal(lTopLeft);
	lBottomRight = pTarget.toLocal(lBottomRight);
	return new PIXI.Rectangle(lTopLeft.x,lTopLeft.y,lBottomRight.x - lTopLeft.x,lBottomRight.y - lTopLeft.y);
};
com_isartdigital_utils_system_DeviceCapabilities.scaleViewport = function() {
	if(com_isartdigital_utils_system_DeviceCapabilities.get_system() == "IEMobile") return;
	com_isartdigital_utils_system_DeviceCapabilities.screenRatio = window.devicePixelRatio;
	if(!com_isartdigital_utils_system_DeviceCapabilities.get_isCocoonJS()) window.document.write("<meta name=\"viewport\" content=\"initial-scale=" + Math.round(100 / com_isartdigital_utils_system_DeviceCapabilities.screenRatio) / 100 + ", user-scalable=no, minimal-ui\">");
};
com_isartdigital_utils_system_DeviceCapabilities.init = function(pHd,pMd,pLd) {
	if(pLd == null) pLd = 0.25;
	if(pMd == null) pMd = 0.5;
	if(pHd == null) pHd = 1;
	{
		com_isartdigital_utils_system_DeviceCapabilities.texturesRatios.set("hd",pHd);
		pHd;
	}
	{
		com_isartdigital_utils_system_DeviceCapabilities.texturesRatios.set("md",pMd);
		pMd;
	}
	{
		com_isartdigital_utils_system_DeviceCapabilities.texturesRatios.set("ld",pLd);
		pLd;
	}
	if(com_isartdigital_utils_Config.get_data().texture != null && com_isartdigital_utils_Config.get_data().texture != "") com_isartdigital_utils_system_DeviceCapabilities.textureType = com_isartdigital_utils_Config.get_data().texture; else {
		var lBW = Math.max(window.screen.width,window.screen.height);
		var lBH = Math.min(window.screen.width,window.screen.height);
		var lW = Math.max(com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().width,com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().height);
		var lH = Math.min(com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().width,com_isartdigital_utils_game_GameStage.getInstance().get_safeZone().height);
		var lRatio = Math.min(lBW * com_isartdigital_utils_system_DeviceCapabilities.screenRatio / lW,lBH * com_isartdigital_utils_system_DeviceCapabilities.screenRatio / lH);
		if(lRatio <= pLd) com_isartdigital_utils_system_DeviceCapabilities.textureType = "ld"; else if(lRatio <= pMd) com_isartdigital_utils_system_DeviceCapabilities.textureType = "md"; else com_isartdigital_utils_system_DeviceCapabilities.textureType = "hd";
	}
	com_isartdigital_utils_system_DeviceCapabilities.textureRatio = com_isartdigital_utils_system_DeviceCapabilities.texturesRatios.get(com_isartdigital_utils_system_DeviceCapabilities.textureType);
};
var com_isartdigital_utils_ui_UIPosition = function() {
};
$hxClasses["com.isartdigital.utils.ui.UIPosition"] = com_isartdigital_utils_ui_UIPosition;
com_isartdigital_utils_ui_UIPosition.__name__ = ["com","isartdigital","utils","ui","UIPosition"];
com_isartdigital_utils_ui_UIPosition.checkAlignExist = function(pAlign) {
	switch(pAlign) {
	case "left":
		return null;
	case "right":
		return null;
	case "top":
		return null;
	case "bottom":
		return null;
	case "topLeft":
		return null;
	case "topRight":
		return null;
	case "bottomLeft":
		return null;
	case "bottomRight":
		return null;
	case "bottomCenter":
		return null;
	case "topCenter":
		return null;
	case "fitWidth":
		return null;
	case "fitHeight":
		return null;
	case "fitScreen":
		return null;
	default:
		com_isartdigital_utils_Debug.error("UIPosition \"" + pAlign + "\" doesn't exist !");
	}
};
com_isartdigital_utils_ui_UIPosition.setPosition = function(pTarget,pPosition,pOffsetX,pOffsetY) {
	if(pOffsetY == null) pOffsetY = 0;
	if(pOffsetX == null) pOffsetX = 0;
	var lScreen = com_isartdigital_utils_system_DeviceCapabilities.getScreenRect(pTarget.parent);
	var lTopLeft = new PIXI.Point(lScreen.x,lScreen.y);
	var lBottomRight = new PIXI.Point(lScreen.x + lScreen.width,lScreen.y + lScreen.height);
	com_isartdigital_utils_ui_UIPosition.moveTarget({ topLeft : lTopLeft, bottomRight : lBottomRight},pTarget,pPosition,pOffsetX,pOffsetY);
};
com_isartdigital_utils_ui_UIPosition.setPositionContextualUI = function(pParent,pTarget,pPosition,pOffsetX,pOffsetY) {
	if(pOffsetY == null) pOffsetY = 0;
	if(pOffsetX == null) pOffsetX = 0;
	com_isartdigital_utils_ui_UIPosition.moveTarget({ topLeft : new PIXI.Point(0,0), bottomRight : new PIXI.Point(pParent.width,pParent.height)},pTarget,pPosition,pOffsetX,pOffsetY);
};
com_isartdigital_utils_ui_UIPosition.moveTarget = function(pParentRect,pTarget,pPosition,pOffsetX,pOffsetY) {
	if(pOffsetY == null) pOffsetY = 0;
	if(pOffsetX == null) pOffsetX = 0;
	var lWidth = pParentRect.bottomRight.x - pParentRect.topLeft.x;
	var lHeight = pParentRect.bottomRight.y - pParentRect.topLeft.y;
	if(HxOverrides.indexOf(["top","topLeft","topRight","topCenter"],pPosition,0) != -1) pTarget.y = pParentRect.topLeft.y + pOffsetY;
	if(HxOverrides.indexOf(["bottom","bottomLeft","bottomRight","bottomCenter"],pPosition,0) != -1) pTarget.y = pParentRect.bottomRight.y - pOffsetY;
	if(HxOverrides.indexOf(["left","topLeft","bottomLeft"],pPosition,0) != -1) pTarget.x = pParentRect.topLeft.x + pOffsetX;
	if(HxOverrides.indexOf(["right","topRight","bottomRight"],pPosition,0) != -1) pTarget.x = pParentRect.bottomRight.x - pOffsetX;
	if(HxOverrides.indexOf(["topCenter","bottomCenter"],pPosition,0) != -1) pTarget.x = pParentRect.bottomRight.x - lWidth / 2 - pOffsetX;
	if(pPosition == "fitWidth" || pPosition == "fitScreen") {
		pTarget.x = pParentRect.topLeft.x;
		pTarget.width = lWidth;
	}
	if(pPosition == "fitHeight" || pPosition == "fitScreen") {
		pTarget.y = pParentRect.topLeft.y;
		pTarget.height = lHeight;
	}
};
com_isartdigital_utils_ui_UIPosition.prototype = {
	__class__: com_isartdigital_utils_ui_UIPosition
};
var com_isartdigital_utils_ui_smart_TextSprite = function(pData) {
	PIXI.Container.call(this);
	var lStyle = { font : StringTools.replace(pData.font,"*",""), fill : pData.color, align : pData.align, wordWrap : pData.wordWrap == 1, wordWrapWidth : pData.width};
	this.textField = new PIXI.Text(com_isartdigital_utils_ui_smart_TextSprite.parseText(StringTools.replace(pData.text,"</BR>","\r")),lStyle);
	if(pData.align == "center") this.textField.anchor.x = 0.5; else if(pData.align == "right") this.textField.anchor.x = 1;
	if(pData.verticalAlign == "top") this.textField.anchor.y = 0;
	if(pData.verticalAlign == "bottom") this.textField.anchor.y = 1; else this.textField.anchor.y = 0.5;
	if(com_isartdigital_utils_Config.get_debug()) {
		var lGraph = new PIXI.Graphics();
		lGraph.beginFill(16776960);
		lGraph.drawRect(pData.x,pData.y,pData.width,pData.height);
		lGraph.endFill();
		lGraph.alpha = 0.5;
		this.addChild(lGraph);
	}
	this.addChild(this.textField);
};
$hxClasses["com.isartdigital.utils.ui.smart.TextSprite"] = com_isartdigital_utils_ui_smart_TextSprite;
com_isartdigital_utils_ui_smart_TextSprite.__name__ = ["com","isartdigital","utils","ui","smart","TextSprite"];
com_isartdigital_utils_ui_smart_TextSprite.defaultParseText = function(pTxt) {
	return pTxt;
};
com_isartdigital_utils_ui_smart_TextSprite.__super__ = PIXI.Container;
com_isartdigital_utils_ui_smart_TextSprite.prototype = $extend(PIXI.Container.prototype,{
	get_text: function() {
		return this.textField.text;
	}
	,set_text: function(pText) {
		this.textField.text = pText;
		return pText;
	}
	,__class__: com_isartdigital_utils_ui_smart_TextSprite
});
var com_isartdigital_utils_ui_smart_UIBuilder = function() {
};
$hxClasses["com.isartdigital.utils.ui.smart.UIBuilder"] = com_isartdigital_utils_ui_smart_UIBuilder;
com_isartdigital_utils_ui_smart_UIBuilder.__name__ = ["com","isartdigital","utils","ui","smart","UIBuilder"];
com_isartdigital_utils_ui_smart_UIBuilder.build = function(pId,pFrame) {
	if(pFrame == null) pFrame = 0;
	var lMovie = pixi_flump_Resource.getResourceForMovie(pId).library.movies.h[pId];
	var lObj;
	var lUIPos = [];
	var lLayer;
	var lKeyFrame;
	var _g1 = 0;
	var _g = lMovie.layers.length;
	while(_g1 < _g) {
		var i = _g1++;
		lObj = null;
		lLayer = lMovie.layers[i];
		lKeyFrame = lLayer.getKeyframeForFrame(pFrame);
		if(lKeyFrame == null || lKeyFrame.symbol == null) continue;
		if((lKeyFrame.symbol.data == null || lKeyFrame.symbol.data.className == null) && com_isartdigital_perle_Main.getInstance().getClassName(lLayer.name) != null) lKeyFrame.symbol.data = { className : com_isartdigital_perle_Main.getInstance().getClassName(lLayer.name)};
		if(lKeyFrame.symbol.data != null && lKeyFrame.symbol.data.className != null) lObj = Type.createInstance(Type.resolveClass(lKeyFrame.symbol.data.className),[]); else if(lKeyFrame.symbol.baseClass == "Flipbook") lObj = new com_isartdigital_utils_ui_smart_UIMovie(lKeyFrame.symbolId); else if(lKeyFrame.symbol.baseClass == "TextSprite") lObj = new com_isartdigital_utils_ui_smart_TextSprite(lKeyFrame.symbol.data); else if(js_Boot.__instanceof(lKeyFrame.symbol,flump_library_SpriteSymbol)) lObj = new com_isartdigital_utils_ui_smart_UISprite(lKeyFrame.symbolId); else if(lKeyFrame.symbol.baseClass == "flash.display.SimpleButton") lObj = new com_isartdigital_utils_ui_smart_SmartButton(lKeyFrame.symbolId); else {
			var lChild = pixi_flump_Resource.getResourceForMovie(lKeyFrame.symbolId).library.movies.h[lKeyFrame.symbolId];
			var lChildLayer;
			var _g2 = 0;
			var _g3 = lChild.layers;
			while(_g2 < _g3.length) {
				var lChildLayer1 = _g3[_g2];
				++_g2;
				if(lChildLayer1.keyframes.length > 1) {
					lObj = new com_isartdigital_utils_ui_smart_UIMovie(lKeyFrame.symbolId);
					break;
				}
			}
			if(lObj == null) {
				lObj = new com_isartdigital_utils_ui_smart_SmartComponent(lKeyFrame.symbolId);
				(js_Boot.__cast(lObj , com_isartdigital_utils_ui_smart_SmartComponent)).set_modal(false);
			}
		}
		lObj.name = lLayer.name;
		lObj.position = new PIXI.Point(lKeyFrame.location.x / com_isartdigital_utils_system_DeviceCapabilities.textureRatio,lKeyFrame.location.y / com_isartdigital_utils_system_DeviceCapabilities.textureRatio);
		lObj.scale = new PIXI.Point(lKeyFrame.scale.x,lKeyFrame.scale.y);
		lObj.skew = new PIXI.Point(lKeyFrame.skew.x,lKeyFrame.skew.y);
		if(lKeyFrame.tintMultiplier != null && lKeyFrame.tintMultiplier != 0) lObj.filters = [new flump_filters_AnimateTintFilter(lKeyFrame.tintColor,lKeyFrame.tintMultiplier)];
		var lUIPosition = "";
		if(lKeyFrame.data != null) {
			Reflect.fields(lKeyFrame.data).map(function(p) {
				if(p != "UIPosition_Desktop" && p != "UIPosition") com_isartdigital_utils_Debug.error("Syntax error in persistent data ? => \"" + p + "\"");
			});
			if(Reflect.hasField(lKeyFrame.data,"UIPosition_" + com_isartdigital_utils_system_DeviceCapabilities.get_system())) lUIPosition = Reflect.field(lKeyFrame.data,"UIPosition_" + com_isartdigital_utils_system_DeviceCapabilities.get_system()); else if(lKeyFrame.data.UIPosition != null) lUIPosition = lKeyFrame.data.UIPosition;
			com_isartdigital_utils_ui_UIPosition.checkAlignExist(lUIPosition);
		}
		lUIPos.push(com_isartdigital_utils_ui_smart_UIBuilder.getUIPositionable(lObj,lUIPosition));
	}
	return lUIPos;
};
com_isartdigital_utils_ui_smart_UIBuilder.getUIPositionable = function(pObj,pPosition) {
	var lOffset = new PIXI.Point(0,0);
	if(pPosition == "top" || pPosition == "topLeft" || pPosition == "topRight" || pPosition == "bottom" || pPosition == "bottomLeft" || pPosition == "bottomRight") lOffset.y = pObj.y;
	if(pPosition == "left" || pPosition == "topLeft" || pPosition == "bottomLeft" || pPosition == "right" || pPosition == "topRight" || pPosition == "bottomRight") lOffset.x = pObj.x;
	return { item : pObj, align : pPosition, offsetX : lOffset.x, offsetY : lOffset.y, update : true};
};
com_isartdigital_utils_ui_smart_UIBuilder.prototype = {
	__class__: com_isartdigital_utils_ui_smart_UIBuilder
};
var com_isartdigital_utils_ui_smart_UIMovie = function(pAssetName) {
	com_isartdigital_utils_game_StateGraphic.call(this);
	this.assetName = pAssetName;
	this.factory = new com_isartdigital_utils_game_factory_FlumpMovieAnimFactory();
	this.setState(this.DEFAULT_STATE,true);
};
$hxClasses["com.isartdigital.utils.ui.smart.UIMovie"] = com_isartdigital_utils_ui_smart_UIMovie;
com_isartdigital_utils_ui_smart_UIMovie.__name__ = ["com","isartdigital","utils","ui","smart","UIMovie"];
com_isartdigital_utils_ui_smart_UIMovie.__super__ = com_isartdigital_utils_game_StateGraphic;
com_isartdigital_utils_ui_smart_UIMovie.prototype = $extend(com_isartdigital_utils_game_StateGraphic.prototype,{
	__class__: com_isartdigital_utils_ui_smart_UIMovie
});
var com_isartdigital_utils_ui_smart_UISprite = function(pAssetName) {
	com_isartdigital_utils_game_StateGraphic.call(this);
	this.assetName = pAssetName;
	this.factory = new com_isartdigital_utils_game_factory_FlumpSpriteAnimFactory();
	this.setState(this.DEFAULT_STATE);
};
$hxClasses["com.isartdigital.utils.ui.smart.UISprite"] = com_isartdigital_utils_ui_smart_UISprite;
com_isartdigital_utils_ui_smart_UISprite.__name__ = ["com","isartdigital","utils","ui","smart","UISprite"];
com_isartdigital_utils_ui_smart_UISprite.__super__ = com_isartdigital_utils_game_StateGraphic;
com_isartdigital_utils_ui_smart_UISprite.prototype = $extend(com_isartdigital_utils_game_StateGraphic.prototype,{
	__class__: com_isartdigital_utils_ui_smart_UISprite
});
var flump_DisplayObjectKey = function(symbolId) {
	this.symbolId = symbolId;
};
$hxClasses["flump.DisplayObjectKey"] = flump_DisplayObjectKey;
flump_DisplayObjectKey.__name__ = ["flump","DisplayObjectKey"];
flump_DisplayObjectKey.prototype = {
	__class__: flump_DisplayObjectKey
};
var flump_IFlumpMovie = function() { };
$hxClasses["flump.IFlumpMovie"] = flump_IFlumpMovie;
flump_IFlumpMovie.__name__ = ["flump","IFlumpMovie"];
flump_IFlumpMovie.prototype = {
	__class__: flump_IFlumpMovie
};
var flump_MoviePlayer = function(symbol,movie,resolution) {
	this.position = 0.0;
	this.fullyGenerated = false;
	this.dirty = false;
	this.changed = 0;
	this.labelsToFire = [];
	this.childPlayers = new haxe_ds_ObjectMap();
	this.createdChildren = new haxe_ds_ObjectMap();
	this.currentChildrenKey = new haxe_ds_ObjectMap();
	this.STATE_STOPPED = "stopped";
	this.STATE_LOOPING = "looping";
	this.STATE_PLAYING = "playing";
	this.independantControl = true;
	this.independantTimeline = true;
	this.prevPosition = -1;
	this.advanced = 0.0;
	this.previousElapsed = 0.0;
	this.elapsed = 0.0;
	this.symbol = symbol;
	this.movie = movie;
	this.resolution = resolution;
	var _g = 0;
	var _g1 = symbol.layers;
	while(_g < _g1.length) {
		var layer = _g1[_g];
		++_g;
		movie.createLayer(layer);
	}
	this.state = this.STATE_LOOPING;
	this.advanceTime(0);
	var _g2 = 0;
	var _g11 = symbol.layers;
	while(_g2 < _g11.length) {
		var layer1 = _g11[_g2];
		++_g2;
		movie.setMask(layer1);
	}
};
$hxClasses["flump.MoviePlayer"] = flump_MoviePlayer;
flump_MoviePlayer.__name__ = ["flump","MoviePlayer"];
flump_MoviePlayer.prototype = {
	get_labels: function() {
		return this.symbol.labels.iterator();
	}
	,getDisplayKey: function(layerId,keyframeIndex) {
		if(keyframeIndex == null) keyframeIndex = 0;
		var layer = this.symbol.getLayer(layerId);
		if(layer == null) throw new js__$Boot_HaxeError("Layer " + layerId + " does not exist.");
		var keyframe = layer.getKeyframeForFrame(keyframeIndex);
		if(keyframe == null) throw new js__$Boot_HaxeError("Keyframe does not exist at index " + Std.string(_$UInt_UInt_$Impl_$.toFloat(keyframeIndex)));
		this.createChildIfNessessary(keyframe);
		return keyframe.displayKey;
	}
	,reset: function() {
		this.elapsed = 0;
		this.previousElapsed = 0;
		this.prevPosition = -1;
	}
	,get_position: function() {
		var lModPos = (this.elapsed % this.symbol.duration + this.symbol.duration) % this.symbol.duration;
		var lEndPos;
		if(this.state == this.STATE_PLAYING) {
			lEndPos = this.symbol.duration - this.symbol.library.frameTime;
			if(this.elapsed >= lEndPos) return lEndPos; else return lModPos;
		} else return lModPos;
	}
	,get_totalFrames: function() {
		return this.symbol.totalFrames;
	}
	,play: function() {
		this.setState(this.STATE_PLAYING);
		return this;
	}
	,loop: function() {
		this.setState(this.STATE_LOOPING);
		return this;
	}
	,stop: function() {
		this.setState(this.STATE_STOPPED);
		return this;
	}
	,goToLabel: function(label) {
		if(!this.labelExists(label)) throw new js__$Boot_HaxeError("Symbol " + this.symbol.name + " does not have label " + label + ".");
		this.set_currentFrame(this.getLabelFrame(label));
		this.fireHitFrames(this.getLabelFrame(label));
		return this;
	}
	,goToFrame: function(frame) {
		this.set_currentFrame(frame);
		this.fireHitFrames(frame);
		return this;
	}
	,fireHitFrames: function(frame) {
		this.changed++;
		var current = this.changed;
		var time = frame * this.symbol.library.frameTime;
		var _g = 0;
		var _g1 = this.symbol.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			var _g2 = 0;
			var _g3 = layer.keyframes;
			while(_g2 < _g3.length) {
				var kf = _g3[_g2];
				++_g2;
				if(current != this.changed) return;
				if(kf.label != null) {
					if(kf.timeInside(time)) this.movie.labelHit(kf.label);
				}
			}
		}
	}
	,goToPosition: function(time) {
		this.elapsed = time;
		this.previousElapsed = time;
		this.clearLabels();
		return this;
	}
	,get_playing: function() {
		return this.state == this.STATE_PLAYING;
	}
	,get_looping: function() {
		return this.state == this.STATE_LOOPING;
	}
	,get_stopped: function() {
		return this.state == this.STATE_STOPPED;
	}
	,getLabelFrame: function(label) {
		if(!this.labelExists(label)) throw new js__$Boot_HaxeError("Symbol " + this.symbol.name + " does not have label " + label + ".");
		return this.symbol.labels.get(label).keyframe.index;
	}
	,get_currentFrame: function() {
		return Std["int"](this.get_position() / this.symbol.library.frameTime);
	}
	,set_currentFrame: function(value) {
		this.goToPosition(this.symbol.library.frameTime * value);
		return value;
	}
	,labelExists: function(label) {
		return this.symbol.labels.exists(label);
	}
	,advanceTime: function(ms) {
		if(this.state != this.STATE_STOPPED) {
			this.elapsed += ms;
			while(this.elapsed < 0) {
				this.elapsed += this.symbol.duration;
				this.previousElapsed += this.symbol.duration;
			}
		}
		this.advanced += ms;
		if(this.state != this.STATE_STOPPED) this.fireLabels();
		this.render();
	}
	,clearLabels: function() {
		while(this.labelsToFire.length > 0) this.labelsToFire.pop();
	}
	,fireLabels: function() {
		if(this.symbol.firstLabel == null) return;
		if(this.previousElapsed > this.elapsed) return;
		var label;
		if(this.previousElapsed <= this.elapsed) label = this.symbol.firstLabel; else label = this.symbol.lastLabel;
		var checking = true;
		while(checking) if(label.keyframe.time > this.previousElapsed % this.symbol.duration) checking = false; else if(_$UInt_UInt_$Impl_$.gte(label.keyframe.index,label.next.keyframe.index)) {
			checking = false;
			label = label.next;
		} else label = label.next;
		var firstChecked = label;
		while(label != null) {
			var checkFrom = this.previousElapsed % this.symbol.duration;
			var checkTo = this.elapsed % this.symbol.duration;
			if(label.keyframe.insideRangeStart(checkFrom,checkTo) && this.state != this.STATE_STOPPED) this.labelsToFire.push(label);
			label = label.next;
			if(label == firstChecked) label = null;
		}
		while(this.labelsToFire.length > 0) {
			var label1 = this.labelsToFire.shift();
			this.movie.labelPassed(label1);
		}
	}
	,render: function() {
		var lIsUpdate = true;
		var next = null;
		var interped = -1;
		var lColor = -1;
		if(this.state == this.STATE_PLAYING) {
			if(this.get_position() >= this.symbol.duration - this.symbol.library.frameTime) {
				this.elapsed = this.symbol.duration - this.symbol.library.frameTime;
				this.stop();
				this.movie.onAnimationComplete();
			}
		}
		if(this.get_position() != this.prevPosition && (this.prevPosition < 0 || _$UInt_UInt_$Impl_$.gt(this.get_totalFrames(),1))) this.prevPosition = this.get_position(); else lIsUpdate = false;
		var _g = 0;
		var _g1 = this.symbol.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			var keyframe = layer.getKeyframeForTime(this.get_position());
			if(keyframe.isEmpty == true) this.removeChildIfNessessary(keyframe); else if(keyframe.isEmpty == false) {
				if(lIsUpdate) {
					interped = this.getInterpolation(keyframe,this.get_position());
					next = keyframe.next;
					if(next.isEmpty) next = keyframe;
					if(keyframe.tintColor != next.tintColor) {
						var lPrevColor = keyframe.tintColor;
						var lNextColor = next.tintColor;
						var lPrevR = lPrevColor >> 16 & 255;
						var lPrevG = lPrevColor >> 8 & 255;
						var lPrevB = lPrevColor & 255;
						var lNextR = lNextColor >> 16 & 255;
						var lNextG = lNextColor >> 8 & 255;
						var lNextB = lNextColor & 255;
						lColor = Math.round(lPrevR + (lNextR - lPrevR) * interped) << 16 | Math.round(lPrevG + (lNextG - lPrevG) * interped) << 8 | Math.round(lPrevB + (lNextB - lPrevB) * interped);
					} else lColor = keyframe.tintColor;
					if(this.currentChildrenKey.h[layer.__id__] != keyframe.displayKey) {
						this.createChildIfNessessary(keyframe);
						this.removeChildIfNessessary(keyframe);
						this.addChildIfNessessary(keyframe);
					}
				}
				if(js_Boot.__instanceof(keyframe.symbol,flump_library_MovieSymbol)) {
					var childMovie = this.movie.getChildPlayer(keyframe);
					if(childMovie.independantTimeline) childMovie.advanceTime(this.advanced); else {
						childMovie.elapsed = this.get_position();
						childMovie.render();
					}
				}
				if(lIsUpdate) this.movie.renderFrame(keyframe,keyframe.location.x + (next.location.x - keyframe.location.x) * interped,keyframe.location.y + (next.location.y - keyframe.location.y) * interped,keyframe.scale.x + (next.scale.x - keyframe.scale.x) * interped,keyframe.scale.y + (next.scale.y - keyframe.scale.y) * interped,keyframe.skew.x + (next.skew.x - keyframe.skew.x) * interped,keyframe.skew.y + (next.skew.y - keyframe.skew.y) * interped,keyframe.alpha + (next.alpha - keyframe.alpha) * interped,keyframe.tintMultiplier + (next.tintMultiplier - keyframe.tintMultiplier) * interped,lColor);
			}
		}
		this.advanced = 0;
		this.previousElapsed = this.elapsed;
	}
	,createChildIfNessessary: function(keyframe) {
		if(keyframe.isEmpty) return;
		if(this.createdChildren.h.__keys__[keyframe.displayKey.__id__] != null == false) {
			this.movie.createFlumpChild(keyframe.displayKey);
			{
				this.createdChildren.set(keyframe.displayKey,true);
				true;
			}
		}
	}
	,removeChildIfNessessary: function(keyframe) {
		if(this.currentChildrenKey.h.__keys__[keyframe.layer.__id__] != null) {
			this.movie.removeFlumpChild(keyframe.layer,keyframe.displayKey);
			this.currentChildrenKey.remove(keyframe.layer);
		}
	}
	,addChildIfNessessary: function(keyframe) {
		if(keyframe.isEmpty) return;
		var v = keyframe.displayKey;
		this.currentChildrenKey.set(keyframe.layer,v);
		v;
		this.movie.addFlumpChild(keyframe.layer,keyframe.displayKey);
	}
	,setState: function(state) {
		this.state = state;
		var _g = 0;
		var _g1 = this.symbol.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			var keyframe = layer.getKeyframeForTime(this.get_position());
			this.createChildIfNessessary(keyframe);
			if(js_Boot.__instanceof(keyframe.symbol,flump_library_MovieSymbol)) {
				var childMovie = this.movie.getChildPlayer(keyframe);
				if(childMovie.independantControl == false) childMovie.setState(state);
			}
		}
		this.advanceTime(0);
	}
	,timeForLabel: function(label) {
		return this.symbol.labels.get(label).keyframe.time;
	}
	,getInterpolation: function(keyframe,time) {
		if(keyframe.tweened == false) return 0.0;
		var interped = (time - keyframe.time) / keyframe.duration;
		var ease = keyframe.ease;
		if(ease != 0) {
			var t;
			if(ease < 0) {
				var inv = 1 - interped;
				t = 1 - inv * inv;
				ease = -ease;
			} else t = interped * interped;
			interped = ease * t + (1 - ease) * interped;
		}
		return interped;
	}
	,__class__: flump_MoviePlayer
};
var flump_filters_AnimateTintFilter = function(pColor,pMultiplier) {
	if(pMultiplier == null) pMultiplier = 1;
	this.color = pColor;
	this.multiplier = pMultiplier;
	this.uniforms = { color : { type : "v3", value : this.hex2v3(this.color)}, multiplier : { type : "1f", value : this.multiplier}};
	PIXI.AbstractFilter.call(this,null,this.getFragmentSrc(),this.uniforms);
};
$hxClasses["flump.filters.AnimateTintFilter"] = flump_filters_AnimateTintFilter;
flump_filters_AnimateTintFilter.__name__ = ["flump","filters","AnimateTintFilter"];
flump_filters_AnimateTintFilter.__super__ = PIXI.AbstractFilter;
flump_filters_AnimateTintFilter.prototype = $extend(PIXI.AbstractFilter.prototype,{
	getFragmentSrc: function() {
		var lSrc = "";
		lSrc += "precision mediump float;varying vec2 vTextureCoord;uniform sampler2D uSampler;uniform vec3 color;uniform float multiplier;";
		lSrc += "void main () { gl_FragColor = texture2D(uSampler, vTextureCoord);";
		lSrc += "gl_FragColor.r = (color.r*multiplier+gl_FragColor.r*(1.0-multiplier)) * gl_FragColor.a;";
		lSrc += "gl_FragColor.g = (color.g*multiplier+gl_FragColor.g*(1.0-multiplier)) * gl_FragColor.a;";
		lSrc += "gl_FragColor.b = (color.b*multiplier+gl_FragColor.b*(1.0-multiplier)) * gl_FragColor.a;";
		lSrc += "}";
		return lSrc;
	}
	,hex2v3: function(pColor) {
		return { x : _$UInt_UInt_$Impl_$.toFloat(pColor >> 16 & 255) / _$UInt_UInt_$Impl_$.toFloat(255), y : _$UInt_UInt_$Impl_$.toFloat(pColor >> 8 & 255) / _$UInt_UInt_$Impl_$.toFloat(255), z : _$UInt_UInt_$Impl_$.toFloat(pColor & 255) / _$UInt_UInt_$Impl_$.toFloat(255)};
	}
	,update: function(pColor,pMultiplier) {
		if(pMultiplier == null) pMultiplier = 1;
		this.uniforms.color.value = this.hex2v3(this.color = pColor);
		this.uniforms.multiplier.value = this.multiplier = pMultiplier;
	}
	,__class__: flump_filters_AnimateTintFilter
});
var flump_json__$FlumpJSON_FlumpPointSpec_$Impl_$ = {};
$hxClasses["flump.json._FlumpJSON.FlumpPointSpec_Impl_"] = flump_json__$FlumpJSON_FlumpPointSpec_$Impl_$;
flump_json__$FlumpJSON_FlumpPointSpec_$Impl_$.__name__ = ["flump","json","_FlumpJSON","FlumpPointSpec_Impl_"];
flump_json__$FlumpJSON_FlumpPointSpec_$Impl_$.get_x = function(this1) {
	return this1[0];
};
flump_json__$FlumpJSON_FlumpPointSpec_$Impl_$.get_y = function(this1) {
	return this1[1];
};
var flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$ = {};
$hxClasses["flump.json._FlumpJSON.FlumpRectSpec_Impl_"] = flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$;
flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$.__name__ = ["flump","json","_FlumpJSON","FlumpRectSpec_Impl_"];
flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$.get_x = function(this1) {
	return this1[0];
};
flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$.get_y = function(this1) {
	return this1[1];
};
flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$.get_width = function(this1) {
	return this1[2];
};
flump_json__$FlumpJSON_FlumpRectSpec_$Impl_$.get_height = function(this1) {
	return this1[3];
};
var flump_library_FlumpLibrary = function(resolution) {
	this.atlases = [];
	this.sprites = new haxe_ds_StringMap();
	this.movies = new haxe_ds_StringMap();
	this.resolution = resolution;
};
$hxClasses["flump.library.FlumpLibrary"] = flump_library_FlumpLibrary;
flump_library_FlumpLibrary.__name__ = ["flump","library","FlumpLibrary"];
flump_library_FlumpLibrary.create = function(flumpData,resolution) {
	var lib = flumpData;
	var spriteSymbols = new haxe_ds_StringMap();
	var movieSymbols = new haxe_ds_StringMap();
	var flumpLibrary = new flump_library_FlumpLibrary(resolution);
	flumpLibrary.sprites = spriteSymbols;
	flumpLibrary.movies = movieSymbols;
	flumpLibrary.framerate = _$UInt_UInt_$Impl_$.toFloat(lib.frameRate);
	flumpLibrary.frameTime = 1000 / flumpLibrary.framerate;
	flumpLibrary.md5 = lib.md5;
	var atlasSpecs = [];
	var textureGroup = null;
	var _g = 0;
	var _g1 = lib.textureGroups;
	while(_g < _g1.length) {
		var tg = _g1[_g];
		++_g;
		if(_$UInt_UInt_$Impl_$.toFloat(tg.scaleFactor) >= resolution && textureGroup == null) textureGroup = tg;
	}
	if(textureGroup == null) textureGroup = lib.textureGroups[lib.textureGroups.length - 1];
	var _g2 = 0;
	var _g11 = textureGroup.atlases;
	while(_g2 < _g11.length) {
		var atlas = _g11[_g2];
		++_g2;
		flumpLibrary.atlases.push(atlas);
		atlasSpecs.push(atlas);
	}
	var _g3 = 0;
	while(_g3 < atlasSpecs.length) {
		var spec = atlasSpecs[_g3];
		++_g3;
		var _g12 = 0;
		var _g21 = spec.textures;
		while(_g12 < _g21.length) {
			var textureSpec = _g21[_g12];
			++_g12;
			var frame = new flump_library_Rectangle(textureSpec.rect[0],textureSpec.rect[1],textureSpec.rect[2],textureSpec.rect[3]);
			var origin = new flump_library_Point(textureSpec.origin[0],textureSpec.origin[1]);
			var symbol = new flump_library_SpriteSymbol();
			symbol.name = textureSpec.symbol;
			symbol.data = textureSpec.data;
			symbol.baseClass = textureSpec.baseClass;
			symbol.origin = origin;
			symbol.texture = textureSpec.symbol;
			{
				spriteSymbols.set(symbol.name,symbol);
				symbol;
			}
		}
	}
	var pendingSymbolAttachments = new haxe_ds_ObjectMap();
	var _g4 = 0;
	var _g13 = lib.movies;
	while(_g4 < _g13.length) {
		var movieSpec = _g13[_g4];
		++_g4;
		var symbol1 = new flump_library_MovieSymbol();
		symbol1.name = movieSpec.id;
		symbol1.data = movieSpec.data;
		symbol1.baseClass = movieSpec.baseClass;
		symbol1.library = flumpLibrary;
		var _g22 = 0;
		var _g31 = movieSpec.layers;
		while(_g22 < _g31.length) {
			var layerSpec = _g31[_g22];
			++_g22;
			var layer1 = new flump_library_Layer(layerSpec.name);
			layer1.movie = symbol1;
			layer1.mask = layerSpec.mask;
			var layerDuration = 0;
			var previousKeyframe = null;
			var _g41 = 0;
			var _g5 = layerSpec.keyframes;
			while(_g41 < _g5.length) {
				var keyframeSpec = _g5[_g41];
				++_g41;
				var keyframe1 = new flump_library_Keyframe();
				keyframe1.prev = previousKeyframe;
				if(previousKeyframe != null) previousKeyframe.next = keyframe1;
				keyframe1.layer = layer1;
				keyframe1.numFrames = keyframeSpec.duration;
				keyframe1.duration = _$UInt_UInt_$Impl_$.toFloat(keyframeSpec.duration) * flumpLibrary.frameTime;
				keyframe1.index = keyframeSpec.index;
				var time = _$UInt_UInt_$Impl_$.toFloat(keyframe1.index) * flumpLibrary.frameTime;
				time *= 10;
				time = Math.floor(time);
				time /= 10;
				keyframe1.time = time;
				if(keyframeSpec.ref == null) keyframe1.isEmpty = true; else {
					keyframe1.isEmpty = false;
					keyframe1.symbolId = keyframeSpec.ref;
					if(keyframeSpec.pivot == null) keyframe1.pivot = new flump_library_Point(0,0); else keyframe1.pivot = new flump_library_Point(keyframeSpec.pivot[0] * resolution,keyframeSpec.pivot[1] * resolution);
					if(keyframeSpec.loc == null) keyframe1.location = new flump_library_Point(0,0); else keyframe1.location = new flump_library_Point(keyframeSpec.loc[0] * resolution,keyframeSpec.loc[1] * resolution);
					if(keyframeSpec.tweened == false) keyframe1.tweened = false; else keyframe1.tweened = true;
					keyframe1.symbol = null;
					if(keyframeSpec.scale == null) keyframe1.scale = new flump_library_Point(1,1); else keyframe1.scale = new flump_library_Point(keyframeSpec.scale[0],keyframeSpec.scale[1]);
					if(keyframeSpec.skew == null) keyframe1.skew = new flump_library_Point(0,0); else keyframe1.skew = new flump_library_Point(keyframeSpec.skew[0],keyframeSpec.skew[1]);
					if(keyframeSpec.alpha == null) keyframe1.alpha = 1; else keyframe1.alpha = keyframeSpec.alpha;
					if(keyframeSpec.tint == null) keyframe1.tintMultiplier = 0; else keyframe1.tintMultiplier = keyframeSpec.tint[0];
					if(keyframeSpec.tint == null) keyframe1.tintColor = 0; else keyframe1.tintColor = Std.parseInt(StringTools.replace(js_Boot.__cast(keyframeSpec.tint[1] , String),"#","0x"));
					keyframe1.data = keyframeSpec.data;
					if(keyframeSpec.ease == null) keyframe1.ease = 0; else keyframe1.ease = keyframeSpec.ease;
				}
				if(layer1.keyframes.length == 0) layer1.firstKeyframe = keyframe1;
				if(keyframeSpec.label != null) {
					keyframe1.label = new flump_library_Label();
					keyframe1.label.keyframe = keyframe1;
					keyframe1.label.name = keyframeSpec.label;
					symbol1.labels.set(keyframe1.label.name,keyframe1.label);
				}
				if(keyframe1.time + keyframe1.duration > layer1.duration) layerDuration = keyframe1.time + keyframe1.duration;
				var v = keyframeSpec.ref;
				pendingSymbolAttachments.set(keyframe1,v);
				v;
				layer1.keyframes.push(keyframe1);
				previousKeyframe = keyframe1;
			}
			layer1.lastKeyframe = layer1.keyframes[layer1.keyframes.length - 1];
			layer1.keyframes[0].prev = layer1.lastKeyframe;
			layer1.lastKeyframe.next = layer1.keyframes[0];
			symbol1.layers.push(layer1);
			var allAreEmpty = Lambda.foreach(layer1.keyframes,(function() {
				return function(keyframe) {
					return keyframe.isEmpty;
				};
			})());
			if(allAreEmpty) {
			} else {
				var _g42 = 0;
				var _g51 = layer1.keyframes;
				while(_g42 < _g51.length) {
					var keyframe2 = [_g51[_g42]];
					++_g42;
					var hasNonEmptySibling = Lambda.exists(layer1.keyframes,(function(keyframe2) {
						return function(checkedKeyframe1) {
							return checkedKeyframe1.isEmpty == false && checkedKeyframe1 != keyframe2[0];
						};
					})(keyframe2));
					if(hasNonEmptySibling) {
						var checked1 = keyframe2[0].prev;
						while(checked1.isEmpty) checked1 = checked1.prev;
						keyframe2[0].prevNonEmptyKeyframe = checked1;
						checked1 = keyframe2[0].next;
						while(checked1.isEmpty) checked1 = checked1.next;
						keyframe2[0].nextNonEmptyKeyframe = checked1;
					} else {
						keyframe2[0].prevNonEmptyKeyframe = keyframe2[0];
						keyframe2[0].nextNonEmptyKeyframe = keyframe2[0];
					}
				}
				var firstNonEmpty = Lambda.find(layer1.keyframes,(function() {
					return function(checkedKeyframe) {
						return checkedKeyframe.isEmpty == false;
					};
				})());
				if(firstNonEmpty != null) firstNonEmpty.displayKey = new flump_DisplayObjectKey(firstNonEmpty.symbolId);
				var checked = firstNonEmpty.nextNonEmptyKeyframe;
				while(checked != firstNonEmpty) {
					if(checked.symbolId == checked.prevNonEmptyKeyframe.symbolId) checked.displayKey = checked.prevNonEmptyKeyframe.displayKey; else checked.displayKey = new flump_DisplayObjectKey(checked.symbolId);
					checked = checked.nextNonEmptyKeyframe;
				}
			}
		}
		var getHighestFrameNumber = (function() {
			return function(layer,accum) {
				var layerLength = layer.lastKeyframe.index + layer.lastKeyframe.numFrames;
				if(_$UInt_UInt_$Impl_$.gt(layerLength,accum)) return layerLength; else return accum;
			};
		})();
		symbol1.totalFrames = Lambda.fold(symbol1.layers,getHighestFrameNumber,0);
		symbol1.duration = _$UInt_UInt_$Impl_$.toFloat(symbol1.totalFrames) * flumpLibrary.frameTime;
		var labels = [];
		var _g23 = 0;
		var _g32 = symbol1.layers;
		while(_g23 < _g32.length) {
			var layer2 = _g32[_g23];
			++_g23;
			var _g43 = 0;
			var _g52 = layer2.keyframes;
			while(_g43 < _g52.length) {
				var keyframe3 = _g52[_g43];
				++_g43;
				if(keyframe3.label != null) labels.push(keyframe3.label);
			}
		}
		haxe_ds_ArraySort.sort(labels,flump_library_FlumpLibrary.sortLabel);
		var _g33 = 0;
		var _g24 = labels.length;
		while(_g33 < _g24) {
			var i = _g33++;
			var nextIndex = i + 1;
			if(nextIndex >= labels.length) nextIndex = 0;
			var label = labels[i];
			var nextLabel = labels[nextIndex];
			label.next = nextLabel;
			nextLabel.prev = label;
		}
		symbol1.firstLabel = labels[0];
		symbol1.lastLabel = labels[labels.length - 1];
		{
			movieSymbols.set(symbol1.name,symbol1);
			symbol1;
		}
	}
	var $it0 = pendingSymbolAttachments.keys();
	while( $it0.hasNext() ) {
		var keyframe4 = $it0.next();
		var symbolId = pendingSymbolAttachments.h[keyframe4.__id__];
		if((__map_reserved[symbolId] != null?spriteSymbols.getReserved(symbolId):spriteSymbols.h[symbolId]) != null) keyframe4.symbol = __map_reserved[symbolId] != null?spriteSymbols.getReserved(symbolId):spriteSymbols.h[symbolId]; else keyframe4.symbol = __map_reserved[symbolId] != null?movieSymbols.getReserved(symbolId):movieSymbols.h[symbolId];
	}
	return flumpLibrary;
};
flump_library_FlumpLibrary.sortLabel = function(a,b) {
	if(_$UInt_UInt_$Impl_$.gt(b.keyframe.index,a.keyframe.index)) return -1; else if(_$UInt_UInt_$Impl_$.gt(a.keyframe.index,b.keyframe.index)) return 1;
	return 0;
};
flump_library_FlumpLibrary.prototype = {
	__class__: flump_library_FlumpLibrary
};
var flump_library_Keyframe = function() {
};
$hxClasses["flump.library.Keyframe"] = flump_library_Keyframe;
flump_library_Keyframe.__name__ = ["flump","library","Keyframe"];
flump_library_Keyframe.prototype = {
	timeInside: function(time) {
		return this.time <= time && this.time + this.duration > time;
	}
	,rangeInside: function(from,to) {
		return this.timeInside(from) && this.timeInside(to);
	}
	,rangeIntersect: function(from,to) {
		return this.timeInside(from) || this.timeInside(to);
	}
	,insideRangeStart: function(from,to) {
		if(from <= to) return this.time > from && this.time <= to; else return this.time > from || this.time <= to;
	}
	,insideRangeEnd: function(from,to) {
		if(from == to && to == this.time + this.duration) return true;
		if(from > to) return to <= this.time + this.duration && from > this.time + this.duration; else return to <= this.time + this.duration || from > this.time + this.duration;
	}
	,__class__: flump_library_Keyframe
};
var flump_library_Label = function() {
};
$hxClasses["flump.library.Label"] = flump_library_Label;
flump_library_Label.__name__ = ["flump","library","Label"];
flump_library_Label.prototype = {
	__class__: flump_library_Label
};
var flump_library_Layer = function(name) {
	this.keyframes = [];
	this.name = name;
};
$hxClasses["flump.library.Layer"] = flump_library_Layer;
flump_library_Layer.__name__ = ["flump","library","Layer"];
flump_library_Layer.prototype = {
	getKeyframeForFrame: function(index) {
		var _g = 0;
		var _g1 = this.keyframes;
		while(_g < _g1.length) {
			var keyframe = _g1[_g];
			++_g;
			if(_$UInt_UInt_$Impl_$.gte(index,keyframe.index) && _$UInt_UInt_$Impl_$.gt(keyframe.index + keyframe.numFrames,index)) return keyframe;
		}
		return null;
	}
	,getKeyframeForTime: function(time) {
		var keyframe = this.lastKeyframe;
		while(keyframe.time > time % this.movie.duration) keyframe = keyframe.prev;
		return keyframe;
	}
	,__class__: flump_library_Layer
};
var flump_library_Symbol = function() {
};
$hxClasses["flump.library.Symbol"] = flump_library_Symbol;
flump_library_Symbol.__name__ = ["flump","library","Symbol"];
flump_library_Symbol.prototype = {
	__class__: flump_library_Symbol
};
var flump_library_MovieSymbol = function() {
	this.labels = new haxe_ds_StringMap();
	this.layers = [];
	flump_library_Symbol.call(this);
};
$hxClasses["flump.library.MovieSymbol"] = flump_library_MovieSymbol;
flump_library_MovieSymbol.__name__ = ["flump","library","MovieSymbol"];
flump_library_MovieSymbol.__super__ = flump_library_Symbol;
flump_library_MovieSymbol.prototype = $extend(flump_library_Symbol.prototype,{
	getLayer: function(name) {
		var _g = 0;
		var _g1 = this.layers;
		while(_g < _g1.length) {
			var layer = _g1[_g];
			++_g;
			if(layer.name == name) return layer;
		}
		return null;
	}
	,debug: function() {
		var largestLayerChars = Lambda.fold(this.layers,function(layer,result) {
			if(layer.name.length > result) return layer.name.length; else return result;
		},0);
		var repeat = function(character,amount) {
			var output = "";
			while(amount > 0) {
				output += character;
				amount--;
			}
			return output;
		};
		var output1 = "asdfsadf\n";
		output1 += repeat(" ",largestLayerChars);
		output1 += "   ";
		var _g1 = 0;
		var _g = this.totalFrames;
		while(_g1 < _g) {
			var i = _g1++;
			if(i % 5 == 0) output1 += i; else if(i % 6 != 0 || i < 10) output1 += " ";
		}
		output1 += "\n";
		output1 += repeat(" ",largestLayerChars);
		output1 += "   ";
		var _g11 = 0;
		var _g2 = this.totalFrames;
		while(_g11 < _g2) {
			var i1 = _g11++;
			if(i1 % 5 == 0) output1 += "▽"; else output1 += " ";
		}
		output1 += "\n";
		var _g12 = 0;
		var _g3 = this.layers.length;
		while(_g12 < _g3) {
			var i2 = _g12++;
			var layer1 = this.layers[i2];
			output1 += layer1.name + repeat(" ",largestLayerChars - layer1.name.length);
			output1 += " : ";
			var _g21 = 0;
			var _g31 = layer1.keyframes;
			while(_g21 < _g31.length) {
				var keyframe = _g31[_g21];
				++_g21;
				if(keyframe.symbolId != null) {
					output1 += "◙";
					if(keyframe.tweened) output1 += repeat("▸",keyframe.numFrames - 1); else output1 += repeat("◉",keyframe.numFrames - 1);
				} else {
					output1 += "○";
					output1 += repeat("◌",keyframe.numFrames - 1);
				}
			}
			output1 += "\n";
		}
		return output1;
	}
	,__class__: flump_library_MovieSymbol
});
var flump_library_Point = function(x,y) {
	this.x = x;
	this.y = y;
};
$hxClasses["flump.library.Point"] = flump_library_Point;
flump_library_Point.__name__ = ["flump","library","Point"];
flump_library_Point.prototype = {
	__class__: flump_library_Point
};
var flump_library_Rectangle = function(x,y,width,height) {
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};
$hxClasses["flump.library.Rectangle"] = flump_library_Rectangle;
flump_library_Rectangle.__name__ = ["flump","library","Rectangle"];
flump_library_Rectangle.prototype = {
	__class__: flump_library_Rectangle
};
var flump_library_SpriteSymbol = function() {
	flump_library_Symbol.call(this);
};
$hxClasses["flump.library.SpriteSymbol"] = flump_library_SpriteSymbol;
flump_library_SpriteSymbol.__name__ = ["flump","library","SpriteSymbol"];
flump_library_SpriteSymbol.__super__ = flump_library_Symbol;
flump_library_SpriteSymbol.prototype = $extend(flump_library_Symbol.prototype,{
	__class__: flump_library_SpriteSymbol
});
var haxe_IMap = function() { };
$hxClasses["haxe.IMap"] = haxe_IMap;
haxe_IMap.__name__ = ["haxe","IMap"];
haxe_IMap.prototype = {
	__class__: haxe_IMap
};
var haxe_Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
$hxClasses["haxe.Http"] = haxe_Http;
haxe_Http.__name__ = ["haxe","Http"];
haxe_Http.prototype = {
	setParameter: function(param,value) {
		this.params = Lambda.filter(this.params,function(p) {
			return p.param != param;
		});
		this.params.push({ param : param, value : value});
		return this;
	}
	,request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js_Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				if (e instanceof js__$Boot_HaxeError) e = e.val;
				s = null;
			}
			if(s != null) {
				var protocol = window.location.protocol.toLowerCase();
				var rlocalProtocol = new EReg("^(?:about|app|app-storage|.+-extension|file|res|widget):$","");
				var isLocal = rlocalProtocol.match(protocol);
				if(isLocal) if(r.responseText != null) s = 200; else s = 404;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var _g_head = this.params.h;
			var _g_val = null;
			while(_g_head != null) {
				var p;
				p = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var _g_head1 = this.headers.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var h1;
			h1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe_Http
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe_Timer;
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_ArraySort = function() { };
$hxClasses["haxe.ds.ArraySort"] = haxe_ds_ArraySort;
haxe_ds_ArraySort.__name__ = ["haxe","ds","ArraySort"];
haxe_ds_ArraySort.sort = function(a,cmp) {
	haxe_ds_ArraySort.rec(a,cmp,0,a.length);
};
haxe_ds_ArraySort.rec = function(a,cmp,from,to) {
	var middle = from + to >> 1;
	if(to - from < 12) {
		if(to <= from) return;
		var _g = from + 1;
		while(_g < to) {
			var i = _g++;
			var j = i;
			while(j > from) {
				if(cmp(a[j],a[j - 1]) < 0) haxe_ds_ArraySort.swap(a,j - 1,j); else break;
				j--;
			}
		}
		return;
	}
	haxe_ds_ArraySort.rec(a,cmp,from,middle);
	haxe_ds_ArraySort.rec(a,cmp,middle,to);
	haxe_ds_ArraySort.doMerge(a,cmp,from,middle,to,middle - from,to - middle);
};
haxe_ds_ArraySort.doMerge = function(a,cmp,from,pivot,to,len1,len2) {
	var first_cut;
	var second_cut;
	var len11;
	var len22;
	var new_mid;
	if(len1 == 0 || len2 == 0) return;
	if(len1 + len2 == 2) {
		if(cmp(a[pivot],a[from]) < 0) haxe_ds_ArraySort.swap(a,pivot,from);
		return;
	}
	if(len1 > len2) {
		len11 = len1 >> 1;
		first_cut = from + len11;
		second_cut = haxe_ds_ArraySort.lower(a,cmp,pivot,to,first_cut);
		len22 = second_cut - pivot;
	} else {
		len22 = len2 >> 1;
		second_cut = pivot + len22;
		first_cut = haxe_ds_ArraySort.upper(a,cmp,from,pivot,second_cut);
		len11 = first_cut - from;
	}
	haxe_ds_ArraySort.rotate(a,cmp,first_cut,pivot,second_cut);
	new_mid = first_cut + len22;
	haxe_ds_ArraySort.doMerge(a,cmp,from,first_cut,new_mid,len11,len22);
	haxe_ds_ArraySort.doMerge(a,cmp,new_mid,second_cut,to,len1 - len11,len2 - len22);
};
haxe_ds_ArraySort.rotate = function(a,cmp,from,mid,to) {
	var n;
	if(from == mid || mid == to) return;
	n = haxe_ds_ArraySort.gcd(to - from,mid - from);
	while(n-- != 0) {
		var val = a[from + n];
		var shift = mid - from;
		var p1 = from + n;
		var p2 = from + n + shift;
		while(p2 != from + n) {
			a[p1] = a[p2];
			p1 = p2;
			if(to - p2 > shift) p2 += shift; else p2 = from + (shift - (to - p2));
		}
		a[p1] = val;
	}
};
haxe_ds_ArraySort.gcd = function(m,n) {
	while(n != 0) {
		var t = m % n;
		m = n;
		n = t;
	}
	return m;
};
haxe_ds_ArraySort.upper = function(a,cmp,from,to,val) {
	var len = to - from;
	var half;
	var mid;
	while(len > 0) {
		half = len >> 1;
		mid = from + half;
		if(cmp(a[val],a[mid]) < 0) len = half; else {
			from = mid + 1;
			len = len - half - 1;
		}
	}
	return from;
};
haxe_ds_ArraySort.lower = function(a,cmp,from,to,val) {
	var len = to - from;
	var half;
	var mid;
	while(len > 0) {
		half = len >> 1;
		mid = from + half;
		if(cmp(a[mid],a[val]) < 0) {
			from = mid + 1;
			len = len - half - 1;
		} else len = half;
	}
	return from;
};
haxe_ds_ArraySort.swap = function(a,i,j) {
	var tmp = a[i];
	a[i] = a[j];
	a[j] = tmp;
};
var haxe_ds_BalancedTree = function() {
};
$hxClasses["haxe.ds.BalancedTree"] = haxe_ds_BalancedTree;
haxe_ds_BalancedTree.__name__ = ["haxe","ds","BalancedTree"];
haxe_ds_BalancedTree.prototype = {
	set: function(key,value) {
		this.root = this.setLoop(key,value,this.root);
	}
	,get: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) return node.value;
			if(c < 0) node = node.left; else node = node.right;
		}
		return null;
	}
	,remove: function(key) {
		try {
			this.root = this.removeLoop(key,this.root);
			return true;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			if( js_Boot.__instanceof(e,String) ) {
				return false;
			} else throw(e);
		}
	}
	,exists: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) return true; else if(c < 0) node = node.left; else node = node.right;
		}
		return false;
	}
	,keys: function() {
		var ret = [];
		this.keysLoop(this.root,ret);
		return HxOverrides.iter(ret);
	}
	,setLoop: function(k,v,node) {
		if(node == null) return new haxe_ds_TreeNode(null,k,v,null);
		var c = this.compare(k,node.key);
		if(c == 0) return new haxe_ds_TreeNode(node.left,k,v,node.right,node == null?0:node._height); else if(c < 0) {
			var nl = this.setLoop(k,v,node.left);
			return this.balance(nl,node.key,node.value,node.right);
		} else {
			var nr = this.setLoop(k,v,node.right);
			return this.balance(node.left,node.key,node.value,nr);
		}
	}
	,removeLoop: function(k,node) {
		if(node == null) throw new js__$Boot_HaxeError("Not_found");
		var c = this.compare(k,node.key);
		if(c == 0) return this.merge(node.left,node.right); else if(c < 0) return this.balance(this.removeLoop(k,node.left),node.key,node.value,node.right); else return this.balance(node.left,node.key,node.value,this.removeLoop(k,node.right));
	}
	,keysLoop: function(node,acc) {
		if(node != null) {
			this.keysLoop(node.left,acc);
			acc.push(node.key);
			this.keysLoop(node.right,acc);
		}
	}
	,merge: function(t1,t2) {
		if(t1 == null) return t2;
		if(t2 == null) return t1;
		var t = this.minBinding(t2);
		return this.balance(t1,t.key,t.value,this.removeMinBinding(t2));
	}
	,minBinding: function(t) {
		if(t == null) throw new js__$Boot_HaxeError("Not_found"); else if(t.left == null) return t; else return this.minBinding(t.left);
	}
	,removeMinBinding: function(t) {
		if(t.left == null) return t.right; else return this.balance(this.removeMinBinding(t.left),t.key,t.value,t.right);
	}
	,balance: function(l,k,v,r) {
		var hl;
		if(l == null) hl = 0; else hl = l._height;
		var hr;
		if(r == null) hr = 0; else hr = r._height;
		if(hl > hr + 2) {
			if((function($this) {
				var $r;
				var _this = l.left;
				$r = _this == null?0:_this._height;
				return $r;
			}(this)) >= (function($this) {
				var $r;
				var _this1 = l.right;
				$r = _this1 == null?0:_this1._height;
				return $r;
			}(this))) return new haxe_ds_TreeNode(l.left,l.key,l.value,new haxe_ds_TreeNode(l.right,k,v,r)); else return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l.left,l.key,l.value,l.right.left),l.right.key,l.right.value,new haxe_ds_TreeNode(l.right.right,k,v,r));
		} else if(hr > hl + 2) {
			if((function($this) {
				var $r;
				var _this2 = r.right;
				$r = _this2 == null?0:_this2._height;
				return $r;
			}(this)) > (function($this) {
				var $r;
				var _this3 = r.left;
				$r = _this3 == null?0:_this3._height;
				return $r;
			}(this))) return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l,k,v,r.left),r.key,r.value,r.right); else return new haxe_ds_TreeNode(new haxe_ds_TreeNode(l,k,v,r.left.left),r.left.key,r.left.value,new haxe_ds_TreeNode(r.left.right,r.key,r.value,r.right));
		} else return new haxe_ds_TreeNode(l,k,v,r,(hl > hr?hl:hr) + 1);
	}
	,compare: function(k1,k2) {
		return Reflect.compare(k1,k2);
	}
	,__class__: haxe_ds_BalancedTree
};
var haxe_ds_TreeNode = function(l,k,v,r,h) {
	if(h == null) h = -1;
	this.left = l;
	this.key = k;
	this.value = v;
	this.right = r;
	if(h == -1) this._height = ((function($this) {
		var $r;
		var _this = $this.left;
		$r = _this == null?0:_this._height;
		return $r;
	}(this)) > (function($this) {
		var $r;
		var _this1 = $this.right;
		$r = _this1 == null?0:_this1._height;
		return $r;
	}(this))?(function($this) {
		var $r;
		var _this2 = $this.left;
		$r = _this2 == null?0:_this2._height;
		return $r;
	}(this)):(function($this) {
		var $r;
		var _this3 = $this.right;
		$r = _this3 == null?0:_this3._height;
		return $r;
	}(this))) + 1; else this._height = h;
};
$hxClasses["haxe.ds.TreeNode"] = haxe_ds_TreeNode;
haxe_ds_TreeNode.__name__ = ["haxe","ds","TreeNode"];
haxe_ds_TreeNode.prototype = {
	__class__: haxe_ds_TreeNode
};
var haxe_ds_EnumValueMap = function() {
	haxe_ds_BalancedTree.call(this);
};
$hxClasses["haxe.ds.EnumValueMap"] = haxe_ds_EnumValueMap;
haxe_ds_EnumValueMap.__name__ = ["haxe","ds","EnumValueMap"];
haxe_ds_EnumValueMap.__interfaces__ = [haxe_IMap];
haxe_ds_EnumValueMap.__super__ = haxe_ds_BalancedTree;
haxe_ds_EnumValueMap.prototype = $extend(haxe_ds_BalancedTree.prototype,{
	compare: function(k1,k2) {
		var d = k1[1] - k2[1];
		if(d != 0) return d;
		var p1 = k1.slice(2);
		var p2 = k2.slice(2);
		if(p1.length == 0 && p2.length == 0) return 0;
		return this.compareArgs(p1,p2);
	}
	,compareArgs: function(a1,a2) {
		var ld = a1.length - a2.length;
		if(ld != 0) return ld;
		var _g1 = 0;
		var _g = a1.length;
		while(_g1 < _g) {
			var i = _g1++;
			var d = this.compareArg(a1[i],a2[i]);
			if(d != 0) return d;
		}
		return 0;
	}
	,compareArg: function(v1,v2) {
		if(Reflect.isEnumValue(v1) && Reflect.isEnumValue(v2)) return this.compare(v1,v2); else if((v1 instanceof Array) && v1.__enum__ == null && ((v2 instanceof Array) && v2.__enum__ == null)) return this.compareArgs(v1,v2); else return Reflect.compare(v1,v2);
	}
	,__class__: haxe_ds_EnumValueMap
});
var haxe_ds_IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe_ds_IntMap;
haxe_ds_IntMap.__name__ = ["haxe","ds","IntMap"];
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,toString: function() {
		var s_b = "";
		s_b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			if(i == null) s_b += "null"; else s_b += "" + i;
			s_b += " => ";
			s_b += Std.string(Std.string(this.h[i]));
			if(it.hasNext()) s_b += ", ";
		}
		s_b += "}";
		return s_b;
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
$hxClasses["haxe.ds.ObjectMap"] = haxe_ds_ObjectMap;
haxe_ds_ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe_ds_ObjectMap.__interfaces__ = [haxe_IMap];
haxe_ds_ObjectMap.prototype = {
	set: function(key,value) {
		var id = key.__id__ || (key.__id__ = ++haxe_ds_ObjectMap.count);
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,exists: function(key) {
		return this.h.__keys__[key.__id__] != null;
	}
	,remove: function(key) {
		var id = key.__id__;
		if(this.h.__keys__[id] == null) return false;
		delete(this.h[id]);
		delete(this.h.__keys__[id]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i.__id__];
		}};
	}
	,__class__: haxe_ds_ObjectMap
};
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
$hxClasses["haxe.ds._StringMap.StringMapIterator"] = haxe_ds__$StringMap_StringMapIterator;
haxe_ds__$StringMap_StringMapIterator.__name__ = ["haxe","ds","_StringMap","StringMapIterator"];
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		return this.map.get(this.keys[this.index++]);
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe_ds_StringMap;
haxe_ds_StringMap.__name__ = ["haxe","ds","StringMap"];
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,exists: function(key) {
		if(__map_reserved[key] != null) return this.existsReserved(key);
		return this.h.hasOwnProperty(key);
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		if(__map_reserved[key] != null) {
			key = "$" + key;
			if(this.rh == null || !this.rh.hasOwnProperty(key)) return false;
			delete(this.rh[key]);
			return true;
		} else {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
	}
	,keys: function() {
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var haxe_xml_Parser = function() { };
$hxClasses["haxe.xml.Parser"] = haxe_xml_Parser;
haxe_xml_Parser.__name__ = ["haxe","xml","Parser"];
haxe_xml_Parser.parse = function(str,strict) {
	if(strict == null) strict = false;
	var doc = Xml.createDocument();
	haxe_xml_Parser.doParse(str,strict,0,doc);
	return doc;
};
haxe_xml_Parser.doParse = function(str,strict,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	var escapeNext = 1;
	var attrValQuote = -1;
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				buf.addSub(str,start,p - start);
				var child = Xml.createPCData(buf.b);
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				escapeNext = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw new js__$Boot_HaxeError("Expected <![CDATA[");
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw new js__$Boot_HaxeError("Expected <!DOCTYPE");
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw new js__$Boot_HaxeError("Expected <!--"); else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw new js__$Boot_HaxeError("Expected node name");
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw new js__$Boot_HaxeError("Expected node name");
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				nsubs++;
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				break;
			case 62:
				state = 9;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw new js__$Boot_HaxeError("Expected attribute name");
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw new js__$Boot_HaxeError("Duplicate attribute");
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected =");
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				buf = new StringBuf();
				state = 8;
				start = p + 1;
				attrValQuote = c;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected \"");
			}
			break;
		case 8:
			switch(c) {
			case 38:
				buf.addSub(str,start,p - start);
				state = 18;
				escapeNext = 8;
				start = p + 1;
				break;
			case 62:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val = buf.b;
					buf = new StringBuf();
					xml.set(aname,val);
					state = 0;
					next = 4;
				}
				break;
			case 60:
				if(strict) throw new js__$Boot_HaxeError("Invalid unescaped " + String.fromCharCode(c) + " in attribute value"); else if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val1 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val1);
					state = 0;
					next = 4;
				}
				break;
			default:
				if(c == attrValQuote) {
					buf.addSub(str,start,p - start);
					var val2 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val2);
					state = 0;
					next = 4;
				}
			}
			break;
		case 9:
			p = haxe_xml_Parser.doParse(str,strict,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw new js__$Boot_HaxeError("Expected >");
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw new js__$Boot_HaxeError("Expected node name");
				var v = HxOverrides.substr(str,start,p - start);
				if(v != (function($this) {
					var $r;
					if(parent.nodeType != Xml.Element) throw new js__$Boot_HaxeError("Bad node type, expected Element but found " + parent.nodeType);
					$r = parent.nodeName;
					return $r;
				}(this))) throw new js__$Boot_HaxeError("Expected </" + (function($this) {
					var $r;
					if(parent.nodeType != Xml.Element) throw "Bad node type, expected Element but found " + parent.nodeType;
					$r = parent.nodeName;
					return $r;
				}(this)) + ">");
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				var xml1 = Xml.createComment(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				var xml2 = Xml.createDocType(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml2);
				nsubs++;
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				var xml3 = Xml.createProcessingInstruction(str1);
				parent.addChild(xml3);
				nsubs++;
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var c1;
					if(s.charCodeAt(1) == 120) c1 = Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)); else c1 = Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += String.fromCharCode(c1);
				} else if(!haxe_xml_Parser.escapes.exists(s)) {
					if(strict) throw new js__$Boot_HaxeError("Undefined entity: " + s);
					buf.b += Std.string("&" + s + ";");
				} else buf.add(haxe_xml_Parser.escapes.get(s));
				start = p + 1;
				state = escapeNext;
			} else if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45) && c != 35) {
				if(strict) throw new js__$Boot_HaxeError("Invalid character in entity: " + String.fromCharCode(c));
				buf.b += "&";
				buf.addSub(str,start,p - start);
				p--;
				start = p + 1;
				state = escapeNext;
			}
			break;
		}
		c = StringTools.fastCodeAt(str,++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) {
			buf.addSub(str,start,p - start);
			var xml4 = Xml.createPCData(buf.b);
			parent.addChild(xml4);
			nsubs++;
		}
		return p;
	}
	if(!strict && state == 18 && escapeNext == 13) {
		buf.b += "&";
		buf.addSub(str,start,p - start);
		var xml5 = Xml.createPCData(buf.b);
		parent.addChild(xml5);
		nsubs++;
		return p;
	}
	throw new js__$Boot_HaxeError("Unexpected end");
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
$hxClasses["js._Boot.HaxeError"] = js__$Boot_HaxeError;
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
$hxClasses["js.Boot"] = js_Boot;
js_Boot.__name__ = ["js","Boot"];
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Browser = function() { };
$hxClasses["js.Browser"] = js_Browser;
js_Browser.__name__ = ["js","Browser"];
js_Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
js_Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw new js__$Boot_HaxeError("Unable to create XMLHttpRequest object.");
};
js_Browser.alert = function(v) {
	window.alert(js_Boot.__string_rec(v,""));
};
var pixi_flump_Factory = function() { };
$hxClasses["pixi.flump.Factory"] = pixi_flump_Factory;
pixi_flump_Factory.__name__ = ["pixi","flump","Factory"];
pixi_flump_Factory.prototype = {
	__class__: pixi_flump_Factory
};
var pixi_flump_Movie = function(symbolId,resourceId) {
	this.animationSpeed = 1.0;
	this.ticker = PIXI.ticker.shared;
	this.displaying = new haxe_ds_ObjectMap();
	this.movieChildren = new haxe_ds_ObjectMap();
	this.layerLookup = new haxe_ds_StringMap();
	this.layers = new haxe_ds_ObjectMap();
	PIXI.Container.call(this);
	this.resourceId = resourceId;
	if(resourceId == null) {
		this.resource = pixi_flump_Resource.getResourceForMovie(symbolId);
		if(this.resource == null) throw new js__$Boot_HaxeError("Flump movie does not exist: " + symbolId);
	} else {
		this.resource = pixi_flump_Resource.get(resourceId);
		if(this.resource == null) throw new js__$Boot_HaxeError("Flump resource does not exist: " + resourceId);
	}
	this.resolution = this.resource.resolution;
	this.symbol = this.resource.library.movies.get(symbolId);
	this.player = new flump_MoviePlayer(this.symbol,this,this.resolution);
	this.set_loop(true);
	this.master = true;
	this.once("added",$bind(this,this.onAdded));
};
$hxClasses["pixi.flump.Movie"] = pixi_flump_Movie;
pixi_flump_Movie.__name__ = ["pixi","flump","Movie"];
pixi_flump_Movie.__interfaces__ = [flump_IFlumpMovie];
pixi_flump_Movie.__super__ = PIXI.Container;
pixi_flump_Movie.prototype = $extend(PIXI.Container.prototype,{
	disableAsMaster: function() {
		this.master = false;
		this.off("added",$bind(this,this.onAdded));
	}
	,get_resX: function() {
		return this.x / this.resolution;
	}
	,set_resX: function(value) {
		this.x = value * this.resolution;
		return value;
	}
	,get_resY: function() {
		return this.y / this.resolution;
	}
	,set_resY: function(value) {
		this.y = value * this.resolution;
		return value;
	}
	,get_resScaleX: function() {
		return this.scale.x / this.resolution;
	}
	,set_resScaleX: function(value) {
		this.scale.x = value * this.resolution;
		return value;
	}
	,get_resScaleY: function() {
		return this.scale.y / this.resolution;
	}
	,set_resScaleY: function(value) {
		this.scale.y = value * this.resolution;
		return value;
	}
	,getLayer: function(layerId) {
		if(this.layerLookup.exists(layerId) == false) throw new js__$Boot_HaxeError("Layer " + layerId + "does not exist");
		return this.layerLookup.get(layerId);
	}
	,getChildDisplayObject: function(layerId,keyframeIndex) {
		if(keyframeIndex == null) keyframeIndex = 0;
		var key = this.player.getDisplayKey(layerId,keyframeIndex);
		return this.movieChildren.h[key.__id__];
	}
	,getChildMovie: function(layerId,keyframeIndex) {
		if(keyframeIndex == null) keyframeIndex = 0;
		var child = this.getChildDisplayObject(layerId,keyframeIndex);
		if(js_Boot.__instanceof(child,pixi_flump_Movie) == false) throw new js__$Boot_HaxeError("Child on layer " + layerId + " at keyframeIndex " + Std.string(_$UInt_UInt_$Impl_$.toFloat(keyframeIndex)) + " is not of type flump.Movie!");
		return child;
	}
	,get_symbolId: function() {
		return this.symbol.name;
	}
	,set_loop: function(value) {
		if(value && this.player.get_playing()) this.player.loop(); else if(value == false && this.player.get_looping()) this.player.play();
		return this.loop = value;
	}
	,set_onComplete: function(value) {
		return this.onComplete = value;
	}
	,set_currentFrame: function(value) {
		this.player.set_currentFrame(value);
		return value;
	}
	,get_currentFrame: function() {
		return this.player.get_currentFrame();
	}
	,get_playing: function() {
		return this.player.get_playing() || this.player.get_looping();
	}
	,get_independantTimeline: function() {
		return this.player.independantTimeline;
	}
	,set_independantTimeline: function(value) {
		this.player.independantTimeline = value;
		return value;
	}
	,get_independantControl: function() {
		return this.player.independantControl;
	}
	,set_independantControl: function(value) {
		this.player.independantControl = value;
		return value;
	}
	,get_totalFrames: function() {
		return this.player.get_totalFrames();
	}
	,set_tint: function(pTint) {
		var $it0 = this.movieChildren.iterator();
		while( $it0.hasNext() ) {
			var child = $it0.next();
			if(js_Boot.__instanceof(child,pixi_flump_Sprite)) (js_Boot.__cast(child , pixi_flump_Sprite)).tint = pTint; else if(js_Boot.__instanceof(child,pixi_flump_Movie)) (js_Boot.__cast(child , pixi_flump_Movie)).set_tint(pTint);
		}
		return this.tint = pTint;
	}
	,stop: function() {
		this.player.stop();
	}
	,play: function() {
		if(this.loop) this.player.loop(); else this.player.play();
	}
	,gotoAndStop: function(frameNumber) {
		if(!this.loop) {
			if(_$UInt_UInt_$Impl_$.gt(frameNumber,(function($this) {
				var $r;
				var a = $this.player.get_totalFrames();
				$r = a - 1;
				return $r;
			}(this)))) {
				var a1 = this.player.get_totalFrames();
				frameNumber = a1 - 1;
			} else if(frameNumber < 0) frameNumber = 0;
		}
		this.player.goToFrame(frameNumber).stop();
	}
	,gotoAndPlay: function(frameNumber) {
		if(!this.loop) {
			if(_$UInt_UInt_$Impl_$.gt(frameNumber,(function($this) {
				var $r;
				var a = $this.player.get_totalFrames();
				$r = a - 1;
				return $r;
			}(this)))) {
				var a1 = this.player.get_totalFrames();
				frameNumber = a1 - 1;
			} else if(frameNumber < 0) frameNumber = 0;
		}
		if(this.loop) this.player.goToFrame(frameNumber).loop(); else this.player.goToFrame(frameNumber).play();
	}
	,getLabelFrame: function(label) {
		return this.player.getLabelFrame(label);
	}
	,tick: function() {
		this.player.advanceTime(this.ticker.elapsedMS * this.animationSpeed);
	}
	,onAdded: function(to) {
		this.once("removed",$bind(this,this.onRemoved));
		this.ticker.add($bind(this,this.tick));
	}
	,onRemoved: function(from) {
		this.once("added",$bind(this,this.onAdded));
		this.ticker.remove($bind(this,this.tick));
	}
	,createLayer: function(layer) {
		var v = new PIXI.Container();
		this.layers.set(layer,v);
		v;
		this.layers.h[layer.__id__].name = layer.name;
		var v1 = this.layers.h[layer.__id__];
		this.layerLookup.set(layer.name,v1);
		v1;
		this.addChild(this.layers.h[layer.__id__]);
	}
	,getChildPlayer: function(keyframe) {
		var movie = this.movieChildren.h[keyframe.displayKey.__id__];
		return movie.player;
	}
	,createFlumpChild: function(displayKey) {
		var v = this.resource.createDisplayObject(displayKey.symbolId);
		this.movieChildren.set(displayKey,v);
		v;
	}
	,removeFlumpChild: function(layer,displayKey) {
		var layer1 = this.layers.h[layer.__id__];
		layer1.removeChildren();
	}
	,addFlumpChild: function(layer,displayKey) {
		var layer1 = this.layers.h[layer.__id__];
		layer1.addChild(this.movieChildren.h[displayKey.__id__]);
	}
	,onAnimationComplete: function() {
		if(this.onComplete != null) this.onComplete();
	}
	,renderFrame: function(keyframe,x,y,scaleX,scaleY,skewX,skewY,alpha,tintMultiplier,tintColor) {
		var layer = this.layers.h[keyframe.layer.__id__];
		var lChild = null;
		var spriteSymbol = null;
		layer.x = x;
		layer.y = y;
		if(this.master) {
			layer.x /= this.resolution;
			layer.y /= this.resolution;
		}
		if(layer.children.length > 0) {
			lChild = layer.getChildAt(0);
			lChild.scale.x = scaleX;
			lChild.scale.y = scaleY;
			if(this.master) {
				lChild.scale.x /= this.resolution;
				lChild.scale.y /= this.resolution;
			}
		}
		if(layer.name != "flipbook") {
			if(js_Boot.__instanceof(keyframe.symbol,flump_library_SpriteSymbol)) {
				if(lChild != null) {
					spriteSymbol = keyframe.symbol;
					lChild.pivot.x = keyframe.pivot.x - spriteSymbol.origin.x;
					lChild.pivot.y = keyframe.pivot.y - spriteSymbol.origin.y;
					if(this.master) {
						lChild.pivot.x /= this.resolution;
						lChild.pivot.y /= this.resolution;
					}
				}
			} else if(lChild != null && js_Boot.__instanceof(lChild,PIXI.Container) && (js_Boot.__cast(lChild , PIXI.Container)).children.length > 0 && (js_Boot.__cast(lChild , PIXI.Container)).getChildAt(0).name == "flipbook") {
				lChild.pivot.x = keyframe.pivot.x;
				lChild.pivot.y = keyframe.pivot.y;
				if(this.master) {
					lChild.pivot.x /= this.resolution;
					lChild.pivot.y /= this.resolution;
				}
			} else if(lChild != null) {
				lChild.x = -scaleX * keyframe.pivot.x;
				lChild.y = -scaleY * keyframe.pivot.y;
				if(this.master) {
					lChild.x /= this.resolution;
					lChild.y /= this.resolution;
				}
			}
		}
		layer.skew.x = skewX;
		layer.skew.y = skewY;
		layer.alpha = alpha;
		if(keyframe.layer.refAnimatedTint == null) keyframe.layer.refAnimatedTint = new flump_filters_AnimateTintFilter(tintColor,tintMultiplier); else keyframe.layer.refAnimatedTint.update(tintColor,tintMultiplier);
		if(tintMultiplier != 0) layer.filters = [keyframe.layer.refAnimatedTint]; else if(layer.filters != null) layer.filters = null;
	}
	,setMask: function(layer) {
		if(layer.mask != null) {
			var lRect = this.getLayer(layer.mask).getChildAt(0).getBounds();
			this.getLayer(layer.mask).removeChildAt(0);
			var lGraph = new PIXI.Graphics();
			lGraph.beginFill(0);
			lGraph.drawRect(lRect.x,lRect.y,lRect.width,lRect.height);
			lGraph.endFill();
			this.getLayer(layer.mask).addChild(lGraph);
			this.layers.h[layer.__id__].mask = lGraph;
		}
	}
	,labelPassed: function(label) {
		this.emit("labelPassed",label.name);
	}
	,labelHit: function(label) {
		this.emit("labelHit",label.name);
	}
	,destroy: function() {
		this.stop();
		this.set_onComplete(null);
		var $it0 = this.layers.iterator();
		while( $it0.hasNext() ) {
			var layer = $it0.next();
			layer.removeChildren();
		}
		this.symbol = null;
		this.player = null;
		PIXI.Container.prototype.destroy.call(this,true);
	}
	,getBaseClass: function() {
		return this.symbol.baseClass;
	}
	,getCustomData: function() {
		return this.symbol.data;
	}
	,getLayerCustomData: function(layerId,keyframeIndex) {
		if(keyframeIndex == null) keyframeIndex = 0;
		var layer = this.symbol.getLayer(layerId);
		if(layer == null) throw new js__$Boot_HaxeError("Layer " + layerId + " does not exist.");
		var keyframe = this.symbol.getLayer(layerId).getKeyframeForFrame(keyframeIndex);
		if(keyframe == null) throw new js__$Boot_HaxeError("Keyframe does not exist at index " + Std.string(_$UInt_UInt_$Impl_$.toFloat(keyframeIndex)));
		return keyframe.data;
	}
	,__class__: pixi_flump_Movie
});
var pixi_flump_Parser = function() { };
$hxClasses["pixi.flump.Parser"] = pixi_flump_Parser;
pixi_flump_Parser.__name__ = ["pixi","flump","Parser"];
pixi_flump_Parser.parse = function(resolution,loadFromCache) {
	if(loadFromCache == null) loadFromCache = true;
	return function(resource,next) {
		if(resource.data == null || resource.isJson == false) return;
		if(!Object.prototype.hasOwnProperty.call(resource.data,"md5") || !Object.prototype.hasOwnProperty.call(resource.data,"movies") || !Object.prototype.hasOwnProperty.call(resource.data,"textureGroups") || !Object.prototype.hasOwnProperty.call(resource.data,"frameRate")) return;
		var lib = flump_library_FlumpLibrary.create(resource.data,resolution);
		var textures = new haxe_ds_StringMap();
		var atlasLoader = new PIXI.loaders.Loader();
		atlasLoader.baseUrl = new EReg("/(.[^/]*)$","i").replace(resource.url,"");
		var _g = 0;
		var _g1 = lib.atlases;
		while(_g < _g1.length) {
			var atlasSpec = [_g1[_g]];
			++_g;
			if(loadFromCache) atlasSpec[0].file += ""; else atlasSpec[0].file += "?" + new Date().getTime();
			atlasLoader.add(atlasSpec[0].file,null,(function(atlasSpec) {
				return function(atlasResource) {
					var atlasTexture = new PIXI.BaseTexture(atlasResource.data);
					atlasTexture.resolution = resolution;
					var _g2 = 0;
					var _g3 = atlasSpec[0].textures;
					while(_g2 < _g3.length) {
						var textureSpec = _g3[_g2];
						++_g2;
						var frame = new PIXI.Rectangle(textureSpec.rect[0],textureSpec.rect[1],textureSpec.rect[2],textureSpec.rect[3]);
						var origin = new PIXI.Point(textureSpec.origin[0],textureSpec.origin[1]);
						origin.x = origin.x / frame.width;
						origin.y = origin.y / frame.height;
						var v = new PIXI.Texture(atlasTexture,frame);
						textures.set(textureSpec.symbol,v);
						v;
					}
				};
			})(atlasSpec));
		}
		atlasLoader.once("complete",function(loader) {
			var flumpResource = new pixi_flump_Resource(lib,textures,resource.name,resolution);
			if(resource.name != null) {
				pixi_flump_Resource.resources.set(resource.name,flumpResource);
				flumpResource;
			}
			resource.data = flumpResource;
			next();
		});
		atlasLoader.load();
	};
};
var pixi_flump_Resource = function(library,textures,resourceId,resolution) {
	this.library = library;
	this.textures = textures;
	this.resourceId = resourceId;
	this.resolution = resolution;
};
$hxClasses["pixi.flump.Resource"] = pixi_flump_Resource;
pixi_flump_Resource.__name__ = ["pixi","flump","Resource"];
pixi_flump_Resource.exists = function(resourceName) {
	return pixi_flump_Resource.resources.exists(resourceName);
};
pixi_flump_Resource.destroy = function(resourceName) {
	if(pixi_flump_Resource.resources.exists(resourceName) == false) throw new js__$Boot_HaxeError("Cannot destroy FlumpResource: " + resourceName + " as it does not exist.");
	var resource = pixi_flump_Resource.resources.get(resourceName);
	var $it0 = resource.textures.iterator();
	while( $it0.hasNext() ) {
		var texture = $it0.next();
		texture.destroy();
	}
	resource.library = null;
	pixi_flump_Resource.resources.remove(resourceName);
};
pixi_flump_Resource.get = function(resourceName) {
	if(!pixi_flump_Resource.resources.exists(resourceName)) throw new js__$Boot_HaxeError("Flump resource: " + resourceName + " does not exist.");
	return pixi_flump_Resource.resources.get(resourceName);
};
pixi_flump_Resource.getResourceForMovie = function(symbolId) {
	var $it0 = pixi_flump_Resource.resources.iterator();
	while( $it0.hasNext() ) {
		var resource = $it0.next();
		if(resource.library.movies.exists(symbolId)) return resource;
	}
	throw new js__$Boot_HaxeError("Movie: " + symbolId + "does not exists in any loaded flump resources.");
};
pixi_flump_Resource.getResourceForSprite = function(symbolId) {
	var $it0 = pixi_flump_Resource.resources.iterator();
	while( $it0.hasNext() ) {
		var resource = $it0.next();
		if(resource.library.sprites.exists(symbolId)) return resource;
	}
	throw new js__$Boot_HaxeError("Sprite: " + symbolId + " does not exists in any loaded flump resources.");
};
pixi_flump_Resource.prototype = {
	createMovie: function(id) {
		var movie;
		if(pixi_flump_Resource.flumpFactory != null && pixi_flump_Resource.flumpFactory.displayClassExists(id)) movie = Type.createInstance(pixi_flump_Resource.flumpFactory.getMovieClass(id),[]); else movie = new pixi_flump_Movie(id,this.resourceId);
		movie.disableAsMaster();
		return movie;
	}
	,createSprite: function(id) {
		if(pixi_flump_Resource.flumpFactory != null && pixi_flump_Resource.flumpFactory.displayClassExists(id)) return Type.createInstance(pixi_flump_Resource.flumpFactory.getSpriteClass(id),[]); else return new pixi_flump_Sprite(id,this.resourceId);
	}
	,createDisplayObject: function(id) {
		var displayObject;
		if(this.library.movies.exists(id)) displayObject = this.createMovie(id); else displayObject = this.createSprite(id);
		displayObject.name = id;
		return displayObject;
	}
	,__class__: pixi_flump_Resource
};
var pixi_flump_Sprite = function(symbolId,resourceId) {
	this.symbolId = symbolId;
	this.resourceId = resourceId;
	var resource;
	if(resourceId != null) {
		resource = pixi_flump_Resource.get(resourceId);
		if(resource == null) throw new js__$Boot_HaxeError("Library: " + resourceId + "does has not been loaded.");
	} else resource = pixi_flump_Resource.getResourceForSprite(symbolId);
	this.resolution = resource.resolution;
	var symbol = resource.library.sprites.get(symbolId);
	var texture = resource.textures.get(symbol.texture);
	PIXI.Sprite.call(this,texture);
	this.data = symbol.data;
	this.baseClass = symbol.baseClass;
	this.anchor.x = symbol.origin.x / texture.width;
	this.anchor.y = symbol.origin.y / texture.height;
};
$hxClasses["pixi.flump.Sprite"] = pixi_flump_Sprite;
pixi_flump_Sprite.__name__ = ["pixi","flump","Sprite"];
pixi_flump_Sprite.__super__ = PIXI.Sprite;
pixi_flump_Sprite.prototype = $extend(PIXI.Sprite.prototype,{
	get_resX: function() {
		return this.x / this.resolution;
	}
	,set_resX: function(value) {
		this.x = value * this.resolution;
		return value;
	}
	,get_resY: function() {
		return this.y / this.resolution;
	}
	,set_resY: function(value) {
		this.y = value * this.resolution;
		return value;
	}
	,get_resScaleX: function() {
		return this.scale.x / this.resolution;
	}
	,set_resScaleX: function(value) {
		this.scale.x = value * this.resolution;
		return value;
	}
	,get_resScaleY: function() {
		return this.scale.y / this.resolution;
	}
	,set_resScaleY: function(value) {
		this.scale.y = value * this.resolution;
		return value;
	}
	,getBaseClass: function() {
		return this.baseClass;
	}
	,getCustomData: function() {
		return this.data;
	}
	,__class__: pixi_flump_Sprite
});
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
$hxClasses.Math = Math;
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
$hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var __map_reserved = {}
Perf.MEASUREMENT_INTERVAL = 1000;
Perf.FONT_FAMILY = "Helvetica,Arial";
Perf.FPS_BG_CLR = "#00FF00";
Perf.FPS_WARN_BG_CLR = "#FF8000";
Perf.FPS_PROB_BG_CLR = "#FF0000";
Perf.MS_BG_CLR = "#FFFF00";
Perf.MEM_BG_CLR = "#086A87";
Perf.INFO_BG_CLR = "#00FFFF";
Perf.FPS_TXT_CLR = "#000000";
Perf.MS_TXT_CLR = "#000000";
Perf.MEM_TXT_CLR = "#FFFFFF";
Perf.INFO_TXT_CLR = "#000000";
Perf.TOP_LEFT = "TL";
Perf.TOP_RIGHT = "TR";
Perf.BOTTOM_LEFT = "BL";
Perf.BOTTOM_RIGHT = "BR";
Perf.DELAY_TIME = 4000;
Xml.Element = 0;
Xml.PCData = 1;
Xml.CData = 2;
Xml.Comment = 3;
Xml.DocType = 4;
Xml.ProcessingInstruction = 5;
Xml.Document = 6;
com_isartdigital_perle_Main.JSON_FOLDER = "json/";
com_isartdigital_perle_Main.JSON_EXTENSION = ".json";
com_isartdigital_perle_Main.DIALOGUE_FTUE_JSON_NAME = "json/" + "dialogue_ftue";
com_isartdigital_perle_Main.FTUE_JSON_NAME = "json/" + "FTUE" + ".json";
com_isartdigital_perle_Main.EXPERIENCE_JSON_NAME = "json/" + "experience";
com_isartdigital_perle_Main.UNLOCK_ITEM_JSON_NAME = "json/" + "item_to_unlock";
com_isartdigital_perle_Main.PRICE_JSON_NAME = "json/" + "buy_price" + ".json";
com_isartdigital_perle_Main.GAME_CONFIG = "json/" + "game_config" + ".json";
com_isartdigital_perle_Main.UI_FOLDER = "UI/";
com_isartdigital_perle_Main.IN_GAME_FOLDER = "InGame/";
com_isartdigital_perle_Main.FACEBOOK_APP_ID = "1764871347166484";
com_isartdigital_perle_Main.FPS = 16;
com_isartdigital_perle_Main.configPath = "config.json";
com_isartdigital_perle_game_AssetName.BUILDING_STYX_PURGATORY = "Tribunal";
com_isartdigital_perle_game_AssetName.BUILDING_STYX_VIRTUE = "Altar_Virtue";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_HOUSE = "HeavenBuild0";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_HOUSE_LEVEL2 = "HeavenBuild1";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_HOUSE_LEVEL3 = "HeavenBuild2";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_BRIDGE = "HeavenBuild3";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL1 = "HeavenLumberMill01";
com_isartdigital_perle_game_AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL2 = "HeavenLumberMill02";
com_isartdigital_perle_game_AssetName.BUILDING_HELL_HOUSE = "hellBuilding";
com_isartdigital_perle_game_AssetName.BUILDING_HELL_HOUSE_LEVEL2 = "hellBuilding2";
com_isartdigital_perle_game_AssetName.BUILDING_HELL_HOUSE_LEVEL3 = "hellBuilding3";
com_isartdigital_perle_game_AssetName.BUILDING_HELL_COLLECTOR_LEVEL1 = "Hell_Quarry";
com_isartdigital_perle_game_AssetName.DECO_HEAVEN_TREE_1 = "Paradis_Arbre01_P";
com_isartdigital_perle_game_AssetName.DECO_HEAVEN_TREE_2 = "Paradis_Arbre02_P";
com_isartdigital_perle_game_AssetName.DECO_HEAVEN_TREE_3 = "Paradis_Arbre03_P";
com_isartdigital_perle_game_AssetName.DECO_HEAVEN_FOUNTAIN = "heavenBuild4";
com_isartdigital_perle_game_AssetName.DECO_HEAVEN_ROCK = "Paradis_Rocher_P";
com_isartdigital_perle_game_AssetName.DECO_HELL_TREE_1 = "Enfer_Arbre01_P";
com_isartdigital_perle_game_AssetName.DECO_HELL_TREE_2 = "Enfer_Arbre02_P";
com_isartdigital_perle_game_AssetName.DECO_HELL_TREE_3 = "Enfer_Arbre03_P";
com_isartdigital_perle_game_AssetName.DECO_HELL_ROCK = "Enfer_Rocher_P";
com_isartdigital_perle_game_AssetName.POPIN_CONFIRM_BUY_CURRENCIE = "Popin_ConfirmBuyEuro";
com_isartdigital_perle_game_AssetName.BTN_PRODUCTION = "ProdDone";
com_isartdigital_perle_game_AssetName.SHOP_PREFIX = "Shop_";
com_isartdigital_perle_game_AssetName.POPIN_SHOP = "Shop_" + "Building";
com_isartdigital_perle_game_AssetName.SHOP_BTN_CLOSE = "Shop_" + "Close_Button";
com_isartdigital_perle_game_AssetName.SHOP_BTN_PURGATORY = "Purgatory_Button";
com_isartdigital_perle_game_AssetName.SHOP_BTN_INTERNS = "Interns_Button";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_BUILDING = "Onglet_Building";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_DECO = "Onglet_Deco";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_INTERN = "Onglet_Interns";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_RESOURCE = "Onglet_Ressources";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_CURRENCIE = "Onglet_Currencies";
com_isartdigital_perle_game_AssetName.SHOP_BTN_TAB_BUNDLE = "Bundles_Button";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_SPAWNER = "Item_List_Spawner";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_SC = "Player_SC";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_HC = "Player_HC";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_MARBRE = "Player_Marbre";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_BOIS = "Player_Bois";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_TEXT = "bar_txt";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_PACK_BUTTON = "Button";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_PACK_PRICE = "Pack_Content_txt";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_PACK_CONTENT = "Pack_Price";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_CARD_PICTURE = "Item_picture";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_CARD_NAME = "Item_Name";
com_isartdigital_perle_game_AssetName.SHOP_RESSOURCE_CARD_PRICE = "Item_SCPrice";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_BUILDING = "Shop_" + "BuildingDeco_List";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_CURRENCIE = "Shop_" + "CurrenciesTab_List";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_INTERN = "Shop_" + "InternsTab_List";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_INTERN_SEARCHING = "Shop_" + "InternsTab_Searching";
com_isartdigital_perle_game_AssetName.SHOP_CAROUSSEL_RESOURCE = "Shop_" + "ResourcesTab_List";
com_isartdigital_perle_game_AssetName.CAROUSSEL_CARD_ITEM_UNLOCKED = "ButtonBuyBuildingDeco";
com_isartdigital_perle_game_AssetName.CAROUSSEL_CARD_ITEM_LOCKED = "Shop_" + "BuildingDeco_LockedItem";
com_isartdigital_perle_game_AssetName.CAROUSSEL_CARD_BUNDLE = "ButtonBuyPack";
com_isartdigital_perle_game_AssetName.POPIN_CONFIRM_BUY_BUILDING = "Popin_ConfirmationBuyHouse";
com_isartdigital_perle_game_AssetName.PCBB_IMG = "Building_Image";
com_isartdigital_perle_game_AssetName.PCBB_TEXT_NAME = "Building_Name";
com_isartdigital_perle_game_AssetName.PCBB_TEXT_LEVEL = "Building_Level_txt";
com_isartdigital_perle_game_AssetName.PCBB_PRICE = "Window_Infos_BuyPrice";
com_isartdigital_perle_game_AssetName.PCBB_PRICE_TEXT = "ButtonUpgrade_Cost_txt";
com_isartdigital_perle_game_AssetName.PCBB_GOLD_MAX = "Window_Infos_LimitGold";
com_isartdigital_perle_game_AssetName.PCBB_GOLD_MAX_TEXT = "Window_Infos_txtGoldLimit";
com_isartdigital_perle_game_AssetName.PCBB_POPULATION_MAX = "Window_Infos_Population";
com_isartdigital_perle_game_AssetName.PCBB_POPULATION_MAX_TEXT = "Window_Infos_txtPopulation";
com_isartdigital_perle_game_AssetName.PCBB_GOLD_PER_TIME = "Window_Infos_ProductionGold";
com_isartdigital_perle_game_AssetName.PCBB_GOLD_PER_TIME_TEXT_1 = "Window_Infos_txtProductionGold";
com_isartdigital_perle_game_AssetName.PCBB_GOLD_PER_TIME_TEXT_2 = "perTime";
com_isartdigital_perle_game_AssetName.PCBB_BTN_CLOSE = "ButtonClose";
com_isartdigital_perle_game_AssetName.PCBB_BTN_BUY = "BuyButton";
com_isartdigital_perle_game_AssetName.POPIN_INFO_BUILDING = "Fenetre_InfoMaison";
com_isartdigital_perle_game_AssetName.INFO_BUILDING_BTN_CLOSE = "ButtonClose";
com_isartdigital_perle_game_AssetName.INFO_BUILDING_BTN_SELL = "ButtonDestroy";
com_isartdigital_perle_game_AssetName.INFO_BUILDING_BTN_UPGRADE = "ButtonUpgrade";
com_isartdigital_perle_game_AssetName.INTERN_LIST = "ListInterns";
com_isartdigital_perle_game_AssetName.INTERN_LIST_CANCEL = "ButtonClose";
com_isartdigital_perle_game_AssetName.INTERN_LIST_LEFT = "_arrow_left";
com_isartdigital_perle_game_AssetName.INTERN_LIST_RIGHT = "_arrow_right";
com_isartdigital_perle_game_AssetName.internListSpawners = ["Intern01","Intern02","Intern03"];
com_isartdigital_perle_game_AssetName.INTERN_INFO_IN_QUEST = "ListInQuest";
com_isartdigital_perle_game_AssetName.BUTTON_ACCELERATE_IN_QUEST = "Bouton_InternSend_Clip";
com_isartdigital_perle_game_AssetName.INTERN_NAME_IN_QUEST = "InQuest_name";
com_isartdigital_perle_game_AssetName.TIME_IN_QUEST = "InQuest_ProgressionBar";
com_isartdigital_perle_game_AssetName.PORTRAIT_IN_QUEST = "InQuest_Portrait";
com_isartdigital_perle_game_AssetName.INTERN_INFO_OUT_QUEST = "ListOutQuest";
com_isartdigital_perle_game_AssetName.BUTTON_SEND_OUT_QUEST = "Bouton_SendIntern_List";
com_isartdigital_perle_game_AssetName.INTERN_NAME_OUT_QUEST = "_intern03_name05";
com_isartdigital_perle_game_AssetName.PORTRAIT_OUT_QUEST = "OutQuest_Portrait";
com_isartdigital_perle_game_AssetName.INTERN_EVENT = "Intern_Event";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_DESC = "_event_description";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_HEAVEN_CHOICE = "_heavenChoice_text";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_HELL_CHOICE = "_hellChoice_text";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_SEE_ALL = "ButtonInterns";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_DISMISS = "BoutonDismissIntern";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_SHARE = "Button_Friends";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_CLOSE = "CloseButton";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_CARD = "_event_FateCard";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_NAME = "_event_internName";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_SIDE = "_event_internSide";
com_isartdigital_perle_game_AssetName.INTERN_EVENT_MAX_STRESS = "Popin_MaxStress";
com_isartdigital_perle_game_AssetName.INTERN_POPIN = "Interns";
com_isartdigital_perle_game_AssetName.INTERN_POPIN_SIDE = "_intern_side";
com_isartdigital_perle_game_AssetName.INTERN_POPIN_NAME = "_intern_name";
com_isartdigital_perle_game_AssetName.INTERN_POPIN_SEE_ALL_CONTAINER = "Bouton_AllInterns_Clip";
com_isartdigital_perle_game_AssetName.INTERN_POPIN_SEE_ALL = "Button";
com_isartdigital_perle_game_AssetName.INTERN_POPIN_CANCEL = "ButtonCancel";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN = "PurgatoryPop";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_CANCEL = "CloseButton";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_SHOP = "ShopButton";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_INTERN = "InternsButton";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_HEAVEN_BUTTON = "HeavenButton";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_HELL_BUTTON = "HellButton";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_LEVEL = "BuildingLevel";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_TIMER_CONTAINER = "UpgradeTimer";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_TIMER = "TimeInfo";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_SOUL_INFO = "FateTitle";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_SOUL_NAME = "Name";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_SOUL_ADJ = "Adjective";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_HEAVEN_INFO = "HeavenINfo";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_HELL_INFO = "HellInfo";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_INFO_BAR = "bar_txt";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_ALL_SOULS_INFO = "SoulCounter";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_ALL_SOULS_NUMBER = "Value";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_UPGRADE = "ButtonUpgrade";
com_isartdigital_perle_game_AssetName.PURGATORY_POPIN_UPGRADE_PRICE = "Cost";
com_isartdigital_perle_game_AssetName.FTUE = "Window_NPC";
com_isartdigital_perle_game_AssetName.FTUE_BUTTON = "Window_NPC" + "_ButtonNext";
com_isartdigital_perle_game_AssetName.FTUE_HELL = "Window_NPC" + "_Hell";
com_isartdigital_perle_game_AssetName.FTUE_HEAVEN = "Window_NPC" + "_Heaven";
com_isartdigital_perle_game_AssetName.FTUE_NAME = "Window_NPC" + "_Name_TXT";
com_isartdigital_perle_game_AssetName.FTUE_SPEACH = "Window_NPC" + "_Speech_TXT";
com_isartdigital_perle_game_AssetName.HUD_PREFIX = "HUD_";
com_isartdigital_perle_game_AssetName.HUD_BTN_RESET_DATA = "ALPHA_ResetData";
com_isartdigital_perle_game_AssetName.HUD_BTN_SHOP = "ButtonShop_HUD";
com_isartdigital_perle_game_AssetName.HUD_BTN_PURGATORY = "HUD_" + "PurgatoryButton";
com_isartdigital_perle_game_AssetName.HUD_CONTAINER_BTN_INTERNS = "HUD_" + "InternsButton";
com_isartdigital_perle_game_AssetName.HUD_BTN_INTERNS = "HUD_" + "InternsButton";
com_isartdigital_perle_game_AssetName.HUD_BTN_MISSIONS = "ButtonMissions_HUD";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_SOFT = "HUD_" + "SoftCurrency";
com_isartdigital_perle_game_AssetName.HUD_BTN_SOFT = "ButtonPlusSC";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_HARD = "HUD_" + "HardCurrency";
com_isartdigital_perle_game_AssetName.HUD_BTN_HARD = "ButtonPlusHC";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_MATERIAL_HEAVEN = "HUD_" + "Wood";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_MATERIAL_HELL = "HUD_" + "Iron";
com_isartdigital_perle_game_AssetName.HUD_BTN_WOOD = "ButtonPlusWOOD";
com_isartdigital_perle_game_AssetName.HUD_BTN_IRON = "ButtonPlusIRON";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_XP_HEAVEN = "HUD_" + "HeavenXP";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_XP_HELL = "HUD_" + "HellXP";
com_isartdigital_perle_game_AssetName.HUD_COUNTER_LEVEL = "HUD_" + "Level";
com_isartdigital_perle_game_AssetName.COUNTER_TXT_XP = "Hud_xp_txt";
com_isartdigital_perle_game_AssetName.COUNTER_TXT_RESSOURCE = "bar_txt";
com_isartdigital_perle_game_AssetName.COUNTER_TXT_LEVEL = "_level_txt";
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
=======
com_isartdigital_perle_game_AssetName.COLLECTOR_POPIN = "InfoCollector";
com_isartdigital_perle_game_AssetName.COLLECTOR_PANEL = "ProductionPanelsContainer";
com_isartdigital_perle_game_AssetName.PACK_COLLECTOR_PANEL = "ProductionPanel";
com_isartdigital_perle_game_AssetName.PACK_COLLECTOR_LOCK_PANEL = "ProductionPanel_Locked";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_SPAWNER = "_productionPanelSpawner";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_SPAWNER_ICON = "_buildRessourceIcon_Large";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_TIME_TEXT = "_time_value";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_GAIN = "_ressourceGain_text";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_BUTTON = "ButtonProduce";
com_isartdigital_perle_game_AssetName.PANEL_COLLECTOR_BUTTON_TEXT = "_buttonProduce_GoldValue";
com_isartdigital_perle_game_AssetName.COLLECTOR_TIME_IN_PROD = "CollectorInProduction";
com_isartdigital_perle_game_AssetName.COLLECTOR_TIME_GAUGE = "TimeGauge";
com_isartdigital_perle_game_AssetName.COLLECTOR_TIME_GAUGE_TEXT = "_Text_TimeSkipGaugeTime";
com_isartdigital_perle_game_AssetName.COLLECTOR_TIME_GAIN = "ProducingValue";
com_isartdigital_perle_game_AssetName.COLLECTOR_TIME_ICON = "ProducingIcon";
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN = "Popin_LevelUp";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_BUTTON = "Button_NextReward";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_PASSALL = "ButtonShowAll";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_LEVELBG = "_bg_level";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_LEVEL = "level";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_TYPE = "_txt_type";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_UNLOCK = "_unlock";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_NAME = "_txt_name";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_IMG = "Image";
com_isartdigital_perle_game_AssetName.LEVELUP_POPPIN_DESCRIPTION = "Description";
com_isartdigital_perle_game_AssetName.DESTROY_POPPIN = "Popin_DestroyBuilding";
com_isartdigital_perle_game_AssetName.XP_GAUGE_HELL = "HUD_HellXP";
com_isartdigital_perle_game_AssetName.XP_GAUGE_HEAVEN = "HUD_HeavenXP";
com_isartdigital_perle_game_AssetName.BACKGROUND_HELL = "BG_Hell";
com_isartdigital_perle_game_AssetName.BACKGROUND_HEAVEN = "BG_Heaven";
com_isartdigital_perle_game_AssetName.BACKGROUND_STYX = "Styx01";
com_isartdigital_perle_game_AssetName.BACKGROUND_UNDER_HEAVEN = "HeavenBackground";
com_isartdigital_perle_game_AssetName.BACKGROUND_UNDER_HELL = "hell_bg_free";
com_isartdigital_perle_game_AssetName.PROD_ICON_SOFT = "_goldIcon__Large_Prod";
com_isartdigital_perle_game_AssetName.PROD_ICON_HARD = "_hardCurrencyIcon_Large";
com_isartdigital_perle_game_AssetName.PROD_ICON_WOOD = "_woodIcon_Large";
com_isartdigital_perle_game_AssetName.PROD_ICON_STONE = "_stoneIcon_Large";
com_isartdigital_perle_game_AssetName.PROD_ICON_SOUL_HEAVEN_SMALL = "_heavenSoulIcon_Small";
com_isartdigital_perle_game_AssetName.PROD_ICON_SOUL_HELL_SMALL = "_hellSoulIcon_Small";
com_isartdigital_perle_game_AssetName.PROD_ICON_WOOD_LARGE = "_woodIcon_Large";
com_isartdigital_perle_game_AssetName.PROD_ICON_STONE_LARGE = "_stoneIcon_Large";
com_isartdigital_perle_game_BuildingName.STYX_PURGATORY = "Purgatory";
com_isartdigital_perle_game_BuildingName.STYX_VICE = "Altar Vice";
com_isartdigital_perle_game_BuildingName.STYX_VIRTUE = "Altar Virtue";
com_isartdigital_perle_game_BuildingName.STYX_MARKET = "Market";
com_isartdigital_perle_game_BuildingName.STYX_DECO_BUILDING = "Styx Nice Building";
com_isartdigital_perle_game_BuildingName.STYX_DECO_GORGEOUS_BUILDING = "Styx Gorgeous Building";
com_isartdigital_perle_game_BuildingName.HEAVEN_HOUSE = "Heaven House";
com_isartdigital_perle_game_BuildingName.HEAVEN_COLLECTOR = "Heaven Collector Lumber Mill";
com_isartdigital_perle_game_BuildingName.HEAVEN_MARKETING_DEPARTMENT = "Marketing Department";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_GENERIC_TREE = "Generic Tree";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_BIGGER_TREE = "Bigger Tree";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_PRETTY_TREE = "Pretty Tree";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_AWESOME_TREE = "Awesome Tree";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_BUILDING = "Heaven Nice Building";
com_isartdigital_perle_game_BuildingName.HEAVEN_DECO_GORGEOUS_BUILDING = "Heaven Gorgeous Building";
com_isartdigital_perle_game_BuildingName.HELL_HOUSE = "Hell House";
com_isartdigital_perle_game_BuildingName.HELL_COLLECTOR = "Hell Collector Iron Mines";
com_isartdigital_perle_game_BuildingName.HELL_FACTORY = "Factory";
com_isartdigital_perle_game_BuildingName.HELL_DECO_GENERIC_ROCK = "Generic Rock";
com_isartdigital_perle_game_BuildingName.HELL_DECO_BIGGER_ROCK = "Bigger Rock";
com_isartdigital_perle_game_BuildingName.HELL_DECO_PRETTY_ROCK = "Pretty Rock";
com_isartdigital_perle_game_BuildingName.HELL_DECO_AWESOME_ROCK = "Awesome Rock";
com_isartdigital_perle_game_BuildingName.HELL_DECO_BUILDING = "Hell Nice Building";
com_isartdigital_perle_game_BuildingName.HELL_DECO_GORGEOUS_BUILDING = "Hell Gorgeous Building";
com_isartdigital_perle_game_BuildingName.HOUSE_INTERNS = "Intern Building";
com_isartdigital_perle_game_BuildingName.BUILDING_NAME_TO_ASSETNAMES = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.set("Heaven House",["HeavenBuild0","HeavenBuild1","HeavenBuild2"]);
	_g.set("Heaven Collector Lumber Mill",["HeavenLumberMill01","HeavenLumberMill02"]);
	_g.set("Marketing Department",["HeavenBuild0"]);
	_g.set("Generic Tree",["Paradis_Arbre01_P"]);
	_g.set("Bigger Tree",["Paradis_Arbre02_P"]);
	_g.set("Pretty Tree",["Paradis_Arbre03_P"]);
	_g.set("Awesome Tree",["Paradis_Arbre03_P"]);
	_g.set("Heaven Nice Building",["HeavenBuild0"]);
	_g.set("Heaven Gorgeous Building",["HeavenBuild0"]);
	_g.set("Hell House",["hellBuilding","hellBuilding2","hellBuilding3"]);
	_g.set("Hell Collector Iron Mines",["Hell_Quarry"]);
	_g.set("Factory",["hellBuilding"]);
	_g.set("Generic Rock",["Enfer_Rocher_P"]);
	_g.set("Bigger Rock",["Enfer_Rocher_P"]);
	_g.set("Pretty Rock",["Enfer_Rocher_P"]);
	_g.set("Awesome Rock",["Enfer_Rocher_P"]);
	_g.set("Hell Nice Building",["hellBuilding"]);
	_g.set("Hell Gorgeous Building",["hellBuilding"]);
	_g.set("Purgatory",["Tribunal"]);
	_g.set("Altar Vice",["Altar_Virtue"]);
	_g.set("Altar Virtue",["Altar_Virtue"]);
	_g.set("Market",["hellBuilding"]);
	_g.set("Intern Building",["hellBuilding"]);
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_GameConfig.BUILDING = "TypeBuilding";
com_isartdigital_perle_game_GameConfig.INTERN = "TypeIntern";
com_isartdigital_perle_game_GameConfig.CONFIG = "Config";
com_isartdigital_perle_game_QuestDictionnary.vowel = ["a","e","i","o","u","y"];
com_isartdigital_perle_game_QuestDictionnary.preSubject = (function($this) {
	var $r;
	var _g = new haxe_ds_EnumValueMap();
	_g.set(com_isartdigital_perle_game_LetterType.CONSONNE,"de ");
	_g.set(com_isartdigital_perle_game_LetterType.VOYELLE,"d'");
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_QuestDictionnary.intern = "votre stagiaire ";
com_isartdigital_perle_game_QuestDictionnary.intro = ["A l'entrée d'","Devant ","Au bords d'","Face à ","A la sortie d'","Au milieu d'","Au coeur d'","Dans ","Au fond d'"];
com_isartdigital_perle_game_QuestDictionnary.localisation = ["un tunnel, ","une grotte, ","un lac, ","un village, ","une ferme, ","un champ, ","une forêt, ","un bois, ","une plaine, "];
com_isartdigital_perle_game_QuestDictionnary.internVerbs = ["rencontre ","voit ","apperçoit ","remarque ","entrevoit ","discerne ","distingue ","observe ","surprend ","découvre "];
com_isartdigital_perle_game_QuestDictionnary.number = ["un groupe ","une horde ","une foule ","une tripotée ","un regroupement ","une armée ","un rassemblement ","une petit groupe ","une poignée "];
com_isartdigital_perle_game_QuestDictionnary.subjects = ["guerriers ","paysans ","marchands ","esclaves ","barbares ","médecins ","mort-vivants ","trolls ","orcs ","gobelins "];
com_isartdigital_perle_game_QuestDictionnary.actions = (function($this) {
	var $r;
	var _g = new haxe_ds_EnumValueMap();
	_g.set(com_isartdigital_perle_game_ActionType.BAD,["brutalisant ","agressant ","torturant ","combattant ","frappant ","pourchassant ","attaquant "]);
	_g.set(com_isartdigital_perle_game_ActionType.GOOD,["soignant ","repoussant ","aidant "]);
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_QuestDictionnary.secondarySubjects = ["des archéologues.","des voyageurs.","des touristes.","un vagabond.","des animaux.","des trolls nains.","des crocodiles.","des enfants.","des chasseurs.","des milliciens."];
com_isartdigital_perle_game_TimesInfo.SEC = 1000;
com_isartdigital_perle_game_TimesInfo.MIN = 60000;
com_isartdigital_perle_game_TimesInfo.HOU = 3600000;
com_isartdigital_perle_game_managers_BoostManager.ALTAR_EVENT_NAME = "ALTAR_CALL";
com_isartdigital_perle_game_managers_BoostManager.BUILDING_EVENT_NAME = "BUILDING_CALL";
com_isartdigital_perle_game_managers_CameraManager.REGION_WIDTH = 2400.;
com_isartdigital_perle_game_managers_CameraManager.REGION_HEIGHT = 1200.;
com_isartdigital_perle_game_managers_CameraManager.REGION_STYX_WIDTH = -1000.;
com_isartdigital_perle_game_managers_CameraManager.REGION_STYX_HEIGHT = -1000.;
com_isartdigital_perle_game_managers_CameraManager.DEFAULT_SPEED = 12;
com_isartdigital_perle_game_managers_CameraManager.DEFAULT_OFFSET_LOCAL = 100;
com_isartdigital_perle_game_managers_CameraManager.test = 0;
com_isartdigital_perle_game_managers_CameraManager.cheat_no_clipping = false;
com_isartdigital_perle_game_managers_ClippingManager.cheat_do_clipping_start_only = false;
com_isartdigital_perle_game_managers_ClippingManager.CLIPPING_MARGIN_V = 12;
com_isartdigital_perle_game_managers_ClippingManager.CLIPPING_MARGIN_H = 18;
com_isartdigital_perle_game_managers_DialogueManager.closeDialoguePoppin = false;
com_isartdigital_perle_game_managers_PoolingManager.INSTANCE_TO_SPAWN = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
<<<<<<< HEAD:bin/ui.js
	if(__map_reserved.hellBuilding != null) {
		_g.setReserved("hellBuilding",2);
	} else {
		_g.h["hellBuilding"] = 2;
	}
	if(__map_reserved.Ground != null) {
		_g.setReserved("Ground",400);
	} else {
		_g.h["Ground"] = 400;
	}
	if(__map_reserved.Road_h != null) {
		_g.setReserved("Road_h",1);
	} else {
		_g.h["Road_h"] = 1;
	}
	if(__map_reserved.Road_c != null) {
		_g.setReserved("Road_c",1);
	} else {
		_g.h["Road_c"] = 1;
	}
	if(__map_reserved.Road_br != null) {
		_g.setReserved("Road_br",1);
	} else {
		_g.h["Road_br"] = 1;
	}
	if(__map_reserved.Road_tl != null) {
		_g.setReserved("Road_tl",1);
	} else {
		_g.h["Road_tl"] = 1;
	}
	if(__map_reserved.Road_v != null) {
		_g.setReserved("Road_v",1);
	} else {
		_g.h["Road_v"] = 1;
	}
	if(__map_reserved.FootPrint != null) {
		_g.setReserved("FootPrint",20);
	} else {
		_g.h["FootPrint"] = 20;
	}
	if(__map_reserved.Tribunal != null) {
		_g.setReserved("Tribunal",1);
	} else {
		_g.h["Tribunal"] = 1;
	}
=======
	if(__map_reserved.hellBuilding != null) _g.setReserved("hellBuilding",2); else _g.h["hellBuilding"] = 2;
	if(__map_reserved.Ground != null) _g.setReserved("Ground",400); else _g.h["Ground"] = 400;
	if(__map_reserved.Road_h != null) _g.setReserved("Road_h",1); else _g.h["Road_h"] = 1;
	if(__map_reserved.Road_c != null) _g.setReserved("Road_c",1); else _g.h["Road_c"] = 1;
	if(__map_reserved.Road_br != null) _g.setReserved("Road_br",1); else _g.h["Road_br"] = 1;
	if(__map_reserved.Road_tl != null) _g.setReserved("Road_tl",1); else _g.h["Road_tl"] = 1;
	if(__map_reserved.Road_v != null) _g.setReserved("Road_v",1); else _g.h["Road_v"] = 1;
	if(__map_reserved.FootPrint != null) _g.setReserved("FootPrint",1); else _g.h["FootPrint"] = 1;
	if(__map_reserved.Tribunal != null) _g.setReserved("Tribunal",1); else _g.h["Tribunal"] = 1;
>>>>>>> btn accelerate working:bin/Builder.js
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_managers_PoolingManager.ASSETNAME_TO_CLASS = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
<<<<<<< HEAD:bin/ui.js
	if(__map_reserved.Tribunal != null) {
		_g.setReserved("Tribunal","Tribunal");
	} else {
		_g.h["Tribunal"] = "Tribunal";
	}
	if(__map_reserved.Altar_Virtue != null) {
		_g.setReserved("Altar_Virtue","Building");
	} else {
		_g.h["Altar_Virtue"] = "Building";
	}
	if(__map_reserved.HeavenBuild0 != null) {
		_g.setReserved("HeavenBuild0","HouseHeaven");
	} else {
		_g.h["HeavenBuild0"] = "HouseHeaven";
	}
	if(__map_reserved.hellBuilding2 != null) {
		_g.setReserved("hellBuilding2","HouseHeaven");
	} else {
		_g.h["hellBuilding2"] = "HouseHeaven";
	}
	if(__map_reserved.hellBuilding3 != null) {
		_g.setReserved("hellBuilding3","HouseHeaven");
	} else {
		_g.h["hellBuilding3"] = "HouseHeaven";
	}
	if(__map_reserved.HeavenBuild3 != null) {
		_g.setReserved("HeavenBuild3","Building");
	} else {
		_g.h["HeavenBuild3"] = "Building";
	}
	if(__map_reserved.HeavenLumberMill01 != null) {
		_g.setReserved("HeavenLumberMill01","Lumbermill");
	} else {
		_g.h["HeavenLumberMill01"] = "Lumbermill";
	}
	if(__map_reserved.HeavenLumberMill02 != null) {
		_g.setReserved("HeavenLumberMill02","Lumbermill");
	} else {
		_g.h["HeavenLumberMill02"] = "Lumbermill";
	}
	if(__map_reserved.hellBuilding != null) {
		_g.setReserved("hellBuilding","HouseHell");
	} else {
		_g.h["hellBuilding"] = "HouseHell";
	}
	if(__map_reserved.HeavenBuild1 != null) {
		_g.setReserved("HeavenBuild1","HouseHell");
	} else {
		_g.h["HeavenBuild1"] = "HouseHell";
	}
	if(__map_reserved.HeavenBuild2 != null) {
		_g.setReserved("HeavenBuild2","HouseHell");
	} else {
		_g.h["HeavenBuild2"] = "HouseHell";
	}
	if(__map_reserved.Hell_Quarry != null) {
		_g.setReserved("Hell_Quarry","Quarry");
	} else {
		_g.h["Hell_Quarry"] = "Quarry";
	}
	if(__map_reserved.Paradis_Arbre01_P != null) {
		_g.setReserved("Paradis_Arbre01_P","DecoHeaven");
	} else {
		_g.h["Paradis_Arbre01_P"] = "DecoHeaven";
	}
	if(__map_reserved.Paradis_Arbre02_P != null) {
		_g.setReserved("Paradis_Arbre02_P","DecoHeaven");
	} else {
		_g.h["Paradis_Arbre02_P"] = "DecoHeaven";
	}
	if(__map_reserved.Paradis_Arbre03_P != null) {
		_g.setReserved("Paradis_Arbre03_P","DecoHeaven");
	} else {
		_g.h["Paradis_Arbre03_P"] = "DecoHeaven";
	}
	if(__map_reserved.heavenBuild4 != null) {
		_g.setReserved("heavenBuild4","Building");
	} else {
		_g.h["heavenBuild4"] = "Building";
	}
	if(__map_reserved.Paradis_Rocher_P != null) {
		_g.setReserved("Paradis_Rocher_P","Building");
	} else {
		_g.h["Paradis_Rocher_P"] = "Building";
	}
	if(__map_reserved.Enfer_Arbre01_P != null) {
		_g.setReserved("Enfer_Arbre01_P","DecoHell");
	} else {
		_g.h["Enfer_Arbre01_P"] = "DecoHell";
	}
	if(__map_reserved.Enfer_Arbre02_P != null) {
		_g.setReserved("Enfer_Arbre02_P","DecoHell");
	} else {
		_g.h["Enfer_Arbre02_P"] = "DecoHell";
	}
	if(__map_reserved.Enfer_Arbre03_P != null) {
		_g.setReserved("Enfer_Arbre03_P","DecoHell");
	} else {
		_g.h["Enfer_Arbre03_P"] = "DecoHell";
	}
	if(__map_reserved.Enfer_Rocher_P != null) {
		_g.setReserved("Enfer_Rocher_P","Building");
	} else {
		_g.h["Enfer_Rocher_P"] = "Building";
	}
	if(__map_reserved.Ground != null) {
		_g.setReserved("Ground","Ground");
	} else {
		_g.h["Ground"] = "Ground";
	}
	if(__map_reserved.Road_h != null) {
		_g.setReserved("Road_h","Ground");
	} else {
		_g.h["Road_h"] = "Ground";
	}
	if(__map_reserved.Road_c != null) {
		_g.setReserved("Road_c","Ground");
	} else {
		_g.h["Road_c"] = "Ground";
	}
	if(__map_reserved.Road_br != null) {
		_g.setReserved("Road_br","Ground");
	} else {
		_g.h["Road_br"] = "Ground";
	}
	if(__map_reserved.Road_tl != null) {
		_g.setReserved("Road_tl","Ground");
	} else {
		_g.h["Road_tl"] = "Ground";
	}
	if(__map_reserved.Road_v != null) {
		_g.setReserved("Road_v","Ground");
	} else {
		_g.h["Road_v"] = "Ground";
	}
	if(__map_reserved.FootPrint != null) {
		_g.setReserved("FootPrint","FootPrintAsset");
	} else {
		_g.h["FootPrint"] = "FootPrintAsset";
	}
=======
	if(__map_reserved.Tribunal != null) _g.setReserved("Tribunal","Tribunal"); else _g.h["Tribunal"] = "Tribunal";
	if(__map_reserved.Altar_Virtue != null) _g.setReserved("Altar_Virtue","Building"); else _g.h["Altar_Virtue"] = "Building";
	if(__map_reserved.HeavenBuild0 != null) _g.setReserved("HeavenBuild0","HouseHeaven"); else _g.h["HeavenBuild0"] = "HouseHeaven";
	if(__map_reserved.hellBuilding2 != null) _g.setReserved("hellBuilding2","HouseHeaven"); else _g.h["hellBuilding2"] = "HouseHeaven";
	if(__map_reserved.hellBuilding3 != null) _g.setReserved("hellBuilding3","HouseHeaven"); else _g.h["hellBuilding3"] = "HouseHeaven";
	if(__map_reserved.HeavenBuild3 != null) _g.setReserved("HeavenBuild3","Building"); else _g.h["HeavenBuild3"] = "Building";
	if(__map_reserved.HeavenLumberMill01 != null) _g.setReserved("HeavenLumberMill01","Lumbermill"); else _g.h["HeavenLumberMill01"] = "Lumbermill";
	if(__map_reserved.HeavenLumberMill02 != null) _g.setReserved("HeavenLumberMill02","Lumbermill"); else _g.h["HeavenLumberMill02"] = "Lumbermill";
	if(__map_reserved.hellBuilding != null) _g.setReserved("hellBuilding","HouseHell"); else _g.h["hellBuilding"] = "HouseHell";
	if(__map_reserved.HeavenBuild1 != null) _g.setReserved("HeavenBuild1","HouseHell"); else _g.h["HeavenBuild1"] = "HouseHell";
	if(__map_reserved.HeavenBuild2 != null) _g.setReserved("HeavenBuild2","HouseHell"); else _g.h["HeavenBuild2"] = "HouseHell";
	if(__map_reserved.Hell_Quarry != null) _g.setReserved("Hell_Quarry","Quarry"); else _g.h["Hell_Quarry"] = "Quarry";
	if(__map_reserved.Paradis_Arbre01_P != null) _g.setReserved("Paradis_Arbre01_P","DecoHeaven"); else _g.h["Paradis_Arbre01_P"] = "DecoHeaven";
	if(__map_reserved.Paradis_Arbre02_P != null) _g.setReserved("Paradis_Arbre02_P","DecoHeaven"); else _g.h["Paradis_Arbre02_P"] = "DecoHeaven";
	if(__map_reserved.Paradis_Arbre03_P != null) _g.setReserved("Paradis_Arbre03_P","DecoHeaven"); else _g.h["Paradis_Arbre03_P"] = "DecoHeaven";
	if(__map_reserved.heavenBuild4 != null) _g.setReserved("heavenBuild4","Building"); else _g.h["heavenBuild4"] = "Building";
	if(__map_reserved.Paradis_Rocher_P != null) _g.setReserved("Paradis_Rocher_P","Building"); else _g.h["Paradis_Rocher_P"] = "Building";
	if(__map_reserved.Enfer_Arbre01_P != null) _g.setReserved("Enfer_Arbre01_P","DecoHell"); else _g.h["Enfer_Arbre01_P"] = "DecoHell";
	if(__map_reserved.Enfer_Arbre02_P != null) _g.setReserved("Enfer_Arbre02_P","DecoHell"); else _g.h["Enfer_Arbre02_P"] = "DecoHell";
	if(__map_reserved.Enfer_Arbre03_P != null) _g.setReserved("Enfer_Arbre03_P","DecoHell"); else _g.h["Enfer_Arbre03_P"] = "DecoHell";
	if(__map_reserved.Enfer_Rocher_P != null) _g.setReserved("Enfer_Rocher_P","Building"); else _g.h["Enfer_Rocher_P"] = "Building";
	if(__map_reserved.Ground != null) _g.setReserved("Ground","Ground"); else _g.h["Ground"] = "Ground";
	if(__map_reserved.Road_h != null) _g.setReserved("Road_h","Ground"); else _g.h["Road_h"] = "Ground";
	if(__map_reserved.Road_c != null) _g.setReserved("Road_c","Ground"); else _g.h["Road_c"] = "Ground";
	if(__map_reserved.Road_br != null) _g.setReserved("Road_br","Ground"); else _g.h["Road_br"] = "Ground";
	if(__map_reserved.Road_tl != null) _g.setReserved("Road_tl","Ground"); else _g.h["Road_tl"] = "Ground";
	if(__map_reserved.Road_v != null) _g.setReserved("Road_v","Ground"); else _g.h["Road_v"] = "Ground";
	if(__map_reserved.FootPrint != null) _g.setReserved("FootPrint","FootPrint"); else _g.h["FootPrint"] = "FootPrint";
>>>>>>> btn accelerate working:bin/Builder.js
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_managers_PoolingManager.poolList = new haxe_ds_StringMap();
com_isartdigital_perle_game_managers_QuestsManager.NUMBER_EVENTS = 3;
com_isartdigital_perle_game_managers_QuestsManager.MIN_TIMELINE = 2000;
com_isartdigital_perle_game_managers_QuestsManager.MAX_TIMELINE = 3000;
com_isartdigital_perle_game_managers_QuestsManager.isFinish = false;
com_isartdigital_perle_game_managers_RegionManager.CURRENT_TYPE_REGION = "current";
com_isartdigital_perle_game_managers_RegionManager.OTHER_TYPE_REGION = "other";
com_isartdigital_perle_game_managers_RegionManager.factors = [new PIXI.Point(-1,0),new PIXI.Point(1,0),new PIXI.Point(0,-1),new PIXI.Point(0,1)];
com_isartdigital_perle_game_managers_ResourcesManager.GENERATOR_EVENT_NAME = "GENERATOR";
com_isartdigital_perle_game_managers_ResourcesManager.TOTAL_RESOURCES_EVENT_NAME = "TOTAL RESOURCES";
com_isartdigital_perle_game_managers_ResourcesManager.POPULATION_CHANGEMENT_EVENT_NAME = "POPULATION";
com_isartdigital_perle_game_managers_ResourcesManager.SOUL_ARRIVED_EVENT_NAME = "SOUL_ARRIVED";
com_isartdigital_perle_game_managers_SaveManager.SAVE_NAME = "com_isartdigital_perle";
com_isartdigital_perle_game_managers_SaveManager.SAVE_VERSION = "1.0.8";
com_isartdigital_perle_game_managers_ServerManager.KEY_POST_FILE_NAME = "module";
com_isartdigital_perle_game_managers_ServerManager.KEY_POST_FUNCTION_NAME = "action";
com_isartdigital_perle_game_managers_ServerFile.MAIN_PHP = "actions.php";
com_isartdigital_perle_game_managers_ServerFile.LOGIN = "Login";
com_isartdigital_perle_game_managers_ServerFile.TEMP_GET_JSON = "JsonCreator";
com_isartdigital_perle_game_managers_ServerFile.REGIONS = "BuyRegions";
com_isartdigital_perle_game_managers_TimeManager.EVENT_RESOURCE_TICK = "TimeManager_Resource_Tick";
com_isartdigital_perle_game_managers_TimeManager.EVENT_QUEST_STEP = "TimeManager_Quest_Step_Reached";
com_isartdigital_perle_game_managers_TimeManager.EVENT_QUEST_END = "TimeManager_Resource_End_Reached";
com_isartdigital_perle_game_managers_TimeManager.EVENT_CONSTRUCT_END = "TimeManager_Construction_End";
com_isartdigital_perle_game_managers_TimeManager.EVENT_COLLECTOR_PRODUCTION = "Production_Time";
com_isartdigital_perle_game_managers_TimeManager.EVENT_COLLECTOR_PRODUCTION_FINE = "Production_Fine";
com_isartdigital_perle_game_managers_TimeManager.TIME_DESC_REFLECT = "timeDesc";
com_isartdigital_perle_game_managers_TimeManager.TIME_LOOP_DELAY = 50;
com_isartdigital_perle_game_managers_UnlockManager.isAlreadySaved = false;
com_isartdigital_utils_game_StateGraphic.animAlpha = 1;
com_isartdigital_utils_game_StateGraphic.boxAlpha = 0;
com_isartdigital_perle_game_sprites_Tile.TILE_WIDTH = 200;
com_isartdigital_perle_game_sprites_Tile.TILE_HEIGHT = 100;
com_isartdigital_perle_game_sprites_Building.BUILDING_NAME_TO_MAPSIZE = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
<<<<<<< HEAD:bin/ui.js
	{
		var value = { width : 3, height : 3, footprint : 1};
		if(__map_reserved.Purgatory != null) {
			_g.setReserved("Purgatory",value);
		} else {
			_g.h["Purgatory"] = value;
		}
	}
	{
		var value1 = { width : 3, height : 1, footprint : 1};
		if(__map_reserved["Altar Vice"] != null) {
			_g.setReserved("Altar Vice",value1);
		} else {
			_g.h["Altar Vice"] = value1;
		}
	}
	{
		var value2 = { width : 3, height : 2, footprint : 1};
		if(__map_reserved["Altar Virtue"] != null) {
			_g.setReserved("Altar Virtue",value2);
		} else {
			_g.h["Altar Virtue"] = value2;
		}
	}
	{
		var value3 = { width : 2, height : 3, footprint : 1};
		if(__map_reserved.Market != null) {
			_g.setReserved("Market",value3);
		} else {
			_g.h["Market"] = value3;
		}
	}
	{
		var value4 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Heaven House"] != null) {
			_g.setReserved("Heaven House",value4);
		} else {
			_g.h["Heaven House"] = value4;
		}
	}
	{
		var value5 = { width : 2, height : 3, footprint : 1};
		if(__map_reserved["Heaven Collector Lumber Mill"] != null) {
			_g.setReserved("Heaven Collector Lumber Mill",value5);
		} else {
			_g.h["Heaven Collector Lumber Mill"] = value5;
		}
	}
	{
		var value6 = { width : 3, height : 1, footprint : 1};
		if(__map_reserved["Marketing Department"] != null) {
			_g.setReserved("Marketing Department",value6);
		} else {
			_g.h["Marketing Department"] = value6;
		}
	}
	{
		var value7 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Generic Tree"] != null) {
			_g.setReserved("Generic Tree",value7);
		} else {
			_g.h["Generic Tree"] = value7;
		}
	}
	{
		var value8 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Bigger Tree"] != null) {
			_g.setReserved("Bigger Tree",value8);
		} else {
			_g.h["Bigger Tree"] = value8;
		}
	}
	{
		var value9 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Pretty Tree"] != null) {
			_g.setReserved("Pretty Tree",value9);
		} else {
			_g.h["Pretty Tree"] = value9;
		}
	}
	{
		var value10 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Awesome Tree"] != null) {
			_g.setReserved("Awesome Tree",value10);
		} else {
			_g.h["Awesome Tree"] = value10;
		}
	}
	{
		var value11 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Heaven Nice Building"] != null) {
			_g.setReserved("Heaven Nice Building",value11);
		} else {
			_g.h["Heaven Nice Building"] = value11;
		}
	}
	{
		var value12 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Heaven Gorgeous Building"] != null) {
			_g.setReserved("Heaven Gorgeous Building",value12);
		} else {
			_g.h["Heaven Gorgeous Building"] = value12;
		}
	}
	{
		var value13 = { width : 1, height : 2, footprint : 1};
		if(__map_reserved["Hell House"] != null) {
			_g.setReserved("Hell House",value13);
		} else {
			_g.h["Hell House"] = value13;
		}
	}
	{
		var value14 = { width : 3, height : 2, footprint : 1};
		if(__map_reserved["Hell Collector Iron Mines"] != null) {
			_g.setReserved("Hell Collector Iron Mines",value14);
		} else {
			_g.h["Hell Collector Iron Mines"] = value14;
		}
	}
	{
		var value15 = { width : 1, height : 3, footprint : 1};
		if(__map_reserved.Factory != null) {
			_g.setReserved("Factory",value15);
		} else {
			_g.h["Factory"] = value15;
		}
	}
	{
		var value16 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Generic Rock"] != null) {
			_g.setReserved("Generic Rock",value16);
		} else {
			_g.h["Generic Rock"] = value16;
		}
	}
	{
		var value17 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Bigger Rock"] != null) {
			_g.setReserved("Bigger Rock",value17);
		} else {
			_g.h["Bigger Rock"] = value17;
		}
	}
	{
		var value18 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Pretty Rock"] != null) {
			_g.setReserved("Pretty Rock",value18);
		} else {
			_g.h["Pretty Rock"] = value18;
		}
	}
	{
		var value19 = { width : 1, height : 1, footprint : 1};
		if(__map_reserved["Awesome Rock"] != null) {
			_g.setReserved("Awesome Rock",value19);
		} else {
			_g.h["Awesome Rock"] = value19;
		}
	}
	{
		var value20 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Hell Nice Building"] != null) {
			_g.setReserved("Hell Nice Building",value20);
		} else {
			_g.h["Hell Nice Building"] = value20;
		}
	}
	{
		var value21 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Hell Gorgeous Building"] != null) {
			_g.setReserved("Hell Gorgeous Building",value21);
		} else {
			_g.h["Hell Gorgeous Building"] = value21;
		}
	}
	{
		var value22 = { width : 2, height : 2, footprint : 1};
		if(__map_reserved["Intern Building"] != null) {
			_g.setReserved("Intern Building",value22);
		} else {
			_g.h["Intern Building"] = value22;
		}
	}
=======
	_g.set("Purgatory",{ width : 3, height : 3, footprint : 1});
	_g.set("Altar Vice",{ width : 3, height : 1, footprint : 1});
	_g.set("Altar Virtue",{ width : 3, height : 1, footprint : 1});
	_g.set("Market",{ width : 2, height : 3, footprint : 1});
	_g.set("Heaven House",{ width : 2, height : 2, footprint : 1});
	_g.set("Heaven Collector Lumber Mill",{ width : 2, height : 3, footprint : 1});
	_g.set("Marketing Department",{ width : 3, height : 1, footprint : 1});
	_g.set("Generic Tree",{ width : 1, height : 1, footprint : 1});
	_g.set("Bigger Tree",{ width : 1, height : 1, footprint : 1});
	_g.set("Pretty Tree",{ width : 1, height : 1, footprint : 1});
	_g.set("Awesome Tree",{ width : 1, height : 1, footprint : 1});
	_g.set("Heaven Nice Building",{ width : 2, height : 2, footprint : 1});
	_g.set("Heaven Gorgeous Building",{ width : 2, height : 2, footprint : 1});
	_g.set("Hell House",{ width : 1, height : 2, footprint : 1});
	_g.set("Hell Collector Iron Mines",{ width : 3, height : 2, footprint : 1});
	_g.set("Factory",{ width : 1, height : 3, footprint : 1});
	_g.set("Generic Rock",{ width : 1, height : 1, footprint : 1});
	_g.set("Bigger Rock",{ width : 1, height : 1, footprint : 1});
	_g.set("Pretty Rock",{ width : 1, height : 1, footprint : 1});
	_g.set("Awesome Rock",{ width : 1, height : 1, footprint : 1});
	_g.set("Hell Nice Building",{ width : 2, height : 2, footprint : 1});
	_g.set("Hell Gorgeous Building",{ width : 2, height : 2, footprint : 1});
	_g.set("Intern Building",{ width : 2, height : 2, footprint : 1});
>>>>>>> btn accelerate working:bin/Builder.js
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_sprites_Building.isClickable = true;
com_isartdigital_perle_game_sprites_FootPrint.ROTATION_IN_RAD = 0.785398;
com_isartdigital_perle_game_sprites_FootPrint.DEPLACEMENT_FOOTPRINT_CONST = 100;
com_isartdigital_perle_game_sprites_FootPrintAsset.FOOTPRINT_ASSET = "FootPrint";
com_isartdigital_perle_game_sprites_FootPrintAsset.FOOTPRINT_RED = "red";
com_isartdigital_perle_game_sprites_FootPrintAsset.FOOTPRINT_GREEN = "green";
com_isartdigital_perle_game_sprites_FootPrintAsset.FOOTPRINT_YELLOW = "yellow";
com_isartdigital_perle_game_sprites_Ground.OFFSET_REGION = 0;
com_isartdigital_perle_game_sprites_Ground.COL_X_LENGTH = 12;
com_isartdigital_perle_game_sprites_Ground.COL_X_STYX_LENGTH = 3;
com_isartdigital_perle_game_sprites_Ground.ROW_Y_LENGTH = 12;
com_isartdigital_perle_game_sprites_Ground.ROW_Y_STYX_LENGTH = 13;
com_isartdigital_perle_game_sprites_Ground.FILTER_BRIGHTNESS = 1.3;
com_isartdigital_perle_game_sprites_Phantom.EVENT_CANT_BUILD = "Phantom_Cant_Build";
com_isartdigital_perle_game_sprites_Phantom.FILTER_OPACITY = 0.5;
com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_VCLASS = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
<<<<<<< HEAD:bin/ui.js
	if(__map_reserved.Purgatory != null) {
		_g.setReserved("Purgatory","VTribunal");
	} else {
		_g.h["Purgatory"] = "VTribunal";
	}
	if(__map_reserved["Altar Vice"] != null) {
		_g.setReserved("Altar Vice","VVirtuesBuilding");
	} else {
		_g.h["Altar Vice"] = "VVirtuesBuilding";
	}
	if(__map_reserved["Altar Virtue"] != null) {
		_g.setReserved("Altar Virtue","VVirtuesBuilding");
	} else {
		_g.h["Altar Virtue"] = "VVirtuesBuilding";
	}
	if(__map_reserved.Market != null) {
		_g.setReserved("Market","VHouseHell");
	} else {
		_g.h["Market"] = "VHouseHell";
	}
	if(__map_reserved["Heaven House"] != null) {
		_g.setReserved("Heaven House","VHouseHeaven");
	} else {
		_g.h["Heaven House"] = "VHouseHeaven";
	}
	if(__map_reserved["Heaven Collector Lumber Mill"] != null) {
		_g.setReserved("Heaven Collector Lumber Mill","VLumbermill");
	} else {
		_g.h["Heaven Collector Lumber Mill"] = "VLumbermill";
	}
	if(__map_reserved["Marketing Department"] != null) {
		_g.setReserved("Marketing Department","VHouseHell");
	} else {
		_g.h["Marketing Department"] = "VHouseHell";
	}
	if(__map_reserved["Generic Tree"] != null) {
		_g.setReserved("Generic Tree","VDecoHeaven");
	} else {
		_g.h["Generic Tree"] = "VDecoHeaven";
	}
	if(__map_reserved["Bigger Tree"] != null) {
		_g.setReserved("Bigger Tree","VDecoHeaven");
	} else {
		_g.h["Bigger Tree"] = "VDecoHeaven";
	}
	if(__map_reserved["Pretty Tree"] != null) {
		_g.setReserved("Pretty Tree","VDecoHeaven");
	} else {
		_g.h["Pretty Tree"] = "VDecoHeaven";
	}
	if(__map_reserved["Awesome Tree"] != null) {
		_g.setReserved("Awesome Tree","VDecoHeaven");
	} else {
		_g.h["Awesome Tree"] = "VDecoHeaven";
	}
	if(__map_reserved["Heaven Nice Building"] != null) {
		_g.setReserved("Heaven Nice Building","VDecoHeaven");
	} else {
		_g.h["Heaven Nice Building"] = "VDecoHeaven";
	}
	if(__map_reserved["Heaven Gorgeous Building"] != null) {
		_g.setReserved("Heaven Gorgeous Building","VDecoHeaven");
	} else {
		_g.h["Heaven Gorgeous Building"] = "VDecoHeaven";
	}
	if(__map_reserved["Hell House"] != null) {
		_g.setReserved("Hell House","VHouseHell");
	} else {
		_g.h["Hell House"] = "VHouseHell";
	}
	if(__map_reserved["Hell Collector Iron Mines"] != null) {
		_g.setReserved("Hell Collector Iron Mines","VCollectorHell");
	} else {
		_g.h["Hell Collector Iron Mines"] = "VCollectorHell";
	}
	if(__map_reserved.Factory != null) {
<<<<<<< 12929c27180a485bacfa82b7fa41d0db56208271:bin/ui.js
		_g.setReserved("Factory","VQuarry");
	} else {
		_g.h["Factory"] = "VQuarry";
=======
		_g.setReserved("Factory","VFactory");
	} else {
		_g.h["Factory"] = "VFactory";
>>>>>>> add time info has a const for minute seconde and houre and can transform a time in ms at time format hh, mm, ss:bin/Builder.js
	}
	if(__map_reserved["Generic Rock"] != null) {
		_g.setReserved("Generic Rock","VDecoHell");
	} else {
		_g.h["Generic Rock"] = "VDecoHell";
	}
	if(__map_reserved["Bigger Rock"] != null) {
		_g.setReserved("Bigger Rock","VDecoHell");
	} else {
		_g.h["Bigger Rock"] = "VDecoHell";
	}
	if(__map_reserved["Pretty Rock"] != null) {
		_g.setReserved("Pretty Rock","VDecoHell");
	} else {
		_g.h["Pretty Rock"] = "VDecoHell";
	}
	if(__map_reserved["Awesome Rock"] != null) {
		_g.setReserved("Awesome Rock","VDecoHell");
	} else {
		_g.h["Awesome Rock"] = "VDecoHell";
	}
	if(__map_reserved["Hell Nice Building"] != null) {
		_g.setReserved("Hell Nice Building","VDecoHell");
	} else {
		_g.h["Hell Nice Building"] = "VDecoHell";
	}
	if(__map_reserved["Hell Gorgeous Building"] != null) {
		_g.setReserved("Hell Gorgeous Building","VDecoHell");
	} else {
		_g.h["Hell Gorgeous Building"] = "VDecoHell";
	}
	if(__map_reserved["Intern Building"] != null) {
		_g.setReserved("Intern Building","VHouseHell");
	} else {
		_g.h["Intern Building"] = "VHouseHell";
	}
=======
	if(__map_reserved.Purgatory != null) _g.setReserved("Purgatory","VTribunal"); else _g.h["Purgatory"] = "VTribunal";
	if(__map_reserved["Altar Vice"] != null) _g.setReserved("Altar Vice","VVirtuesBuilding"); else _g.h["Altar Vice"] = "VVirtuesBuilding";
	if(__map_reserved["Altar Virtue"] != null) _g.setReserved("Altar Virtue","VVirtuesBuilding"); else _g.h["Altar Virtue"] = "VVirtuesBuilding";
	if(__map_reserved.Market != null) _g.setReserved("Market","VHouseHell"); else _g.h["Market"] = "VHouseHell";
	if(__map_reserved["Heaven House"] != null) _g.setReserved("Heaven House","VHouseHeaven"); else _g.h["Heaven House"] = "VHouseHeaven";
	if(__map_reserved["Heaven Collector Lumber Mill"] != null) _g.setReserved("Heaven Collector Lumber Mill","VLumbermill"); else _g.h["Heaven Collector Lumber Mill"] = "VLumbermill";
	if(__map_reserved["Marketing Department"] != null) _g.setReserved("Marketing Department","VHouseHell"); else _g.h["Marketing Department"] = "VHouseHell";
	if(__map_reserved["Generic Tree"] != null) _g.setReserved("Generic Tree","VDecoHeaven"); else _g.h["Generic Tree"] = "VDecoHeaven";
	if(__map_reserved["Bigger Tree"] != null) _g.setReserved("Bigger Tree","VDecoHeaven"); else _g.h["Bigger Tree"] = "VDecoHeaven";
	if(__map_reserved["Pretty Tree"] != null) _g.setReserved("Pretty Tree","VDecoHeaven"); else _g.h["Pretty Tree"] = "VDecoHeaven";
	if(__map_reserved["Awesome Tree"] != null) _g.setReserved("Awesome Tree","VDecoHeaven"); else _g.h["Awesome Tree"] = "VDecoHeaven";
	if(__map_reserved["Heaven Nice Building"] != null) _g.setReserved("Heaven Nice Building","VDecoHeaven"); else _g.h["Heaven Nice Building"] = "VDecoHeaven";
	if(__map_reserved["Heaven Gorgeous Building"] != null) _g.setReserved("Heaven Gorgeous Building","VDecoHeaven"); else _g.h["Heaven Gorgeous Building"] = "VDecoHeaven";
	if(__map_reserved["Hell House"] != null) _g.setReserved("Hell House","VHouseHell"); else _g.h["Hell House"] = "VHouseHell";
	if(__map_reserved["Hell Collector Iron Mines"] != null) _g.setReserved("Hell Collector Iron Mines","VHouseHell"); else _g.h["Hell Collector Iron Mines"] = "VHouseHell";
	if(__map_reserved.Factory != null) _g.setReserved("Factory","VQuarry"); else _g.h["Factory"] = "VQuarry";
	if(__map_reserved["Generic Rock"] != null) _g.setReserved("Generic Rock","VDecoHell"); else _g.h["Generic Rock"] = "VDecoHell";
	if(__map_reserved["Bigger Rock"] != null) _g.setReserved("Bigger Rock","VDecoHell"); else _g.h["Bigger Rock"] = "VDecoHell";
	if(__map_reserved["Pretty Rock"] != null) _g.setReserved("Pretty Rock","VDecoHell"); else _g.h["Pretty Rock"] = "VDecoHell";
	if(__map_reserved["Awesome Rock"] != null) _g.setReserved("Awesome Rock","VDecoHell"); else _g.h["Awesome Rock"] = "VDecoHell";
	if(__map_reserved["Hell Nice Building"] != null) _g.setReserved("Hell Nice Building","VDecoHell"); else _g.h["Hell Nice Building"] = "VDecoHell";
	if(__map_reserved["Hell Gorgeous Building"] != null) _g.setReserved("Hell Gorgeous Building","VDecoHell"); else _g.h["Hell Gorgeous Building"] = "VDecoHell";
	if(__map_reserved["Intern Building"] != null) _g.setReserved("Intern Building","VHouseHell"); else _g.h["Intern Building"] = "VHouseHell";
>>>>>>> btn accelerate working:bin/Builder.js
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_virtual_Virtual.BUILDING_NAME_TO_ALIGNEMENT = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.set("Purgatory",com_isartdigital_perle_game_managers_Alignment.neutral);
	_g.set("Altar Vice",com_isartdigital_perle_game_managers_Alignment.neutral);
	_g.set("Altar Virtue",com_isartdigital_perle_game_managers_Alignment.neutral);
	_g.set("Market",com_isartdigital_perle_game_managers_Alignment.neutral);
	_g.set("Heaven House",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Heaven Collector Lumber Mill",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Marketing Department",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Generic Tree",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Bigger Tree",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Pretty Tree",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Awesome Tree",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Heaven Nice Building",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Heaven Gorgeous Building",com_isartdigital_perle_game_managers_Alignment.heaven);
	_g.set("Hell House",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Hell Collector Iron Mines",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Factory",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Generic Rock",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Bigger Rock",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Pretty Rock",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Awesome Rock",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Hell Nice Building",com_isartdigital_perle_game_managers_Alignment.hell);
	_g.set("Hell Gorgeous Building",com_isartdigital_perle_game_managers_Alignment.hell);
	if(__map_reserved["Intern Building"] != null) _g.setReserved("Intern Building",null); else _g.h["Intern Building"] = null;
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_game_virtual_VTile.ROAD_MAP = [["","","","","Road_br","Road_tl","",""],["","","","Road_br","Road_tl","","",""],["Road_v","Road_v","Road_v","Road_c","","","",""],["","","","Road_h","","","",""],["Road_v","Road_v","Road_v","Road_tl","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""]];
com_isartdigital_perle_game_virtual_vBuilding_VAltar.ZONESIZE = 4;
com_isartdigital_utils_ui_Button.UP = 0;
com_isartdigital_utils_ui_Button.OVER = 1;
com_isartdigital_utils_ui_Button.DOWN = 2;
com_isartdigital_perle_ui_hud_Hud.isHide = false;
com_isartdigital_perle_ui_hud_building_BuildingHud.VBUILDING_STATE_TO_BH_TYPE = (function($this) {
	var $r;
	var _g = new haxe_ds_EnumValueMap();
	_g.set(com_isartdigital_perle_game_virtual_VBuildingState.isBuilt,com_isartdigital_perle_ui_hud_BuildingHudType.HARVEST);
	_g.set(com_isartdigital_perle_game_virtual_VBuildingState.isBuilding,com_isartdigital_perle_ui_hud_BuildingHudType.CONSTRUCTION);
	_g.set(com_isartdigital_perle_game_virtual_VBuildingState.isMoving,com_isartdigital_perle_ui_hud_BuildingHudType.MOVING);
	$r = _g;
	return $r;
}(this));
com_isartdigital_perle_ui_popin_choice_Choice.EVENT_CHOICE_DONE = "Choice_Done";
com_isartdigital_perle_ui_popin_choice_Choice.MOUSE_DIFF_MAX = 200;
com_isartdigital_perle_ui_popin_choice_Choice.DIFF_MAX = 80;
com_isartdigital_perle_ui_popin_listIntern_InternElementInQuest.canPushNewScreen = false;
com_isartdigital_perle_ui_popin_shop_CarousselCardLock.UNLOCK_TEXT = "Level : ";
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.buildingNameList = ["Altar Vice","Altar Virtue","Market","Heaven House","Heaven Collector Lumber Mill","Marketing Department","Hell House","Hell Collector Iron Mines","Factory","Intern Building"];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.decoNameList = ["Generic Tree","Bigger Tree","Pretty Tree","Awesome Tree","Heaven Nice Building","Heaven Gorgeous Building","Generic Rock","Bigger Rock","Pretty Rock","Awesome Rock","Hell Nice Building","Hell Gorgeous Building"];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.internsNameList = [];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.resourcesNameList = ["Wood pack","Iron pack"];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.currencieNameList = ["Gold pack","Karma pack"];
com_isartdigital_perle_ui_popin_shop_ShopCaroussel.bundleNameList = [];
com_isartdigital_services_facebook_Facebook.permissions = { scope : "user_friends,email"};
com_isartdigital_services_facebook_Facebook.isFirstAttempt = true;
com_isartdigital_utils_events_EventType.GAME_LOOP = "gameLoop";
com_isartdigital_utils_events_EventType.RESIZE = "resize";
com_isartdigital_utils_events_EventType.ADDED = "added";
com_isartdigital_utils_events_EventType.REMOVED = "removed";
com_isartdigital_services_facebook_events_FacebookEventType.CONNECTED = "connected";
com_isartdigital_services_facebook_events_FacebookEventType.NOT_AUTHORIZED = "not_authorized";
com_isartdigital_services_facebook_events_FacebookEventType.UNKNOWN = "unknown";
com_isartdigital_utils_Config.cache = true;
com_isartdigital_utils_Config._data = { };
com_isartdigital_utils_Debug.QR_SIZE = 0.35;
com_isartdigital_utils_events_KeyboardEventType.KEY_DOWN = "keydown";
com_isartdigital_utils_events_KeyboardEventType.KEY_UP = "keyup";
com_isartdigital_utils_events_LoadEventType.COMPLETE = "complete";
com_isartdigital_utils_events_LoadEventType.LOADED = "load";
com_isartdigital_utils_events_LoadEventType.PROGRESS = "progress";
com_isartdigital_utils_events_LoadEventType.ERROR = "error";
com_isartdigital_utils_events_MouseEventType.MOUSE_MOVE = "mousemove";
com_isartdigital_utils_events_MouseEventType.MOUSE_DOWN = "mousedown";
com_isartdigital_utils_events_MouseEventType.MOUSE_OUT = "mouseout";
com_isartdigital_utils_events_MouseEventType.MOUSE_OVER = "mouseover";
com_isartdigital_utils_events_MouseEventType.MOUSE_UP = "mouseup";
com_isartdigital_utils_events_MouseEventType.MOUSE_UP_OUTSIDE = "mouseupoutside";
com_isartdigital_utils_events_MouseEventType.CLICK = "click";
com_isartdigital_utils_events_MouseEventType.RIGHT_DOWN = "rightdown";
com_isartdigital_utils_events_MouseEventType.RIGHT_UP = "rightup";
com_isartdigital_utils_events_MouseEventType.RIGHT_UP_OUTSIDE = "rightupoutside";
com_isartdigital_utils_events_MouseEventType.RIGHT_CLICK = "rightclick";
com_isartdigital_utils_events_TouchEventType.TOUCH_START = "touchstart";
com_isartdigital_utils_events_TouchEventType.TOUCH_MOVE = "touchmove";
com_isartdigital_utils_events_TouchEventType.TOUCH_END = "touchend";
com_isartdigital_utils_events_TouchEventType.TOUCH_END_OUTSIDE = "touchendoutside";
com_isartdigital_utils_events_TouchEventType.TAP = "tap";
com_isartdigital_utils_game_GameStage.SAFE_ZONE_WIDTH = 2048;
com_isartdigital_utils_game_GameStage.SAFE_ZONE_HEIGHT = 1366;
com_isartdigital_utils_loader_GameLoader.txtLoaded = new haxe_ds_StringMap();
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_ANDROID = "Android";
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_IOS = "iOS";
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_BLACKBERRY = "BlackBerry";
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_BB_PLAYBOOK = "BlackBerry PlayBook";
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_WINDOWS_MOBILE = "IEMobile";
com_isartdigital_utils_system_DeviceCapabilities.SYSTEM_DESKTOP = "Desktop";
com_isartdigital_utils_system_DeviceCapabilities.ICON_SIZE = 0.11;
com_isartdigital_utils_system_DeviceCapabilities.TEXTURE_NO_SCALE = "";
com_isartdigital_utils_system_DeviceCapabilities.TEXTURE_HD = "hd";
com_isartdigital_utils_system_DeviceCapabilities.TEXTURE_MD = "md";
com_isartdigital_utils_system_DeviceCapabilities.TEXTURE_LD = "ld";
com_isartdigital_utils_system_DeviceCapabilities.texturesRatios = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	if(__map_reserved.hd != null) _g.setReserved("hd",1); else _g.h["hd"] = 1;
	if(__map_reserved.md != null) _g.setReserved("md",0.5); else _g.h["md"] = 0.5;
	if(__map_reserved.ld != null) _g.setReserved("ld",0.25); else _g.h["ld"] = 0.25;
	$r = _g;
	return $r;
}(this));
com_isartdigital_utils_system_DeviceCapabilities.textureRatio = 1;
com_isartdigital_utils_system_DeviceCapabilities.textureType = "";
com_isartdigital_utils_system_DeviceCapabilities.screenRatio = 1;
com_isartdigital_utils_ui_UIPosition.LEFT = "left";
com_isartdigital_utils_ui_UIPosition.RIGHT = "right";
com_isartdigital_utils_ui_UIPosition.TOP = "top";
com_isartdigital_utils_ui_UIPosition.BOTTOM = "bottom";
com_isartdigital_utils_ui_UIPosition.TOP_LEFT = "topLeft";
com_isartdigital_utils_ui_UIPosition.TOP_RIGHT = "topRight";
com_isartdigital_utils_ui_UIPosition.BOTTOM_LEFT = "bottomLeft";
com_isartdigital_utils_ui_UIPosition.BOTTOM_RIGHT = "bottomRight";
com_isartdigital_utils_ui_UIPosition.BOTTOM_CENTER = "bottomCenter";
com_isartdigital_utils_ui_UIPosition.TOP_CENTER = "topCenter";
com_isartdigital_utils_ui_UIPosition.FIT_WIDTH = "fitWidth";
com_isartdigital_utils_ui_UIPosition.FIT_HEIGHT = "fitHeight";
com_isartdigital_utils_ui_UIPosition.FIT_SCREEN = "fitScreen";
com_isartdigital_utils_ui_smart_TextSprite.parseText = com_isartdigital_utils_ui_smart_TextSprite.defaultParseText;
flump_library_Label.LABEL_ENTER = "labelEnter";
flump_library_Label.LABEL_EXIT = "labelExit";
flump_library_Label.LABEL_UPDATE = "labelUpdate";
haxe_ds_ObjectMap.count = 0;
haxe_xml_Parser.escapes = (function($this) {
	var $r;
	var h = new haxe_ds_StringMap();
	if(__map_reserved.lt != null) h.setReserved("lt","<"); else h.h["lt"] = "<";
	if(__map_reserved.gt != null) h.setReserved("gt",">"); else h.h["gt"] = ">";
	if(__map_reserved.amp != null) h.setReserved("amp","&"); else h.h["amp"] = "&";
	if(__map_reserved.quot != null) h.setReserved("quot","\""); else h.h["quot"] = "\"";
	if(__map_reserved.apos != null) h.setReserved("apos","'"); else h.h["apos"] = "'";
	$r = h;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
pixi_flump_Resource.resources = new haxe_ds_StringMap();
<<<<<<< HEAD:bin/ui.js
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
=======
com_isartdigital_perle_Main.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : exports, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=Builder.js.map
>>>>>>> btn accelerate working:bin/Builder.js
