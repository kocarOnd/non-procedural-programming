{-Task:You have studied the propositional calculus in a previous course 
about logic.

We can represent a propositional formula in Haskell using this datatype:

data Prop = 
    Const Bool
  | Var Char
  | Not Prop
  | And Prop Prop
  | Or Prop Prop
  deriving Show

Recall that a tautology is a propositional formula that is true for every 
possible assignment of Boolean values to variables.

Define a Haskell function

isTaut :: Prop -> Bool

that determines whether a proposition is a tautology.-}

import Data.Maybe (fromJust)
import Data.List (nub)

data Prop =
    Const Bool
  | Var Char
  | Not Prop
  | And Prop Prop
  | Or Prop Prop
  deriving Show

type Subst = [(Char, Bool)]

eval :: Subst -> Prop -> Bool
eval _ (Const b) = b
eval subs (Var a) = fromJust (lookup a subs) {-Assumes a always in subs-}
eval subs (Not p) = not (eval subs p)
eval subs (And p1 p2) = eval subs p1 && eval subs p2
eval subs (Or p1 p2) = eval subs p1 || eval subs p2

vars :: Prop -> [Char]
vars (Const a) = []
vars (Var a) = [a]
vars (Not a) = vars a
vars (Or a b) = nub (vars a ++ vars b)
vars (And a b) = nub (vars a ++ vars b)

substs :: [Char] -> [Subst]
substs [] = [[]]
substs (x:xs) = [ (x, b) : s | s <- substs xs, b <- [True, False]]

isTaut :: Prop -> Bool
isTaut p = all (`eval` p) s
    where s = substs (vars p)