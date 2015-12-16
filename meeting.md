---
title: Praqma GIT course
author: Sebastian K. Mangelsen
date: 2015-12-15
toc-title: Table Of Content
...


# Introduction

## Some Ideas To Cover
* Handle tools in GIT
* Handle big binary files
* Interaction with task management tools


## Evolution of Version Control
*  GIT distributes the complete database on all computer that clone the main repository.
*  The downside is that could be big.
*  Its not a good idea to put an existing VMS directly into GIT.
   
   
# GIT Commands
Before starting work with GIT everyone should start with setting users name and email adress.

~~~~{.bash}
git config --global user.email "your@mail.com"
git config --global user.name "Name Surname"
~~~~

After that we could initialize a new files becoming a GIT repository

~~~~{.bash}
mkdir DIR && cd DIR
git init .
~~~~

Once this is done, we're ending up with a new directory that contains a hidden directory
called `.git`.


## GIT Clone

It is possible to clone a local repository and make it a service instance. This could
be very handy if you start developing code in a local repository and would like to turn 
the repository to a server instance.

> Note: A server instance would just contain the repository database and not the files.

## GIT Commit

* A commit is always taken from the staging area

### GIT Commit Message
* add a brief description in the first line (less than 60 characters)
* add an empty line
* add as much of new lines you want explaining the details
* when printing the log in GIT as a one-liner, just the first brief description is shown
* be picky when colleagues writing commit messages, especially
* try to avoid the word __and__ in a commit message, this is a reminder that one should
  isolate the two parts of the commit

### Review changes before committing
In order to review changes before committing changes one could use the `-p`.

~~~~{.bash}
git commit -p <file.name>
~~~~

### Ammended commit messages
This is a handy way to rewrite commit messages. Furthermore it could be used to 

~~~~{.bash}
git commit --amend # no changes made, just change the message
~~~~

It will open up a commit message editor and allows you to change the commit message for 
the previous commit.

~~~~{.bash}
git commit --commit             # first commit messing things up
git commit --add <file.change>  # add a new file
git commit --amend              # fix the previous commit
~~~~

