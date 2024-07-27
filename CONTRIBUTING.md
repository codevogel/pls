# Contributing to Project Level Shortcuts (pls)

First off, thank you for considering contributing to Project Level Shortcuts! 

It's people like you that make `pls` such a great tool. ❤️ 🐦 

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for pls. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

- Use a clear and descriptive title for the issue to identify the problem.
- Describe the exact steps which reproduce the problem in as many details as possible.
- Provide specific examples to demonstrate the steps.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for pls, including completely new features and minor improvements to existing functionality.

- Use a clear and descriptive title for the issue to identify the suggestion.
- Provide a step-by-step description of the suggested enhancement in as many details as possible.
- Provide specific examples to demonstrate the steps or point out the part of pls which the suggestion is related to.
- Explain why this enhancement would be useful to most pls users.
- Optionally, suggest how you think your enhancement could be implemented.

I retain the right to reject any suggestions that I don't see fit for the project, but please don't let that discourage you from suggesting improvements or reporting bugs!

### PRs, Issues, and Discussions

Pull Requests are always welcome - I will do my best to review them in a timely manner. I cannot promise your feature will always get accepted. If you have any questions, feel free to open an issue or discussion. My only real 'rule' is that you should write **unit tests** for the new features you add.

## Getting Started

- **Building**
  
  `pls` is made using `bashly`. To get started, you'll need to install `bashly`. Please refer to the [installation instructions on the `bashly` website](https://bashly.dannyb.co/installation/).

  You can run `bashly generate` to generate the new `pls` script containing your changes. You can then run `./pls` in the root of this repository to test your changes. `bashly generate -w` will watch for changes and regenerate the script automatically.

- **Testing** 

  `pls` also uses `shellspec` for unit tests. To run the tests, you'll need to install `shellspec`. Please refer to the [installation instructions in the `shellspec` repository](https://github.com/shellspec/shellspec?tab=readme-ov-file#installation).

  You can then run `shellspec --shell bash --format documentation` to run the tests.

But hey, who are we kidding? Of course `pls` comes with a `pls` file of its own, so to build or test, you can just run `pls build` or `pls test`!
