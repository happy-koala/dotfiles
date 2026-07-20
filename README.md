# Bash Functions

A small collection of bash functions for macOS that make everyday command-line tasks a little more convenient.

This repository is essentially a collection of small utilities that grew out of my personal `~/.bash_functions` file. Nothing here is intended to be a framework or a complete toolkit — just a few useful commands that make life in the terminal a bit nicer.

The functions are provided individually, so you can pick the ones you like and add them to your own `.bash_functions` file.



## Functions



### `pong`

A simple notification function for macOS.

It plays a sound and, if a `blink(1)` USB notification light is available, also provides a visual signal. If no `blink(1)` is connected, `pong` simply carries on without the visual notification.

```bash
pong
```

Useful whenever a command finishes and you want something more noticeable than a terminal prompt waiting for you.



#### `blink1`

The `pong` function can optionally use a `blink1` bash function to control a connected [blink(1)](https://blink1.thingm.com/) USB device.

There is a [CLI tool](https://github.com/todbot/blink1-tool) as well as a [Python package](https://github.com/todbot/blink1-python) for the blink(1). Since I use the blink(1) from Python, I already have the Python package installed and use it for my own scripts. Rather than installing the CLI tool as well, I simply expose a small Python script through a bash function:

For example, the Python script could be located at `~/.scripts/blink.py` and exposed through `.bash_functions` like this:

```bash
blink1() {
    ~/.scripts/blink.py
}
```

If `blink1` is not available or no compatible device is connected, `pong` continues without the visual notification.



### `ntfy`

Sends a notification via [ntfy.sh](https://ntfy.sh/). 

The ntfy topic is configured separately using the `NTFY_TOPIC` environment variable:

```bash
export NTFY_TOPIC="YOUR_NTFY_TOPIC"
```

The actual topic should remain in your personal shell configuration and should not be committed to this repository.

Send a notification using the default message:

```bash
ntfy
```

Or provide a custom message:

```bash
ntfy "Backup completed"
```

It can also be used as a small companion to long-running commands:

```bash
some-long-running-command && ntfy "some-long-running-command just finished"
```



## Usage

These functions are intended to live in a personal `~/.bash_functions` file.

Add the functions you want to use to your own file and source it from your shell configuration (.bashrc or .bash_profile):

```bash
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
```

The functions are independent where possible, but some build on others.
