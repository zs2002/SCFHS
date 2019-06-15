Type.registerNamespace("Telerik.Web.Animation");
var $TWA=Telerik.Web.Animation;
$TWA.registerAnimation=function(_1,_2){
if(_2&&((_2===$TWA.Animation)||(_2.inheritsFrom&&_2.inheritsFrom($TWA.Animation)))){
if(!$TWA.__animations){
$TWA.__animations={};
}
$TWA.__animations[_1.toLowerCase()]=_2;
_2.play=function(){
var _3=new _2();
_2.apply(_3,arguments);
_3.initialize();
var _4=Function.createDelegate(_3,function(){
_3.remove_ended(_4);
_4=null;
_3.dispose();
});
_3.add_ended(_4);
_3.play();
};
}else{
throw Error.argumentType("type",_2,$TWA.Animation,"Telerik.Web.Animation.registerAnimation can only register types that inherit from Telerik.Web.Animation.Animation");
}
};
$TWA.Animation=function(_5,_6,_7){
$TWA.Animation.initializeBase(this);
this._duration=1;
this._fps=25;
this._target=null;
this._tickHandler=null;
this._timer=null;
this._percentComplete=0;
this._percentDelta=null;
this._owner=null;
this._parentAnimation=null;
this.DynamicProperties={};
if(_5){
this.set_target(_5);
}
if(_6){
this.set_duration(_6);
}
if(_7){
this.set_fps(_7);
}
};
$TWA.Animation.prototype={dispose:function(){
if(this._timer){
this._timer.dispose();
this._timer=null;
}
this._tickHandler=null;
this._target=null;
$TWA.Animation.callBaseMethod(this,"dispose");
},play:function(){
if(!this._owner){
var _8=true;
if(!this._timer){
_8=false;
if(!this._tickHandler){
this._tickHandler=Function.createDelegate(this,this._onTimerTick);
}
this._timer=new Telerik.Web.Timer();
this._timer.add_tick(this._tickHandler);
this.onStart();
this._timer.set_interval(1000/this._fps);
this._percentDelta=100/(this._duration*this._fps);
this._updatePercentComplete(0,true);
}
this._timer.set_enabled(true);
this.raisePropertyChanged("isPlaying");
if(!_8){
this.raisePropertyChanged("isActive");
}
}
},pause:function(){
if(!this._owner){
if(this._timer){
this._timer.set_enabled(false);
this.raisePropertyChanged("isPlaying");
}
}
},stop:function(_9){
if(!this._owner){
var t=this._timer;
this._timer=null;
if(t){
t.dispose();
if(this._percentComplete!==100){
this._percentComplete=100;
this.raisePropertyChanged("percentComplete");
if(_9||_9===undefined){
this.onStep(100);
}
}
this.onEnd();
this.raisePropertyChanged("isPlaying");
this.raisePropertyChanged("isActive");
}
}
},onStart:function(){
this.raiseStarted();
for(var _b in this.DynamicProperties){
try{
this[_b](eval(this.DynamicProperties[_b]));
}
catch(ex){
if(Sys.Debug.isDebug){
throw ex;
}
}
}
},onStep:function(_c){
this.setValue(this.getAnimatedValue(_c));
},onEnd:function(){
this.raiseEnded();
},getAnimatedValue:function(_d){
throw Error.notImplemented();
},setValue:function(_e){
throw Error.notImplemented();
},interpolate:function(_f,end,_11){
return _f+(end-_f)*(_11/100);
},_onTimerTick:function(){
this._updatePercentComplete(this._percentComplete+this._percentDelta,true);
this.raise_onTick();
},_updatePercentComplete:function(_12,_13){
if(_12>100){
_12=100;
}
this._percentComplete=_12;
this.raisePropertyChanged("percentComplete");
if(_13){
this.onStep(_12);
}
if(_12===100){
this.stop(false);
}
},setOwner:function(_14){
this._owner=_14;
},raiseStarted:function(){
var _15=this.get_events().getHandler("started");
if(_15){
_15(this,Sys.EventArgs.Empty);
}
},add_started:function(_16){
this.get_events().addHandler("started",_16);
},remove_started:function(_17){
this.get_events().removeHandler("started",_17);
},raiseEnded:function(){
var _18=this.get_events().getHandler("ended");
if(_18){
_18(this,Sys.EventArgs.Empty);
}
},add_ended:function(_19){
this.get_events().addHandler("ended",_19);
},remove_ended:function(_1a){
this.get_events().removeHandler("ended",_1a);
},raise_onTick:function(){
var _1b=this.get_events().getHandler("onTick");
if(_1b){
_1b(this,Sys.EventArgs.Empty);
}
},add_onTick:function(_1c){
this.get_events().addHandler("onTick",_1c);
},remove_onTick:function(_1d){
this.get_events().removeHandler("onTick",_1d);
},get_target:function(){
if(!this._target&&this._parentAnimation){
return this._parentAnimation.get_target();
}
return this._target;
},set_target:function(_1e){
if(this._target!=_1e){
this._target=_1e;
this.raisePropertyChanged("target");
}
},set_animationTarget:function(id){
var _20=null;
var _21=$get(id);
if(_21){
_20=_21;
}else{
var _22=$find(id);
if(_22){
_21=_22.get_element();
if(_21){
_20=_21;
}
}
}
if(_20){
this.set_target(_20);
}else{
throw Error.argument("id",String.format("Telerik.Web.Animation.Animation.set_animationTarget requires the ID of a Sys.UI.DomElement or Sys.UI.Control.  No element or control could be found corresponding to \"{0}\"",id));
}
},get_duration:function(){
return this._duration;
},set_duration:function(_23){
_23=this._getFloat(_23);
if(this._duration!=_23){
this._duration=_23;
this.raisePropertyChanged("duration");
}
},get_fps:function(){
return this._fps;
},set_fps:function(_24){
_24=this._getInteger(_24);
if(this.fps!=_24){
this._fps=_24;
this.raisePropertyChanged("fps");
}
},get_isActive:function(){
return (this._timer!==null);
},get_isPlaying:function(){
return (this._timer!==null)&&this._timer.get_enabled();
},get_percentComplete:function(){
return this._percentComplete;
},_getBoolean:function(_25){
if(String.isInstanceOfType(_25)){
return Boolean.parse(_25);
}
return _25;
},_getInteger:function(_26){
if(String.isInstanceOfType(_26)){
return parseInt(_26);
}
return _26;
},_getFloat:function(_27){
if(String.isInstanceOfType(_27)){
return parseFloat(_27);
}
return _27;
},_getEnum:function(_28,_29){
if(String.isInstanceOfType(_28)&&_29&&_29.parse){
return _29.parse(_28);
}
return _28;
}};
$TWA.Animation.registerClass("Telerik.Web.Animation.Animation",Sys.Component);
$TWA.registerAnimation("animation",$TWA.Animation);
$TWA.ParentAnimation=function(_2a,_2b,fps,_2d){
$TWA.ParentAnimation.initializeBase(this,[_2a,_2b,fps]);
this._animations=[];
if(_2d&&_2d.length){
for(var i=0;i<_2d.length;i++){
this.add(_2d[i]);
}
}
};
$TWA.ParentAnimation.prototype={initialize:function(){
$TWA.ParentAnimation.callBaseMethod(this,"initialize");
if(this._animations){
for(var i=0;i<this._animations.length;i++){
var _30=this._animations[i];
if(_30&&!_30.get_isInitialized){
_30.initialize();
}
}
}
},dispose:function(){
this.clear();
this._animations=null;
$TWA.ParentAnimation.callBaseMethod(this,"dispose");
},get_animations:function(){
return this._animations;
},add:function(_31){
if(this._animations){
if(_31){
_31._parentAnimation=this;
}
Array.add(this._animations,_31);
this.raisePropertyChanged("animations");
}
},remove:function(_32){
if(this._animations){
if(_32){
_32.dispose();
}
Array.remove(this._animations,_32);
this.raisePropertyChanged("animations");
}
},removeAt:function(_33){
if(this._animations){
var _34=this._animations[_33];
if(_34){
_34.dispose();
}
Array.removeAt(this._animations,_33);
this.raisePropertyChanged("animations");
}
},clear:function(){
if(this._animations){
for(var i=this._animations.length-1;i>=0;i--){
this._animations[i].dispose();
this._animations[i]=null;
}
Array.clear(this._animations);
this._animations=[];
this.raisePropertyChanged("animations");
}
}};
$TWA.ParentAnimation.registerClass("Telerik.Web.Animation.ParentAnimation",$TWA.Animation);
$TWA.registerAnimation("parent",$TWA.ParentAnimation);
$TWA.ParallelAnimation=function(_36,_37,fps,_39){
$TWA.ParallelAnimation.initializeBase(this,[_36,_37,fps,_39]);
};
$TWA.ParallelAnimation.prototype={add:function(_3a){
$TWA.ParallelAnimation.callBaseMethod(this,"add",[_3a]);
_3a.setOwner(this);
},onStart:function(){
$TWA.ParallelAnimation.callBaseMethod(this,"onStart");
var _3b=this.get_animations();
for(var i=0;i<_3b.length;i++){
_3b[i].onStart();
}
},onStep:function(_3d){
var _3e=this.get_animations();
for(var i=0;i<_3e.length;i++){
_3e[i].onStep(_3d);
}
},onEnd:function(){
var _40=this.get_animations();
for(var i=0;i<_40.length;i++){
_40[i].onEnd();
}
$TWA.ParallelAnimation.callBaseMethod(this,"onEnd");
}};
$TWA.ParallelAnimation.registerClass("Telerik.Web.Animation.ParallelAnimation",$TWA.ParentAnimation);
$TWA.registerAnimation("parallel",$TWA.ParallelAnimation);
$TWA.FadeEffect=function(){
throw Error.invalidOperation();
};
$TWA.FadeEffect.prototype={FadeIn:0,FadeOut:1};
$TWA.FadeEffect.registerEnum("Telerik.Web.Animation.FadeEffect",false);
$TWA.FadeAnimation=function(_42,_43,fps,_45,_46,_47,_48){
$TWA.FadeAnimation.initializeBase(this,[_42,_43,fps]);
this._effect=(_45!==undefined)?_45:$TWA.FadeEffect.FadeIn;
this._max=(_47!==undefined)?_47:1;
this._min=(_46!==undefined)?_46:0;
this._start=this._min;
this._end=this._max;
this._layoutCreated=false;
this._forceLayoutInIE=(_48===undefined||_48===null)?true:_48;
this._currentTarget=null;
this._resetOpacities();
};
$TWA.FadeAnimation.prototype={_resetOpacities:function(){
if(this._effect==$TWA.FadeEffect.FadeIn){
this._start=this._min;
this._end=this._max;
}else{
this._start=this._max;
this._end=this._min;
}
},_createLayout:function(){
var _49=this._currentTarget;
if(_49){
var _4a=$telerik.getCurrentStyle(_49,"width");
var _4b=$telerik.getCurrentStyle(_49,"height");
var _4c=$telerik.getCurrentStyle(_49,"backgroundColor");
if((!_4a||_4a==""||_4a=="auto")&&(!_4b||_4b==""||_4b=="auto")){
_49.style.width=_49.offsetWidth+"px";
}
if(!_4c||_4c==""||_4c=="transparent"||_4c=="rgba(0, 0, 0, 0)"){
_49.style.backgroundColor=$telerik.getInheritedBackgroundColor(_49);
}
this._layoutCreated=true;
}
},onStart:function(){
$TWA.FadeAnimation.callBaseMethod(this,"onStart");
this._currentTarget=this.get_target();
this.setValue(this._start);
if(this._forceLayoutInIE&&!this._layoutCreated&&Sys.Browser.agent==Sys.Browser.InternetExplorer){
this._createLayout();
}
},getAnimatedValue:function(_4d){
return this.interpolate(this._start,this._end,_4d);
},setValue:function(_4e){
if(this._currentTarget){
$telerik.setOpacity(this._currentTarget,_4e);
}
},get_effect:function(){
return this._effect;
},set_effect:function(_4f){
_4f=this._getEnum(_4f,$TWA.FadeEffect);
if(this._effect!=_4f){
this._effect=_4f;
this._resetOpacities();
this.raisePropertyChanged("effect");
}
},get_minimumOpacity:function(){
return this._min;
},set_minimumOpacity:function(_50){
_50=this._getFloat(_50);
if(this._min!=_50){
this._min=_50;
this._resetOpacities();
this.raisePropertyChanged("minimumOpacity");
}
},get_maximumOpacity:function(){
return this._max;
},set_maximumOpacity:function(_51){
_51=this._getFloat(_51);
if(this._max!=_51){
this._max=_51;
this._resetOpacities();
this.raisePropertyChanged("maximumOpacity");
}
},get_forceLayoutInIE:function(){
return this._forceLayoutInIE;
},set_forceLayoutInIE:function(_52){
_52=this._getBoolean(_52);
if(this._forceLayoutInIE!=_52){
this._forceLayoutInIE=_52;
this.raisePropertyChanged("forceLayoutInIE");
}
},set_startValue:function(_53){
_53=this._getFloat(_53);
this._start=_53;
}};
$TWA.FadeAnimation.registerClass("Telerik.Web.Animation.FadeAnimation",$TWA.Animation);
$TWA.registerAnimation("fade",$TWA.FadeAnimation);
$TWA.FadeInAnimation=function(_54,_55,fps,_57,_58,_59){
$TWA.FadeInAnimation.initializeBase(this,[_54,_55,fps,$TWA.FadeEffect.FadeIn,_57,_58,_59]);
};
$TWA.FadeInAnimation.prototype={onStart:function(){
$TWA.FadeInAnimation.callBaseMethod(this,"onStart");
if(this._currentTarget){
this.set_startValue($telerik.getOpacity(this._currentTarget));
}
}};
$TWA.FadeInAnimation.registerClass("Telerik.Web.Animation.FadeInAnimation",$TWA.FadeAnimation);
$TWA.registerAnimation("fadeIn",$TWA.FadeInAnimation);
$TWA.FadeOutAnimation=function(_5a,_5b,fps,_5d,_5e,_5f){
$TWA.FadeOutAnimation.initializeBase(this,[_5a,_5b,fps,$TWA.FadeEffect.FadeOut,_5d,_5e,_5f]);
};
$TWA.FadeOutAnimation.prototype={onStart:function(){
$TWA.FadeOutAnimation.callBaseMethod(this,"onStart");
if(this._currentTarget){
this.set_startValue($telerik.getOpacity(this._currentTarget));
}
}};
$TWA.FadeOutAnimation.registerClass("Telerik.Web.Animation.FadeOutAnimation",$TWA.FadeAnimation);
$TWA.registerAnimation("fadeOut",$TWA.FadeOutAnimation);
$TWA.PropertyAnimation=function(_60,_61,fps,_63,_64){
$TWA.PropertyAnimation.initializeBase(this,[_60,_61,fps]);
this._property=_63;
this._propertyKey=_64;
this._currentTarget=null;
};
$TWA.PropertyAnimation.prototype={onStart:function(){
$TWA.PropertyAnimation.callBaseMethod(this,"onStart");
this._currentTarget=this.get_target();
},setValue:function(_65){
var _66=this._currentTarget;
if(_66&&this._property&&this._property.length>0){
if(this._propertyKey&&this._propertyKey.length>0&&_66[this._property]){
_66[this._property][this._propertyKey]=_65;
}else{
_66[this._property]=_65;
}
}
},getValue:function(){
var _67=this.get_target();
if(_67&&this._property&&this._property.length>0){
var _68=_67[this._property];
if(_68){
if(this._propertyKey&&this._propertyKey.length>0){
return _68[this._propertyKey];
}
return _68;
}
}
return null;
},get_property:function(){
return this._property;
},set_property:function(_69){
if(this._property!=_69){
this._property=_69;
this.raisePropertyChanged("property");
}
},get_propertyKey:function(){
return this._propertyKey;
},set_propertyKey:function(_6a){
if(this._propertyKey!=_6a){
this._propertyKey=_6a;
this.raisePropertyChanged("propertyKey");
}
}};
$TWA.PropertyAnimation.registerClass("Telerik.Web.Animation.PropertyAnimation",$TWA.Animation);
$TWA.registerAnimation("property",$TWA.PropertyAnimation);
$TWA.DiscreteAnimation=function(_6b,_6c,fps,_6e,_6f,_70){
$TWA.DiscreteAnimation.initializeBase(this,[_6b,_6c,fps,_6e,_6f]);
this._values=(_70&&_70.length)?_70:[];
};
$TWA.DiscreteAnimation.prototype={getAnimatedValue:function(_71){
var _72=Math.floor(this.interpolate(0,this._values.length-1,_71));
return this._values[_72];
},get_values:function(){
return this._values;
},set_values:function(_73){
if(this._values!=_73){
this._values=_73;
this.raisePropertyChanged("values");
}
}};
$TWA.DiscreteAnimation.registerClass("Telerik.Web.Animation.DiscreteAnimation",$TWA.PropertyAnimation);
$TWA.registerAnimation("discrete",$TWA.DiscreteAnimation);
$TWA.InterpolatedAnimation=function(_74,_75,fps,_77,_78,_79,_7a){
$TWA.InterpolatedAnimation.initializeBase(this,[_74,_75,fps,((_77!==undefined)?_77:"style"),_78]);
this._startValue=_79;
this._endValue=_7a;
};
$TWA.InterpolatedAnimation.prototype={get_startValue:function(){
return this._startValue;
},set_startValue:function(_7b){
_7b=this._getFloat(_7b);
if(this._startValue!=_7b){
this._startValue=_7b;
this.raisePropertyChanged("startValue");
}
},get_endValue:function(){
return this._endValue;
},set_endValue:function(_7c){
_7c=this._getFloat(_7c);
if(this._endValue!=_7c){
this._endValue=_7c;
this.raisePropertyChanged("endValue");
}
}};
$TWA.InterpolatedAnimation.registerClass("Telerik.Web.Animation.InterpolatedAnimation",$TWA.PropertyAnimation);
$TWA.registerAnimation("interpolated",$TWA.InterpolatedAnimation);
$TWA.ColorAnimation=function(_7d,_7e,fps,_80,_81,_82,_83){
$TWA.ColorAnimation.initializeBase(this,[_7d,_7e,fps,_80,_81,_82,_83]);
this._start=null;
this._end=null;
this._interpolateRed=false;
this._interpolateGreen=false;
this._interpolateBlue=false;
};
$TWA.ColorAnimation.prototype={onStart:function(){
$TWA.ColorAnimation.callBaseMethod(this,"onStart");
this._start=$TWA.ColorAnimation.getRGB(this.get_startValue());
this._end=$TWA.ColorAnimation.getRGB(this.get_endValue());
this._interpolateRed=(this._start.Red!=this._end.Red);
this._interpolateGreen=(this._start.Green!=this._end.Green);
this._interpolateBlue=(this._start.Blue!=this._end.Blue);
},getAnimatedValue:function(_84){
var r=this._start.Red;
var g=this._start.Green;
var b=this._start.Blue;
if(this._interpolateRed){
r=Math.round(this.interpolate(r,this._end.Red,_84));
}
if(this._interpolateGreen){
g=Math.round(this.interpolate(g,this._end.Green,_84));
}
if(this._interpolateBlue){
b=Math.round(this.interpolate(b,this._end.Blue,_84));
}
return $TWA.ColorAnimation.toColor(r,g,b);
},set_startValue:function(_88){
if(this._startValue!=_88){
this._startValue=_88;
this.raisePropertyChanged("startValue");
}
},set_endValue:function(_89){
if(this._endValue!=_89){
this._endValue=_89;
this.raisePropertyChanged("endValue");
}
}};
$TWA.ColorAnimation.getRGB=function(_8a){
if(!_8a||_8a.length!=7){
throw String.format("Color must be a 7-character hex representation (e.g. #246ACF), not \"{0}\"",_8a);
}
return {"Red":parseInt(_8a.substr(1,2),16),"Green":parseInt(_8a.substr(3,2),16),"Blue":parseInt(_8a.substr(5,2),16)};
};
$TWA.ColorAnimation.toColor=function(red,_8c,_8d){
var r=red.toString(16);
var g=_8c.toString(16);
var b=_8d.toString(16);
if(r.length==1){
r="0"+r;
}
if(g.length==1){
g="0"+g;
}
if(b.length==1){
b="0"+b;
}
return "#"+r+g+b;
};
$TWA.ColorAnimation.registerClass("Telerik.Web.Animation.ColorAnimation",$TWA.InterpolatedAnimation);
$TWA.registerAnimation("color",$TWA.ColorAnimation);
$TWA.LengthAnimation=function(_91,_92,fps,_94,_95,_96,_97,_98){
$TWA.LengthAnimation.initializeBase(this,[_91,_92,fps,_94,_95,_96,_97]);
this._unit=(_98!=null)?_98:"px";
};
$TWA.LengthAnimation.prototype={getAnimatedValue:function(_99){
var _9a=this.interpolate(this.get_startValue(),this.get_endValue(),_99);
return Math.round(_9a)+this._unit;
},get_unit:function(){
return this._unit;
},set_unit:function(_9b){
if(this._unit!=_9b){
this._unit=_9b;
this.raisePropertyChanged("unit");
}
}};
$TWA.LengthAnimation.registerClass("Telerik.Web.Animation.LengthAnimation",$TWA.InterpolatedAnimation);
$TWA.registerAnimation("length",$TWA.LengthAnimation);
$TWA.MoveAnimation=function(_9c,_9d,fps,_9f,_a0,_a1,_a2){
$TWA.MoveAnimation.initializeBase(this,[_9c,_9d,fps,null]);
this._horizontal=_9f?_9f:0;
this._vertical=_a0?_a0:0;
this._relative=(_a1===undefined)?true:_a1;
this._horizontalAnimation=new $TWA.LengthAnimation(_9c,_9d,fps,"style","left",null,null,_a2);
this._verticalAnimation=new $TWA.LengthAnimation(_9c,_9d,fps,"style","top",null,null,_a2);
this.add(this._verticalAnimation);
this.add(this._horizontalAnimation);
};
$TWA.MoveAnimation.prototype={onStart:function(){
$TWA.MoveAnimation.callBaseMethod(this,"onStart");
var _a3=this.get_target();
this._horizontalAnimation.set_startValue(_a3.offsetLeft);
this._horizontalAnimation.set_endValue(this._relative?_a3.offsetLeft+this._horizontal:this._horizontal);
this._verticalAnimation.set_startValue(_a3.offsetTop);
this._verticalAnimation.set_endValue(this._relative?_a3.offsetTop+this._vertical:this._vertical);
},get_horizontal:function(){
return this._horizontal;
},set_horizontal:function(_a4){
_a4=this._getFloat(_a4);
if(this._horizontal!=_a4){
this._horizontal=_a4;
this.raisePropertyChanged("horizontal");
}
},get_vertical:function(){
return this._vertical;
},set_vertical:function(_a5){
_a5=this._getFloat(_a5);
if(this._vertical!=_a5){
this._vertical=_a5;
this.raisePropertyChanged("vertical");
}
},get_relative:function(){
return this._relative;
},set_relative:function(_a6){
_a6=this._getBoolean(_a6);
if(this._relative!=_a6){
this._relative=_a6;
this.raisePropertyChanged("relative");
}
},get_unit:function(){
this._horizontalAnimation.get_unit();
},set_unit:function(_a7){
var _a8=this._horizontalAnimation.get_unit();
if(_a8!=_a7){
this._horizontalAnimation.set_unit(_a7);
this._verticalAnimation.set_unit(_a7);
this.raisePropertyChanged("unit");
}
}};
$TWA.MoveAnimation.registerClass("Telerik.Web.Animation.MoveAnimation",$TWA.ParallelAnimation);
$TWA.registerAnimation("move",$TWA.MoveAnimation);
$TWA.ResizeAnimation=function(_a9,_aa,fps,_ac,_ad,_ae){
$TWA.ResizeAnimation.initializeBase(this,[_a9,_aa,fps,null]);
this._width=_ac;
this._height=_ad;
this._horizontalAnimation=new $TWA.LengthAnimation(_a9,_aa,fps,"style","width",null,null,_ae);
this._verticalAnimation=new $TWA.LengthAnimation(_a9,_aa,fps,"style","height",null,null,_ae);
this.add(this._horizontalAnimation);
this.add(this._verticalAnimation);
};
$TWA.ResizeAnimation.prototype={onStart:function(){
$TWA.ResizeAnimation.callBaseMethod(this,"onStart");
var _af=this.get_target();
this._horizontalAnimation.set_startValue(_af.offsetWidth);
this._verticalAnimation.set_startValue(_af.offsetHeight);
this._horizontalAnimation.set_endValue((this._width!==null&&this._width!==undefined)?this._width:_af.offsetWidth);
this._verticalAnimation.set_endValue((this._height!==null&&this._height!==undefined)?this._height:_af.offsetHeight);
},get_width:function(){
return this._width;
},set_width:function(_b0){
_b0=this._getFloat(_b0);
if(this._width!=_b0){
this._width=_b0;
this.raisePropertyChanged("width");
}
},get_height:function(){
return this._height;
},set_height:function(_b1){
_b1=this._getFloat(_b1);
if(this._height!=_b1){
this._height=_b1;
this.raisePropertyChanged("height");
}
},get_unit:function(){
this._horizontalAnimation.get_unit();
},set_unit:function(_b2){
var _b3=this._horizontalAnimation.get_unit();
if(_b3!=_b2){
this._horizontalAnimation.set_unit(_b2);
this._verticalAnimation.set_unit(_b2);
this.raisePropertyChanged("unit");
}
}};
$TWA.ResizeAnimation.registerClass("Telerik.Web.Animation.ResizeAnimation",$TWA.ParallelAnimation);
$TWA.registerAnimation("resize",$TWA.ResizeAnimation);
Type.registerNamespace("Telerik.Web.UI.Animations");
Telerik.Web.UI.Animations.ShowHideAnimation=function(_b4,_b5,fps,_b7,_b8,_b9){
this.controller=_b4;
this._duration=(_b5!=null)?_b5:0.3;
this._fps=(fps!=null)?fps:50;
this._frames=_b5*fps;
this._position=null!=_b8?_b8:32;
this._animatedElement=_b7;
this._sourceElement=_b9;
this._startBounds=null;
this._endBounds=null;
this._showAnimation=null;
this._hideAnimation=null;
};
Telerik.Web.UI.Animations.ShowHideAnimation.prototype={_getHorizontalPosition:function(){
return parseInt((this._position+"").charAt(1));
},_getVerticalPosition:function(){
return parseInt((this._position+"").charAt(0));
},_onBeforeShow:function(){
},_onBeforeHide:function(){
},_onAfterShow:function(){
},_onAfterHide:function(){
},onShowStart:function(){
},onHideStart:function(){
},onShowEnd:function(){
},onHideEnd:function(){
},play:function(_ba){
var _bb=(true==_ba)?this._hideAnimation:this._showAnimation;
if(_bb){
this.stop();
if(!_bb.__isTelerikModified){
var _bc=this;
_bb.__isTelerikModified=true;
var _bd=_bb.onStart;
_bb.onStart=function(){
if(_ba){
_bc.onHideStart();
}else{
_bc.onShowStart();
}
if(true==_ba){
_bc._onBeforeHide();
}else{
_bc._onBeforeShow();
}
if(_bd){
_bd.call(this);
}
};
var _be=_bb.onEnd;
_bb.onEnd=function(){
if(_be){
_be.call(this);
}
if(_bc.onEnd){
_bc.onEnd(_ba);
}
if(true==_ba){
_bc._onAfterHide();
}else{
_bc._onAfterShow();
}
if(_ba){
_bc.onHideEnd();
}else{
_bc.onShowEnd();
}
};
}
_bb.play();
}
this._runningAnimation=_bb;
},set_startBounds:function(_bf){
this._startBounds=_bf;
},set_endBounds:function(_c0){
this._endBounds=_c0;
},dispose:function(){
this.stop();
if(this._showAnimation){
this._showAnimation.dispose();
}
if(this._hideAnimation){
this._hideAnimation.dispose();
}
},stop:function(){
if(this._runningAnimation){
this._runningAnimation.stop();
this._runningAnimation=null;
}
}};
Telerik.Web.UI.Animations.ShowHideAnimation.registerClass("Telerik.Web.UI.Animations.ShowHideAnimation",null);
Telerik.Web.UI.Animations.ResizeAnimation=function(_c1,_c2,fps,_c4,_c5,_c6){
Telerik.Web.UI.Animations.ResizeAnimation.initializeBase(this,[_c1,_c2,fps,_c4,_c5,_c6]);
var _c2=this._duration;
var fps=this._fps;
var _c7=this._animatedElement;
var _c8,_c9,_ca,_cb,_cc,_cd;
var _ce=new Telerik.Web.Animation.ResizeAnimation(_c7,_c2,fps,_c8,_c9,"px");
var _cf=new Telerik.Web.Animation.LengthAnimation(_c7,_c2,fps,"style","left",_cc,_cd,"px");
var _d0=new Telerik.Web.Animation.LengthAnimation(_c7,_c2,fps,"style","top",_ca,_cb,"px");
var _d1=new Telerik.Web.Animation.FadeInAnimation(_c7,_c2,fps,0.3,1,false);
this._showAnimation=new Telerik.Web.Animation.ParallelAnimation(_c7,_c2,fps,[_ce,_cf,_d0,_d1]);
this._hideAnimation=new Telerik.Web.Animation.FadeInAnimation(this._animatedElement,this._duration,this._fps,1,0,false);
};
Telerik.Web.UI.Animations.ResizeAnimation.prototype={_configureAnimatedElement:function(){
var _d2=this._animatedElement;
_d2.style.overflow="hidden";
_d2.style.display="";
_d2.style.visibility="visible";
_d2.style.width="1px";
_d2.style.height="1px";
},_configureAnimation:function(_d3){
var _d4=this._showAnimation.get_animations();
var _d5=_d4[0];
_d5.set_width(_d3.width);
_d5.set_height(_d3.height);
var _d6=_d4[1];
_d6.set_startValue(_d3.startX);
_d6.set_endValue(_d3.endX);
var _d7=_d4[2];
_d7.set_startValue(_d3.startY);
_d7.set_endValue(_d3.endY);
},_getStartBounds:function(){
var _d8=null;
if(this._startBounds){
_d8=this._startBounds;
}else{
if(this._sourceElement){
_d8=$telerik.getBounds(this._sourceElement);
}else{
_d8=new Sys.UI.Bounds(1,1,1,1);
}
}
return _d8;
},_getEndBounds:function(){
return this._endBounds;
},_modifyAnimationValues:function(_d9){
var _da=this._animatedElement;
var _db=this._getStartBounds();
if(_db.width<_d9.width){
_d9.startX=_db.x;
_da.style.width=_db.width;
}
if(_db.height<_d9.height){
_d9.startY=_db.y;
_da.style.height=_db.height;
}
},_setHorizontalValues:function(_dc){
var _dd=this._getHorizontalPosition();
var _de=this._getEndBounds();
switch(_dd){
case 2:
_dc.startX=_de.x+Math.floor(_de.width/2);
_dc.endX=_de.x;
break;
case 3:
_dc.startX=_de.x;
_dc.endX=_de.x;
break;
case 1:
_dc.startX=_de.x+_de.width;
_dc.endX=_de.x;
}
},_setVerticalValues:function(_df){
var _e0=this._getVerticalPosition();
var _e1=this._getEndBounds();
switch(_e0){
case 2:
_df.startY=_e1.y+Math.floor(_e1.height/2);
_df.endY=_e1.y;
break;
case 1:
_df.startY=_e1.y+_e1.height;
_df.endY=_e1.y;
break;
case 3:
_df.startY=_e1.y;
_df.endY=_e1.y;
}
},_setSizeValues:function(_e2){
var _e3=this._endBounds;
_e2["width"]=_e3.width;
_e2["height"]=_e3.height;
},_onBeforeShow:function(){
var _e4={};
this._setHorizontalValues(_e4);
this._setVerticalValues(_e4);
this._setSizeValues(_e4);
this._configureAnimatedElement();
this._modifyAnimationValues(_e4);
this._configureAnimation(_e4);
},_onAfterShow:function(){
this._animatedElement.style.overflow="";
this._animatedElement.style.filter="";
}};
Telerik.Web.UI.Animations.ResizeAnimation.registerClass("Telerik.Web.UI.Animations.ResizeAnimation",Telerik.Web.UI.Animations.ShowHideAnimation);
Telerik.Web.UI.Animations.SlideAnimation=function(_e5,_e6,fps,_e8,_e9,_ea){
Telerik.Web.UI.Animations.SlideAnimation.initializeBase(this,[_e5,_e6,fps,_e8,_e9,_ea]);
};
Telerik.Web.UI.Animations.SlideAnimation.prototype={_modifyAnimationValues:function(_eb){
},_configureAnimatedElement:function(){
var _ec=this._animatedElement;
_ec.style.overflow="hidden";
_ec.style.display="";
_ec.style.visibility="visible";
var _ed=this._getVerticalPosition();
if(_ed==2){
_ec.style.width="1px";
}else{
_ec.style.height="1px";
}
},_setHorizontalValues:function(_ee){
var _ef=this._getHorizontalPosition();
var _f0=this._getEndBounds();
switch(_ef){
case 2:
_ee.startX=_f0.x;
_ee.endX=_f0.x;
break;
case 3:
_ee.startX=_f0.x;
_ee.endX=_f0.x;
break;
case 1:
var _f1=_f0.x;
if(2==this._getVerticalPosition()){
_f1+=_f0.width;
}
_ee.startX=_f1;
_ee.endX=_f0.x;
}
},_setVerticalValues:function(_f2){
var _f3=this._getVerticalPosition();
var _f4=this._getEndBounds();
switch(_f3){
case 2:
_f2.startY=_f4.y;
_f2.endY=_f4.y;
break;
case 1:
_f2.startY=_f4.y+_f4.height;
_f2.endY=_f4.y;
break;
case 3:
_f2.startY=_f4.y;
_f2.endY=_f4.y;
}
}};
Telerik.Web.UI.Animations.SlideAnimation.registerClass("Telerik.Web.UI.Animations.SlideAnimation",Telerik.Web.UI.Animations.ResizeAnimation);
Telerik.Web.UI.Animations.FlyInAnimation=function(_f5,_f6,fps,_f8,_f9,_fa){
Telerik.Web.UI.Animations.FlyInAnimation.initializeBase(this,[_f5,_f6,fps,_f8,_f9,_fa]);
};
Telerik.Web.UI.Animations.FlyInAnimation.prototype={_modifyAnimationValues:function(_fb){
},_setHorizontalValues:function(_fc){
var _fd=this._getHorizontalPosition();
var _fe=this._getEndBounds();
var _ff=$telerik.getClientBounds();
switch(_fd){
case 2:
_fc.startX=_fe.x;
_fc.endX=_fe.x;
break;
case 3:
_fc.startX=_ff.width;
_fc.endX=_fe.x;
break;
case 1:
_fc.startX=_ff.x;
_fc.endX=_fe.x;
}
},_setVerticalValues:function(_100){
var _101=this._getVerticalPosition();
var _102=this._getEndBounds();
var _103=$telerik.getClientBounds();
switch(_101){
case 2:
_100.startY=_102.y;
_100.endY=_102.y;
break;
case 1:
_100.startY=_103.y-_102.height;
_100.endY=_102.y;
break;
case 3:
_100.startY=_103.height;
_100.endY=_102.y;
}
}};
Telerik.Web.UI.Animations.FlyInAnimation.registerClass("Telerik.Web.UI.Animations.FlyInAnimation",Telerik.Web.UI.Animations.ResizeAnimation);
Telerik.Web.UI.Animations.FadeAnimation=function(_104,_105,fps,_107){
Telerik.Web.UI.Animations.FadeAnimation.initializeBase(this,[_104,_105,fps,_107]);
this._showAnimation=new Telerik.Web.Animation.FadeInAnimation(this._animatedElement,this._duration,this._fps,0.5,1,false);
this._hideAnimation=new Telerik.Web.Animation.FadeInAnimation(this._animatedElement,this._duration,this._fps,0.9,0,false);
};
Telerik.Web.UI.Animations.FadeAnimation.prototype={_onAfterShow:function(){
this._animatedElement.style.filter="";
}};
Telerik.Web.UI.Animations.FadeAnimation.registerClass("Telerik.Web.UI.Animations.FadeAnimation",Telerik.Web.UI.Animations.ShowHideAnimation);


if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();