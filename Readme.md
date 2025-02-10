# pyenv-universal2

A plugin for [pyenv](https://github.com/pyenv/pyenv) that simplifies managing Python installations for both arm64 and x86_64 architectures on macOS. This plugin supports creating universal2 binaries by merging architecture-specific Python builds.

```
This is my personal plugin for managing Python installations on my system.

I created it specifically for macOS users, as it's challenging to find proper support for universal2 binaries. Using Homebrew simplifies dependency management.

Feel free to try it out and use it if it suits your needs.
```

## Prerequisites

1. **macOS**: This plugin is designed specifically for macOS users.
2. **Dual Homebrew Setup**: Both arm64 and x86_64 Homebrew installations are required (you can use [brew-dual plugin](https://github.com/ziprangga/brew-dual.git) for this).
3. **Shell Configuration**: Ensure your profile file (`~/.zprofile`, `~/.zshrc`, `~/.bash_profile`, or `~/.bashrc`) includes the following for safe dual Homebrew usage:

```bash
if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Optional: Use any alias you prefer for safety when using Homebrew
alias brew-arm='/opt/homebrew/bin/brew'
alias brew-x86='arch -x86_64 /usr/local/bin/brew'
```

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/ziprangga/pyenv-universal2.git $(pyenv root)/plugins/pyenv-universal2
```

### Step 2: Restart Your Shell

After installation, restart your shell or source your profile file to ensure the plugin is loaded:

```bash
source ~/.zshrc # or ~/.bashrc, depending on your shell
```

## Additional Note

Before building Python, ensure that you have installed the necessary dependencies using both Homebrew installations (arm64 and x86_64). Refer to the [pyenv documentation](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) for more details about the required dependencies.

You can use the Homebrew aliases for convenience when installing dependencies:

- For arm64:

  ```bash
  brew_arm install <dependency>
  # or without alias
  arch -arm64 brew install <dependency>
  ```

- For x86_64:

  ```bash
  brew_x86 install <dependency>
  # or without alias
  arch -x86_64 brew install <dependency>
  ```

Make sure to verify installed dependencies using `brew info` and ensure the versions are consistent across both architectures.

## Usage

### 1. Install Universal Python

To install a specific Python version for both architectures, use the following command:

```bash
pyenv universal2 build <version>
```

For example:

```bash
pyenv universal2 build 3.9.0
```

### 2. Install Python for Individual Architectures

To install Python for a specific architecture, append the desired suffix:

- For arm64:

  ```bash
  pyenv universal2 arm64 3.9.0
  ```

- For x86_64:

  ```bash
  pyenv universal2 x86_64 3.9.0
  ```

### 3. Install Without Suffix or With Custom Suffix or Suffix as alias

By default Pyenv-universal2 use suffix with `arm, x86 and universal`
If you do not want to use architecture-specific suffixes, use the `--without-suffix` option:

# Without suffix

```bash
pyenv universal2 3.9.0 --without-suffix
```

# Custom suffix

```bash
pyenv universal2 3.9.0 --suffix=pythonU2
```

```than python will be 3.9.0-pyhtonU2

```

# Alias

```bash
pyenv universal2 3.9.0 --alias=pythonU2
```

```than python will be pyhtonU2

```

### 4. Merge Architectures into Universal2 Binary

To merge arm64 and x86_64 versions into a universal2 binary, ensure both versions are installed with appropriate suffixes (`-arm` and `-x86`):

```bash
pyenv universal2 arm64 3.9.0
pyenv universal2 x86_64 3.9.0
```

Then, use the merge command:

```bash
pyenv universal2 merge 3.9.0
```

This will combine the two architecture-specific versions into a universal2 binary.

## Notes

- Ensure you have both arm64 and x86_64 Homebrew environments correctly configured.
- When merging, the Python versions must match exactly in both architecture builds.
- Use `pyenv versions` to verify installed versions and architecture-specific suffixes.
