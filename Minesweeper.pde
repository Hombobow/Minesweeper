import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private static final int NUM_MINES = 40;

void setup ()
{
  size(1000, 1000);
  textAlign(CENTER, CENTER);
  textFont(createFont("Times New Roman", 24));

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];

  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  mines = new ArrayList <MSButton>();

  setMines();
}

public void draw ()
{
  background( 0 ); 
  if (isWon() == true)
    displayWinningMessage();
  //System.out.print(PFont.list());
}

public void setMines()
{
  for (int i = 0; i < NUM_MINES; i++)
  {
    int ranRow = (int)(Math.random() * NUM_ROWS);
    int ranCol = (int)(Math.random() * NUM_COLS);

    if (!mines.contains(buttons[ranRow][ranCol]))
    {
      mines.add(buttons[ranRow][ranCol]);
    } else
    {
      i--;
    }
  }
}


public boolean isWon()
{
  //your code here
  for (int i = 0; i < NUM_ROWS; i++)
  {
    for (int j = 0; j < NUM_COLS; j++)
    {
      if (!mines.contains(buttons[i][j]) && !buttons[i][j].isClicked())
      {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage()
{
  buttons[0][0].setLabel("L");
  buttons[0][1].setLabel("O");
  buttons[0][2].setLabel("S");
  buttons[0][3].setLabel("E");
  buttons[0][4].setLabel("R");
}

public void displayWinningMessage()
{
  buttons[0][0].setLabel("W");
  buttons[0][1].setLabel("I");
  buttons[0][2].setLabel("N");
  buttons[0][3].setLabel("N");
  buttons[0][4].setLabel("E");
  buttons[0][5].setLabel("R");
}

public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
  {
    return true;
  }
  return false;
}

public int countMines(int row, int col)
{
  int numMines = 0; 

  for (int i = row - 1; i <= row + 1; i++)
  {
    for (int j = col - 1; j <= col + 1; j++)
    {
      if (isValid(i, j) && mines.contains(buttons[i][j]))
      {
        numMines++;
      }
    }
  }

  if (isValid(row, col) && mines.contains(buttons[row][col]))
  {
    numMines--;
  }

  return numMines;
}

public class MSButton
{
  private int myRow, myCol; 
  private float x, y, width, height; 
  private boolean clicked, flagged; 
  private String myLabel; 

  public MSButton ( int row, int col )
  {
    width = 1000/NUM_COLS;
    height = 1000/NUM_ROWS;
    myRow = row; 
    myCol = col; 
    x = myCol*width; 
    y = myRow*height; 
    myLabel = ""; 
    flagged = clicked = false; 
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true; 
    //your code here

    if (mouseButton == RIGHT)
    {
      flagged = !flagged;
      if (flagged == false)
      {
        clicked = false;
      }
    } else if (mines.contains(buttons[myRow][myCol]))
    {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0)
    {
      setLabel(countMines(myRow, myCol));
      System.out.println(countMines(myRow, myCol));
    } else
    {
      for (int i = myRow - 1; i < myRow + 2; i++)
      {
        for (int j = myCol - 1; j < myCol + 2; j++)
        {
          if (isValid(i, j) && buttons[i][j].clicked == false && !(buttons[myRow][myCol] == buttons[i][j]))
          {
            buttons[i][j].mousePressed();
          }
        }
      }
    }
  }

  public void draw () 
  {    
    if (flagged)
    {
      fill(0);
    } else if ( clicked && mines.contains(this) )
    {
      fill(255, 0, 0);
    } else if (clicked) 
    {
      fill( 200 );
    } else 
    {
      fill( 100 );
    }

    rect(x, y, width, height); 
    fill(0); 
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged()
  {
    return flagged;
  }

  public boolean isClicked()
  {
    return clicked;
  }
}
