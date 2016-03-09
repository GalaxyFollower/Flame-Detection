function [Af As]= getParaboloidArea(this,complete)
rf=this.R;
hf=max(this.y)-this.min;
Af=pi*rf/(6*hf^2)*((rf^2+4*hf^2)^3/2-rf^3);
As=pi*rf^2;