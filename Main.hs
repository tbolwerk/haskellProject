module Main where 
import Graphics.Proc
type X = Float
type Y = Float
type Width = Float
type Height = Float
type Color = Float

main = runProc $ def 
	{ procSetup  = setup
	, procDraw   = draw }

width  = 400
height = 400
center = (width / 2, height / 2)

setup = do
	size (width, height)	



cell :: X -> Y -> Width -> Height -> Color -> Pio()
cell x y w h c = do
  fill(grey c)
  rect(x,y) (w,h)

drawBoard :: Integer -> Width -> Height -> Pio()
drawBoard n w h | n <= 0 = cell 0 0 0 0 0
drawBoard n w h | n > 0 = do
                             cell (fromIntegral n * 20) 20 w h 0
                             cell 20 (fromIntegral n * 20) w h 0
                             drawBoard (n - 1) 30 30



draw () = do
	background (grey 230)
	drawBoard 3 20 20