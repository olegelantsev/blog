---
title:  "I use VIM"
date: 2023-09-10T13:06:00+04:00
draft: false
cover:
    image: "vim.webp"
    caption: "VIM editor"
---

<!-- ![Design overview](/images/vim.webp) -->


9 years ago I became a VIM user (after coding 3 years in XCode), that significantly uplifted my coding skills, C++ knowledge and environment around it.
Throughout my career I used different IDEs and code editors: Visual Studio, NetBeans, XCode for iOS & Mac, Eclipse, IDEs from JetBrains (Android Studio, Idea, CLion), Sublime, VS Code.

Why did I started using VIM instead of full featured IDE?

**Responsiveness and minimal input lag** (between key press and letter on screen). The project I joined back in 2014 was so big, that none of the existing IDEs could manage it, at least not with enabled auto-complete and indexer. My colleagues used either Notepad++ (Windows), Eclipse, Emacs, VIM. I joined the later club. Typical workflow was to navigate in terminal to the right place, or use find command, open file, edit, compile & link, run the tests. That was also the time I started using GNU debugger from terminal.

**Cross platform** - on any Mac, BSD or Linux machine its often pre-installed. As a DevOps engineer I frequently have to edit code or configuration remotely and using VIM over SSH is very convenient and has minimal latency as it was designed to be efficient for remote terminal connections in the first place.

**Encourages Learning the Language** Absence of auto-complete and other reach features make you actually learn the programming language instead of relying on IDE. I quickly learned what kind of headers of standard library contains the needed declarations (string operations, IO, socket, etc). When I just started programming I used Visual Studio 6.0 and the autocomplete did all the magic. You may not know the class names and their methods by heart, and IDE helps a lot by showing what methods are available for an object. When you are exploring a new project, it may be a hard time because of the need to switch the context - jumping to documentation, reading available methods and signatures. Which brings me to the next point.

**Promotes Project Familiarity and Structure** VIM's lean interface, devoid of the navigation tools found in full-featured IDEs, encourages a unique approach. I often use the terminal to traverse the project, typing out file paths to open them in VIM. This method fosters an intimate understanding of the project's structure and component locations. Of course, in the moments of laziness I turn to plugins like NerdTree to simplify navigation between files, but it's always beneficial to have a mental map of the project's layout.
I also hope this works the other way as well - as project grows, I tend to maintain its logical structure, helping me and others navigate around.

I know there are thousands of VIM plugins exist today, that trasform it into even more powerful IDE, but typically I use just a few, such as

- **ctags** - it helps a lot with navigating around the project. Requires to build an index before, and then you can jump to the method/class definitions and back.
- **NerdTree** - it shows the file tree and simplifies navigation between the files visually with a cursor.
- **vim-colors-solarized** - I just like that theme ;-)

After the 9 years, it is still my favorite code editor.
