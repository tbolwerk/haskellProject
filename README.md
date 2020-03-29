# Haskell (Functional programming paradigma)
## Inleiding
Tijdens het eerste en tweede jaar leerden wij programeren met het paradigma imperatief. In het eerste jaar vooral procedural, bijvoorbeeld in C heb ik met de arduino geprogrammeerd. Dit betekent dat het abstractie niveau laag is. Ik vertel doormiddel van code wat de code moet doen, om tot iets te komen. 

In het tweede jaar ben ik overgestapt van procedural naar object georienteerd. Het zijn beide imperatieve paradigma's wat niet meer of minder betekent dan dat ik de machine uitleg hoe het iets moet doen aan de hand van code. 

Het verschil tussen object georienteerd en procedural zit hem erin dat de groepering anders gedaan wordt.

Voor mij nu de uitdaging om over te gaan op een heel ander paradigma, namelijk decleratief. Dit komt deels overeen met SQL, waarin je beschrijft wat je wil in plaats van hoe je iets wil. Een declaratie betekent ook een aangifte, als in aangeven wat je wilt.

## Keuze programmeer taal
Mijn persoonlijke interesse ging uit naar Rust, dit is een vrij nieuwe programmeer taal met de focus op concurrency save en performance. Ondanks dat is mijn keuze gevallen op Haskell, omdat dit een unieke kans is om functioneel te programmeren. Haskell is dan wellicht niet de meest gebruikte functionele programmeer taal en heeft daardoor niet de grootste community, maar is wel de grondlegger van veel begrippen in functioneel programeren. Denk bijvoorbeeld aan Monads.

|  Criteria | Clojure | Rust  | Erlang  | Haskell  |
|---|---|---|---|---|
| functioneel | +  | - | + | ++ |
| community  | +  | +  | -  | -  |
| documentatie  | +  | ++  | --  | +  |
| gebruikt in productie  | +  | +  | ++ *1* |  + |
| performance  | +  |  ++ | +  | + |
| snel te leren *2* |  ++ | +  | --  | --  |

*1* gebruikt in Whatsapp relevant voor het ASD-project

*2* overeenkomst met java & c#

## Dag 1 Haskell Onderzoek functioneel programeren

Blog functioneel haskell
Ik ben begonnen met lezen over wat functioneel programmeren precies inhoud tenopzichte van andere paradigma.
 So in purely functional languages, a function has no side-effects.

Ik heb onder andere de volgende YouTube video gekeken over dit onderwerp.
https://youtu.be/eis11j_iGMs

## Dag 2 Haskell Interactive shell

Vervolgens begon ik te lezen uit de gratis versie http://learnyouahaskell.com/chapters
Haskell won't execute functions and calculate things until it's really forced to show you a result. 

http://learnyouahaskell.com/starting-out
Ontdekken van de interactieve mode van haskell ghci, modules inladen met :l
DoubleMe functie samenlaten werken met double us
```haskell
doubleMe x = x + x
doubleUs x y = x * 2 + y * 2
```
```haskell
*Main> doubleUs 4 9 + doubleMe 123
272 = output
```
Making basic functions that are obviously correct and then combining them into more complex functions. This way you also avoid repetition.

if statement and if statements in imperative languages is that the else part is mandatory in Haskell.

 We usually use ' to either denote a strict version of a function (one that isn't lazy) or a slightly modified version of a function or a variable.
```haskell
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1  
conanO'Brien = "It's a-me, Conan O'Brien!"   
```

List samenvoegen kan alleen van hetzelfde type
*Main> "test" ++ [1,2]

<interactive>:32:12: error:
    • No instance for (Num Char) arising from the literal ‘1’
    • In the expression: 1
      In the second argument of ‘(++)’, namely ‘[1, 2]’
      In the expression: "test" ++ [1, 2]
*Main> 

Haskell intern voegt een lijst toe ++ door de hele lijst te doorlopen
dmv. : kan dit instant
*Main> 5:[1,2,3,4]
[5,1,2,3,4]
Nadeel is dat er geen array kan worden toegevoegd, slecht 1 int of char

Een element uit een lijst "Twan Bolwerk" !! 0
'T'


