Rect[] snakeArr = new Rect[625]; //<>//
Rect snakeFood = new Rect();
Rect scoreBackground = new Rect();
Rect snakeHead;
Text gameEndText = new Text();
Text scoreText = new Text();
String gameEndString = "Game over!";
int snakeColor = color(0, 255, 0);
int backgroundColor = color(0);
int snakeLength = 3;
int gridPos = 20;
int score = 0;
int currDir = Direction.LEFT; // the current direction of the snake
boolean stopGame  = false;


void setup()
{
  size(500, 620);
  frameRate(15);
  background(backgroundColor); 

  initSnake(); 
  snakeHead = snakeArr[0];
  initSnakeFood();
}         

void draw()
{

  if (stopGame) {
    drawGameEnd();
    noLoop();
  } else // if the snake is not dead
  {
    moveTo(currDir);
    drawSnake();
    drawGrid();
    isFoodAte(); 
    drawScore(); 
    isGameOver();
  }
}

void drawSnake()
{
  for (int i=0; i<snakeLength; i++)
  {
    snakeArr[i].draw();
  }
}


void keyPressed()
{
  if (keyCode == LEFT && currDir != Direction.RIGHT)
  {
    currDir = Direction.LEFT;
  }
  if (keyCode == RIGHT && currDir != Direction.LEFT)
  {
    currDir = Direction.RIGHT;
  }
  if (keyCode == UP && currDir != Direction.DOWN)
  {
    currDir = Direction.UP;
  }
  if (keyCode == DOWN && currDir != Direction.UP)
  {
    currDir = Direction.DOWN;
  }
}

void drawGrid()
{
  stroke(128);
  strokeWeight(1);

  while (gridPos < width)
  {
    line(gridPos, 0, gridPos, height);
    gridPos += 20;
  }
  gridPos = 20;


  while (gridPos < height)
  {
    line(0, gridPos, width, gridPos);
    gridPos += 20;
  }
  gridPos = 20;
}


void initSnake() 
{
  for (int i=0; i<snakeLength; i++)
  {
    snakeArr[i] = new Rect();
    drawRect(snakeArr[i], gridPos*20 + i*gridPos, gridPos*6, gridPos, gridPos, snakeColor);
  }
}


void initSnakeFood()
{
  snakeFood = new Rect();
  drawRect(snakeFood, int(random(4, 20)) * gridPos, int(random(4, 20)) * gridPos, gridPos, gridPos, color(255, 0, 0));
}

void drawGameEnd()
{
  drawText(gameEndText, gameEndString, 30, 150, 80, color(255, 255, 0));
}

void drawScore()
{
  scoreBackground(); 
  drawText(scoreText, "Score:" + score, 200, 50, 35, color(255, 255, 0));
}

void isGameOver()
{

  if (snakeHead.x == -gridPos || snakeHead.x == width || snakeHead.y == scoreBackground.height - 20 || snakeHead.y == height) // if the snakeHead hits the wall
  {
    stopGame = true;
  }

  checkIfSnakeHitsHimself();
}

void checkIfSnakeHitsHimself()
{
  for (int i=1; i<snakeLength; i++)
  {
    if (snakeHead.x == snakeArr[i].x && snakeHead.y == snakeArr[i].y)
    {
      stopGame = true;
    }
  }
}


void isFoodAte()
{
  if (snakeHead.x == snakeFood.x && snakeHead.y == snakeFood.y)
  {
    score++;
    putFoodInRandomLoc();
    snakeLength++;
    snakeArr[snakeLength-1] = new Rect();
    drawRect(snakeArr[snakeLength-1], snakeArr[snakeLength-1].x - gridPos, snakeArr[snakeLength-2].y, gridPos, gridPos, snakeColor);
  }
}

void putFoodInRandomLoc()
{
  while (foodOnSnake())
  {
    snakeFood.x = int(random(4, 20)) * gridPos;
    snakeFood.y = int(random(4, 20)) * gridPos;
  }
  snakeFood.draw();
}

// should return true if snake toutches the food, false otherwise
boolean foodOnSnake()
{ 
  for (int i=0; i<snakeLength; i++)
  {
    if (snakeFood.x == snakeArr[i].x && snakeFood.y == snakeArr[i].y) {
      return true;
    }
  }
  return false;
}

void scoreBackground()
{
  drawRect(scoreBackground, 0, 0, 600, 80, color(0, 0, 255));
}

void moveTo(int direction)
{
  updateSnakeMovement();
  snakeHead.direction = direction;
  snakeHead.speed = 20;
}

void updateSnakeMovement() 
{
  snakeArr[snakeLength-1].brush = backgroundColor;
  snakeArr[snakeLength-1].draw();
  for (int i=snakeLength-1; i>0; i--) // follow the one in front of you
  {
    snakeArr[i].brush = snakeColor;
    snakeArr[i].x = snakeArr[i-1].x;
    snakeArr[i].y = snakeArr[i-1].y;
  }
}
