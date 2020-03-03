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
offset = 1
numberOfCells = 10
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


-- getCell row = cell:row

-- getRow board = getCell row:board 

-- boardState board points = getCellCord 

drawInCell :: X -> Y -> Width -> Height -> Pio()
drawInCell x y w h= translate (x + (w / 2), y + (h / 2))


getCellCord :: (Float, Float) ->  Maybe (X, Y)
getCellCord (mouseX, mouseY) | mouseX <= calculateWidthCell*offset || mouseX > (calculateWidthCell * (numberOfCells + offset)) = Nothing
                                     | mouseY < calculateHeightCell*offset || mouseY > (calculateHeightCell * (numberOfCells + offset)) = Nothing
                                     | otherwise = Just ( ((fromIntegral $ floor (mouseX / calculateWidthCell)) * calculateWidthCell) + (calculateWidthCell/2) ,  ((fromIntegral $ floor (mouseY / calculateHeightCell))*calculateHeightCell) + (calculateHeightCell/2))


drawColumn ::  Rows -> Cols -> Width -> Height -> Color -> Pio()
drawColumn r c widthCell heightCell color | c <= 0 = drawCell Cell{player = Nothing,xCord =0,yCord =0, width = 0, height=0,backgroundColor =0}
drawColumn r c widthCell heightCell color | c > 0 = do
                                drawCell Cell{player = playerOnCell r c, xCord=(rows * widthCell), yCord=(columns * heightCell),width= widthCell,height= heightCell,backgroundColor=color}
                                drawColumn r (c-1) widthCell heightCell (switchColor color)
                                where columns = fromIntegral c 
                                      rows = fromIntegral r
                                      playerOnCell r c = (calculatePlayerOnCell r c)


calculatePlayerOnCell :: Rows -> Cols -> Maybe Player
calculatePlayerOnCell r c
  | isWhite (c,r) = Just White 
  | isBlack (c,r) = Just Black 
  | otherwise = Nothing

isWhite (c,r) = ((boardInitial !! (c-1)) !! (r-1)) == 1
isBlack (c,r) = ((boardInitial !! (c-1)) !! (r-1)) == 2


boardInitial = [
  [0,2,0,2,0,2,0,2,0,2],
  [2,0,2,0,2,0,2,0,2,0],
  [0,2,0,2,0,2,0,2,0,2],
  [2,0,2,0,2,0,2,0,2,0],
  [0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0],
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

fillColor p     | isWhite $ toIntTuple $ calculateCord p = fill (grey 255)
                | isBlack $ toIntTuple $ calculateCord p = fill (grey 0)
                | otherwise = fill (grey 123)

drawAllPoints [] = circle 0 (0,0)
drawAllPoints (p:pr:ps) = do
  fillColor pr
  circle 15 p
  drawAllPoints ps
drawAllPoints (p:ps) = drawAllPoints ps



calculateCord (x,y) = (row ,col)
    where col = (x-calculateWidthCell/2) / calculateWidthCell
          row = (y-calculateHeightCell/2) / calculateHeightCell

toInt :: Float -> Int
toInt  = round

toIntTuple :: (Float,Float) -> (Int,Int)
toIntTuple (x,y)= (toInt x, toInt y)


drawBoard :: Pio()
drawBoard = do 
  drawRow 10 10 screenWidth screenHeight 200
draw ps = do
	background (grey 150)
	drawBoard
  	case ps of
		[] -> return ()
		_  -> do
			 drawAllPoints ps
mousePressed ps = do
  mb <- mouseButton
  case mb of
    Just LeftButton -> do
      m <- mouse
      let selectedCell = getCellCord m
      case selectedCell of
          Just cell ->  return (cell : ps)
          Nothing ->  return ([])
    Just RightButton -> do
      if null ps 
        then return []
        else return (tail ps)
    _ -> return ps