Xcode Project and File templates
================================

Project and file templates I use for my daily work. Described in my blog at

[http://gentlebytes.com](http://www.gentlebytes.com/2010/04/xcode-project-using-coredata/)

Hope you'll find the templates useful. You are free to use/modify the templates for your 
own needs!


Installation and Usage
======================

To install, copy Application folder to ~/Library/Application Support/Developer/Shared/Xcode.
Note that this will overwrite your existing `File Templates` and `Project Templates`
folders; if you use other templates in there, copy each folder contents individually!

After copying, the templates are ready to use (no Xcode restart is required!).


Usage of Project Templates
--------------------------

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


Usage of File Templates
-----------------------

To use file templates, create a new file, then select Cocoa Class from User Templates
section of Xcode New File window. On the right you'll see the option of selecting
either Objective-C class or Objective-C test case class. In the bottom part of the
window you can then select various options or subclasses to use. Note that most are
suited for use with above custom project templates, but you may find them useful
othewise too.


Special Considerations
----------------------

If you'll use CocoaLumberjack logging framework, you might experience problems with your
custom classes logging levels not being detected by DDLog class (especially if using
`updateLoggingLevelsOfAllClassesWithValue:` or `updateLoggingLevelsForClasses:levelValue:`
methods from `DDLog(GBLogExtensions)` category. The problem is due to custom subclasses
are not detected as being registered by `DDLog`s private `isRegisteredClass:` method.
The reason is in testing for conformance to `NSObject` protocol which rejects most
classes, even though they are derived from `NSObject` class... I admit, I didn't go
into details about this, so I've adopted a quick (and dirty) solution at the moment -
for each of my classes, I make them conform to an empty `GBDynamicLogger` protocol
and this solves the problem. Note that this MUST be done for each subclass as well!


Thanks
======

Project templates include the following open-source software from fellow Mac developers, 
either full or partial (in no particular order):

- CocoaLumberjack logging framework by Robbie Hanson [link](http://code.google.com/p/cocoalumberjack/).
- DDFoundation by Dave Dribin [link](http://www.dribin.org/dave/software/)
- XSViewController by Jonathan Dann and Cathy Shive [link](http://katidev.com/blog/2008/04/17/nsviewcontroller-the-new-c-in-mvc-pt-2-of-3/)
- SynthesizeSingleton by Matt Gallagher [link](http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html)

For unit testing I use the following (in addition to above mentioned):

- GHUnit unit testing framework by Gabriel Handford [link](http://github.com/gabriel/gh-unit)
- OCMock mock objects by 'Mulle Kibernetik' [link](http://www.mulle-kybernetik.com/software/OCMock/)
- OCHamcrest framework [link](http://www.hamcrest.org/)

A big thanks for all contributors!


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
