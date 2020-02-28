module Pieces where
import Graphics.Proc
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