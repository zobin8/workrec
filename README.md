# Workrec

Python script for time management.

Keeps track of completed tasks, time spent on tasks, and task categories.

Intended to be used with Emacs org-mode, but this is not required.

## Usage

Start a work or fun task:

```
workrec start <WORK|FUN> <CATEGORY> <TASK> 
```

To stop a task:

```
workrec stop
```

To view today's progress:

```
workrec
```

To view this week's progress on a category:

```
workrec -t week -f <CATEGORY>
```
