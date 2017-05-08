int[][] b = new int[4][4], pp[] = new int[4][4][3]; //size(len,len) is better but js no support
int f=4,pd=20,bs=100,len=pd*(f+1)+bs*f,sc=0,aS,aL=10,dead=1,w,h,bb=color(0),C=CENTER;

void setup() { size(500,500); restart(); textFont(createFont("Courier",40)); noStroke(); }

void restart() 
{ b = new int[4][4]; 
spawn(); 
dead = sc = 100; 
w=width;
h=height;
}

void spawn() 
{ ArrayList<Integer> xs = new ArrayList<Integer>(), ys = new ArrayList<Integer>();
  for(int j=0;j<f;j++) for(int i=0;i<f;i++) for(int k=0;k<1&&b[j][i]==0;k++,xs.add(i),ys.add(j)){}
  int r=(int)random(xs.size()),y=ys.get(r),x=xs.get(r),z=b[y][x]=random(-(pp[y][x][0]=-1))<.9?2:4;
}
  
void draw() { background(255); rectt(0,0,w,h,10,color(150));fill(200);float grs=0,txv=35;
  for (int j=0;j<f;j++) for(int i=0;i<f;i++) rect(pd+(pd+bs)*i, pd+(pd+bs)*j, bs, bs, 5);
  for (int j = 0 ; j < f; j++) for (int i = 0 ; i < b[j].length; i++) {
      float fC=frameCount,xt=pd+(pd+bs)*i,yt=pd+(pd+bs)*j,x=xt,y=yt,val=b[j][i],tm=(fC-aS)*1.0/aL;
      if (fC - aS < aL && pp[j][i][0]>0) { //idea based off http://gabrielecirulli.github.io/2048/
        int py=pd+(pd+bs)*pp[j][i][1], px=pd+(pd+bs)*pp[j][i][2];x=(x-px)*tm+px;y=(y-py)*tm+py;
        if (pp[j][i][0]>1) { val=pp[j][i][0]; textt(""+pp[j][i][0],xt,yt+txv,bs,bs,bb,40,C);
          rectt(xt,yt,bs,bs,5,color(255-(log(val)/log(2))*255/11,(log(val)/log(2))*255/11, 0)); } }
      if(fC-aS>aL||pp[j][i][0]>=0){if(pp[j][i][0]>=2){ float gr=abs(0.5-tm)*2;if(fC-aS>aL*3) gr=1; 
          else grs=gr; rectt(x-2*gr, y-2*gr, bs+4*gr, bs+4*gr, 5, color(255,255,0,100)); }
        else if (pp[j][i][0]==1) rectt(x-2, y-2, bs+4, bs+4, 5, color(255,100));
        if (val>0){rectt(x,y,bs,bs,5,color(255-log(val)/log(2)*255/11,log(val)/log(2)*255/11,0));
          textt(""+int(val), x, y + txv, bs, bs,bb,40,C); } } }  
  if(grs>0) textt(""+sc,0,h/2,w,200,color(255,255,0,200),grs*40,C);
  textt("score: "+sc,10,5,100,50,bb,10.0, LEFT);;;; if(dead>0) { rectt(0,0,w,h,0,color(255,100)); 
    textt("Gameover! Click to restart", 0,h/2,w,50,bb,30,C); if(mousePressed) restart(); } }
    
    
void rectt(float x, float y, float w, float h, float r, color c) 
{ fill(c); rect(x,y,w,h,r); }


void textt(String t, float x, float y, float w, float h, color c, float s, int align) {
  fill(c); 
  textAlign(align); 
  textSize(s); 
  text(t,x,y,w,h); 
}
  
  
void keyPressed(){if(dead>0)return;int k=keyCode,dy=k==UP?-1:(k==40?1:0),dx=k==37?-1:(k==39?1:0);
  int[][] newb=go(dy,dx,true); if(newb != null) { b=newb; spawn(); } if(gameover()) dead=1; }
boolean gameover() { int[] dx = {1,-1,0,0},dy={0,0,1,-1},ppbk[][] =pp; boolean out=true; 
  for (int i=0;i<f;i++) if(go(dy[i], dx[i],false) != null) out=false;;; pp=ppbk; return out; }
int[][] go(int dy, int dx, boolean ups) { pp = new int[4][4][3]; boolean mv = false; 
  int[][] bk = new int[4][4]; for (int j=0;j<f;j++) for(int i=0;i<f;i++) bk[j][i]=b[j][i];
  if (dx != 0 || dy != 0) {  int d=dx!=0?dx:dy;
    for (int perp = 0; perp < f; perp++) for (int tn=(d>0?f-2:1); tn!=(d>0?-1:f);tn-=d) {
      int y = dx!=0?perp:tn,x=dx!=0?tn:perp,ty=y,tx=x; if(bk[y][x]==0) continue;
      for (int i=(dx!=0?x:y)+d;i!=(d>0?f:-1);i+=d) { int r=dx!=0?y:i,c=dx!=0?i:x; 
        if(bk[r][c]!=0 &&bk[r][c]!=bk[y][x]) break; if (dx!=0) tx=i; else ty=i; }
      if ( (dx != 0 && tx == x) || (dy != 0 && ty == y)) continue;
      else if(bk[ty][tx]==bk[y][x]){mv=true;pp[ty][tx][0]=bk[ty][tx];if(ups)sc+=(bk[ty][tx]*=2);}
      else if((dx!=0&&tx!=x)||(dy!=0&&ty!=y)){ pp[ty][tx][0]=1; bk[ty][tx]=bk[y][x]; mv=true; }
      if (mv) { pp[ty][tx][1] = y; pp[ty][tx][2] = x; bk[y][x] = 0; } } }
  if (!mv) return null; aS = frameCount; return bk; } //42 lines of code. my kind of perfection.


//Section added for mobile support (I'm sure we could fit this within the 42 lines)
void mousePressed() {
  keyCode = 0;
  if(mouseX < width / 4) keyCode = LEFT;
  if(mouseX > width * 3 / 4) keyCode = RIGHT;
  if(mouseY < height / 4) keyCode = UP;
  if(mouseY > height * 3 / 4) keyCode = DOWN;
  if(keyCode > 0) keyPressed();
}