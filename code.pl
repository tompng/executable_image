@tbl=split//,'QBMW#TTVQQd8PVV*pQAk5Y7*pgyxJ?7*ggau{1/"gau](:~^gau;;--`a,,,,.. ';
$w=80;$h=80;$pi=3.1416;
@coords=[];
@base=[];
for($i=0;$i<80;$i++){
  push(@base,1);
  $th=($i/80.0)**2*40;
  $r=16**(-$th/30);
  $c=cos$th;$s=sin$th;
  my@aa=[];
  for($j=0;$j<80;$j++){
    $t=2*$pi*$j/20;
    $x=cos$t;$z=sin$t;
    $l=1+((cos(5*$t)+sin(3*$t))*cos(2.3*$th))**2*0.1;
    ($x,$y,$z)=($x*$l+0.8,sin(3*$t)*0.1,$z*$l*0.75);
    ($x,$y)=($x*$c+$y*$s,$y*$c-$x*$s);
    my@a=($x*$r,$y*$r,$z*$r+$r*2.5-1.8);
    $aa[$j]=\@a;
  }
  $coords[$i]=\@aa;
}
# print"\e[2J";
$rot=0;

while(1){
  $rot+=0.05;
  $cz=cos$rot;$sz=sin$rot;
  $rx=sin($rot*0.31);
  $cx=cos($rx);$sx=sin($rx);
  @col=map{my@a=map{1}@base;\@a}@base;
  @dep=map{my@a=map{999}@base;\@a}@base;
  sub conv{
    $x=shift;$y=shift;$z=shift;
    $s=$w/4.0;
    ($y,$z)=($y*$cx-$z*$sx,$z*$cx+$y*$sx);
    ($x,$y)=($x*$cz-$y*$sz,$y*$cz+$x*$sz);
    ($w/2+$s*$x,$s*$y,$h/2+$s*$z)
  }
  # sub fill{
  #   $a=shift;$b=shift;$c=shift;
  #   ax,ay,az=a
  #   bx,by,bz=b
  #   cx,cy,cz=c
  #   ax,ay,az=conv[ax,ay,az]
  #   bx,by,bz=conv[bx,by,bz]
  #   cx,cy,cz=conv[cx,cy,cz]
  #
  #   sx,sy,sz=bx-ax,by-ay,bz-az
  #   tx,ty,tz=cx-ax,cy-ay,cz-az
  #   nx,ny,nz=sy*tz-sz*ty,sz*tx-tz*sx,sx*ty-sy*tx
  #   nr=(nx*nx+ny*ny+nz*nz)**0.5
  #   nx/=nr;ny/=nr;nz/=nr;
  #   nx,ny,nz=-nx,-ny,-nz if ny<0
  #   cc=(nx+1)*0.4
  #   x0,x1=[ax,bx,cx].minmax
  #   z0,z1=[az,bz,cz].minmax
  #   x0=0 if x0<0
  #   z0=0 if z0<0
  #   x1=w-1 if x1>=w
  #   z1=h-1 if z1>=h
  #   (x0.ceil..x1.floor).each{|ix|(z0.ceil..z1.floor).each{|iz|
  #     a,b,p=bx-ax,cx-ax,ix-ax
  #     c,d,q=bz-az,cz-az,iz-az
  #     det=a*d-b*c
  #     s=(d*p-b*q)/det
  #     t=(a*q-c*p)/det
  #     next unless s+t<=1&&0<=s&&0<=t
  #     d=ay+(by-ay)*s+(cy-ay)*t
  #     if d<dep[iz][ix]
  #       dep[iz][ix]=d
  #       col[iz][ix]=cc
  #     end
  #   }}
  # }
  # (coords.size-1).times{|i|
  #   ca,cb=coords[i],coords[i+1]
  #   (ca.size).times{|i|
  #     fill[ca[i],cb[i],ca[(i+1)%ca.size]]
  #     fill[ca[(i+1)%ca.size],cb[(i+1)%cb.size],cb[i]]
  #   }
  # }
  for($i=0;$i<$h;$i++){
    for($j=0;$j<$w;$j++){
      if(($i-40)**2+($j-40)**2<400){$col[$i][$j]=0;}
    }
  }
  print"\e[1;1H";
  $s='';
  for($i=0;$i<$h;$i+=2){
    for($j=0;$j<$w;$j++){
      $s.=$tbl[int($col[$i][$j]*7.9)*8+int($col[$i+1][$j]*7.9)]
    }
    $s.="\n";
  }
  print$s;
}
