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


cell :: X -> Y -> Width -> Height -> Color -> Pio ()
cell x y w h c = do
  fill(grey c)
  rect(x,y) (w,h)

drawRow ::  Rows -> Cols -> Width -> Height -> Color -> Pio()
drawRow r c widthCell heightCell color | c <= 0 = cell 0 0 0 0 0
drawRow r c widthCell heightCell color | c > 0 = do
                                cell (rows * widthCell) (columns * heightCell) widthCell heightCell color
                                drawRow r (c-1) widthCell heightCell (switchColor color)
                                where columns = fromIntegral c 
                                      rows = fromIntegral r


drawBoard :: Rows -> Cols -> Width -> Height -> Float -> Pio()
drawBoard r c w h color | r <= 0 = cell 0 0 0 0 0
drawBoard r c w h color | r > 0 = do
                            --  cell (fromIntegral c * w) h w h color
                            --  cell (fromIntegral c * w) (fromIntegral r * h) w h (switchColor color)
                            --  cell w (fromIntegral r * h) w h color
                             drawRow r c widthCell heightCell color
                             drawBoard (r-1) c widthCell heightCell (switchColor color)
                             where widthCell = 40
                                   heightCell= 40



draw () = do
	background (grey 150)
	drawBoard 8 8 width height 255