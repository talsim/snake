abstract class BaseShape {
  public float rotation = 0;

  abstract protected int getX();
  abstract protected int getY();

  private float speedX = 0;
  private float speedY = 0;

  public int speed = 0;
  public int direction;

  protected int advanceSpeedX() {
    int advanceX = 0;
    if (speed == 0) {
      speedX = 0;
    } else {
      speedX += (speed) * cos(radians(direction));

      advanceX = round(speedX);

      speedX = speedX - advanceX;
    }
    return advanceX;
  }

  protected int advanceSpeedY() {
    int advanceY = 0;
    if (speed == 0) {
      speedY = 0;
    } else {
      speedY += (speed) * sin(radians(direction));

      advanceY = round(speedY);

      speedY = speedY - advanceY;
    }
    return advanceY;
  }


  protected void rotateIt() {
    pushMatrix();
    translate(getX(), getY());
    rotate(radians(rotation));
    translate(-getX(), -getY());
    this.drawIt();
    popMatrix();
  }
  abstract protected void drawIt();
  public void draw() {
    if (abs(rotation)%360!=0) {
      this.rotateIt();
    } else {
      this.drawIt();
    }
  }
}

class Direction {
  public final static int UP = 270;
  public final static int DOWN = 90;
  public final static int LEFT = 180;
  public final static int RIGHT = 0;
  public final static int UPRIGHT = 315;
  public final static int DOWNRIGHT = 45;
  public final static int UPLEFT = 225;
  public final static int DOWNLEFT = 135;
}


class Ellipse extends BaseShape {
  public int x;
  public int y;
  public int radiusX;
  public int radiusY;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;


  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);

    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    ellipse(x, y, radiusX * 2, radiusY * 2);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public boolean pointInShape(int x1, int y1) {
    double normalizeXPow2 = pow((x1 - x), 2);
    double normalizeYPow2 = pow((y1 - y), 2);
    double radiusXPow2 = pow(radiusX, 2);
    double radiusYPow2 = pow(radiusY, 2);
    return ((normalizeXPow2 / radiusXPow2) + (normalizeYPow2 / radiusYPow2)) <= 1.0;
  }
}

