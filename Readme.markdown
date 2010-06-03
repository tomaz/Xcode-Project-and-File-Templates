Xcode Project and File templates
================================

Project and file templates I use for my daily work. Described in my blog at

http://www.gentlebytes.com/2010/04/xcode-project-using-coredata/

You are free to use/modify the templates for your own needs!


Installation
============

To install, copy Application folder to ~/Library/Application Support/Developer/Shared/Xcode.
Note that this will overwrite your existing `File Templates` and `Project Templates`
folders; if you use other templates in there, copy each folder contents individually!

After copying, the templates are ready to use (no Xcode restart is required!).


Usage
=====

To use project templates, start a new project, then in Xcode New Project window, select
Application option in the User Templates section on the left side of the window. This
will present you with a Cocoa Application option on the right. At the bottom part of the
window you can choose which template to use - just tick appropriate options and you're
ready to go.

Both Core Data projects include Sparkle framework, however you do need to enter few
details manually to make it usable:

1. First you need to supply the URL of your appcast file. Open your project's info.plist
   file in Xcode and enter the URL as the value of SUFeedURL key. You can find the file
   in Other Sources group.
  
2. Copy the contents of your public key file (it's called `dsa_pub.pem` by default)
   into the `dsa_pub.pem` file inside Resources group (delete existing contents!).

Sparkle auto-update check is set to daily by default. If you'd like to use other default
update timing, change the value of the `SUScheduledCheckInterval` key as well. Note that
both templates include the main menu item for manually checking for updates, but anything
more is up to you (options on preferences window for example) - consult Sparkle documentation
on github wiki pages for details on how to do that.

This should be basically everything you need to get a working skeleton.


LICENCE
=======

Copyright (c) 2009 Tomaz Kragelj

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

 
Tomaz Kragelj <tkragelj@gmail.com>
