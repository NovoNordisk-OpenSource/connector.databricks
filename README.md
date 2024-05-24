
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Rtemplate

<!-- badges: start -->

[![R-CMD-check](https://github.com/NN-OpenSource/Rtemplate/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/NN-OpenSource/Rtemplate/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package is a template for future R packages developed by the ATMOS
team.

The template sets package development standards, and GitHub action
workflows. For details see below.

The repository is meant to be used via the
[useatmos](https://github.com/NN-OpenSource/useatmos) package, but can
also be applied manually by pressing the “Use this template” button.

Note, that when the new repository is first created an intial workflow
starts which updates package specific files, and creates a PR for your
review and approval.

## Standards

- Set licence to Apache licence version 2.0 with Novo Nordisk A/S as the
  copyright holder.
- Use a README.Rmd
- Use `testthat` for testing
- Use `pkgdown` to create a documentation webpage
- Setup `lintr` with default style

## GitHub actions

- Styling using [MegaLinter](https://megalinter.io/) (calls `lintr` for
  R scripts)
- R CMD Check. Both for CRAN version requirements, and for internal
  versions.
- Test coverage
- Pkgdown webpage hosted on GitHub pages. Pages for pull requests are
  also hosted under “{base-url}/dev/{PR-number}”.
