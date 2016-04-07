


> subscription-manager repos --enable rhel-server-rhscl-7-rpms

> subscription-manager repos --enable rhel-7-server-optional-rpms

> yum install devtoolset-3

to ~/.bashrc put

> source scl_source enable devtoolset-3
