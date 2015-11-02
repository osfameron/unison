module Unison.Signals where

import Control.Monad.Fix
import Data.These
import Reflex
import Reflex.Dom

toggle :: (MonadFix m, MonadHold t m, Reflex t) => Bool -> Event t a -> m (Dynamic t Bool)
toggle initial e = foldDyn (\b _ -> not b) initial (initial <$ e)

mergeThese :: Reflex t => Event t a -> Event t b -> Event t (These a b)
mergeThese a b = mergeWith g [fmap This a, fmap That b] where
  g (This a) (That b) = These a b
  g _ _ = error "not possible"

mergeLeft :: Reflex t => Event t a -> Event t b -> Event t (Either a b)
mergeLeft a b = mergeWith const [fmap Left a, fmap Right b]

upArrow, downArrow, leftArrow, rightArrow :: Reflex t => Event t Int -> Event t Int
leftArrow = ffilter (== 37)
upArrow = ffilter (== 38)
rightArrow = ffilter (== 39)
downArrow = ffilter (== 40)