import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Loggers
import XMonad.Layout.NoBorders 
import System.IO
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import XMonad.Layout.Grid
import XMonad.Layout.Column
import XMonad.Layout.TwoPane
import XMonad.Layout.SimpleFloat


myManageHook = composeAll
    [ className =? "Thunderbird" --> doF (W.shift (myWorkspaces !! 0))
    , className =? "Firefox" --> doF (W.shift (myWorkspaces !! 1))
    ] <+> composeOne
    [ isFullscreen -?> doFullFloat
    ]

myModMask::KeyMask
myModMask = mod4Mask
myControlMask::KeyMask
myControlMask = controlMask

myTerm = "urxvt"
myNormalBorderColor  = "#33486C"
myFocusedBorderColor = "#86A2BE"

myWorkspaces = clickable . (map dzenEscape) $ ["mail", "web", "emacs", "org"] ++ map show [5..9]
	    where clickable l = ["^ca(1, xdotool key super+" ++ show(i) ++ ")" ++ ws ++ "^ca()" |
	    	  	          (i,ws) <- zip [1..] l ]

myLayoutHook = avoidStruts $ smartBorders $ 
	       		   (   tiled 
			   ||| Mirror tiled 
			   ||| simpleFloat
			   ||| Full 
			   ||| Grid 
			   ||| stacked 
			   ||| Mirror stacked 
			   ||| TwoPane (3/100) (1/2)
			   )
			   where tiled   = Tall 1 (3/100) (1/2)
			   	 stacked = Column 1.618

myConky = "conky -c ~/.xmonad/conkyrc | dzen2 -x 980 -w 660 -ta r" ++ " " ++ myDzenStyle
myDzenStyle = "-e '' -fn -*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*"
myDmenuStyle = " -fn -*-terminus-medium-*-*-*-14-*-*-*-*-*-*-* -nb '#242424' -nf '#A1C4E6' -sb '#A1C4E6' -sf '#242424'"

main = do
    dzenOutput <- spawnPipe $ "dzen2 -ta l -w 980" ++ " " ++ myDzenStyle
    spawn myConky
    xmonad $ defaultConfig
    	   { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
	   --, layoutHook = avoidStruts  $  smartBorders $ layoutHook defaultConfig
	   , modMask = myModMask
	   , terminal = myTerm
	   , normalBorderColor = myNormalBorderColor
	   , focusedBorderColor = myFocusedBorderColor
	   , logHook = dynamicLogWithPP $ myDzenPP {ppOutput = hPutStrLn dzenOutput} 
	   , workspaces = myWorkspaces
	   , layoutHook = myLayoutHook
	   } `additionalKeys` myKeys



myKeys =   [ ((myModMask, xK_z), spawn "slock")
	   , ((myControlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	   , ((0, xK_Print), spawn "scrot")
	   , ((myModMask, xK_p), spawn $ "dmenu_run" ++ myDmenuStyle)
	   , ((myModMask, xK_Tab), toggleWS)
	   , ((myModMask, xK_q), broadcastMessage ReleaseResources >> restart "xmonad" True)
	   , ((0, 0x1008ff11), spawn "amixer sset Master 3%-")
	   , ((0, 0x1008ff12), spawn "amixer sset Master toggle")
	   , ((0, 0x1008ff13), spawn "amixer sset Master 3%+")
	   , ((0, 0x1008ff02), spawn "xbacklight -inc 5")
	   , ((0, 0x1008ff03), spawn "xbacklight -dec 5")
	   , ((myModMask, xK_e), spawn "emacs")
	   , ((myModMask, xK_r), spawn "rox")
	   ]

myDzenPP = dzenPP
    { ppCurrent = dzenColor "#A4BC51" "" . wrap "[" "]"
    , ppHidden  = dzenColor "#86A2BE" "" . wrap " " " "
    , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " " "
    , ppUrgent  = dzenColor "#D94C3D" "" . wrap " " " "
    , ppSep     = " "
    , ppLayout  = dzenColor "#AAAAAA" "" . wrap "^ca(1,xdotool key super+space): " " :^ca()"
    , ppTitle   = dzenColor "#86A2BE" "" . wrap "^ca(1,xdotool key super+k)" " ^ca()" . shorten 50 . dzenEscape
    --, ppExtras  = [ wrapL "[bat:" "]" battery
    --  	    , wrapL "" "" (date "%a %b %d %H:%M")
    -- 		    ]
    }
