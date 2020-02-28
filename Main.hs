module Main where 
import Graphics.Proc
type X = Float
type Y = Float
type Width = Float
type Height = Float
type Color = Float
type Rows = Integer
type Cols = Integer

main = runProc $ def 
	{ procSetup  = setup
	, procDraw   = draw }

width  = 400
height = 400
center = (width / 2, height / 2)

setup = do
	size (width, height)	

calculateWidthCell :: Float -> Width
calculateWidthCell columns = columns / width
calculateHeightCell :: Float -> Height
calculateHeightCell rows = rows / height

switchColor :: Float -> Float
switchColor 255 = 0
switchColor 0 = 255


drawHero = do
	drawHead
	drawBody
	drawLegs
	drawArms

drawHead = do	
	fill (grey 165)	
	circle 10 (0, -20)

drawBody = do
	fill (grey 68)
	rect (-10, -10) (20, 40)

drawLegs = do
	fill (grey 125)	
	rect (-7, 30) (3, 27)
	rect (4, 30) (3, 27)
	
drawArms = do
	fill (grey 125)	
	strokeWeight 2
	linePath [(-10, -10), (-20, 7), (-15, 15)]
	linePath [(10, -10), (20, -27), (15, -35)]


cell :: X -> Y -> Width -> Height -> Color -> Pio ()
cell x y w h c = do
  fill(grey c)
  rect(x,y) (w,h)
  local $ do
    drawInCell x y w h
    scale (0.5, 0.3)
    drawHero 

drawInCell :: X -> Y -> Width -> Height -> Pio()
drawInCell x y w h= translate (x + (w / 2), y + (h / 2))

drawColumn ::  Rows -> Cols -> Width -> Height -> Color -> Pio()
drawColumn r c widthCell heightCell color | c <= 0 = cell 0 0 0 0 0
drawColumn r c widthCell heightCell color | c > 0 = do
                                cell (rows * widthCell) (columns * heightCell) widthCell heightCell color
                                drawColumn r (c-1) widthCell heightCell (switchColor color)
                                where columns = fromIntegral c 
                                      rows = fromIntegral r


drawRow :: Rows -> Cols -> Width -> Height -> Float -> Pio()
drawRow r c w h color | r <= 0 = cell 0 0 0 0 0
drawRow r c w h color | r > 0 = do
                             drawColumn r c widthCell heightCell color
                             drawRow (r-1) c widthCell heightCell (switchColor color)
                             where widthCell = 40
                                   heightCell= 40


drawBoard = drawRow 8 8 width height 255

draw () = do
	background (grey 150)
	drawBoard