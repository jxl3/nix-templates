#!/usr/bin/env cached-nix-shell
#! nix-shell --pure
#! nix-shell -p "ghc.withPackages (ps: with ps; [optparse-applicative])"
#! nix-shell -i runghc
#! nix-shell -I nixpkgs=https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz

import Options.Applicative

data Sample = Sample
  { hello :: String,
    quiet :: Bool,
    enthusiasm :: Int
  }

sample :: Parser Sample
sample =
  Sample
    <$> strOption
      ( long "hello"
          <> metavar "TARGET"
          <> help "Target for the greeting"
      )
    <*> switch
      ( long "quiet"
          <> short 'q'
          <> help "Whether to be quiet"
      )
    <*> option
      auto
      ( long "enthusiasm"
          <> help "How enthusiastically to greet"
          <> showDefault
          <> value 1
          <> metavar "INT"
      )

main :: IO ()
main = greet =<< execParser opts
  where
    opts =
      info
        (sample <**> helper)
        ( fullDesc
            <> progDesc "Print a greeting for TARGET"
            <> header "hello - a test for optparse-applicative"
        )

greet :: Sample -> IO ()
greet (Sample h False n) = putStrLn $ "Hello, " ++ h ++ replicate n '!'
greet _ = return ()
