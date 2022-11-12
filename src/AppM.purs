module AppM where

import Control.Monad.Writer.Trans (WriterT)
import Effect (Effect)
import Event (Event)

type AppM = WriterT (Array Event) Effect