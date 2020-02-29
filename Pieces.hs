module Pieces where
import Graphics.Proc
drawDraught c = do
	fill (grey c)
	circle 30 (0, 0)



drawPawn c = do
	drawHead c
	drawBody c
	drawLegs c
	drawArms c

drawHead c= do	
	fill (grey c)	
	circle 10 (0, -20)

drawBody c= do
	fill (grey c)
	rect (-10, -10) (20, 40)

drawLegs c= do
	fill (grey c)	
	rect (-7, 30) (3, 27)
	rect (4, 30) (3, 27)
	
drawArms c= do
	fill (grey c)	
	strokeWeight 2
	linePath [(-10, -10), (-20, 7), (-15, 15)]
	linePath [(10, -10), (20, -27), (15, -35)]