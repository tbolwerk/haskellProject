module Main where 
import Graphics.Proc
import Pieces

type X = Float
type Y = Float
type Width = Float
type Height = Float
type Color = Float
type Rows = Int
type Cols = Int

data Player = White | Black deriving (Eq, Show)
data Cell = Cell{
  player :: Maybe Player,
  xCord :: X,
  yCord :: Y,
  width :: Width,
  height :: Height,
  backgroundColor :: Color
  } deriving (Show)



main = runProc $ def 
	{ procSetup  = setup
	, procDraw   = draw
  , procMousePressed = mousePressed}

screenWidth  = 800
screenHeight = 800
center = (screenWidth / 2, screenHeight / 2)

setup = do
	size (screenWidth, screenHeight)
	strokeWeight 2
	stroke (grey 255)
	return []


calculateWidthCell:: Width
calculateWidthCell = screenWidth /15
calculateHeightCell ::  Height
calculateHeightCell = screenHeight/15

switchColor :: Float -> Float
switchColor 200 = 50
switchColor 50 = 200

drawCell :: Cell -> Pio ()
drawCell (Cell {player = p, xCord = x, yCord = y, width = w, height=h,backgroundColor=c}) = do
  fill(grey c)
  rect(x,y) (w,h) 
  case p of
    Nothing -> circle 0 0
    Just White -> local $ do
      drawInCell x y w h
      scale (0.5, 0.5)
      drawDraught 255
    Just Black -> local $ do
      drawInCell x y w h
      scale (0.5, 0.5)
      drawDraught 0

drawInCell :: X -> Y -> Width -> Height -> Pio()
drawInCell x y w h= translate (x + (w / 2), y + (h / 2))

isCell :: X -> Y -> Width -> Height -> (Float, Float)-> Bool
isCell x y w h (mouseX, mouseY) | mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y+h = True | otherwise = False




  -- checkMoves ps board = 
-- checkMoves ps board = isSelectedCell x y calculateHeightCell calculateHeightCell (mouseX, mouseY)
--       where (x, y) = p:ps

drawColumn ::  Rows -> Cols -> Width -> Height -> Color -> Pio()
drawColumn r c widthCell heightCell color | c <= 0 = drawCell Cell{player = Nothing,xCord =0,yCord =0, width = 0, height=0,backgroundColor =0}
drawColumn r c widthCell heightCell color | c > 0 = do
                                drawCell Cell{player = playerOnCell r c, xCord=(rows * widthCell), yCord=(columns * heightCell),width= widthCell,height= heightCell,backgroundColor=color}
                                drawColumn r (c-1) widthCell heightCell (switchColor color)
                                where columns = fromIntegral c 
                                      rows = fromIntegral r
                                      playerOnCell r c| ((boardInitial !! (c-1)) !! (r-1)) == 1 = Just White | ((boardInitial !! (c-1)) !! (r-1)) == 2 = Just Black | otherwise = Nothing


boardInitial = [
  [0,2,0,2,0,2,0,2,0,2],
  [2,0,2,0,2,0,2,0,2,0],
  [0,2,0,2,0,2,0,2,0,2],
  [2,0,2,0,2,0,2,0,2,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
  [1,0,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,0,1],
  [1,0,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,0,1],
  [1,0,1,0,1,0,1,0,1,0]]

drawRow :: Rows -> Cols -> Width -> Height -> Float -> Pio()
drawRow r c w h color | r <= 0 = drawCell Cell{player = Nothing,xCord =0,yCord =0, width = 0, height=0,backgroundColor=0} 
drawRow r c w h color | r > 0 = do
                             drawColumn r c widthCell heightCell color
                             drawRow (r-1) c w h (switchColor color)
                             where widthCell = calculateWidthCell
                                   heightCell= calculateHeightCell

drawBoard :: Pio()
drawBoard = do 
  drawRow 10 10 screenWidth screenHeight 200
  m <- mouse
  circle 15 m

draw ps = do
	background (grey 150)
	drawBoard
  	case ps of
		[] -> return ()
		_  -> do
			m <- mouse
			linePath (m : ps)

mousePressed ps = do
  mb <- mouseButton
  case mb of
    Just LeftButton -> do
      m <- mouse
      return (m : ps)
    Just RightButton -> do
      if null ps 
        then return []
        else return (tail ps)
    _ -> return ps