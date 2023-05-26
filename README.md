# gh-review

gh-review is a NeoVim plugin written in Lua designed to simplify your PR review
workflow. With gh-review, you can easily stay on top of pending PRs, open them
quickly, change your branch, and review the changes.

## Key Features

- Notifications for PRs awaiting review
- Quick access to pending PRs
- Efficient branch and diff management

## Dependencies

To use gh-review, you'll need to have the following dependencies installed on your system:

- [GitHub CLI (`gh`)](https://cli.github.com/)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Integration

gh-review works seamlessly with
[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

Using [lazy](https://github.com/folke/lazy.nvim)
```lua
{
  "agusdmb/gh-review",
  dependencies = "nvim-lua/plenary.nvim",
}
```

Using [packer](https://github.com/wbthomason/packer.nvim)
```lua
use {
  "agusdmb/gh-review",
  requires = { { "nvim-lua/plenary.nvim" } },
}
```

## Configuration

The easiest way to configure gh-review is to simply call the setup function
without any arguments:

```lua
require("gh-review").setup()
```

This will use the default settings, including an interval of 60 seconds.

If you need to customize the settings, you can pass a table to the setup
function with any of the following keys:

- interval: Determines how often to check for new PRs (in seconds). The default value is 60 seconds.

Here's an example of how to set the interval value:

```lua
require("gh-review").setup(
  {
    interval = 60  -- default value
  }
)
```

## Commands

gh-review provides the following commands:

- `GhPRs` - Opens a telescope picker with a list of pending PRs awaiting your review

We hope that you find gh-review helpful in streamlining your PR review process.
Please don't hesitate to open an issue or submit a pull request if you
encounter any problems or have suggestions for new features.

---

# draft

it will only fetch prs from the current repo
it will change your branch when doing a diff