Array vergelijkingen First the heads are compared. If they are equal then the second elements are compared

*Main> [3,4] > [1,2]
True
*Main> [3,4] > [1,1000]
True
*Main> [3,4] > [10,1000]
False
*Main> [3,4] > [3,1000]
False
*Main> [3,400000] > [3,1000]
True


Array functies
￼



elem takes a thing and a list of things and tells us if that thing is an element of the list. It's usually called as an infix function because it's easier to read that way.
* ghci> 4 `elem` [3,4,5,6]  
* True  
* ghci> 10 `elem` [3,4,5,6]  
* False 

￼
Grappige manier om de lengte van de array te berekenen door gebruik te maken van zip en tuples bron : http://learnyouahaskell.com/starting-out#tuples
Prelude> fst (last (zip [1..] "dit is een test"))
15
Prelude> length "dit is een test"
15


## Dag 3 Haskell Opdrachten APP in haskell

Fibonacci Haskell vs java
￼
Overeenkomsten: Beide maken gebruik van het data type Integer

2 manieren voor factorial
1ste is met guards
```haskell
fact :: Integer -> Integer
fact n | n == 0 = 1 | n /= 0 = n * fact(n -1)
```
Pattern matching

```haskell
factorial :: (Integral a) => a -> a  
factorial 0 = 1  
factorial n = n * factorial (n - 1)  
```

Quicksort with median of three in haskell

```haskell
centerOfArray :: [a] -> [a]
centerOfArray l@(_:_:_:_) = centerOfArray $ tail $ init l
centerOfArray l           = l

middleNumber :: (Ord n) => n -> n -> n -> n 
middleNumber x y z
    | x > y = middleNumber y x z
    | y > z = middleNumber x z y
    | otherwise = y

medianOfThree :: (Ord a) => [a] -> a
medianOfThree [] = error "Need atleast one item"
medianOfThree [a] = a
medianOfThree array =  middleNumber start center end
                        where start = head $ take 1 array
                              center = head $ take 1 (centerOfArray array)
                              end = head $ take 1 (drop (length $ init array) array)

quickSort3 :: (Ord a) => [a] -> [a]
quickSort3 [] = []
quickSort3 xs = quickSort3 lesser ++ sortedArray ++ quickSort3 greater 
      where
            pivot = medianOfThree xs
            sortedArray = [x | x <- xs, x == pivot]
            unsortedArray = [x | x <- xs, x /= pivot]
            lesser = filter (< pivot) unsortedArray
            greater = filter (>= pivot) unsortedArray
```

## Dag 4 Haskell Benchmark performance van quicksort
Importeren van packages, library zoals criterion een benchmarking tool.
prereqisites: cabal 

Genereer criterion benchmarks met:
[Benchmark genereren](Benchmark.hs)

$ cabal v2-run Benchmark.hs
### Benchmarking results: 
![alt text](1.png "screenshot 1")
![alt text](2.png "screenshot 2")
![alt text](3.png "screenshot 3")
![alt text](4.png "screenshot 4")
![alt text](5.png "screenshot 5")

## Dag 5 Start uitdaging chess board
Het was even puzzelen voordat ik het goed had. Het lijkt simpel 2 dimensionale array met een boolean isWhite. Echter bleek dit toch net wat complexer in een functinele programmeer taal.
![alt text](6.jpeg "screenshot 1")
![alt text](7.jpeg "screenshot 2")
![alt text](8.jpeg "screenshot 3")
![alt text](9.jpeg "screenshot 4")
![alt text](10.jpeg "screenshot 5")

## Dag 6 Start uitdaging chess pieces
Mijn intieele idee was om de pieces uit een afbeelding te halen. Helaas ondersteund de processing library van haskell dit niet. Het is alleen mogelijk omm simpele figuren te tekenen. Dit zou betekenen dat ik alle pieces moet tekenen in processing in haskell, terwijl ik liever eerst een werkend bord heb. 
![alt text](11.jpeg "screenshot 5")
![alt text](12.jpeg "screenshot 5")

Ik heb mijn uitdaging veranderd naar een dambord. Het is eenvoudig om een circel te tekenen, damsteen bedoel ik.

