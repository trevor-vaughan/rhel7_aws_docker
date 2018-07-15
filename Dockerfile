# You will need to set DOCKER_REGISTRY='registry.access.redhat.com'
#
# If you want to save your container for future use, you use use the `docker
# commit` command
#   * docker commit <running container ID> el7_build
#   * docker run -it el7_build
#
FROM rhel7
ENV container docker

ADD assets/tmp/etc /etc
ADD assets/tmp/usr /usr

# Fix issues with overlayfs
#RUN yum clean all
RUN rm -f /var/lib/rpm/__db*
RUN yum clean all
RUN yum install -y yum-plugin-ovl || :
RUN yum install -y yum-utils

# This is meant to be a test/working image so this sets up some common apps and
# a 'build_user' account

# Commonly needed tools
RUN yum install -y git vim-enhanced sudo which jq
RUN yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# RPM Dev Tools
RUN yum install -y rpmdevtools rpm-sign

# Software Collections
RUN yum install -y scl-utils scl-utils-build

# Ensure that the 'build_user' can sudo to root for RVM
RUN echo 'Defaults:build_user !requiretty' >> /etc/sudoers
RUN echo 'build_user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -b /home -G wheel -m -c "Build User" -s /bin/bash -U build_user
RUN rm -rf /etc/security/limits.d/*.conf

# I do Ruby development, so go ahead and set up RVM
RUN runuser build_user -l -c "echo 'gem: --no-ri --no-rdoc' > .gemrc"
RUN runuser build_user -l -c "gpg2 --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
RUN runuser build_user -l -c "curl -sSL https://get.rvm.io | bash -s stable --ruby"
RUN runuser build_user -l -c "rvm all do gem install bundler"
RUN runuser build_user -l -c "rvm use default; gem install json"
RUN runuser build_user -l -c "rvm use default; gem install posix-spawn"

# But hey, maybe you like Python development

RUN yum install -y python2-bz2file
RUN runuser build_user -l -c "curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash"
RUN runuser build_user -l -c "echo 'export PATH=\"/home/build_user/.pyenv/bin:\$PATH\"' >> ~/.bash_profile"
RUN runuser build_user -l -c "echo 'eval \"\$(pyenv init -)\"' >> ~/.bash_profile"
RUN runuser build_user -l -c "echo 'eval \"\$(pyenv virtualenv-init -)\"' >> ~/.bash_profile"
RUN runuser build_user -l -c "git clone https://github.com/momo-lab/pyenv-install-latest.git \"\$(pyenv root)\"/plugins/pyenv-install-latest"
RUN runuser build_user -l -c "pyenv install-latest"

# Drop into a shell for building
CMD /bin/bash -c "su -l build_user"
