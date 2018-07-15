# RHEL7 Docker on AWS

This is an example of a method for getting a RHEL7 Docker container to be able
to access the RHEL YUM repositories as made available by AWS.

**DO NOT RUN THIS ON A PRODUCTION SERVER**

This copies sensitive information out of the `/etc/pki` directory so you really
don't want to run this on anything important but it is a good way to make a
container that can be used for troubleshooting issues on RHEL in AWS.

## Instructions

1. Make sure you are on a RHEL7 AWS instance with a valid license
   * You can check to see if you have a valid license by running `curl
     http://169.254.169.254/latest/dynamic/instance-identity/document` and
     checking that the `billingProducts` field is not empty.

2. Make sure your account has `sudo` access to `root`
3. Edit the `Dockerfile` to meet your needs
4. Run `./build.sh`
5. Profit