For more information refer to the [following article](https://git-scm.com/book/be/v2/Git-Basics-Undoing-Things).

> Note: Every amend operation will get its own SHA because every changed commit message or
file will always affect the SHA.

## GIT Branch
In order to list branches just type

~~~~{.bash}
git branch
~~~~

Creating one branch is as easy as typing the following command. The command just
creates just a new file that contains the SHA reference.

~~~~{.bash}
git branch <branchname>
~~~~

In order to switch to the newly created branch type.

~~~~{.bash}
$ git checkout <branchname>
~~~~

Once you would like to check that you've actually switched to the new branch type:

~~~~{.bash}
$ git status
~~~~

### Some recommendations

* Avoid long living branches - it will create integration debt.

## GIT RESET
Sometimes it is really useful to reset the last commit. One could do that using the
following command.

~~~~{.bash}
git reset --hard HEAD^
~~~~

This command will change the branch __and__ the working directory. For further reading 
refer to [GIT SCM blog](https://git-scm.com/blog).

Try to avoid rewriting the history. Its usualy a very bad idea when sharing code with
other people.

## GIT Merge

*  fast forward commit is possible if there are no differences.
*  that means that just the reference is changed pointing to the 
*  fast forward is possible if there is a _linear line of history_
   *  direct descendant
*  If a branch is no longer needed, just delete it

~~~~{.bash}
$ git branch --merged #show allready merged branches
~~~~

The previous command shows the list of branches that are already merged.

~~~~{.bash}
$ git branch -d <branchname>
~~~~

When merging divergent branches it will end up in a new commit using a 
[recursive merge](http://codicesoftware.blogspot.com/2011/09/merge-recursive-strategy.html)
strategy.

~~~~{.bash}
$ git merge greetings master

Merge made by the 'recursive' strategy.

 goodbuy.sh | 4 ++++
 hello.sh   | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)
 create mode 100644 goodbuy.sh
~~~~

### GIT Merge with conflicts

~~~~{.bash}
git checkout <branchname>
git add <something> # add your changes
git commit -m "your message"
git checkout <otherbranch>

# make and commit some conflicting changes

git merge <branchname>
Auto-merging hello.sh
CONFLICT (content): Merge conflict in hello.sh
Automatic merge failed; fix conflicts and then commit the result.

open hello.sh   # make your fixes

git add hello.sh  # stage changes and mark the conflict as resolved

git commit -m "your commit message"  # commit the changes

~~~~


### GIT Merge further reading
When it comes to merge strategy refer to [this link](http://git-scm.com/docs/merge-strategies)

### GIT Importance of branching strategy
Keeping that in mind, it's important to agree onto a branching strategy. Otherwise
it could get tricky to work together.

### GIT commit in detached mode
Sometimes it could be useful to commit code changes without being in a branch.
This is possible when starting in a so-called "detached state" and commit code changes.
This commit will later be fetched by the garbage collector after a certain amount of
time. This could be very useful when going back in time in order to find the commit
to start a new branch from. Once you've find a proper commit create a branch

### GIT Checkout with anchestry reference modifiers

The order of _parent_ is depending how the merge has been done. But one could say that
the first parent is always the left most anchestor.

~~~~{.bash}

git checkout HEAD
git checkout HEAD^^ #(second last parent)
git checkout HEAD~3 #(third last parent)

~~~~

One could even type a combination of both.

~~~~{.bash}
git checkout HEAD^2~2 # second parent, go back 2 commits
~~~~


## GIT DIFF
* One could add his own diff tool by typing. For more details take a look 

~~~~{.bash}
git config --global core.diff "your tool" # change the default diff tool
~~~~

## GIT LOG

Trying to show the commits for a certain period in time, for a given file name.

~~~~{.bash}
$ git log --oneline -- <filename.h>

c9f54e8 commit after the first day
6238545 initial commit
~~~~


## GIT SHOW

The command __show__ can be used to show details about a certain commit.

~~~~{.bash}
$ git show <SHA1>
commit 1688b262620b3e708ec062ab11311e17314b55cf
Author: Sebastian K. Mangelsen <sebastian@mangelsen.se>
Date:   Tue Dec 15 15:15:21 2015 +0100

    new conflicting edit

diff --git a/hello.sh b/hello.sh
index b622892..560aefb 100644
--- a/hello.sh
+++ b/hello.sh
@@ -3,4 +3,5 @@
 echo "Hello"
 echo "HELLO"
 echo "new greetings"
+echo "Berlin"
 exit 0

~~~~


## GIT References

Just a pointer to a commit.

* long SHA
* short SHA
* branch
* HEAD
   - when
* tags






## GIT Rebase

While working in a local branch other people are doing new changes to the master.

It goes back to the common anchestor, puts the commits on _master_ and puts your changes 
on top of it. The whole task ends with with a straight line.

If _rebase_ ends up in a conflict, fix the changes and continue with:

~~~~ {.bash}
git rebase
git status
vim hello.sh
git add hello.sh
git rebase --continue
~~~~

> __Note__: Try to avoid synchronizing __master__ into your local branch and then start 
__rebasing__. Because it could end up with circular dependency.

This should be a common strategy to always rebase to the __master__ committing code
to the _remote_ repository.

## GIT Reflog

Instead of showing a graphical representation of the commits one could show a kind of a 
historyt for the local repository.


## GIT Clone

The difference between __copy__ is that when cloning you will get a remote entity
in your GIT configuration.

## GIT Remote

A remote branch is deleted by:

~~~~{.bash}
git push origin --delete <serverBranchName>
~~~~

> __NOTE__: When creating a new remote branch, always talk to each other in order to 
understand whether this branch is actually used by someone else. This will especially be
true in cases where you would like to remove this local branch. So create a good
communcation channel around a remote repositry.

## GIT Push Methods

There a 4 different methods for push modes.

*  nothing - do not push anything
*  current - push the current branch to a branch with the same name
*  upstream - push the branch back to the one whose changes are usualy integrated
*  matching - local branch name matches a branch existing on a remote server
*  simple - works like upstream, with safety in cases where names differ
*  upstream - 
*  default

> __NOTE__: Always __pull__ before __push__. Otherwise you might end up in trouble where
local changes are in conflict with remote ones.

It is possible to push the local branch to a remote branch with a different name.

~~~~{.bash}
git push feat/branch123:<serverbranchname>
~~~~

## GIT Ignore

There is a __local__ and a __global__ GIT ignore file. They are both called `.gitignore`.
One should put operating specific files (__DS_STORE) into the __global__ and project specific 

## GIT Tag

Two types exists. __Lightweight__ and __annotated__ tags. The difference is that an 
annotated tag ends up in an own commit.

~~~~{.bash}
git tag v0.10.1 <SHA1>   # create a lightweight tag
git tag v0.10.1 <SHA1>   # create a lightweight tag
~~~~

If you do not specify the commit ID it will apply it to the current HEAD. For further 
reading refer to [this article](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

## GIT Blame

This is a tool that could be used to find out _who_ made changes to _what_ in _which commit_.

> __Note__: If you did a __shallow__ clone of a remote repository you can only access those
items when doing a blame. So keep that in mind to avoid bug tracking GIT. :-)


## GIT Clean

It will remove untracked file from a working tree. It helps you to clean-up the working 
tree in order to verify the build would actually.

Usualy files that are not tracked in a branch will be kept in the working tree when 
checking out a new branch. GIT rejects changing the branch if the locally changed
file is tracked by the branch.

~~~~{.bash}
git clean -f -d -x
~~~~


## GIT Stash

When one is identifying that she made changes to a file but did it in the wrong branch,
GIT stash is a handy tool in order to put the changes to a local storage and clean the 
working tree before checking out the targeted branch.

~~~~{.bash}
git stash -m "message"     # put the local change to the stash and give it a note
git checkout <branchName>
git stash push             # fetch the changes from the stash and apply them
~~~~

> __Note__: It is a very handy tool when one has to switch the task one is working with. 
Lets say you have a lot of changes for a really cool feature and another person comes 
to your office and tells you to start working with an urgent bug report. You could 
_stash away_ your local changes and start with a clean working tree. Later on the changes 
could be reapplied to the working tree.

## GIT GC

One could perform a garbage collection in order to optimize the local repository. It will 
perform file revision compression and tries to remove unreachable objects.



## GIT Interactive Rebase

In short this is a more user friendly version of rebase.

~~~~{.bash}
git rebase --interactive HEAD~4 # interactive rebase for the last 4 commits
~~~~

It will open your favourite editor where one could change the signal words in front
of each commit SHA1.

pick
reword - 
edit - use commit, stop for amending
squash - use commit but meld ith into previous commit
fixup - like squshm but discard this commit message
exec - run a command

~~~~{.bash}
pick 2cb7d7b added a README.md file
pick ac1c52b adds a disclaimer
pick edc7f46 make a mistake
pick 73c99e8 first commit
pick f390baf Adding the changes
pick c214a98 a new line in order to leave the detached state
pick 1688b26 new conflicting edit

# Rebase f8d263e..c763f83 onto f8d263e (7 command(s))
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
~~~~

Then GIT opens an editor session in order to make the changes one has requested.

The difference to an usual _rebase_ operation is that one could not only rebase the
commit but squash, rearrange, change commit message and delete commits when rebasing the
branch. In short - one can change the local history to make it looks nice! :-)

## GIT Bisect

It is a binary search to find the commit that introduced a bug. One could provide a shell
script that will be executed for each commit in the bisect area.

The first to do is to mark _start_ (last working commit) and _stop_.

~~~~{.bash}
git bisect start HEAD~5
~~~~

Fort further reading refer to [this article](https://git-scm.com/docs/git-bisect).


## GIT Cat-File

This tool is usualy used in the background. It is just interesting to see how GIT
works in the background.

~~~~{.bash}
$ git ls-tree HEAD  # presents a SHA1 ID for each file in working tree
100644 blob 89f9ac04aac6c8ee66e158853e7d0439b3ec782d	.gitignore
100644 blob f2578a054234b5deaf310bfcee542b959879af80	Makefile
040000 tree 1a5db2fc8362c9f7310c691f3c42d4a3d484d93b	html
040000 tree aa88afc5b629f2f8c8e044d9ba8d8a9995dcdfec	img
100644 blob 3957bced6b7d89ad6c92ee941dc76ab9365d2dc7	meeting.md

$ git cat-file -p f2578a054234b5deaf310bfcee542b959879af80     # print the content
out/

~~~~


# GIT Branching Strategy

For further reading there is a [good article](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows).

> __Avoid__: Team-based branches

## Stability-based branch

Usualy the _master_ branch is the one that is safe to clone at every time (will 
always build). So it is always save to merge down. Merging up isn't very safe and has to
be take care about. So you should never do a fix directly in the _master_ branch. Instead
create __fix__ branch and merge the changes into the _master_ branch. This won't be the 
branching strategy when using _GIT_.


## Topic Branching

You could even call it _feature_ branch. Everytime you create a change you would 
create an own branch (i.e. for an BLI). The advantage is that it is easy to do a 
rebase with the master branch. 

## GIT Flow

It is basically a stability-based branching strategy with GIT. A disadvantage is that it
has very many long-living branches. This is against the continuous delivery perspective.

## CoDe:U Git Flow

Refer to the following online [PDF document](http://www.praqma.com/sites/default/files/img/git_flow_web.pdf).

*  A continuous delivery tool precheckes a branch and merges automatically when all tests
passed.
*  Naming is used as a trigger for an automated test and integration system.
*  Squash merge is used in order to reduce number of commits. The reason is that all commits
wants to be reversable. So in order to ensure that there is no conflict a developer is 
instructed to rebase before marking the branch he is working on as _ready_.


# GIT Submodule

Sometimes a teams work with code that requires a shared resource (kind of an API, a 
platform code). And very often both parts of the application have different release 
cycles. So then the code points to a released version of the shared repository - the 
__submodule__.

~~~~{.bash}
$ git submodules add https:///uri.to.remote.repo.com
$ git status # check what have changed

git submodule add file:///home/ccsekru1/Projects/praqma_submodule
Cloning into 'praqma_submodule'...
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 4 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (4/4), done.
Checking connectivity... done.

$ git status # check the files changed
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   .gitmodules
	new file:   praqma_submodule

$ git commit -m "added a submodule"

[master 61ef5be] adding a new submodule that is file based
 2 files changed, 4 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 praqma_submodule

$ git log --oneline -2 # we ended up with a new commit
61ef5be adding a new submodule that is file based
c763f83 resolved conflict merging newgreetings

~~~~

> __Note__: If you update your repository you've just get a specific commit out of 
the submodules repository. But there is a workaround that is stated below.

> __Note__: When adding a submodule it is always done at a specific commit.

For further information refer to [this article](https://git-scm.com/docs/git-submodule).

## Clone into a submodule

One could either clone the repository that uses a submodule

~~~~{.bash}
$ git clone uri:///path/to/repo
~~~~

The problem is that the submodules directory will be empty. In order to fix it 
we got two possible ways.

### Initialize A Submodule
Jump to the submodules directory and run the following commands.

~~~~{.bash}
$ cd path/to/submodule
$ git submodule init
$ git submodule update
~~~~

### Recursivly Clone a Repository

As an alternative one could right from the beginning clone a repository that
contains a submodule __recursively__.

~~~~{.bash}
$ git clone --recursive
~~~~


### Remove a submodule

Removing a submodule is not really straight forward. Mike provided a link to a guide
explaining how to do that.

1. Delete the relevant section from the .gitmodules file.
2. Stage the .gitmodules changes `git add .gitmodules`
3. Delete the relevant section from .git/config.
4. Run `git rm --cached path_to_submodule` (no trailing slash).
5. Run `rm -rf .git/modules/path_to_submodule`
6. Commit `git commit -m "Removed submodule <name>"`
7. Delete the now untracked submodule files
8. `rm -rf` path_to_submodule

## Get Updates from a Submodule

Once the submodule have some new updates, we would get those changes into our working 
tree. So changes are fetched as any other repository.

~~~~{.bash}
$ cd ./path/to/repo/submodule
$ git fetch
$ git merge origin/master
$ cd ..
$ git diff --submodule[=submodule name]
$ git add <submoduleName>
$ git commit
~~~~




# GIT Questions

Why should we make use of GIT?

: Because it is cool.

What will happen if we rename a branch remotely.

: Ask Mike


# GIT Idea Pad
In this section we collect some ideas regarding teaching GIT or any other idea that is
worth noting.

## Teaching GIT
*  Create a local repository
*  

## GIT Tools
* [BFG REPO Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)


# Course Improvements
* Ensure that everyone has installed a proper version of GIT
* Provide a PDF containing the links
* You are a way to fast!!
* When asking people writing down notes describing how they work. Analyze them and
return with some feedback.