class Hexagon extends BaseShape {
  public int x;
  public int y;
  public int radius;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  private PVector[] verts;
  protected void drawIt() {

    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    pushMatrix();
    polygon();
    popMatrix();
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  private void polygon() {
    verts = new PVector[7];
    float angle = 2 * PI / 6;

    beginShape();
    float sx;
    float sy;
    int index = 0;
    for (float i = 0; i < 2 * PI; i += angle) {
      sx = x + cos(i) * radius;
      sy = y + sin(i) * radius;
      verts[index++] = new PVector(sx, sy);
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  public boolean pointInShape(int x1, int y1) {
    PVector pos = new PVector(x1, y1);
    int i, j;
    boolean c = false;
    int sides = 6;

    for (i = 0, j = sides - 1; i < sides; j = i++) {
      if ((((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }
}

class Image extends BaseShape {
  private PImage image;
  private String path;
  public int x;
  public int y;
  public int width = -1;
  public int height = -1;
  public float alpha = 1;

  public String getPath() {
    return path;
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    width = image.width;
    height = image.height;
    /*
        if(width==-1){
     width = image.width;
     }
     if(height==-1){
     height = image.height;
     }
     */
  }
  public void resetSize() {
    if (image != null) {
      width = image.width;
      height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    image(image, x, y, width, height);
  }

  public boolean pointInShape(int x1, int y1) {
    if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {
      return true;
    } else {
      return false;
    }
  }
}

class Line extends BaseShape {
  public int x1;
  public int y1;
  public int x2;
  public int y2;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    //brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    int advancedSpeedX = this.advanceSpeedX();
    int advancedSpeedY = this.advanceSpeedY();
    x1 += advancedSpeedX;
    y1 += advancedSpeedY;
    x2 += advancedSpeedX;
    y2 += advancedSpeedY;

    line(x1, y1, x2, y2);
  }

  protected int getX() {
    return x1;
  }

  protected int getY() {
    return y1;
  }
}

class Pentagon extends BaseShape {
  public int x;
  public int y;
  public int radius;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  private PVector[] verts;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    pushMatrix();
    polygon(); //(x, y, radius, 5);
    popMatrix();
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  private void polygon() {
    verts = new PVector[5];
    float angle = 2 * PI / 5;
    beginShape();
    float sx;
    float sy;
    int index = 0;
    for (float i = 0; i < 2 * PI; i += angle) {
      sx = x + cos(i) * radius;
      sy = y + sin(i) * radius;
      verts[index++] = new PVector(sx, sy);
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }

  public boolean pointInShape(int x1, int y1) {
    PVector pos = new PVector(x1, y1);
    int i, j;
    boolean c = false;
    int sides = 5;

    for (i = 0, j = sides - 1; i < sides; j = i++) {
      if ((((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }
}


class Rect extends BaseShape {
  public int x;
  public int y;
  public int width;
  public int height;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    rect(x, y, width, height);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public boolean pointInShape(int x1, int y1) {
    if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {
      return true;
    } else {
      return false;
    }
  }
}


class Text extends BaseShape {
  public int x;
  public int y;
  public color brush;
  public int alpha = 255;

  public String text;
  public int textSize;
  public String font;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    textSize(textSize);
    fill(brush);

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();


    if(font!=null){
    PFont myFont;
    myFont = createFont(font, textSize, true);
    textFont(myFont);

}


    text(text, x, y);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }
}

class Triangle extends BaseShape {
  public int x1;
  public int y1;
  public int x2;
  public int y2;
  public int x3;
  public int y3;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    int advancedSpeedX = this.advanceSpeedX();
    int advancedSpeedY = this.advanceSpeedY();

    x1 += advancedSpeedX;
    y1 += advancedSpeedY;
    x2 += advancedSpeedX;
    y2 += advancedSpeedY;
    x3 += advancedSpeedX;
    y3 += advancedSpeedY;

    triangle(x1, y1, x2, y2, x3, y3);
  }

  protected int getX() {
    return x1;
  }

  protected int getY() {
    return y1;
  }

  public boolean pointInShape(int x, int y) {
    float s = y1 * x3 - x1 * y3 + (y3 - y1) * x + (x1 - x3) * y;
    float t = x1 * y2 - y1 * x2 + (y1 - y2) * x + (x2 - x1) * y;

    if ((s < 0) != (t < 0))
      return false;

    float A = -y2 * x3 + y1 * (x3 - x2) + x1 * (y2 - y3) + x2 * y3;
    if (A < 0.0) {
      s = -s;
      t = -t;
      A = -A;
    }
    return s > 0 && t > 0 && (s + t) < A;
  }
}


class SpriteSheet extends BaseShape {
  public int x;
  public int y;
  public Image img = new Image();
  private int imgNum = 1;
  public int NumOfImage=0; 
  public int animationFactor = 10;
  private int drawInvokeCounter=0;
  public String imageBaseName; 

  
  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }
  protected void drawIt() {
    drawInvokeCounter++;
    if (frameCount%animationFactor==0) {
      imgNum++;
      if (imgNum>NumOfImage) {
        imgNum=1;
      }
    }
    img.setImage(imageBaseName+imgNum+".png");
    img.x=x;
    img.y=y;
    img.draw();

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    img.x = x;
    img.y = y;
    println(imgNum);
  }
}

PApplet papplet = this;

import ddf.minim.*;

class Music {


  private Minim minim;
  private AudioPlayer player;

  private String path;

  public boolean loop;

  public Music() {
  }

  public void load(String path_) {

    path = path_;
    if (minim == null) {
      minim = new Minim(papplet);
    }

    if (player != null) {
      player.close();
    }

    player = minim.loadFile(path);
  }

  public void play() {
    if (player != null) {
      if (loop) {
        player.loop();
      } else {
        player.rewind();
        player.play();
      }
    }
  }

  public void stop() {
    if (player != null) {
      player.pause();
      player.rewind();
    }
  }
}