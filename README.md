#Introduction

Dockerfile to build a GitLab CI Runner with JDK, maven, git and openssh from sameersbn/gitlab-ci-runner base image.
Installed Java7, maven, git and openssh.
After run this image, you can login this runner by ssh using root, the password is 123456.

#Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the Docker Trusted Build service.

```bash
docker pull lemonbar/gitlab-runner-jdk-maven:latest
```

Starting from version 1.0, You can pull a particular version by specifying the version number. For example,

```bash
docker pull lemonbar/gitlab-runner-jdk-maven:1.0
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/lemonbar/docker-gitlab-runner-jdk-maven.git
cd docker-gitlab-runner-jdk-maven
docker build --tag="$USER/gitlab-runner-jdk-maven" .
```
# Quick Start
For a runner to do its trick, it has to first be registered/authorized on the GitLab CI server. This can be done by running the image with the **app:setup** command.

```bash
mkdir -p /opt/gitlab-runner-jdk-maven
docker run --name gitlab-runner-jdk-maven -it --rm \
	-v /opt/gitlab-runner-jdk-maven:/home/gitlab_ci_runner/data \
  lemonbar/gitlab-runner-jdk-maven:1.0 app:setup
```

The command will prompt you to specify the location of the GitLab CI server and provide the registration token to access the server. With this out of the way the image is ready, lets get is started.

```bash
docker run --name gitlab-runner-jdk-maven -P -d \
	-v /opt/gitlab-runner-jdk-maven:/home/gitlab_ci_runner/data \
	lemonbar/gitlab-runner-jdk-maven:1.0
```

You now have a runner up and running, you can logon this container by ssh.
The default password for root is 123456.

```bash
root/123456
```

# Configuration

## Data Store
GitLab CI Runner saves the configuration for connection and access to the GitLab CI server. In addition, SSH keys are generated as well. To make sure this configuration is not lost when when the container is stopped/deleted, we should mount a data store volume at

* /home/gitlab_ci_runner/data

Volumes can be mounted in docker by specifying the **'-v'** option in the docker run command.

```bash
mkdir /opt/gitlab-runner-jdk-maven
docker run --name gitlab-runner-jdk-maven -d -h gitlab-ci-runner.local.host \
  -v /opt/gitlab-runner-jdk-maven:/home/gitlab_ci_runner/data \
  lemonbar/gitlab-runner-jdk-maven:1.0
```

## Installing Trusted SSL Server Certificates
If your GitLab server is using self-signed SSL certificates then you should make sure the GitLab server certificate is trusted on the runner for the git clone operations to work.

The default path the runner is configured to look for the trusted SSL certificates is at /home/gitlab_ci_runner/data/certs/ca.crt, this can however be changed using the CA_CERTIFICATES_PATH configuration option.

If you remember from above, the /home/gitlab_ci_runner/data path is the path of the [data store](#data-store), which means that we have to create a folder named certs inside /opt/gitlab-runner-jdk-maven/ and add the ca.crt file into it.

The ca.crt file should contain the root certificates of all the servers you want to trust. With respect to GitLab, this will be the contents of the gitlab.crt file as described in the [README](https://github.com/sameersbn/docker-gitlab/blob/master/README.md#ssl) of the [docker-gitlab](https://github.com/sameersbn/docker-gitlab) container.

## Upgrading

To update the runner, simply stop the image and pull the latest version from the docker index.

```bash
docker pull lemonbar/gitlab-runner-jdk-maven:1.0
docker stop gitlab-runner-jdk-maven
docker rm gitlab-runner-jdk-maven
docker run --name gitlab-runner-jdk-maven -d [OPTIONS] lemonbar/gitlab-runner-jdk-maven:1.0
```
