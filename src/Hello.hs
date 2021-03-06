-- Copyright:
--   This file is part of the package hello.  It is subject to the
--   license terms in the LICENSE file found in the top-level
--   directory of this distribution and at:
--
--     https://github.com/pjones/hello
--
--   No part of this package, including this file, may be copied,
--   modified, propagated, or distributed except according to the terms
--   contained in the LICENSE file.
--
-- License: BSD-2-Clause
module Hello
  ( hello,
  )
where

-- | Print "Hello World!".
hello :: IO ()
hello = putStrLn "Hello World!"
