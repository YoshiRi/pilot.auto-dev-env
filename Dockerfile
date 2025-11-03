FROM ros:humble

RUN apt-get update && apt-get install -y \
    python3-pip python3-vcstool git \
    colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/autoware/ws
RUN mkdir -p src

COPY repos/debug_tools.repos .

RUN vcs import src < debug_tools.repos

RUN apt-get update && rosdep install -y --from-paths src --ignore-src -r \
    && rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO=humble
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

CMD ["/bin/bash"]
