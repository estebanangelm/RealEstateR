# Contributor Guidelines

### 1. External Contributors 

If you would like to propose an update or report a bug to `RealEstateR`, please check out the repo's [issues](https://github.com/UBC-MDS/RealEstateR/issues) to see if it's in our backlog. You can create a new issue to report the bug (use `bug` label), to ask a question (use `question` label), or to propose an update to enhance the code (use `enhancement` label). 

To contribute to `RealEstateR`, you must fork the repo and make changes in the forked version:

```
https://github.com/yourusername/RealEstateR
```

Please follow the [Google style guide](https://google.github.io/styleguide/Rguide.xml) for R syntax and documentation.

Once you have made all of your proposed updates, submit a **pull request** and reference the appropriate `issue` that you have tackled.

**Note:** As a contributor, you must adhere to the terms outlined in our [Contributor Code of Conduct](CODE_OF_CONDUCT.md).


### 2. Core Contributors

- All core contributors can push either into their own dev branch OR directly to master if their code passes the `devtools::check()` test.

- When a contributor is working on a separate branch and wants to merge with the *master* branch, they can either create a pull request and assign it to a fellow contributor for verifying OR merge themselves given that their code passes `devtools::check()`.

- **Requirements for merging a PR:**
    - Code should be tested with `devtools::check()` before being merged. 
    - It is recommended that contributors run [lintr](https://github.com/jimhester/lintr), `devtools::spell_check()`, and [goodpractice]((https://github.com/MangoTheCat/goodpractice) before submitting a PR.