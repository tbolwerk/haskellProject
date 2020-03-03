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
  m <- mouse 
  let selectedCell = getCellCord m
  case selectedCell of
    Nothing -> circle 0 0
    Just cell -> local $ do
      fill (grey 255)
      circle 15 cell
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


-- calculateCurrentBoardState x: (p:ps) = getCellCord x y w h p
-- op basis van point -> initial board nummer krijgen en aanpassen
-- dubbele array locatie krijgen op basis van point

-- get2DimArrayIndex p:ps = 


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
                                      playerOnCell r c = (calculatePlayerOnCell r c)


calculatePlayerOnCell :: Rows -> Cols -> Maybe Player
calculatePlayerOnCell r c
  | ((boardInitial !! (c-1)) !! (r-1)) == 1 = Just White 
  | ((boardInitial !! (c-1)) !! (r-1)) == 2 = Just Black 
  | otherwise = Nothing

-- boardInitial -> all points in ps -> current board state -> calculate player on cell



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
  [1,0,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,0,1]]

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
draw ps = do
	background (grey 150)
	drawBoard
  	case ps of
		[] -> return ()
		_  -> do
      -- fill (grey 255)
      -- linePath (ps)
			 (map (\p -> circle 15 p) ps) !! 0

mousePressed ps = do
  mb <- mouseButton
  case mb of
    Just LeftButton -> do
      m <- mouse
      let selectedCell = getCellCord m
      case selectedCell of
          Just cell -> return (cell : ps)
    Just RightButton -> do
      if null ps 
        then return []
        else return (tail ps)
    _ -> return ps