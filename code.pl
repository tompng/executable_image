@tbl=split//,'QBMW#TTVQQd8PVV*pQAk5Y7*pgyxJ?7*ggau{1/"gau](:~^gau;;--`a,,,,.. ';
use List::Util qw( min max );
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
  $cosz=cos$rot;$sinz=sin$rot;
  $rx=sin($rot*0.31);
  $cosx=cos($rx);$sinx=sin($rx);
  @col=map{my@a=map{1}@base;\@a}@base;
  @dep=map{my@a=map{999}@base;\@a}@base;
  sub conv{
    $x=shift;$y=shift;$z=shift;
    $s=$w/4.0;
    ($y,$z)=($y*$cosx-$z*$sinx,$z*$cosx+$y*$sinx);
    ($x,$y)=($x*$cosz-$y*$sinz,$y*$cosz+$x*$sinz);
    ($w/2+$s*$x,$s*$y,$h/2+$s*$z)
  }
  sub fill{
    $a=shift;$b=shift;$c=shift;
    ($ax,$ay,$az)=conv($a->[0],$a->[1],$a->[2]);
    ($bx,$by,$bz)=conv($b->[0],$b->[1],$b->[2]);
    ($cx,$cy,$cz)=conv($c->[0],$c->[1],$c->[2]);
    $sx=$bx-$ax;$sy=$by-$ay;$sz=$bz-$az;
    $tx=$cx-$ax;$ty=$cy-$ay;$tz=$cz-$az;
    $nx=$sy*$tz-$sz*$ty;$ny=$sz*$tx-$tz*$sx;$nz=$sx*$ty-$sy*$tx;
    $nr=($nx*$nx+$ny*$ny+$nz*$nz)**0.5;
    $nx/=$nr;$ny/=$nr;$nz/=$nr;
    if($ny<0){($nx,$ny,$nz)=(-$nx,-$ny,-$nz)}
    $cc=($nx+1)*0.4;
    $x0=int(min($ax,$bx,$cx));$x1=int(max($ax,$bx,$cx));
    $z0=int(min($az,$bz,$cz));$z1=int(max($az,$bz,$cz));
    if($x0<0){$x0=0}
    if($z0<0){$z0=0}
    if($x1>=$w){$x1=$w-1}
    if($z1>=$w){$z1=$h-1}
    $a=$bx-$ax;$b=$cx-$ax;
    $c=$bz-$az;$d=$cz-$az;
    $det=$a*$d-$b*$c;
    for($ix=$x0;$ix<=$x1;$ix++){for($iz=$z0;$iz<=$z1;$iz++){
      $p=$ix-$ax;$q=$iz-$az;
      $s=($d*$p-$b*$q)/$det;
      $t=($a*$q-$c*$p)/$det;
      if($s+$t<=1&&0<=$s&&0<=$t){
        $dp=$ay+($by-$ay)*$s+($cy-$ay)*$t;
        if($dp<$dep[$iz][$ix]){
          $dep[$iz][$ix]=$dp;
          $col[$iz][$ix]=$cc;
        }
      }
    }}
  }
  for($i=0;$i<$#coords;$i++){
    $size=80;
    for($j=0;$j<$size;$j++){
      fill($coords[$i][$i],$coords[$i+1][$i],$coords[$i][($i+1)% $size]);
      fill($coords[$i][($i+1)% $size],$coords[$i+1][($i+1)% $size],$coords[$i+1][$i]);
    }
  }
  # print"\e[1;1H";
  $s='';
  for($i=0;$i<$h;$i+=2){
    for($j=0;$j<$w;$j++){
      $s.=$tbl[int($col[$i][$j]*7.9)*8+int($col[$i+1][$j]*7.9)]
    }
    $s.="\n";
  }
  print$s;
  exit;
}
