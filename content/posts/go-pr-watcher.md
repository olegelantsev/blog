---
title:  "Watch GitHub PRs"
date: 2021-10-24T20:07:00+01:00
draft: false
cover:
    image: "images/go-pr-watcher.png"
    caption: "go-pr-watcher tool listing open pull requests"
---

<!-- ![Design overview](/images/go-pr-watcher.png) -->

I try to cultivate a habit to regularly keep an eye on whats going on in the project, either on user story or code changes levels.
User stories are relatively easy to track (still might be improved) with existing tooling, while code changes is a bit more challenging.

The typical flow I had for months is checking a dedicated folder in the e-mail inbox, where notification messages were sent for the new comments, raised PRs and PR status changes. The downside of such approach is that messages are separated from regular "inbox", and I may forget to check the other folder as well. Soon I removed such rule, and kept checking the only inbox folder and try to keep it empty at all times - this worked better. This however requires an immediate reaction, such as checking the new PR, or responding to the new comments, or something unrelated to PRs, which may be even more costly in terms of context switching.

To avoid possible distractions, it would be better to have a list of open pull requests. GitHub or BitBucket show you the list of open pull requests on owning repositories or pull requests where you are added as reviewer.
I wanted to regularly check all PRs including repositories where I am neither an owner nor a reviewer. And preferably in a fancy way :-). Some time ago I came across a [tview](https://github.com/rivo/tview) - project for terminal based interface - which would be perfect for listing of pull requests in a terminal.

As a solution I made a simple tool written in Go. It shows the table of open pull requests to the desired GitHub repositories. Other git solution can be added later if needed. It requires Personal GitHub token, as it enables higher rate limit than in anonymous mode, which is stored in the keyring. I believe you use Ubuntu with Gnome, right? ;-)  

With such approach there is no need to check the inbox to monitor open PRs. It is also "stateless" approach in comparison with notifications in the inbox - where streaming events require reader to keep up with the incoming messages, otherwise they will pile up and would not deliver a proper overview.

The app is available at [github.com/olegelantsev/go-pr-watcher](https://github.com/olegelantsev/go-pr-watcher).