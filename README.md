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

## Running the testbed on the same host with the target pod
If you want to run the testbed on the same host, where your Diaspora installation lives, you must perform additional actions.

Add the following lines to your ```/etc/hosts```:
```
127.0.0.1	testbed.local
127.0.0.1	pod.local
```

Install [boxcars](https://github.com/azer/boxcars) proxy.

Pick the following configuration and save it to ```proxy.json```:
```
{
  "testbed.local": "192.168.56.103:4567",
  "pod.local": "192.168.56.103:3000"
}
```

Launch the proxy with:
```
sudo gocode/bin/boxcars --port=80 proxy.json
```

After this actions, both Diaspora and the testbed will be accessible on the same machine and will be able to communicate with each other.

## Run
Launch tests with:
```
cucumber
```
