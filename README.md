## Prepare
You must have a working diaspora installation! Check out the source code, cd to the source directory.
Run "bundle install" there.

## Configuration
You must have a user registered on your pod.
Change "features/support/config.yml" so that it represents valid settings for your pod.
You could get a public/private keypair for a user by running following command in the Rails console.
```ruby
username = "test"                                                                    #=> set to your user's name
User.where(username: username)[0].serialized_private_key                             #=> will return private key
Person.where(guid: User.where(username: username)[0].guid)[0].serialized_public_key  #=> will return public key
```
The Rails console could be run with
```
bin/rails console
```

## Run
Launch tests with
```
cucumber
```
