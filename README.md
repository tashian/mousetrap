## 🐭  Mousetrap 

Trying to master the keyboard shortcuts in your favorite app?  
Use Mousetrap to selectively disable the mouse when that app is active.

Note: This is a command-line app until I have time to make it a Proper Menubar App.

To build 🪤:

0. Clone this
1. Install Xcode
2. In `mousetrap.m`, change the list of `blockedApps` to your liking
3. Run `clang -o mousetrap mousetrap.m -framework Cocoa`


To run 🪤:

`sudo ./mousetrap`

Note that you will need to give this app accessibility privilieges.

Have fun.

