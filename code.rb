TABLE = ['QBMW#TTV','QQd8PVV*','pQAk5Y7*','pgyxJ?7*','ggau{1/"','gau](:~^','gau;;--`','a,,,,.. ']
w=80
h=80
coords=[]
80.times{|i|
  th = (i/80.0)**2*40
  r  = 16**(-th/30)
  c,s=Math.cos(th),Math.sin(th)
  aa=[]
  coords<<aa
  20.times{|j|
    t=2*Math::PI*j/20
    x,z=Math.cos(t),Math.sin(t)
    l=1+((Math.cos(5*t)+Math.sin(3*t))*Math.cos(2.3*th))**2*0.1
    x,y,z=x*l+0.8,Math.sin(3*t)*0.1,z*l*0.75
    x,y=x*c+y*s,y*c-x*s
    x*=r;y*=r;z=r*z+r*2.5-1.8
    aa<<[x,y,z]
  }
}
$><<"\e[2J"
rot=0
loop{
  rot+=0.05
  cosz,sinz=Math.cos(rot),Math.sin(rot)
  cosx,sinx=Math.cos(Math.sin(rot*0.31)),Math.sin(Math.sin(rot*0.31))
  col=w.times.map{h.times.map{1}}
  dep=w.times.map{h.times.map{999}}
  conv=->x,y,z{
    s=w/4.0
    y,z=y*cosx-z*sinx,z*cosx+y*sinx
    x,y=x*cosz-y*sinz,y*cosz+x*sinz
    [w/2+s*x,s*y,h/2+s*z]
  }
  fill=->(a,b,c){
    ax,ay,az=a
    bx,by,bz=b
    cx,cy,cz=c
    ax,ay,az=conv[ax,ay,az]
    bx,by,bz=conv[bx,by,bz]
    cx,cy,cz=conv[cx,cy,cz]

    sx,sy,sz=bx-ax,by-ay,bz-az
    tx,ty,tz=cx-ax,cy-ay,cz-az
    nx,ny,nz=sy*tz-sz*ty,sz*tx-tz*sx,sx*ty-sy*tx
    nr=(nx*nx+ny*ny+nz*nz)**0.5
    nx/=nr;ny/=nr;nz/=nr;
    nx,ny,nz=-nx,-ny,-nz if ny<0
    cc=(nx+1)*0.4
    x0,x1=[ax,bx,cx].minmax
    z0,z1=[az,bz,cz].minmax
    x0=0 if x0<0
    z0=0 if z0<0
    x1=w-1 if x1>=w
    z1=h-1 if z1>=h
    (x0.ceil..x1.floor).each{|ix|(z0.ceil..z1.floor).each{|iz|
      a,b,p=bx-ax,cx-ax,ix-ax
      c,d,q=bz-az,cz-az,iz-az
      det=a*d-b*c
      s=(d*p-b*q)/det
      t=(a*q-c*p)/det
      next unless s+t<=1&&0<=s&&0<=t
      d=ay+(by-ay)*s+(cy-ay)*t
      if d<dep[iz][ix]
        dep[iz][ix]=d
        col[iz][ix]=cc
      end
    }}
  }
  (coords.size-1).times{|i|
    ca,cb=coords[i],coords[i+1]
    (ca.size).times{|i|
      fill[ca[i],cb[i],ca[(i+1)%ca.size]]
      fill[ca[(i+1)%ca.size],cb[(i+1)%cb.size],cb[i]]
    }
  }
  $><<"\e[1;1H"
  puts (h/2).times.map{|i|
    col[2*i].zip(col[2*i+1]).map{|a,b|
      TABLE[a*7.9][b*7.9]
    }.join
  }
}
