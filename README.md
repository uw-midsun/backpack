# `backpack`
This repository contains the packer configuration to build a base box for use with our [box](https://github.com/uw-midsun/box).

# ⚠️ NOTICE ⚠️
This repository is currently **experimental**. It hasn't been tested with utilities for working with firmware onsite.

## What is packer?
[Packer](https://www.packer.io/) is a program that takes in some configuration and outputs a machine image. This machine image can be loaded into virtualbox with [vagrant](https://www.vagrantup.com/). This toolchain of packer -> vagrant -> virtualbox allows us to provide a standardized development environment, regardless of host OS.

It works in three steps:
1. Execute builders. This is basically the initial ubuntu configuration, which is defined in the `builders` section of `backpack.json` and `http/preseed.cfg`. You'll (hopefully) never need to touch these.
2. Run provisioners. These are defined in the `provisioners` section of `backpack.json`. There are a number of provisioning tools you might see in industry or in job descriptions like [chef](https://www.chef.io/), [ansible](https://www.ansible.com/), and [puppet](https://puppet.com/). However, we opt for simple shell scripts to do the provisioning because they're easier to understand and update without learning new tools. These scripts live in `scripts`, and are probably the only things you'll need to touch in this repo.
3. Run post-processors. This is the `post-processors` section of `backpack.json`, and is what outputs the final vagrant-compatible image.

## Philosophy
Packer configuration is pretty complex already, so this repo is designed to make it as easy as possible to add to the "backpack". Keeping things in here makes for a more smooth onboarding and setup process for new team members. If adding extra functionality, make sure to add comments and keep things neat for future generations.

## Dependencies
In order to work with packer, you'll need:
- ruby
- packer
- virtualbox
However, in order to properly test and release, it's highly recommended you have the uwmidsun [box](https://github.com/uw-midsun/box) set up in order to properly test your changes.

## Adding functionality
First, set up a brand new [box](https://github.com/uw-midsun/box) to test your changes with. Run your installation commands as you would, but with `sudo`. As an example, if you wanted to add `foobar`:
```
sudo apt-get -y install foobar
```
After you've made sure `foobar` is working correctly, add the same commands to the appropriate setup script without the `sudo`, with a comment:
```
...
#Install foobar
apt-get -y install foobar
...
```
If you're adding significant steps, consider adding an additional setup script by adding its name to the `scripts` section of `backpack.json`, then creating the new script in the `scripts` directory.

Once you're happy with your changes, pack the new box with:
```
packer build backpack.json
```
This will take a really long time, potentially up to 20 minutes. The process may appear to be stuck at:
```
==> virtualbox-iso: Waiting for SSH to become available...
```
This is normal. Give it at least 10 minutes just at this step before deciding the run's a failure.

On success, something along the lines of the following should appear:
```
==> virtualbox-iso (vagrant): Creating Vagrant box for 'virtualbox' provider
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-ubuntu-18.04-amd64-disk001.vmdk
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-ubuntu-18.04-amd64.ovf
    virtualbox-iso (vagrant): Renaming the OVF to box.ovf...
    virtualbox-iso (vagrant): Compressing: Vagrantfile
    virtualbox-iso (vagrant): Compressing: box.ovf
    virtualbox-iso (vagrant): Compressing: metadata.json
    virtualbox-iso (vagrant): Compressing: packer-ubuntu-18.04-amd64-disk001.vmdk
Build 'virtualbox-iso' finished after 15 minutes 13 seconds.
```
This should be accompanied by the creation of the file `backpack.box` in this directory. Release this as a new version [here](https://github.com/uw-midsun/backpack/releases/new), bumping the minor or major version number as appropriate. Finally, open a PR to bump the backpack version in the [box](https://github.com/uw-midsun/box) repo by changing the line that looks something like:
```
config.vm.box_url = "https://github.com/uw-midsun/box/releases/download/v1.1.0/backpack.box"
```
