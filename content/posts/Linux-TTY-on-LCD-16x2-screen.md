---
title: "Linux TTY on LCD 16x2 screen"
date: 2024-12-05T12:00:00
draft: false
---

{{< youtube kIuDFnvjQvw >}}

#

Yet another just for fun project. I decided to make use of a small LCD screen from Arduino kit & Raspberry Pi.

Inspired by historical teletype access to the computers & also challenges to use low-end tech as working setup (e.g. full day work on Raspberry Pi or Chrome books). Even today terminal is used, mostly by software developers, to run system commands for managing files, writing code, debugging, building apps, managing configs, etc. It’s sometimes surprising how much can be done by using only terminal and no fancy GUI at all.

What I want - is to use see TTY in LCD screen as if it is the only screen available.

### Breadboard

There are many articles available on how to connect LCD 1602 to Raspberry Pi (e.g. [this](https://www.mbtechworks.com/projects/drive-an-lcd-16x2-display-with-raspberry-pi.html)). The only component I miss is the trimpot for contrast. I replaced it with 1K Ohm resistor and contrast turned out to be about right.

Once the LCD is connected, a simple program in Python will be able to render characters. I used a program from an article as a scaffold and quickly rendered first “Hello, World!”.

### TTY

TTY stands for teletype. It’s a user interface device that uses text for input and output. On Linux if you run `tty` command, it returns user’s terminal name. The original terminals in Linux are `/dev/ttyX` - as I understood those are available with CTRL + ALT + F1 console.

There are also `/dev/pty/` that functions as a pseudo-TTY - that acts like physical, but is not a real one. If you open a term app in Ubuntu or SSH to it and run `tty` command output will show it’s a pseudo-terminal.

The greatest article I can recommend on TTY - [The TTY demystified](http://www.linusakesson.net/programming/tty/index.php). I am also looking for more resource to learn more on TTY subsystem. Any sources you can recommend?

The next task - is to read the TTY in Linux and pass it to the LCD.

I was sure there should be a way to access it and was considering writing a TTY driver for it, but came across [this Reddit post](https://www.reddit.com/r/raspberry_pi/comments/fnd8rk/full_linux_tty_on_lcd1602/) that exactly what I want and mentions VCS.

VCS - [man vcs](https://man7.org/linux/man-pages/man4/vcs.4.html) - virtual console memory

Example of its contents:

```jsx
$ hexdump -c /dev/vcs2
0000000
*
00001e0   R   a   s   p   b   i   a   n       G   N   U   /   L   i   n
00001f0   u   x       1   1       r   a   s   p   b   e   r   r   y   p
0000200   i       t   t   y   2
0000210
*
00005a0   r   a   s   p   b   e   r   r   y   p   i       l   o   g   i
00005b0   n   :       o   l   e   g
00005c0
*
0000780   P   a   s   s   w   o   r   d   :
0000790
```

What my Python program does is pretty straightforward:

- continuously reads characters from `/dev/vcs`
- renders lines on LCD screen

But entire TTY currently doesn’t fit the LCD screen, it has to be resized. `stty` tool helps with that:

```jsx
stty cols 16 rows 2
```

After that the output become correct and TTY is usable. 

## Conclusion

I played around with terminal on such screen. Tasks such as `ls` that needs multiple line output are better be used in combination with `less` so you can conveniently scroll the content as there are only 2 rows available.

I managed to create a simple C++ program that prints Hello World, compile and run it 😀 and a few commands in Python interpreter.

Here is a short demo video:

https://youtube.com/shorts/kIuDFnvjQvw?feature=share

### References:

https://www.mbtechworks.com/projects/drive-an-lcd-16x2-display-with-raspberry-pi.html

https://www.reddit.com/r/raspberry_pi/comments/fnd8rk/full_linux_tty_on_lcd1602/