{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Chatterbot where
import Utilities
--import System.Random
import Data.Char
import Data.Text (splitOn)
--import Distribution.ModuleName (main)


chatterbot :: String -> [(String, [String])] -> IO ()
chatterbot botName botRules = do
    putStrLn ("\n\nHi! I am " ++ botName ++ ". How are you?")
    botloop
  where
    brain = rulesCompile botRules
    botloop = do
      putStr "\n: "
      question <- getLine
      answer <- stateOfMind brain
      putStrLn (botName ++ ": " ++ (present . answer . prepare) question)
      if (not . endOfDialog) question then botloop else return ()

--------------------------------------------------------

type Phrase = [String]
type PhrasePair = (Phrase, Phrase)
type BotBrain = [(Phrase, [Phrase])]


--------------------------------------------------------

stateOfMind :: BotBrain -> IO (Phrase -> Phrase)
{- TO BE WRITTEN -}
stateOfMind _ = return id

rulesApply :: [PhrasePair] -> Phrase -> Phrase
{- TO BE WRITTEN -}
rulesApply _ = id

reflect :: Phrase -> Phrase
{- TO BE WRITTEN -}
reflect = id

reflections =
  [ ("am",     "are"),
    ("was",    "were"),
    ("i",      "you"),
    ("i'm",    "you are"),
    ("i'd",    "you would"),
    ("i've",   "you have"),
    ("i'll",   "you will"),
    ("my",     "your"),
    ("me",     "you"),
    ("are",    "am"),
    ("you're", "i am"),
    ("you've", "i have"),
    ("you'll", "i will"),
    ("your",   "my"),
    ("yours",  "mine"),
    ("you",    "me")
  ]


---------------------------------------------------------------------------------

endOfDialog :: String -> Bool
endOfDialog = (=="quit") . map toLower

present :: Phrase -> String
present = unwords

prepare :: String -> Phrase
prepare = reduce . words . map toLower . filter (not . flip elem ".,:;*!#%&|")

rulesCompile :: [(String, [String])] -> BotBrain
{- TO BE WRITTEN -}
rulesCompile _ = []


--------------------------------------


reductions :: [PhrasePair]
reductions = (map.map2) (words, words)
  [ ( "please *", "*" ),
    ( "can you *", "*" ),
    ( "could you *", "*" ),
    ( "tell me if you are *", "are you *" ),
    ( "tell me who * is", "who is *" ),
    ( "tell me what * is", "what is *" ),
    ( "do you know who * is", "who is *" ),
    ( "do you know what * is", "what is *" ),
    ( "are you very *", "are you *" ),
    ( "i am very *", "i am *" ),
    ( "hi *", "hello *")
  ]

reduce :: Phrase -> Phrase
reduce = reductionsApply reductions

reductionsApply :: [PhrasePair] -> Phrase -> Phrase
{- TO BE WRITTEN -}
reductionsApply _ = id


-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq a => a -> [a] -> [a] -> [a]
{- TO BE WRITTEN -}
substitute _ [] _ = []
substitute a (x:xs) ys
  | a == x = ys ++ substitute a xs ys
  | otherwise = x : substitute a xs ys

-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
-- match _ _ _ = Nothing
match _ [] [] = Just []
match _ [] _ = Nothing
match _ _ [] = Nothing 
{- TO BE WRITTEN -}
match wildcard p s
  -- if they're equal, continue searching
  | pi == si = match wildcard (tail p) (tail s)
  -- if we reach the wildcard. We only look for the first value recursively, 
  -- thus orElse throws away the second value
  | pi == wildcard = orElse (singleWildcardMatch p s) $ longerWildcardMatch p s
  | otherwise = Nothing 
  where
    pi = head p
    si = head s

-- Helper function to match
singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
{- TO BE WRITTEN -}
-- we know that x is the answer as the first correct element since 
-- match call this when pi == wildcard. This will always return 
-- Just [x], or nothing of course if there is no matches
singleWildcardMatch (wc:ps) (x:xs) = 
  mmap (const [x]) $ match wc ps xs

{- TO BE WRITTEN -}
-- appends the correct x (using (x:)) and then continues looking for new
-- values AFTER x that are not equal to the elements in wc:ps
-- for example, "a=*;" "a=32;", first we get x = 3, then we continue
-- looking but in the match loop pi == si will not be equal but pi == wildcard
-- will be equal so that means now 2 will also be appended, thus we have 32. 
-- next iteration will reach the ; and result in pi == si being true finaly reaching Nothing
longerWildcardMatch (wc:ps) (x:xs) = 
  mmap (x:) $ match wc (wc:ps) xs


-- findInd '*' "a=*;" $ reverse $ findInd '*' "a=*;" "a=32;"
-- Test cases --------------------

testPattern =  "a=*;"
testSubstitutions = "32"
testString = "a=32;"

substituteTest = substitute '*' testPattern testSubstitutions
substituteCheck = substituteTest == testString

matchTest = match '*' testPattern testString
matchCheck = matchTest == Just testSubstitutions

-------------------------------------------------------
-- Applying patterns
--------------------------------------------------------

-- Applying a single pattern
transformationApply :: Eq a => a -> ([a] -> [a]) -> [a] -> ([a], [a]) -> Maybe [a]
transformationApply _ _ _ _ = Nothing
{- TO BE WRITTEN -}


-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply _ _ _ _ = Nothing
{- TO BE WRITTEN -}


