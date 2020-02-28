{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_haskellProject (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/twanbolwerk/.cabal/bin"
libdir     = "/Users/twanbolwerk/.cabal/lib/x86_64-osx-ghc-8.6.5/haskellProject-0.1.0.0-inplace-haskellProject"
dynlibdir  = "/Users/twanbolwerk/.cabal/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/twanbolwerk/.cabal/share/x86_64-osx-ghc-8.6.5/haskellProject-0.1.0.0"
libexecdir = "/Users/twanbolwerk/.cabal/libexec/x86_64-osx-ghc-8.6.5/haskellProject-0.1.0.0"
sysconfdir = "/Users/twanbolwerk/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskellProject_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskellProject_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "haskellProject_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "haskellProject_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskellProject_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskellProject_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
