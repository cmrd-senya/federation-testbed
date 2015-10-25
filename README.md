## Prepare
You must have a working diaspora installation! Check out the source code, cd to the source directory.
Run ```bundle install``` there.
```
$ git clone https://github.com/cmrd-senya/federation-testbed
$ cd federation-testbed
$ gem install bundler
$ bundle install
```

## Configuration
Configure the ```features/support/config.yml``` according to your testing environment.

You must have a user registered on your pod.

## Run
Launch tests with:
```
cucumber
```
