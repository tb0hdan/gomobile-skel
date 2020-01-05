# gomobile-skel
Gomobile skel tool - build mobile apps written in Go easier and faster


## Working with gomobile-skel

First run:

`make all domain=foo.com project=bar`


Next runs:

`make create project=baz`


Listing projects:

`make list-projects`


Building project:

`make build-project project=bar`

Building all projects:

`make build-all`

Linking all project dirs to GOPATH:

`make link-all`

Unlinking all project dirs from GOPATH:

`make unlink-all`
